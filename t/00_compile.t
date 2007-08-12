#!perl
##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic-More/t/00_compile.t $
#     $Date: 2007-08-10 20:38:52 -0500 (Fri, 10 Aug 2007) $
#   $Author: chrisdolan $
# $Revision: 1827 $
##############################################################################

use warnings;
use strict;
use Perl::Critic::Config;
use Perl::Critic::Utils qw{ &policy_long_name &hashify };
use Perl::Critic::TestUtils qw(bundled_policy_names);
use Test::More tests => 2;

Perl::Critic::TestUtils::block_perlcriticrc();

my @policies = bundled_policy_names();

{
   my $config = Perl::Critic::Config->new(-theme => 'more');
   my @found_policies = sort map { policy_long_name(ref $_) } $config->policies();
   is_deeply(\@found_policies, \@policies, 'successfully loaded policies matches MANIFEST');
}

{
   my $config = Perl::Critic::Config->new(-theme => 'core');
   my @found_policies =  map { policy_long_name(ref $_) } $config->policies();
   my %policies = hashify(@policies);
   my @core_in_this_dist = grep {$policies{$_}} @found_policies;
   is(0, scalar @core_in_this_dist, 'none of the More policies are themed as core');
}

