# @(#)Ident: Types.pm 2013-07-14 15:34 pjf ;

package Unexpected::Types;

use strict;
use warnings;
use namespace::clean -except => 'meta';
use version; our $VERSION = qv( sprintf '0.6.%d', q$Rev: 1 $ =~ /\d+/gmx );

use Class::Load             qw( load_class );
use English                 qw( -no_match_vars );
use Scalar::Util            qw( blessed );
use Type::Library               -base, -declare =>
                            qw( LoadableClass NonEmptySimpleStr
                                NonNumericSimpleStr NonZeroPositiveInt
                                PositiveInt SimpleStr Tracer );
use Type::Utils             qw( as coerce extends from
                                inline_as message subtype via where );
use Unexpected::Functions   qw( inflate_message );

BEGIN { extends 'Types::Standard' };

$Type::Exception::CarpInternal{ 'Sub::Quote' }++;
$Type::Exception::CarpInternal{ 'Unexpected::TraitFor::Throwing' }++;

subtype NonEmptySimpleStr, as Str,
   inline_as {
      $_[ 0 ]->parent->inline_check( $_ )
         ." and length $_ > 0 and length $_ < 255 and $_ !~ m{ [\\n] }mx" },
   message   {
      inflate_message
         ( 'Attribute value [_1] is not a non empty simple string', $_ ) },
   where     { length $_ > 0 and length $_ < 255 and $_ !~ m{ [\n] }mx };

subtype NonZeroPositiveInt, as Int,
   inline_as { $_[ 0 ]->parent->inline_check( $_ )." and $_ > 0" },
   message   {
      inflate_message
         ( 'Attribute value [_1] is not a non zero positive integer', $_ ) },
   where     { $_ > 0 };

subtype PositiveInt, as Int,
   inline_as { $_[ 0 ]->parent->inline_check( $_ )." and $_ >= 0" },
   message   { inflate_message
                  ( 'Attribute value [_1] is not a positive integer', $_ ) },
   where     { $_ >= 0 };

subtype SimpleStr, as Str,
   inline_as { $_[ 0 ]->parent->inline_check( $_ )
                  ." and length $_ < 255 and $_ !~ m{ [\\n] }mx" },
   message   { inflate_message
                  ( 'Attribute value [_1] is not a simple string', $_ ) },
   where     { length $_ < 255 and $_ !~ m{ [\n] }mx };

subtype Tracer, as Object,
   inline_as { $_[ 0 ]->parent->inline_check( $_ )." and $_->can( 'frames' )" },
   message   { __exception_message_for_tracer( $_ ) },
   where     { $_->can( 'frames' ) };


subtype LoadableClass, as NonEmptySimpleStr,
   message   { inflate_message( 'String [_1] is not a loadable class', $_ ) },
   where     { __constraint_for_loadable_class( $_ ) };

subtype NonNumericSimpleStr, as SimpleStr,
   inline_as { $_[ 0 ]->parent->inline_check( $_ )." and $_ !~ m{ \\d+ }mx" },
   message   {
      inflate_message
         ( 'Attribute value [_1] is not a non numeric simple string', $_ ) },
   where     { $_ !~ m{ \d+ }mx };

# Private functions
sub __constraint_for_loadable_class {
   my $x = shift; my $class = ref $x eq 'CODE' ? $x->() : $x; local $EVAL_ERROR;

   eval { load_class( $class ) }; $EVAL_ERROR and warn "${EVAL_ERROR}\n";

   return $EVAL_ERROR ? 0 : 1;
}

sub __exception_message_for_object_reference {
   return inflate_message( 'String [_1] is not an object reference', $_[ 0 ] );
}

sub __exception_message_for_tracer {
   blessed $_[ 0 ] and return inflate_message
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

This documents version v0.6.$Rev: 1 $ of L<Unexpected::Types>

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
