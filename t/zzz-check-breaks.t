use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::CheckBreaks 0.007

use Test::More;

SKIP: {
    skip 'no conflicts module found to check against', 1;
}

my $breaks = {
  "Dist::Zilla::App::CommandHelper::ChainSmoking" => "<= 1.04"
};

use CPAN::Meta::Requirements;
my $reqs = CPAN::Meta::Requirements->new;
$reqs->add_string_requirement($_, $breaks->{$_}) foreach keys %$breaks;

use CPAN::Meta::Check 0.007 'check_requirements';
our $result = check_requirements($reqs, 'conflicts');

if (my @breaks = sort grep { defined $result->{$_} } keys %$result)
{
    diag 'Breakages found with Dist-Zilla-Plugin-Git:';
    diag "$result->{$_}" for @breaks;
    diag "\n", 'You should now update these modules!';
}


done_testing;
