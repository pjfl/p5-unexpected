# @(#)Ident: 30functions.t 2013-11-27 11:18 pjf ;

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

sub EXCEPTION_CLASS { 'MyException' }

BEGIN {
   {  package MyException;

      use Moo;

      extends 'Unexpected';
      with    'Unexpected::TraitFor::ErrorLeader';
      with    'Unexpected::TraitFor::ExceptionClasses';

      my $class = __PACKAGE__;

      $class->has_exception( 'A' );
      $class->has_exception( 'B', [ 'A' ] );
      $class->has_exception( 'C', { parents => 'A' } );
      $class->has_exception( 'D', [ qw( A B ) ] );
      $class->has_exception( 'E', 'A' );

      $INC{ 'MyException.pm' } = __FILE__;
   }
}

use Unexpected::Functions;

use Unexpected::Functions qw( build_attr_from inflate_message );

ok( (main->can( 'build_attr_from' )), 'Imports build_attr_from' );
ok( (main->can( 'inflate_message' )), 'Imports inflate_message' );

done_testing;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
# vim: expandtab shiftwidth=3:
