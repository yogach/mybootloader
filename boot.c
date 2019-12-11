

void main(void)
{

    void (*theKernel)(int zero, int arch, unsigned int params);
	volatile unsigned int *p = (volatile unsigned int *)0x30008000;

	/* 0. 帮内核设置串口: 内核启动的开始部分会从串口打印一些信息,但是内核一开始没有初始化串口 */
	uart0_init();
	
	/* 1. 从NAND FLASH里把内核读入内存 */

	/* 2. 设置参数 */

	
	/* 3. 跳转到内核开始地址执行 */
    theKernel = (void (*)(int , int , unsigned int ))0x30008000;
	


	/* 如果一切正常, 不会执行到这里 */

}
