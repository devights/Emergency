package Emergency::Database;

use base qw(Emergency);
use Emergency::Configure;
use DBI();

sub setupDB {
    my $self = shift;

    my $conf = Emergency::Configure->new();
    $conf->loadConfig();
    my @db_conf = @{$conf->getDbConfig()};
    my $dbh = DBI->connect("DBI:mysql:database=$db_conf[3];host=$db_conf[0]", $db_conf[1], $db_conf[2], {'RaiseError' =>1});
    return $dbh;
}


1;
