use strict;
use warnings;

use Module::Build ##{ $meta2{prereqs}->{configure}->{requires}->{'Module::Build'} ##};

sub testing { $ENV{AUTOMATED_TESTING} || $ENV{PERL_CPAN_REPORTER_CONFIG}
                                      || $ENV{PERL5_CPANPLUS_IS_VERSION} }
sub whimper { print {*STDOUT} $_[ 0 ]."\n"; exit 0 }

my $perl_ver = ##{ $meta2{prereqs}->{runtime}->{requires}->{perl} ##};
my $name     = '##{ $zilla->name ##}'; $name =~ s{ - }{::}gmx;
my $paths    = {};
my $prereqs  = {
##{ $plugin->get_prereqs( 1 ) ##}
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
##{ $plugin->get_default('share_dir') ##}
)->create_build_script;

exit 0;
