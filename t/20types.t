# @(#)Ident: 20types.t 2013-06-17 17:19 pjf ;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 12 $ =~ /\d+/gmx );
use File::Spec::Functions   qw( catdir updir );
use FindBin                 qw( $Bin );
use lib                 catdir( $Bin, updir, q(lib) );

use Module::Build;
use Test::More;

my $reason;

BEGIN {
   my $builder = eval { Module::Build->current };

   $builder and $reason = $builder->notes->{stop_tests};
   $reason  and $reason =~ m{ \A TESTS: }mx and plan skip_all => $reason;
}

use English qw( -no_match_vars );

{  package MyNESS;

   use Moo;
   use Unexpected::Types qw( NonEmptySimpleStr );

   has 'test_ness'  => is => 'ro', isa => NonEmptySimpleStr, default => sub {};
}

my $myness; eval { $myness = MyNESS->new };

like $EVAL_ERROR, qr{ not \s+ a \s+ non }mx, 'Non empty simple str - undef';

eval { $myness = MyNESS->new( test_ness => '' ) };

like $EVAL_ERROR, qr{ not \s+ a \s+ non }mx, 'Non empty simple str - null';

eval { $myness = MyNESS->new( test_ness => "\n" ) };

like $EVAL_ERROR, qr{ not \s+ a \s+ non }mx, 'Non empty simple str - newline';

eval { $myness = MyNESS->new( test_ness => 'x' ) };

is $EVAL_ERROR, q(), 'Non empty simple str - passes';

{  package MyNZPI;

   use Moo;
   use Unexpected::Types qw( NonZeroPositiveInt );

   has 'test_nzpi'  => is => 'ro', isa => NonZeroPositiveInt, default => sub {};
}

my $mynzpi; eval { $mynzpi = MyNZPI->new };

like $EVAL_ERROR, qr{ not \s+ a \s+ non }mx, 'Non zero positive int - undef';

eval { $mynzpi = MyNZPI->new( test_nzpi => '' ) };

like $EVAL_ERROR, qr{ not \s+ a \s+ non }mx, 'Non zero positive int - null';

eval { $mynzpi = MyNZPI->new( test_nzpi => "0" ) };

like $EVAL_ERROR, qr{ not \s+ a \s+ non }mx, 'Non zero positive int - zero';

eval { $mynzpi = MyNZPI->new( test_nzpi => "-1" ) };

like $EVAL_ERROR, qr{ not \s+ a \s+ non }mx, 'Non zero positive int - negative';

eval { $mynzpi = MyNZPI->new( test_nzpi => '1' ) };

is $EVAL_ERROR, q(), 'Non zero positive int - passes';

{  package MyLoadableClass;

   use Moo;
   use Unexpected::Types qw( LoadableClass );

   has 'test_class' => is => 'ro', isa => LoadableClass,
      coerce        => LoadableClass->coercion;
}

my $mylc  = MyLoadableClass->new( test_class => 'Unexpected' );
my $trace = $mylc->test_class->new;

ok $trace->can( 'frames' ), 'Loadable class';

{  package MyTracer;

   use Moo;
   use Unexpected::Types qw( Tracer );

   has 'test_tracer'  => is => 'ro', isa => Tracer, default => sub {};
}

my $mytracer; eval { $mytracer = MyTracer->new };

like $EVAL_ERROR, qr{ not \s+ an \s+ object }mx, 'Tracer - undef';

eval { $mytracer = MyTracer->new( test_tracer => 'Unexpected' ) };

like $EVAL_ERROR, qr{ not \s+ an \s+ object }mx, 'Tracer - not an object ref';

{  package NoFrames;

   sub new { bless {}, __PACKAGE__ }
}

my $noframes = NoFrames->new;

eval { $mytracer = MyTracer->new( test_tracer => $noframes ) };

like $EVAL_ERROR, qr{ missing \s+ a \s+ frames }mx, 'Tracer - missing method';

eval { $mytracer = MyTracer->new( test_tracer => $trace ) };

is $EVAL_ERROR, q(), 'Tracer - passes';

done_testing;

#SKIP: {
#   $reason and $reason =~ m{ \A tests: }mx and skip $reason, 1;
#}

# Local Variables:
# mode: perl
# tab-width: 3
# End:
