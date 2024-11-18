.global my_function
my_function:
    addi sp, sp, -16
    sw ra, (sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    add a0, a0, a1
    mv a1, s0
    jal mystery_function
    mv a1, s1
    mv a2, s2

    sub a3, a1, a0
    add a3, a3, a2

    mv s1, a1
    mv s2, a2
    mv s3, a3

    mv a0, a3
    jal mystery_function
    mv a1, s1
    mv a2, s2
    mv a3, s3

    sub t0, a2, a0
    add a0, t0, a3

    lw ra, (sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 16
    ret
