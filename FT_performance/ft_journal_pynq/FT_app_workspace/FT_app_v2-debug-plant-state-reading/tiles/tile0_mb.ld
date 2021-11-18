/* Define Memories in the system */

MEMORY
{
   mem  : ORIGIN = 0x50,    LENGTH = 0x07FB0
   mem2 : ORIGIN = 0x8000,  LENGTH = 0x08000
   mem3 : ORIGIN = 0x10000, LENGTH = 0x08000 
   mem4 : ORIGIN = 0x18000, LENGTH = 0x08000 
}

INCLUDE ../share/von_neumann.ld
