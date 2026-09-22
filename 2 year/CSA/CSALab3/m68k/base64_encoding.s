    .data
.org             0x100
output_addr:     .word  0x84
input_addr:      .word  0x80
err_msg:         .word  0xCCCCCCCC

    .text
    .org     0x200
_start:
    movea.l  0x7D0, A7
    movea.l  0x84, A3
    movea.l  0x80, A2
    movea.l  0x40, A0                        ; буфер для чтения
    clr.l    D0                              ; счетчик

read_loop:
    cmp.l    64, D0
    bge      ov_error
    move.b   (A2), D1
    and.l    0xFF, D1
    cmp.l    10, D1
    beq      check_len

    move.b   D1, (A0)+
    add.l    1, D0
    jmp      read_loop

check_len:
    cmp.l    64, D0
    bge      ov_error

    movea.l  0x0000, A0
    movea.l  0x40, A1

encode_loop:
    cmp.l    3, D0
    blt      ost

    clr.l    D1
    clr.l    D2
    clr.l    D3
    move.b   (A1)+, D1
    move.b   (A1)+, D2
    move.b   (A1)+, D3
    sub.l    3, D0

    lsl.l    16, D1
    lsl.l    8, D2
    move.l   D1, D4
    or.l     D2, D4
    or.l     D3, D4

    move.l   D4, D5                          ; первый символ
    lsr.l    18, D5
    and.l    63, D5
    jsr      encode_char
    move.b   D5, (A0)+
    move.b   D5, (A3)

    move.l   D4, D5                          ; второй символ
    lsr.l    12, D5
    and.l    63, D5
    jsr      encode_char
    move.b   D5, (A0)+
    move.b   D5, (A3)

    move.l   D4, D5                          ; третий символ
    lsr.l    6, D5
    and.l    63, D5
    jsr      encode_char
    move.b   D5, (A0)+
    move.b   D5, (A3)

    move.l   D4, D5                          ; четвертый символ
    and.l    63, D5
    jsr      encode_char
    move.b   D5, (A0)+
    move.b   D5, (A3)

    jmp      encode_loop

ost:
    cmp.l    0, D0
    beq      end

    cmp.l    1, D0
    beq      one_byte

two_bytes:
    clr.l    D1
    clr.l    D2
    move.b   (A1)+, D1
    move.b   (A1)+, D2

    lsl.l    16, D1
    lsl.l    8, D2
    move.l   D1, D4
    or.l     D2, D4

    move.l   D4, D5
    lsr.l    18, D5
    and.l    63, D5
    jsr      encode_char
    move.b   D5, (A0)+
    move.b   D5, (A3)

    move.l   D4, D5
    lsr.l    12, D5
    and.l    63, D5
    jsr      encode_char
    move.b   D5, (A0)+
    move.b   D5, (A3)

    move.l   D4, D5
    lsr.l    6, D5
    and.l    63, D5
    jsr      encode_char
    move.b   D5, (A0)+
    move.b   D5, (A3)

    move.b   61, (A0)+
    move.b   61, (A3)

    jmp      end

one_byte:
    clr.l    D1
    move.b   (A1)+, D1

    lsl.l    16, D1
    move.l   D1, D4

    move.l   D4, D5
    lsr.l    18, D5
    and.l    63, D5
    jsr      encode_char
    move.b   D5, (A0)+
    move.b   D5, (A3)

    move.l   D4, D5
    lsr.l    12, D5
    and.l    63, D5
    jsr      encode_char
    move.b   D5, (A0)+
    move.b   D5, (A3)

    move.b   61, (A0)+
    move.b   61, (A3)
    move.b   61, (A0)+
    move.b   61, (A3)

    jmp      end

encode_char:
    cmp.l    25, D5
    ble      is_upper_case

    cmp.l    51, D5
    ble      is_lower_case

    cmp.l    61, D5
    ble      is_digit

    cmp.l    62, D5
    beq      is_plus

    move.l   47, D5
    rts

is_upper_case:
    add.l    65, D5
    rts

is_lower_case:
    add.l    71, D5
    rts

is_digit:
    sub.l    4, D5
    rts

is_plus:
    move.l   43, D5
    rts

end:
    clr.b    (A0)
    halt

ov_error:
    move.l   0xCCCCCCCC, (A3)
    halt

