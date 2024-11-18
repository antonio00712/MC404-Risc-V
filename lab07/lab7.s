
.data
input1: .skip 0x5  # buffer
input2: .skip 0x8  # buffer
output1: .skip 0x8  # buffer
output2: .skip 0x5  # buffer
output3: .skip 0x2  # buffer

.text
.global _start
_start:

    # ----------- line 1

    jal readln1

    la a1, input1
    la a2, output1

    li t0, '\n'
    sb t0, 7(a2)

    # --- p1
    
    lb t1, 0(a1)
    sb t1, 2(a2) # d1
    addi t1, t1, -48
    lb t2, 1(a1)
    sb t2, 4(a2) # d2
    addi t2, t2, -48
    lb t3, 2(a1)
    sb t3, 5(a2) # d3
    addi t3, t3, -48
    lb t4, 3(a1)
    sb t4, 6(a2) # d4
    addi t4, t4, -48

    xor t0, t1, t2
    xor t0, t0, t4

    addi t0, t0, 48
    sb t0, 0(a2) # p1


    # --- p2

    xor t0, t1, t3
    xor t0, t0, t4

    addi t0, t0, 48
    sb t0, 1(a2) # p2


    # --- p3

    xor t0, t2, t3
    xor t0, t0, t4

    addi t0, t0, 48
    sb t0, 3(a2) # p3

    jal write1

    # ----------- line 2

    jal readln2

    la a1, input2
    la a2, output2

    li t0, '\n'
    sb t0, 4(a2)

    lb s1, 0(a1)
    addi s1, s1, -48 # p1
    lb s2, 1(a1)
    addi s2, s2, -48 # p2
    lb s3, 3(a1)
    addi s3, s3, -48 # p3

    lb t1, 2(a1)
    sb t1, 0(a2) # d1
    addi t1, t1, -48
    lb t2, 4(a1)
    sb t2, 1(a2) # d2
    addi t2, t2, -48
    lb t3, 5(a1)
    sb t3, 2(a2) # d3
    addi t3, t3, -48
    lb t4, 6(a1)
    sb t4, 3(a2) # d4
    addi t4, t4, -48

    jal write2

    # check errors

    la a1, output3
    li t0, 48
    sb t0, 0(a1)
    li t0, '\n'
    sb t0, 1(a1)

    # check p1
    xor t0, t1, t2
    xor t0, t0, t4
    xor t0, t0, s1

    beq t0, x0, 1f
    li t0, 49
    sb t0, 0(a1)
    1:

    # check p2
    xor t0, t1, t3
    xor t0, t0, t4
    xor t0, t0, s2

    beq t0, x0, 1f
    li t0, 49
    sb t0, 0(a1)
    1:

    # check p3
    xor t0, t2, t3
    xor t0, t0, t4
    xor t0, t0, s3

    beq t0, x0, 1f
    li t0, 49
    sb t0, 0(a1)
    1:

    jal write3

    li a0, 0
    li a7, 93
    ecall

readln1:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input1 #  buffer to write the data
    li a2, 5  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    ret
readln2:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input2 #  buffer to write the data
    li a2, 8  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    ret

write1:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output1       # buffer
    li a2, 8           # size
    li a7, 64           # syscall write (64)
    ecall
    ret
write2:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output2       # buffer
    li a2, 5           # size
    li a7, 64           # syscall write (64)
    ecall
    ret
write3:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output3       # buffer
    li a2, 2           # size
    li a7, 64           # syscall write (64)
    ecall
    ret
