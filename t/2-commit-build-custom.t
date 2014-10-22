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
use Git::Wrapper;
use Path::Class;
use Test::More   tests => 2;
use Cwd qw(cwd);

my $cwd = cwd();
my $zilla = Dist::Zilla::Tester->from_config({
  dist_root => dir($cwd, qw(t commit-build-custom)),
});

# build fake repository
chdir $zilla->tempdir->subdir('source');
system "git init -q";

my $git = Git::Wrapper->new('.');
$git->config( 'user.name'  => 'dzp-git test' );
$git->config( 'user.email' => 'dzp-git@test' );
$git->add( qw{ dist.ini Changes } );
$git->commit( { message => 'initial commit' } );
$git->branch(-m => 'dev');

$zilla->build;
ok( eval { $git->rev_parse('-q', '--verify', 'refs/heads/build-dev') }, 'source repo has the "build-dev" branch') or diag explain $@, $git->branch;
is( $git->log('build-dev'), 2, 'one commit on the build-dev branch') or diag $git->branch;
