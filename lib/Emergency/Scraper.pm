package Emergency::Scraper;

use strict;
use warnings;
use WWW::Curl::Easy;
use HTML::TreeBuilder;

sub new {
    my $proto = shift; 
    my $class = ref($proto) || $proto;
    my $self = {};
    bless($self, $class);
    return $self;
}

sub buildTree {
    my $self = shift;
    my $response = $self->_scrapePage();

    my $tree = HTML::TreeBuilder->new_from_content($response);
    my $table = $tree->look_down("bgcolor", "#FFFFFF", "cellpadding", "2");
    my @raw_incidents = $table->look_down("_tag", "tr");
    my @incidents;
    foreach my $incident (@raw_incidents){
        my $hash = {};
        $hash->{'time'} = $incident->look_down("_tag", "td", "width", "16%")->as_text();
        $hash->{'id'} = $incident->look_down("_tag", "td", "width", "10%")->as_text();
        $hash->{'level'} = $incident->look_down("_tag", "td", "width", "7%")->as_text();
        $hash->{'units'} = $incident->look_down("_tag", "td", "width", "17%")->as_text();
        $hash->{'location'} = $incident->look_down("_tag", "td", "width", "36%")->as_text();
        $hash->{'type'} = $incident->look_down("_tag", "td", "width", "14%")->as_text();
        $hash->{'is_active'} =  $incident->look_down("_tag", "td", "width", "16%")->attr('class') eq "active" ? 1 : 0;
        
        my $model =  Emergency::Model::Incident->new();
	    $model->initFromHash($hash);
        push(@incidents, $model);
    }
    return \@incidents;
}

sub _scrapePage {
    my $self = shift;
    my $url = "http://www2.seattle.gov/fire/realTime911/getRecsForDatePub.asp?action=Today&incDate=&rad1=des";
    my $curl = WWW::Curl::Easy->new();
    $curl->setopt(CURLOPT_HEADER,1);
    $curl->setopt(CURLOPT_URL, $url);

    my $response_body;
    $curl->setopt(CURLOPT_WRITEDATA,\$response_body);

    my $retcode = $curl->perform;

    if ($retcode == 0) {
        my $response_code = $curl->getinfo(CURLINFO_HTTP_CODE);
        return $response_body;
    } else {
        die("An error happened: $retcode ".$curl->strerror($retcode)." ".$curl->errbuf."\n");
    }
}

1;

