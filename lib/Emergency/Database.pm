package Emergency::Database;

use base qw(Emergency);
use Emergency::Configure;
use DBI;
use Carp qw(confess cluck longmess shortmess);

sub new {
    my $pkg  = shift;
    my $self = $pkg->SUPER::new(@_);

    $self->{'dbh'} = $self->_setup();
    return $self;
}

sub _setup {
    my $self = shift;

    my $conf    = Emergency::Configure->new();
    my @db_conf = @{ $conf->getDbConfig() };
    my $dsn     = "DBI:mysql:database=$db_conf[3];host=$db_conf[0]";

    my $dbh =
      DBI->connect( $dsn, $db_conf[1], $db_conf[2], { 'RaiseError' => 1 } )
      || die $DBI::errstr;
    return $dbh;
}

sub query {
    my $self      = shift;
    my $statement = shift;
    my @params    = @_;
    my $dbh       = $self->{'dbh'};

    die "No database handle for query" unless ($dbh);

    my $sth = $dbh->prepare($statement);

    local $SIG{__WARN__} = sub { cluck $_[0]; };

    $sth->execute(@params);

    $self->{'insert_id'}   = $sth->{'mysql_insertid'};
    $self->{'read_cursor'} = $sth;
}
sub getRow {
    my $self = shift;

    return unless defined $self->{'read_cursor'};

    my $row = $self->{'read_cursor'}->fetchrow_hashref();
    unless ($row) {
        $self->{'read_cursor'}->finish();
        delete $self->{'read_cursor'};
    }
    return $row;
}

sub getLastInsertID {
    my $self = shift;
    return $self->{'insert_id'};
}
1;
