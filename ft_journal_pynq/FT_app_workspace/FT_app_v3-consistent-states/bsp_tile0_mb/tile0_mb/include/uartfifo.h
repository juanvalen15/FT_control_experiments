#ifndef __UARTFIFO_H__
#define __UARTFIFO_H__

#include <stdint.h>

void uart_send_byte (uint32_t admin, uint8_t data);

uint8_t uart_receive_byte (uint32_t admin);

#endif //__UARTFIFO_H__
