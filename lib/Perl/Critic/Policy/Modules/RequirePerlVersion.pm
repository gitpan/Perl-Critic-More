#######################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic-More/lib/Perl/Critic/Policy/Modules/RequirePerlVersion.pm $
#     $Date: 2007-08-08 20:17:06 -0500 (Wed, 08 Aug 2007) $
#   $Author: chrisdolan $
# $Revision: 1825 $
########################################################################

package Perl::Critic::Policy::Modules::RequirePerlVersion;

use v5.6;
use strict;
use warnings;
use Perl::Critic::Utils qw{ :severities };
use base 'Perl::Critic::Policy';

our $VERSION = 0.15;

#---------------------------------------------------------------------------

my $desc = 'Missing Perl version';
my $expl = 'Add "use v5.6.0" or similar';

#---------------------------------------------------------------------------

sub default_severity { return $SEVERITY_LOWEST }
sub default_themes   { return qw(more compatibility) }
sub applies_to       { return 'PPI::Document' }

#---------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, $doc ) = @_;

    my $includes = $doc->find('PPI::Statement::Include');
    if ($includes) {
        for my $stmt ( @{$includes} ) {
            next if $stmt->type ne 'use';
            return if $stmt->version;
            return if $stmt->module =~ m/\A v\d+(?:\.\d+(?:_\d+)?)*\z/xms;
        }
    }

    return $self->violation( $desc, $expl, $doc );
}

1;

__END__

#---------------------------------------------------------------------------

=pod

=for stopwords

=head1 NAME

Perl::Critic::Policy::Modules::RequirePerlVersion - Expect a C<use 5.6.0;> or similar

=head1 AFFILIATION

This policy is part of L<Perl::Critic::More>, a bleading edge supplement to
L<Perl::Critic>.

=head1 DESCRIPTION

As Perl evolves, new desirable features get added.  The best ones seem to
break backward compatibility, unfortunately.  As a favor to downstream
developers, it's good to state explicitly which Perl version will not be able
to parse your code.

For example, the C<our> keyword was first appeared in a stable Perl in version
5.6.0.  Therefore, if your code employs C<our>, then you should have a line
like this near the very top of your file:

  use 5.006;

or

  use v5.6.0;

Additionally, it's good form to start that minimum version in your
F<Makefile.PL> or F<Build.PL> file.

=head1 AUTHOR

Chris Dolan <cdolan@cpan.org>

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
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab :
