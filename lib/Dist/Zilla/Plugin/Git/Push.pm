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

package Dist::Zilla::Plugin::Git::Push;
our $VERSION = '1.100430';
# ABSTRACT: push current branch

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

    # push everything on remote branch
    $git->push;
    $git->push( { tags=>1 } );
}

1;


=pod

=head1 NAME

Dist::Zilla::Plugin::Git::Push - push current branch

=head1 VERSION

version 1.100430

=head1 SYNOPSIS

In your F<dist.ini>:

    [Git::Push]
    filename = Changes      ; this is the default

=head1 DESCRIPTION

Once the release is done, this plugin will push current git branch to
remote end, with the associated tags.

The plugin accepts the following options:

=over 4

=item * filename - the name of your changelog file. defaults to F<Changes>.

=back

=for Pod::Coverage::TrustPod after_release

=head1 AUTHOR

  Jerome Quelin

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

