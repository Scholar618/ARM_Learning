	
@ ARM指令集
	@ 1.数据处理指令：	进行数学运算和逻辑运算
	@ 2.跳转指令：		实现程序的跳转，本质就是修改了PC寄存器
	@ 3.Load/Store指令：访问（读写）内存，
	@ 4.状态寄存器传送指令：用于访问（读写）CPSR寄存器
	@ 5.软中断指令：	触发软中断
	@ 6.协处理器指令：	操作协处理器的指令
	
@ ******************************************************************
	
.text			@ 表示当前为代码段
.global _start	@ 将start定义为全局符号
_start:			@ 汇编的入口
@ 1.指令：能够编译生成一条32bits机器码，并且能够直接被CPU识别和执行
	@ 1.1 数据处理指令：进行数学运算和逻辑运算
	
	@ 数据搬移指令	
	@ MOV R1,#1	@ 汇编指令
	@ MOV R2,#2
	@ MOV R3,R1
	@ MOV PC,#4
	
	@ MVN R0,#0xFF
	@ R0 = ~0xFF
	
	@ MOV R0, #0
	@ MVN R0, #0
	
	@ 立即数
	@ 立即数的本质就是包含在指令当中的数，属于指令的一部分
	@ 立即数的优点：
	@		取指时就可以读取到CPU，不用单独去内存读取，速度快
	@ 立即数的缺点：
	@		不能是任意的32位数字，有局限性
	@ MOV R0, 0x12345678	@ 不是立即数
	@ MOV R0, 0x12			@ 是立即数
	
	@ 伪指令
	@ MOV R0, 0xFFFFFFFF
	
	@ 数据运算指令格式
	@	（操作码） （目标寄存器） （第一操作寄存器） （第二操作数）
	@		操作码：		表示执行哪种操作
	@		目标寄存器：	用于存储运算的结果
	@		第一操作寄存器：存储第一个参与运算的数据（只能写寄存器）
	@		第二操作数：	第二个参与运算的数据（可以是寄存器也可以是立即数）
	
	@ 加法指令
	@ MOV R1, #5
	@ MOV R2, #3
	@ ADD R1, R2, R3
	@ R1 = R2 + R3
	@ ADD R1, R2, #5
	@ R1 = R2 + 5
	
	@ 减法指令
	@ SUB R1, R2, R3	
	@ R1 = R2 - R3
	@ SUB R1, R2, #4
	@ R1 = R2 - 4
	
	@ 逆向减法指令
	@ RSB R1, R2, #3
	@ R1 = 3 - R2
	
	@ 乘法指令
	@ MUL R1, R2, R3
	@ R1 = R2 * R3
	@ 乘法指令只能是两个寄存器相乘，不能有立即数
	
	@ 按位与指令（有0则0，无0才1）
	@ AND R1, R2, R3
	@ R1 = R2 & R3
	
	@ 按位或指令（有1则1，无1才0）
	@ ORR R1, R2, R3
	@ R1 = R2 | R3
	
	@ 按位异或指令（相同为0，相异为1）
	@ EOR R1, R2, R3
	@ R1 = R2 ^ R3
	
	@ 左移指令（R1 = R2向左移R3位）
	@ LSL R1, R2, R3
	@ R1 = (R2 << R3)
	
	@ 右移指令（R1 = R2向右移R3位）
	@ LSR R1, R2, R3
	@ R1 = (R2 >> R3)
	
	@ 位清零指令
	@ BIC R1, R2, #0xF
	@ 第二操作数哪一位为1，就将第一操作寄存器中的哪一位清零，然后将结果放入目标寄存器中
	
	@ 数据运算指令扩展
	@ 遇到这种情况，将后面几个操作码看作一个整体。
	@ MOV R1, R2, LSL #1
	@ R1 = (R2 << 1)
	
	@ 数据运算指令对条件位（N、Z、C、V）的影响
	@ 默认情况下，数据运算不会对条件位产生影响，
	@ 当在指令后面加后缀“S”可以影响
	@ MOV R1 ,#3
	@ SUBS R2, R1, #5
	
	@ 带进位的加法指令
	
	@ 两个64位的数据做加法运算
	@ 第一个低32位放到R1
	@ 第一个高32位放到R2
	@ 第二个低32位放到R3
	@ 第二个高32位放到R4
	@ 运算结果低32位放到R5
	@ 运算结果高32位放到R6
	
	@ 第一个数
	@ 0x00000002	00000001
	@ 第二个数
	@ 0x00000001	00000005
	
	@ MOV R1, #0x00000001
	@ MOV R2, #0x00000002
	@ MOV R3, #0x00000005
	@ MOV R4, #0x00000001
	@ ADDS R5, R1, R3
	@ ADC R6, R2, R4
	@ 本质：R6 = R2 + R4 + 'C'
	
	@ 带借位的减法指令
	
	@ 第一个数
	@ 0x00000002	00000001
	@ 第二个数
	@ 0x00000001	00000005
	
	@ MOV R1, #0x00000001
	@ MOV R2, #0x00000002
	@ MOV R3, #0x00000005
	@ MOV R4, #0x00000001
	@ SUBS R5, R1, R3
	@ SUB	 R6, R2, R4	
	@ 本质：R6 = R2 - R4 - '!C'
	
	@ 1.2 跳转指令：实现了程序的跳转，本质就是修改了PC的寄存器
	
	@ 方式一：直接修改PC寄存器中的值
	@（不建议使用，需要我们去计算绝对地址）
@ MAIN:
	@ MOV R1, #1
	@ MOV R2, #2
	@ MOV R3, #3
	@ 跳转到FUNC函数
	@ MOV PC, #0x18
	@ MOV R4, #4
	@ MOV R5, #5
@ FUNC:
	@ MOV R6, #6
	@ MOV R7, #7
	@ MOV R8, #8
	
	@ 方式二：不带返回的通过跳转指令
	@ 本质就是修改了PC寄存器，修改为跳转标号下第一条指令的地址
@ MAIN:
	@ MOV R1, #1
	@ MOV R2, #2
	@ MOV R3, #3
	@ 跳转到FUNC函数
	@ B		FUNC
	@ MOV R4, #4
	@ MOV R5, #5
@ FUNC:
	@ MOV R6, #6
	@ MOV R7, #7
	@ MOV R8, #8
	
	@ 方式三：带返回的通过跳转指令
	@ 本质就是修改了PC寄存器，修改为跳转标号下第一条指令的地址
	@ 同时将跳转指令下的一条指令，存储到LR寄存器
@ MAIN:
	@ MOV R1, #1
	@ MOV R2, #2
	@ MOV R3, #3
	@ 跳转到FUNC函数
	@ BL	FUNC
	@ MOV R4, #4
	@ MOV R5, #5
@ FUNC:
	@ MOV R6, #6
	@ MOV R7, #7
	@ MOV R8, #8
	@ MOV PC, LR
	
	@ ARM 条件的条件执行
	
	@ 比较指令
	@ CMP的本质就是一条减法指令（SUBS）只是没有将运算结果存入寄存器
	@ MOV R1, #1
	@ MOV R2, #2
	@ CMP R1, R2
	@ BEQ FUNC	@ if(EQ)(B FUNC)本质：if(Z == 1) (B FUNC)
	@ BNE FUNC	@ if(NQ)(B FUNC)本质：if(Z == 0) (B FUNC)
	@ MOV R3, #3
	@ MOV R4, #4
	@ MOV R5, #5
	
@ FUNC:
	@ MOV R6, #6
	@ MOV R7, #7
	
	@ ARM 指令集中大多数都可以带条件码后缀
	@ MOV R1, #1
	@ MOV R2, #2
	@ CMP R1, R2
	@ MOVGT R3, #3
	
@ 练习
	@ int R1 = 9;
	@ int R2 = 15;
@ START:
	@ if(R1 == R2) 
		@ STOP();
	@ else if(R1 > R2) {
		@ R1 = R1 - R2;
		@ goto START;
	@ }
	@ else {
		@ R2 = R2 - R1;
		@ goto START;
	@ }
	
	@ MOV R1, #9
	@ MOV R2, #15
@ START:
	@ CMP R1, R2
	@ BEQ stop
	@ SUBGT R1, R1, R2
	@ SUBLT R2, R2, R1
	@ B START
	
	@ 1.3 Load/Store指令：访问（读写）内存
	
	@ MOV R1, #0xFF000000
	@ MOV R2, #0x40000000
	@ 写内存(将R1寄存器的数据存储到R2指向的内存空间)
	@ STR R1, [R2]
	
	@ 读内存（将内存中R2指向的内存空间中的数据读取到R3寄存器）
	@ LDR R3, [R2]
	
	@ MOV R1, #0xFFFFFFFF
	@ MOV R2, #0x40000000
	@ STRB R1, [R2]		@ 一个字节
	@ STRH R1, [R2]		@ 两个字节
	@ STR R1, [R2] 		@ 四个字节
	
	@ 寻址方式就是CPU去寻找一个操作数的方式
	
	@ 立即寻址
	@ MOV R1, #1
	@ ADD R1, R2, #1
	
	@ 寄存器寻址
	@ ADD R1, R2, R3
	
	@ 寄存器移位寻址
	@ MOV R1, R2, LSL #1
	
	@ 寄存器间接寻址
	@ STR R1, [R2]
	
	@ 基址加变址寻址
	@ MOV R1, #0xFFFFFFFF
	@ MOV R2, #0x40000000
	@ MOV R3, #4
	@ STR R1, [R2, R3]			@ 将R1寄存器中的数据写入到R2+R3指向的内存空间
	@ STR R1, [R2, R3, LSL #1]	@ 将R1寄存器中的数据写入到R2+(R3 << 1)指向的内存空间
	
	@ 基址加变址寻址的索引方式
	@ 前索引
	@ MOV R1, #0xFFFFFFFF
	@ MOV R2, #0x40000000
	@ STR R1, [R2, #8]
	@ 将R1寄存器中的数据写入到R2+8指向的内存空间
	
	@ 后索引
	@ MOV R1, #0xFFFFFFFF
	@ MOV R2, #0x40000000
	@ STR R1, [R2], #8
	@ 将R1寄存器中的数据写入到R2指向的内存空间，然后R2自增8
	
	@ 自动索引
	@ MOV R1, #0xFFFFFFFF
	@ MOV R2, #0x40000000
	@ STR R1, [R2, #8]!
	@ 将R1寄存器中的数据写入到R2+8指向的内存空间，然后R2自增8
	
	@ 以上寻址方式和索引方式同样适合于LDR
	
	@ 多寄存器内存访问指令
	@ MOV R1, #1
	@ MOV R2, #2
	@ MOV R3, #3
	@ MOV R4, #4
	@ MOV R11, #0x40000020
	@ STM R11,{R1-R4}
	@ 将R1-R4寄存器中的数据存储到内存以R11为起始地址的内存中
	@ LDM R11,{R6-R9}
	@ 将内存中以R11为起始地址的数据读取到R6-R9寄存器中
	@ 当寄存器不连续时，使用逗号分隔
	@ STM R11, {R1, R2, R4}
	@ 不管寄存器列表中的顺序如何，存储时永远是低地址存储小标号的寄存器
	@ STM R11, {R3, R2, R1, R4}
	@ 自动索引照样适用于多寄存器内存访问指令
	@ STM R11!,(R1-R4)

	@ 多寄存器内存访问指令的寻址方式
	@ MOV R1, #1
	@ MOV R2, #2
	@ MOV R3, #3
	@ MOV R4, #4
	@ MOV R11, #0x40000020
	@ STMIA R11!, {R1-R4}
	@ STMIB R11!, {R1-R4}
	@ STMDA R11!, {R1-R4}
	@ STMDB R11!, {R1-R4}

	@ 栈的种类与使用
	@ MOV R1, #1
	@ MOV R2, #2
	@ MOV R3, #3
	@ MOV R4, #4
	@ MOV R11, #0x40000020
	@ STMDB R11!, {R1-R4}
	@ LDMIA R11!, {R6-R9}
	@ STMFD R11!, {R1-R4}
	@ LDMFD R11!, {R6-R9}

	@ 栈的应用举例
	
	@ 叶子函数的调用过程举例
	@ 初始化栈指针
	@ MOV SP, #0x40000020
	
@ MAIN:
		@ MOV R1, #3
		@ MOV R2, #5
		@ BL	FUNC
		@ ADD R3, R1, R2
		@ B stop
		
@ FUNC:
		@ 压栈保护现场
		@ STMFD SP!, {R1, R2}		@ 满减栈
		@ MOV R1, #10
		@ MOV R2, #20
		@ SUB R3, R2, R1
		@ 出栈恢复现场
		@ LDMFD SP!, {R1, R2}
		@ MOV PC, LR
		
	@ 非叶子函数的调用过程举例
	@ 初始化栈指针
	@ MOV SP, #0x40000020
	
@ MAIN:
		@ MOV R1, #3
		@ MOV R2, #5
		@ BL	FUNC1
		@ ADD R3, R1, R2
		@ B stop
		
@ FUNC1:
		@ STMFD SP!, {R1, R2, LR}		@ 满减栈
		@ MOV R1, #10
		@ MOV R2, #20
		@ BL FUNC2
		@ SUB R3, R2, R1
		@ LDMFD SP!, {R1, R2, LR}
		@ MOV PC, LR
@ FUNC2:
		@ STMFD SP!, {R1, R2}	
		@ MOV R1, #7
		@ MOV R2, #8
		@ MUL R3, R1, R2
		@ LDMFD SP!, {R1, R2}
		@ MOV PC, LR
		
	@ 1.4 状态寄存器传送指令：访问（读写）CPSR寄存器
		
		@ 读CPSR
		@ MRS R1, CPSR
		@ R1 = CPSR
		
		@ 写CPSR
		@ MSR CPSR, #0x10
		
		@ 在USER模式下不能修改CPSR， 非特权模式
		@ MSR CPSR, #0xD3

	@ 1.5 软中断指令：触发软中断
	
		@ 异常向量表
		@ B MAIN
		@ B .
		@ B SWI_HANDLE
		@ B .
		@ B .
		@ B .
		@ B .
		@ B .
		
		@ 应用程序 
@ MAIN:
		@ MOV SP, #0x40000020
		@ MSR CPSR, #0x10
		@ MOV R1, #1
		@ MOV R2, #2
		@ SWI #1
		@ ADD R3, R2, R1
		@ B stop
		
		@ 异常处理程序
@ SWI_HANDLE:
		@ STMFD SP!, {R1, R2, LR}
		@ MOV R1, #10
		@ MOV R2, #20
		@ SUB R3, R2, R1
		@ LDMFD SP!,{R1, R2, PC}^		@ ^表示将SPSR传递给CPSR，模式的恢复

	@ 1.6 协处理器指令：操控协处理器的指令
		@ 1. 协处理器数据运算指令
		@	CDP
		@ 2. 协处理器存储器访问指令
		@	STC 将协处理器中的数据存储到存储器中
		@	LDC 将存储器中的数据读取到协处理器中
		@ 3. 协处理器寄存器传送指令
		@	MRC 将协处理器中寄存器的数据传送到ARM处理器中的寄存器
		@	MCR 将ARM处理器寄存器中的数据传送到协处理器中的寄存器


stop:			@ 死循环防止跑飞
	B stop

.end			@ 汇编的结束

