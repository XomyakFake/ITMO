    .data
input_addr:      .word  0x80
output_addr:     .word  0x84
n:               .word  0
res:             .word  0
one:             .word  1
ten:             .word  10
err_const:       .word  0xCCCCCCCC

    .text
_start:
    load_addr    input_addr
	load_acc
    store_addr   n
    bgez         loop

neg_part:
    load_addr    n
    not
    add          one
    store_addr   n

loop:
    load_addr    n
    rem          ten
    add          res
    store_addr   res
    load_addr    n
    div          ten
    store_addr   n
    bnez         loop

print:
    load_addr    res
    store_ind    output_addr

exit:
    halt
