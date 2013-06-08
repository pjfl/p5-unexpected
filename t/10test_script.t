# @(#)Ident: 10test_script.t 2013-06-06 00:59 pjf ;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.3.%d', q$Rev: 1 $ =~ /\d+/gmx );
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

{  package MyException;

   use Moo;

   extends 'Unexpected';
   with    'Unexpected::TraitFor::ErrorLeader';

   1;
}

use English qw(-no_match_vars);

sub _eval_error () { my $e = $EVAL_ERROR; $EVAL_ERROR = undef; return $e }

my $class = 'MyException'; my $e = _eval_error;

is $class->ignore->[ 0 ], undef, 'No initial ignore class';

ok $class->ignore_class( 'IgnoreMe' ), 'Set ignore class';

is $class->ignore->[ 0 ], 'IgnoreMe', 'Get ignore class';

eval { $class->throw_on_error };

ok ! _eval_error, 'No throw without error';

eval { eval { die 'In a pit of fire' }; $class->throw_on_error };

like _eval_error, qr{ In \s a \s pit \s of \s fire }mx , 'Throws on error';

eval { $class->throw( 'PracticeKill' ) }; $e = _eval_error;

is ref $e, $class, 'Good class'; my $min_level = $e->level;

like $e, qr{ \A main \[ \d+ / $min_level \] }mx, 'Package and default level';
like $e, qr{ PracticeKill \s* \z   }mx, 'Throws error message';
is $e->class, 'Unexpected', 'Default error classification';

my ($line1, $line2, $line3);

sub test_throw { $class->throw( 'PracticeKill' ) }; $line1 = __LINE__;

sub test_throw1 { test_throw() }; $line2 = __LINE__;

eval { test_throw1() }; $line3 = __LINE__; $e = _eval_error;

my @lines = $e->stacktrace;

like $e, qr{ \A main \[ $line2 / \d+ \] }mx, 'Package and line number';
is $lines[ 0 ], "main::test_throw line ${line1}", 'Stactrace line 1';
is $lines[ 1 ], "main::test_throw1 line ${line2}", 'Stactrace line 2';
is $lines[ 2 ], "main line ${line3}", 'Stactrace line 3';

my $level = $min_level + 1;

sub test_throw2 { $class->throw( error => 'PracticeKill', level => $level ) };

sub test_throw3 { test_throw2() }

sub test_throw4 { test_throw3() }; $line1 = __LINE__;

eval { test_throw4() }; $e = _eval_error;

like $e, qr{ \A main \[ $line1 / $level \] }mx, 'Specific leader level';

$line1 = __LINE__; eval {
   $class->throw( args  => [ 'flap' ],
                  class => 'nonDefault',
                  error => 'cat: [_1] cannot open: [_2]', ) }; $e = _eval_error;

is $e->class, 'nonDefault', 'Specific error classification';
like $e, qr{ main\[ $line1 / \d+ \]:\scat:\sflap\scannot\sopen:\s\[\?\] }mx,
   'Placeholer substitution';

$line1 = __LINE__; eval {
   $class->throw( args  => [ 'flap' ],
                  class => 'testPrevious',
                  error => 'cat: [_1] cannot open: [_2]', ) }; $e = _eval_error;

is $e->class, 'testPrevious', 'Current exception classification';
is $e->previous_exception->class, 'nonDefault', 'Previous exception';

done_testing;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
