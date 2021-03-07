/* Entry Point */
ENTRY(Reset_Handler)

_bstack = 0x20000000;
_estack = 0x20010000; /* end of RAM */

/* Generate a link error if heap and stack don't fit into RAM */
_Min_Heap_Size = 0x200;  /* required amount of heap  */
_Min_Stack_Size = 0x400; /* required amount of stack */

/* Specify the memory areas */
MEMORY {
	FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 256K
	SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 64K
}

/* 
 * Initial 32K Flash is used to store kernel functions and
 * initial 512 bytes of RAM is used to store kernel data. 
 */
__privileged_functions_region_size__  = 32K;
__privileged_data_region_size__       = 512;

__FLASH_segment_start__               = ORIGIN(FLASH);
__FLASH_segment_end__                 = __FLASH_segment_start__ + LENGTH(FLASH);

__SRAM_segment_start__                = ORIGIN(SRAM);
__SRAM_segment_end__                  = __SRAM_segment_start__ + LENGTH(SRAM);

__privileged_functions_start__        = __FLASH_segment_start__;
__privileged_functions_end__          = __FLASH_segment_start__ + __privileged_functions_region_size__;

__privileged_data_start__             = __SRAM_segment_start__;
__privileged_data_end__               = __SRAM_segment_start__ + __privileged_data_region_size__;


/* Define output sections */
SECTIONS {
	/* 
	 * The startup code and FreeRTOS kernel code are placed into privileged
	 * flash. 
	 */
	.privileged_functions : {
		. = ALIGN(4);
		KEEP(*(.isr_vector)) /* Startup code */
		. = ALIGN(4);
		*(privileged_functions)
		. = ALIGN(4);
		
		. = __privileged_functions_region_size__;
	} > FLASH
	
	/* 
	 * The rest of the program code and other data into the remaining
	 * unprivileged flash. 
	 */
	.text : {
        /* Place the FreeRTOS System Calls first in the unprivileged region. */
		. = ALIGN(4);
		__syscalls_flash_start__ = .;
		*(freertos_system_calls)
		__syscalls_flash_end__ = .;
		. = ALIGN(4);
		*(.text)           /* .text sections (code). */
		*(.text*)          /* .text* sections (code). */
		*(.glue_7)         /* glue arm to thumb code. */
		*(.glue_7t)        /* glue thumb to arm code. */
		*(.eh_frame)

		KEEP (*(.init))
		KEEP (*(.fini))

		. = ALIGN(4);
		_etext = .;        /* define a global symbols at end of code. */
	} > FLASH
	
	/* Constant data into "FLASH" Rom type memory. */
	.rodata : {
		. = ALIGN(4);
		*(.rodata)         /* .rodata sections (constants, strings, etc.). */
		*(.rodata*)        /* .rodata* sections (constants, strings, etc.). */
		. = ALIGN(4);
	} > FLASH

	.ARM.extab : { 
		. = ALIGN(4);
		*(.ARM.extab* .gnu.linkonce.armextab.*)
		. = ALIGN(4);
	} > FLASH

	.ARM : {
		. = ALIGN(4);
		__exidx_start = .;
		*(.ARM.exidx*)
		__exidx_end = .;
		. = ALIGN(4);
	} > FLASH
	
	/* Used by the startup to initialize data. */
	_sidata = LOADADDR(.privileged_data);

	/* FreeRTOS kernel data. */
	.privileged_data : {
		. = ALIGN(4);
		_sdata = .;        /* Create a global symbol at data start. */
		*(privileged_data)
		. = ALIGN(4);
		. = __privileged_data_region_size__;
	} > SRAM AT> FLASH

	/* Initialized data sections into "RAM" Ram type memory. */
	.data : {
		. = ALIGN(4);
		*(.data)           /* .data sections. */
		*(.data*)          /* .data* sections. */

		. = ALIGN(4);
		_edata = .;        /* define a global symbol at data end. */
	} > SRAM AT> FLASH
	
	/* Uninitialized data section into "RAM" Ram type memory. */
	. = ALIGN(4);
	.bss : {
		/* This is used by the startup in order to initialize the .bss section. */
		_sbss = .;         /* define a global symbol at bss start. */
		__bss_start__ = _sbss;
		*(.bss)
		*(.bss*)
		*(COMMON)

		. = ALIGN(4);
		_ebss = .;         /* define a global symbol at bss end. */
		__bss_end__ = _ebss;
	} > SRAM

	/* 
	 * User_heap_stack section, used to check that there is enough "RAM" Ram
	 * type memory left. 
	 */
	._user_heap_stack : {
		. = ALIGN(8);
		PROVIDE (end = .);
		PROVIDE (_end = .);
		. = . + _Min_Heap_Size;
		. = . + _Min_Stack_Size;
		. = ALIGN(8);
	} > SRAM

	/* Remove information from the compiler libraries. */
	/DISCARD/ : {
		libc.a (*)
		libm.a (*)
		libgcc.a (*)
	}

	.ARM.attributes 0 : { *(.ARM.attributes) }
}
