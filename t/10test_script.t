# @(#)Ident: 10test_script.t 2013-08-23 23:51 pjf ;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.8.%d', q$Rev: 2 $ =~ /\d+/gmx );
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

{  package MyException;

   use Moo;

   extends 'Unexpected';
   with    'Unexpected::TraitFor::ErrorLeader';

   1;
}

use English      qw( -no_match_vars );
use Scalar::Util qw( blessed refaddr );

sub _eval_error () { my $e = $EVAL_ERROR; $EVAL_ERROR = undef; return $e }

my $class = 'MyException'; my $e = _eval_error;

is $class->ignore->[ 0 ], 'Try::Tiny', 'No initial ignore class';

ok $class->ignore_class( 'IgnoreMe' ), 'Set ignore class';

is $class->ignore->[ 1 ], 'IgnoreMe', 'Get ignore class';

eval { $class->throw_on_error };

ok ! _eval_error, 'No throw without error';

eval { eval { die 'In a pit of fire' }; $class->throw_on_error };

like _eval_error, qr{ In \s a \s pit \s of \s fire }mx , 'Throws on error';

eval { $class->throw( 'PracticeKill' ) }; $e = _eval_error;

can_ok $e, 'message';

like $e->message, qr{ PracticeKill }mx, 'Message contains known string';

is ref $e, $class, 'Good class'; my $min_level = $e->level;

like $e, qr{ \A main \[ \d+ / $min_level \] }mx, 'Package and default level';

like $e, qr{ PracticeKill \s* \z   }mx, 'Throws error message';

is $e->class, 'Unexpected', 'Default error classification';

my $addr = refaddr $e;

is refaddr $e->caught(), $addr, 'Catches self';

is refaddr $class->caught( $e ), $addr, 'Catches own objects';

eval { $e->throw() }; $e = _eval_error;

is refaddr $e, $addr, 'Throws self';

eval { $class->throw( $e ) }; $e = _eval_error;

is refaddr $e, $addr, 'Throws own objects';

eval { $e->throw( 'Not allowed' ) }; $e = _eval_error;

like $e, qr{ object \s+ with \s+ arguments }mx, 'No throwing objects with args';

eval { $class->throw() }; $e = _eval_error;

like $e, qr{ Unknown \s+ error }mx, 'Default error string';

eval { $class->throw( error => sub { 'Test firing' } ) }; $e = _eval_error;

like $e, qr{ Test \s+ firing }mx, 'Derefernces coderef as error string';

eval { $class->throw( args => {} ) }; $e = _eval_error;

like $e, qr{ not \s+ pass \s+ type \s+ constraint }mx, 'Attribute type error';

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

sub test_throw2 { $class->throw( 'PracticeKill', level => $level ) };

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

$class->ignore_class( 'main' );

eval { $class->throw( 'PracticeKill' ) }; $e = _eval_error;

is $e->leader, q(), 'No leader';

done_testing;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
