    .data
.org             0x00
buf:             .byte  'Hello, _________________________'
msg_str:         .byte  'What is your name?\n\0'
err_const:       .word  0xCCCCCCCC

    .text
    .org 0x100

    \ 0 = success
    \ 1 = empty input
    \ 2 = buffer ov

_start:
    print_msg
    read_input
    write_output
    halt

print_msg:
    lit 0x84
    b!
    lit msg_str
    a!

print_msg_loop:
    @+                       \ цикл вывода сообщение What is your name?
    lit 0xff
    and
    dup
    if print_msg_done
    !b
    print_msg_loop ;

print_msg_done:
    drop
    ;

read_input:
    lit 0x80
    b!
    lit 7                    \ адрес начала записи для имени
    a!

read_input_loop:
    a                        \ чтение ввода имени
    lit 30                   \ проверка не закончилось ли место в буфере
    xor
    if read_input_overflow

    @b
    dup
    if read_input_terminate

    dup
    lit 10
    xor
    if read_input_done       \ проверка на перенос строки
    !+
    read_input_loop ;

read_input_terminate:
    drop

read_input_tail:
    @b                       \ дочитывает символы после 0 чтоб входной поток стал пустым
    dup
    lit 10
    xor
    if read_input_done
    drop
    read_input_tail ;

read_input_done:
    drop
    a                        \ проверка был ли записан хотя бы 1 символ
    lit 7
    xor
    if read_input_empty


read_input_success:
    lit 33                   \ добавление ! в конец строки
    !+

    lit 0                    \ добавление символа конца строки в конец
    !

    a
    lit 1
    +
    a!
    lit 0x5f5f5f5f
    !

    lit 0
    ;

read_input_empty:
    lit 1                    \ статус нарушения домена
    ;

read_input_overflow:
    lit 2                    \ статус переполнения
    ;

write_output:
    dup
    if write_output_normal   \ проверка на статус = 0
    lit 1
    xor
    if write_output_domain   \ проверка на статус = 1

    lit 0x84
    b!
    @p err_const             \ вывод сообщения об ошибке если статус = 2
    !b
    ;

write_output_domain:
    lit 0x84
    b!
    lit -1                   \ вывод сообщения об ошибке если статус = 1
    !b
    ;

write_output_normal:
    lit 0x84
    b!
    lit buf
    a!

write_output_loop:
    @+                       \ цикл вывода итогого сообщения с именем
    lit 0xff
    and
    dup
    if write_output_done
    !b
    write_output_loop ;

write_output_done:
    drop
    ;

