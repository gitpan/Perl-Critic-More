#######################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic-More/lib/Perl/Critic/Policy/Modules/PerlMinimumVersion.pm $
#     $Date: 2008-05-26 16:44:53 -0500 (Mon, 26 May 2008) $
#   $Author: clonezone $
# $Revision: 2407 $
########################################################################

package Perl::Critic::Policy::Modules::PerlMinimumVersion;

use 5.006;
use strict;
use warnings;

use English qw(-no_match_vars);
use Readonly;

use Perl::Critic::Utils qw{ :severities };

use base 'Perl::Critic::Policy';

our $VERSION = '1.000';

#---------------------------------------------------------------------------

Readonly::Scalar my $DESC =>
    'Avoid Perl features newer than specified version';
Readonly::Scalar my $EXPL => 'Improve your backward compatibility';

#---------------------------------------------------------------------------

sub default_severity { return $SEVERITY_LOWEST }
sub default_themes   { return qw< more compatibility > }
sub applies_to       { return 'PPI::Document' }

sub supported_parameters {
    return (
        {   name        => 'version',
            description => 'Version of perl to be compatible with.',
            behavior    => 'string',
            parser      => \&_parse_version,
        },
    );
}

#---------------------------------------------------------------------------

sub _parse_version {
    my ( $self, $parameter, $config_string ) = @_;

    my $version;
    if ($config_string) {
        if ( $config_string =~ m<\A \s* (5 [.] [\d.]+) \s* \z>xms ) {
            $version = $1;
        } else {
            $self->throw_parameter_value_exception( 'version', $config_string,
                undef, "doesn't look like a perl version number.\n",
            );
        }
    } elsif ( ref $PERL_VERSION ) {
        $version = $PERL_VERSION->numify();    # It's an object as of 5.10.
    } else {
        $version = 0 + $PERL_VERSION;    # numify to get away from version.pm
    }

    $self->{_version} = $version;

    return;
}

#---------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, $doc ) = @_;

    eval { require Perl::MinimumVersion; };
    return if $EVAL_ERROR;

    my $checker = Perl::MinimumVersion->new($doc);

    # Workaround for Perl::Critic::Document instance in older P::C versions
    # (pre-v0.22) that didn't have a custom isa() to masquerade as a
    # PPI::Document
    if ( !$checker ) {
        $checker = Perl::MinimumVersion->new( $doc->{_doc} );
    }
    return if !$checker;    # bail out!

    # this returns a version.pm instance
    my $doc_version = $checker->minimum_version();

    #print "v$doc_version vs. $self->{_version}\n";
    return if $doc_version <= $self->{_version};

    return $self->violation( $DESC, $EXPL, $doc );
}

1;

__END__

#---------------------------------------------------------------------------

=pod

=for stopwords

=head1 NAME

Perl::Critic::Policy::Modules::PerlMinimumVersion - Enforce backward compatible code.

=head1 AFFILIATION

This policy is part of L<Perl::Critic::More>, a bleeding edge supplement to
L<Perl::Critic>.

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

Copyright (c) 2006-2008 Chris Dolan

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
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
