use strict;
use warnings;
use Module::Build;

Module::Build->new(
   module_name => 'Perl::Critic::More',
   dist_author => 'Chris Dolan <cdolan@cpan.org>',
   license => 'perl',
   requires => {
      'PPI' => 0.199_01,
      'Perl::Critic' => 0.21,
   },
   recommends => {
      'Perl::MinimumVersion' => '>0.13',
   },
   build_requires => {
      'Test::More' => 0,
   },
   create_readme => 1,
   create_makefile_pl => 'traditional',
)->create_build_script();
