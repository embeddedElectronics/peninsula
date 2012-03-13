///////////////////////////////////////////////////////////////////////////////
//                                                                            /
// IAR ANSI C/C++ Compiler V6.10.1.52143/W32 for ARM    07/Jan/2012  15:09:51 /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  G:\K60\Kinetis512\kinetis-sc\src\common\io.c            /
//    Command line =  G:\K60\Kinetis512\kinetis-sc\src\common\io.c -D IAR -D  /
//                    TWR_K60N512 -lCN G:\K60\Kinetis512\kinetis-sc\build\iar /
//                    \demo\RAM_128KB\List\ -lB G:\K60\Kinetis512\kinetis-sc\ /
//                    build\iar\demo\RAM_128KB\List\ -o                       /
//                    G:\K60\Kinetis512\kinetis-sc\build\iar\demo\RAM_128KB\O /
//                    bj\ --no_cse --no_unroll --no_inline --no_code_motion   /
//                    --no_tbaa --no_clustering --no_scheduling --debug       /
//                    --endian=little --cpu=Cortex-M4 -e --fpu=None           /
//                    --dlib_config "D:\Program Files\IAR Systems\Embedded    /
//                    Workbench 6.0\arm\INC\c\DLib_Config_Normal.h" -I        /
//                    G:\K60\Kinetis512\kinetis-sc\build\iar\demo\..\..\..\sr /
//                    c\projects\demo\ -I G:\K60\Kinetis512\kinetis-sc\build\ /
//                    iar\demo\..\..\..\src\common\ -I                        /
//                    G:\K60\Kinetis512\kinetis-sc\build\iar\demo\..\..\..\sr /
//                    c\cpu\ -I G:\K60\Kinetis512\kinetis-sc\build\iar\demo\. /
//                    .\..\..\src\cpu\headers\ -I                             /
//                    G:\K60\Kinetis512\kinetis-sc\build\iar\demo\..\..\..\sr /
//                    c\drivers\uart\ -I G:\K60\Kinetis512\kinetis-sc\build\i /
//                    ar\demo\..\..\..\src\drivers\mcg\ -I                    /
//                    G:\K60\Kinetis512\kinetis-sc\build\iar\demo\..\..\..\sr /
//                    c\drivers\wdog\ -I G:\K60\Kinetis512\kinetis-sc\build\i /
//                    ar\demo\..\..\..\src\platforms\ -I                      /
//                    G:\K60\Kinetis512\kinetis-sc\build\iar\demo\..\ -Ol     /
//                    --use_c++_inline                                        /
//    List file    =  G:\K60\Kinetis512\kinetis-sc\build\iar\demo\RAM_128KB\L /
//                    ist\io.s                                                /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME io

        EXTERN uart_getchar
        EXTERN uart_getchar_present
        EXTERN uart_putchar

        PUBLIC char_present
        PUBLIC in_char
        PUBLIC out_char

// G:\K60\Kinetis512\kinetis-sc\src\common\io.c
//    1 /*
//    2  * File:		io.c
//    3  * Purpose:		Serial Input/Output routines
//    4  *
//    5  * Notes:       TERMINAL_PORT defined in <board>.h
//    6  */
//    7 
//    8 #include "common.h"
//    9 #include "uart.h"
//   10 
//   11 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   12 char
//   13 in_char (void)
//   14 {
in_char:
        PUSH     {R7,LR}
//   15 	return uart_getchar(TERM_PORT);
        LDR.N    R0,??DataTable2  ;; 0x400eb000
        BL       uart_getchar
        POP      {R1,PC}          ;; return
//   16 }
//   17 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   18 void
//   19 out_char (char ch)
//   20 {
out_char:
        PUSH     {R7,LR}
//   21 	uart_putchar(TERM_PORT, ch);
        MOVS     R1,R0
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        LDR.N    R0,??DataTable2  ;; 0x400eb000
        BL       uart_putchar
//   22 }
        POP      {R0,PC}          ;; return
//   23 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   24 int
//   25 char_present (void)
//   26 {
char_present:
        PUSH     {R7,LR}
//   27 	return uart_getchar_present(TERM_PORT);
        LDR.N    R0,??DataTable2  ;; 0x400eb000
        BL       uart_getchar_present
        POP      {R1,PC}          ;; return
//   28 }

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2:
        DC32     0x400eb000

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
//   29 /********************************************************************/
// 
// 38 bytes in section .text
// 
// 38 bytes of CODE memory
//
//Errors: none
//Warnings: none
