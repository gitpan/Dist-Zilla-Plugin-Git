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
our $VERSION = '1.093410';
# ABSTRACT: all git plugins in one go

use Moose;
use Moose::Autobox;

with 'Dist::Zilla::Role::PluginBundle';

sub bundle_config {
    my ($self, $section) = @_;
    my $class = ( ref $self ) || $self;
    my $arg   = $section->{payload};

    # bundle all git plugins
    my @classes =
        map { "Dist::Zilla::Plugin::Git::$_" }
        qw{ Check Commit Tag Push };

    # make sure all plugins exist
    eval "require $_; 1" or die for @classes; ## no critic ProhibitStringyEval

    return @classes->map(sub { [ "$class/$_" => $_ => $arg ] })->flatten;
}


__PACKAGE__->meta->make_immutable;
no Moose;
1;


=pod

=head1 NAME

Dist::Zilla::PluginBundle::Git - all git plugins in one go

=head1 VERSION

version 1.093410

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