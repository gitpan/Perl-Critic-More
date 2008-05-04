#!perl
##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic-More/t/00_compile.t $
#     $Date: 2008-05-04 14:52:44 -0500 (Sun, 04 May 2008) $
#   $Author: clonezone $
# $Revision: 2309 $
##############################################################################

use strict;
use warnings;

use Perl::Critic::Config;
use Perl::Critic::Utils qw{ &policy_long_name &hashify };
use Perl::Critic::TestUtils qw(bundled_policy_names);

use Test::More tests => 2;

Perl::Critic::TestUtils::block_perlcriticrc();

my @policies = bundled_policy_names();
my $had_failure = 0;

{
    my $config = Perl::Critic::Config->new(-theme => 'more');
    my @found_policies = sort map { policy_long_name(ref $_) } $config->policies();

    is_deeply(\@found_policies, \@policies, 'successfully loaded policies matches MANIFEST')
        or $had_failure = 1;
}

{
    my $config = Perl::Critic::Config->new(-theme => 'core');
    my @found_policies =  map { policy_long_name(ref $_) } $config->policies();
    my %policies = hashify(@policies);
    my @core_in_this_dist = grep {$policies{$_}} @found_policies;

    is(0, scalar @core_in_this_dist, 'none of the More policies are themed as core')
        or $had_failure = 1;
}

if ($had_failure) {
    BAIL_OUT('No point continueing if there was a compilation problem.');
}

# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab shiftround :
