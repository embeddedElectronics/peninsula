///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      04/Mar/2012  17:42:43 /
// IAR ANSI C/C++ Compiler V6.10.1.22143/W32 EVALUATION for ARM               /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\tsi\ /
//                    misc.c                                                  /
//    Command line =  "F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\tsi /
//                    \misc.c" -D IAR -D TWR_K60N512 -lCN "F:\My              /
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
//                    SH_512KB_PFLASH\List\misc.s                             /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME misc

        PUBLIC GPIO_Init
        PUBLIC LED_Dir_Out
        PUBLIC LEDs_On
        PUBLIC delay

// F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\tsi\misc.c
//    1 #include "misc.h"
//    2 
//    3 /********************************************************************************
//    4  *   delay: delay
//    5  * Notes:
//    6  *    -
//    7  ********************************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//    8 void delay(uint32 i)
//    9 {
//   10   for(i;i;i--)  //delay
delay:
        B.N      ??delay_0
??delay_1:
        SUBS     R0,R0,#+1
??delay_0:
        CMP      R0,#+0
        BNE.N    ??delay_1
//   11   {
//   12   }
//   13 }
        BX       LR               ;; return
//   14 
//   15 /********************************************************************************
//   16  *   GPIO_Init: Initializes GPIO controlling LED
//   17  * Notes:
//   18  *    -
//   19  ********************************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   20 void GPIO_Init(void)
//   21 {
GPIO_Init:
        PUSH     {R7,LR}
//   22   ENABLE_GPIO_CLOCKS;
        LDR.N    R0,??DataTable2  ;; 0x40048038
        LDR      R0,[R0, #+0]
        MOV      R1,#+512
        ORRS     R0,R1,R0
        LDR.N    R1,??DataTable2  ;; 0x40048038
        STR      R0,[R1, #+0]
//   23 
//   24   LED0_EN;
        LDR.N    R0,??DataTable2_1  ;; 0x4004902c
        MOV      R1,#+256
        STR      R1,[R0, #+0]
//   25   LED1_EN;
        LDR.N    R0,??DataTable2_2  ;; 0x40049074
        MOV      R1,#+256
        STR      R1,[R0, #+0]
//   26   LED2_EN;
        LDR.N    R0,??DataTable2_3  ;; 0x40049070
        MOV      R1,#+256
        STR      R1,[R0, #+0]
//   27   LED3_EN;
        LDR.N    R0,??DataTable2_4  ;; 0x40049028
        MOV      R1,#+256
        STR      R1,[R0, #+0]
//   28 
//   29   LEDs_On();
        BL       LEDs_On
//   30   LED_Dir_Out();
        BL       LED_Dir_Out
//   31 }
        POP      {R0,PC}          ;; return
//   32 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   33 void LEDs_On(void)
//   34 {
//   35 #ifdef CPU_MK60N512VMD100
//   36   GPIOA_PDDR = (1<<10)|(1<<11)|(1<<28)|(1<<29);
LEDs_On:
        LDR.N    R0,??DataTable2_5  ;; 0x400ff014
        LDR.N    R1,??DataTable2_6  ;; 0x30000c00
        STR      R1,[R0, #+0]
//   37 #else
//   38   GPIOB_PDDR = (1<<11);
//   39   GPIOC_PDDR = ((1<<7)|(1<<8)|(1<<9));
//   40 #endif
//   41 }
        BX       LR               ;; return
//   42 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   43 void LED_Dir_Out(void)
//   44 {
//   45 #ifdef CPU_MK60N512VMD100
//   46   GPIOA_PDOR &= ~((1<<10)|(1<<11)|(1<<28)|(1<<29));
LED_Dir_Out:
        LDR.N    R0,??DataTable2_7  ;; 0x400ff000
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable2_8  ;; 0xcffff3ff
        ANDS     R0,R1,R0
        LDR.N    R1,??DataTable2_7  ;; 0x400ff000
        STR      R0,[R1, #+0]
//   47 #else
//   48   GPIOB_PDOR &= ~(1<<11);
//   49   GPIOC_PDOR &= ~((1<<7)|(1<<8)|(1<<9));
//   50 #endif
//   51 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2:
        DC32     0x40048038

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_1:
        DC32     0x4004902c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_2:
        DC32     0x40049074

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_3:
        DC32     0x40049070

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_4:
        DC32     0x40049028

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_5:
        DC32     0x400ff014

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_6:
        DC32     0x30000c00

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_7:
        DC32     0x400ff000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_8:
        DC32     0xcffff3ff

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
// 
// 126 bytes in section .text
// 
// 126 bytes of CODE memory
//
//Errors: none
//Warnings: 1
