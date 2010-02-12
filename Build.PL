
use strict;
use warnings;

use Module::Build 0.3601;

my %module_build_args = (
                       'dist_abstract' => 'update your git repository after release',
                       'dist_author' => [
                                          'Jerome Quelin'
                                        ],
                       'dist_name' => 'Dist-Zilla-Plugin-Git',
                       'script_files' => [],
                       'module_name' => 'Dist::Zilla::Plugin::Git',
                       'requires' => {
                                       'MooseX::Has::Sugar' => 0,
                                       'MooseX::Types::Moose' => 0,
                                       'Dist::Zilla::Role::PluginBundle' => 0,
                                       'Git::Wrapper' => 0,
                                       'Dist::Zilla::Role::AfterRelease' => 0,
                                       'File::Find' => 0,
                                       'Moose' => 0,
                                       'Test::Exception' => 0,
                                       'English' => 0,
                                       'Moose::Autobox' => 0,
                                       'perl' => '5.008',
                                       'Test::More' => 0,
                                       'File::Temp' => 0,
                                       'Dist::Zilla' => '1.093250',
                                       'Dist::Zilla::Role::BeforeRelease' => 0,
                                       'Path::Class' => 0,
                                       'String::Formatter' => 0,
                                       'Cwd' => 0
                                     },
                       'license' => 'perl'
                     );


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
