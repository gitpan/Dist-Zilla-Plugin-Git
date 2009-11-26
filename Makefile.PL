
use strict;
use warnings;

 BEGIN { require 5.008; } 

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'Dist-Zilla-Plugin-Git',
  NAME      => 'Dist::Zilla::Plugin::Git',
  AUTHOR    => "Jerome\ Quelin",
  ABSTRACT  => "update\ your\ git\ repository\ after\ release",
  VERSION   => '1.093300',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
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
    "Moose::Autobox" => '0',
    "Test::More" => '0',
    "File::Temp" => '0',
    "Dist::Zilla" => '1.093250',
    "Dist::Zilla::Role::BeforeRelease" => '0',
    "String::Formatter" => '0',
    "Cwd" => '0',
  },
  test => {TESTS => 't/*.t'}
);

