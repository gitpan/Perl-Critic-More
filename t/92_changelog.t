#!perl -w
use warnings;
use strict;
use ExtUtils::Manifest qw(maniread);
use Test::More;

if (!$ENV{TEST_AUTHOR}) {
    plan skip_all => 'Author test';
}

my $manifest = maniread();
my @policies = sort map { m{/Policy/(\w+)/(\w+)\.} ? $1.q{::}.$2 : ()} keys %{$manifest};

plan tests => scalar @policies;

my $changelog;
if (open my $fh, '<', 'Changes') {
   local $/ = undef;
   $changelog = <$fh>;
   close $fh;
}

if (!$changelog) {
   BAIL_OUT('Failed to read the Changes file');
}

for my $policy (@policies) {
    ok($changelog =~ m/\Q$policy\E/xms, 'changelog mentions ' . $policy);
}

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 tw=78 ft=perl expandtab :
