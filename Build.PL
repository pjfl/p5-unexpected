# @(#)$Ident: Build.PL 2013-05-11 08:54 pjf ;

use strict;
use warnings;
use inc::Bob; # Module::Build subclass
use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 14 $ =~ /\d+/gmx );

Bob->new( {
   module    => q(Unexpected),
   home_page => q(http://www.roxsoft.co.uk),
   requires  => {
      'perl'                          => 5.01,
      'namespace::autoclean'          => 0.13,
      'Devel::StackTrace'             => 1.26,
      'Moose'                         => 2.0802,
      'MooseX::ClassAttribute'        => 0.27,
      'MooseX::Role::WithOverloading' => 0.13,
      'MooseX::Types'                 => 0.35,
      'MooseX::Types::Common'         => 0.001008,
      'MooseX::Types::LoadableClass'  => 0.008, },
   recommends          => {
      'App::cpanminus' => 1.6005, },
   configure_requires  => {
      'version'        => 0.88,
      'Module::Build'  => 0.4004, },
   build_requires      => {
      'version'        => 0.88,
      'Module::Build'  => 0.4004, },
} )->create_build_script; # Goal!

# Local Variables:
# mode: perl
# eval: (load-project-state "unexpected")
# tab-title: Unexpected
# tab-width: 3
# End:
