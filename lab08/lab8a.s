.data
input_file: .asciz "image.pgm"
image: .skip 0x4000f  # buffer

.text
.global _start
_start:
    jal open
    jal read

    la a3, image
    addi a3, a3, 3
    jal getSize
    jal setCanvasSize

    addi a3, a3, 4
    mv s0, a0
    mv s1, a1

    li s2, 0 # s2 = j
    li s3, 0 # s3 = i
    for_i:
        bge s3, s1, 1f
        for_j:
            bge s2, s0, 2f
            addi a3, a3, 1
            lbu a2, (a3)
            slli t0, a2, 24
            slli t1, a2, 16
            slli t2, a2, 8
            li a2, 255
            or a2, a2, t0
            or a2, a2, t1
            or a2, a2, t2
            
            mv a0, s2
            mv a1, s3
            jal setPixel

            addi s2, s2, 1
            j for_j
        2:
        li s2, 0
        addi s3, s3, 1
        j for_i
    1:

    jal close

    li a0, 0
    li a7, 93
    ecall

getSize:
    li a0, 0
    li a1, 0
    li t0, ' '
    li t4, 10
    li t1, 1

    # num 1
    lb t2, 1(a3)
    beq t0, t2, 1f

    mul t1, t1, t4
    lb t2, 2(a3)
    beq t0, t2, 1f

    mul t1, t1, t4

    1:
    lb t2, 0(a3)
    addi t2, t2, -48
    mul t2, t2, t1
    add a0, a0, t2
    div t1, t1, t4
    addi a3, a3, 1
    bne t1, x0, 1b

    # num 2
    li t0, '\n'
    li t1, 1
    addi a3, a3, 1

    lb t2, 1(a3)
    beq t0, t2, 1f

    mul t1, t1, t4
    lb t2, 2(a3)
    beq t0, t2, 1f

    mul t1, t1, t4

    1:
    lb t2, 0(a3)
    addi t2, t2, -48
    mul t2, t2, t1
    add a1, a1, t2
    div t1, t1, t4
    addi a3, a3, 1
    bne t1, x0, 1b
    ret


setCanvasSize:
    li a7, 2201
    ecall
    ret

setPixel:
    li a7, 2200 # syscall setPixel (2200)
    ecall
    ret

/*
setScaling:
    li a0, 1 # scale
    li a1, 1
    li a7, 2201
    ecall
    ret
*/

read:
    la a1, image #  buffer to write the data
    li a2, 262159  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    ret

open:
    la a0, input_file    # address for the file path
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # mode
    li a7, 1024          # syscall open
    ecall
    ret

close:
    li a0, 3             # file descriptor (fd) 3
    li a7, 57            # syscall close
    ecall
    ret
