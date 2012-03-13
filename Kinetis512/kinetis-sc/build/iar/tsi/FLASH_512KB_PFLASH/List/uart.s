///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      04/Mar/2012  17:42:42 /
// IAR ANSI C/C++ Compiler V6.10.1.22143/W32 EVALUATION for ARM               /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  F:\My Works\K60\Kinetis512\kinetis-sc\src\drivers\uart\ /
//                    uart.c                                                  /
//    Command line =  "F:\My Works\K60\Kinetis512\kinetis-sc\src\drivers\uart /
//                    \uart.c" -D IAR -D TWR_K60N512 -lCN "F:\My              /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\FLASH_512 /
//                    KB_PFLASH\List\" -lB "F:\My                             /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\FLASH_512 /
//                    KB_PFLASH\List\" -o "F:\My                              /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\FLASH_512 /
//                    KB_PFLASH\Obj\" --no_cse --no_unroll --no_inline        /
//                    --no_code_motion --no_tbaa --no_clustering              /
//                    --no_scheduling --debug --endian=little                 /
//                    --cpu=Cortex-M4 -e --fpu=None --dlib_config             /
//                    "D:\Program Files\IAR Systems\Embedded Workbench 6.0    /
//                    Evaluation\arm\INC\c\DLib_Config_Normal.h" -I "F:\My    /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\..\..\..\ /
//                    src\projects\tsi\" -I "F:\My                            /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\..\..\..\ /
//                    src\common\" -I "F:\My Works\K60\Kinetis512\kinetis-sc\ /
//                    build\iar\tsi\..\..\..\src\cpu\" -I "F:\My              /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\..\..\..\ /
//                    src\cpu\headers\" -I "F:\My                             /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\..\..\..\ /
//                    src\drivers\uart\" -I "F:\My                            /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\..\..\..\ /
//                    src\drivers\mcg\" -I "F:\My                             /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\..\..\..\ /
//                    src\drivers\wdog\" -I "F:\My                            /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\..\..\..\ /
//                    src\platforms\" -I "F:\My Works\K60\Kinetis512\kinetis- /
//                    sc\build\iar\tsi\..\" -Ol --use_c++_inline              /
//    List file    =  F:\My Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\FLA /
//                    SH_512KB_PFLASH\List\uart.s                             /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME uart

        PUBLIC uart_getchar
        PUBLIC uart_getchar_present
        PUBLIC uart_init
        PUBLIC uart_putchar

// F:\My Works\K60\Kinetis512\kinetis-sc\src\drivers\uart\uart.c
//    1 /*
//    2  * File:        uart.c
//    3  * Purpose:     Provide common UART routines for serial IO
//    4  *
//    5  * Notes:       
//    6  *              
//    7  */
//    8 
//    9 #include "common.h"
//   10 #include "uart.h"
//   11 
//   12 /********************************************************************/
//   13 /*
//   14  * Initialize the UART for 8N1 operation, interrupts disabled, and
//   15  * no hardware flow-control
//   16  *
//   17  * NOTE: Since the UARTs are pinned out in multiple locations on most
//   18  *       Kinetis devices, this driver does not enable UART pin functions.
//   19  *       The desired pins should be enabled before calling this init function.
//   20  *
//   21  * Parameters:
//   22  *  uartch      UART channel to initialize
//   23  *  sysclk      UART module Clock in kHz(used to calculate baud)
//   24  *  baud        UART baud rate
//   25  */

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   26 void uart_init (UART_MemMapPtr uartch, int sysclk, int baud)
//   27 {
uart_init:
        PUSH     {R4,R5}
//   28     register uint16 sbr, brfa;
//   29     uint8 temp;
//   30     
//   31 	/* Enable the clock to the selected UART */    
//   32     if(uartch == UART0_BASE_PTR)
        LDR.N    R3,??DataTable0  ;; 0x4006a000
        CMP      R0,R3
        BNE.N    ??uart_init_0
//   33 		SIM_SCGC4 |= SIM_SCGC4_UART0_MASK;
        LDR.N    R3,??DataTable0_1  ;; 0x40048034
        LDR      R3,[R3, #+0]
        ORRS     R3,R3,#0x400
        LDR.N    R4,??DataTable0_1  ;; 0x40048034
        STR      R3,[R4, #+0]
        B.N      ??uart_init_1
//   34     else
//   35     	if (uartch == UART1_BASE_PTR)
??uart_init_0:
        LDR.N    R3,??DataTable0_2  ;; 0x4006b000
        CMP      R0,R3
        BNE.N    ??uart_init_2
//   36 			SIM_SCGC4 |= SIM_SCGC4_UART1_MASK;
        LDR.N    R3,??DataTable0_1  ;; 0x40048034
        LDR      R3,[R3, #+0]
        ORRS     R3,R3,#0x800
        LDR.N    R4,??DataTable0_1  ;; 0x40048034
        STR      R3,[R4, #+0]
        B.N      ??uart_init_1
//   37     	else
//   38     		if (uartch == UART2_BASE_PTR)
??uart_init_2:
        LDR.N    R3,??DataTable0_3  ;; 0x4006c000
        CMP      R0,R3
        BNE.N    ??uart_init_3
//   39     			SIM_SCGC4 |= SIM_SCGC4_UART2_MASK;
        LDR.N    R3,??DataTable0_1  ;; 0x40048034
        LDR      R3,[R3, #+0]
        ORRS     R3,R3,#0x1000
        LDR.N    R4,??DataTable0_1  ;; 0x40048034
        STR      R3,[R4, #+0]
        B.N      ??uart_init_1
//   40     		else
//   41     			if(uartch == UART3_BASE_PTR)
??uart_init_3:
        LDR.N    R3,??DataTable0_4  ;; 0x4006d000
        CMP      R0,R3
        BNE.N    ??uart_init_4
//   42     				SIM_SCGC4 |= SIM_SCGC4_UART3_MASK;
        LDR.N    R3,??DataTable0_1  ;; 0x40048034
        LDR      R3,[R3, #+0]
        ORRS     R3,R3,#0x2000
        LDR.N    R4,??DataTable0_1  ;; 0x40048034
        STR      R3,[R4, #+0]
        B.N      ??uart_init_1
//   43     			else
//   44     				if(uartch == UART4_BASE_PTR)
??uart_init_4:
        LDR.N    R3,??DataTable0_5  ;; 0x400ea000
        CMP      R0,R3
        BNE.N    ??uart_init_5
//   45     					SIM_SCGC1 |= SIM_SCGC1_UART4_MASK;
        LDR.N    R3,??DataTable0_6  ;; 0x40048028
        LDR      R3,[R3, #+0]
        ORRS     R3,R3,#0x400
        LDR.N    R4,??DataTable0_6  ;; 0x40048028
        STR      R3,[R4, #+0]
        B.N      ??uart_init_1
//   46     				else
//   47     					SIM_SCGC1 |= SIM_SCGC1_UART5_MASK;
??uart_init_5:
        LDR.N    R3,??DataTable0_6  ;; 0x40048028
        LDR      R3,[R3, #+0]
        ORRS     R3,R3,#0x800
        LDR.N    R4,??DataTable0_6  ;; 0x40048028
        STR      R3,[R4, #+0]
//   48                                 
//   49     /* Make sure that the transmitter and receiver are disabled while we 
//   50      * change settings.
//   51      */
//   52     UART_C2_REG(uartch) &= ~(UART_C2_TE_MASK
//   53 				| UART_C2_RE_MASK );
??uart_init_1:
        LDRB     R3,[R0, #+3]
        ANDS     R3,R3,#0xF3
        STRB     R3,[R0, #+3]
//   54 
//   55     /* Configure the UART for 8-bit mode, no parity */
//   56     UART_C1_REG(uartch) = 0;	/* We need all default settings, so entire register is cleared */
        MOVS     R3,#+0
        STRB     R3,[R0, #+2]
//   57     
//   58     /* Calculate baud settings */
//   59     sbr = (uint16)((sysclk*1000)/(baud * 16));
        MOV      R3,#+1000
        MUL      R3,R3,R1
        LSLS     R4,R2,#+4
        SDIV     R3,R3,R4
//   60         
//   61     /* Save off the current value of the UARTx_BDH except for the SBR field */
//   62     temp = UART_BDH_REG(uartch) & ~(UART_BDH_SBR(0x1F));
        LDRB     R4,[R0, #+0]
        ANDS     R4,R4,#0xE0
//   63     
//   64     UART_BDH_REG(uartch) = temp |  UART_BDH_SBR(((sbr & 0x1F00) >> 8));
        UXTH     R3,R3            ;; ZeroExt  R3,R3,#+16,#+16
        LSRS     R5,R3,#+8
        ANDS     R5,R5,#0x1F
        ORRS     R4,R5,R4
        STRB     R4,[R0, #+0]
//   65     UART_BDL_REG(uartch) = (uint8)(sbr & UART_BDL_SBR_MASK);
        STRB     R3,[R0, #+1]
//   66     
//   67     /* Determine if a fractional divider is needed to get closer to the baud rate */
//   68     brfa = (((sysclk*32000)/(baud * 16)) - (sbr * 32));
        MOV      R4,#+32000
        MULS     R1,R4,R1
        LSLS     R2,R2,#+4
        SDIV     R1,R1,R2
        UXTH     R3,R3            ;; ZeroExt  R3,R3,#+16,#+16
        SUBS     R1,R1,R3, LSL #+5
//   69     
//   70     /* Save off the current value of the UARTx_C4 register except for the BRFA field */
//   71     temp = UART_C4_REG(uartch) & ~(UART_C4_BRFA(0x1F));
        LDRB     R2,[R0, #+10]
        ANDS     R4,R2,#0xE0
//   72     
//   73     UART_C4_REG(uartch) = temp |  UART_C4_BRFA(brfa);    
        ANDS     R1,R1,#0x1F
        ORRS     R1,R1,R4
        STRB     R1,[R0, #+10]
//   74 
//   75     /* Enable receiver and transmitter */
//   76 	UART_C2_REG(uartch) |= (UART_C2_TE_MASK
//   77 				| UART_C2_RE_MASK );
        LDRB     R1,[R0, #+3]
        ORRS     R1,R1,#0xC
        STRB     R1,[R0, #+3]
//   78 }
        POP      {R4,R5}
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable0:
        DC32     0x4006a000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable0_1:
        DC32     0x40048034

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable0_2:
        DC32     0x4006b000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable0_3:
        DC32     0x4006c000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable0_4:
        DC32     0x4006d000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable0_5:
        DC32     0x400ea000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable0_6:
        DC32     0x40048028
//   79 /********************************************************************/
//   80 /*
//   81  * Wait for a character to be received on the specified UART
//   82  *
//   83  * Parameters:
//   84  *  channel      UART channel to read from
//   85  *
//   86  * Return Values:
//   87  *  the received character
//   88  */

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   89 char uart_getchar (UART_MemMapPtr channel)
//   90 {
//   91     /* Wait until character has been received */
//   92     while (!(UART_S1_REG(channel) & UART_S1_RDRF_MASK));
uart_getchar:
??uart_getchar_0:
        LDRB     R1,[R0, #+4]
        LSLS     R1,R1,#+26
        BPL.N    ??uart_getchar_0
//   93     
//   94     /* Return the 8-bit data from the receiver */
//   95     return UART_D_REG(channel);
        LDRB     R0,[R0, #+7]
        BX       LR               ;; return
//   96 }
//   97 /********************************************************************/
//   98 /*
//   99  * Wait for space in the UART Tx FIFO and then send a character
//  100  *
//  101  * Parameters:
//  102  *  channel      UART channel to send to
//  103  *  ch			 character to send
//  104  */ 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  105 void uart_putchar (UART_MemMapPtr channel, char ch)
//  106 {
//  107     /* Wait until space is available in the FIFO */
//  108     while(!(UART_S1_REG(channel) & UART_S1_TDRE_MASK));
uart_putchar:
??uart_putchar_0:
        LDRB     R2,[R0, #+4]
        LSLS     R2,R2,#+24
        BPL.N    ??uart_putchar_0
//  109     
//  110     /* Send the character */
//  111     UART_D_REG(channel) = (uint8)ch;
        STRB     R1,[R0, #+7]
//  112  }
        BX       LR               ;; return
//  113 /********************************************************************/
//  114 /*
//  115  * Check to see if a character has been received
//  116  *
//  117  * Parameters:
//  118  *  channel      UART channel to check for a character
//  119  *
//  120  * Return values:
//  121  *  0       No character received
//  122  *  1       Character has been received
//  123  */

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  124 int uart_getchar_present (UART_MemMapPtr channel)
//  125 {
//  126     return (UART_S1_REG(channel) & UART_S1_RDRF_MASK);
uart_getchar_present:
        LDRB     R0,[R0, #+4]
        ANDS     R0,R0,#0x20
        BX       LR               ;; return
//  127 }

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
//  128 /********************************************************************/
//  129     
// 
// 260 bytes in section .text
// 
// 260 bytes of CODE memory
//
//Errors: none
//Warnings: none
