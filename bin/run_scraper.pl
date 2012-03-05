use lib('/home/devights/Emergency/lib/');
use Emergency;
use Emergency::Scraper;
use Emergency::Model::Incident;
use strict;
use warnings;

use Data::Dumper;

my $scraper = Emergency::Scraper->new();

my $res = $scraper->buildTree();

print Dumper $res;


