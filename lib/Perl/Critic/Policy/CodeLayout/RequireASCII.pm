#######################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic-More/lib/Perl/Critic/Policy/CodeLayout/RequireASCII.pm $
#     $Date: 2007-08-08 20:17:06 -0500 (Wed, 08 Aug 2007) $
#   $Author: chrisdolan $
# $Revision: 1825 $
########################################################################

package Perl::Critic::Policy::CodeLayout::RequireASCII;

use v5.6;
use strict;
use warnings;
use Readonly;
use Perl::Critic::Utils qw{ :severities };
use List::MoreUtils qw(none any);
use base 'Perl::Critic::Policy';

our $VERSION = 0.14;

Readonly my $MAX_ASCII_VALUE => 127;

#---------------------------------------------------------------------------

my $desc = 'Use only ASCII code';
my $expl = 'Put any non-ASCII in separate files';

#---------------------------------------------------------------------------

sub default_severity { return $SEVERITY_LOWEST }
sub default_themes   { return qw(more notrecommended) }
sub applies_to       { return 'PPI::Token' }

#---------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, $doc ) = @_;

    if ( any { $_ > $MAX_ASCII_VALUE } unpack 'C*', "$elem" ) {
        return $self->violation( $desc, $expl, $elem );
    }
    if ( $elem->isa('PPI::Token::HereDoc') ) {
        for my $line ( $elem->heredoc ) {
            if ( any { $_ > $MAX_ASCII_VALUE } unpack 'C*', $line ) {
                return $self->violation( $desc, $expl, $elem );
            }
        }
    }

    return;    #ok
}

1;

__END__

#---------------------------------------------------------------------------

=pod

=for stopwords EBCDIC

=head1 NAME

Perl::Critic::Policy::CodeLayout::RequireASCII - Disallow high-bit characters

=head1 AFFILIATION

This policy is part of L<Perl::Critic::More>, a bleading edge supplement to
L<Perl::Critic>.

=head1 DESCRIPTION

ASCII is a text encoding first introduced in 1963.  It represents 128
characters in seven-bit bytes, reserving the eighth bit for error detection.
Perl supports a large number of encodings.  However, if you really want the
ultimate in backward compatibility, ASCII is it!  (We won't even talk about
EBCDIC and the like...)

This policy is B<not> recommended for everyone.  Instead,
most of you should probably strive for one of the Unicode encodings for
maximum forward compatibility.

=head1 SEE ALSO

L<http://en.wikipedia.org/wiki/Ascii>

L<http://en.wikipedia.org/wiki/EBCDIC>

L<http://en.wikipedia.org/wiki/Unicode>

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
