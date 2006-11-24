#!perl

##################################################################
#      $URL: http://perlcritic.tigris.org/svn/perlcritic/trunk/Perl-Critic-More/t/97_spelling.t $
#     $Date: 2006-11-22 01:44:33 -0600 (Wed, 22 Nov 2006) $
#   $Author: chrisdolan $
# $Revision: 913 $
##################################################################


use strict;
use warnings;
use Test::More;

#-----------------------------------------------------------------------------

if (!$ENV{TEST_AUTHOR}) {
    plan skip_all => 'Author test';
}

my $aspell_path = eval q{use Test::Spelling; use File::Which;
                         which('aspell') || die 'no aspell';};
plan skip_all => 'Optional Test::Spelling, File::Which and aspell program required to spellcheck POD' if $@;

add_stopwords(<DATA>);
set_spell_cmd("$aspell_path list");
all_pod_files_spelling_ok();

__DATA__
autoflushes
CGI
CPAN
CVS
Dolan
filename
Guzis
HEREDOC
HEREDOCs
HEREDOCS
IDE
Maxia
Mehner
multi-line
namespace
namespaces
PBP
perlcritic
perlcriticrc
postfix
PPI
refactor
refactoring
runtime
sigil
sigils
SQL
STDERR
STDIN
STDOUT
TerMarsch
Thalhammer
TODO
unblessed
vice-versa
modeline
modelines
inline
UTF
HereDocs
h2xs

# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 78
#   indent-tabs-mode: nil
#   c-indentation-style: bsd
# End:
# ex: set ts=8 sts=4 sw=4 expandtab :
