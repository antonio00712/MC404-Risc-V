.data
.global _system_time
_system_time: .word 0

.bss
.align 4
isr_stack: .skip 1024
isr_stack_end:

.text
.set GPT_INTERRUPTION, 0xFFFF0108
.set MIDI_CH, 0xFFFF0300
.set MIDI_INST, 0xFFFF0302
.set MIDI_NOTE, 0xFFFF0304
.set MIDI_VEL, 0xFFFF0305
.set MIDI_DUR, 0xFFFF0306

.global play_note
.global _start
_start:
    la t0, isr_stack_end
    csrw mscratch, t0

    la t0, main_isr
    csrw mtvec, t0 

    csrr t0, mie # read the mie register
    li t2, 0x800 # set the MEIE field (bit 11)
    or t1, t1, t2
    csrw mie, t1 # update the mie register
    
    # Enable global interrupts (mstatus.MIE <= 1)
    csrr t0, mstatus # read the mstatus register
    ori t0, t0, 0x8 # set MIE field (bit 3)
    csrw mstatus, t0

    # start gpt interruptions
    li t0, 100
    li a0, GPT_INTERRUPTION
    sw t0, (a0)

    jal main
    
    ret

play_note:

    # setting configs
    li t0, MIDI_INST
    sh a1, (t0)
    li t0, MIDI_NOTE
    sb a2, (t0)
    li t0, MIDI_VEL
    sb a3, (t0)
    li t0, MIDI_DUR
    sh a4, (t0)

    li t0, MIDI_CH  # starts playing
    sb a0, (t0)

    ret

.align 2
main_isr:
    # Save the context
    csrrw sp, mscratch, sp # exchange sp with mscratch
    addi sp, sp, -64 # allocate space at the ISR stack
    sw a0, 0(sp) # save 
    sw t0, 4(sp)

    # Handles the interrupt
    la a0, _system_time
    lw t0, (a0)
    addi t0, t0, 100
    sw t0, (a0)

    li t0, 100
    li a0, GPT_INTERRUPTION
    sw t0, (a0)

    lw a0, 0(sp) # restore
    lw t0, 4(sp)
    addi sp, sp, 64 # deallocate space from the ISR stack
    csrrw sp, mscratch, sp # exchange sp with mscratch
    mret