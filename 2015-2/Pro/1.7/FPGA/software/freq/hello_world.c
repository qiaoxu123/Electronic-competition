/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "altera_avalon_uart_regs.h"
#include "system.h"

void delay(int z)
{
	int x,y;
	for(x = z;x>0;x--)
	for(y = 110;y>0;y--);
}



int main()
{
  printf("Hello from Nios\n");
  alt_u8 txdata = 0;
  alt_u8 rxdata = 0;
  while(1)
  {
	 while(!((IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_RRDY_MSK)));
	 rxdata = IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE);
	 txdata = rxdata;
	 while(!((IORD_ALTERA_AVALON_UART_STATUS(UART_BASE) & ALTERA_AVALON_UART_STATUS_TRDY_MSK)));
	 IOWR_ALTERA_AVALON_UART_TXDATA(UART_BASE, txdata);
  }
  return 0;
}
