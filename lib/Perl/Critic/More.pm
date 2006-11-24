##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic-More/lib/Perl/Critic/More.pm $
#     $Date: 2006-11-23 22:58:14 -0600 (Thu, 23 Nov 2006) $
#   $Author: chrisdolan $
# $Revision: 917 $
##############################################################################
package Perl::Critic::More;

use v5.6;
use warnings;
use strict;
our $VERSION = 0.12;

1;

__END__

=pod

=for stopwords metacode

=head1 NAME

Perl::Critic::More - Supplemental policies for Perl::Critic

=head1 SYNOPSIS

  perl -MCPAN -e'install Perl::Critic::More'
  perlcritic -theme more lib/Foo.pm

=head1 DESCRIPTION

This is a collection of Perl::Critic policies that are not included in
the Perl::Critic core for a variety of reasons:

=over

=item * Peripheral to Perl

For example, the C<Editor::RequireEmacsFileVariables> policy is
metacode.

=item * Requires special CPAN modules

For example, some policies require development versions of PPI.

=item * Special purpose

For example, policies designed to scratch itches not felt by most of
the community.

=back

All of these policies have the theme C<more> so they can be turned off as a group via F<.perlcriticrc> by adding this line:

  theme = not more

=head1 SEE ALSO

L<Perl::Critic>

L<Perl::Critic::Bangs>

L<Perl::Critic::Lax>

=head1 AUTHOR

Chris Dolan <cdolan@cpan.org>

Individual policies may have other authors -- please see them
individually.

This distribution is controlled by the Perl::Critic team.

=head1 COPYRIGHT

Copyright (c) 2006 Chris Dolan

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.  The full text of this license
can be found in the LICENSE file included with this module.

=cut

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 expandtab :
