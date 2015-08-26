package t::boilerplate;

use strict;
use warnings;
use File::Spec::Functions qw( catdir updir );
use FindBin               qw( $Bin );
use lib               catdir( $Bin, updir, 'lib' ), catdir( $Bin, 'lib' );

use Test::More;
use Test::Requires { version => 0.88 };
use Module::Build;
use Sys::Hostname;

my ($builder, $host, $notes, $perl_ver);

BEGIN {
   $host     = lc hostname;
   $builder  = eval { Module::Build->current };
   $notes    = $builder ? $builder->notes : {};
   $perl_ver = $notes->{min_perl_version} || 5.008;

   if ($notes->{testing}) {
      $Bin =~ m{ : .+ : }mx and
         plan skip_all => 'Two colons in $Bin path';
      $host eq 'digitalis'  and
         plan skip_all => 'Broken smoker a54c1c84-6bf5-1014-b4f9-dcd54300afcd';
      # TODO: Remove this when service is restored
      plan skip_all => 'CPAN Testing down Aug 2015';
   }
}

use Test::Requires "${perl_ver}";

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
