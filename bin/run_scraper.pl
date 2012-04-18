use lib('/home/devights/devel/Emergency/lib/');
use Emergency;
use Emergency::Scraper;
use Emergency::Model::Incident;

use strict;
use warnings;

use Data::Dumper;

my $scraper = Emergency::Scraper->new();

my @res = @{$scraper->buildTree()};



foreach my $incident (@res){
    $incident->store;
}