# @(#)$Ident: Build.PL 2013-05-07 23:38 pjf ;

use strict;
use warnings;
use inc::Bob; # Module::Build subclass
use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 1 $ =~ /\d+/gmx );

Bob->new( {
   module    => q(Unexpected),
   home_page => q(http://www.roxsoft.co.uk),
   requires  => {
      'perl'             => 5.010,
      'version'          => 0.77,
      'Class::Usul'      => q(0.18.0),
      'File::DataClass'  => q(0.20.0),
   },
   recommends            => {
      'App::cpanminus'   => 1.6005,
      'Date::Format'     => 2.24,
      'Pod::Markdown'    => 1.322,
      'Module::Metadata' => 1.000011, },
   configure_requires    => {
      'version'          => 0.77,
      'Module::Build'    => 0.38, },
   build_requires        => {
      'Exception::Class' => 1.23,
      'Test::More'       => 0.74, },
} )->create_build_script; # Goal!

# Local Variables:
# mode: perl
# eval: (load-project-state "unexpected")
# tab-title: Unexpected
# tab-width: 3
# End:
