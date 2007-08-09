use strict;
use warnings;
use Module::Build;

Module::Build->new(
   module_name => 'Perl::Critic::More',
   dist_author => 'Chris Dolan <cdolan@cpan.org>',
   license => 'perl',
   requires => {
      'PPI' => 0.199_03,
      'Perl::Critic' => 1.061,
   },
   recommends => {
      'Perl::MinimumVersion' => '0.14',
   },
   build_requires => {
      'Test::More' => 0,
   },
   create_readme => 1,
   create_makefile_pl => 'traditional',
)->create_build_script();
