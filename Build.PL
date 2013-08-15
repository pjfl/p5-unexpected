# @(#)$Ident: Build.PL 2013-07-13 10:19 pjf ;

use strict;
use warnings;
use inc::Bob; # Module::Build subclass
use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 3 $ =~ /\d+/gmx );

Bob->new( {
   module    => '[% project %]',
   home_page => '[% home_page %]',
   requires  => {
      'perl'           => [% perl %],
      'Class::Usul'    => q(0.22.0),
   },
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
# eval: (load-project-state "[% appdir %]")
# tab-title: [% project %]
# tab-width: 3
# End:
