
use strict;
use warnings;

use Module::Build 0.3601;

my %module_build_args = (
                       'dist_abstract' => 'update your git repository after release',
                       'script_files' => [],
                       'license' => 'perl',
                       'build_requires' => {
                                             'Test::More' => '0',
                                             'Test::Exception' => '0',
                                             'English' => '0',
                                             'File::Find' => '0',
                                             'Path::Class' => '0',
                                             'Module::Build' => '0.3601',
                                             'Dist::Zilla::Tester' => '0',
                                             'Cwd' => '0'
                                           },
                       'dist_name' => 'Dist-Zilla-Plugin-Git',
                       'dist_author' => [
                                          'Jerome Quelin'
                                        ],
                       'module_name' => 'Dist::Zilla::Plugin::Git',
                       'requires' => {
                                       'Moose::Role' => '0',
                                       'DateTime' => '0',
                                       'MooseX::Types::Moose' => '0',
                                       'MooseX::Has::Sugar' => '0',
                                       'Dist::Zilla::Role::PluginBundle' => '0',
                                       'Class::MOP' => '0',
                                       'Git::Wrapper' => '0',
                                       'Dist::Zilla::Role::AfterRelease' => '0',
                                       'Moose::Autobox' => '0',
                                       'perl' => '5.008',
                                       'File::Temp' => '0',
                                       'Dist::Zilla' => '1.100660',
                                       'Dist::Zilla::Role::BeforeRelease' => '0',
                                       'String::Formatter' => '0',
                                       'Moose' => '0'
                                     },
                       'configure_requires' => {
                                                 'Module::Build' => '0.3601'
                                               },
                       'dist_version' => '1.100960'
                     );


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
