# 
# This file is part of Dist-Zilla-Plugin-Git
# 
# This software is copyright (c) 2009 by Jerome Quelin.
# 
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
# 
use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::Git::Commit;
our $VERSION = '1.100690';
# ABSTRACT: commit dist.ini and changelog

use File::Temp           qw{ tempfile };
use Git::Wrapper;
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw{ Str };

with 'Dist::Zilla::Role::AfterRelease';


# -- attributes

has filename => ( ro, isa=>Str, default => 'Changes' );

sub after_release {
    my $self = shift;
    my $git  = Git::Wrapper->new('.');
    my @output;

    # check if changelog and dist.ini need to be committed
    # at this time, we know that only those 2 files may remain modified,
    # otherwise before_release would have failed, ending the release
    # process.
    @output =
        grep { $_ eq 'dist.ini' || $_ eq $self->filename }
        $git->ls_files( { modified=>1, deleted=>1 } );
    return unless @output;

    # write commit message in a temp file
    my ($fh, $filename) = tempfile( 'DZP-git.XXXX', UNLINK => 1 );
    print $fh $self->get_commit_message;
    close $fh;

    # commit the files in git
    $git->add( 'dist.ini', $self->filename );
    $git->commit( { file=>$filename } );
}


sub get_commit_message {
    my $self = shift;

    # parse changelog to find commit message
    my $changelog = Dist::Zilla::File::OnDisk->new( { name => $self->filename } );
    my $newver    = $self->zilla->version;
    my @content   =
        grep { /^$newver\s+/ ... /^(\S|\s*$)/ }
        split /\n/, $changelog->content;
    shift @content; # drop the version line

    # return commit message
    return join("\n", "v$newver\n", @content, ''); # add a final \n
} # end get_commit_message

1;


=pod

=head1 NAME

Dist::Zilla::Plugin::Git::Commit - commit dist.ini and changelog

=head1 VERSION

version 1.100690

=head1 SYNOPSIS

In your F<dist.ini>:

    [Git::Commit]
    filename = Changes      ; this is the default

=head1 DESCRIPTION

Once the release is done, this plugin will record this fact in git by
committing changelog and F<dist.ini>. The commit message will be taken
from the changelog for this release.

The plugin accepts the following options:

=over 4

=item * filename - the name of your changelog file. defaults to F<Changes>.

=back

=head1 METHODS

=head2 get_commit_message

This method returns the commit message.  The default implementation
reads the Changes file to get the list of changes in the just-released version.

=for Pod::Coverage::TrustPod after_release

=head1 AUTHOR

  Jerome Quelin

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

