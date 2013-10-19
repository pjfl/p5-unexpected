# @(#)Ident: ExceptionClasses.pm 2013-09-27 12:23 pjf ;

package Unexpected::TraitFor::ExceptionClasses;

use namespace::sweep;
use version; our $VERSION = qv( sprintf '0.14.%d', q$Rev: 1 $ =~ /\d+/gmx );

use Unexpected::Functions   qw( inflate_message );
use Moo::Role;

my $Root = 'Unexpected'; my $Classes = { $Root => {} };

has 'class' => is => 'ro', isa => sub {
   ($_[ 0 ] and exists $Classes->{ $_[ 0 ] }) or die inflate_message
      ( 'Exception class "[_1]" does not exist', $_[ 0 ] ) }, default => $Root;

sub has_exception {
   my ($self, @args) = @_; my $i = 0;

   defined $args[ 0 ] or die 'Exception class undefined';

   while (defined (my $class = $args[ $i++ ])) {
      exists $Classes->{ $class } and
         die "Exception class ${class} already exists";

      my $args = $args[ $i++ ] // {};

      ref $args ne 'HASH' and $args = { parents => $args };

      my $parents = $args->{parents} //= [ $Root ];

      ref $parents ne 'ARRAY' and $parents = $args->{parents} = [ $parents ];

      for my $parent (@{ $parents }) {
         exists $Classes->{ $parent } or die
            "Exception class ${class} parent class ${parent} does not exist";
      }

      $Classes->{ $class } = $args;
   }

   return;
}

sub instance_of {
   my ($self, $wanted) = @_; $wanted or return 0;

   exists $Classes->{ $wanted }
      or die "Exception class ${wanted} does not exist";

   my @classes = ( $self->class );

   while (defined (my $class = shift @classes)) {
      $class eq $wanted and return 1;
      exists $Classes->{ $class }->{parents}
         and push @classes, @{ $Classes->{ $class }->{parents} };
   }

   return 0;
}

1;

__END__

=pod

=encoding utf8

=head1 Name

Unexpected::TraitFor::ExceptionClasses - Define an exception class hierarchy

=head1 Synopsis

   package YourExceptionClass;

   use Moo;

   extends 'Unexpected';

   __PACKAGE__->has_exception( 'A' );
   __PACKAGE__->has_exception( 'B', { parents => 'A' } );
   __PACKAGE__->has_exception( 'C', 'A' ); # same but shorter
   __PACKAGE__->has_exception( 'D', [ 'B', 'C' ] ); # diamond pattern

   # Then elsewhere
   __PACKAGE__->throw( 'error message', { class => 'C' } );

   # Elsewhere still
   my $e = __PACKAGE__->caught;

   $e->class eq 'C'; # true
   $e->instance_of( 'A' ); # true
   $e->instance_of( 'B' ); # false
   $e->instance_of( 'C' ); # true
   $e->instance_of( 'D' ); # false

=head1 Version

This documents version v0.14.$Rev: 1 $
of L<Unexpected::TraitFor::ExceptionClasses>

=head1 Description

Allows for the creation of an exception class hierarchy. Exception
classes inherit from one or more existing classes, ultimately all
classes inherit from the C<Unexpected> exception class

=head1 Configuration and Environment

Defines the following attributes;

=over 3

=item C<class>

Defaults to C<Unexpected>. Can be used to differentiate different
classes of error. Non default values for this attribute must have been
defined with a call to L</has_exception> otherwise an exception will
be thrown. Oh the irony

=back

=head1 Subroutines/Methods

=head2 has_exception

   Unexpected->has_exception( 'new_classname', [ 'parent1', 'parent2' ] );

Defines a new exception class. Parent classes must already exist. Default
parent class is C<Unexpected>;

=head2 instance_of

   $bool = $exception_obj->instance_of( 'exception_classname' );

Is the exception object an instance of the exception class

=head1 Diagnostics

None

=head1 Dependencies

=over 3

=item L<Moo::Role>

=back

=head1 Incompatibilities

There are no known incompatibilities in this module

=head1 Bugs and Limitations

There are no known bugs in this module. Please report problems to
http://rt.cpan.org/NoAuth/Bugs.html?Dist=Unexpected.
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
