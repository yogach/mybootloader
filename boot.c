

void main(void)
{

    void (*theKernel)(int zero, int arch, unsigned int params);
	volatile unsigned int *p = (volatile unsigned int *)0x30008000;

	/* 0. ���ں����ô���: �ں������Ŀ�ʼ���ֻ�Ӵ��ڴ�ӡһЩ��Ϣ,�����ں�һ��ʼû�г�ʼ������ */
	uart0_init();
	
	/* 1. ��NAND FLASH����ں˶����ڴ� */

	/* 2. ���ò��� */

	
	/* 3. ��ת���ں˿�ʼ��ִַ�� */
    theKernel = (void (*)(int , int , unsigned int ))0x30008000;
	


	/* ���һ������, ����ִ�е����� */

}
