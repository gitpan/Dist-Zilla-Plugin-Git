
use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new(
  module_name   => 'Dist::Zilla::Plugin::Git',
  license       => 'perl',
  dist_abstract => "update\ your\ git\ repository\ after\ release",
  dist_name     => "Dist\-Zilla\-Plugin\-Git",
  dist_author   => [
"Jerome\ Quelin",
  ],
  requires      => {
    "MooseX::Has::Sugar" => '0',
    "MooseX::Types::Moose" => '0',
    "Dist::Zilla::Role::PluginBundle" => '0',
    "Git::Wrapper" => '0',
    "Dist::Zilla::Role::AfterRelease" => '0',
    "File::Find" => '0',
    "File::Path" => '0',
    "File::Spec::Functions" => '0',
    "Moose" => '0',
    "English" => '0',
    "Test::Exception" => '0',
    "ExtUtils::MakeMaker" => '0',
    "Moose::Autobox" => '0',
    "perl" => '5.008',
    "Test::More" => '0',
    "File::Temp" => '0',
    "Dist::Zilla" => '1.093250',
    "Dist::Zilla::Role::BeforeRelease" => '0',
    "String::Formatter" => '0',
    "Cwd" => '0',
  },
  script_files => [ qw() ],
);

$build->create_build_script;
