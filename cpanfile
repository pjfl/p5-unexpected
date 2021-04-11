requires "Devel::StackTrace" => "1.34";
requires "Exporter::Tiny" => "0.042";
requires "Module::Runtime" => "0.014";
requires "Moo" => "2.000001";
requires "Package::Stash" => "0.37";
requires "Ref::Util" => "0.203";
requires "Sub::Install" => "0.928";
requires "Type::Tiny" => "1.000002";
requires "namespace::autoclean" => "0.26";
requires "perl" => "5.010001";

on 'build' => sub {
  requires "Module::Build" => "0.4004";
  requires "version" => "0.88";
};

on 'test' => sub {
  requires "File::Spec" => "0";
  requires "Module::Build" => "0.4004";
  requires "Module::Metadata" => "0";
  requires "Sys::Hostname" => "0";
  requires "Test::Requires" => "0.08";
  requires "Try::Tiny" => "0.22";
  requires "strictures" => "1.005004";
  requires "version" => "0.88";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "Module::Build" => "0.4004";
  requires "version" => "0.88";
};
