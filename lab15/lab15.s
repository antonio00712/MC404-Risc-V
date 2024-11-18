.data
pos_x: .skip 0x4
pos_y: .skip 0x4
pos_z: .skip 0x4

.bss
.align 4
isr_stack: .skip 1024
isr_stack_end:

.text
.set GPS, 0xFFFF0100
.set POS_X, 0xFFFF0110
.set POS_Y, 0xFFFF0114
.set POS_Z, 0xFFFF0118
.set TURN, 0xFFFF0120
.set GAS, 0xFFFF0121
.set HAND_BREAK, 0xFFFF0122

.align 4
int_handler:
    csrrw sp, mscratch, sp # exchange sp with mscratch
    addi sp, sp, -64 # allocate space at the ISR stack
    sw t0, 0(sp) # save 

    # <= Implement your syscall handler here
    
    # checa a7 para saber qual syscall: 10, 11, 15
    li t0, 10
    beq t0, a7, 1f
    li t0, 11
    beq t0, a7, 2f
    li t0, 15
    beq t0, a7, 3f

    1: # syscall_set_engine_and_steering

        li t0, -1
        blt a0, t0, invalid_parameter
        li t0, 1
        bgt a0, t0, invalid_parameter
        li t0, -127
        blt a1, t0, invalid_parameter
        li t0, 127
        bgt a1, t0, invalid_parameter
        j valid_parameter

        invalid_parameter:
            li a0, -1
            j out_syscall

        valid_parameter:

        li t0, GAS
        sb a0, (t0)

        li t0, TURN
        sb a1, (t0)

        li a0, 0

        j out_syscall
    2: # syscall_set_hand_brake

        li t0, HAND_BREAK
        sb a0, (t0)

        j out_syscall
    3: # syscall_get_position

        li t1, 1
        li t0, GPS
        sb t1, (t0)
        0:
        lb t1, (t0)
        bnez t1, 0b

        li t0, POS_X
        lw t1, (t0)
        sw t1, (a0)
        li t0, POS_Y
        lw t1, (t0)
        sw t1, (a1)
        li t0, POS_Z
        lw t1, (t0)
        sw t1, (a2)

    out_syscall: 

    csrr t0, mepc  # load return address (address of the instruction that invoked the syscall)
    addi t0, t0, 4 # adds 4 to the return address (to return after ecall)
    csrw mepc, t0  # stores the return address back on mepc

    # restore
    lw t0, 0(sp)
    addi sp, sp, 64 # deallocate space from the ISR stack
    csrrw sp, mscratch, sp # exchange sp with mscratch
    mret

.globl _start
_start:
    la t0, isr_stack_end
    csrw mscratch, t0

    la t0, int_handler  # Load the address of the routine that will handle interrupts
    csrw mtvec, t0      # (and syscalls) on the register MTVEC to set the interrupt array.

    csrr t1, mstatus # update the mstatus.MPP
    ori t1, t1, 8
    csrw mstatus, t1
    
    la t0, user_main # load the user software
    csrw mepc, t0 # entry point into mepc

    mret 

.globl control_logic
control_logic:

    li a0, 1
    li a1, -75
    li a7, 10
    ecall

    # curva
    1:
    
    la a0, pos_x
    la a1, pos_y
    la a2, pos_z
    li a7, 15
    ecall

    lw a0, (a0)
    li t0, 174
    bgt a0, t0, 1b

    # fim da curva
    li a0, 1
    li a1, 0
    li a7, 10
    ecall

    # reta
    1:
    
    la a0, pos_x
    la a1, pos_y
    la a2, pos_z
    li a7, 15
    ecall

    lw a0, (a0)
    li t0, 100
    bgt a0, t0, 1b

    # fim da reta
    li a0, 0
    li a1, 0
    li a7, 10
    ecall

    # freio de mao
    li a0, 1
    li a7, 11
    ecall

    ret
