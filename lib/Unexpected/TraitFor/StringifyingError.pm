# @(#)$Ident: StringifyingError.pm 2013-08-02 19:53 pjf ;

package Unexpected::TraitFor::StringifyingError;

use namespace::sweep;
use version; our $VERSION = qv( sprintf '0.5.%d', q$Rev: 8 $ =~ /\d+/gmx );

use Unexpected::Functions   qw( build_attr_from inflate_message );
use Unexpected::Types       qw( ArrayRef Str );
use Moo::Role;

# Object attributes (public)
has 'args'  => is => 'ro', isa => ArrayRef, default => sub { [] };

has 'error' => is => 'ro', isa => Str,      default => 'Unknown error';

# Construction
around 'BUILDARGS' => sub {
   my ($orig, $self, @args) = @_;

   my $attr = build_attr_from( @args ); my $e = delete $attr->{error};

   $e and ref $e eq 'CODE' and $e = $e->( $self, $attr );
   $e and $e .= q() and chomp $e;
   $e and $attr->{error} = $e;
   return $attr;
};

after 'BUILD' => sub {
   # Fixes 98c94be8-d01e-11e2-8bc5-3f0fbdbf7481 WTF? Stringify fails.
   # Bug only happens when Moose class inherits from Moo class which
   # uses overload string. Moose class inherits from Moose class which
   # has consumed a ::Role::WithOverloading works. Moo inherits from
   # Moo also works
   my $self = shift; $self->as_string; return;
};

# Public methods
sub as_string { # Stringifies the error and inflates the placeholders
   my $self = shift; my $error = $self->error; defined $error or return;

   0 > index $error, '[_' and return $error."\n";

   return inflate_message( $error, @{ $self->args } )."\n";
}

sub message { # Stringify self and a full stack trace
   my $self = shift; return $self."\n".$self->trace->as_string."\n";
}

1;

__END__

=pod

=head1 Name

Unexpected::TraitFor::StringifyingError - Base role for exception handling

=head1 Version

This documents version v0.5.$Rev: 8 $ of
L<Unexpected::TraitFor::StringifyingError>

=head1 Synopsis

   use Moo;

   with 'Unexpected::TraitFor::StringifyingError';

=head1 Description

Base role for exception handling

=head1 Configuration and Environment

Defines the following list of read only attributes;

=over 3

=item C<args>

An array ref of parameters substituted in for the placeholders in the
error message when the error is localised

=item C<error>

The actual error message which defaults to C<Unknown error>. Can contain
placeholders of the form C<< [_<n>] >> where C<< <n> >> is an integer
starting at one. If passed a code ref it will be called passing in the
calling classname and constructor hash ref, the return value will be
used as the error string

=back

=head1 Subroutines/Methods

=head2 as_string

   $error_text = $self->as_string;

This is what the object stringifies to

=head2 message

   $error_text_and_stack_trace = $self->message;

Returns the stringified object and a full stack trace

=head2 __build_attr_from

   $hash_ref = __build_attr_from( @args );

Function that coerces a hash ref from whatever is passed to it

=head1 Diagnostics

None

=head1 Dependencies

=over 3

=item L<namespace::sweep>

=item L<Moo::Role>

=item L<Unexpected::Types>

=back

=head1 Incompatibilities

There are no known incompatibilities in this module

=head1 Bugs and Limitations

There are no known bugs in this module.
Please report problems to the address below.
Patches are welcome

=head1 Author

Peter Flanigan C<< <pjfl@cpan.org> >>

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
