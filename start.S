#define S3C2440_MPLL_200MHZ     ((0x5c<<12)|(0x01<<4)|(0x02))
#define MEM_CTL_BASE    0x48000000
#define WDT_CTL_BASE    0x53000000
#define CLK_CTL_BASE    0x4c000014

.text
.global _start
_start:

/* 1. 关看门狗 */
	ldr r0, =WDT_CTL_BASE //0x53000000为看门狗寄存器地址
	mov r1, #0
	str r1, [r0]


/* 2. 设置运行时钟 */
	ldr r0, =CLK_CTL_BASE
	mov r1, #0x03; //FCLK:HCLK:PCLK=1:2:4, HDIVN=1,PDIVN=1
	str r1, [r0]

	/* 如果HDIVN非0，CPU的总线模式应该从“fast bus mode”变为“asynchronous bus mode” */
    mcr p15, 0, r1, c1, c0, 0	/* 读出控制寄存器 */
    orr r1, r1, #0xc0000000  	/* r1与0xc0000000做或运算 设置为“asynchronous bus mode” */
    mcr p15, 0, r1, c1, c0, 0	/* 写入控制寄存器 */

    /* MPLLCON = S3C2440_MPLL_200MHZ */
	ldr r0, =0x4c000004
	ldr r1, =S3C2440_MPLL_200MHZ
	str r1, [r0]

/* 3. 初始化SDRAM */
	ldr r0,=MEM_CTL_BASE
	adr r1,sdram_config /* sdram_config的当前地址 */
	add r3, r0,#(13*4)

1:
	ldr r2, [r1], #4 //将r1地址上的值取到r2中 之后r1地址加4
	str r2, [r0], #4 //将r2的值写入r0所指向的地址，之后r0地址加4
	cmp r0, r3		 //r0和r3比较
	bne 1b           //如果r0小于r3 跳回代码之前的1标号位置
	
/* 4. 重定位 : 把bootloader本身的代码从flash复制到它的链接地址去 */
	ldr sp, =0x34000000 //设置栈

	bl nand_inti

	mov r0, #0
	ldr r1, =_start      //__bss_start段起始地址 - _start程序开始地址 得到代码段、数据段、只读数据段的长度
	ldr r2, =__bss_start
	sub r2,r2,r1    //r2-r1 重新赋值给r2

	bl copy_code_to_sdram // 拷贝代码到sdram r0 r1 r2 代表传给copy_code_to_sdram的三个参数
	bl clear_bss

	
/* 5. 执行main */
	ldr lr, =halt
	ldr pc, =main

halt:
	b halt



//sdram相关寄存器地址
sdram_config:
	.long 0x22011110	 //BWSCON  //定义一个长整型 并为它分配空间
	.long 0x00000700	 //BANKCON0
	.long 0x00000700	 //BANKCON1
	.long 0x00000700	 //BANKCON2
	.long 0x00000700	 //BANKCON3  
	.long 0x00000700	 //BANKCON4
	.long 0x00000700	 //BANKCON5
	.long 0x00018005	 //BANKCON6
	.long 0x00018005	 //BANKCON7
	.long 0x008C04F4	 //REFRESH
	.long 0x000000B1	 //BANKSIZE
	.long 0x00000030	 //MRSRB6
	.long 0x00000030	 //MRSRB7

