package t::boilerplate;

use strict;
use warnings;
use File::Spec::Functions qw( catdir updir );
use FindBin               qw( $Bin );
use lib               catdir( $Bin, updir, 'lib' ), catdir( $Bin, 'lib' );

use Test::Requires { version => 0.88 };
use Module::Build;

my $notes = {}; my $perl_ver;

BEGIN {
   my $builder = eval { Module::Build->current };
      $builder and $notes = $builder->notes;
      $perl_ver = $notes->{min_perl_version} || 5.008;
}

use Test::Requires "${perl_ver}";
use Test::More;

sub import {
   strict->import;
   $] < 5.008 ? warnings->import : warnings->import( NONFATAL => 'all' );
# 160dd1a2-1ebe-11e4-ae61-5739e0bfc7aa
# 494fe6de-2168-11e4-b0d1-f6bc4915a708
   my $ref = warnings->can( 'bits' );

   $ref or warn 'Broken installation of Perl / TAP';
   $ref or plan skip_all => 'Broken installation of Perl / TAP';

   return;
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
# vim: expandtab shiftwidth=3:
