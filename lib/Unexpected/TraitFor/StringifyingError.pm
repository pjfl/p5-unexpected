# @(#)$Ident: StringifyingError.pm 2013-06-08 12:59 pjf ;

package Unexpected::TraitFor::StringifyingError;

use namespace::sweep;
use version; our $VERSION = qv( sprintf '0.3.%d', q$Rev: 1 $ =~ /\d+/gmx );

use Moo::Role;
use Unexpected::Types qw(ArrayRef Str);

# Object attributes (public)
has 'args'  => is => 'ro', isa => ArrayRef, default => sub { [] };

has 'error' => is => 'ro', isa => Str,      default => 'Unknown error';

# Construction
around 'BUILDARGS' => sub {
   my ($next, $self, @args) = @_; my $attr = __build_attr_from( @args );

   $attr->{error} and $attr->{error} .= q() and chomp $attr->{error};

   return $attr;
};

after 'BUILD' => sub { # Fixes 98c94be8-d01e-11e2-8bc5-3f0fbdbf7481 WTF?
   my $self = shift; $self->as_string; return;
};

# Public methods
sub as_string { # Expand positional parameters of the form [_<n>]
   my $self = shift; my $error = $self->error or return;

   0 > index $error, q([_) and return $error;

   my @args = map { $_ // '[?]' } @{ $self->args }, map { '[?]' } 0 .. 9;

   $error =~ s{ \[ _ (\d+) \] }{$args[ $1 - 1 ]}gmx;

   return $error;
}

sub message {
   my $self = shift; return $self."\n\n".$self->trace->as_string."\n";
}

# Private functions
sub __build_attr_from { # Coerce a hash ref from whatever was passed
   return ($_[ 0 ] && ref $_[ 0 ] eq q(HASH)) ? { %{ $_[ 0 ] } }
        :        (defined $_[ 1 ])            ? { @_ }
                                              : { error => $_[ 0 ] };
}

1;

__END__

=pod

=head1 Name

Unexpected::TraitFor::StringifyingError - Base role for exception handling

=head1 Version

This documents version v0.3.$Rev: 1 $ of
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
starting at one

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
