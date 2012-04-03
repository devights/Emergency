package Emergency::Configure;

use base qw(Emergency);
use File::Slurp;
use JSON::XS;


sub new {
    my $proto = shift; 
    my $class = ref($proto) || $proto;
    my $self = {};
    bless($self, $class);
    $self->_loadConfig();
    return $self;
}


sub _loadConfig {
    my $self = shift;
    my $conf_file = read_file("/home/devights/devel/Emergency/data/conf.json");
    $self->{'conf'} = decode_json $conf_file;
}

sub getDbConfig {
    my $self = shift;
    my $conf = $self->{'conf'};
    my $db_token = [$conf->{'database'}->{'server'},  $conf->{'database'}->{'user'}, $conf->{'database'}->{'pass'}, $conf->{'database'}->{'database'}];
    return $db_token;
}

sub getDataRoot {
    my $self = shift;
    my $conf = $self->{'conf'};
    return $conf->{'data_root'};
}
1;
