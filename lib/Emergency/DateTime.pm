package Emergency::DateTime;

use base qw(Emergency);
use Date::Calc qw(:all);
use Date::Format;

sub new {
    my $proto = shift; 
    my $class = ref($proto) || $proto;
    my $self = {};
    bless($self, $class);
    return $self;
}

sub setDate {
    my $self = shift;
    my ($year, $month, $day) = @_;

    $self->{'year'} = $year;
    $self->{'month'} = $month;
    $self->{'day'} = $day;
    return TRUE;
}

sub setTime {
    my $self = shift;
    my ($hour, $min, $sec, $ampm) = @_;

    if (defined $ampm and defined $hour and $hour =~ /^\d+$/) {
        $hour += 12 if ($ampm eq 'PM' and $hour > 0 and $hour < 12);
        $hour = 0 if ($ampm eq 'AM' and $hour == 12);
    }

    $self->{'hour'} = $hour;
    $self->{'min'} = $min;
    $self->{'sec'} = $sec;
    return TRUE;
}

sub toString {
    my $self = shift;
    my $format = shift;

    my $time_str;
    eval {
        $time_str = Mktime($self->{'year'}, $self->{'month'}, $self->{'day'},
        $self->{'hour'}, $self->{'min'}, $self->{'sec'});
    }; if ($@) {
        return;
    }

    my @date = localtime($time_str);
    return strftime($format, @date);
}

sub toSQL {
    my $self = shift;
    
    return $self->toString("%Y-%m-%d %H:%M:%S");
}
1;