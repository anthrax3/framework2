
##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Payload::Empty;
use strict;
use base 'Msf::PayloadComponent::NoConnection';

my $info =
{
  'Name'         => 'Empty Testing Payload',
  'Version'      => '$Revision$',
  'Description'  => 'Empty payload (for testing)',
  'Authors'      => [ 'spoonm <ninjatools [at] hush.com>', ],
  'Priv'         => 0,
  'Size'         => 0,
};

sub new {
  my $class = shift;
  my $hash = @_ ? shift : { };
  $hash = $class->MergeHashRec($hash, {'Info' => $info});
  my $self = $class->SUPER::new($hash, @_);
  return($self);
}

# bypass the size > 0 check
sub Loadable {
  my $self = shift;
  return($self->DebugLevel > 0);
}

sub Build {
  my $self = shift;
  return('');
}

1;
