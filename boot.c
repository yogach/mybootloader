

int main(void)
{

    void (*theKernel)(int zero, int arch, unsigned int params);
	volatile unsigned int *p = (volatile unsigned int *)0x30008000;

	/* 0. 帮内核设置串口: 内核启动的开始部分会从串口打印一些信息,但是内核一开始没有初始化串口 */
	uart0_init();
	
	/* 1. 从NAND FLASH里把内核读入内存 */
	puts("Copy kernel from nand\n\r");
	nand_read(0x60000+64, (unsigned char * )0x30008000, 0x200000) //内核起始地址为0x60000 +64为了跳过内核头部
	puthex(0x1234abcd);

	/* 2. 设置参数 tag */
	puts("Set boot params\n\r");

	
	/* 3. 跳转到内核开始地址执行 */
	puts("Boot kernel\n\r");
    theKernel = (void (*)(int , int , unsigned int ))0x30008000;
	theKernel(0,362,0x30000100); //362代表s3c2440在内核中的编号 0x30000100为tag存储的起始地址


	/* 如果一切正常, 不会执行到这里 */
	return -1;
}
