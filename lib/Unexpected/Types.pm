# @(#)Ident: Types.pm 2013-06-16 18:33 pjf ;

package Unexpected::Types;

use strict;
use warnings;
use namespace::clean -except => 'meta';
use version; our $VERSION = qv( sprintf '0.3.%d', q$Rev: 11 $ =~ /\d+/gmx );

use Class::Load  qw( load_class );
use English      qw( -no_match_vars );
use Scalar::Util qw( blessed );
use Type::Library    -base;
use Type::Tiny;
use Type::Utils  qw( extends );

BEGIN { extends 'Types::Standard' };

$Type::Exception::CarpInternal{ 'Sub::Quote' }++;
$Type::Exception::CarpInternal{ 'Unexpected::TraitFor::Throwing' }++;

__PACKAGE__->meta->add_type( Type::Tiny->new
   (  name       => 'LoadableClass',
      constraint => sub { __constraint_for_loadable_class( $_ ) },
      message    => sub { __exception_message
         ( 'Attribute value [_1] is not a loadable class', $_ ) },
      parent     => Defined, ) );

__PACKAGE__->meta->add_type( Type::Tiny->new
   (  name       => 'NonEmptySimpleStr',
      constraint => sub {
         length $_ > 0 and length $_ < 255 and $_ !~ m{ \n }mx },
      message    => sub { __exception_message
         ( 'Attribute value [_1] is not a non empty simple string', $_ ) },
      parent     => Defined, ) );

__PACKAGE__->meta->add_type( Type::Tiny->new
   (  name       => 'NonZeroPositiveInt',
      constraint => sub { $_ =~ m{ \+?[0-9]+ }mx and $_ > 0 },
      message    => sub { __exception_message
         ( 'Attribute value [_1] is not a non zero positive integer', $_ ) },
      parent     => Defined, ) );

__PACKAGE__->meta->add_type( Type::Tiny->new
   (  name       => 'PositiveInt',
      constraint => sub { $_ =~ m{ \+?[0-9]+ }mx and $_ >= 0 },
      message    => sub { __exception_message
         ( 'Attribute value [_1] is not a positive integer', $_ ) },
      parent     => Defined, ) );

__PACKAGE__->meta->add_type( Type::Tiny->new
   (  name       => 'SimpleStr',
      constraint => sub { length $_ < 255 and $_ !~ m{ \n }mx },
      message    => sub { __exception_message
         ( 'Attribute value [_1] is not a simple string', $_ ) },
      parent     => Defined, ) );

__PACKAGE__->meta->add_type( Type::Tiny->new
   (  name       => 'Tracer',
      constraint => sub { $_->can( 'frames' ) },
      message    => sub { __exception_message_for_tracer( $_ ) },
      parent     => Object, ) );

# Private functions
sub __constraint_for_loadable_class {
   my $x = shift; my $class = ref $x eq 'CODE' ? $x->() : $x; local $EVAL_ERROR;

   eval { load_class( $class ) }; $EVAL_ERROR and warn "${EVAL_ERROR}\n";

   return $EVAL_ERROR ? 0 : 1;
}

sub __exception_message {
   my ($error, @args) = @_;

   my @vals = map { (length) ? $_ : '[]' }
              map { $_ // '[?]' } @args, map { '[?]' } 0 .. 9;

   $error =~ s{ \[ _ (\d+) \] }{$vals[ $1 - 1 ]}gmx;

   return $error;
}

sub __exception_message_for_object_reference {
   return __exception_message
      ( 'Attribute value [_1] is not an object reference', $_[ 0 ] );
}

sub __exception_message_for_tracer {
   blessed $_[ 0 ] and return __exception_message
      ( 'Object [_1] is missing a frames method', blessed $_[ 0 ] );

   return __exception_message_for_object_reference( $_[ 0 ] );
}

1;

__END__

=pod

=encoding utf8

=head1 Name

Unexpected::Types - Defines type constraints

=head1 Synopsis

   use Unexpected::Types qw(ArrayRef SimplStr);

=head1 Version

This documents version v0.3.$Rev: 11 $ of L<Unexpected::Types>

=head1 Description

Defines type constraints used throughout this distribution. The types defined
are replacements for those found in L<MooseX::Types::Common> and
L<MooseX::Types::LoadableClass> but based on L<Type::Tiny> rather than
L<MooseX::Types>

Extends L<Types::Standard> so you can import any TCs that module exports

=head1 Configuration and Environment

Defines the following type constraints;

=over 3

=item C<LoadableClass>

A classname that is loaded using L<Class::Load>

=item C<NonEmptySimpleStr>

A string of at least one character and no more than 255 characters that
contains no newlines

=item C<NonZeroPositiveInt>

A non zero positive integer

=item C<PositiveInt>

A positive integer including zero

=item C<SimpleStr>

A string of than 255 characters that contains no newlines

=item C<Tracer>

An object reference that implements the C<frames> method

=back

Defines no attributes

=head1 Subroutines/Methods

None

=head1 Diagnostics

None

=head1 Dependencies

=over 3

=item L<namespace::clean>

=item L<Class::Load>

=item L<Type::Tiny>

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

Copyright (c) 2013 Peter Flanigan. All rights reserved

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
