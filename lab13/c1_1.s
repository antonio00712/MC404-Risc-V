.data
my_var: .word 10

.global my_var
.global increment_my_var
increment_my_var:

    la a0, my_var
    lw t0, (a0)
    addi t0, t0, 1
    sw t0, (a0)

    ret