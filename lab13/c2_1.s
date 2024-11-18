.global swap_int
.global swap_short
.global swap_char
swap_int:

    lw t0, (a0)
    lw t1, (a1)

    sw t1, (a0)
    sw t0, (a1)

    mv a0, zero
    ret

swap_short:

    lh t0, (a0)
    lh t1, (a1)

    sh t1, (a0)
    sh t0, (a1)

    mv a0, zero
    ret

swap_char:

    lb t0, (a0)
    lb t1, (a1)

    sb t1, (a0)
    sb t0, (a1)

    mv a0, zero
    ret
