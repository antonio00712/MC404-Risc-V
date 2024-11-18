prog.x: lab8a.o
	ld.lld lab8a.o -o prog.x

lab8a.o: lab8a.s
	clang-17 --target=riscv32 -march=rv32g -mabi=ilp32d -mno-relax lab8a.s -c -o lab8a.o
