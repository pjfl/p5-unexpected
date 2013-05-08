# @(#)Ident: Unexpected.pm 2013-05-08 18:37 pjf ;

package Unexpected;

use namespace::autoclean;
use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 7 $ =~ /\d+/gmx );

use Moose;

extends q(Unexpected::Base);
with    q(Unexpected::TraitFor::Throwing);
with    q(Unexpected::TraitFor::TracingStacks);

sub BUILD {}

sub is_one_of_us {
   return $_[ 1 ] && blessed $_[ 1 ] && $_[ 1 ]->isa( __PACKAGE__ );
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding utf8

=head1 Name

Unexpected - Moose exception class composed from traits

=head1 Synopsis

   use File::DataClass::Functions qw(throw);
   use Try::Tiny;

   sub some_method {
      my $self = shift;

      try   { this_will_fail }
      catch { throw $_ };
   }

   # OR
   use Unexpected;

   sub some_method {
      my $self = shift;

      eval { this_will_fail };
      Unexpected->throw_on_error;
   }

   # THEN
   try   { $self->some_method() }
   catch { warn $_."\n\n".$_->stacktrace."\n" };

=head1 Version

This documents version v0.1.$Rev: 7 $ of L<Unexpected>

=head1 Description

An exception class that supports error messages with placeholders, a
L<Unexpected::TraitFor::Throwing/throw> method with
automatic re-throw upon detection of self, conditional throw if an
exception was caught and a simplified stacktrace

=head1 Configuration and Environment

Applies exception roles to the exception base class
L<Unexpected::Base>. See L</Dependencies> for the list of
roles that are applied

Error objects are overloaded to stringify to the full error message
plus a leader if the optional C<ErrorLeader> role has been applied

=head1 Subroutines/Methods

=head2 BUILD

Does nothing placeholder that allows the applied roles to modify it

=head2 is_one_of_us

   $bool = $class->is_one_of_us( $string_or_exception_object_ref );

Class method which detects instances of this exception class

=head1 Diagnostics

None

=head1 Dependencies

=over 3

=item L<namespace::autoclean>

=item L<Unexpected::Base>

=item L<Unexpected::TraitFor::ErrorLeader>

=item L<Unexpected::TraitFor::Throwing>

=item L<Unexpected::TraitFor::TracingStacks>

=item L<Moose>

=back

=head1 Incompatibilities

There are no known incompatibilities in this module

=head1 Bugs and Limitations

There are no known bugs in this module.
Please report problems to the address below.
Patches are welcome

=head1 Acknowledgements

Larry Wall - For the Perl programming language

L<Throwable::Error> - Lifted the stack frame filter from here

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
