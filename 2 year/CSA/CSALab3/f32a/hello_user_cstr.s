    .data
.org             0x00
buf:             .byte  'Hello, \0________________________'
prompt_str:      .byte  'What is your name?\n\0'

    .text
    .org 0x100

_start:
    proc_print_prompt
    proc_read_input
    proc_write_output
    halt

proc_print_prompt:
    lit 0x84 b!
    lit prompt_str a!

proc_print_prompt__loop:
    @+
    lit 255 and
    dup
    if proc_print_prompt__done
    !b
    proc_print_prompt__loop ;

proc_print_prompt__done:
    drop
    ;

proc_read_input:
    lit 0x80 b!
    lit 7 a!

proc_read_input__loop:
    @b
    dup
    if proc_read_input__done
    dup lit 10 xor
    if proc_read_input__done
    @
    lit -256 and
    +
    !
    a 1 + a!
    proc_read_input__loop ;

proc_read_input__done:
    drop
    lit 33
    @
    lit -256 and
    +
    !
    a 1 + a!
    lit 0
    @
    lit -256 and
    +
    !
    ;

proc_write_output:
    lit 0x84 b!
    lit buf a!

proc_write_output__loop:
    @+
    lit 255 and
    dup
    if proc_write_output__done
    !b
    proc_write_output__loop ;

proc_write_output__done:
    drop
    ;
