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
use File::Copy qw{ cp };
use File::Path 2.07 qw{ make_path }; # 2.07 required for make_path
use File::pushd qw(pushd);
use Git::Wrapper;
use List::MoreUtils qw(firstidx);
use Path::Tiny 0.012 qw(path); # cwd
use File::Which qw{ which };
use Test::More;

which('gpg')
    ? plan tests => 8
    : plan skip_all => q{gpg couldn't be located in $PATH; required for GPG-signed tags};

# Mock HOME to avoid ~/.gitexcludes from causing problems
my $tempdir = Path::Tiny->tempdir( CLEANUP => 1 );
$ENV{HOME} = $ENV{GNUPGHOME} = "$tempdir";

# Don't let GIT_* variables interfere with the test
delete $ENV{$_} for grep /^GIT_/i, keys %ENV;

cp 'corpus/dzp-git.pub', "$ENV{GNUPGHOME}/pubring.gpg";
cp 'corpus/dzp-git.sec', "$ENV{GNUPGHOME}/secring.gpg";

# build fake repository
my $zilla = Dist::Zilla::Tester->from_config({
  dist_root => path('corpus/tag-signed')->absolute,
});

{
  my $dir = pushd(path($zilla->tempdir)->child('source'));
  system "git init";
  my $git = Git::Wrapper->new('.');

  $git->config( 'user.name'  => 'dzp-git test' );
  $git->config( 'user.email' => 'dzp-git@test' );
  $git->config( 'user.signingkey' => '7D85ED44');
  $git->add( qw{ dist.ini Changes } );
  $git->commit( { message => 'initial commit' } );

  # do the release
  $zilla->release;

  # check if tag has been correctly created
  my @tags = $git->tag;
  is( scalar(@tags), 1, 'one tag created' );
  is( $tags[0], 'v1.23', 'new tag created after new version' );
  is( $tags[0], $zilla->plugin_named('Git::Tag')->tag(), 'new tag matches the tag the plugin claims is the tag.');

  # Check that it is a signed tag
  my @lines = $git->show({pretty => 'short'}, 'v1.23');
  if (my $commit_begins = firstidx { /^commit / } @lines) {
    splice @lines, $commit_begins;
  }
  my $tag = join "\n", @lines;
  like( $tag, qr/^tag v1.23/m, 'Is it a real tag?' );
  like( $tag, qr/^Tagger: dzp-git test <dzp-git\@test>/m, 'Is it a real tag?' );
  like( $tag, qr/PGP SIGNATURE/m, 'Is it GPG-signed?' );
  like( $tag, qr/^v1.23:\n\n - foo\n - bar\n - baz\n/m,
        'Includes commit message?');

  # attempting to release again should fail
  eval { $zilla->release };

  like($@, qr/tag v1\.23 already exists/, 'prohibit duplicate tag');
}
