.global operation
operation:
    lb t0, (sp)
    lb t1, 4(sp)
    lh t2, 8(sp)
    lh t3, 12(sp)
    lw t4, 16(sp)
    lw t5, 20(sp)

    add a0, a1, a2
    sub a0, a0, a5
    add a0, a0, a7
    add a0, a0, t2
    sub a0, a0, t4

    ret
