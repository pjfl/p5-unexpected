# @(#)Ident: Functions.pm 2013-06-30 23:03 pjf ;

package Unexpected::Functions;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.6.%d', q$Rev: 1 $ =~ /\d+/gmx );
use parent 'Exporter::TypeTiny';

our @EXPORT = qw( build_attr_from inflate_message );

# Public functions
sub build_attr_from { # Coerce a hash ref from whatever was passed
   return ($_[ 0 ] && ref $_[ 0 ] eq q(HASH)) ? { %{ $_[ 0 ] } }
        : (   @_ % 2 == 0 && defined $_[ 1 ]) ? { @_ }
        : (                  defined $_[ 0 ]) ? { error => @_ }
                                              : {};
}

sub inflate_message { # Expand positional parameters of the form [_<n>]
   my $msg = shift; my @args = __inflate_placeholders( \@_ );

   $msg =~ s{ \[ _ (\d+) \] }{$args[ $1 - 1 ]}gmx; return $msg;
}

# Private functions
sub __inflate_placeholders { # Substitute visible strings for null and undef
   return map { (length) ? $_ : '[]' }
          map { $_ // '[?]'          } @{ $_[ 0 ] },
          map { '[?]'                } 0 .. 9;
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

This documents version v0.6.$Rev: 1 $ of L<Unexpected::Functions>

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

=head1 Diagnostics

None

=head1 Dependencies

=over 3

=item L<Exporter::TypeTiny>

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
