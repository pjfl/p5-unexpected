package t::boilerplate;

use strict;
use warnings;
use File::Spec::Functions qw( catdir updir );
use FindBin               qw( $Bin );
use lib               catdir( $Bin, updir, 'lib' ), catdir( $Bin, 'lib' );

use Module::Build;
use Sys::Hostname;

sub plan (;@) {
   $_[ 0 ] eq 'skip_all' and print '1..0 # SKIP '.$_[ 1 ]."\n" and exit 0;
}

my ($builder, $host, $notes, $perl_ver);

BEGIN {
   $host     = lc hostname;
   $builder  = eval { Module::Build->current };
   $notes    = $builder ? $builder->notes : {};
   $perl_ver = $notes->{min_perl_version} || 5.008;

   eval { require Test::Requires }; $@ and plan skip_all => 'No Test::Requires';

   $Bin =~ m{ : .+ : }mx and plan skip_all => 'Two colons in $Bin path';

   if ($notes->{testing}) {
      $host eq 'digitalis' and plan skip_all =>
         'Broken smoker a54c1c84-6bf5-1014-b4f9-dcd54300afcd';
   }
}

use Test::Requires "${perl_ver}";
use Test::Requires { version => 0.88 };

sub import {
   strict->import;
   $] < 5.008 ? warnings->import : warnings->import( NONFATAL => 'all' );
   return;
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
# vim: expandtab shiftwidth=3:
