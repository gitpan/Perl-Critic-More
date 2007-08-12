#######################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic-More/lib/Perl/Critic/Policy/ValuesAndExpressions/RestrictLongStrings.pm $
#     $Date: 2007-08-12 11:37:37 -0500 (Sun, 12 Aug 2007) $
#   $Author: chrisdolan $
# $Revision: 1831 $
########################################################################

package Perl::Critic::Policy::ValuesAndExpressions::RestrictLongStrings;

use 5.006;
use strict;
use warnings;
use Carp;
use Readonly;
use Perl::Critic::Utils qw{ :severities };
use base 'Perl::Critic::Policy';

our $VERSION = 0.16;

Readonly my $DEFAULT_MAX_STRING_LENGTH => 78;

#---------------------------------------------------------------------------

my $desc = 'Long string mixed with code';
my $expl = 'Put long strings in their own subroutine or split them';

#---------------------------------------------------------------------------

sub default_severity { return $SEVERITY_LOW }
sub default_themes   { return qw(more readability) }
sub applies_to       { return 'PPI::Token::Quote' }

#---------------------------------------------------------------------------

sub new {
    my ( $class, %config ) = @_;
    my $self = bless {}, $class;

    $self->{_max_length} = $DEFAULT_MAX_STRING_LENGTH;
    if ( $config{max_length} ) {
        if ( $config{max_length} =~ m/\A \s* (\d+) \s* \z/xms && $1 > 0 ) {
            $self->{_max_length} = $1;
        } else {
            croak 'Invalid RestrictLongStrings length in Perl::Critic config';
        }
    }

    return $self;
}

#---------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, $doc ) = @_;

    my $length = length $elem->string;
    return if $length <= $self->{_max_length};

    # Allow long strings in the last statment of a subroutine
    my $stmt = $elem->statement;
    if ( !$stmt->snext_sibling ) {
        my $stmt_parent = $stmt->parent;
        if ( $stmt_parent->isa('PPI::Structure::Block') ) {

            # Named subroutine
            return if $stmt_parent->parent->isa('PPI::Statement::Sub');

            # Anonymous subroutine
            my $sib = $stmt_parent->sprevious_sibling;
            return if $sib && $sib->isa('PPI::Token::Word') && $sib eq 'sub';
        }
    }

    return $self->violation( $desc, $expl, $elem );
}

1;

__END__

#---------------------------------------------------------------------------

=pod

=for stopwords

=head1 NAME

Perl::Critic::Policy::ValuesAndExpressions::RestrictLongStrings - Stop mixing long strings with code

=head1 AFFILIATION

This policy is part of L<Perl::Critic::More>, a bleading edge supplement to
L<Perl::Critic>.

=head1 DESCRIPTION

Long text strings in the middle of code is very distracting and wreaks havoc
on code formatting.  Consider putting long strings in external data files,
C<__DATA__> sections, or in their own subroutines.

This policy complains if a long string is not the last line of a subroutine.
"Long" is defined as 78 characters by default.  This value can be altered in
your Perl::Critic configuration via the C<max_length> property.  For example,
you may add the following to your F<.perlcriticrc> file:

  [ValuesAndExpressions::RestrictLongStrings]
  max_length = 50

=head1 SEE ALSO

=head1 AUTHOR

Chris Dolan <cdolan@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2006-2007 Chris Dolan

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
