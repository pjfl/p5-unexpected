# @(#)Ident: Unexpected.pm 2013-08-28 22:42 pjf ;

package Unexpected;

use 5.010001;
use namespace::sweep;
use overload '""' => 'as_string', fallback => 1;
use version; our $VERSION = qv( sprintf '0.12.%d', q$Rev: 1 $ =~ /\d+/gmx );

use Moo;
use Scalar::Util qw( blessed );

with q(Unexpected::TraitFor::StringifyingError);
with q(Unexpected::TraitFor::Throwing);
with q(Unexpected::TraitFor::TracingStacks);

sub BUILD {} # Can be modified by the applied traits

sub is_one_of_us {
   return $_[ 1 ] && blessed $_[ 1 ] && $_[ 1 ]->isa( __PACKAGE__ );
}

1;

__END__

=pod

=encoding utf8

=head1 Name

Unexpected - Exception class composed from traits

=head1 Synopsis

   package YourApp::Exception;

   use Moo;

   extends 'Unexpected';
   with    'Unexpected::TraitFor::ErrorLeader';

   __PACKAGE__->ignore_class( 'YourApp::IgnoreMe' );

   has '+class' => default => __PACKAGE__;

   package YourApp;

   use YourApp::Exception;
   use Try::Tiny;

   sub some_method {
      my $self = shift;

      try   { this_will_fail }
      catch { YourApp::Exception->throw $_ };
   }

   # OR

   sub some_method {
      my $self = shift;

      eval { this_will_fail };
      YourApp::Exception->throw_on_error;
   }

   # THEN
   try   { $self->some_method() }
   catch { warn $_->message };

=head1 Version

This documents version v0.12.$Rev: 1 $ of L<Unexpected>

=head1 Description

An exception class that supports error messages with placeholders, a
L<throw|Unexpected::TraitFor::Throwing/throw> method with automatic
re-throw upon detection of self, conditional throw if an exception was
caught and a simplified stack trace in addition to the error message
with full stack trace

=head1 Configuration and Environment

Applies exception roles to the exception base class L<Unexpected>. See
L</Dependencies> for the list of roles that are applied

Error objects are overloaded to stringify to the full error message
plus a leader if the optional C<ErrorLeader> role has been applied

=head1 Subroutines/Methods

=head2 BUILDARGS

Customizes the constructor. Accepts either a coderef, an object ref,
a hashref, a scalar, or a list of key / value pairs

=head2 BUILD

Does nothing placeholder that allows the applied roles to modify it

=head2 is_one_of_us

   $bool = $class->is_one_of_us( $string_or_exception_object_ref );

Class method which detects instances of this exception class

=head1 Diagnostics

String overload is performed in this class as opposed to the stringify
error role since overloading is not supported in L<Moo::Role>

=head1 Dependencies

=over 3

=item L<namespace::sweep>

=item L<overload>

=item L<Moo>

=item L<Unexpected::TraitFor::Exception::Classes>

=item L<Unexpected::TraitFor::StringifyingError>

=item L<Unexpected::TraitFor::Throwing>

=item L<Unexpected::TraitFor::TracingStacks>

=back

=head1 Incompatibilities

There are no known incompatibilities in this module

=head1 Bugs and Limitations

L<Throwable> did not let me use the stack trace filter directly, it's wrapped
inside an attribute constructor. There was nothing else in L<Throwable>
that would not have been overridden

There are no known bugs in this module.  Please report problems to
http://rt.cpan.org/NoAuth/Bugs.html?Dist=Unexpected. Patches
are welcome

=head1 Acknowledgements

Larry Wall - For the Perl programming language

L<Throwable::Error> - Lifted the stack frame filter from here

John Sargent - Came up with the package name

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
