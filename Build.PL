
use strict;
use warnings;

use Module::Build 0.3601;

my %module_build_args = (
                       'dist_abstract' => 'update your git repository after release',
                       'script_files' => [],
                       'license' => 'perl',
                       'build_requires' => {
                                             'Scalar::Util' => '0',
                                             'Test::Exception' => '0',
                                             'English' => '0',
                                             'Dist::Zilla::Tester' => '0',
                                             'Carp' => '0',
                                             'Test::More' => '0.88',
                                             'File::Find' => '0',
                                             'Path::Class' => '0',
                                             'Module::Build' => '0.3601'
                                           },
                       'dist_name' => 'Dist-Zilla-Plugin-Git',
                       'dist_author' => [
                                          'Jerome Quelin'
                                        ],
                       'module_name' => 'Dist::Zilla::Plugin::Git',
                       'requires' => {
                                       'DateTime' => '0',
                                       'MooseX::Types::Moose' => '0',
                                       'MooseX::Has::Sugar' => '0',
                                       'Dist::Zilla::Role::PluginBundle' => '0',
                                       'Class::MOP' => '0',
                                       'Git::Wrapper' => '0',
                                       'Dist::Zilla::Role::AfterRelease' => '0',
                                       'Dist::Zilla::Role::AfterBuild' => '0',
                                       'Moose' => '0',
                                       'Moose::Role' => '0',
                                       'Moose::Autobox' => '0',
                                       'perl' => '5.008',
                                       'File::Temp' => '0',
                                       'Dist::Zilla' => '2.100880',
                                       'Dist::Zilla::Role::BeforeRelease' => '0',
                                       'String::Formatter' => '0',
                                       'Cwd' => '0'
                                     },
                       'recommends' => {},
                       'configure_requires' => {
                                                 'Module::Build' => '0.3601'
                                               },
                       'dist_version' => '1.101230'
                     );


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
