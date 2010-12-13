#
# This file is part of Dist-Zilla-Plugin-Git
#
# This software is copyright (c) 2009 by Jerome Quelin.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use 5.010;
use strict;
use warnings;

package Dist::Zilla::Plugin::Git::Init;
BEGIN {
  $Dist::Zilla::Plugin::Git::Init::VERSION = '1.103470';
}
# ABSTRACT: initialize git repository on dzil new

use Moose;
use Git::Wrapper;

with 'Dist::Zilla::Role::AfterMint';

has commit_message => (
    is      => 'ro',
    isa     => 'Str',
    default => 'initial commit',
);

sub after_mint {
    my $self = shift;
    my ($opts) = @_;
    my $git = Git::Wrapper->new($opts->{mint_root});
    $self->log("Initializing a new git repository in " . $opts->{mint_root});
    $git->init;
    $git->add($opts->{mint_root});
    $git->commit({message => $self->commit_message});
}

1;


=pod

=head1 NAME

Dist::Zilla::Plugin::Git::Init - initialize git repository on dzil new

=head1 VERSION

version 1.103470

=head1 DESCRIPTION

This plugin initializes a git repository when a new distribution is
created with C<dzil new>.

=for Pod::Coverage after_mint

=head1 AUTHOR

Jerome Quelin

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

