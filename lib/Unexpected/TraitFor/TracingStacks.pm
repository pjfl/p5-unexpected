package Unexpected::TraitFor::TracingStacks;

use namespace::autoclean;

use Unexpected::Types qw( HashRef LoadableClass Tracer );
use Scalar::Util      qw( weaken );
use Moo::Role;

requires qw( BUILD );

# Object attributes (public)
has 'trace' =>
   is       => 'lazy',
   isa      => Tracer,
   builder  => sub {
      my $self = shift;

      return $self->trace_class->new(%{$self->trace_args});
   },
   handles  => [ qw(frames) ],
   init_arg => undef;

has 'trace_args'    =>
   is      => 'lazy',
   isa     => HashRef,
   builder => sub {
      my $self = shift;

      return {
         filter_frames_early => 1,
         no_refs             => 1,
         respect_overload    => 0,
         max_arg_length      => 0,
         frame_filter        => $self->trace_frame_filter,
      };
   };

has 'trace_class' =>
   is      => 'ro',
   isa     => LoadableClass,
   default => 'Devel::StackTrace';

# Construction
before 'BUILD' => sub {
   my $self = shift;

   $self->trace;
   return;
};

# Public methods
sub message { # Stringify self and a full stack trace
   my $self = shift;

   return "${self}\n".$self->trace->as_string."\n";
}

sub stacktrace {
   my ($self, $skip) = @_;

   my (@lines, %seen, $subr);

   for my $frame (reverse $self->frames) {
      my $package = $frame->package;
      my $l_no;

      unless ($l_no = $seen{$package} and $l_no == $frame->line) {
         my $lead = $subr || $package; # uncoverable condition false

         # uncoverable branch false
         push @lines, join q( ), $lead, 'line', $frame->line
            if $lead !~ m{ (?: \A \(eval\) )|(?: ::try)|(?: :: __ANON__ \z) }mx;

         $seen{$package} = $frame->line;
      }

      # uncoverable branch false
      $subr = $frame->subroutine if $frame->subroutine !~ m{ :: __ANON__ \z }mx;
   }

   $skip = 0 unless defined $skip;

   pop @lines while ($skip--);

   return wantarray ? reverse @lines : (join "\n", reverse @lines)."\n";
}

sub trace_frame_filter { # Lifted from StackTrace::Auto
   my $self       = shift; weaken($self);
   my $found_mark = 0;

   return sub {
      my ($raw)    = @_;
      my  $subr    = $raw->{caller}->[3];
     (my  $package = $subr) =~ s{ :: \w+ \z }{}mx;

      # uncoverable branch true
      # uncoverable condition right
      warn "${subr}\n" if $ENV{UNEXPECTED_SHOW_RAW_TRACE};

      if    ($found_mark == 2) { return 1 }
      elsif ($found_mark == 1) {
         # uncoverable branch true
         # uncoverable condition right
         return 0 if $subr =~ m{ :: new \z }mx && $self->isa($package);

         $found_mark++;
         return 1;
      }

      # uncoverable condition right
      $found_mark++ if $subr =~ m{ :: new \z }mx && $self->isa($package);
      return 0;
   }
}

1;

__END__

=pod

=encoding utf-8

=head1 Name

Unexpected::TraitFor::TracingStacks - Provides a minimalist stacktrace

=head1 Synopsis

   use Moo;

   with 'Unexpected::TraitFor::TracingStacks';

=head1 Description

Provides a minimalist stacktrace

=head1 Configuration and Environment

Modifies C<BUILD> in the consuming class. Forces the instantiation of
the C<trace> attribute

Defines the following attributes;

=over 3

=item C<trace>

An instance of the C<trace_class>

=item C<trace_args>

A hash ref of arguments passed the C<trace_class> constructor when the
C<trace> attribute is instantiated

=item C<trace_class>

A loadable class which defaults to L<Devel::StackTrace>

=back

=head1 Subroutines/Methods

=head2 message

   $error_text_and_stack_trace = $self->message;

Returns the stringified object and a full stack trace

=head2 stacktrace

   $lines = $self->stacktrace( $num_frames_to_skip );

Returns a minimalist stack trace. Defaults to skipping zero frames
from the stack

=head2 trace_frame_filter

Lifted from L<StackTrace::Auto> this method filters out frames from the
raw stacktrace that are not of interest. It is very clever

=head1 Diagnostics

None

=head1 Dependencies

=over 3

=item L<namespace::autoclean>

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

Copyright (c) 2021 Peter Flanigan. All rights reserved

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
