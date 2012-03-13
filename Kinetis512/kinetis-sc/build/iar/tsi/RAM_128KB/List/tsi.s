///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      04/Mar/2012  17:42:30 /
// IAR ANSI C/C++ Compiler V6.10.1.22143/W32 EVALUATION for ARM               /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\tsi\ /
//                    tsi.c                                                   /
//    Command line =  "F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\tsi /
//                    \tsi.c" -D IAR -D TWR_K60N512 -lCN "F:\My               /
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
//                    _128KB\List\tsi.s                                       /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME tsi

        EXTERN delay
        EXTERN enable_irq

        PUBLIC TSI_Init
        PUBLIC TSI_SelfCalibration
        PUBLIC TSI_isr
        PUBLIC g16ElectrodeBaseline
        PUBLIC g16ElectrodeTouch
        PUBLIC g32DebounceCounter

// F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\tsi\tsi.c
//    1 
//    2 #include "TSI.h"
//    3 
//    4 extern uint32 __VECTOR_RAM[];
//    5 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//    6 uint16  g16ElectrodeTouch[16] = {0};
g16ElectrodeTouch:
        DS8 32

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//    7 uint16  g16ElectrodeBaseline[16] = {0};
g16ElectrodeBaseline:
        DS8 32
//    8 

        SECTION `.data`:DATA:REORDER:NOROOT(2)
//    9 uint32  g32DebounceCounter[16] = {DBOUNCE_COUNTS};
g32DebounceCounter:
        DATA
        DC32 16
        DC8 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DC8 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DC8 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DC8 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
//   10 
//   11 /********************************************************************************
//   12  *   TSI_Init: Initializes TSI module
//   13  * Notes:
//   14  *    -
//   15  ********************************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   16 void TSI_Init(void)
//   17 {
TSI_Init:
        PUSH     {R7,LR}
//   18   SIM_SCGC5 |= (SIM_SCGC5_TSI_MASK); //Turn on clock to TSI module
        LDR.N    R0,??DataTable2  ;; 0x40048038
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x20
        LDR.N    R1,??DataTable2  ;; 0x40048038
        STR      R0,[R1, #+0]
//   19 
//   20 #ifdef TWR_K60N512
//   21   PORTA_PCR4 = PORT_PCR_MUX(0);      //Enable ALT0 for portA4
        LDR.N    R0,??DataTable2_1  ;; 0x40049010
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//   22   PORTB_PCR2 = PORT_PCR_MUX(0);      //Enable ALT0 for portB2
        LDR.N    R0,??DataTable2_2  ;; 0x4004a008
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//   23   PORTB_PCR3 = PORT_PCR_MUX(0);      //Enable ALT0 for portB3
        LDR.N    R0,??DataTable2_3  ;; 0x4004a00c
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//   24   PORTB_PCR16 = PORT_PCR_MUX(0);      //Enable ALT0 for portB16
        LDR.N    R0,??DataTable2_4  ;; 0x4004a040
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//   25 
//   26 #else
//   27   PORTB_PCR16 = PORT_PCR_MUX(0);      //Enable ALT0 for portB16
//   28   PORTB_PCR17 = PORT_PCR_MUX(0);      //Enable ALT0 for portB17
//   29   PORTB_PCR18 = PORT_PCR_MUX(0);      //Enable ALT0 for portB18
//   30   PORTB_PCR19 = PORT_PCR_MUX(0);      //Enable ALT0 for portB19
//   31 
//   32 #endif
//   33 
//   34   TSI0_GENCS |= ((TSI_GENCS_NSCN(10))|(TSI_GENCS_PS(3)));
        LDR.N    R0,??DataTable2_5  ;; 0x40045000
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x530000
        LDR.N    R1,??DataTable2_5  ;; 0x40045000
        STR      R0,[R1, #+0]
//   35   TSI0_SCANC |= ((TSI_SCANC_EXTCHRG(3))|(TSI_SCANC_REFCHRG(31))|(TSI_SCANC_DELVOL(7))|(TSI_SCANC_SMOD(0))|(TSI_SCANC_AMPSC(0)));
        LDR.N    R0,??DataTable2_6  ;; 0x40045004
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable2_7  ;; 0xf81f0000
        ORRS     R0,R1,R0
        LDR.N    R1,??DataTable2_6  ;; 0x40045004
        STR      R0,[R1, #+0]
//   36 
//   37   ELECTRODE_ENABLE_REG = ELECTRODE0_EN_MASK|ELECTRODE1_EN_MASK|ELECTRODE2_EN_MASK|ELECTRODE3_EN_MASK;
        LDR.N    R0,??DataTable2_8  ;; 0x40045008
        MOV      R1,#+928
        STR      R1,[R0, #+0]
//   38 
//   39   TSI0_GENCS |= (TSI_GENCS_TSIEN_MASK);  //Enables TSI
        LDR.N    R0,??DataTable2_5  ;; 0x40045000
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.N    R1,??DataTable2_5  ;; 0x40045000
        STR      R0,[R1, #+0]
//   40 
//   41   /* Init TSI interrupts */
//   42   enable_irq(83);  //TSI Vector is 99. IRQ# is 99-16=83
        MOVS     R0,#+83
        BL       enable_irq
//   43   /***********************/
//   44 
//   45 }
        POP      {R0,PC}          ;; return
//   46 
//   47 /********************************************************************************
//   48  *   TSI_SelfCalibration: Simple auto calibration version
//   49  * Notes:
//   50  *    - Very simple, only sums a prefixed amount to the current baseline
//   51  ********************************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   52 void TSI_SelfCalibration(void)
//   53 {
TSI_SelfCalibration:
        PUSH     {R7,LR}
//   54   TSI0_GENCS |= TSI_GENCS_SWTS_MASK;
        LDR.N    R0,??DataTable2_5  ;; 0x40045000
        LDR      R0,[R0, #+0]
        MOV      R1,#+256
        ORRS     R0,R1,R0
        LDR.N    R1,??DataTable2_5  ;; 0x40045000
        STR      R0,[R1, #+0]
//   55 
//   56   while(!TSI0_GENCS&TSI_GENCS_EOSF_MASK){};
        LDR.N    R0,??DataTable2_5  ;; 0x40045000
        LDR      R0,[R0, #+0]
        CMP      R0,#+0
        BNE.N    ??TSI_SelfCalibration_0
        MOVS     R0,#+1
        B.N      ??TSI_SelfCalibration_1
??TSI_SelfCalibration_0:
        MOVS     R0,#+0
//   57 
//   58   delay(25000);
??TSI_SelfCalibration_1:
        MOVW     R0,#+25000
        BL       delay
//   59 
//   60   g16ElectrodeBaseline[ELECTRODE0] = ELECTRODE0_COUNT;
        LDR.N    R0,??DataTable2_9  ;; 0x40045108
        LDR      R0,[R0, #+0]
        LSRS     R0,R0,#+16
        LDR.N    R1,??DataTable2_10
        STRH     R0,[R1, #+0]
//   61   ELECTRODE0_OVERRUN = (uint32)((g16ElectrodeBaseline[ELECTRODE0]+ELECTRODE0_OVRRUN));
        LDR.N    R0,??DataTable2_10
        LDRH     R0,[R0, #+0]
        ADDS     R0,R0,#+61440
        LDR.N    R1,??DataTable2_11  ;; 0x40045134
        STR      R0,[R1, #+0]
//   62   g16ElectrodeTouch[ELECTRODE0] = g16ElectrodeBaseline[ELECTRODE0] + ELECTRODE0_TOUCH;
        LDR.N    R0,??DataTable2_10
        LDRH     R0,[R0, #+0]
        ADDW     R0,R0,#+512
        LDR.N    R1,??DataTable2_12
        STRH     R0,[R1, #+0]
//   63 
//   64   g16ElectrodeBaseline[ELECTRODE1] = ELECTRODE1_COUNT;
        LDR.N    R0,??DataTable2_10
        LDR.N    R1,??DataTable2_13  ;; 0x4004510c
        LDR      R1,[R1, #+0]
        LSRS     R1,R1,#+16
        STRH     R1,[R0, #+2]
//   65   ELECTRODE1_OVERRUN = (uint32)((g16ElectrodeBaseline[ELECTRODE1]+ELECTRODE1_OVRRUN));
        LDR.N    R0,??DataTable2_10
        LDRH     R0,[R0, #+2]
        ADDS     R0,R0,#+61440
        LDR.N    R1,??DataTable2_14  ;; 0x4004513c
        STR      R0,[R1, #+0]
//   66   g16ElectrodeTouch[ELECTRODE1] = g16ElectrodeBaseline[ELECTRODE1] + ELECTRODE1_TOUCH;
        LDR.N    R0,??DataTable2_10
        LDRH     R0,[R0, #+2]
        ADDW     R0,R0,#+512
        LDR.N    R1,??DataTable2_12
        STRH     R0,[R1, #+2]
//   67 
//   68   g16ElectrodeBaseline[ELECTRODE2] = ELECTRODE2_COUNT;
        LDR.N    R0,??DataTable2_10
        LDR.N    R1,??DataTable2_15  ;; 0x40045110
        LDR      R1,[R1, #+0]
        STRH     R1,[R0, #+4]
//   69   ELECTRODE2_OVERRUN = (uint32)((g16ElectrodeBaseline[ELECTRODE2]+ELECTRODE2_OVRRUN));
        LDR.N    R0,??DataTable2_10
        LDRH     R0,[R0, #+4]
        ADDS     R0,R0,#+61440
        LDR.N    R1,??DataTable2_16  ;; 0x40045140
        STR      R0,[R1, #+0]
//   70   g16ElectrodeTouch[ELECTRODE2] = g16ElectrodeBaseline[ELECTRODE2] + ELECTRODE2_TOUCH;
        LDR.N    R0,??DataTable2_10
        LDRH     R0,[R0, #+4]
        ADDW     R0,R0,#+512
        LDR.N    R1,??DataTable2_12
        STRH     R0,[R1, #+4]
//   71 
//   72   g16ElectrodeBaseline[ELECTRODE3] = ELECTRODE3_COUNT;
        LDR.N    R0,??DataTable2_10
        LDR.N    R1,??DataTable2_15  ;; 0x40045110
        LDR      R1,[R1, #+0]
        LSRS     R1,R1,#+16
        STRH     R1,[R0, #+6]
//   73   ELECTRODE3_OVERRUN = (uint32)((g16ElectrodeBaseline[ELECTRODE3]+ELECTRODE3_OVRRUN));
        LDR.N    R0,??DataTable2_10
        LDRH     R0,[R0, #+6]
        ADDS     R0,R0,#+61440
        LDR.N    R1,??DataTable2_17  ;; 0x40045144
        STR      R0,[R1, #+0]
//   74   g16ElectrodeTouch[ELECTRODE3] = g16ElectrodeBaseline[ELECTRODE3] + ELECTRODE3_TOUCH;
        LDR.N    R0,??DataTable2_10
        LDRH     R0,[R0, #+6]
        ADDW     R0,R0,#+512
        LDR.N    R1,??DataTable2_12
        STRH     R0,[R1, #+6]
//   75 
//   76   DISABLE_TSI;
        LDR.N    R0,??DataTable2_5  ;; 0x40045000
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x80
        LDR.N    R1,??DataTable2_5  ;; 0x40045000
        STR      R0,[R1, #+0]
//   77 
//   78 }
        POP      {R0,PC}          ;; return
//   79 
//   80 /********************************************************************************
//   81  *   TSI_isr: TSI interrupt subroutine
//   82  * Notes:
//   83  *    -
//   84  ********************************************************************************/
//   85 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   86 void TSI_isr(void)
//   87 {
//   88   static uint16 TouchEvent = 0;
//   89   uint16 lValidTouch = 0;
TSI_isr:
        MOVS     R0,#+0
//   90   uint16 l16Counter;
//   91 
//   92   TSI0_GENCS |= TSI_GENCS_OUTRGF_MASK;
        LDR.N    R1,??DataTable2_5  ;; 0x40045000
        LDR      R1,[R1, #+0]
        ORRS     R1,R1,#0x4000
        LDR.N    R2,??DataTable2_5  ;; 0x40045000
        STR      R1,[R2, #+0]
//   93   TSI0_GENCS |= TSI_GENCS_EOSF_MASK;
        LDR.N    R1,??DataTable2_5  ;; 0x40045000
        LDR      R1,[R1, #+0]
        ORRS     R1,R1,#0x8000
        LDR.N    R2,??DataTable2_5  ;; 0x40045000
        STR      R1,[R2, #+0]
//   94 
//   95 
//   96   /* Process electrode 0 */
//   97   l16Counter = ELECTRODE0_COUNT;
        LDR.N    R1,??DataTable2_9  ;; 0x40045108
        LDR      R1,[R1, #+0]
        LSRS     R1,R1,#+16
//   98   if(l16Counter>g16ElectrodeTouch[ELECTRODE0]) //See if detected a touch
        LDR.N    R2,??DataTable2_12
        LDRH     R2,[R2, #+0]
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        CMP      R2,R1
        BCS.N    ??TSI_isr_0
//   99   {
//  100     TouchEvent |= (1<<ELECTRODE0); //Set touch event variable
        LDR.N    R1,??DataTable2_18
        LDRH     R1,[R1, #+0]
        ORRS     R1,R1,#0x1
        LDR.N    R2,??DataTable2_18
        STRH     R1,[R2, #+0]
//  101     g32DebounceCounter[ELECTRODE0]--; //Decrement debounce counter
        LDR.N    R1,??DataTable2_19
        LDR      R1,[R1, #+0]
        SUBS     R1,R1,#+1
        LDR.N    R2,??DataTable2_19
        STR      R1,[R2, #+0]
//  102     if(!g32DebounceCounter[ELECTRODE0]) //If debounce counter reaches 0....
        LDR.N    R1,??DataTable2_19
        LDR      R1,[R1, #+0]
        CMP      R1,#+0
        BNE.N    ??TSI_isr_1
//  103     {
//  104       lValidTouch |= ((1<<ELECTRODE0)); //Signal that a valid touch has been detected
        ORRS     R0,R0,#0x1
//  105       TouchEvent &= ~(1<<ELECTRODE0);  //Clear touch event variable
        LDR.N    R1,??DataTable2_18
        LDRH     R1,[R1, #+0]
        MOVW     R2,#+65534
        ANDS     R1,R2,R1
        LDR.N    R2,??DataTable2_18
        STRH     R1,[R2, #+0]
        B.N      ??TSI_isr_1
//  106     }
//  107   }
//  108   else
//  109   {
//  110     TouchEvent &= ~(1<<ELECTRODE0); //Clear touch event variable
??TSI_isr_0:
        LDR.N    R1,??DataTable2_18
        LDRH     R1,[R1, #+0]
        MOVW     R2,#+65534
        ANDS     R1,R2,R1
        LDR.N    R2,??DataTable2_18
        STRH     R1,[R2, #+0]
//  111     g32DebounceCounter[ELECTRODE0] = DBOUNCE_COUNTS; //Reset debounce counter
        LDR.N    R1,??DataTable2_19
        MOVS     R2,#+16
        STR      R2,[R1, #+0]
//  112   }
//  113   /***********************/
//  114 
//  115   /* Process electrode 1 */
//  116   l16Counter = ELECTRODE1_COUNT;
??TSI_isr_1:
        LDR.N    R1,??DataTable2_13  ;; 0x4004510c
        LDR      R1,[R1, #+0]
        LSRS     R1,R1,#+16
//  117   if(l16Counter>g16ElectrodeTouch[ELECTRODE1])
        LDR.N    R2,??DataTable2_12
        LDRH     R2,[R2, #+2]
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        CMP      R2,R1
        BCS.N    ??TSI_isr_2
//  118   {
//  119     TouchEvent |= (1<<ELECTRODE1);
        LDR.N    R1,??DataTable2_18
        LDRH     R1,[R1, #+0]
        ORRS     R1,R1,#0x2
        LDR.N    R2,??DataTable2_18
        STRH     R1,[R2, #+0]
//  120     g32DebounceCounter[ELECTRODE1]--;
        LDR.N    R1,??DataTable2_19
        LDR      R1,[R1, #+4]
        SUBS     R1,R1,#+1
        LDR.N    R2,??DataTable2_19
        STR      R1,[R2, #+4]
//  121     if(!g32DebounceCounter[ELECTRODE1])
        LDR.N    R1,??DataTable2_19
        LDR      R1,[R1, #+4]
        CMP      R1,#+0
        BNE.N    ??TSI_isr_3
//  122     {
//  123       lValidTouch |= ((1<<ELECTRODE1));
        ORRS     R0,R0,#0x2
//  124       TouchEvent &= ~(1<<ELECTRODE1);
        LDR.N    R1,??DataTable2_18
        LDRH     R1,[R1, #+0]
        MOVW     R2,#+65533
        ANDS     R1,R2,R1
        LDR.N    R2,??DataTable2_18
        STRH     R1,[R2, #+0]
        B.N      ??TSI_isr_3
//  125     }
//  126   }
//  127   else
//  128   {
//  129     TouchEvent &= ~(1<<ELECTRODE1);
??TSI_isr_2:
        LDR.N    R1,??DataTable2_18
        LDRH     R1,[R1, #+0]
        MOVW     R2,#+65533
        ANDS     R1,R2,R1
        LDR.N    R2,??DataTable2_18
        STRH     R1,[R2, #+0]
//  130     g32DebounceCounter[ELECTRODE1] = DBOUNCE_COUNTS;
        LDR.N    R1,??DataTable2_19
        MOVS     R2,#+16
        STR      R2,[R1, #+4]
//  131   }
//  132   /***********************/
//  133 
//  134   /* Process electrode 2 */
//  135   l16Counter = ELECTRODE2_COUNT;
??TSI_isr_3:
        LDR.N    R1,??DataTable2_15  ;; 0x40045110
        LDR      R1,[R1, #+0]
//  136   if(l16Counter>g16ElectrodeTouch[ELECTRODE2])
        LDR.N    R2,??DataTable2_12
        LDRH     R2,[R2, #+4]
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        CMP      R2,R1
        BCS.N    ??TSI_isr_4
//  137   {
//  138     TouchEvent |= (1<<ELECTRODE2);
        LDR.N    R1,??DataTable2_18
        LDRH     R1,[R1, #+0]
        ORRS     R1,R1,#0x4
        LDR.N    R2,??DataTable2_18
        STRH     R1,[R2, #+0]
//  139     g32DebounceCounter[ELECTRODE2]--;
        LDR.N    R1,??DataTable2_19
        LDR      R1,[R1, #+8]
        SUBS     R1,R1,#+1
        LDR.N    R2,??DataTable2_19
        STR      R1,[R2, #+8]
//  140     if(!g32DebounceCounter[ELECTRODE2])
        LDR.N    R1,??DataTable2_19
        LDR      R1,[R1, #+8]
        CMP      R1,#+0
        BNE.N    ??TSI_isr_5
//  141     {
//  142       lValidTouch |= ((1<<ELECTRODE2));
        ORRS     R0,R0,#0x4
//  143       TouchEvent &= ~(1<<ELECTRODE2);
        LDR.N    R1,??DataTable2_18
        LDRH     R1,[R1, #+0]
        MOVW     R2,#+65531
        ANDS     R1,R2,R1
        LDR.N    R2,??DataTable2_18
        STRH     R1,[R2, #+0]
        B.N      ??TSI_isr_5
//  144     }
//  145   }
//  146   else
//  147   {
//  148     TouchEvent &= ~(1<<ELECTRODE2);
??TSI_isr_4:
        LDR.N    R1,??DataTable2_18
        LDRH     R1,[R1, #+0]
        MOVW     R2,#+65531
        ANDS     R1,R2,R1
        LDR.N    R2,??DataTable2_18
        STRH     R1,[R2, #+0]
//  149     g32DebounceCounter[ELECTRODE2] = DBOUNCE_COUNTS;
        LDR.N    R1,??DataTable2_19
        MOVS     R2,#+16
        STR      R2,[R1, #+8]
//  150   }
//  151   /***********************/
//  152 
//  153   /* Process electrode 3 */
//  154   l16Counter = ELECTRODE3_COUNT;
??TSI_isr_5:
        LDR.N    R1,??DataTable2_15  ;; 0x40045110
        LDR      R1,[R1, #+0]
        LSRS     R1,R1,#+16
//  155   if(l16Counter>g16ElectrodeTouch[ELECTRODE3])
        LDR.N    R2,??DataTable2_12
        LDRH     R2,[R2, #+6]
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        CMP      R2,R1
        BCS.N    ??TSI_isr_6
//  156   {
//  157     TouchEvent |= (1<<ELECTRODE3);
        LDR.N    R1,??DataTable2_18
        LDRH     R1,[R1, #+0]
        ORRS     R1,R1,#0x8
        LDR.N    R2,??DataTable2_18
        STRH     R1,[R2, #+0]
//  158     g32DebounceCounter[ELECTRODE3]--;
        LDR.N    R1,??DataTable2_19
        LDR      R1,[R1, #+12]
        SUBS     R1,R1,#+1
        LDR.N    R2,??DataTable2_19
        STR      R1,[R2, #+12]
//  159     if(!g32DebounceCounter[ELECTRODE3])
        LDR.N    R1,??DataTable2_19
        LDR      R1,[R1, #+12]
        CMP      R1,#+0
        BNE.N    ??TSI_isr_7
//  160     {
//  161       lValidTouch |= ((1<<ELECTRODE3));
        ORRS     R0,R0,#0x8
//  162       TouchEvent &= ~(1<<ELECTRODE3);
        LDR.N    R1,??DataTable2_18
        LDRH     R1,[R1, #+0]
        MOVW     R2,#+65527
        ANDS     R1,R2,R1
        LDR.N    R2,??DataTable2_18
        STRH     R1,[R2, #+0]
        B.N      ??TSI_isr_7
//  163     }
//  164   }
//  165   else
//  166   {
//  167     TouchEvent &= ~(1<<ELECTRODE3);
??TSI_isr_6:
        LDR.N    R1,??DataTable2_18
        LDRH     R1,[R1, #+0]
        MOVW     R2,#+65527
        ANDS     R1,R2,R1
        LDR.N    R2,??DataTable2_18
        STRH     R1,[R2, #+0]
//  168     g32DebounceCounter[ELECTRODE3] = DBOUNCE_COUNTS;
        LDR.N    R1,??DataTable2_19
        MOVS     R2,#+16
        STR      R2,[R1, #+12]
//  169   }
//  170   /***********************/
//  171 
//  172   if(lValidTouch&((1<<ELECTRODE0))) //If detected a valid touch...
??TSI_isr_7:
        LSLS     R1,R0,#+31
        BPL.N    ??TSI_isr_8
//  173   {
//  174     LED0_TOGGLE; //Toggle LED
        LDR.N    R1,??DataTable2_20  ;; 0x400ff00c
        MOV      R2,#+2048
        STR      R2,[R1, #+0]
//  175     lValidTouch &= ~((1<<ELECTRODE0)); //Clear valid touch
        MOVW     R1,#+65534
        ANDS     R0,R1,R0
//  176   }
//  177   if(lValidTouch&((1<<ELECTRODE1)))
??TSI_isr_8:
        LSLS     R1,R0,#+30
        BPL.N    ??TSI_isr_9
//  178   {
//  179     LED1_TOGGLE;
        LDR.N    R1,??DataTable2_20  ;; 0x400ff00c
        MOVS     R2,#+536870912
        STR      R2,[R1, #+0]
//  180     lValidTouch &= ~((1<<ELECTRODE1));
        MOVW     R1,#+65533
        ANDS     R0,R1,R0
//  181   }
//  182   if(lValidTouch&((1<<ELECTRODE2)))
??TSI_isr_9:
        LSLS     R1,R0,#+29
        BPL.N    ??TSI_isr_10
//  183   {
//  184     LED2_TOGGLE;
        LDR.N    R1,??DataTable2_20  ;; 0x400ff00c
        MOVS     R2,#+268435456
        STR      R2,[R1, #+0]
//  185     lValidTouch &= ~((1<<ELECTRODE2));
        MOVW     R1,#+65531
        ANDS     R0,R1,R0
//  186   }
//  187   if(lValidTouch&((1<<ELECTRODE3)))
??TSI_isr_10:
        LSLS     R1,R0,#+28
        BPL.N    ??TSI_isr_11
//  188   {
//  189     LED3_TOGGLE;
        LDR.N    R1,??DataTable2_20  ;; 0x400ff00c
        MOV      R2,#+1024
        STR      R2,[R1, #+0]
//  190     lValidTouch &= ~((1<<ELECTRODE3));
        MOVW     R1,#+65527
        ANDS     R0,R1,R0
//  191   }
//  192 
//  193   TSI0_STATUS = 0xFFFFFFFF;
??TSI_isr_11:
        LDR.N    R0,??DataTable2_21  ;; 0x4004500c
        MOVS     R1,#-1
        STR      R1,[R0, #+0]
//  194 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2:
        DC32     0x40048038

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_1:
        DC32     0x40049010

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_2:
        DC32     0x4004a008

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_3:
        DC32     0x4004a00c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_4:
        DC32     0x4004a040

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_5:
        DC32     0x40045000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_6:
        DC32     0x40045004

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_7:
        DC32     0xf81f0000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_8:
        DC32     0x40045008

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_9:
        DC32     0x40045108

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_10:
        DC32     g16ElectrodeBaseline

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_11:
        DC32     0x40045134

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_12:
        DC32     g16ElectrodeTouch

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_13:
        DC32     0x4004510c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_14:
        DC32     0x4004513c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_15:
        DC32     0x40045110

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_16:
        DC32     0x40045140

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_17:
        DC32     0x40045144

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_18:
        DC32     ??TouchEvent

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_19:
        DC32     g32DebounceCounter

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_20:
        DC32     0x400ff00c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable2_21:
        DC32     0x4004500c

        SECTION `.bss`:DATA:REORDER:NOROOT(1)
??TouchEvent:
        DS8 2

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
//  195 
// 
//  66 bytes in section .bss
//  64 bytes in section .data
// 814 bytes in section .text
// 
// 814 bytes of CODE memory
// 130 bytes of DATA memory
//
//Errors: none
//Warnings: none
