package Msf::Encoder::PexAlphaNum;
use strict;
use base 'Msf::Encoder';
use Pex::Encoder;

my $advanced = {
  'PexDebug' => [0, 'Sets the Pex Debugging level (zero is no output)'],
};

my $info = {
  'Name'  => 'Pex Alphanumeric Encoder',
  'Version'  => '1.0',
  'Authors' => [ 'H D Moore <hdm [at] metasploit.com> [Artistic License]', ],
  'Arch'  => [ 'x86' ],
  'OS'    => [ ],
  'Description'  =>  "Skylined's alphanumeric encoder ported to perl",
  'Refs'  => [ ],
};

sub new {
  my $class = shift; 
  return($class->SUPER::new({'Info' => $info, 'Advanced' => $advanced}, @_));
}

sub EncodePayload {
  my $self = shift;
  my $rawshell = shift;
  my $badChars = shift;
  
  my $type = $self->GetVar('GETPCTYPE');
  if (! $type && $self->GetVar('_Payload') && grep {/win32/} @{ $self->GetVar('_Payload')->OS})
  {
    $type = 'win32';
  }

  return(Pex::Encoder::Encode('x86', 'AlphaNum', 'Skylined', $rawshell, $badChars, $self->GetLocal('PexDebug'), $type));
}

1;
