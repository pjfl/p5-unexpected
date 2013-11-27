# @(#)Ident: 20types.t 2013-11-27 12:12 pjf ;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.16.%d', q$Rev: 1 $ =~ /\d+/gmx );
use File::Spec::Functions   qw( catdir updir );
use FindBin                 qw( $Bin );
use lib                 catdir( $Bin, updir, 'lib' );

use Module::Build;
use Test::More;

my $notes = {}; my $perl_ver;

BEGIN {
   my $builder = eval { Module::Build->current };
      $builder and $notes = $builder->notes;
      $perl_ver = $notes->{min_perl_version} || 5.008;
}

use Test::Requires "${perl_ver}";
use Test::Requires { Moo => 1.002 };
use English qw( -no_match_vars );
use Unexpected;

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

{  package MyNNSS;

   use Moo;
   use Unexpected::Types qw( NonNumericSimpleStr );

   has 'test_nnss'  => is => 'ro', isa => NonNumericSimpleStr,
   default          => sub {};
}

my $mynnss; eval { $mynnss = MyNNSS->new };

like $EVAL_ERROR, qr{ not \s+ a \s+ non }mx, 'Non numeric simple str - undef';

eval { $mynnss = MyNNSS->new( test_nnss => 1 ) };

like $EVAL_ERROR, qr{ not \s+ a \s+ non }mx, 'Non numeric simple str - numeric';

eval { $mynnss = MyNNSS->new( test_nnss => '' ) };

is $EVAL_ERROR, q(), 'Non numeric simple str - null passes';

eval { $mynnss = MyNNSS->new( test_nnss => 'fred' ) };

is $EVAL_ERROR, q(), 'Non numeric simple str - string passes';

{  package MyLoadableClass;

   use Moo;
   use Unexpected::Types qw( LoadableClass );

   has 'test_class' => is => 'ro', isa => LoadableClass,
      coerce        => LoadableClass->coercion;
}

my $mylc  = MyLoadableClass->new( test_class => 'Unexpected' );
my $trace = $mylc->test_class->new;

ok $trace->can( 'frames' ), 'Loadable class';

eval { MyLoadableClass->new( test_class => 'Not::Bloody::Likely' ) };

my $e = Unexpected->caught;

like $e, qr{ not \s+ a \s+ loadable }mx, 'Unloadable class';

eval { MyLoadableClass->new( test_class => '------' ) };

$e = Unexpected->caught;

like $e, qr{ not \s+ a \s+ loadable }mx, 'Invalid class name';

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

# Local Variables:
# mode: perl
# tab-width: 3
# End:
