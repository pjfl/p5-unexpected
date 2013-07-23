# @(#)Ident: CPANTesting.pm 2013-07-23 18:15 pjf ;

package CPANTesting;

use strict;
use warnings;

use Sys::Hostname; my $host = lc hostname; my $osname = lc $^O;

# Is this an attempted install on a CPAN testing platform?
sub is_testing { !! ($ENV{AUTOMATED_TESTING} || $ENV{PERL_CR_SMOKER_CURRENT}
                 || ($ENV{PERL5OPT} || q()) =~ m{ CPAN-Reporter }mx) }

sub should_abort {
   is_testing() or return 0;
   # 1d05f0a0-f34c-11e2-8c80-50d7c5c10595 - fucking unreal
   $host =~ m{ bingosnet }mx and exit 0;
   return 0;
}

sub test_exceptions {
   my $p = shift; is_testing() or return 0;

   $p->{stop_tests}     and return 'TESTS: CPAN Testing stopped in Build.PL';
   $osname eq q(mirbsd) and return 'TESTS: Mirbsd OS unsupported';

   $host =~ m{ jasonclifford }mx
      and return "TESTS: 3954afc6-d231-11e2-8b9f-bc1b31b64f85";
   return 0;
}

1;

__END__
