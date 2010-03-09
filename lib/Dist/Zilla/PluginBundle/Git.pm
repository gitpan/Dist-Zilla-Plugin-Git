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

package Dist::Zilla::PluginBundle::Git;
our $VERSION = '1.100680';
# ABSTRACT: all git plugins in one go

use Moose;
use Class::MOP;

with 'Dist::Zilla::Role::PluginBundle';

sub bundle_config {
    my ($self, $section) = @_;
    my $class = ( ref $self ) || $self;
    my $arg   = $section->{payload};

    # bundle all git plugins
    my @names   = qw{ Check Commit Tag Push };

    my @config;

    for my $name (@names) {
        my $class = "Dist::Zilla::Plugin::Git::$name";
        Class::MOP::load_class($class);
        push @config, [ "$section->{name}/$name" => $class => $arg ];
    }

    return @config;
}


__PACKAGE__->meta->make_immutable;
no Moose;
1;


=pod

=head1 NAME

Dist::Zilla::PluginBundle::Git - all git plugins in one go

=head1 VERSION

version 1.100680

=head1 SYNOPSIS

In your F<dist.ini>:

    [@Git]
    filename = Changes        ; this is the default

=head1 DESCRIPTION

This is a plugin bundle to load all git plugins. It is equivalent to:

    [Git::Check]
    [Git::Commit]
    [Git::Tag]
    [Git::Push]

The options are passed through to the plugins.

=for Pod::Coverage::TrustPod bundle_config

=head1 AUTHOR

  Jerome Quelin

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

