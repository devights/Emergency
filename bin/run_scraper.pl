use lib('/home/devights/devel/Emergency/lib/');
use Emergency;
use Emergency::Scraper;
use Emergency::Model::Incident;

use strict;
use warnings;

my $scraper;
my @res;

eval { $scraper = Emergency::Scraper->new(); };
warn $@ if $@;

eval { @res = @{ $scraper->buildTree() }; };
warn $@ if $@;

foreach my $incident (@res) {
    $incident->store;
}
