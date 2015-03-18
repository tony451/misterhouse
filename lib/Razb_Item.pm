
# This is based on Servo_Item.pm and is intended to create a simple
# item for use to control ZWave Appliance modules through Razb Pi.
# TY Oct 2013

#
# An example usage of the original can be found in mh/code/common/robot_esra.pl
#
#
#
# This is slightly complicated by needing to support device/sub-devices like the 2x1.5KW relay
# module - in Zway (at least) this appears as 2 instances of the same deviceid with instance 1 and 2.
# where a conventional single item appears as device n instance 0.
# Adapted read_table_A to use an arbitary device number as the address and pass the deviceid/instance within
# the extended data at the right hand side of the table:

# Razberry Pi ZWave Devices
#           Device index                                          Real Dev ID/Instance
# RAZB_DEV, 1,    shed_phone,                     Shed|IT|All|Phones, 2,       0
# RAZB_DEV, 2,    shed_lamp,                      Shed|Lights|All,    3,       1
# RAZB_DEV, 3,    shed_security_lamp,             Shed|Lights|All,    3,       2

  

package Razb_Item;

use LWP::UserAgent;

@Razb_Item::ISA = ('Generic_Item');


sub new {
    my ($class, $device, $deviceid, $instance) = @_;
# Need to avoid this, or the Generic_Item ExtraHash tie will disable TK scale -variable slider :(
#   my $self = $class->SUPER::new();
    my %myhash;
    my $self = \%myhash;
    bless $self, $class;
    $self->{device} = $device;
    $self->{deviceid} = $deviceid;
    $self->{instance} = $instance;
    print "Create Razb Pi item: class=$class self-device=$self->{device} self-deviceid=$self->{deviceid} self-instance=$self->{instance} other=$other \n" if $::Debug{rasp};
    return $self;
}

sub set {
    my ($self, $state) = @_;
    $self->SUPER::set($state);
    my $dev_state = ($state eq 'on') ? 255 : 0;
    &set_device($self, $dev_state);
}

sub set_device {
    my ($self, $state) = @_;
    my $device     = $self->{device};
    my $deviceid   = $self->{deviceid};
    my $instance   = $self->{instance};

    print "Sending Razb Pi data: deviceid=$deviceid instance=$instance state=$state\n" if $::Debug{rasp};
    if (defined $device) {
        my $url = "http://192.168.1.123:8083/ZWaveAPI/Run/devices[$deviceid].instances[$instance].commandClasses[0x25].Set($state)";

        # Create the fake browser (user agent).
        my $ua = LWP::UserAgent->new();

        # Pretend to be Mozilla 
        $ua->agent("Mozilla/8.0");

        # Get some HTML.
        my $response = $ua->get("$url");

    }

}
