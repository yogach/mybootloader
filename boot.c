

int main(void)
{

    void (*theKernel)(int zero, int arch, unsigned int params);
	volatile unsigned int *p = (volatile unsigned int *)0x30008000;

	/* 0. ���ں����ô���: �ں������Ŀ�ʼ���ֻ�Ӵ��ڴ�ӡһЩ��Ϣ,�����ں�һ��ʼû�г�ʼ������ */
	uart0_init();
	
	/* 1. ��NAND FLASH����ں˶����ڴ� */
	puts("Copy kernel from nand\n\r");
	nand_read(0x60000+64, (unsigned char * )0x30008000, 0x200000) //�ں���ʼ��ַΪ0x60000 +64Ϊ�������ں�ͷ��
	puthex(0x1234abcd);

	/* 2. ���ò��� tag */
	puts("Set boot params\n\r");

	
	/* 3. ��ת���ں˿�ʼ��ִַ�� */
	puts("Boot kernel\n\r");
    theKernel = (void (*)(int , int , unsigned int ))0x30008000;
	theKernel(0,362,0x30000100); //362����s3c2440���ں��еı�� 0x30000100Ϊtag�洢����ʼ��ַ


	/* ���һ������, ����ִ�е����� */
	return -1;
}
