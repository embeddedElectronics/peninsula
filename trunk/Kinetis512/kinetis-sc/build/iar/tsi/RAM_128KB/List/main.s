///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      04/Mar/2012  17:42:28 /
// IAR ANSI C/C++ Compiler V6.10.1.22143/W32 EVALUATION for ARM               /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\tsi\ /
//                    main.c                                                  /
//    Command line =  "F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\tsi /
//                    \main.c" -D IAR -D TWR_K60N512 -lCN "F:\My              /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\RAM_128KB /
//                    \List\" -lB "F:\My Works\K60\Kinetis512\kinetis-sc\buil /
//                    d\iar\tsi\RAM_128KB\List\" -o "F:\My                    /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\RAM_128KB /
//                    \Obj\" --no_cse --no_unroll --no_inline                 /
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
//    List file    =  F:\My Works\K60\Kinetis512\kinetis-sc\build\iar\tsi\RAM /
//                    _128KB\List\main.s                                      /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME main

        EXTERN GPIO_Init
        EXTERN TSI_Init
        EXTERN TSI_SelfCalibration

        PUBLIC main

// F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\tsi\main.c
//    1 /*
//    2  * File:		main.c
//    3  * Purpose:		TSI Example
//    4  *
//    5  *                      Toggle the LED's on the tower board by pressing the TSI
//    6  *                        touch pads
//    7  *
//    8  */
//    9 
//   10 #include "common.h"
//   11 #include "TSI.h"
//   12 #include "misc.h"
//   13 
//   14 void GPIO_Init(void);
//   15 
//   16 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//   17 void main (void)
//   18 {
main:
        PUSH     {R7,LR}
//   19   TSI_Init();
        BL       TSI_Init
//   20   GPIO_Init();
        BL       GPIO_Init
//   21   TSI_SelfCalibration();
        BL       TSI_SelfCalibration
//   22 
//   23   START_SCANNING;
        LDR.N    R0,??main_0      ;; 0x40045000
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x2
        LDR.N    R1,??main_0      ;; 0x40045000
        STR      R0,[R1, #+0]
//   24   ENABLE_EOS_INT;
        LDR.N    R0,??main_0      ;; 0x40045000
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x50
        LDR.N    R1,??main_0      ;; 0x40045000
        STR      R0,[R1, #+0]
//   25   ENABLE_TSI;
        LDR.N    R0,??main_0      ;; 0x40045000
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.N    R1,??main_0      ;; 0x40045000
        STR      R0,[R1, #+0]
//   26 
//   27   while(1)
??main_1:
        B.N      ??main_1
        DATA
??main_0:
        DC32     0x40045000
//   28   {
//   29 
//   30   }
//   31 }

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
//   32 /********************************************************************/
//   33 
// 
// 56 bytes in section .text
// 
// 56 bytes of CODE memory
//
//Errors: none
//Warnings: none
