# @(#)$Ident: Build.PL 2013-06-25 21:36 pjf ;

use strict;
use warnings;
use inc::Bob; # Module::Build subclass
use version; our $VERSION = qv( sprintf '0.5.%d', q$Rev: 1 $ =~ /\d+/gmx );

Bob->new( {
   module    => q(Unexpected),
   home_page => q(http://www.roxsoft.co.uk),
   requires  => {
      'perl'              => 5.010001,
      'namespace::clean'  => 0.23,
      'namespace::sweep'  => 0.006,
      'Class::Load'       => 0.18,
      'Devel::StackTrace' => 1.26,
      'Moo'               => 1.002,
      'Type::Tiny'        => 0.012, },
   recommends             => {
      'App::cpanminus'    => 1.6005, },
   configure_requires     => {
      'version'           => 0.88,
      'Module::Build'     => 0.4004, },
   build_requires         => {
      'version'           => 0.88,
      'Module::Build'     => 0.4004,
      'Moo'               => 1.002, },
} )->create_build_script; # Goal!

# Local Variables:
# mode: perl
# eval: (load-project-state "unexpected")
# tab-title: Unexpected
# tab-width: 3
# End:
