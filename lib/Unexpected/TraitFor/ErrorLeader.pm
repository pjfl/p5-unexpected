# @(#)Ident: ErrorLeader.pm 2013-08-23 22:08 pjf ;

package Unexpected::TraitFor::ErrorLeader;

use namespace::sweep;
use version; our $VERSION = qv( sprintf '0.12.%d', q$Rev: 1 $ =~ /\d+/gmx );

use List::Util        qw( first );
use Unexpected::Types qw( NonZeroPositiveInt SimpleStr );
use Moo::Role;

requires qw( as_string filtered_frames );

my $Ignore = [ 'Try::Tiny' ];

# Object attributes (public)
has 'leader' => is => 'lazy', isa => SimpleStr, init_arg => undef;

has 'level'  => is => 'ro',   isa => NonZeroPositiveInt, default => 1;

# Construction
around 'as_string' => sub {
   my ($orig, $self, @args) = @_; my $str = $orig->( $self, @args );

   return $str ? $self->leader.$str : $str;
};

# Public methods
sub ignore {
   return $Ignore;
}

sub ignore_class {
   shift; return push @{ $Ignore }, @_;
}

# Private methods
sub _build_leader {
   my $self = shift; my $level = $self->level; my $leader = q();

   my @frames = $self->filtered_frames; my ($line, $package);

   $level >= scalar @frames and $level = scalar @frames - 1;

   do {
      if ($frames[ $level ] and $package = $frames[ $level ]->package) {
         $line    = $frames[ $level ]->line;
         $leader  = $package; $leader =~ s{ :: }{-}gmx;
         $leader .= "[${line}/${level}]: "; $level++;
      }
      else { $leader = $package = q() }
   }
   while ($package and __is_member( $package, $self->ignore ));

   return $leader;
}

# Private functions
sub __is_member {
   my $wanted = shift; return (first { $_ eq $wanted } @{ $_[ 0 ] }) ? 1 : 0;
}

1;

__END__

=pod

=encoding utf8

=head1 Name

Unexpected::TraitFor::ErrorLeader - Prepends a leader to the exception

=head1 Synopsis

   package MyException;

   use Moo;

   extends 'Unexpected';
   with    'Unexpected::TraitFor::ErrorLeader';

=head1 Version

This documents version v0.12.$Rev: 1 $
of L<Unexpected::TraitFor::ErrorLeader>

=head1 Description

Prepends a one line stack summary to the exception error message

=head1 Configuration and Environment

Requires the C<as_string> method in the consuming class, as well as
C<filtered_frames> from the stack trace role

Defines the following attributes;

=over 3

=item C<leader>

Set to the package and line number where the error should be reported

=item C<level>

A positive integer which defaults to one. How many additional stack frames
to pop before calculating the C<leader> attribute

=back

Modifies C<as_string> in the consuming class. Prepends the C<leader>
attribute to the return value

=head1 Subroutines/Methods

=head2 ignore

   $array_ref = $self->ignore;

Read only accessor for the C<$Ignore> package scoped
variable. Defaults to an empty array ref

=head2 ignore_class

   Unexpected->ignore_class( $classname );

The C<$Ignore> package scoped variable is an array ref of methods
whose presence should be ignored by the error message leader. This
method pushes C<$classname> onto that array ref

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
