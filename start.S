#define S3C2440_MPLL_200MHZ     ((0x5c<<12)|(0x01<<4)|(0x02))
#define MEM_CTL_BASE    0x48000000
#define WDT_CTL_BASE    0x53000000
#define CLK_CTL_BASE    0x4c000014

.text
.global _start
_start:

/* 1. �ؿ��Ź� */
	ldr r0, =WDT_CTL_BASE //0x53000000Ϊ���Ź��Ĵ�����ַ
	mov r1, #0
	str r1, [r0]


/* 2. ��������ʱ�� */
	ldr r0, =CLK_CTL_BASE
	mov r1, #0x03; //FCLK:HCLK:PCLK=1:2:4, HDIVN=1,PDIVN=1
	str r1, [r0]

	/* ���HDIVN��0��CPU������ģʽӦ�ôӡ�fast bus mode����Ϊ��asynchronous bus mode�� */
    mcr p15, 0, r1, c1, c0, 0	/* �������ƼĴ��� */
    orr r1, r1, #0xc0000000  	/* r1��0xc0000000�������� ����Ϊ��asynchronous bus mode�� */
    mcr p15, 0, r1, c1, c0, 0	/* д����ƼĴ��� */

    /* MPLLCON = S3C2440_MPLL_200MHZ */
	ldr r0, =0x4c000004
	ldr r1, =S3C2440_MPLL_200MHZ
	str r1, [r0]

/* 3. ��ʼ��SDRAM */
	ldr r0,=MEM_CTL_BASE
	adr r1,sdram_config /* sdram_config�ĵ�ǰ��ַ */
	add r3, r0,#(13*4)

1:
	ldr r2, [r1], #4 //��r1��ַ�ϵ�ֵȡ��r2�� ֮��r1��ַ��4
	str r2, [r0], #4 //��r2��ֵд��r0��ָ��ĵ�ַ��֮��r0��ַ��4
	cmp r0, r3		 //r0��r3�Ƚ�
	bne 1b           //���r0С��r3 ���ش���֮ǰ��1���λ��
	
/* 4. �ض�λ : ��bootloader�����Ĵ����flash���Ƶ��������ӵ�ַȥ */
	ldr sp, =0x34000000 //����ջ

	bl nand_init

	mov r0, #0
	ldr r1, =_start      //__bss_start����ʼ��ַ - _start����ʼ��ַ �õ�����Ρ����ݶΡ�ֻ�����ݶεĳ���
	ldr r2, =__bss_start
	sub r2,r2,r1    //r2-r1 ���¸�ֵ��r2

	bl copy_code_to_sdram // �������뵽sdram r0 r1 r2 ��������copy_code_to_sdram����������
	bl clear_bss

	
/* 5. ִ��main */
	ldr lr, =halt
	ldr pc, =main

halt:
	b halt



//sdram��ؼĴ�����ַ
sdram_config:
	.long 0x22011110	 //BWSCON  //����һ�������� ��Ϊ������ռ�
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
