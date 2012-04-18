package Emergency::Model::Incident;
use strict;
use warnings;
use Emergency::Configure;
use Emergency::DateTime;
use Emergency::Database;
use File::Slurp;
use JSON::XS;

use Data::Dumper;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = {};
    bless( $self, $class );
    return $self;
}

sub initFromHash {
    my $self = shift;
    my $hash = shift;

    $self->{'time'}     = $self->parseTime( $hash->{'time'} );
    $self->{'id'}       = $hash->{'id'};
    $self->{'location'} = $self->parseLocation( $hash->{'location'} );
    $self->{'units'}    = $self->parseUnits( $hash->{'units'} );
    $self->{'level'}    = $hash->{'level'};
    $self->{'type'}     = $hash->{'type'};
    $self->{'active'}   = $hash->{'is_active'};
}

sub parseUnits {
    my $self  = shift;
    my $units = shift;
    my @units = split( /\s/, $units );
    return \@units;
}

sub parseLocation {
    my $self     = shift;
    my $location = shift;
    $location =~ s/\//&/;
    $location =~ s/Av/Ave/;
    return $location;
}

sub parseType {
    my $self        = shift;
    my $type_string = shift;

    my $conf      = Emergency::Configure->new();
    my $types     = read_file( $conf->getDataRoot() . "/types.json" );
    my $json      = decode_json $types;
    my $type_code = $json->{$type_string};
    return $type_code ? $type_code : '---';
}

sub parseTime {
    my $self     = shift;
    my $raw_time = shift;

    ( my $date,  my $time,   my $period ) = split( /\s/, $raw_time );
    ( my $month, my $day,    my $year )   = split( /\//, $date );
    ( my $hour,  my $minute, my $second ) = split( /:/,  $time );

    my $datetime = Emergency::DateTime->new();
    $datetime->setTime( $hour, $minute, $second, $period );
    $datetime->setDate( $year, $month, $day );

    return $datetime;
}

sub store {
    my $self = shift;

    my @vehicles = @{ $self->{'units'} };
    my $type_id  = $self->{'type'};
    my $db       = Emergency::Database->new();

    my $insert_placeholder;
    foreach (@vehicles) {
        $insert_placeholder .= "(?),";
    }
    chop $insert_placeholder;

    #V1 Ignores vehicle type
    $db->query(
"INSERT IGNORE INTO Emergency.Vehicle (`name`) VALUES $insert_placeholder",
        @vehicles
    );

    #V1 Ignores "name"
    $db->query( "INSERT IGNORE INTO Emergency.IncidentType (`id`) VALUES (?)",
        $type_id );

    my @dispatch;
    $insert_placeholder = '';
    foreach my $vehicle (@vehicles) {
        push @dispatch, $vehicle, $self->{'id'};
        $insert_placeholder .= "(?, ?),";
    }
    chop $insert_placeholder;
    $db->query(
"INSERT IGNORE INTO Emergency.Dispatch (`vehicle_id`, `incident_id`) VALUES $insert_placeholder",
        @dispatch
    );
    $db->query(
"INSERT IGNORE INTO Emergency.Incident (`id`, `location`, `type_id`, `level`) VALUES (?, ?, ?, ?)",
        $self->{'id'}, $self->{'location'}, $type_id, $self->{'level'} );
}

1;
