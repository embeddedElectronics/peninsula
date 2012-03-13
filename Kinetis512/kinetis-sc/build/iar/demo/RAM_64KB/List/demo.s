///////////////////////////////////////////////////////////////////////////////
//                                                                            /
// IAR ANSI C/C++ Compiler V6.10.1.52143/W32 for ARM    23/Jan/2012  15:55:52 /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  G:\K60\Kinetis512\kinetis-sc\src\projects\demo\demo.c   /
//    Command line =  G:\K60\Kinetis512\kinetis-sc\src\projects\demo\demo.c   /
//                    -D IAR -D TWR_K60N512 -lCN                              /
//                    G:\K60\Kinetis512\kinetis-sc\build\iar\demo\RAM_64KB\Li /
//                    st\ -lB G:\K60\Kinetis512\kinetis-sc\build\iar\demo\RAM /
//                    _64KB\List\ -o G:\K60\Kinetis512\kinetis-sc\build\iar\d /
//                    emo\RAM_64KB\Obj\ --no_cse --no_unroll --no_inline      /
//                    --no_code_motion --no_tbaa --no_clustering              /
//                    --no_scheduling --debug --endian=little                 /
//                    --cpu=Cortex-M4 -e --fpu=None --dlib_config             /
//                    "D:\Program Files\IAR Systems\Embedded Workbench        /
//                    6.0\arm\INC\c\DLib_Config_Normal.h" -I                  /
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
//    List file    =  G:\K60\Kinetis512\kinetis-sc\build\iar\demo\RAM_64KB\Li /
//                    st\demo.s                                               /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME demo

        EXTERN in_char
        EXTERN out_char
        EXTERN printf

        PUBLIC main

// G:\K60\Kinetis512\kinetis-sc\src\projects\demo\demo.c
//    1 /*
//    2  * File:		demo.c
//    3  * Purpose:		Main process
//    4  *
//    5  */
//    6 
//    7 #include "common.h"
//    8 
//    9 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   10 void main (void)
//   11 {
main:
        PUSH     {R7,LR}
//   12 	char ch;
//   13                 
//   14   	printf("\nHello World!!\n");
        ADR.W    R0,`?<Constant "\\nHello World!!\\n">`
        BL       printf
//   15 
//   16 	while(1)
//   17 	{
//   18 		ch = in_char();
??main_0:
        BL       in_char
//   19 		out_char(ch);
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BL       out_char
        B.N      ??main_0
//   20 	} 
//   21 }

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "\\nHello World!!\\n">`:
        ; Initializer data, 16 bytes
        DC8 10, 72, 101, 108, 108, 111, 32, 87, 111, 114
        DC8 108, 100, 33, 33, 10, 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
//   22 /********************************************************************/
// 
// 38 bytes in section .text
// 
// 38 bytes of CODE memory
//
//Errors: none
//Warnings: none
