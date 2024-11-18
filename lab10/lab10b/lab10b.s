.globl recursive_tree_search
.globl puts
.globl gets
.globl atoi
.globl itoa
.globl exit

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
    while_stoi:
        lb a4, (t0)
        beq a4, t1, 1f  # a4 == '\n' end while
        beq a4, zero, 1f  # a4 == '\0' end while

        mul a0, a0, t1  # a0 *= 10
        addi t2, a4, -48  # t2 = a4 - '0'
        add a0, a0, t2

        addi t0, t0, 1
        j while_stoi
    1:

    mul a0, a0, a1  # a0 * sign

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
    li a6, 0
    sb a6, (t0)                     # termina com \0
    addi t0, t0, -1                 # t0 -= 1

    for_itoa:
        rem a4, a0, a2              # a4 = (a0 % base)

        li t3, 9
        bgt a4, t3, 1f 

        addi a4, a4, 48             # a4 += '0'
        j 2f
        1:
        addi a4, a4, 55             # a4 += 'A' - 10
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

recursive_tree_search:
    addi sp, sp, -16
    sw ra, (sp)
    sw s0, 4(sp)

    beq a0, zero, retorna # node vazio

    lw a2, 0(a0)    # VAL
    lw a3, 4(a0)     # Left
    lw a4, 8(a0)     # Right

    bne a1, a2, 1f
    # o valor é igual entao guarda a resposta e retorna
    li a0, 1
    j retorna
        
    1:
    mv s0, a4
    # a0 -> Left
    mv a0, a3
    jal recursive_tree_search

    beq a0, zero, 1f # nao achou (retornou 0)
    # achou
    addi a0, a0, 1
    j retorna

    1:
    # a0 -> Right
    mv a0, s0
    jal recursive_tree_search

    beq a0, zero, 1f # nao achou (retornou 0)
    # achou
    addi a0, a0, 1
    j retorna

    1:
    li a0, 0
    
    retorna:
    lw ra, (sp)
    lw s0, 4(sp)
    addi sp, sp, 16
    ret
