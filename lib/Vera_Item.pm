
# This is based on Servo_Item.pm and is intended to create a simple
# item for use to control ZWave Appliance modules through Veralite.
# TY Feb 2013

# An example usage of the original can be found in mh/code/common/robot_esra.pl

package Vera_Item;

use LWP::UserAgent;

@Vera_Item::ISA = ('Generic_Item');


sub new {
    my ($class, $device) = @_;
# Need to avoid this, or the Generic_Item ExtraHash tie will disable TK scale -variable slider :(
#   my $self = $class->SUPER::new();
    my %myhash;
    my $self = \%myhash;
    bless $self, $class;
    $self->{device} = $device;
    return $self;
}

sub set {
    my ($self, $state) = @_;
    $self->SUPER::set($state);
    my $dev_state = ($state eq 'on') ? 1 : 0;
    &set_device($self, $dev_state);
}

sub set_device {
    my ($self, $state) = @_;
    my $device     = $$self{device};

    print "Sending Veralite data: device=$device state=$state\n" if $::Debug{vera};
    if (defined $device) {
        my $url = "http://192.168.1.234:3480/data_request?id=lu_action&DeviceNum=$device"
                  ."&serviceId=urn:upnp-org:serviceId:SwitchPower1&action=SetTarget&newTargetValue=$state";

        # Create the fake browser (user agent).
        my $ua = LWP::UserAgent->new();

        # Pretend to be Mozilla 
        $ua->agent("Mozilla/8.0");

        # Get some HTML.
        my $response = $ua->get("$url");

    }

}
