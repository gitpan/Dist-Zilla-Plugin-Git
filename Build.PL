#
# This file is part of Dist-Zilla-Plugin-Git
#
# This software is copyright (c) 2009 by Jerome Quelin.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#

use strict;
use warnings;

use Module::Build 0.3601;
use version 0.80 ();

my %module_build_args = (
  'dist_abstract' => 'update your git repository after release',
  'dist_author' => [
    'Jerome Quelin'
  ],
  'dist_name' => 'Dist-Zilla-Plugin-Git',
  'dist_version' => '2.020',
  'license' => 'perl',
  'module_name' => 'Dist::Zilla::Plugin::Git',
  'recursive_test_files' => 1,
  'build_requires' => {
    'Module::Build' => '0'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601',
    'version' => '0.80',
    'warnings' => '0'
  },
  'requires' => {
    'Cwd' => '0',
    'DateTime' => '0',
    'Dist::Zilla' => '4',
    'Dist::Zilla::Plugin::GatherDir' => '4.200016',
    'Dist::Zilla::Role::AfterBuild' => '0',
    'Dist::Zilla::Role::AfterMint' => '0',
    'Dist::Zilla::Role::AfterRelease' => '0',
    'Dist::Zilla::Role::BeforeRelease' => '0',
    'Dist::Zilla::Role::FilePruner' => '0',
    'Dist::Zilla::Role::GitConfig' => '0',
    'Dist::Zilla::Role::PluginBundle' => '0',
    'Dist::Zilla::Role::VersionProvider' => '0',
    'File::Spec' => '0',
    'File::Spec::Functions' => '0',
    'File::Temp' => '0',
    'File::chdir' => '0',
    'Git::Wrapper' => '0.021',
    'IPC::Open3' => '0',
    'IPC::System::Simple' => '0',
    'List::AllUtils' => '0',
    'List::Util' => '0',
    'Module::Runtime' => '0',
    'Moose' => '0',
    'Moose::Autobox' => '0',
    'Moose::Role' => '0',
    'Moose::Util::TypeConstraints' => '0',
    'MooseX::AttributeShortcuts' => '0',
    'MooseX::Has::Sugar' => '0',
    'MooseX::Types::Moose' => '0',
    'MooseX::Types::Path::Tiny' => '0',
    'Path::Tiny' => '0.048',
    'String::Formatter' => '0',
    'Try::Tiny' => '0',
    'Version::Next' => '0',
    'constant' => '0',
    'namespace::autoclean' => '0.09',
    'perl' => '5.010',
    'strict' => '0',
    'version' => '0.80',
    'warnings' => '0'
  },
  'test_requires' => {
    'Devel::SimpleTrace' => '0',
    'Dist::Zilla::File::InMemory' => '0',
    'Dist::Zilla::Plugin::Config::Git' => '0',
    'Dist::Zilla::Role::Releaser' => '0',
    'Dist::Zilla::Tester' => '0',
    'Encode' => '0',
    'Exporter' => '0',
    'File::Copy' => '0',
    'File::Copy::Recursive' => '0',
    'File::Path' => '2.07',
    'File::Spec' => '0',
    'File::Which' => '0',
    'File::pushd' => '0',
    'IO::Handle' => '0',
    'IPC::Open3' => '0',
    'Log::Dispatchouli' => '0',
    'Test::DZil' => '0',
    'Test::Fatal' => '0.006',
    'Test::More' => '0.88',
    'lib' => '0',
    'utf8' => '0'
  },
  get_options => { 'force-install' => undef },
);

unless ( eval { Module::Build->VERSION(0.4004) } ) {
  my $tr = delete $module_build_args{test_requires};
  my $br = $module_build_args{build_requires};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

my $build = Module::Build->new(%module_build_args);

# Git 1.5.4 introduced the --exclude-standard option to git ls-files,
# which Git::Check needs to work properly.
my $need_version = version->parse('1.5.4');
eval {
  my $git_version = `git --version` or die "Unable to execute git\n";
  $git_version =~ /git \s+ version \s* ( \d+ (?: \.\d+ )+ )( [-.]rc\d+)?/x
      or die "Unable to determine git version\n";
  my $rc = $2 || '';

  $git_version = version->parse("$1");
  die "git $need_version or later required, you have $git_version$rc\n"
      if $git_version < $need_version or $git_version == $need_version and $rc;
  1;
} or do {
  print $@;

  if ($build->args('force-install')) {
    print "--force-install specified, attempting to install anyway.\n";
  } else {
    print <<"END MESSAGE";
\nDist::Zilla::Plugin::Git requires git $need_version or later in your PATH,
and it wasn't found.  If you want to install anyway, run

  $^X Build.PL --force-install
END MESSAGE

    exit 0;                  # Indicate missing non-Perl prerequisite
  } # end else not --force-install
}; # end do when Git prerequisite is not met

$build->create_build_script;
