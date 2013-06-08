# @(#)Ident: Types.pm 2013-06-07 00:05 pjf ;

package Unexpected::Types;

use namespace::clean -except => 'meta';
use version; our $VERSION = qv( sprintf '0.3.%d', q$Rev: 1 $ =~ /\d+/gmx );

use Class::Load  qw(load_class);
use English      qw(-no_match_vars);
use Scalar::Util qw(blessed);
use Type::Library  -base;
use Type::Tiny;
use Type::Utils;

BEGIN { extends q(Types::Standard) };

__PACKAGE__->meta->add_type( Type::Tiny->new
   (  name       => 'LoadableClass',
      constraint => sub {
         local  $EVAL_ERROR;
         eval { load_class( $_ ) };
         return $EVAL_ERROR ? 0 : 1 },
      message    => sub { "Attribute value ${_} is not a loadable class" }, ) );

__PACKAGE__->meta->add_type( Type::Tiny->new
   (  name       => 'NonEmptySimpleStr',
      constraint => sub {
         length $_ > 0 and length $_ < 255 and $_ !~ m{ \n }mx },
      message    => sub {
         "Attribute value ${_} is not a non empty simple string" }, ) );

__PACKAGE__->meta->add_type( Type::Tiny->new
   (  name       => 'NonZeroPositiveInt',
      constraint => sub { $_ =~ m{ \+?[0-9]+ }mx and $_ > 0 },
      message    => sub {
         "Attribute value ${_} is not a non zero positive integer" }, ) );

__PACKAGE__->meta->add_type( Type::Tiny->new
   (  name       => 'PositiveInt',
      constraint => sub { $_ =~ m{ \+?[0-9]+ }mx and $_ >= 0 },
      message    => sub {
         "Attribute value ${_} is not a positive integer" }, ) );

__PACKAGE__->meta->add_type( Type::Tiny->new
   (  name       => 'SimpleStr',
      constraint => sub { length $_ < 255 and $_ !~ m{ \n }mx },
      message    => sub { "Attribute value ${_} is not a simple string" }, ) );

__PACKAGE__->meta->add_type( Type::Tiny->new
   (  name       => 'Tracer',
      constraint => sub { $_->can( 'frames' ) },
      message    => sub {
         blessed $_ ? 'Object '.(blessed $_).' is missing a frames method'
                    : "Attribute value ${_} is not on object reference" }, ) );

1;

__END__

=pod

=encoding utf8

=head1 Name

Unexpected::Types - Defines type constraints

=head1 Synopsis

   use Unexpected::Types qw(ArrayRef SimplStr);

=head1 Version

This documents version v0.3.$Rev: 1 $ of L<Unexpected::Types>

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
