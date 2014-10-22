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

use Dist::Zilla           1.093250;
use File::Path            qw{ remove_tree };
use File::Spec::Functions qw{ catdir };
use Git::Wrapper;
use Test::More            tests => 2;

# build fake repository
chdir( catdir('t', 'tag') );
system "git init";
my $git = Git::Wrapper->new('.');
$git->add( qw{ dist.ini Changes } );
$git->commit( { message => 'initial commit' } );

# do the release
my $zilla = Dist::Zilla->from_config;
$zilla->release;

# check if tag has been correctly created
my @tags = $git->tag;
is( scalar(@tags), 1, 'one tag created' );
is( $tags[0], 'v1.23', 'new tag created after new version' );

# clean & exit
remove_tree( '.git' );
unlink 'Foo-1.23.tar.gz';
exit;