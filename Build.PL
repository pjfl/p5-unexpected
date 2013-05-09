# @(#)$Ident: Build.PL 2013-05-09 13:43 pjf ;

use strict;
use warnings;
use inc::Bob; # Module::Build subclass
use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 10 $ =~ /\d+/gmx );

Bob->new( {
   module    => q(Unexpected),
   home_page => q(http://www.roxsoft.co.uk),
   requires  => {
      'perl'                          => 5.010,
      'namespace::autoclean'          => 0.13,
      'overload'                      => 1.07,
      'version'                       => 0.88,
      'Carp'                          => 0,
      'Devel::StackTrace'             => 1.26,
      'List::Util'                    => 1.27,
      'Moose'                         => 2.0802,
      'MooseX::ClassAttribute'        => 0.27,
      'MooseX::Role::WithOverloading' => 0.13,
      'MooseX::Types'                 => 0.35,
      'MooseX::Types::Common'         => 0.001008,
      'MooseX::Types::LoadableClass'  => 0.008,
      'Scalar::Util'                  => 1.27, },
   configure_requires => {
      'version'       => 0.77,
      'Module::Build' => 0.38, },
   build_requires     => {
      'Test::More'    => 0.74, },
} )->create_build_script; # Goal!

# Local Variables:
# mode: perl
# eval: (load-project-state "unexpected")
# tab-title: Unexpected
# tab-width: 3
# End:
