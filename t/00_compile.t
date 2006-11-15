#!perl -T
##############################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic-More/t/00_compile.t $
#     $Date: 2006-11-15 12:02:15 -0600 (Wed, 15 Nov 2006) $
#   $Author: chrisdolan $
# $Revision: 867 $
##############################################################################

use warnings;
use strict;
use ExtUtils::Manifest qw(maniread);
use Perl::Critic::Config;
use Perl::Critic::Utils;
use Test::More tests => 1;

my $manifest = maniread();
my @policies = sort map { m{/Policy/(\w+)/(\w+)\.} ? $1.q{::}.$2 : ()} keys %{$manifest};
my $config = Perl::Critic::Config->new(-theme => 'more');
my @found_policies = sort map { policy_short_name(ref $_) } $config->policies();
is_deeply(\@found_policies, \@policies, 'successfully loaded policies matches MANIFEST');
