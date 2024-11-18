.data
input_op: .skip 0x3  # buffer
input: .skip 0x100005  # buffer
output: .skip 0x100005  # buffer

.text
.set WRITE_STATUS, 0xFFFF0100
.set WRITE_DATA, 0xFFFF0101
.set READ_STATUS, 0xFFFF0102
.set READ_DATA, 0xFFFF0103

.global _start
_start:

    la a0, input_op
    jal gets_SP

    la a0, input
    jal gets_SP

    la a0, input_op
    lbu a1, (a0)

    li t0, '1'
    beq a1, t0, 1f
    addi t0, t0, 1  # t0 = '2'
    beq a1, t0, 2f
    addi t0, t0, 1  # t0 = '3'
    beq a1, t0, 3f
    addi t0, t0, 1  # t0 = '4'
    beq a1, t0, 4f

    1:
        la a0, input
        jal puts_SP
        j end_op
    2:
        la a0, input
        jal invert_puts
        j end_op
    3:
        la a0, input
        jal atoi
        la a1, output
        li a2, 16
        jal itoa
        jal puts_SP
        j end_op
    4:
        la a0, input
        jal atoi
        mv s0, a0  # num 1

        addi a1, a1, 1
        lbu s1, (a1) # operator

        addi a0, a1, 2
        jal atoi   # num 2

        li a3, '+'
        beq s1, a3, soma
        li a3, '-'
        beq s1, a3, subt
        li a3, '*'
        beq s1, a3, mult
        li a3, '/'
        beq s1, a3, divi

        soma:
            add a0, s0, a0
            j end_operation
        subt:
            sub a0, s0, a0
            j end_operation
        mult:
            mul a0, s0, a0
            j end_operation
        divi:
            div a0, s0, a0
            j end_operation
            
        end_operation:
            la a1, output
            li a2, 10
            jal itoa
            jal puts_SP
        j end_op

    end_op:
    jal exit


puts:
    mv a1, a0                   # a1 <- vetor        
    li a2, 1                    # a2 é a quantidade de caracteres de a1

    for_puts:
        lbu a4, (a1)
        beq a4, zero, 1f    # se a4 == NULL, acaba

        addi a2, a2, 1
        addi a1, a1, 1
        j for_puts
    1:

    li a4, '\n'
    sb a4, (a1)                 # a1 = '\n'

    mv a3, a1
    mv a1, a0
    li a0, 1                    # file descriptor = 1 (stdout)
    li a7, 64                   # syscall write (64)
    ecall

    mv a1, a3
    sb zero, (a1)               # a1 = NULL

    ret

gets:
    mv a3, a0
    mv a1, a0

    do_while:
        li a0, 0                    # file descriptor = 0 (stdin)
        li a2, 1              # size - Reads 1 byte.
        li a7, 63                   # syscall read (63)
        ecall

        lb a4, (a1)
        li t0, '\n'
        addi a1, a1, 1
        bne a4, t0, do_while

    sb zero, (a1)
    mv a0, a3
    ret

gets_SP:
    # a0 = endereço do buffer
    mv a4, a0

    do_whileSP:

        li t0, 1
        li a1, READ_STATUS
        sb t0, (a1)
        0:
        lb a2, (a1)
        bnez a2, 0b

        li a1, READ_DATA
        lb a3, (a1)
        sb a3, (a0)
        addi a0, a0, 1
        li t0, '\n'
        bne a3, t0, do_whileSP

    sb zero, (a0)
    mv a0, a4
    ret

puts_SP:

    for_putsSP:

        lb a1, (a0)
        addi a0, a0, 1
        li a2, WRITE_DATA
        sb a1, (a2)

        beqz a1, 1f  # se a1 == NULL: acaba

        li t0, 1
        li a1, WRITE_STATUS
        sb t0, (a1)
        0:
        lb a2, (a1)
        bnez a2, 0b

        j for_putsSP
    1:

    ret

invert_puts:
    mv t0, a0

    # anda com ponteiro até o fim da string
    for_conta:
        lbu a4, (t0)
        beq a4, zero, 1f    # se a4 == NULL, acaba

        addi t0, t0, 1
        j for_conta
    1:
    addi t0, t0, -2

    # imprime byte a byte voltando com o ponteiro, depois dá um \n
    for_INVputs:

        lb a1, (t0)
        addi t0, t0, -1
        li a2, WRITE_DATA
        sb a1, (a2)

        li t1, 1
        li a3, WRITE_STATUS
        sb t1, (a3)
        0:
        lb a2, (a3)
        bnez a2, 0b

        lbu a4, (a0)
        beq a1, a4, 1f  # se a1 == a0[0]: acaba

        j for_INVputs
    1:

    li a1, '\n'
    li a2, WRITE_DATA
    sb a1, (a2)

    li t0, 1
    li a1, WRITE_STATUS
    sb t0, (a1)
    0:
    lb a2, (a1)
    bnez a2, 0b

    ret

atoi:

    mv t0, a0
    li a1, 1  # sign
    lb a4, (t0)
    li t1, '-'
    bne a4, t1, 1f

    addi t0, t0, 1
    li a1, -1  # sign == '-'

    1:

    li a0, 0
    li t1, 10  # '\n' == 10
    li t3, ' '
    while_stoi:
        lb a4, (t0)
        beq a4, t1, 1f  # a4 == '\n' end while
        beq a4, t3, 1f  # a4 == ' ' end while
        beqz a4, 1f  # a4 == '\0' end while

        mul a0, a0, t1  # a0 *= 10
        addi t2, a4, -48  # t2 = a4 - '0'
        add a0, a0, t2

        addi t0, t0, 1
        j while_stoi
    1:

    mul a0, a0, a1  # a0 * sign
    mv a1, t0

    ret

itoa:  # valor, string, base

    mv t0, a1
    li t1, 0                        # posicao inicial 

    bge a0, zero, 1f       # se a0 >= 0

    li t3, '-' 
    sb t3, (t0)            # a1[0] = '-'
    li t3, -1          # t3 = -1
    li t1, 1           # t1 recebe 1, a posicao inicial do vetor
    mul a0, a0, t3                  # a0 = |a0|

    1:
    mv t4, a0                       # t4 recebe o numero a0     
    li t2, -1                       # t2 é a posicao do ultimo caractere de a0

    for_cont:  # conta a quantidade de caracteres
        addi t2, t2, 1              # t2++
        div t4, t4, a2              # t4 remove um caractere

        beq t4, zero, 1f       # se t4 = 0, sai do for
        j for_cont
    1:

    add t2, t2, t1                  # t2 += t1, soma 1 se já apareceu o -
    add t0, a1, t2                  # t0 = a1[t2]

    addi t0, t0, 1                  # t0 += 1
    li t3, '\n'
    sb t3, (t0)                    
    sb zero, 1(t0)                     # termina com \0
    addi t0, t0, -1                 # t0 -= 1

    for_itoa:
        rem a4, a0, a2              # a4 = (a0 % base)

        li t3, 9
        bgt a4, t3, 1f 

        addi a4, a4, 48             # a4 += '0'
        j 2f
        1:
        addi a4, a4, 87             # a4 += 'a' - 10
        2:

        sb a4, (t0)              # t0[0] = a4
        div a0, a0, a2              # a0 /= base

        bge t1, t2, 1f         # se t1 >= t2 sai do for
        addi t0, t0, -1             # t0 volta uma posição
        addi t2, t2, -1             # soma -1 no iterador
        j for_itoa
    1:

    mv a0, a1
    ret

exit:
    li a0, 0
    li a7, 93                       # exit
    ecall
