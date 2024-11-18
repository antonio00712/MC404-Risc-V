.globl exit
exit:
    li a0, 0
    li a7, 93                       # exit
    ecall

.text
.set GPS, 0xFFFF0100
.set POS_X, 0xFFFF0110
.set TURN, 0xFFFF0120
.set GAS, 0xFFFF0121
.set HAND_BREAK, 0xFFFF0122

.global _start
_start:

    li t0, 1
    li a0, GPS
    sb t0, (a0)
    0:
    lb a1, (a0)
    bnez a1, 0b

    li t0, 1
    li a0, GAS
    sb t0, (a0)

    li t1, -75
    li a0, TURN
    sb t1, (a0)

    # curva
    1:
    
    li t0, 1
    li a0, GPS
    sb t0, (a0)
    0:
    lb a1, (a0)
    bnez a1, 0b

    li a0, POS_X
    lw a1, (a0)
    li t0, 174
    bgt a1, t0, 1b

    # fim da curva

    li a0, TURN
    sb zero, (a0)

    1:
    
    li t0, 1
    li a0, GPS
    sb t0, (a0)
    0:
    lb a1, (a0)
    bnez a1, 0b

    li a0, POS_X
    lw a1, (a0)
    li t0, 90
    bgt a1, t0, 1b

    # fim de reta
    
    li t0, 0
    li a0, GAS
    sb t0, (a0)

    li t0, 1
    li a0, HAND_BREAK
    sb t0, (a0)

    jal exit