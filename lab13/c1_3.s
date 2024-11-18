
.global operation
operation:
    addi sp, sp, -16
    sw ra, (sp)

    li a0, 1
    li a1, -2
    li a2, 3
    li a3, -4
    li a4, 5
    li a5, -6
    li a6, 7

    addi sp, sp, -24
    li a7, 9
    sw a7, 0(sp)
    li a7, -10
    sw a7, 4(sp)
    li a7, 11
    sw a7, 8(sp)
    li a7, -12
    sw a7, 12(sp)
    li a7, 13
    sw a7, 16(sp)
    li a7, -14
    sw a7, 20(sp)
    li a7, -8

    jal mystery_function
    addi sp, sp, 24

    lw ra, (sp)
    addi sp, sp, 16
    ret
