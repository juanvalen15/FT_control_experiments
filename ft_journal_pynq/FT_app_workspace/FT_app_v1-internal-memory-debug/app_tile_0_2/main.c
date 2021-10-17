#include <stdio.h>
#include <stdlib.h>
#include <memmap.h>
#include <stdint.h>
#include <xil_printf.h>

int main ( void )
{
	volatile uint64_t *timer = 0x00FC0000;
	uint64_t t_iter=*timer;
	while(1){
		t_iter=*timer;
		asm("sleep");
	}
    return 0;
}
