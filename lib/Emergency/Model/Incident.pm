
package Emergency::Model::Incident;
use strict;
use warnings;
use Date::Calc qw(Parse_Date);
use File::Slurp;
use JSON::XS;

use Data::Dumper;
sub new {
    my $proto = shift; 
    my $class = ref($proto) || $proto;
    my $self = {};
    bless($self, $class);
    return $self;
}

sub initFromHash {
    my $self = shift;
    my $hash = shift;
    
    my $time = $hash->{'time'};
    my $id = $hash->{'id'};
    my $location = $self->parseLocation($hash->{'location'});
    my $units = $self->parseUnits($hash->{'units'});
    my $level = $hash->{'level'};
    my $type = $hash->{'type'};
    my $is_active = $hash->{'is_active'};
}

sub parseUnits {
    my $self = shift;
    my $units = shift;
    my @units = split(/\s/, $units);
    return \@units;
}

sub parseLocation {
    my $self = shift;
    my $location = shift;
    $location =~ s/\//&/;
    $location =~ s/Av/Ave/;
    return $location;
}
1;
