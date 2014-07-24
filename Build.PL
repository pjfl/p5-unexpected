use strict;
use warnings;

use Module::Build 0.4004;

sub testing { $ENV{AUTOMATED_TESTING} || $ENV{PERL_CPAN_REPORTER_CONFIG}
                                      || $ENV{PERL5_CPANPLUS_IS_VERSION} }
sub whimper { print {*STDOUT} $_[ 0 ]."\n"; exit 0 }

my $perl_ver = 5.010001;
my $name     = 'Unexpected'; $name =~ s{ - }{::}gmx;
my $paths    = {};
my $prereqs  = {
  'build_requires' => {
    'Module::Build' => '0.4004',
    'Test::Requires' => '0.06',
    'Try::Tiny' => '0.18',
    'version' => '0.88'
  },
  'configure_requires' => {
    'Module::Build' => '0.4004',
    'version' => '0.88'
  },
  'requires' => {
    'Devel::StackTrace' => '1.34',
    'Exporter::Tiny' => '0.038',
    'Module::Runtime' => '0.014',
    'Moo' => '1.005000',
    'Package::Stash' => '0.36',
    'Sub::Install' => '0.928',
    'Type::Tiny' => '0.046',
    'namespace::autoclean' => '0.19',
    'namespace::clean' => '0.25',
    'perl' => '5.010001'
  },
};

if ($] < $perl_ver) { # Not interested in reports below min perl ver
   testing or whimper "Minimum required Perl version is ${perl_ver}";
   $prereqs->{build_requires} = { %{ $prereqs->{configure_requires} } };
   $prereqs->{build_requires}->{ 'Test::Requires' } = 0.06;
   delete $prereqs->{requires};
}

# 20ba3f5a-f94d-11e3-82c2-bc3ea1235623
testing and $paths->{install_path} = { bindoc => 'none', libdoc => 'none' };

Module::Build->new(
   'module_name' => $name,
   'notes'       => { min_perl_version => $perl_ver },
   %{ $paths },
   %{ $prereqs },

)->create_build_script;

exit 0;
