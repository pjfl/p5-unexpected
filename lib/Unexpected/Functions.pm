package Unexpected::Functions;

use strict;
use warnings;
use parent 'Exporter::Tiny';

use Carp         qw( croak );
use Package::Stash;
use Scalar::Util qw( blessed reftype );
use Sub::Install qw( install_sub );

our @EXPORT_OK = qw( build_attr_from catch_class has_exception inflate_message
                     is_class_loaded );

my $Should_Quote = 1;

# Package methods
sub import {
   my $class       = shift;
   my $global_opts = { $_[ 0 ] && ref $_[ 0 ] eq 'HASH' ? %{+ shift } : () };
   my $ex_class    = delete $global_opts->{exception_class};
   # uncoverable condition false
   my $target      = $global_opts->{into} ||= caller;
   my $ex_subr     = $target->can( 'EXCEPTION_CLASS' );
   my @want        = @_;
   my @args        = ();

   $ex_subr and $ex_class = $ex_subr->();

   for my $sym (@want) {
      if ($ex_class and $ex_class->can( 'is_exception' )
                    and $ex_class->is_exception( $sym )) {
         install_sub { as => $sym, code => sub { $sym }, into => $target, };
      }
      else { push @args, $sym }
   }

   $class->SUPER::import( $global_opts, @args );
   return;
}

sub quote_bind_values {
   defined $_[ 1 ] and $Should_Quote = !!$_[ 1 ]; return $Should_Quote;
}

# Public functions
sub build_attr_from (;@) { # Coerce a hash ref from whatever was passed
   return ($_[ 0 ] && ref $_[ 0 ] eq 'HASH') ? { %{ $_[ 0 ] } }
        : ($_[ 1 ] && ref $_[ 1 ] eq 'HASH') ? { error => $_[ 0 ], %{ $_[ 1 ] }}
        : (  @_ % 2 == 0 && defined $_[ 1 ]) ? { @_ }
        : (                 defined $_[ 0 ]) ? { error => @_ }
                                             : {};
}

sub catch_class ($@) {
   my $checker = __gen_checker( @{+ shift }, '*' => sub { die $_[ 0 ] } );

   wantarray or croak 'Useless bare catch_class()';

   return __catch( sub { ($checker->( $_[ 0 ] ) || return)->( $_[ 0 ] ) }, @_ );
}

sub has_exception ($;@) {
   my ($name, %args) = @_; my $exception_class = caller;

   return $exception_class->add_exception( $name, \%args );
}

sub inflate_message ($;@) { # Expand positional parameters of the form [_<n>]
   my $msg = shift; my @args = __inflate_placeholders( @_ );

   $msg =~ s{ \[ _ (\d+) \] }{$args[ $1 - 1 ]}gmx; return $msg;
}

sub is_class_loaded ($) { # Lifted from Class::Load
   my $class = shift; my $stash = Package::Stash->new( $class );

   if ($stash->has_symbol( '$VERSION' )) {
      my $version = ${ $stash->get_symbol( '$VERSION' ) };

      if (defined $version) {
         not ref $version and return 1;
         # Sometimes $VERSION ends up as a reference to undef (weird)
         ref $version and reftype $version eq 'SCALAR'
            and defined ${ $version } and return 1;
         blessed $version and return 1; # A version object
      }
   }

   $stash->has_symbol( '@ISA' ) and @{ $stash->get_symbol( '@ISA' ) }
      and return 1;
   # Check for any method
   return $stash->list_all_symbols( 'CODE' ) ? 1 : 0;
}

# Private functions
sub __catch {
   my $block = shift; return ((bless \$block, 'Try::Tiny::Catch'), @_);
}

sub __gen_checker {
   my @prototable = @_;

   return sub {
      my $x       = shift;
      my $ref     = ref $x;
      my $blessed = blessed $x;
      my $does    = ($blessed && $x->can( 'DOES' )) || 'isa';
      my @table   = @prototable;

      while (my ($key, $value) = splice @table, 0, 2) {
         __match_class( $x, $ref, $blessed, $does, $key ) and return $value
      }

      return;
   }
}

sub __inflate_placeholders { # Substitute visible strings for null and undef
   return map { __quote_maybe( (length) ? $_ : '[]' ) }
          map { $_ // '[?]' } @_,
          map {       '[?]' } 0 .. 9;
}

sub __match_class {
   my ($x, $ref, $blessed, $does, $key) = @_;

   return !defined $key                                       ? !defined $x
        : $key eq '*'                                         ? 1
        : $key eq ':str'                                      ? !$ref
        : $key eq $ref                                        ? 1
        : $blessed && $x->can( 'class' ) && $x->class eq $key ? 1
        : $blessed && $x->$does( $key )                       ? 1
                                                              : 0;
}

sub __quote_maybe {
   return $Should_Quote ? "'".$_[ 0 ]."'" : $_[ 0 ];
}

1;

__END__

=pod

=encoding utf8

=head1 Name

Unexpected::Functions - A collection of functions used in this distribution

=head1 Synopsis

   use Unexpected::Functions qw( build_attr_from );

=head1 Description

A collection of functions used in this distribution

Also exports any exceptions defined by the caller's C<EXCEPTION_CLASS>
as subroutines that return the subroutines name as a string. The calling
package can then throw exceptions with a class attribute that takes these
subroutines return values

=head1 Configuration and Environment

Defines no attributes

=head1 Subroutines/Methods

=head2 build_attr_from

   $hash_ref = build_attr_from( <whatever> );

Coerces a hash ref from whatever args are passed

=head2 catch_class

   use Try::Tiny;

   try         { die $exception_object }
   catch_class [ 'exception_class' => sub { # handle exception }, ... ],
   finally     { # always do this };

See L<Try::Tiny::ByClass>. Checks the exception object's C<class> attribute
against the list of exception class names passed to C<catch_class>. If there
is a match, call the subroutine provided to handle that exception. Re-throws
the exception if there is no match of if the exception object has no C<class>
attribute

=head2 has_exception

   has_exception 'exception_name' => parents => [ 'parent_exception' ],
      error => 'Error message for the exception with placeholders';

Calls L<Unexpected::TraitFor::ExceptionClasses/add_exception> via the
calling class which is assumed to inherit from a class that consumes
the L<Unexpected::TraitFor::ExceptionClasses> role

=head2 inflate_message

   $message = inflate_message( $template, $arg1, $arg2, ... );

Substitute the placeholders in the C<$template> string (e.g. [_1])
with the corresponding argument

=head2 is_class_loaded

   $bool = is_class_loaded $classname;

Returns true is the classname as already loaded and compiled

=head2 quote_bind_values

   $bool = Unexpected::Functions->quote_bind_values( $bool );

Accessor / mutator package method that toggles the state on quoting
the placeholder substitution values in C<inflate_message>. Defaults
to true

=head1 Diagnostics

None

=head1 Dependencies

=over 3

=item L<Exporter::Tiny>

=item L<Package::Stash>

=item L<Sub::Install>

=back

=head1 Incompatibilities

There are no known incompatibilities in this module

=head1 Bugs and Limitations

There are no known bugs in this module.
Please report problems to the address below.
Patches are welcome

=head1 Acknowledgements

Larry Wall - For the Perl programming language

=head1 Author

Peter Flanigan, C<< <pjfl@cpan.org> >>

=head1 License and Copyright

Copyright (c) 2014 Peter Flanigan. All rights reserved

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See L<perlartistic>

This program is distributed in the hope that it will be useful,
but WITHOUT WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE

=cut

# Local Variables:
# mode: perl
# tab-width: 3
# End:
