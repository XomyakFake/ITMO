    .data
output_addr:     .word  0x84
input_addr:      .word  0x80
shift:           .word  8
mask:            .word  0x000000FF
cycle_count:     .word  4

    .text
    .org     0x200
_start:
    lui      t0, %hi(input_addr)
    addi     t0, t0, %lo(input_addr)
    lw       t0, 0(t0)

    lui      t5, %hi(output_addr)
    addi     t5, t5, %lo(output_addr)
    lw       t5, 0(t5)

    lui      a0, %hi(shift)
    addi     a0, a0, %lo(shift)
    lw       a0, 0(a0)

    lui      a1, %hi(mask)
    addi     a1, a1, %lo(mask)
    lw       a1, 0(a1)

    lui      a2, %hi(cycle_count)
    addi     a2, a2, %lo(cycle_count)
    lw       a2, 0(a2)

    lw       t2, 0(t0)

loop:
    and      t3, t2, a1                      ; младший байт
    srl      t2, t2, a0

    sll      t4, t4, a0
    add      t4, t4, t3

    addi     a2, a2, -1
    beq      a2, zero, exit
    j        loop

exit:
    sw       t4, 0(t5)
    halt
