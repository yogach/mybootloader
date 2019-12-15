SECTIONS{
     . = 0x33f80000; 	/*链接地址*/
    .text : {
            start.o (.text)
            *(.text)
            } 	/*代码段*/

     . = ALIGN(4); 	/*下一段的起始地址向4取整*/
     .rodata : {*(.rodata*)} 	/*只读数据段*/

      . = ALIGN(4);	
      .data : {*(.data)}	/*数据段*/

      . = ALIGN(4);	
      __bss_start = .;	/*bss段起始地址设为当前地址*/
      .bss : {*(.bss) *(COMMON) }	/*bss段 以及通用符号段*/
      __bss_end = .;	

}