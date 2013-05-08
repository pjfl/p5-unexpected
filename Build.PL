# @(#)$Ident: Build.PL 2013-05-08 19:20 pjf ;

use strict;
use warnings;
use inc::Bob; # Module::Build subclass
use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 9 $ =~ /\d+/gmx );

Bob->new( {
   module    => q(Unexpected),
   home_page => q(http://www.roxsoft.co.uk),
   requires  => {
      'perl'                          => 5.010,
      'namespace::autoclean'          => 0.13,
      'overload'                      => 1.04,
      'version'                       => 0.77,
      'Carp'                          => 0,
      'List::Util'                    => 1.23,
      'Moose'                         => 2.0801,
      'MooseX::ClassAttribute'        => 0.27,
      'MooseX::Role::WithOverloading' => 0.13,
      'MooseX::Types'                 => 0.25,
      'MooseX::Types::Common'         => 0.001002,
      'MooseX::Types::LoadableClass'  => 0.007,
      'Scalar::Util'                  => 1.18, },
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
