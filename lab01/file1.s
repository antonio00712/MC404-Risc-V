	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_zicsr2p0_zifencei2p0"
	.file	"file1.c"
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:
	addi	sp, sp, -64
	sw	ra, 60(sp)                      # 4-byte Folded Spill
	sw	s0, 56(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 64
	li	a0, 0
	sw	a0, -60(s0)                     # 4-byte Folded Spill
	sw	a0, -12(s0)
	addi	a1, s0, -22
	li	a2, 10
	call	read
	mv	a1, a0
	lw	a0, -60(s0)                     # 4-byte Folded Reload
	sw	a1, -28(s0)
	lbu	a1, -22(s0)
	addi	a1, a1, -48
	sw	a1, -32(s0)
	lbu	a1, -18(s0)
	addi	a1, a1, -48
	sw	a1, -36(s0)
	lbu	a1, -20(s0)
	sb	a1, -37(s0)
	sw	a0, -44(s0)
	lbu	a0, -37(s0)
	li	a1, 43
	bne	a0, a1, .LBB0_2
	j	.LBB0_1
.LBB0_1:
	lw	a0, -32(s0)
	lw	a1, -36(s0)
	add	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_6
.LBB0_2:
	lbu	a0, -37(s0)
	li	a1, 45
	bne	a0, a1, .LBB0_4
	j	.LBB0_3
.LBB0_3:
	lw	a0, -32(s0)
	lw	a1, -36(s0)
	sub	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_5
.LBB0_4:
	lw	a0, -32(s0)
	lw	a1, -36(s0)
	mul	a0, a0, a1
	sw	a0, -44(s0)
	j	.LBB0_5
.LBB0_5:
	j	.LBB0_6
.LBB0_6:
	lw	a0, -44(s0)
	addi	a0, a0, 48
	sb	a0, -54(s0)
	li	a2, 10
	sb	a2, -53(s0)
	li	a0, 1
	addi	a1, s0, -54
	call	write
	li	a0, 0
	lw	ra, 60(sp)                      # 4-byte Folded Reload
	lw	s0, 56(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 64
	ret
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.ident	"clang version 17.0.6 (Fedora 17.0.6-2.fc39)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym read
	.addrsig_sym write
