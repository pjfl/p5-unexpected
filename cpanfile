requires "Devel::StackTrace" => "1.34";
requires "Exporter::Tiny" => "0.038";
requires "Module::Runtime" => "0.014";
requires "Moo" => "1.005000";
requires "Package::Stash" => "0.36";
requires "Sub::Install" => "0.928";
requires "Type::Tiny" => ">= 0.042, != 0.44";
requires "namespace::autoclean" => "0.19";
requires "namespace::clean" => "0.25";
requires "perl" => "5.010001";

on 'build' => sub {
  requires "Module::Build" => "0.4004";
  requires "Test::Requires" => "0.06";
  requires "Try::Tiny" => "0.18";
  requires "version" => "0.88";
};

on 'configure' => sub {
  requires "Module::Build" => "0.4004";
  requires "version" => "0.88";
};
