# @(#)Ident: Throwing.pm 2013-08-23 19:48 pjf ;

package Unexpected::TraitFor::Throwing;

use namespace::sweep;
use version; our $VERSION = qv( sprintf '0.12.%d', q$Rev: 1 $ =~ /\d+/gmx );

use Carp                      ( );
use English                 qw( -no_match_vars );
use Scalar::Util            qw( blessed );
use Unexpected::Functions   qw( build_attr_from );
use Unexpected::Types       qw( Maybe Object );
use Moo::Role;

requires qw( BUILD is_one_of_us );

my %Cache;

# Lifted from Throwable
has 'previous_exception' => is => 'ro', isa => Maybe[Object],
   default               => sub { $Cache{ __cache_key() } };

# Construction
after 'BUILD' => sub {
   my $self = shift; $self->_cache_exception; return;
};

# Public methods
sub caught {
   my ($self, @args) = @_; $self->_is_object_ref( @args ) and return $self;

   my $attr  = build_attr_from( @args );
   my $error = $attr->{error} ||= $EVAL_ERROR; $error or return;

   return $self->is_one_of_us( $error ) ? $error : $self->new( $attr );
}

sub throw {
   my ($self, @args) = @_;

   $self->_is_object_ref( @args )    and die $self;
   $self->is_one_of_us( $args[ 0 ] ) and die $args[ 0 ];
                                         die $self->new( @args );
}

sub throw_on_error {
   my $e; $e = shift->caught( @_ ) and die $e; return;
}

# Private methods
sub _cache_exception {
   my $self = shift; my $e = bless { %{ $self } }, blessed $self;

   delete $e->{previous_exception}; $Cache{ __cache_key() } = $e;

   return;
}

sub _is_object_ref {
   my ($self, @args) = @_; blessed $self or return 0;

   scalar @args and Carp::confess
      'Trying to throw an Exception object with arguments';
   return 1;
}

# Private functions
sub __cache_key {
   return $PID.'-'.(exists $INC{ 'threads.pm' } ? threads->tid() : 0);
}

1;

__END__

=pod

=encoding utf8

=head1 Name

Unexpected::TraitFor::Throwing - Detects and throws exceptions

=head1 Synopsis

   use Moo;

   with 'Unexpected::TraitFor::Throwing';

=head1 Version

This documents version v0.12.$Rev: 1 $ of
L<Unexpected::TraitFor::Throwing>

=head1 Description

Detects and throws exceptions

=head1 Configuration and Environment

Modifies C<BUILD> in the consuming class. Caches the new exception for
use by the C<previous_exception> attribute in the next exception thrown

Requires the consuming class to have the class method C<is_one_of_us>

Defines the following list of attributes;

=over 3

=item C<previous_exception>

May hold a reference to the previous exception in this thread

=back

=head1 Subroutines/Methods

=head2 caught

   $self = $class->caught( [ @args ] );

Catches and returns a thrown exception or generates a new exception if
C<$EVAL_ERROR> has been set. Returns either an exception object or undef

=head2 throw

   $class->throw error => 'Path [_1] not found', args => [ 'pathname' ];

Create (or re-throw) an exception. If the passed parameter is a
blessed reference it is re-thrown. If a single scalar is passed it is
taken to be an error message, a new exception is created with all
other parameters taking their default values. If more than one
parameter is passed the it is treated as a list and used to
instantiate the new exception. The 'error' parameter must be provided
in this case

=head2 throw_on_error

   $class->throw_on_error( [ @args ] );

Calls L</caught> passing in the options C<@args> and if there was an
exception L</throw>s it

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
