.global fill_array_int
.global fill_array_short
.global fill_array_char


fill_array_int:
    addi sp, sp, -16
    sw ra, (sp)

    addi sp, sp, -400

    mv a0, sp
    li t0, 0
    li t1, 100
    for_int:
        bge t0, t1, 1f

        sw t0, (a0)

        addi a0, a0, 4
        addi t0, t0, 1
        j for_int
    1:

    mv a0, sp
    jal mystery_function_int

    addi sp, sp, 400

    lw ra, (sp)
    addi sp, sp, 16
    ret

fill_array_short:
    addi sp, sp, -16
    sw ra, (sp)

    addi sp, sp, -200

    mv a0, sp
    li t0, 0
    li t1, 100
    for_short:
        bge t0, t1, 1f

        sh t0, (a0)

        addi a0, a0, 2
        addi t0, t0, 1
        j for_short
    1:

    mv a0, sp
    jal mystery_function_short

    addi sp, sp, 200

    lw ra, (sp)
    addi sp, sp, 16
    ret

fill_array_char:
    addi sp, sp, -16
    sw ra, (sp)

    addi sp, sp, -100

    mv a0, sp
    li t0, 0
    li t1, 100
    for_char:
        bge t0, t1, 1f

        sb t0, (a0)

        addi a0, a0, 1
        addi t0, t0, 1
        j for_char
    1:

    mv a0, sp
    jal mystery_function_char

    addi sp, sp, 100

    lw ra, (sp)
    addi sp, sp, 16
    ret
