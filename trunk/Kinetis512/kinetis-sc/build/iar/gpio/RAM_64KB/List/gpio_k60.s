///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      06/Mar/2012  13:00:25 /
// IAR ANSI C/C++ Compiler V6.10.1.22143/W32 EVALUATION for ARM               /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\gpio /
//                    \gpio_k60.c                                             /
//    Command line =  "F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\gpi /
//                    o\gpio_k60.c" -D IAR -D TWR_K60N512 -lCN "F:\My         /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\RAM_64KB /
//                    \List\" -lB "F:\My Works\K60\Kinetis512\kinetis-sc\buil /
//                    d\iar\gpio\RAM_64KB\List\" -o "F:\My                    /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\RAM_64KB /
//                    \Obj\" --no_cse --no_unroll --no_inline                 /
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
//    List file    =  F:\My Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\RA /
//                    M_64KB\List\gpio_k60.s                                  /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME gpio_k60

        EXTERN BmpBIT8Write
        EXTERN FAT32_Add_Dat
        EXTERN FAT32_Create_File
        EXTERN FAT32_Init
        EXTERN InitColorTable
        EXTERN disable_irq
        EXTERN disk_initialize
        EXTERN enable_irq

        PUBLIC CLie
        PUBLIC ColorTable
        PUBLIC Dev_No
        PUBLIC FatArg
        PUBLIC FileInfo
        PUBLIC GPflag
        PUBLIC GetPic
        PUBLIC IRQ_Init
        PUBLIC ISR_PTA
        PUBLIC ISR_PTD
        PUBLIC LieCount
        PUBLIC PIT0_ISR
        PUBLIC PIT1_ISR
        PUBLIC PIT2_ISR
        PUBLIC PIT3_ISR
        PUBLIC Pic
        PUBLIC Pll_Init
        PUBLIC RowCount
        PUBLIC Timer0
        PUBLIC Timer1
        PUBLIC Timer2
        PUBLIC Timer3
        PUBLIC Timer_Init
        PUBLIC delay
        PUBLIC gpflag
        PUBLIC gpline
        PUBLIC gppoint
        PUBLIC main
        PUBLIC pArg
        PUBLIC pic
        PUBLIC temp
        PUBLIC ucTimeDelayFlag

// F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\gpio\gpio_k60.c
//    1 /*
//    2  * File:		gpio_k60.c
//    3  * Purpose:		LED and Switch Example
//    4  *
//    5  *                      Configures GPIO for the LED and push buttons on the TWR-K60N512
//    6  *                      Blue LED - On
//    7  *                      Green LED - Toggles on/off
//    8  *                      Orange LED - On if SW2 pressed
//    9  *                      Yellow LED - On if SW1 pressed
//   10  *
//   11  *                      Also configures push buttons for falling IRQ's. ISR
//   12  *                        configured in vector table in isr.h
//   13  *
//   14  
//   15 
//   16 
//   17 #define GPIO_PIN_MASK            0x1Fu
//   18 #define GPIO_PIN(x)              (((1)<<(x & GPIO_PIN_MASK)))*/
//   19 
//   20 #include "common.h"
//   21 #include "MK60N512VMD100.h"
//   22 #include "k60_tower.h"
//   23 #include "hw_sdhc.h"
//   24 #include "diskio.h"
//   25 #include "FAT32.h"
//   26 #include "BMP.h"
//   27 
//   28 #define RowEnd  260
//   29 #define LineEnd  100
//   30 #define lie  60//51  
//   31 
//   32 //#define PTT  (GPIOD_PDIR & 0x00000100u)
//   33 
//   34 
//   35 
//   36 
//   37 //位带操作,实现51类似的GPIO控制功能
//   38 //具体实现思想,参考<<CM3权威指南>>第五章(87页~92页)
//   39 //参考正点原子STM32不完全手册
//   40 //IO口操作宏定义
//   41 #define BITBAND(addr, bitnum) ((addr & 0xF0000000)+0x2000000+((addr &0xFFFFF)<<5)+(bitnum<<2)) 
//   42 #define MEM_ADDR(addr)  *((volatile unsigned long  *)(addr)) 
//   43 #define BIT_ADDR(addr, bitnum)   MEM_ADDR(BITBAND(addr, bitnum)) 
//   44 //IO口地址映射
//   45 #define GPIOA_ODR_Addr    (PTA_BASE_PTR+0) //0x4001080C 
//   46 #define GPIOB_ODR_Addr    (PTB_BASE_PTR+0) //0x40010C0C 
//   47 #define GPIOC_ODR_Addr    (PTC_BASE_PTR+0) //0x4001100C 
//   48 #define GPIOD_ODR_Addr    (PTD_BASE_PTR+0) //0x4001140C 
//   49 #define GPIOE_ODR_Addr    (PTE_BASE_PTR+0) //0x4001180C 
//   50    
//   51 
//   52 #define GPIOA_IDR_Addr    (PTA_BASE_PTR+0x10) //0x40010808 
//   53 #define GPIOB_IDR_Addr    (PTB_BASE_PTR+0x10) //0x40010C08 
//   54 #define GPIOC_IDR_Addr    (PTC_BASE_PTR+0x10) //0x40011008 
//   55 #define GPIOD_IDR_Addr    (PTD_BASE_PTR+0x10) //0x40011408 
//   56 #define GPIOE_IDR_Addr    (PTE_BASE_PTR+0x10) //0x40011808 
//   57 
//   58 
//   59 //IO口操作,只对单一的IO口!
//   60 #define PAout(n)   BIT_ADDR(GPIOA_ODR_Addr,n)  //输出 
//   61 #define PAin(n)    BIT_ADDR(GPIOA_IDR_Addr,n)  //输入 
//   62   
//   63 #define PBout(n)   BIT_ADDR(GPIOB_ODR_Addr,n)  //输出 
//   64 #define PBin(n)    BIT_ADDR(GPIOB_IDR_Addr,n)  //输入 
//   65 
//   66 #define PCout(n)   BIT_ADDR(GPIOC_ODR_Addr,n)  //输出 
//   67 #define PCin(n)    BIT_ADDR(GPIOC_IDR_Addr,n)  //输入 
//   68 
//   69 #define PDout(n)   BIT_ADDR(GPIOD_ODR_Addr,n)  //输出 
//   70 #define PDin(n)    BIT_ADDR(GPIOD_IDR_Addr,n)  //输入 
//   71 
//   72 #define PEout(n)   BIT_ADDR(GPIOE_ODR_Addr,n)  //输出 
//   73 #define PEin(n)    BIT_ADDR(GPIOE_IDR_Addr,n)  //输入
//   74 
//   75 
//   76 
//   77 //#define GPIOE_ODR_Addr    (PTE_BASE+0) //0x4001180C 
//   78 #define PEin(n)    BIT_ADDR(GPIOE_IDR_Addr,n)  //输入 
//   79 #define KEY0_PIN  5    
//   80 #define KEY0      PEin(KEY0_PIN) //PE0 
//   81 
//   82 
//   83 
//   84 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   85 int ucTimeDelayFlag;
ucTimeDelayFlag:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//   86 unsigned char gpline=0 , gpflag=0 , gppoint=0 ;
gpline:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
gpflag:
        DS8 1

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
gppoint:
        DS8 1
//   87 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   88 unsigned char Pic[lie][LineEnd];
Pic:
        DS8 6000

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   89 unsigned int CLie=0;
CLie:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   90 unsigned int LieCount=0,RowCount;
LieCount:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
RowCount:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   91 unsigned int GPflag;
GPflag:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   92 int temp;
temp:
        DS8 4
//   93 
//   94 
//   95 const unsigned int GetPic[61]={20,24,28,32,36,40,44,48,52,56,
//   96                               59,62,65,68,71,74,77,80,83,86,
//   97                               89,91,93,95,97,99,101,103,105,107,
//   98                               109,110,111,112,113,114,115,116,117,118,
//   99                               119,120,121,122,123,124,125,126,127,128,
//  100                               129,130,131,132,133,134,135,136,137,138,
//  101                               139
//  102                          };
//  103 //FAT32文件系统变量

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  104 struct FAT32_Init_Arg *pArg;
pArg:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  105 struct FAT32_Init_Arg FatArg;
FatArg:
        DS8 32

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  106 struct FileInfoStruct FileInfo;
FileInfo:
        DS8 64

        SECTION `.bss`:DATA:REORDER:NOROOT(0)
//  107 uint8 Dev_No=0;
Dev_No:
        DS8 1
//  108 //BMP变量

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  109 RGBQUAD ColorTable[256];
ColorTable:
        DS8 1024
//  110 //BMP测试数据

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//  111 uint8 pic[80][70];
pic:
        DS8 5600

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  112 void delay(int num)                                   
//  113 { 
//  114      unsigned int ii,jj; 
//  115     for(ii=0;ii<num;ii++) 
delay:
        MOVS     R1,#+0
        B.N      ??delay_0
//  116        for(jj=0;jj<59;jj++); 
??delay_1:
        ADDS     R2,R2,#+1
??delay_2:
        CMP      R2,#+59
        BCC.N    ??delay_1
        ADDS     R1,R1,#+1
??delay_0:
        CMP      R1,R0
        BCS.N    ??delay_3
        MOVS     R2,#+0
        B.N      ??delay_2
//  117 }
??delay_3:
        BX       LR               ;; return
//  118 
//  119 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  120 void IRQ_Init(void)
//  121 {
//  122 	//PORTD_PCR8 = PORT_PCR_MUX(0x1); // GPIO is alt1 function for this pin
//  123         PORTA_PCR15 = PORT_PCR_MUX(0x1);
IRQ_Init:
        LDR.W    R0,??DataTable17  ;; 0x4004903c
        MOV      R1,#+256
        STR      R1,[R0, #+0]
//  124 	/* Configure the PTE26 pin for rising edge interrupts */
//  125 	//PORTD_PCR8 |= PORT_PCR_IRQC(0x9);
//  126         PORTA_PCR15 |= PORT_PCR_IRQC(0x9);
        LDR.W    R0,??DataTable17  ;; 0x4004903c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x90000
        LDR.W    R1,??DataTable17  ;; 0x4004903c
        STR      R0,[R1, #+0]
//  127         /*
//  128         0000 Interrupt/DMA Request disabled.
//  129         0001 DMA Request on rising edge.
//  130         0010 DMA Request on falling edge.
//  131         0011 DMA Request on either edge.
//  132         0100 Reserved.
//  133         1000 Interrupt when logic zero.
//  134         1001 Interrupt on rising edge.
//  135         1010 Interrupt on falling edge.
//  136         1011 Interrupt on either edge.
//  137         1100 Interrupt when logic one.
//  138         */
//  139 	//PORTE_PCR26 = 1 << 8 | 0xA << 16 | 1;
//  140 	//GPIOD_PDDR |= 0 << 8;
//  141         //GPIOA_PDDR |= 0 << 15;
//  142         
//  143         PORTC_PCR0 = PORT_PCR_MUX(0x1);
        LDR.W    R0,??DataTable17_1  ;; 0x4004b000
        MOV      R1,#+256
        STR      R1,[R0, #+0]
//  144         GPIOC_PDDR = 0x00000000u;
        LDR.W    R0,??DataTable17_2  ;; 0x400ff094
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//  145 }
        BX       LR               ;; return
//  146 void Timer0( unsigned int timeout );

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  147 void ISR_PTA(void)    //行同步
//  148 {
ISR_PTA:
        PUSH     {R7,LR}
//  149 	PORTA_ISFR = 1 << 15;
        LDR.N    R0,??DataTable17_3  ;; 0x400490a0
        MOV      R1,#+32768
        STR      R1,[R0, #+0]
//  150         
//  151         //GPIOA_PTOR |= 1 << 10;
//  152 	//delay2();
//  153         disable_irq(87);
        MOVS     R0,#+87
        BL       disable_irq
//  154         //enable_irq(90);
//  155     
//  156         if(LieCount==GetPic[CLie]) 
        LDR.N    R0,??DataTable17_4
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable17_5
        LDR      R1,[R1, #+0]
        ADR.W    R2,GetPic
        LDR      R1,[R2, R1, LSL #+2]
        CMP      R0,R1
        BNE.N    ??ISR_PTA_0
//  157         {  
//  158           delay(3);   
        MOVS     R0,#+3
        BL       delay
//  159           for(RowCount=0;RowCount<LineEnd;RowCount++)
        LDR.N    R0,??DataTable17_6
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
        B.N      ??ISR_PTA_1
//  160           {  
//  161             Pic[CLie][RowCount] = (GPIOC_PDIR & (~GPIO_PDIR_PDI(0))) * 0xFF; 
??ISR_PTA_2:
        LDR.N    R0,??DataTable17_6
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable17_5
        LDR      R1,[R1, #+0]
        MOVS     R2,#+100
        LDR.N    R3,??DataTable17_7
        MLA      R1,R2,R1,R3
        LDR.N    R2,??DataTable17_8  ;; 0x400ff090
        LDR      R2,[R2, #+0]
        MOVS     R3,#+255
        MULS     R2,R3,R2
        STRB     R2,[R0, R1]
//  162             /*temp = (GPIOC_PDIR & 0x00000001u);
//  163             if(temp > 0)
//  164             {
//  165               temp = 0;
//  166             }*/
//  167           }
        LDR.N    R0,??DataTable17_6
        LDR      R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.N    R1,??DataTable17_6
        STR      R0,[R1, #+0]
??ISR_PTA_1:
        LDR.N    R0,??DataTable17_6
        LDR      R0,[R0, #+0]
        CMP      R0,#+100
        BCC.N    ??ISR_PTA_2
//  168          CLie++; 
        LDR.N    R0,??DataTable17_5
        LDR      R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.N    R1,??DataTable17_5
        STR      R0,[R1, #+0]
//  169         }
//  170         LieCount++; 
??ISR_PTA_0:
        LDR.N    R0,??DataTable17_4
        LDR      R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.N    R1,??DataTable17_4
        STR      R0,[R1, #+0]
//  171         if(CLie==60)GPflag=1;
        LDR.N    R0,??DataTable17_5
        LDR      R0,[R0, #+0]
        CMP      R0,#+60
        BNE.N    ??ISR_PTA_3
        LDR.N    R0,??DataTable17_9
        MOVS     R1,#+1
        STR      R1,[R0, #+0]
//  172         Timer0(1);
??ISR_PTA_3:
        MOVS     R0,#+1
        BL       Timer0
//  173         PIT_TCTRL0 |= PIT_TCTRL_TEN_MASK;
        LDR.N    R0,??DataTable17_10  ;; 0x40037108
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable17_10  ;; 0x40037108
        STR      R0,[R1, #+0]
//  174         enable_irq(68);
        MOVS     R0,#+68
        BL       enable_irq
//  175 }
        POP      {R0,PC}          ;; return
//  176 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  177 void ISR_PTD(void)    //场同步
//  178 {
ISR_PTD:
        PUSH     {R7,LR}
//  179 	PORTD_ISFR = 1 << 8;
        LDR.N    R0,??DataTable17_11  ;; 0x4004c0a0
        MOV      R1,#+256
        STR      R1,[R0, #+0]
//  180 	//GPIOA_PTOR |= 1 << 11;
//  181         //disable_irq(90);
//  182         
//  183         Timer0(0x15A0);
        MOV      R0,#+5536
        BL       Timer0
//  184         
//  185         PIT_TCTRL0 |= PIT_TCTRL_TEN_MASK;
        LDR.N    R0,??DataTable17_10  ;; 0x40037108
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable17_10  ;; 0x40037108
        STR      R0,[R1, #+0]
//  186         enable_irq(68);
        MOVS     R0,#+68
        BL       enable_irq
//  187         
//  188         while(GPflag==0);     
??ISR_PTD_0:
        LDR.N    R0,??DataTable17_9
        LDR      R0,[R0, #+0]
        CMP      R0,#+0
        BEQ.N    ??ISR_PTD_0
//  189 }
        POP      {R0,PC}          ;; return
//  190 
//  191 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  192 void Timer_Init()
//  193 {
//  194   SIM_SCGC6 |= SIM_SCGC6_PIT_MASK;
Timer_Init:
        LDR.N    R0,??DataTable17_12  ;; 0x4004803c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x800000
        LDR.N    R1,??DataTable17_12  ;; 0x4004803c
        STR      R0,[R1, #+0]
//  195   PIT_MCR &= ~PIT_MCR_MDIS_MASK;
        LDR.N    R0,??DataTable17_13  ;; 0x40037000
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x2
        LDR.N    R1,??DataTable17_13  ;; 0x40037000
        STR      R0,[R1, #+0]
//  196 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  197 void Timer0( unsigned int timeout )
//  198 {
//  199     PIT_LDVAL0 = timeout;
Timer0:
        LDR.N    R1,??DataTable17_14  ;; 0x40037100
        STR      R0,[R1, #+0]
//  200     PIT_TCTRL0 |= PIT_TCTRL_TEN_MASK |PIT_TCTRL_TIE_MASK;
        LDR.N    R0,??DataTable17_10  ;; 0x40037108
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3
        LDR.N    R1,??DataTable17_10  ;; 0x40037108
        STR      R0,[R1, #+0]
//  201     //enable_irq(68);
//  202 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  203 void PIT0_ISR(void)
//  204 {
PIT0_ISR:
        PUSH     {R7,LR}
//  205     PIT_TFLG0 |= PIT_TFLG_TIF_MASK;
        LDR.N    R0,??DataTable17_15  ;; 0x4003710c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable17_15  ;; 0x4003710c
        STR      R0,[R1, #+0]
//  206     PIT_TCTRL0 &= ~PIT_TCTRL_TEN_MASK;
        LDR.N    R0,??DataTable17_10  ;; 0x40037108
        LDR      R0,[R0, #+0]
        LSRS     R0,R0,#+1
        LSLS     R0,R0,#+1
        LDR.N    R1,??DataTable17_10  ;; 0x40037108
        STR      R0,[R1, #+0]
//  207     //GPIOA_PTOR |= 1 << 10;
//  208     disable_irq(68);
        MOVS     R0,#+68
        BL       disable_irq
//  209     
//  210     if(GPflag==0)
        LDR.N    R0,??DataTable17_9
        LDR      R0,[R0, #+0]
        CMP      R0,#+0
        BNE.N    ??PIT0_ISR_0
//  211     {
//  212       delay(10);
        MOVS     R0,#+10
        BL       delay
//  213       enable_irq(87);
        MOVS     R0,#+87
        BL       enable_irq
//  214     }
//  215      
//  216 }
??PIT0_ISR_0:
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  217 void Timer1( unsigned int timeout )
//  218 {
//  219     PIT_LDVAL1 = timeout;
Timer1:
        LDR.N    R1,??DataTable17_16  ;; 0x40037110
        STR      R0,[R1, #+0]
//  220     
//  221     PIT_TCTRL1 |= PIT_TCTRL_TEN_MASK |PIT_TCTRL_TIE_MASK;
        LDR.N    R0,??DataTable17_17  ;; 0x40037118
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3
        LDR.N    R1,??DataTable17_17  ;; 0x40037118
        STR      R0,[R1, #+0]
//  222     //enable_irq(69);
//  223 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  224 void PIT1_ISR(void)
//  225 {
PIT1_ISR:
        PUSH     {R7,LR}
//  226     PIT_TFLG1 |= PIT_TFLG_TIF_MASK;
        LDR.N    R0,??DataTable17_18  ;; 0x4003711c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable17_18  ;; 0x4003711c
        STR      R0,[R1, #+0]
//  227     GPIOA_PTOR |= 1 << 10;
        LDR.N    R0,??DataTable17_19  ;; 0x400ff00c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x400
        LDR.N    R1,??DataTable17_19  ;; 0x400ff00c
        STR      R0,[R1, #+0]
//  228     
//  229     disable_irq(69);
        MOVS     R0,#+69
        BL       disable_irq
//  230 }
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  231 void Timer2( unsigned int timeout )
//  232 {
//  233     PIT_LDVAL2 = timeout;
Timer2:
        LDR.N    R1,??DataTable17_20  ;; 0x40037120
        STR      R0,[R1, #+0]
//  234     PIT_TCTRL2 |= PIT_TCTRL_TEN_MASK |PIT_TCTRL_TIE_MASK;
        LDR.N    R0,??DataTable17_21  ;; 0x40037128
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3
        LDR.N    R1,??DataTable17_21  ;; 0x40037128
        STR      R0,[R1, #+0]
//  235     //enable_irq(70);
//  236 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  237 void PIT2_ISR(void)
//  238 {
PIT2_ISR:
        PUSH     {R7,LR}
//  239     PIT_TFLG2 |= PIT_TFLG_TIF_MASK;
        LDR.N    R0,??DataTable17_22  ;; 0x4003712c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable17_22  ;; 0x4003712c
        STR      R0,[R1, #+0]
//  240     GPIOA_PTOR |= 1 << 10;
        LDR.N    R0,??DataTable17_19  ;; 0x400ff00c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x400
        LDR.N    R1,??DataTable17_19  ;; 0x400ff00c
        STR      R0,[R1, #+0]
//  241  
//  242     disable_irq(70);
        MOVS     R0,#+70
        BL       disable_irq
//  243 }
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  244 void Timer3( unsigned int timeout )
//  245 {
//  246     PIT_LDVAL3 = timeout;
Timer3:
        LDR.N    R1,??DataTable17_23  ;; 0x40037130
        STR      R0,[R1, #+0]
//  247     
//  248     PIT_TCTRL3 |= PIT_TCTRL_TEN_MASK |PIT_TCTRL_TIE_MASK;
        LDR.N    R0,??DataTable17_24  ;; 0x40037138
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x3
        LDR.N    R1,??DataTable17_24  ;; 0x40037138
        STR      R0,[R1, #+0]
//  249     //enable_irq(71);
//  250 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  251 void PIT3_ISR(void)
//  252 {
PIT3_ISR:
        PUSH     {R7,LR}
//  253     PIT_TFLG3 |= PIT_TFLG_TIF_MASK;
        LDR.N    R0,??DataTable17_25  ;; 0x4003713c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable17_25  ;; 0x4003713c
        STR      R0,[R1, #+0]
//  254     GPIOA_PTOR |= 1 << 10;
        LDR.N    R0,??DataTable17_19  ;; 0x400ff00c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x400
        LDR.N    R1,??DataTable17_19  ;; 0x400ff00c
        STR      R0,[R1, #+0]
//  255     
//  256     disable_irq(71);
        MOVS     R0,#+71
        BL       disable_irq
//  257 }
        POP      {R0,PC}          ;; return
//  258 
//  259 //设置系统主频率

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  260 void Pll_Init(void)		//pll = 外部晶振(50) / MCG_C5_PRDIV *  MCG_C6_VDIV
//  261 {
//  262 	uint32_t temp_reg;
//  263 
//  264 	//这里处在默认的FEI模式
//  265 	//首先移动到FBE模式
//  266 
//  267 	MCG_C2 = 0;  
Pll_Init:
        LDR.N    R0,??DataTable17_26  ;; 0x40064001
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//  268 	//MCG_C2 = MCG_C2_RANGE(2) | MCG_C2_HGO_MASK | MCG_C2_EREFS_MASK;
//  269 	//初始化晶振后释放锁定状态的振荡器和GPIO
//  270 	SIM_SCGC4 |= SIM_SCGC4_LLWU_MASK;
        LDR.N    R0,??DataTable17_27  ;; 0x40048034
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x10000000
        LDR.N    R1,??DataTable17_27  ;; 0x40048034
        STR      R0,[R1, #+0]
//  271 	LLWU_CS |= LLWU_CS_ACKISO_MASK;
        LDR.N    R0,??DataTable17_28  ;; 0x4007c008
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.N    R1,??DataTable17_28  ;; 0x4007c008
        STRB     R0,[R1, #+0]
//  272 
//  273 
//  274 	MCG_C1 = MCG_C1_CLKS(2) | MCG_C1_FRDIV(3);
        LDR.N    R0,??DataTable17_29  ;; 0x40064000
        MOVS     R1,#+152
        STRB     R1,[R0, #+0]
//  275 	//选择外部晶振，参考分频器，清IREFS来启动外部晶振
//  276 	//011 If RANGE = 0, Divide Factor is 8; for all other RANGE values, Divide Factor is 256.
//  277 
//  278 	//等待晶振稳定	    
//  279 	//while (!(MCG_S & MCG_S_OSCINIT_MASK)){}              //等待锁相环初始化结束
//  280 	while (MCG_S & MCG_S_IREFST_MASK){}                  //等待时钟切换到外部参考时钟
??Pll_Init_0:
        LDR.N    R0,??DataTable17_30  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+27
        BMI.N    ??Pll_Init_0
//  281 	while (((MCG_S & MCG_S_CLKST_MASK) >> MCG_S_CLKST_SHIFT) != 0x2){}
??Pll_Init_1:
        LDR.N    R0,??DataTable17_30  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        UBFX     R0,R0,#+2,#+2
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+2
        BNE.N    ??Pll_Init_1
//  282 
//  283 	//进入FBE模式,
//  284 
//  285 	MCG_C5 = MCG_C5_PRDIV(0x13);       //	1 - 25    
        LDR.N    R0,??DataTable17_31  ;; 0x40064004
        MOVS     R1,#+19
        STRB     R1,[R0, #+0]
//  286 	//Selects the amount to divide down the external reference clock for the PLL.
//  287 	//The resulting frequency must be in the range of 2 MHz to 4 MHz. 
//  288 	//	00000 1 01000  9 10000 17 11000 25
//  289 	//	00001 2 01001 10 10001 18 11001 Reserved
//  290 	//	00010 3 01010 11 10010 19 11010 Reserved
//  291 	//	00011 4 01011 12 10011 20 11011 Reserved
//  292 	//	00100 5 01100 13 10100 21 11100 Reserved
//  293 	//	00101 6 01101 14 10101 22 11101 Reserved
//  294 	//	00110 7 01110 15 10110 23 11110 Reserved
//  295 	//	00111 8 01111 16 10111 24 11111 Reserved
//  296 
//  297 	//确保MCG_C6处于复位状态，禁止LOLIE、PLL、和时钟控制器，清PLL VCO分频器
//  298 	MCG_C6 = 0x0;
        LDR.N    R0,??DataTable17_32  ;; 0x40064005
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//  299 
//  300 	//保存FMC_PFAPR当前的值
//  301 	temp_reg = FMC_PFAPR;
        LDR.N    R0,??DataTable17_33  ;; 0x4001f000
        LDR      R0,[R0, #+0]
//  302 
//  303 	//通过M&PFD置位M0PFD来禁止预取功能
//  304 	FMC_PFAPR |= FMC_PFAPR_M7PFD_MASK | FMC_PFAPR_M6PFD_MASK | FMC_PFAPR_M5PFD_MASK
//  305 		| FMC_PFAPR_M4PFD_MASK | FMC_PFAPR_M3PFD_MASK | FMC_PFAPR_M2PFD_MASK
//  306 		| FMC_PFAPR_M1PFD_MASK | FMC_PFAPR_M0PFD_MASK;  
        LDR.N    R1,??DataTable17_33  ;; 0x4001f000
        LDR      R1,[R1, #+0]
        ORRS     R1,R1,#0xFF0000
        LDR.N    R2,??DataTable17_33  ;; 0x4001f000
        STR      R1,[R2, #+0]
//  307 
//  308 	///设置系统分频器
//  309 	//MCG=PLL, core = MCG, bus = MCG/2, FlexBus = MCG/2, Flash clock= MCG/4
//  310 	SIM_CLKDIV1 = SIM_CLKDIV1_OUTDIV1(0) | SIM_CLKDIV1_OUTDIV2(1) 
//  311 		| SIM_CLKDIV1_OUTDIV3(1) | SIM_CLKDIV1_OUTDIV4(3);  
        LDR.N    R1,??DataTable17_34  ;; 0x40048044
        LDR.N    R2,??DataTable17_35  ;; 0x1130000
        STR      R2,[R1, #+0]
//  312 
//  313 	//OUTDIV1  sets the divide value for the core/system clock		1 - 16
//  314 	//0x00 == 1
//  315 	//0x0F == 16
//  316 	//OUTDIV2 sets the divide value for the peripheral clock		1 - 16
//  317 	//0x00 == 1
//  318 	//0x0F == 16
//  319 	//OUTDIV3 sets the divide value for the FlexBus clock driven to the external pin (FB_CLK).
//  320 	//1 - 16
//  321 	//OUTDIV4 sets the divide value for the flash clock				1 - 16
//  322 
//  323 	//重新存FMC_PFAPR的原始值
//  324 	FMC_PFAPR = temp_reg; 
        LDR.N    R1,??DataTable17_33  ;; 0x4001f000
        STR      R0,[R1, #+0]
//  325 
//  326 	//设置VCO分频器，使能PLL为100MHz, LOLIE=0, PLLS=1, CME=0, VDIV=26
//  327 	MCG_C6 = MCG_C6_PLLS_MASK | MCG_C6_VDIV(0x10);	//	24 - 55
        LDR.N    R0,??DataTable17_32  ;; 0x40064005
        MOVS     R1,#+80
        STRB     R1,[R0, #+0]
//  328 	/*
//  329 	Generate an interrupt request on loss of lock.
//  330 	PLL Select
//  331 	Controls whether the PLL or FLL output is selected as the MCG source when CLKS[1:0]=00. If the PLLS
//  332 	bit is cleared and PLLCLKEN is not set, the PLL is disabled in all modes. If the PLLS is set, the FLL is
//  333 	disabled in all modes.
//  334 	0 FLL is selected.
//  335 	1 PLL is selected (PRDIV need to be programmed to the correct divider to generate a PLL reference
//  336 	clock in the range of 2 - 4 MHz prior to setting the PLLS bit).
//  337 	*/
//  338 	//	00000 24	 01000 32	 10000 40	 11000 48
//  339 	//	00001 25	 01001 33	 10001 41	 11001 49
//  340 	//	00010 26	 01010 34	 10010 42	 11010 50
//  341 	//	00011 27	 01011 35	 10011 43	 11011 51
//  342 	//	00100 28	 01100 36	 10100 44	 11100 52
//  343 	//	00101 29	 01101 37	 10101 45	 11101 53
//  344 	//	00110 30	 01110 38	 10110 46	 11110 54
//  345 	//	00111 31	 01111 39	 10111 47	 11111 55
//  346 
//  347 	while (!(MCG_S & MCG_S_PLLST_MASK)){}; // wait for PLL status bit to set    
??Pll_Init_2:
        LDR.N    R0,??DataTable17_30  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+26
        BPL.N    ??Pll_Init_2
//  348 	while (!(MCG_S & MCG_S_LOCK_MASK)){}; // Wait for LOCK bit to set    
??Pll_Init_3:
        LDR.N    R0,??DataTable17_30  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+25
        BPL.N    ??Pll_Init_3
//  349 
//  350 	//进入PBE模式    
//  351 	//通过清零CLKS位来进入PEE模式
//  352 	// CLKS=0, FRDIV=3, IREFS=0, IRCLKEN=0, IREFSTEN=0
//  353 	MCG_C1 &= ~MCG_C1_CLKS_MASK;
        LDR.N    R0,??DataTable17_29  ;; 0x40064000
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0x3F
        LDR.N    R1,??DataTable17_29  ;; 0x40064000
        STRB     R0,[R1, #+0]
//  354 
//  355 	//等待时钟状态位更新
//  356 	while (((MCG_S & MCG_S_CLKST_MASK) >> MCG_S_CLKST_SHIFT) != 0x3){};
??Pll_Init_4:
        LDR.N    R0,??DataTable17_30  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        UBFX     R0,R0,#+2,#+2
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+3
        BNE.N    ??Pll_Init_4
//  357 	//SIM_CLKDIV2 |= SIM_CLKDIV2_USBDIV(1);    
//  358 
//  359 	/*	//时钟检测
//  360 	//设置跟踪时钟为内核时钟
//  361 	SIM_SOPT2 |= SIM_SOPT2_TRACECLKSEL_MASK; 
//  362 	//在PTA6引脚上使能TRACE_CLKOU功能
//  363 	PORTA_PCR6 = ( PORT_PCR_MUX(0x7));  
//  364 	*/
//  365 }
        BX       LR               ;; return
//  366 
//  367 

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
//  368 void main(void)
//  369 {	
main:
        PUSH     {R4,R5,LR}
        SUB      SP,SP,#+28
//  370 	int i=0;
        MOVS     R4,#+0
//  371         uint8 info[9];
//  372         DRESULT sd_state;    //SD卡操作状态
//  373         //SD数据缓存
//  374         uint8  sdhc_dat_buffer1[512];      
//  375         uint8  sdhc_dat_buffer2[512];
//  376         //FAT32文件系统变量
//  377         uint8 CreateTime[6]={0x09,0x07,0x0d,0x0d,0x14,0x0f};
        ADD      R0,SP,#+16
        ADR.W    R1,`?<Constant {9, 7, 13, 13, 20, 15}>`
        LDM      R1!,{R2,R3}
        STM      R0!,{R2,R3}
        SUBS     R1,R1,#+8
        SUBS     R0,R0,#+8
//  378                
//  379         info[0]=0x53;
        MOVS     R0,#+83
        STRB     R0,[SP, #+4]
//  380         info[1]=0x65;
        MOVS     R0,#+101
        STRB     R0,[SP, #+5]
//  381         info[2]=0x72;
        MOVS     R0,#+114
        STRB     R0,[SP, #+6]
//  382         info[3]=0x61;
        MOVS     R0,#+97
        STRB     R0,[SP, #+7]
//  383         info[4]=0x70;
        MOVS     R0,#+112
        STRB     R0,[SP, #+8]
//  384         info[5]=0x68;
        MOVS     R0,#+104
        STRB     R0,[SP, #+9]
//  385         info[6]=0x6C;
        MOVS     R0,#+108
        STRB     R0,[SP, #+10]
//  386         info[7]=0x69;
        MOVS     R0,#+105
        STRB     R0,[SP, #+11]
//  387         info[8]=0x69;
        MOVS     R0,#+105
        STRB     R0,[SP, #+12]
//  388         
//  389         Pll_Init();   //设置系统主频率 
        BL       Pll_Init
//  390 	//关中断
//  391         DisableInterrupts;
        CPSID i         
//  392         //SDHC模式初始化
//  393         sd_state = disk_initialize(0);
        MOVS     R0,#+0
        BL       disk_initialize
        MOVS     R5,R0
//  394         //FAT32 struct init
//  395         pArg=&FatArg;
        LDR.N    R0,??DataTable17_36
        LDR.N    R1,??DataTable17_37
        STR      R1,[R0, #+0]
//  396         FAT32_Init();
        BL       FAT32_Init
//  397         InitColorTable(ColorTable);
        LDR.N    R0,??DataTable17_38
        BL       InitColorTable
//  398         
//  399 	//开启各个GPIO口的转换时钟
//  400 	SIM_SCGC5 = SIM_SCGC5_PORTA_MASK | SIM_SCGC5_PORTB_MASK | SIM_SCGC5_PORTC_MASK | SIM_SCGC5_PORTD_MASK | SIM_SCGC5_PORTE_MASK;
        LDR.N    R0,??DataTable17_39  ;; 0x40048038
        MOV      R1,#+15872
        STR      R1,[R0, #+0]
//  401 	
//  402 	//禁止总中断
//  403         // PIT_Init();
//  404         //PORTA_PCR10 = 1 << 8 | 1 << 5;
//  405 	//GPIOA_PDDR |= 1 << 10;
//  406         
//  407         //开中断
//  408         EnableInterrupts;
        CPSIE i         
//  409         //enable_irq(70);
//  410         //PIT_TCTRL2 |= PIT_TCTRL_TIE_MASK;
//  411 	//IRQ_Init();
//  412         //Timer_Init();
//  413         
//  414 	for(;;)  
//  415 	{	
//  416            /* gpline=0;                          //一场中行计数清零
//  417             gpflag=0;                          //清除场采集结束标志
//  418             gppoint=0;
//  419              
//  420             PORTD_PCR8 = 1 << 8 ;
//  421 	    GPIOD_PDDR |= 0 << 8;
//  422             while((GPIOD_PDIR & (~GPIO_PDIR_PDI(8)))!= 0x0) ;
//  423             
//  424             Timer0(0x15A0);
//  425         
//  426             PIT_TCTRL0 |= PIT_TCTRL_TEN_MASK;
//  427             enable_irq(68);
//  428             
//  429             while(GPflag==0);   
//  430             
//  431             
//  432             
//  433             
//  434 	    PORTA_PCR10 = 1 << 8 | 1 << 5;
//  435 	    GPIOA_PDDR |= 1 << 10;*/
//  436 		//用户添加自己的代码
//  437             //enable_irq(90);
//  438             
//  439             
//  440             
//  441             
//  442             //disable_irq(90);
//  443           
//  444          
//  445             if (RES_OK == sd_state&&i==0/**/)
??main_0:
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R5,#+0
        BNE.N    ??main_0
        CMP      R4,#+0
        BNE.N    ??main_0
//  446             {
//  447                 FAT32_Create_File(&FileInfo,"\\3.txt",CreateTime);
        ADD      R2,SP,#+16
        ADR.W    R1,`?<Constant "\\\\3.txt">`
        LDR.N    R0,??DataTable17_40
        BL       FAT32_Create_File
//  448 	        FAT32_Add_Dat(&FileInfo,sizeof(info),info);
        ADD      R2,SP,#+4
        MOVS     R1,#+9
        LDR.N    R0,??DataTable17_40
        BL       FAT32_Add_Dat
//  449                 FAT32_Add_Dat(&FileInfo,sizeof(info),info);
        ADD      R2,SP,#+4
        MOVS     R1,#+9
        LDR.N    R0,??DataTable17_40
        BL       FAT32_Add_Dat
//  450                 
//  451 	          BmpBIT8Write(/*&FileInfo,*/"\\6.bmp",80,70,pic,ColorTable);
        LDR.N    R0,??DataTable17_38
        STR      R0,[SP, #+0]
        LDR.N    R3,??DataTable17_41
        MOVS     R2,#+70
        MOVS     R1,#+80
        ADR.W    R0,`?<Constant "\\\\6.bmp">`
        BL       BmpBIT8Write
//  452                 
//  453                 
//  454                 i++;
        ADDS     R4,R4,#+1
        B.N      ??main_0
//  455             }
//  456           
//  457 	}	
//  458 }

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17:
        DC32     0x4004903c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_1:
        DC32     0x4004b000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_2:
        DC32     0x400ff094

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_3:
        DC32     0x400490a0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_4:
        DC32     LieCount

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_5:
        DC32     CLie

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_6:
        DC32     RowCount

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_7:
        DC32     Pic

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_8:
        DC32     0x400ff090

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_9:
        DC32     GPflag

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_10:
        DC32     0x40037108

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_11:
        DC32     0x4004c0a0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_12:
        DC32     0x4004803c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_13:
        DC32     0x40037000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_14:
        DC32     0x40037100

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_15:
        DC32     0x4003710c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_16:
        DC32     0x40037110

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_17:
        DC32     0x40037118

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_18:
        DC32     0x4003711c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_19:
        DC32     0x400ff00c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_20:
        DC32     0x40037120

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_21:
        DC32     0x40037128

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_22:
        DC32     0x4003712c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_23:
        DC32     0x40037130

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_24:
        DC32     0x40037138

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_25:
        DC32     0x4003713c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_26:
        DC32     0x40064001

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_27:
        DC32     0x40048034

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_28:
        DC32     0x4007c008

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_29:
        DC32     0x40064000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_30:
        DC32     0x40064006

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_31:
        DC32     0x40064004

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_32:
        DC32     0x40064005

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_33:
        DC32     0x4001f000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_34:
        DC32     0x40048044

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_35:
        DC32     0x1130000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_36:
        DC32     pArg

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_37:
        DC32     FatArg

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_38:
        DC32     ColorTable

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_39:
        DC32     0x40048038

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_40:
        DC32     FileInfo

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_41:
        DC32     pic

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant {9, 7, 13, 13, 20, 15}>`:
        ; Initializer data, 8 bytes
        DC8 9, 7, 13, 13, 20, 15, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "\\\\3.txt">`:
        ; Initializer data, 8 bytes
        DC8 92, 51, 46, 116, 120, 116, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "\\\\6.bmp">`:
        ; Initializer data, 8 bytes
        DC8 92, 54, 46, 98, 109, 112, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
GetPic:
        ; Initializer data, 244 bytes
        DC32 20, 24, 28, 32, 36, 40, 44, 48, 52, 56
        DC32 59, 62, 65, 68, 71, 74, 77, 80, 83, 86
        DC32 89, 91, 93, 95, 97, 99, 101, 103, 105, 107
        DC32 109, 110, 111, 112, 113, 114, 115, 116, 117, 118
        DC32 119, 120, 121, 122, 123, 124, 125, 126, 127, 128
        DC32 129, 130, 131, 132, 133, 134, 135, 136, 137, 138
        DC32 139

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
//  459 
//  460 
//  461 
//  462 
// 
// 12 752 bytes in section .bss
//  1 282 bytes in section .text
// 
//  1 282 bytes of CODE memory
// 12 752 bytes of DATA memory
//
//Errors: none
//Warnings: 14
