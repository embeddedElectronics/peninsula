///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      06/Mar/2012  12:46:34 /
// IAR ANSI C/C++ Compiler V6.10.1.22143/W32 EVALUATION for ARM               /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  F:\My Works\K60\Kinetis512\kinetis-sc\src\cpu\sysinit.c /
//    Command line =  "F:\My Works\K60\Kinetis512\kinetis-sc\src\cpu\sysinit. /
//                    c" -D IAR -D TWR_K60N512 -lCN "F:\My                    /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\RAM_64KB /
//                    \List\" -lB "F:\My Works\K60\Kinetis512\kinetis-sc\buil /
//                    d\iar\gpio\RAM_64KB\List\" -o "F:\My                    /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\RAM_64KB /
//                    \Obj\" --no_cse --no_unroll --no_inline                 /
//                    --no_code_motion --no_tbaa --no_clustering              /
//                    --no_scheduling --debug --endian=little                 /
//                    --cpu=Cortex-M4 -e --char_is_signed --fpu=None          /
//                    --dlib_config "D:\Program Files\IAR Systems\Embedded    /
//                    Workbench 6.0 Evaluation\arm\INC\c\DLib_Config_Normal.h /
//                    " -I "F:\My Works\K60\Kinetis512\kinetis-sc\build\iar\g /
//                    pio\..\..\..\src\projects\gpio\" -I "F:\My              /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\..\..\.. /
//                    \src\common\" -I "F:\My Works\K60\Kinetis512\kinetis-sc /
//                    \build\iar\gpio\..\..\..\src\cpu\" -I "F:\My            /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\..\..\.. /
//                    \src\cpu\headers\" -I "F:\My                            /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\..\..\.. /
//                    \src\drivers\uart\" -I "F:\My                           /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\..\..\.. /
//                    \src\drivers\mcg\" -I "F:\My                            /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\..\..\.. /
//                    \src\drivers\wdog\" -I "F:\My                           /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\..\..\.. /
//                    \src\platforms\" -I "F:\My                              /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\..\"     /
//                    -Ol --use_c++_inline                                    /
//    List file    =  F:\My Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\RA /
//                    M_64KB\List\sysinit.s                                   /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME sysinit

        EXTERN pll_init
        EXTERN uart_init

        PUBLIC core_clk_khz
        PUBLIC core_clk_mhz
        PUBLIC fb_clk_init
        PUBLIC periph_clk_khz
        PUBLIC sysinit
        PUBLIC trace_clk_init

// F:\My Works\K60\Kinetis512\kinetis-sc\src\cpu\sysinit.c
//    1 /*
//    2  * File:        sysinit.c
//    3  * Purpose:     Kinetis Configuration
//    4  *              Initializes processor to a default state
//    5  *
//    6  * Notes:
//    7  *
//    8  */
//    9 
//   10 #include "common.h"
//   11 #include "sysinit.h"
//   12 #include "uart.h"
//   13 #include "k60_tower.h"
//   14 
//   15 /********************************************************************/
//   16 
//   17 /* Actual system clock frequency */

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   18 int core_clk_khz;
core_clk_khz:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   19 int core_clk_mhz;
core_clk_mhz:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   20 int periph_clk_khz;
periph_clk_khz:
        DS8 4
//   21 
//   22 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   23 void sysinit (void)
//   24 {
sysinit:
        PUSH     {R7,LR}
//   25         /*
//   26          * Enable all of the port clocks. These have to be enabled to configure
//   27          * pin muxing options, so most code will need all of these on anyway.
//   28          */
//   29         SIM_SCGC5 |= (SIM_SCGC5_PORTA_MASK
//   30                       | SIM_SCGC5_PORTB_MASK
//   31                       | SIM_SCGC5_PORTC_MASK
//   32                       | SIM_SCGC5_PORTD_MASK
//   33                       | SIM_SCGC5_PORTE_MASK );
        LDR.N    R0,??DataTable2  ;; 0x40048038
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3E00
        LDR.N    R1,??DataTable2  ;; 0x40048038
        STR      R0,[R1, #+0]
//   34 
//   35  	/* Ramp up the system clock */
//   36 	core_clk_mhz = pll_init(CORE_CLK_MHZ, REF_CLK);
        MOVS     R1,#+3
        MOVS     R0,#+2
        BL       pll_init
        LDR.N    R1,??DataTable2_1
        STR      R0,[R1, #+0]
//   37 
//   38 	/*
//   39          * Use the value obtained from the pll_init function to define variables
//   40 	 * for the core clock in kHz and also the peripheral clock. These
//   41 	 * variables can be used by other functions that need awareness of the
//   42 	 * system frequency.
//   43 	 */
//   44 	core_clk_khz = core_clk_mhz * 1000;
        LDR.N    R0,??DataTable2_1
        LDR      R0,[R0, #+0]
        MOV      R1,#+1000
        MULS     R0,R1,R0
        LDR.N    R1,??DataTable2_2
        STR      R0,[R1, #+0]
//   45   	periph_clk_khz = core_clk_khz / (((SIM_CLKDIV1 & SIM_CLKDIV1_OUTDIV2_MASK) >> 24)+ 1);
        LDR.N    R0,??DataTable2_2
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable2_3  ;; 0x40048044
        LDR      R1,[R1, #+0]
        UBFX     R1,R1,#+24,#+4
        ADDS     R1,R1,#+1
        UDIV     R0,R0,R1
        LDR.N    R1,??DataTable2_4
        STR      R0,[R1, #+0]
//   46 
//   47   	/* For debugging purposes, enable the trace clock and/or FB_CLK so that
//   48   	 * we'll be able to monitor clocks and know the PLL is at the frequency
//   49   	 * that we expect.
//   50   	 */
//   51 	trace_clk_init();
        BL       trace_clk_init
//   52   	fb_clk_init();
        BL       fb_clk_init
//   53 
//   54   	/* Enable the pins for the selected UART */
//   55          if (TERM_PORT == UART0_BASE_PTR)
//   56          {
//   57             /* Enable the UART0_TXD function on PTD6 */
//   58             PORTD_PCR6 = PORT_PCR_MUX(0x3); // UART is alt3 function for this pin
//   59 
//   60             /* Enable the UART0_RXD function on PTD7 */
//   61             PORTD_PCR7 = PORT_PCR_MUX(0x3); // UART is alt3 function for this pin
//   62          }
//   63 
//   64          if (TERM_PORT == UART1_BASE_PTR)
//   65   	 {
//   66                  /* Enable the UART1_TXD function on PTC4 */
//   67   		PORTC_PCR4 = PORT_PCR_MUX(0x3); // UART is alt3 function for this pin
//   68 
//   69   		/* Enable the UART1_RXD function on PTC3 */
//   70   		PORTC_PCR3 = PORT_PCR_MUX(0x3); // UART is alt3 function for this pin
//   71   	}
//   72 
//   73   	if (TERM_PORT == UART2_BASE_PTR)
//   74   	{
//   75                  /* Enable the UART2_TXD function on PTD3 */
//   76   		PORTD_PCR3 = PORT_PCR_MUX(0x3); // UART is alt3 function for this pin
//   77 
//   78   		/* Enable the UART2_RXD function on PTD2 */
//   79   		PORTD_PCR2 = PORT_PCR_MUX(0x3); // UART is alt3 function for this pin
//   80   	}
//   81 
//   82   	if (TERM_PORT == UART3_BASE_PTR)
//   83   	{
//   84                  /* Enable the UART3_TXD function on PTC17 */
//   85   		PORTC_PCR17 = PORT_PCR_MUX(0x3); // UART is alt3 function for this pin
//   86 
//   87   		/* Enable the UART3_RXD function on PTC16 */
//   88   		PORTC_PCR16 = PORT_PCR_MUX(0x3); // UART is alt3 function for this pin
//   89   	}
//   90   	if (TERM_PORT == UART4_BASE_PTR)
//   91   	{
//   92                  /* Enable the UART3_TXD function on PTC17 */
//   93   		PORTE_PCR24 = PORT_PCR_MUX(0x3); // UART is alt3 function for this pin
//   94 
//   95   		/* Enable the UART3_RXD function on PTC16 */
//   96   		PORTE_PCR25 = PORT_PCR_MUX(0x3); // UART is alt3 function for this pin
//   97   	}
//   98   	if (TERM_PORT == UART5_BASE_PTR)
//   99   	{
//  100                  /* Enable the UART3_TXD function on PTC17 */
//  101   		PORTE_PCR8 = PORT_PCR_MUX(0x3); // UART is alt3 function for this pin
        LDR.N    R0,??DataTable2_5  ;; 0x4004d020
        MOV      R1,#+768
        STR      R1,[R0, #+0]
//  102 
//  103   		/* Enable the UART3_RXD function on PTC16 */
//  104   		PORTE_PCR9 = PORT_PCR_MUX(0x3); // UART is alt3 function for this pin
        LDR.N    R0,??DataTable2_6  ;; 0x4004d024
        MOV      R1,#+768
        STR      R1,[R0, #+0]
//  105   	}
//  106   	/* UART0 and UART1 are clocked from the core clock, but all other UARTs are
//  107          * clocked from the peripheral clock. So we have to determine which clock
//  108          * to send to the uart_init function.
//  109          */
//  110         if ((TERM_PORT == UART0_BASE_PTR) | (TERM_PORT == UART1_BASE_PTR))
//  111             uart_init (TERM_PORT, core_clk_khz, TERMINAL_BAUD);
//  112         else
//  113   	    uart_init (TERM_PORT, periph_clk_khz, TERMINAL_BAUD);
        MOVS     R2,#+115200
        LDR.N    R0,??DataTable2_4
        LDR      R1,[R0, #+0]
        LDR.N    R0,??DataTable2_7  ;; 0x400eb000
        BL       uart_init
//  114 }
        POP      {R0,PC}          ;; return
//  115 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  116 void trace_clk_init(void)
//  117 {
//  118 	/* Set the trace clock to the core clock frequency */
//  119 	SIM_SOPT2 |= SIM_SOPT2_TRACECLKSEL_MASK;
trace_clk_init:
        LDR.N    R0,??DataTable2_8  ;; 0x40048004
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1000
        LDR.N    R1,??DataTable2_8  ;; 0x40048004
        STR      R0,[R1, #+0]
//  120 
//  121 	/* Enable the TRACE_CLKOUT pin function on PTA6 (alt7 function) */
//  122 	PORTA_PCR6 = ( PORT_PCR_MUX(0x7));
        LDR.N    R0,??DataTable2_9  ;; 0x40049018
        MOV      R1,#+1792
        STR      R1,[R0, #+0]
//  123 }
        BX       LR               ;; return
//  124 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  125 void fb_clk_init(void)
//  126 {
//  127 	/* Enable the clock to the FlexBus module */
//  128         SIM_SCGC7 |= SIM_SCGC7_FLEXBUS_MASK;
fb_clk_init:
        LDR.N    R0,??DataTable2_10  ;; 0x40048040
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable2_10  ;; 0x40048040
        STR      R0,[R1, #+0]
//  129 
//  130  	/* Enable the FB_CLKOUT function on PTC3 (alt5 function) */
//  131 	PORTC_PCR3 = ( PORT_PCR_MUX(0x5));
        LDR.N    R0,??DataTable2_11  ;; 0x4004b00c
        MOV      R1,#+1280
        STR      R1,[R0, #+0]
//  132 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2:
        DC32     0x40048038

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_1:
        DC32     core_clk_mhz

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_2:
        DC32     core_clk_khz

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_3:
        DC32     0x40048044

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_4:
        DC32     periph_clk_khz

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_5:
        DC32     0x4004d020

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_6:
        DC32     0x4004d024

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_7:
        DC32     0x400eb000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_8:
        DC32     0x40048004

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_9:
        DC32     0x40049018

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_10:
        DC32     0x40048040

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_11:
        DC32     0x4004b00c

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
//  133 /********************************************************************/
// 
//  12 bytes in section .bss
// 194 bytes in section .text
// 
// 194 bytes of CODE memory
//  12 bytes of DATA memory
//
//Errors: none
//Warnings: 3
