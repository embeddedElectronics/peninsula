///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      01/Mar/2012  22:04:46 /
// IAR ANSI C/C++ Compiler V6.10.1.22143/W32 EVALUATION for ARM               /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  F:\My Works\K60\K60课件\K60课件\源程序\Ch11-PRG(SDHC)\S /
//                    DHC\Sources\MCUabout\common.c                           /
//    Command line =  "F:\My Works\K60\K60课件\K60课件\源程序\Ch11-PRG(SDHC)\ /
//                    SDHC\Sources\MCUabout\common.c" -D IAR -D TWR_K60N512   /
//                    -lCN "F:\My Works\K60\Kinetis512\kinetis-sc\build\iar\g /
//                    pio\FLASH_512KB_PFLASH\List\" -lB "F:\My                /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\FLASH_51 /
//                    2KB_PFLASH\List\" -o "F:\My                             /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\FLASH_51 /
//                    2KB_PFLASH\Obj\" --no_cse --no_unroll --no_inline       /
//                    --no_code_motion --no_tbaa --no_clustering              /
//                    --no_scheduling --debug --endian=little                 /
//                    --cpu=Cortex-M4 -e --fpu=None --dlib_config             /
//                    "D:\Program Files\IAR Systems\Embedded Workbench 6.0    /
//                    Evaluation\arm\INC\c\DLib_Config_Normal.h" -I "F:\My    /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\..\..\.. /
//                    \src\projects\gpio\" -I "F:\My                          /
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
//    List file    =  F:\My Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\FL /
//                    ASH_512KB_PFLASH\List\common.s                          /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME common

        PUBLIC disable_irq
        PUBLIC enable_irq
        PUBLIC set_irq_priority
        PUBLIC stop
        PUBLIC wait
        PUBLIC write_vtor

// F:\My Works\K60\K60课件\K60课件\源程序\Ch11-PRG(SDHC)\SDHC\Sources\MCUabout\common.c
//    1 //============================================================================
//    2 //文件名称：common.c
//    3 //功能概要：通用函数
//    4 //============================================================================
//    5 
//    6 
//    7 #include "common.h"
//    8 
//    9 
//   10 //============================================================================
//   11 //函数名称：stop
//   12 //函数返回：无
//   13 //参数说明：无
//   14 //功能概要：设置CPU为STOP模式
//   15 //============================================================================

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//   16 void stop (void)
//   17 {
//   18     //置位SLEEPDEEP使能STOP模式
//   19     BSET(SCB_SCR_SLEEPDEEP_SHIFT, SCB_SCR);
stop:
        LDR.N    R0,??DataTable5  ;; 0xe000ed10
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x4
        LDR.N    R1,??DataTable5  ;; 0xe000ed10
        STR      R0,[R1, #+0]
//   20     //进入STOP模式
//   21     asm("WFI");
        WFI              
//   22 }
        BX       LR               ;; return
//   23 
//   24 //============================================================================
//   25 //函数名称：wait
//   26 //函数返回：无
//   27 //参数说明：无
//   28 //功能概要：设置CPU为WAIT模式
//   29 //============================================================================

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//   30 void wait (void)
//   31 {
//   32     //清SLEEPDEEP位来确定进入WAIT模式
//   33     BCLR(SCB_SCR_SLEEPDEEP_SHIFT, SCB_SCR);
wait:
        LDR.N    R0,??DataTable5  ;; 0xe000ed10
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x4
        LDR.N    R1,??DataTable5  ;; 0xe000ed10
        STR      R0,[R1, #+0]
//   34     //进入WAIT模式
//   35     asm("WFI");
        WFI              
//   36 }
        BX       LR               ;; return
//   37 
//   38 //============================================================================
//   39 //函数名称：write_vtor
//   40 //函数返回：vtor：要更改的值
//   41 //参数说明：无
//   42 //功能概要：更改中断向量表偏移寄存器的值 
//   43 //============================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   44 void write_vtor (uint16 vtor)
//   45 {
//   46     //写新值
//   47     SCB_VTOR = vtor;	
write_vtor:
        LDR.N    R1,??DataTable5_1  ;; 0xe000ed08
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        STR      R0,[R1, #+0]
//   48 }
        BX       LR               ;; return
//   49 
//   50 //============================================================================
//   51 //函数名称：enable_irq
//   52 //函数返回：无  
//   53 //参数说明：irq：irq号
//   54 //功能概要：使能irq中断 
//   55 //============================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   56 void enable_irq (uint16 irq)
//   57 {
//   58     uint16 div;
//   59 
//   60     //确定irq号为有效的irq号
//   61     if (irq > 91)	irq=91;
enable_irq:
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        CMP      R0,#+92
        BCC.N    ??enable_irq_0
        MOVS     R0,#+91
//   62     
//   63     //确定对应的NVICISER
//   64     div = irq/32;
??enable_irq_0:
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        MOVS     R1,#+32
        SDIV     R1,R0,R1
//   65 
//   66     switch (div)
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        CMP      R1,#+0
        BEQ.N    ??enable_irq_1
        CMP      R1,#+2
        BEQ.N    ??enable_irq_2
        BCC.N    ??enable_irq_3
        B.N      ??enable_irq_4
//   67     {
//   68     	case 0x0:
//   69             NVICICPR0 = 1 << (irq%32);
??enable_irq_1:
        MOVS     R1,#+1
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        MOVS     R2,#+32
        SDIV     R3,R0,R2
        MLS      R3,R3,R2,R0
        LSLS     R1,R1,R3
        LDR.N    R2,??DataTable5_2  ;; 0xe000e280
        STR      R1,[R2, #+0]
//   70             NVICISER0 = 1 << (irq%32);
        MOVS     R1,#+1
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        MOVS     R2,#+32
        SDIV     R3,R0,R2
        MLS      R3,R3,R2,R0
        LSLS     R0,R1,R3
        LDR.N    R1,??DataTable5_3  ;; 0xe000e100
        STR      R0,[R1, #+0]
//   71             break;
        B.N      ??enable_irq_5
//   72     	case 0x1:
//   73             NVICICPR1 = 1 << (irq%32);
??enable_irq_3:
        MOVS     R1,#+1
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        MOVS     R2,#+32
        SDIV     R3,R0,R2
        MLS      R3,R3,R2,R0
        LSLS     R1,R1,R3
        LDR.N    R2,??DataTable5_4  ;; 0xe000e284
        STR      R1,[R2, #+0]
//   74             NVICISER1 = 1 << (irq%32);
        MOVS     R1,#+1
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        MOVS     R2,#+32
        SDIV     R3,R0,R2
        MLS      R3,R3,R2,R0
        LSLS     R0,R1,R3
        LDR.N    R1,??DataTable5_5  ;; 0xe000e104
        STR      R0,[R1, #+0]
//   75             break;
        B.N      ??enable_irq_5
//   76     	case 0x2:
//   77             NVICICPR2 = 1 << (irq%32);
??enable_irq_2:
        MOVS     R1,#+1
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        MOVS     R2,#+32
        SDIV     R3,R0,R2
        MLS      R3,R3,R2,R0
        LSLS     R1,R1,R3
        LDR.N    R2,??DataTable5_6  ;; 0xe000e288
        STR      R1,[R2, #+0]
//   78             NVICISER2 = 1 << (irq%32);
        MOVS     R1,#+1
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        MOVS     R2,#+32
        SDIV     R3,R0,R2
        MLS      R3,R3,R2,R0
        LSLS     R0,R1,R3
        LDR.N    R1,??DataTable5_7  ;; 0xe000e108
        STR      R0,[R1, #+0]
//   79             break;
        B.N      ??enable_irq_5
//   80     	default:
//   81     		break;
//   82     }              
//   83 }
??enable_irq_4:
??enable_irq_5:
        BX       LR               ;; return
//   84 
//   85 //============================================================================
//   86 //函数名称：disable_irq
//   87 //函数返回：无      
//   88 //参数说明：irq：irq号
//   89 //功能概要：禁止irq中断 
//   90 //============================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   91 void disable_irq (uint16 irq)
//   92 {
//   93     uint16 div;
//   94 
//   95     //确定irq号为有效的irq号
//   96     if (irq > 91)	irq=91;
disable_irq:
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        CMP      R0,#+92
        BCC.N    ??disable_irq_0
        MOVS     R0,#+91
//   97     
//   98     //确定对应的NVICISER
//   99     div = irq/32;
??disable_irq_0:
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        MOVS     R1,#+32
        SDIV     R1,R0,R1
//  100 
//  101     switch (div)
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        CMP      R1,#+0
        BEQ.N    ??disable_irq_1
        CMP      R1,#+2
        BEQ.N    ??disable_irq_2
        BCC.N    ??disable_irq_3
        B.N      ??disable_irq_4
//  102     {
//  103         case 0:
//  104             NVICICER0 = 1 << (irq%32);
??disable_irq_1:
        MOVS     R1,#+1
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        MOVS     R2,#+32
        SDIV     R3,R0,R2
        MLS      R3,R3,R2,R0
        LSLS     R0,R1,R3
        LDR.N    R1,??DataTable5_8  ;; 0xe000e180
        STR      R0,[R1, #+0]
//  105             break;
        B.N      ??disable_irq_5
//  106     	case 1:
//  107             NVICICER1 = 1 << (irq%32);
??disable_irq_3:
        MOVS     R1,#+1
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        MOVS     R2,#+32
        SDIV     R3,R0,R2
        MLS      R3,R3,R2,R0
        LSLS     R0,R1,R3
        LDR.N    R1,??DataTable5_9  ;; 0xe000e184
        STR      R0,[R1, #+0]
//  108             break;
        B.N      ??disable_irq_5
//  109     	case 2:
//  110             NVICICER2 = 1 << (irq%32);
??disable_irq_2:
        MOVS     R1,#+1
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        MOVS     R2,#+32
        SDIV     R3,R0,R2
        MLS      R3,R3,R2,R0
        LSLS     R0,R1,R3
        LDR.N    R1,??DataTable5_10  ;; 0xe000e188
        STR      R0,[R1, #+0]
//  111             break;
        B.N      ??disable_irq_5
//  112     	default:
//  113     		break;
//  114     }              
//  115 }
??disable_irq_4:
??disable_irq_5:
        BX       LR               ;; return
//  116  
//  117 //============================================================================
//  118 //函数名称：set_irq_priority
//  119 //函数返回：无      
//  120 //参数说明：irq：irq号         											   
//  121 //         prio：优先级
//  122 //功能概要：设置irq中断和优先级 
//  123 //============================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  124 void set_irq_priority (uint16 irq, uint16 prio)
//  125 {
//  126     uint8 *prio_reg;
//  127 
//  128     //确定irq号和优先级有效
//  129     if (irq > 91)	irq = 91;
set_irq_priority:
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        CMP      R0,#+92
        BCC.N    ??set_irq_priority_0
        MOVS     R0,#+91
//  130     if (prio > 15)	prio = 15;
??set_irq_priority_0:
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        CMP      R1,#+16
        BCC.N    ??set_irq_priority_1
        MOVS     R1,#+15
//  131 
//  132     //确定对应的NVICISER
//  133     prio_reg = (uint8 *)(((uint32)&NVICIP0) + irq);
??set_irq_priority_1:
        LDR.N    R2,??DataTable5_11  ;; 0xe000e400
        UXTAH    R0,R2,R0
//  134     //设置优先级
//  135     *prio_reg = ( (prio&0xF) << (8 - ARM_INTERRUPT_LEVEL_BITS) );             
        LSLS     R1,R1,#+4
        STRB     R1,[R0, #+0]
//  136 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable5:
        DC32     0xe000ed10

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable5_1:
        DC32     0xe000ed08

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable5_2:
        DC32     0xe000e280

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable5_3:
        DC32     0xe000e100

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable5_4:
        DC32     0xe000e284

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable5_5:
        DC32     0xe000e104

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable5_6:
        DC32     0xe000e288

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable5_7:
        DC32     0xe000e108

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable5_8:
        DC32     0xe000e180

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable5_9:
        DC32     0xe000e184

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable5_10:
        DC32     0xe000e188

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable5_11:
        DC32     0xe000e400

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
//  137 
// 
// 384 bytes in section .text
// 
// 384 bytes of CODE memory
//
//Errors: none
//Warnings: 3
