///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      04/Mar/2012  17:42:26 /
// IAR ANSI C/C++ Compiler V6.10.1.22143/W32 EVALUATION for ARM               /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  F:\My Works\K60\Kinetis512\kinetis-sc\src\common\assert /
//                    .c                                                      /
//    Command line =  "F:\My Works\K60\Kinetis512\kinetis-sc\src\common\asser /
//                    t.c" -D IAR -D TWR_K60N512 -lCN "F:\My                  /
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
//                    _128KB\List\assert.s                                    /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME assert

        EXTERN printf

        PUBLIC ASSERT_FAILED_STR
        PUBLIC assert_failed

// F:\My Works\K60\Kinetis512\kinetis-sc\src\common\assert.c
//    1 /*
//    2  * File:        assert.c
//    3  * Purpose:     Provide macro for software assertions
//    4  *
//    5  * Notes:       ASSERT macro defined in assert.h calls assert_failed()
//    6  */
//    7 
//    8 #include "common.h"
//    9 
//   10 const char ASSERT_FAILED_STR[] = "Assertion failed in %s at line %d\n";
//   11 
//   12 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   13 void
//   14 assert_failed(char *file, int line)
//   15 {
assert_failed:
        PUSH     {R7,LR}
//   16     int i;
//   17     
//   18     printf(ASSERT_FAILED_STR, file, line);
        MOVS     R2,R1
        MOVS     R1,R0
        ADR.W    R0,ASSERT_FAILED_STR
        BL       printf
//   19 
//   20     while (1)
//   21     {
//   22 //        platform_led_display(0xFF);
//   23         for (i = 100000; i; i--) ;
??assert_failed_0:
        LDR.N    R0,??DataTable1  ;; 0x186a0
        B.N      ??assert_failed_1
??assert_failed_2:
        SUBS     R0,R0,#+1
??assert_failed_1:
        CMP      R0,#+0
        BNE.N    ??assert_failed_2
//   24 //        platform_led_display(0x00);
//   25         for (i = 100000; i; i--) ;
        LDR.N    R0,??DataTable1  ;; 0x186a0
??assert_failed_3:
        CMP      R0,#+0
        BEQ.N    ??assert_failed_0
        SUBS     R0,R0,#+1
        B.N      ??assert_failed_3
//   26     }
//   27 }

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable1:
        DC32     0x186a0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
ASSERT_FAILED_STR:
        ; Initializer data, 36 bytes
        DC8 65, 115, 115, 101, 114, 116, 105, 111, 110, 32
        DC8 102, 97, 105, 108, 101, 100, 32, 105, 110, 32
        DC8 37, 115, 32, 97, 116, 32, 108, 105, 110, 101
        DC8 32, 37, 100, 10, 0, 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
//   28 /********************************************************************/
// 
// 74 bytes in section .text
// 
// 74 bytes of CODE memory
//
//Errors: none
//Warnings: none
