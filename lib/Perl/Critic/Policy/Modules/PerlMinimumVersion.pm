#######################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic-More/lib/Perl/Critic/Policy/Modules/PerlMinimumVersion.pm $
#     $Date: 2006-11-23 22:58:14 -0600 (Thu, 23 Nov 2006) $
#   $Author: chrisdolan $
# $Revision: 917 $
########################################################################

package Perl::Critic::Policy::Modules::PerlMinimumVersion;

use v5.6;
use strict;
use warnings;
use Perl::Critic::Utils;
use English qw(-no_match_vars);
use Carp;
use base 'Perl::Critic::Policy';

our $VERSION = 0.12;

#---------------------------------------------------------------------------

my $desc = 'Avoid Perl features newer than specified version';
my $expl = 'Improve your backward compatibility';

#---------------------------------------------------------------------------

sub default_severity { return $SEVERITY_LOWEST }
sub default_themes   { return qw(more compatibility) }
sub applies_to       { return 'PPI::Document' }

#---------------------------------------------------------------------------

sub new {
    my ( $class, %config ) = @_;
    my $self = bless {}, $class;

    $self->{_version} = $PERL_VERSION;
    if ( $config{version} ) {
        if ( $config{version} =~ m/\A \s* (5\.[\d\.]+) \s* \z/xms ) {
            $self->{_version} = $1;
        } else {
            croak 'Invalid PerlMinimumVersion number in Perl::Critic config';
        }
    }

    return $self;
}

#---------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, $doc ) = @_;

    eval { require Perl::MinimumVersion; };
    return if $EVAL_ERROR;

    my $checker = Perl::MinimumVersion->new($doc);

    # Workaround for Perl::Critic::Document instance in older P::C versions
    if ( !$checker ) {
        $checker = Perl::MinimumVersion->new( $doc->{_doc} );
    }
    return if !$checker;    # bail out!

    # this returns a version.pm instance
    my $doc_version = $checker->minimum_version();
    return if $doc_version <= $self->{_version};

    return $self->violation( $desc, $expl, $doc );
}

1;

__END__

#---------------------------------------------------------------------------

=pod

=for stopwords

=head1 NAME

Perl::Critic::Policy::Modules::PerlMinimumVersion - Enforce backward compatible code

=head1 DESCRIPTION

As Perl evolves, new desirable features get added.  The best ones seem to
break backward compatibility, unfortunately.  This policy allows you to
specify a mandatory compatibility version for your code.

For example, if you add the following to your F<.perlcriticrc> file:

  [Modules::PerlMinimumVersion]
  version = 5.005

then any code that employs C<our> will fail this policy, for example.  By
default, this policy enforces the current Perl version, which is a pretty weak
statement.

This policy relies on L<Perl::MinimumVersion> to do the heavy lifting.  If
that module is not installed, then this policy always passes.

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
# ex: set ts=8 sts=4 sw=4 expandtab :
