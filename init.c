/* NAND FLASH控制器 */
#define NFCONF  (*((volatile unsigned long *)0x4E000000))
#define NFCONT (*((volatile unsigned long *)0x4E000004))
#define NFCMMD (*((volatile unsigned char *)0x4E000008))
#define NFADDR (*((volatile unsigned char *)0x4E00000C))
#define NFDATA (*((volatile unsigned char *)0x4E000010))
#define NFSTAT (*((volatile unsigned char *)0x4E000020))

/* GPIO */
#define GPHCON		(*(volatile unsigned long *)0x56000070)
#define GPHUP       (*(volatile unsigned long *)0x56000078)

/* UART registers*/
#define ULCON0      (*(volatile unsigned long *)0x50000000)
#define UCON0       (*(volatile unsigned long *)0x50000004)
#define UFCON0      (*(volatile unsigned long *)0x50000008)
#define UMCON0      (*(volatile unsigned long *)0x5000000c)
#define UTRSTAT0    (*(volatile unsigned long *)0x50000010)
#define UTXH0       (*(volatile unsigned char *)0x50000020)
#define URXH0       (*(volatile unsigned char *)0x50000024)
#define UBRDIV0     (*(volatile unsigned long *)0x50000028)
#define TXD0READY   (1<<2)

int isBootFromNorFlash ( void )
{
	volatile int* p = ( volatile int* ) 0;
	int val;

	val = *p;
	*p = 0x12345678; //对0地址进行写操作

	if ( *p == 0x12345678 ) //如果能对0地址写值，代表是nand启动
	{
		/* 写成功, 是nand启动 */
		*p = val;
		return 0;

	}
	else
	{
		/* NOR启动不能像内存一样写 */
		return 1;
	}

}

void copy_code_to_sdram ( unsigned char* src, unsigned char* dest, unsigned int len )
{
	int i=0;

	if ( isBootFromNorFlash() )
	{
		while ( i<len )
		{
			dest[i] = src[i];
			i++;
		}

	}
	else
	{
		nand_read ( ( unsigned int ) src,dest,len );
	}

}

void clear_bss(void)
{
   extern int __bss_start, __bss_end;
   int *p = &__bss_start;

   //将__bss_start地址到__bss_end的内容清0
   for(;p< &__bss_end;p++)
   	 *p = 0;

}

void nand_init ( void )
{



}

