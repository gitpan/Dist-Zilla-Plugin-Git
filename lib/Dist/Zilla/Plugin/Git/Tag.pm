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

package Dist::Zilla::Plugin::Git::Tag;
our $VERSION = '1.100660';
# ABSTRACT: tag the new version

use Git::Wrapper;
use Moose;
use MooseX::Has::Sugar;
use MooseX::Types::Moose qw{ Str };
use String::Formatter method_stringf => {
  -as => '_format_tag',
  codes => {
    v => sub { $_[0]->version },
  },
};

with 'Dist::Zilla::Role::AfterRelease';


# -- attributes

has filename   => ( ro, isa=>Str, default => 'Changes' );
has tag_format => ( ro, isa=>Str, default => 'v%v' );


# -- role implementation

sub after_release {
    my $self = shift;
    my $git  = Git::Wrapper->new('.');

    # create a tag with the new version
    my $tag = _format_tag($self->tag_format, $self->zilla);
    $git->tag( $tag );
}

1;


=pod

=head1 NAME

Dist::Zilla::Plugin::Git::Tag - tag the new version

=head1 VERSION

version 1.100660

=head1 SYNOPSIS

In your F<dist.ini>:

    [Git::Tag]
    filename = Changes      ; this is the default

=head1 DESCRIPTION

Once the release is done, this plugin will record this fact in git by
creating a tag.

The plugin accepts the following options:

=over 4

=item * filename - the name of your changelog file. Defaults to F<Changes>.

=item * tag_format - format of the tag to apply. C<%v> will be
replaced by the dist version. Defaults to C<v%v>.

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

