
.data
input1: .skip 0xc  # buffer
input2: .skip 0x14  # buffer

.text
.global _start
_start:

    # ----------- line 1

    jal readln1
    
    # --- Yb
    la a1, input1
    lb t4, 0(a1)
    li t5, '+'
    addi a1, a1, 1
    jal str_to_int

    beq t4, t5, 1f  # if the number is positive, jump to 1
    li t6, -1
    mul a3, a3, t6
    1:
    mv s2, a3

    # --- Xc

    la a1, input1
    lb t4, 6(a1)
    li t5, '+'
    addi a1, a1, 7
    jal str_to_int

    beq t4, t5, 1f  # if the number is positive, jump to 1
    li t6, -1
    mul a3, a3, t6
    1:
    mv s3, a3

    # ----------- line 2

    jal readln2

    la a1, input2
    jal str_to_int
    mv s4, a3

    la a1, input2
    add a1, a1, 5
    jal str_to_int
    mv s5, a3

    la a1, input2
    add a1, a1, 10
    jal str_to_int
    mv s6, a3

    la a1, input2
    add a1, a1, 15
    jal str_to_int
    mv s7, a3

    # --- Da(s4), Db(s5) and Dc(s6) 

    li t1, 10

    li t0, 3
    sub t2, s7, s4
    mul t0, t0, t2
    div t0, t0, t1
    mv s4, t0

    li t0, 3
    sub t2, s7, s5
    mul t0, t0, t2
    div t0, t0, t1
    mv s5, t0

    li t0, 3
    sub t2, s7, s6
    mul t0, t0, t2
    div t0, t0, t1
    mv s6, t0

    # --- Y

    mul s10, s2, s2 # s10 = s2*s2
    mul t0, s4, s4 # t0 = s4*s4
    add s10, s10, t0
    mul t0, s5, s5 # t0 = s5*s5
    sub s10, s10, t0
    li t0, 2
    mul t0, t0, s2
    div s10, s10, t0 # s10 == Y

    # --- X

    mul s11, s4, s4 # s11 = s4*s4
    mul t0, s10, s10
    sub s11, s11, t0 # s11 == x²
    mv a3, s11
    jal sqrt # a3 == x
    mv s11, a3

    # --- x or -x ?

    mul t0, a3, a3 # t0 = x²
    mul t1, s10, s10 # t1 = y²
    add t0, t0, t1
    mul t1, s3, s3 # t1 = Xc²
    add t0, t0, t1
    
    li t1, -2
    mul t1, t1, a3
    mul t1, t1, s3 # t1 = -2x*Xc

    mv t5, t0
    add t0, t0, t1 # t0, +x
    li t4, -1
    mul t1, t1, t4
    add t5, t5, t1 # t5, -x

    mul t3, s6, s6 # Dc²
    sub t0, t0, t3
    sub t5, t5, t3

    bge t0, x0, 1f
    mul t0, t0, t4 # *-1
    1:
    bge t5, x0, 1f
    mul t5, t5, t4 # *-1
    1:

    blt t0, t5, 1f # if t0 < t5 jump to 1

    li t1, -1
    mul s11, s11, t1 # s11 == -x
    1:

    # ---

    # s10 == Y, s11 == X
    la a1, input1
    mv a3, s11
    jal int_to_str

    la a1, input1
    addi a1, a1, 6 
    mv a3, s10
    jal int_to_str

    jal write

    li a0, 0
    li a7, 93
    ecall

sqrt:
    li a2, 2
    div t0, a3, a2
    li t2, 1
    li t3, 20

aprox:
    div t1, a3, t0
    add t1, t1, t0
    div t0, t1, a2

    addi t2, t2, 1
    bne t2, t3, aprox  # repeat until t2 == 10

    mv a3, t0
    ret

str_to_int:
    li a3, 0

    lb t0, 0(a1)
    addi t0, t0, -48
    li t1, 1000
    mul t0, t0, t1
    add a3, a3, t0

    lb t0, 1(a1)
    addi t0, t0, -48
    li t1, 100
    mul t0, t0, t1
    add a3, a3, t0

    lb t0, 2(a1)
    addi t0, t0, -48
    li t1, 10
    mul t0, t0, t1
    add a3, a3, t0

    lb t0, 3(a1)
    addi t0, t0, -48
    add a3, a3, t0
    ret

int_to_str:

    li t1, 10
    
    li t2, '+'
    sb t2, 0(a1)

    li t0, 0
    bge a3, t0, 1f
    li t0, -1
    mul a3, a3, t0
    li t2, '-'
    sb t2, 0(a1)

    1:
    rem t0, a3, t1
    addi t0, t0, 48
    sb t0, 4(a1)
    div a3, a3, t1

    rem t0, a3, t1
    addi t0, t0, 48
    sb t0, 3(a1)
    div a3, a3, t1

    rem t0, a3, t1
    addi t0, t0, 48
    sb t0, 2(a1)
    div a3, a3, t1

    rem t0, a3, t1
    addi t0, t0, 48
    sb t0, 1(a1)
    ret

readln1:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input1 #  buffer to write the data
    li a2, 12  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    ret
readln2:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input2 #  buffer to write the data
    li a2, 20  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, input1       # buffer
    li a2, 12           # size
    li a7, 64           # syscall write (64)
    ecall
    ret
