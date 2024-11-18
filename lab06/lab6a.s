
.data
input: .skip 0x14  # buffer

.text
.global _start
_start:

    jal ra, read

    la a1, input
    jal ra, str_to_int
    jal ra, sqrt
    jal ra, int_to_str

    la a1, input
    add a1, a1, 5
    jal ra, str_to_int
    jal ra, sqrt
    jal ra, int_to_str

    la a1, input
    add a1, a1, 10
    jal ra, str_to_int
    jal ra, sqrt
    jal ra, int_to_str

    la a1, input
    add a1, a1, 15
    jal ra, str_to_int
    jal ra, sqrt
    jal ra, int_to_str

    jal ra, write

    li a0, 0
    li a7, 93
    ecall

sqrt:
    li a2, 2
    div t0, a3, a2
    li t2, 1
    li t3, 10

aprox:
    div t1, a3, t0
    add t1, t1, t0
    div t0, t1, a2

    addi t2, t2, 1
    bne t2, t3, aprox  # repeat until t2 == 10

    mv a3, t0
    jr ra

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
    jr ra

int_to_str:

    li t1, 10
    
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
    div a3, a3, t1

    rem t0, a3, t1
    addi t0, t0, 48
    sb t0, 0(a1)
    jr ra

read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input #  buffer to write the data
    li a2, 20  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    jr ra

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, input       # buffer
    li a2, 20           # size
    li a7, 64           # syscall write (64)
    ecall
    jr ra
