# @(#)Ident: 08memory_leak.t 2013-05-08 15:14 pjf ;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.4.%d', q$Rev: 1 $ =~ /\d+/gmx );
use File::Spec::Functions   qw( catdir updir );
use FindBin                 qw( $Bin );
use lib                 catdir( $Bin, updir, q(lib) );

use English qw(-no_match_vars);
use Test::More;

BEGIN {
   $ENV{AUTHOR_TESTING}
      or plan skip_all => 'Memory leak test only for developers';
}

eval "use Test::Memory::Cycle";

$EVAL_ERROR
   and plan skip_all => 'Test::Memory::Cycle required but not installed';

$ENV{TEST_MEMORY}
   or  plan skip_all => 'Environment variable TEST_MEMORY not set';

{  package MyError;
   use Moo;
   extends 'Unexpected';
   with 'Unexpected::TraitFor::ErrorLeader';
}

eval { MyError->throw( 'the error' ) };

ok $EVAL_ERROR, 'Exception was thrown';

memory_cycle_ok( $EVAL_ERROR, 'Exception has no memory cycles' );

done_testing;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
