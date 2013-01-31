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

use Git::Wrapper;
use Path::Class;
use Test::More 0.88;            # done_testing
use Test::Fatal qw(exception);

use t::Util;

# rt#56485 - skip test to avoid failures for old git versions
skip_unless_git_version('1.7.0');

plan tests => 7;

init_test(corpus => 'push');

$git->add( qw{ dist.ini Changes } );
$git->commit( { message => 'initial commit' } );

# create a clone, and use it to set up origin
my $clone = $base_dir->subdir('clone');
$git->clone( { quiet=>1, 'no-checkout'=>1, bare=>1 }, $git_dir, $clone );
$git->remote('add', 'origin', $clone);
$git->config('branch.master.remote', 'origin');
$git->config('branch.master.merge', 'refs/heads/master');

# do the release
append_to_file('Changes',  "\n");
append_to_file('dist.ini', "\n");

new_zilla_from_repo;
$zilla->release;

# Check log
zilla_log_is('Git::Push', <<'');
[Git::Push] pushing to origin

# check if everything was pushed
$git = Git::Wrapper->new( $clone );
my ($log) = $git->log( 'HEAD' );
like( $log->message, qr/v1.23\n[^a-z]*foo[^a-z]*bar[^a-z]*baz/, 'commit pushed' );

# check if tag has been correctly created
my @tags = $git->tag;
is( scalar(@tags), 1, 'one tag pushed' );
is( $tags[0], 'v1.23', 'new tag created after new version' );

# try a release with a bogus remote
append_to_file('dist.ini', <<'END dist.ini');
push_to = origin
push_to = bogus unmodified
END dist.ini

new_zilla_from_repo;
my $exception = exception { $zilla->release };
like($exception, qr/^\Q[Git::Push] These remotes do not exist: bogus\E/,
     'Caught bogus remote');

zilla_log_is('Git::Push', <<'');
[Git::Push] These remotes do not exist: bogus

is_deeply($zilla->plugin_named('Git::Push')->push_to,
          [ 'origin', 'bogus unmodified' ],
          "push_to is not modified");

done_testing;
