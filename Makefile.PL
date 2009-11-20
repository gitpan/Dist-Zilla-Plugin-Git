
use strict;
use warnings;

 BEGIN { require 5.008; } 

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'Dist-Zilla-Plugin-Git',
  NAME      => 'Dist::Zilla::Plugin::Git',
  AUTHOR    => "Jerome\ Quelin",
  ABSTRACT  => "update\ your\ git\ repository\ after\ release",
  VERSION   => '1.093240',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "MooseX::Has::Sugar" => '0',
    "MooseX::Types::Moose" => '0',
    "English" => '0',
    "Git::Wrapper" => '0',
    "Dist::Zilla::Role::AfterRelease" => '0',
    "Symbol" => '0',
    "IPC::Open3" => '0',
    "Test::More" => '0',
    "File::Find" => '0',
    "File::Temp" => '0',
    "Dist::Zilla::Role::BeforeRelease" => '0',
    "File::Spec::Functions" => '0',
    "Moose" => '0',
    "Cwd" => '0',
  },
  test => {TESTS => 't/*.t'}
);

