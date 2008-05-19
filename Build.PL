#!perl

#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic-More/Build.PL $
#     $Date: 2008-05-18 18:40:27 -0500 (Sun, 18 May 2008) $
#   $Author: clonezone $
# $Revision: 2366 $

use 5.006;

use strict;
use warnings;

use English qw< -no_match_vars >;

use Module::Build;


my $class = Module::Build->subclass( code => <<'END_SUBCLASS' );

    sub ACTION_test {
        my ($self) = @_;

        $self->depends_on('manifest');

        return $self->SUPER::ACTION_test();
    }

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

        return $self->SUPER::ACTION_distdir();
    } # end ACTION_distdir

END_SUBCLASS

my $builder = $class->new(
    module_name         => 'Perl::Critic::More',
    dist_author         => 'Chris Dolan <cdolan@cpan.org>',
    license             => 'perl',
    dynamic_config      => 1,

    requires            => {
        'Perl::Critic'  => 1.082,
        'Readonly'      => 1.03,
    },

    build_requires      => {
        'Test::More'    => 0,
    },

    recommends          => {
        'Perl::MinimumVersion' => '0.14',
    },

    create_packlist     => 1,

    sign                => 0,

    create_readme       => 1,

    create_makefile_pl  => 'traditional',

    meta_merge          => {
        resources   => {
            homepage    => 'http://perlcritic.com',
            license     => 'http://dev.perl.org/licenses/',
            Repository  => 'http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic-More/',
            MailingList => 'http://perlcritic.tigris.org/servlets/SummarizeList?listName=users',
        }
    },

    add_to_cleanup      => [
        qw<
            MANIFEST.bak
            Makefile
            Makefile.old
            pod2htm?.tmp
            pm_to_blib
            Perl-Critic-More-*
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
