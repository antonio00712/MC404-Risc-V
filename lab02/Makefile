prog.x: prog.o
	ld.lld prog.o -o prog.x

prog.o: prog.s
	clang-17 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax prog.s -c -o prog.o
