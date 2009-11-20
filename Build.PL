
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
    "Git::Wrapper" => '0',
    "Dist::Zilla::Role::AfterRelease" => '0',
    "Symbol" => '0',
    "IPC::Open3" => '0',
    "File::Find" => '0',
    "File::Spec::Functions" => '0',
    "Moose" => '0',
    "English" => '0',
    "ExtUtils::MakeMaker" => '0',
    "Test::More" => '0',
    "perl" => '5.008',
    "File::Temp" => '0',
    "Dist::Zilla::Role::BeforeRelease" => '0',
    "Cwd" => '0',
  },
  script_files => [ qw() ],
);

$build->create_build_script;
