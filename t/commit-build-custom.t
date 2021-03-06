#!perl
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

use Dist::Zilla  1.093250;
use Dist::Zilla::Tester;
use File::pushd qw(pushd);
use Git::Wrapper;
use Path::Tiny qw();
use Test::More   tests => 5;

# Mock HOME to avoid ~/.gitexcludes from causing problems
my $tmp = Path::Tiny->tempdir( CLEANUP => 1 );
$ENV{HOME} = "$tmp";

my $zilla = Dist::Zilla::Tester->from_config({
  dist_root => Path::Tiny::path('corpus/commit-build-custom')->absolute,
});

# build fake repository
{
  my $dir = pushd(Path::Tiny::path($zilla->tempdir)->child('source'));
  system "git init -q";

  my $git = Git::Wrapper->new('.');
  $git->config( 'user.name'  => 'dzp-git test' );
  $git->config( 'user.email' => 'dzp-git@test' );
  $git->add( qw{ dist.ini Changes } );
  $git->commit( { message => 'initial commit' } );
  $git->branch(-m => 'dev');

  $zilla->build;
  ok( eval { $git->rev_parse('-q', '--verify', 'refs/heads/build-dev') }, 'source repo has the "build-dev" branch') or diag explain $@, $git->branch;
  is( scalar $git->log('build-dev'), 1, 'one commit on the build-dev branch')
      or diag $git->branch;

  $zilla->release;
  ok( eval { $git->rev_parse('-q', '--verify', 'refs/heads/release') }, 'source repo has the "release" branch') or diag explain $@, $git->branch;
  my @logs = $git->log('release');
  is( scalar(@logs), 1, 'one commit on the release branch') or diag $git->branch;
  like( $logs[0]->message, qr/^Release of 1\.23\b/, 'correct release commit log message generated');
}
