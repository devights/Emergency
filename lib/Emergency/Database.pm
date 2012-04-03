package Emergency::Database;

use base qw(Emergency);
use Emergency::Configure;
use DBI();

sub setupDB {
    my $self = shift;

    my $conf = Emergency::Configure->new();
    my @db_conf = @{$conf->getDbConfig()};
    my $dsn = "DBI:mysql:database=$db_conf[3];host=$db_conf[0]";    
    
    my $dbh = DBI->connect($dsn, $db_conf[1], $db_conf[2]) || die $DBI::errstr;
    return $dbh;
}


1;
