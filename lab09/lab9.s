
.data
input: .skip 0x7  # buffer
output: .skip 0x5  # buffer

.text
.global _start
_start:

    jal read

    la a1, input
    jal str_to_int

    la a1, head_node
    li t0, 0  # contador
    li t1, -1  # resposta

    for_ll:

        lw a2, (a1)
        addi a1, a1, 4
        lw a3, (a1)
        addi a1, a1, 4
        lw a1, (a1)

        add a2, a2, a3

        bne a0, a2, 1f 
        # a soma é igual entao guarda a resposta e sai do for
        mv t1, t0
        j outfor_ll

        1:
        beq a1, zero, outfor_ll  # não tem mais nodes
        addi t0, t0, 1
        j for_ll

    outfor_ll:

    # imprime t1 (resposta)

    mv a0, t1
    la a1, output
    jal int_to_str
    
    jal write

    li a0, 0
    li a7, 93
    ecall

str_to_int:
    
    li a2, 1  # sign
    lb t0, (a1)
    li t1, '-'
    bne t0, t1, 1f

    addi a1, a1, 1
    li a2, -1  # sign == '-'

    1:

    li a0, 0
    li t1, 10  # '\n' == 10
    while_stoi:
        lb t0, (a1)
        beq t0, t1, 1f  # t0 == '\n' end while

        mul a0, a0, t1  # a0 *= 10
        addi t2, t0, -48  # t2 = t0 - '0'
        add a0, a0, t2

        addi a1, a1, 1
        j while_stoi
    1:

    mul a0, a0, a2  # a0 * sign

    ret

int_to_str:

    bge a0, zero, 1f  # sign

    li t0, '-'
    sb t0, (a1)
    addi a1, a1, 1
    li t0, -1
    mul a0, a0, t0

    1:

    li t0, 0
    li t1, 10
    mv t2, a0
    bne t2, zero, for_cont
    li t0, 1
    for_cont:  # conta quantos digitos o numero possui
        beq t2, zero, 1f
        div t2, t2, t1
        addi t0, t0, 1
        j for_cont
    1:

    mv t2, a0
    add a1, a1, t0
    li t3, '\n'
    sb t3, 1(a1)
    for_itos:
        beq t0, zero, 1f

        rem t3, t2, t1
        addi t3, t3, 48
        sb t3, (a1)
        div t2, t2, t1

        addi a1, a1, -1
        addi t0, t0, -1
        j for_itos
    1:
    
    ret

read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input #  buffer to write the data
    li a2, 7  # size 
    li a7, 63 # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output       # buffer
    li a2, 5           # size
    li a7, 64           # syscall write (64)
    ecall
    ret
