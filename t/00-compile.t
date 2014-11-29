use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::Compile 2.037

use Test::More  tests => 13 + ($ENV{AUTHOR_TESTING} ? 1 : 0);



my @module_files = (
    'Dist/Zilla/Plugin/Git.pm',
    'Dist/Zilla/Plugin/Git/Check.pm',
    'Dist/Zilla/Plugin/Git/Commit.pm',
    'Dist/Zilla/Plugin/Git/CommitBuild.pm',
    'Dist/Zilla/Plugin/Git/GatherDir.pm',
    'Dist/Zilla/Plugin/Git/Init.pm',
    'Dist/Zilla/Plugin/Git/NextVersion.pm',
    'Dist/Zilla/Plugin/Git/Push.pm',
    'Dist/Zilla/Plugin/Git/Tag.pm',
    'Dist/Zilla/PluginBundle/Git.pm',
    'Dist/Zilla/Role/Git/DirtyFiles.pm',
    'Dist/Zilla/Role/Git/Repo.pm',
    'Dist/Zilla/Role/Git/StringFormatter.pm'
);



# no fake home requested

my $inc_switch = -d 'blib' ? '-Mblib' : '-Ilib';

use File::Spec;
use IPC::Open3;
use IO::Handle;

my @warnings;
for my $lib (@module_files)
{
    # see L<perlfaq8/How can I capture STDERR from an external command?>
    open my $stdin, '<', File::Spec->devnull or die "can't open devnull: $!";
    my $stderr = IO::Handle->new;

    my $pid = open3($stdin, '>&STDERR', $stderr, $^X, $inc_switch, '-e', "require q[$lib]");
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';
    my @_warnings = <$stderr>;
    waitpid($pid, 0);
    is($?, 0, "$lib loaded ok");

    if (@_warnings)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
}



is(scalar(@warnings), 0, 'no warnings found') if $ENV{AUTHOR_TESTING};


