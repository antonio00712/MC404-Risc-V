prog.x: lab7.o
	ld.lld lab7.o -o prog.x

lab7.o: lab7.s
	clang-17 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lab7.s -c -o lab7.o
