use strict;
use warnings;

use Module::Build;

my $class = Module::Build->subclass( code => <<'END_SUBCLASS' );

    sub ACTION_authortest {
        my ($self) = @_;

        $self->depends_on('build');
        $self->depends_on('manifest');
        $self->depends_on('distmeta');

        $self->test_files( qw< t xt/author > );
        $self->recursive_test_files(1);

        $self->depends_on('test');

        return;
    } # end ACTION_authortest()

    sub ACTION_distdir {
        my ($self) = @_;

        $self->depends_on('authortest');

        return $self->SUPER::ACTION_distdir;
    } # end ACTION_distdir

END_SUBCLASS

my $builder = $class->new(
    module_name     => 'Perl::Critic::More',
    dist_author     => 'Chris Dolan <cdolan@cpan.org>',
    license         => 'perl',
    requires        => {
        'Perl::Critic' => 1.082,
        'Readonly'     => 1.03,
    },

    recommends      => {
        'Perl::MinimumVersion' => '0.14',
    },

    build_requires  => {
        'Test::More'   => 0,
    },

    create_readme   => 1,

    create_makefile_pl  => 'traditional',

    meta_merge      => {
        resources   => {
            homepage    => 'http://perlcritic.com',
            license     => 'http://dev.perl.org/licenses/',
            Repository  => 'http://perlcritic.tigris.org/source/browse/perlcritic/',
            MailingList => 'http://perlcritic.tigris.org/servlets/SummarizeList?listName=users',
        }
    },

    add_to_cleanup => [
        qw<
            MANIFEST.bak
            Makefile
            Makefile.old
            lib/Perl/Critic/PolicySummary.pod
            pm_to_blib
            t/ControlStructures/ProhibitNegativeExpressionsInUnlessAndUntilConditions.run
            t/Variables/RequireLocalizedPunctuationVars.run
        >,
    ],
);

$builder->create_build_script();

##############################################################################
# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
