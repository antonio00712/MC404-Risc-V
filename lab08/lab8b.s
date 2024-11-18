.data
input_file: .asciz "image.pgm"
w: .skip 0x24
image: .skip 0x4000f  # buffer


.text
.global _start
_start:

    # set w
    la a0, w
    li t0, -1
    li t1, 8
    sw t0, 0(a0)
    sw t0, 4(a0)
    sw t0, 8(a0)
    sw t0, 12(a0)
    sw t1, 16(a0)
    sw t0, 20(a0)
    sw t0, 24(a0)
    sw t0, 28(a0)
    sw t0, 32(a0)

    jal open
    jal read

    la a3, image
    addi a3, a3, 3
    jal getSize
    jal setCanvasSize

    addi a3, a3, 4
    mv s0, a0 # m
    mv s1, a1 # n

    li s2, 0 # s2 = j
    li s3, 0 # s3 = i
    for_i:
        bge s3, s1, 1f
        for_j:
            bge s2, s0, 2f
            addi a3, a3, 1
            lbu a2, (a3)

            # se for algum pixel da borda
            beq s3, x0, 1f
            beq s2, x0, 1f
            addi t0, s1, -1
            beq s3, t0, 1f
            addi t0, s0, -1
            beq s2, t0, 1f
            j filtro
            # pinta de preto
            1:
            li a2, 0
            j pixelSet

            filtro:
            # aplica filtro
            li s4, 2
            la a4, w
            li s5, 0
            li s6, 0
            li t4, 0
            # t6 = Min[i-1][j-1]
            mv t6, a3
            sub t6, t6, s0
            addi t6, t6, -1
            for_k:
                bgt s6, s4, 5f
                for_q:
                    bgt s5, s4, 6f
                    
                    # w[k][q] = t5
                    li t5, -1
                    li t2, 1
                    bne s6, t2, jump
                    bne s5, t2, jump
                    li t5, 8

                    jump:
                    # Min[i+k-1][j+q-1] = t0
                    lbu t0, (t6)
                    addi t6, t6, 1

                    mul t5, t5, t0
                    add t4, t4, t5

                    addi s5, s5, 1
                    jal for_q
                6:
                li s5, 0

                add t6, t6, s0
                addi t6, t6, -3

                addi s6, s6, 1
                jal for_k
            5:
            teste:
            li t0, 255
            ble t4, t0, 7f
            li t4, 255
            7:
            bge t4, x0, 8f
            li t4, 0
            8:

            mv a2, t4

            pixelSet:
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
