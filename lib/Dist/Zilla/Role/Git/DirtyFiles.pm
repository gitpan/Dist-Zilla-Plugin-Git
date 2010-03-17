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

package Dist::Zilla::Role::Git::DirtyFiles;
our $VERSION = '1.100760';
# ABSTRACT: provide the allow_dirty & changelog attributes

use Moose::Role;
use Moose::Autobox;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw{ ArrayRef Str };


# -- attributes


has allow_dirty => (
  ro, lazy,
  isa     => ArrayRef[Str],
  builder => '_build_allow_dirty',
);
has changelog => ( ro, isa=>Str, default => 'Changes' );

sub mvp_multivalue_args { qw(allow_dirty) }


# -- builders & initializers

sub _build_allow_dirty { [ 'dist.ini', shift->changelog ] }




sub list_dirty_files
{
  my ($self, $git, $listAllowed) = @_;

  my %allowed = map { $_ => 1 } $self->allow_dirty->flatten;

  return grep { $allowed{$_} ? $listAllowed : !$listAllowed }
      $git->ls_files( { modified=>1, deleted=>1 } );
} # end list_dirty_files


no Moose::Role;
no MooseX::Has::Sugar;
1;


=pod

=head1 NAME

Dist::Zilla::Role::Git::DirtyFiles - provide the allow_dirty & changelog attributes

=head1 VERSION

version 1.100760

=head1 DESCRIPTION

This role is used within the git plugin to work with files that are
dirty in the local git checkout.

=head1 ATTRIBUTES

=head2 allow_dirty

A list of files that are allowed to be dirty in the git checkout.
Defaults to C<dist.ini> and the changelog (as defined per the
C<changelog> attribute.

=head2 changelog

The name of the changelog. Defaults to C<Changes>.

=head1 METHODS

=head2 list_dirty_files

  my @dirty = $plugin->list_dirty_files($git, $listAllowed);

This returns a list of the modified or deleted files in C<$git>,
filtered against the C<allow_dirty> attribute.  If C<$listAllowed> is
true, only allowed files are listed.  If it's false, only files that
are not allowed to be dirty are listed.

In scalar context, returns the number of dirty files.

=for Pod::Coverage::TrustPod mvp_multivalue_args

=head1 AUTHOR

  Jerome Quelin

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
