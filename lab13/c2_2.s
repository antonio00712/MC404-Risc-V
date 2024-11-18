.global middle_value_int
.global middle_value_short
.global middle_value_char
.global value_matrix

middle_value_int:

    li t0, 2
    div a1, a1, t0
    li t0, 4
    mul a1, a1, t0

    add a0, a0, a1
    lw a0, (a0)
    ret

middle_value_short:

    li t0, 2
    div a1, a1, t0
    li t0, 2
    mul a1, a1, t0

    add a0, a0, a1
    lh a0, (a0)
    ret

middle_value_char:

    li t0, 2
    div a1, a1, t0

    add a0, a0, a1
    lb a0, (a0)
    ret

value_matrix:

    li t0, 42
    mul a1, a1, t0
    add a1, a1, a2
    li t0, 4
    mul a1, a1, t0

    add a0, a0, a1
    lw a0, (a0)
    ret
