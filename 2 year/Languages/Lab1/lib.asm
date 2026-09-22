section .text
%define EXIT_SYSCALL 60
%define WRITE_SYSCALL 1
%define READ_SYSCALL 0
%define STD_OUT 1
%define STD_IN  0
 
; Принимает код возврата и завершает текущий процесс
exit: 
    mov rax, EXIT_SYSCALL
    syscall 


; Принимает указатель на нуль-терминированную , возвращает её длину
string_length:
    xor rax, rax
    .loop:
        cmp byte[rdi + rax], 0
        je .end
        inc rax
        jmp .loop
    .end
        ret



; Принимает указатель на нуль-терминированную строку, выводит её в stdout
print_string:
    push rdi
    call string_length
    pop rsi
    mov rdx, rax
    mov rax, WRITE_SYSCALL
    mov rdi, STD_OUT
    syscall
    ret


; Принимает код символа и выводит его в stdout
print_char:
    push rdi
    mov rsi, rsp
    mov rdx, 1
    mov rax, WRITE_SYSCALL
    mov rdi, STD_OUT
    syscall
    pop rdi
    ret


; Переводит строку (выводит символ с кодом 0xA)
print_newline:
    mov rdi, 0xA
    jmp print_char


; Выводит беззнаковое 8-байтовое число в десятичном формате 
; Совет: выделите место в стеке и храните там результаты деления
; Не забудьте перевести цифры в их ASCII коды.
print_uint:
    mov rax, rdi
    push 0
    mov rdi, rsp
    sub rsp, 32
    mov r8, 10
    .loop:
        xor rdx, rdx
        div r8              ; остаток складывает в rdx
        add dl, '0'         ; младший байт регистр rdx
        dec rdi
        mov [rdi], dl
        test rax, rax
        je .print_num
        jmp .loop
        
    .print_num:
        call print_string
        add rsp, 32
        pop rax
    ret


; Выводит знаковое 8-байтовое число в десятичном формате 
print_int:
    mov rax, rdi
    cmp rax, 0
    jl .print_minus
    jmp print_uint

    .print_minus:
        mov rdi, "-"
        push rax
        call print_char
        pop rax
        neg rax
        mov rdi, rax
        call print_uint

; Принимает два указателя на нуль-терминированные строки, возвращает 1 если они равны, 0 иначе
string_equals:
    xor rcx, rcx
    .loop:
        mov dl, byte[rdi+rcx]
        cmp dl, byte[rsi+rcx]
        jnz .false
        test dl, dl
        jz .true
        inc rcx
        jmp .loop

    .false:
        xor rax, rax
        ret

    .true:
        mov rax, 1
        ret



; Читает один символ из stdin и возвращает его. Возвращает 0 если достигнут конец потока
read_char:
    xor rax, rax
    push rax
    mov rax, READ_SYSCALL
    mov rdi, STD_IN
    mov rsi, rsp
    mov rdx, 1
    syscall
    pop rax
    ret 




; Принимает: адрес начала буфера, размер буфера
; Читает в буфер слово из stdin, пропуская пробельные символы в начале, .
; Пробельные символы это пробел 0x20, табуляция 0x9 и перевод строки 0xA.
; Останавливается и возвращает 0 если слово слишком большое для буфера
; При успехе возвращает адрес буфера в rax, длину слова в rdx.
; При неудаче возвращает 0 в rax
; Эта функция должна дописывать к слову нуль-терминатор

read_word:
    xor rax, rax
    push r12
    push r13
    push r14
    mov r12, rdi
    mov r13, rsi
    xor r14, r14    ; счетчик

    .skip_loop:
        call read_char
        cmp rax, 0x20
        jz .skip_loop

        cmp rax, 0x9
        jz .skip_loop

        cmp rax, 0xA
        jz .skip_loop

        test rax, rax
        jz .fail

    .loop:
        lea rdx, [r14 + 1]
        cmp rdx, r13
        jae .fail
        mov [r12 + r14], al
        inc r14
        call read_char

        test rax, rax    
        jz .success

        cmp rax, 0x20
        jz .success

        cmp rax, 0x9
        jz .success

        cmp rax, 0xA
        jz .success
        jmp .loop


    .success:
        mov byte [r12 + r14], 0
        mov rax, r12
        mov rdx, r14
        jmp .end

    .fail:
        xor rax, rax
        xor rdx, rdx

    .end:
        pop r14
        pop r13
        pop r12
        ret



; Принимает указатель на строку, пытается
; прочитать из её начала беззнаковое число.
; Возвращает в rax: число, rdx : его длину в символах
; rdx = 0 если число прочитать не удалось
parse_uint:
    xor rax, rax
    xor rcx, rcx                ; буфер для цифры
    xor rdx, rdx                ; счетчик

    .loop:
        mov cl, [rdi+rdx]
        cmp cl, 0
        jz .end

        cmp cl, '0'
        jb .end

        cmp cl, '9'
        ja .end

        sub cl, '0'
        imul rax, 10            
        add rax, rcx

        inc rdx
        jmp .loop

    .end:
        ret



; Принимает указатель на строку, пытается
; прочитать из её начала знаковое число.
; Если есть знак, пробелы между ним и числом не разрешены.
; Возвращает в rax: число, rdx : его длину в символах (включая знак, если он был) 
; rdx = 0 если число прочитать не удалось
parse_int:
    mov cl, [rdi]

    cmp cl, '-'
    je .print_minus             

    jmp parse_uint            

    .print_minus:
        inc rdi
        sub rsp, 8              
        call parse_uint
        add rsp, 8
        
        test rdx, rdx           
        jz .end

        inc rdx             
        neg rax              

    .end:
        ret




; Принимает указатель на строку, указатель на буфер и длину буфера
; Копирует строку в буфер
; Возвращает длину строки если она умещается в буфер, иначе 0
string_copy:
    xor rcx, rcx
    .loop:
        cmp rcx, rdx
        jge .buffer_ov

        mov al, [rdi+rcx]
        mov [rsi+rcx], al

        test al, al
        jz .end

        inc rcx
        jmp .loop

    .buffer_ov:
        xor rax, rax

    .end:
        ret
