global _start

section .data
    ok_msg:   db "Okay", 10
    fail_msg: db "Fail", 10

section .text
getsymbol:
    mov al, [rbx]
    inc rbx
    ret

_start:
    sub rsp, 256
    xor eax, eax
    xor edi, edi
    mov rsi, rsp
    mov edx, 255
    syscall
    mov byte [rsp + rax], 0
    mov rbx, rsp

_A:
    call getsymbol
    cmp al, 'c'
    je _B
    jmp _E

_B:
    call getsymbol
    cmp al, 'b'
    je _C
    jmp _E

_C:
    call getsymbol
    cmp al, 'b'
    je _D
    jmp _E

_D:
    call getsymbol
    cmp al, 'b'
    je _F
    cmp al, 'c'
    je _D
    jmp _E

_F:
    call getsymbol
    cmp al, 'b'
    je _F
    cmp al, 'c'
    je _D
    cmp al, 10
    je _G
    test al, al
    jz _G
    jmp _E

_G:
    mov rsi, ok_msg
    mov edx, 5
    jmp _print

_E:
    mov rsi, fail_msg
    mov edx, 5

_print:
    mov eax, 1
    mov edi, 1
    syscall
    mov eax, 60
    xor edi, edi
    syscall