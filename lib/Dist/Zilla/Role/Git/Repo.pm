#
# This file is part of Dist-Zilla-Plugin-Git
#
# This software is copyright (c) 2009 by Jerome Quelin.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
package Dist::Zilla::Role::Git::Repo;
{
  $Dist::Zilla::Role::Git::Repo::VERSION = '2.001';
}

# ABSTRACT: Provide repository information for Git plugins

use Moose::Role;
use Git::Wrapper ();

has 'repo_root'   => ( is => 'ro', isa => 'Str', default => '.' );


my %cached_wrapper;

sub git {
  my $root = shift->repo_root;

  $cached_wrapper{$root} ||= Git::Wrapper->new( $root );
}

1;

__END__

=pod

=head1 NAME

Dist::Zilla::Role::Git::Repo - Provide repository information for Git plugins

=head1 VERSION

version 2.001

=head1 DESCRIPTION

This role is used within the Git plugins to get information about the
repository structure, and to create a Git::Wrapper object.

=head1 ATTRIBUTES

=head2 repo_root

The repository root, either as a full path or relative to the distribution root. Default is C<.>.

=head1 METHODS

=head2 git

  $git = $plugin->git;

This method returns a Git::Wrapper object for the C<repo_root>
directory, constructing one if necessary.  The object is shared
between all plugins that consume this role (if they have the same
C<repo_root>).

=head1 AUTHOR

Jerome Quelin

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
