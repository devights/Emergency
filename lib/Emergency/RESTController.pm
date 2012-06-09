package Emergency::RESTController;
use Emergency::Database;
use warnings;
use strict;

use base qw(Apache2::REST::Handler);

sub GET{
    my ($self, $request, $response) = @_;
    my $vehicle_id =  $request->param('vehicle');
    my $db = Emergency::Database->new();
    $db->query("select Incident.id, IncidentType.name, Incident.location, Incident.start 
                FROM Incident LEFT JOIN IncidentType on Incident.type_id = IncidentType.id 
                LEFT JOIN Dispatch on Dispatch.incident_id = Incident.id WHERE end IS NULL AND start >= NOW() - INTERVAL 1 DAY AND Dispatch.vehicle_id = ?;", $vehicle_id);
    my $result = $db->getRow();
    unless ($result){
        return Apache2::Const::HTTP_NOT_FOUND;
    }
    
    $response->data()->{'incident'} = $result;
    return Apache2::Const::HTTP_OK;
    
    sub isAuth{
        my ($self, $method, $req) = @_;
        return $method eq 'GET';
    }
}

1;