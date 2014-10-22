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
use utf8;

use Cwd qw( cwd );
use Dist::Zilla  1.093250;
use Dist::Zilla::Tester;
use Encode qw( decode );
use File::Temp qw{ tempdir };
use Git::Wrapper;
use Path::Class;
use Test::More;

plan skip_all => "Dist::Zilla 5 required" if Dist::Zilla->VERSION < 5;
plan tests => 1;

# Mock HOME to avoid ~/.gitexcludes from causing problems
$ENV{HOME} = tempdir( CLEANUP => 1 );
my $cwd = cwd();
END { chdir $cwd if $cwd }

# UTF-8 encoded strings:
my $changes1 = 'Ævar Arnfjörð Bjarmason';
my $changes2 = 'ブログの情報';
my $changes3 = 'plain ASCII';

# build fake repository
my $zilla = Dist::Zilla::Tester->from_config({
  dist_root => dir('corpus/commit')->absolute,
},{
  add_files => {
    'source/Changes' => <<"END CHANGES",
Changes

1.23 2012-11-10 19:15:45 CET
 - $changes1
 - $changes2
 - $changes3
END CHANGES
  },
});

chdir $zilla->tempdir->subdir('source');

system "git init";
my $git = Git::Wrapper->new('.');
$git->config( 'user.name'  => 'dzp-git test' );
$git->config( 'user.email' => 'dzp-git@test' );
$git->add( qw{ dist.ini Changes } );
$git->commit( { message => 'initial commit' } );

# do a release, with changes and dist.ini updated
append_to_file('Changes',  "\n");
append_to_file('dist.ini', "\n");
$zilla->release;

# check if dist.ini and changelog have been committed
my ($log) = $git->log( 'HEAD' );
like( decode('UTF-8', $log->message), qr/v1.23\n[^a-z]*\Q$changes1\E[^a-z]*\Q$changes2\E[^a-z]*\Q$changes3\E/, 'commit message taken from changelog' );

sub append_to_file {
    my ($file, @lines) = @_;
    open my $fh, '>>', $file or die "can't open $file: $!";
    print $fh @lines;
    close $fh;
}
