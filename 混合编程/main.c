void func_c(void) {
	int a = 0;
	a--;
	
	// 写汇编语言
	asm
	(
		"MOV R6, #6\n"
		"MOV R7, #7\n"
	);
	
	a++;
	FUNC_ASM();
}
