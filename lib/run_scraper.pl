use Emergency::Scraper;
use strict;
use warnings;

use Data::Dumper;

my $scraper = Emergency::Scraper->new();

$scraper->_buildTree();
