# @(#)Ident: 30functions.t 2013-12-05 19:31 pjf ;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.20.%d', q$Rev: 1 $ =~ /\d+/gmx );
use File::Spec::Functions   qw( catdir updir );
use FindBin                 qw( $Bin );
use lib                 catdir( $Bin, updir, 'lib' );

use Test::More;
use Test::Requires { version => 0.88 };
use Module::Build;

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

use Unexpected::Functions { into => 'main' };

use Unexpected::Functions qw( :all );

ok( (main->can( 'build_attr_from' )), 'Imports build_attr_from' );
ok( (main->can( 'inflate_message' )), 'Imports inflate_message' );

# Lifted from Class::Load
ok(  is_class_loaded( 'MyException' ), 'MyException is loaded' );
ok( !is_class_loaded( 'MyException::NOEXIST' ), 'Nonexistent class NOT loaded');

do {
   package MyException::ISA;
   our @ISA = 'MyException';
};

ok(  is_class_loaded( 'MyException::ISA' ), 'Defines \@ISA loaded' );

do {
   package MyException::ScalarISA;
   our $ISA = 'MyException';
};

ok( !is_class_loaded( 'MyException::ScalarISA' ), 'Defines $ISA not loaded' );

do {
   package MyException::UndefVers;
   our $VERSION;
};

ok( !is_class_loaded( 'MyException::UndefVers' ), 'Undef version not loaded' );

do {
   package MyException::UndefScalar;
   my $version; our $VERSION = \$version;
};

ok( !is_class_loaded( 'MyException::UndefScalar' ), 'Undef scalar not loaded' );

do {
   package MyException::DefScalar;
   my $version = 1; our $VERSION = \$version;
};

ok(  is_class_loaded( 'MyException::DefScalar' ), 'Defined scalar ref loaded' );

do {
   package MyException::VERSION;
   our $VERSION = '1.0';
};

ok(  is_class_loaded( 'MyException::VERSION' ), 'Defines $VERSION is loaded' );

do {
   package MyException::VersionObj;
   our $VERSION = version->new( 1 );
};

ok(  is_class_loaded( 'MyException::VersionObj' ), 'Version obj returns true' );

do {
   package MyException::WithMethod;
   sub foo { }
};

ok(  is_class_loaded( 'MyException::WithMethod' ), 'Defines a method loaded' );

do {
   package MyException::WithScalar;
   our $FOO = 1;
};

ok( !is_class_loaded( 'MyException::WithScalar' ), 'Defines scalar not loaded');

do {
   package MyException::Foo::Bar;
   sub bar {}
};

ok( !is_class_loaded( 'MyException::Foo' ), 'If Foo::Bar is loaded Foo is not');

do {
   package MyException::Quuxquux;
   sub quux {}
};

ok( !is_class_loaded( 'MyException::Quux' ),
    'Quuxquux does not imply the existence of Quux' );

do {
   package MyException::WithConstant;
   use constant PI => 3;
};

ok(  is_class_loaded( 'MyException::WithConstant' ),
     'Defining a constant means the class is loaded' );

do {
   package MyException::WithRefConstant;
   use constant PI => \3;
};

ok(  is_class_loaded( 'MyException::WithRefConstant' ),
     'Defining a constant as a reference means the class is loaded' );

do {
   package MyException::WithStub;
   sub foo;
};

ok(  is_class_loaded( 'MyException::WithStub' ),
     'Defining a stub means the class is loaded' );

do {
   package MyException::WithPrototypedStub;
   sub foo (&);
};

ok(  is_class_loaded( 'MyException::WithPrototypedStub' ),
     'Defining a stub with a prototype means the class is loaded' );

done_testing;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
# vim: expandtab shiftwidth=3:
