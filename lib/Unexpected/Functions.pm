# @(#)Ident: Functions.pm 2013-10-21 14:38 pjf ;

package Unexpected::Functions;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.14.%d', q$Rev: 2 $ =~ /\d+/gmx );
use parent                  qw( Exporter::Tiny );

our @EXPORT_OK = qw( build_attr_from inflate_message );

my $Should_Quote = 1;

# Package methods
sub quote_inflated_messages {
   defined $_[ 1 ] and $Should_Quote = $_[ 1 ]; return $Should_Quote;
}

# Public functions
sub build_attr_from { # Coerce a hash ref from whatever was passed
   return ($_[ 0 ] && ref $_[ 0 ] eq 'HASH') ? { %{ $_[ 0 ] } }
        : (  @_ % 2 == 0 && defined $_[ 1 ]) ? { @_ }
        : (                 defined $_[ 0 ]) ? { error => @_ }
                                             : {};
}

sub inflate_message { # Expand positional parameters of the form [_<n>]
   my $msg = shift; my @args = __inflate_placeholders( @_ );

   $msg =~ s{ \[ _ (\d+) \] }{$args[ $1 - 1 ]}gmx; return $msg;
}

# Private functions
sub __inflate_placeholders { # Substitute visible strings for null and undef
   return map { __quote_maybe( (length) ? $_ : '[]' ) }
          map { $_ // '[?]' } @_,
          map { '[?]'       } 0 .. 9;
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

=head1 Version

This documents version v0.14.$Rev: 2 $ of L<Unexpected::Functions>

=head1 Description

A collection of functions used in this distribution

=head1 Configuration and Environment

Defines no attributes

=head1 Subroutines/Methods

=head2 build_attr_from

   $hash_ref = build_attr_from( <whatever> );

Coerces a hash ref from whatever args are passed

=head2 inflate_message

   $message = inflate_message( $template, $arg1, $arg2, ... );

Substitute the placeholders in the C<$template> string (e.g. [_1])
with the corresponding argument

=head2 quote_inflated_messages

   $bool = Unexpected::Functions->quote_inflated_messages( $bool );

Accessor / mutator package method that toggles the state on quoting
the placeholder substitution values in C<inflate_message>. Defaults
to true

=head1 Diagnostics

None

=head1 Dependencies

=over 3

=item L<Exporter::Tiny>

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
