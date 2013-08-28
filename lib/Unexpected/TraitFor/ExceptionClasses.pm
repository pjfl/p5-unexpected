# @(#)Ident: ExceptionClasses.pm 2013-08-28 02:21 pjf ;

package Unexpected::TraitFor::ExceptionClasses;

use namespace::sweep;
use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 1 $ =~ /\d+/gmx );

use Unexpected::Functions   qw( inflate_message );
use Moo::Role;

my $Root    = 'Unexpected';
my $Classes = { $Root => {} };

has 'class' => is => 'ro', isa => sub {
   exists $Classes->{ $_[ 0 ] }
      or die inflate_message( 'Exception class [_1] does not exist',
                              $_[ 0 ] ) }, default => $Root;

sub has_exception {
   my ($self, $class, $args) = @_;

   defined $class or die 'Exception class undefined';

   exists $Classes->{ $class } and die inflate_message
      ( 'Exception class [_1] already exists', $class );

   $args //= {}; ref $args ne 'HASH' and $args = { parent => $args };

   my $parent = $args->{parent} //= $Root;

   exists $Classes->{ $parent } or die inflate_message
      ( "Exception class [_1] parent class ${parent} does not exist", $class );

   $Classes->{ $class } = $args;
   return;
}

sub instance_of {
   my ($self, $wanted) = @_; my $class = $self->class; $wanted or return 0;

   do    { $class eq $wanted and return 1 }
   while (defined ($class = $Classes->{ $class }->{parent}));

   return 0;
}

1;

__END__

=pod

=encoding utf8

=head1 Name

Unexpected::TraitFor::ExceptionClasses - One-line description of the modules purpose

=head1 Synopsis

   use Moo;

   with 'Unexpected::TraitFor::ExceptionClasses';

=head1 Version

This documents version v0.1.$Rev: 1 $ of L<Unexpected::TraitFor::ExceptionClasses>

=head1 Description

=head1 Configuration and Environment

Defines the following attributes;

=over 3

=item C<class>

Defaults to C<Unexpected>. Can be used to differentiate different
classes of error

=back

=head1 Subroutines/Methods

=head2 has_exception

=head2 instance_of

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
