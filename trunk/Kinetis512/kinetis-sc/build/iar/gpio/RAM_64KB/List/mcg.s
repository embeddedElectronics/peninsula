///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      06/Mar/2012  12:46:33 /
// IAR ANSI C/C++ Compiler V6.10.1.22143/W32 EVALUATION for ARM               /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  F:\My Works\K60\Kinetis512\kinetis-sc\src\drivers\mcg\m /
//                    cg.c                                                    /
//    Command line =  "F:\My Works\K60\Kinetis512\kinetis-sc\src\drivers\mcg\ /
//                    mcg.c" -D IAR -D TWR_K60N512 -lCN "F:\My                /
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
//                    M_64KB\List\mcg.s                                       /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME mcg

        #define SHT_PROGBITS 0x1
        #define SHF_WRITE 0x1
        #define SHF_EXECINSTR 0x4

        EXTERN core_clk_khz
        EXTERN core_clk_mhz
        EXTERN periph_clk_khz

        PUBLIC mcg_blpi_2_pee
        PUBLIC mcg_pbe_2_pee
        PUBLIC mcg_pee_2_blpi
        PUBLIC pll_init
        PUBLIC set_sys_dividers

// F:\My Works\K60\Kinetis512\kinetis-sc\src\drivers\mcg\mcg.c
//    1 /*
//    2  * File:    mcg.c
//    3  * Purpose: Driver for enabling the PLL in 1 of 4 options
//    4  *
//    5  * Notes:
//    6  * Assumes the MCG mode is in the default FEI mode out of reset
//    7  * One of 4 clocking oprions can be selected.
//    8  * One of 16 crystal values can be used
//    9  */
//   10 
//   11 #include "common.h"
//   12 #include "mcg.h"
//   13 #include "k60_tower.h"
//   14 
//   15 extern int core_clk_khz;
//   16 extern int core_clk_mhz;
//   17 extern int periph_clk_khz;
//   18 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   19 unsigned char pll_init(unsigned char clk_option, unsigned char crystal_val)
//   20 {
pll_init:
        PUSH     {R7,LR}
        MOVS     R2,R1
//   21   unsigned char pll_freq;
//   22 
//   23   if (clk_option > 3) {return 0;} //return 0 if one of the available options is not selected
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+4
        BCC.N    ??pll_init_0
        MOVS     R0,#+0
        B.N      ??pll_init_1
//   24   if (crystal_val > 15) {return 1;} // return 1 if one of the available crystal options is not available
??pll_init_0:
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        CMP      R2,#+16
        BCC.N    ??pll_init_2
        MOVS     R0,#+1
        B.N      ??pll_init_1
//   25 //This assumes that the MCG is in default FEI mode out of reset.
//   26 
//   27 // First move to FBE mode
//   28 #if (defined(K60_CLK) || defined(ASB817))
//   29      MCG_C2 = 0;
??pll_init_2:
        LDR.N    R2,??DataTable3  ;; 0x40064001
        MOVS     R3,#+0
        STRB     R3,[R2, #+0]
//   30 #else
//   31 // Enable external oscillator, RANGE=2, HGO=1, EREFS=1, LP=0, IRCS=0
//   32     MCG_C2 = MCG_C2_RANGE(2) | MCG_C2_HGO_MASK | MCG_C2_EREFS_MASK;
//   33 #endif
//   34 
//   35 // after initialization of oscillator release latched state of oscillator and GPIO
//   36     SIM_SCGC4 |= SIM_SCGC4_LLWU_MASK;
        LDR.N    R2,??DataTable3_1  ;; 0x40048034
        LDR      R2,[R2, #+0]
        ORRS     R2,R2,#0x10000000
        LDR.N    R3,??DataTable3_1  ;; 0x40048034
        STR      R2,[R3, #+0]
//   37     LLWU_CS |= LLWU_CS_ACKISO_MASK;
        LDR.N    R2,??DataTable3_2  ;; 0x4007c008
        LDRB     R2,[R2, #+0]
        ORRS     R2,R2,#0x80
        LDR.N    R3,??DataTable3_2  ;; 0x4007c008
        STRB     R2,[R3, #+0]
//   38   
//   39 // Select external oscilator and Reference Divider and clear IREFS to start ext osc
//   40 // CLKS=2, FRDIV=3, IREFS=0, IRCLKEN=0, IREFSTEN=0
//   41   MCG_C1 = MCG_C1_CLKS(2) | MCG_C1_FRDIV(3);
        LDR.N    R2,??DataTable3_3  ;; 0x40064000
        MOVS     R3,#+152
        STRB     R3,[R2, #+0]
//   42 
//   43   /* if we aren't using an osc input we don't need to wait for the osc to init */
//   44 #if (!defined(K60_CLK) && !defined(ASB817))
//   45     while (!(MCG_S & MCG_S_OSCINIT_MASK)){};  // wait for oscillator to initialize
//   46 #endif
//   47 
//   48   while (MCG_S & MCG_S_IREFST_MASK){}; // wait for Reference clock Status bit to clear
??pll_init_3:
        LDR.N    R2,??DataTable3_4  ;; 0x40064006
        LDRB     R2,[R2, #+0]
        LSLS     R2,R2,#+27
        BMI.N    ??pll_init_3
//   49 
//   50   while (((MCG_S & MCG_S_CLKST_MASK) >> MCG_S_CLKST_SHIFT) != 0x2){}; // Wait for clock status bits to show clock source is ext ref clk
??pll_init_4:
        LDR.N    R2,??DataTable3_4  ;; 0x40064006
        LDRB     R2,[R2, #+0]
        UBFX     R2,R2,#+2,#+2
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        CMP      R2,#+2
        BNE.N    ??pll_init_4
//   51 
//   52 // Now in FBE
//   53 
//   54 #if (defined(K60_CLK))
//   55    MCG_C5 = MCG_C5_PRDIV(0x18);
        LDR.N    R2,??DataTable3_5  ;; 0x40064004
        MOVS     R3,#+24
        STRB     R3,[R2, #+0]
//   56 #else
//   57 // Configure PLL Ref Divider, PLLCLKEN=0, PLLSTEN=0, PRDIV=5
//   58 // The crystal frequency is used to select the PRDIV value. Only even frequency crystals are supported
//   59 // that will produce a 2MHz reference clock to the PLL.
//   60   MCG_C5 = MCG_C5_PRDIV(crystal_val); // Set PLL ref divider to match the crystal used
//   61 #endif
//   62 
//   63   // Ensure MCG_C6 is at the reset default of 0. LOLIE disabled, PLL disabled, clk monitor disabled, PLL VCO divider is clear
//   64   MCG_C6 = 0x0;
        LDR.N    R2,??DataTable3_6  ;; 0x40064005
        MOVS     R3,#+0
        STRB     R3,[R2, #+0]
//   65 // Select the PLL VCO divider and system clock dividers depending on clocking option
//   66   switch (clk_option) {
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??pll_init_5
        CMP      R0,#+2
        BEQ.N    ??pll_init_6
        BCC.N    ??pll_init_7
        CMP      R0,#+3
        BEQ.N    ??pll_init_8
        B.N      ??pll_init_9
//   67     case 0:
//   68       // Set system options dividers
//   69       //MCG=PLL, core = MCG, bus = MCG, FlexBus = MCG, Flash clock= MCG/2
//   70       set_sys_dividers(0,0,0,1);
??pll_init_5:
        MOVS     R3,#+1
        MOVS     R2,#+0
        MOVS     R1,#+0
        MOVS     R0,#+0
        BL       set_sys_dividers
//   71       // Set the VCO divider and enable the PLL for 50MHz, LOLIE=0, PLLS=1, CME=0, VDIV=1
//   72       MCG_C6 = MCG_C6_PLLS_MASK | MCG_C6_VDIV(1); //VDIV = 1 (x25)
        LDR.N    R0,??DataTable3_6  ;; 0x40064005
        MOVS     R1,#+65
        STRB     R1,[R0, #+0]
//   73       pll_freq = 50;
        MOVS     R1,#+50
//   74       break;
        B.N      ??pll_init_9
//   75    case 1:
//   76       // Set system options dividers
//   77       //MCG=PLL, core = MCG, bus = MCG/2, FlexBus = MCG/2, Flash clock= MCG/4
//   78      set_sys_dividers(0,1,1,3);
??pll_init_7:
        MOVS     R3,#+3
        MOVS     R2,#+1
        MOVS     R1,#+1
        MOVS     R0,#+0
        BL       set_sys_dividers
//   79       // Set the VCO divider and enable the PLL for 100MHz, LOLIE=0, PLLS=1, CME=0, VDIV=26
//   80       MCG_C6 = MCG_C6_PLLS_MASK | MCG_C6_VDIV(26); //VDIV = 26 (x50)
        LDR.N    R0,??DataTable3_6  ;; 0x40064005
        MOVS     R1,#+90
        STRB     R1,[R0, #+0]
//   81       pll_freq = 100;
        MOVS     R1,#+100
//   82       break;
        B.N      ??pll_init_9
//   83     case 2:
//   84       // Set system options dividers
//   85       //MCG=PLL, core = MCG, bus = MCG/2, FlexBus = MCG/2, Flash clock= MCG/4
//   86       set_sys_dividers(0,1,1,3);
??pll_init_6:
        MOVS     R3,#+3
        MOVS     R2,#+1
        MOVS     R1,#+1
        MOVS     R0,#+0
        BL       set_sys_dividers
//   87       // Set the VCO divider and enable the PLL for 96MHz, LOLIE=0, PLLS=1, CME=0, VDIV=24
//   88       MCG_C6 = MCG_C6_PLLS_MASK | MCG_C6_VDIV(24); //VDIV = 24 (x48)
        LDR.N    R0,??DataTable3_6  ;; 0x40064005
        MOVS     R1,#+88
        STRB     R1,[R0, #+0]
//   89       pll_freq = 96;
        MOVS     R1,#+96
//   90       break;
        B.N      ??pll_init_9
//   91    case 3:
//   92       // Set system options dividers
//   93       //MCG=PLL, core = MCG, bus = MCG, FlexBus = MCG, Flash clock= MCG/2
//   94       set_sys_dividers(0,0,0,1);
??pll_init_8:
        MOVS     R3,#+1
        MOVS     R2,#+0
        MOVS     R1,#+0
        MOVS     R0,#+0
        BL       set_sys_dividers
//   95       // Set the VCO divider and enable the PLL for 48MHz, LOLIE=0, PLLS=1, CME=0, VDIV=0
//   96       MCG_C6 = MCG_C6_PLLS_MASK; //VDIV = 0 (x24)
        LDR.N    R0,??DataTable3_6  ;; 0x40064005
        MOVS     R1,#+64
        STRB     R1,[R0, #+0]
//   97       pll_freq = 48;
        MOVS     R1,#+48
//   98       break;
//   99   }
//  100   while (!(MCG_S & MCG_S_PLLST_MASK)){}; // wait for PLL status bit to set
??pll_init_9:
        LDR.N    R0,??DataTable3_4  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+26
        BPL.N    ??pll_init_9
//  101 
//  102   while (!(MCG_S & MCG_S_LOCK_MASK)){}; // Wait for LOCK bit to set
??pll_init_10:
        LDR.N    R0,??DataTable3_4  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+25
        BPL.N    ??pll_init_10
//  103 
//  104 // Now running PBE Mode
//  105 
//  106 // Transition into PEE by setting CLKS to 0
//  107 // CLKS=0, FRDIV=3, IREFS=0, IRCLKEN=0, IREFSTEN=0
//  108   MCG_C1 &= ~MCG_C1_CLKS_MASK;
        LDR.N    R0,??DataTable3_3  ;; 0x40064000
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0x3F
        LDR.N    R2,??DataTable3_3  ;; 0x40064000
        STRB     R0,[R2, #+0]
//  109 
//  110 // Wait for clock status bits to update
//  111   while (((MCG_S & MCG_S_CLKST_MASK) >> MCG_S_CLKST_SHIFT) != 0x3){};
??pll_init_11:
        LDR.N    R0,??DataTable3_4  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        UBFX     R0,R0,#+2,#+2
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+3
        BNE.N    ??pll_init_11
//  112 
//  113 // Now running PEE Mode
//  114 
//  115 return pll_freq;
        MOVS     R0,R1
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
??pll_init_1:
        POP      {R1,PC}          ;; return
//  116 } //pll_init
//  117 
//  118 
//  119  /*
//  120   * This routine must be placed in RAM. It is a workaround for errata e2448.
//  121   * Flash prefetch must be disabled when the flash clock divider is changed.
//  122   * This cannot be performed while executing out of flash.
//  123   * There must be a short delay after the clock dividers are changed before prefetch
//  124   * can be re-enabled.
//  125   */
//  126 #if (defined(IAR))

        SECTION `.textrw`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, SHF_WRITE | SHF_EXECINSTR
        THUMB
//  127 	__ramfunc void set_sys_dividers(uint32 outdiv1, uint32 outdiv2, uint32 outdiv3, uint32 outdiv4)
//  128 #elif (defined(CW))
//  129 __relocate_code__ 
//  130 void set_sys_dividers(uint32 outdiv1, uint32 outdiv2, uint32 outdiv3, uint32 outdiv4)
//  131 #endif
//  132 {
set_sys_dividers:
        PUSH     {R4-R6}
//  133   uint32 temp_reg;
//  134   uint8 i;
//  135   
//  136   temp_reg = FMC_PFAPR; // store present value of FMC_PFAPR
        LDR.N    R4,??set_sys_dividers_0  ;; 0x4001f000
        LDR      R4,[R4, #+0]
//  137   
//  138   // set M0PFD through M7PFD to 1 to disable prefetch
//  139   FMC_PFAPR |= FMC_PFAPR_M7PFD_MASK | FMC_PFAPR_M6PFD_MASK | FMC_PFAPR_M5PFD_MASK
//  140              | FMC_PFAPR_M4PFD_MASK | FMC_PFAPR_M3PFD_MASK | FMC_PFAPR_M2PFD_MASK
//  141              | FMC_PFAPR_M1PFD_MASK | FMC_PFAPR_M0PFD_MASK;
        LDR.N    R5,??set_sys_dividers_0  ;; 0x4001f000
        LDR      R5,[R5, #+0]
        ORRS     R5,R5,#0xFF0000
        LDR.N    R6,??set_sys_dividers_0  ;; 0x4001f000
        STR      R5,[R6, #+0]
//  142   
//  143   // set clock dividers to desired value  
//  144   SIM_CLKDIV1 = SIM_CLKDIV1_OUTDIV1(outdiv1) | SIM_CLKDIV1_OUTDIV2(outdiv2) 
//  145               | SIM_CLKDIV1_OUTDIV3(outdiv3) | SIM_CLKDIV1_OUTDIV4(outdiv4);
        LSLS     R1,R1,#+24
        ANDS     R1,R1,#0xF000000
        ORRS     R0,R1,R0, LSL #+28
        LSLS     R1,R2,#+20
        ANDS     R1,R1,#0xF00000
        ORRS     R0,R1,R0
        LSLS     R1,R3,#+16
        ANDS     R1,R1,#0xF0000
        ORRS     R0,R1,R0
        LDR.N    R1,??set_sys_dividers_0+0x4  ;; 0x40048044
        STR      R0,[R1, #+0]
//  146 
//  147   // wait for dividers to change
//  148   for (i = 0 ; i < outdiv4 ; i++)
        MOVS     R0,#+0
        B.N      ??set_sys_dividers_1
??set_sys_dividers_2:
        ADDS     R0,R0,#+1
??set_sys_dividers_1:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,R3
        BCC.N    ??set_sys_dividers_2
//  149   {}
//  150   
//  151   FMC_PFAPR = temp_reg; // re-store original value of FMC_PFAPR
        LDR.N    R0,??set_sys_dividers_0  ;; 0x4001f000
        STR      R4,[R0, #+0]
//  152   
//  153   return;
        POP      {R4-R6}
        BX       LR               ;; return
        DATA
??set_sys_dividers_0:
        DC32     0x4001f000
        DC32     0x40048044
//  154 } // set_sys_dividers
//  155 
//  156 
//  157 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  158 void mcg_pee_2_blpi(void)
//  159 {
//  160     uint8 temp_reg;
//  161     // Transition from PEE to BLPI: PEE -> PBE -> FBE -> FBI -> BLPI
//  162   
//  163     // Step 1: PEE -> PBE
//  164     MCG_C1 |= MCG_C1_CLKS(2);  // System clock from external reference OSC, not PLL.
mcg_pee_2_blpi:
        LDR.N    R0,??DataTable3_3  ;; 0x40064000
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.N    R1,??DataTable3_3  ;; 0x40064000
        STRB     R0,[R1, #+0]
//  165     while (((MCG_S & MCG_S_CLKST_MASK) >> MCG_S_CLKST_SHIFT) != 0x2){};  // Wait for clock status to update.
??mcg_pee_2_blpi_0:
        LDR.N    R0,??DataTable3_4  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        UBFX     R0,R0,#+2,#+2
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+2
        BNE.N    ??mcg_pee_2_blpi_0
//  166     
//  167     // Step 2: PBE -> FBE
//  168     MCG_C6 &= ~MCG_C6_PLLS_MASK;  // Clear PLLS to select FLL, still running system from ext OSC.
        LDR.N    R0,??DataTable3_6  ;; 0x40064005
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0xBF
        LDR.N    R1,??DataTable3_6  ;; 0x40064005
        STRB     R0,[R1, #+0]
//  169     while (MCG_S & MCG_S_PLLST_MASK){};  // Wait for PLL status flag to reflect FLL selected.
??mcg_pee_2_blpi_1:
        LDR.N    R0,??DataTable3_4  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+26
        BMI.N    ??mcg_pee_2_blpi_1
//  170     
//  171     // Step 3: FBE -> FBI
//  172     MCG_C2 &= ~MCG_C2_LP_MASK;  // FLL remains active in bypassed modes.
        LDR.N    R0,??DataTable3  ;; 0x40064001
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0xFD
        LDR.N    R1,??DataTable3  ;; 0x40064001
        STRB     R0,[R1, #+0]
//  173     MCG_C2 |= MCG_C2_IRCS_MASK;  // Select fast (1MHz) internal reference
        LDR.N    R0,??DataTable3  ;; 0x40064001
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable3  ;; 0x40064001
        STRB     R0,[R1, #+0]
//  174     temp_reg = MCG_C1;
        LDR.N    R0,??DataTable3_3  ;; 0x40064000
        LDRB     R0,[R0, #+0]
//  175     temp_reg &= ~(MCG_C1_CLKS_MASK | MCG_C1_IREFS_MASK);
        ANDS     R0,R0,#0x3B
//  176     temp_reg |= (MCG_C1_CLKS(1) | MCG_C1_IREFS_MASK);  // Select internal reference (fast IREF clock @ 1MHz) as MCG clock source.
        ORRS     R0,R0,#0x44
//  177     MCG_C1 = temp_reg;
        LDR.N    R1,??DataTable3_3  ;; 0x40064000
        STRB     R0,[R1, #+0]
//  178   
//  179     while (MCG_S & MCG_S_IREFST_MASK){};  // Wait for Reference Status bit to update.
??mcg_pee_2_blpi_2:
        LDR.N    R0,??DataTable3_4  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+27
        BMI.N    ??mcg_pee_2_blpi_2
//  180     while (((MCG_S & MCG_S_CLKST_MASK) >> MCG_S_CLKST_SHIFT) != 0x1){};  // Wait for clock status bits to update
??mcg_pee_2_blpi_3:
        LDR.N    R0,??DataTable3_4  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        UBFX     R0,R0,#+2,#+2
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+1
        BNE.N    ??mcg_pee_2_blpi_3
//  181     
//  182     // Step 4: FBI -> BLPI
//  183     MCG_C1 |= MCG_C1_IREFSTEN_MASK;  // Keep internal reference clock running in STOP modes.
        LDR.N    R0,??DataTable3_3  ;; 0x40064000
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable3_3  ;; 0x40064000
        STRB     R0,[R1, #+0]
//  184     MCG_C2 |= MCG_C2_LP_MASK;  // FLL remains disabled in bypassed modes.
        LDR.N    R0,??DataTable3  ;; 0x40064001
        LDRB     R0,[R0, #+0]
        ORRS     R0,R0,#0x2
        LDR.N    R1,??DataTable3  ;; 0x40064001
        STRB     R0,[R1, #+0]
//  185     while (!(MCG_S & MCG_S_IREFST_MASK)){};  // Wait for Reference Status bit to update.
??mcg_pee_2_blpi_4:
        LDR.N    R0,??DataTable3_4  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+27
        BPL.N    ??mcg_pee_2_blpi_4
//  186     while (((MCG_S & MCG_S_CLKST_MASK) >> MCG_S_CLKST_SHIFT) != 0x1){};  // Wait for clock status bits to update.
??mcg_pee_2_blpi_5:
        LDR.N    R0,??DataTable3_4  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        UBFX     R0,R0,#+2,#+2
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+1
        BNE.N    ??mcg_pee_2_blpi_5
//  187   
//  188 } // end MCG PEE to BLPI
        BX       LR               ;; return
//  189 /********************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  190 void mcg_blpi_2_pee(void)
//  191 {
mcg_blpi_2_pee:
        PUSH     {R7,LR}
//  192     uint8 temp_reg;
//  193     // Transition from BLPI to PEE: BLPI -> FBI -> FEI -> FBE -> PBE -> PEE
//  194   
//  195     // Step 1: BLPI -> FBI
//  196     MCG_C2 &= ~MCG_C2_LP_MASK;  // FLL remains active in bypassed modes.
        LDR.N    R0,??DataTable3  ;; 0x40064001
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0xFD
        LDR.N    R1,??DataTable3  ;; 0x40064001
        STRB     R0,[R1, #+0]
//  197     while (!(MCG_S & MCG_S_IREFST_MASK)){};  // Wait for Reference Status bit to update.
??mcg_blpi_2_pee_0:
        LDR.N    R0,??DataTable3_4  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+27
        BPL.N    ??mcg_blpi_2_pee_0
//  198     while (((MCG_S & MCG_S_CLKST_MASK) >> MCG_S_CLKST_SHIFT) != 0x1){};  // Wait for clock status bits to update
??mcg_blpi_2_pee_1:
        LDR.N    R0,??DataTable3_4  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        UBFX     R0,R0,#+2,#+2
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+1
        BNE.N    ??mcg_blpi_2_pee_1
//  199     
//  200     // Step 2: FBI -> FEI
//  201     MCG_C2 &= ~MCG_C2_LP_MASK;  // FLL remains active in bypassed modes.
        LDR.N    R0,??DataTable3  ;; 0x40064001
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0xFD
        LDR.N    R1,??DataTable3  ;; 0x40064001
        STRB     R0,[R1, #+0]
//  202     temp_reg = MCG_C2;  // assign temporary variable of MCG_C2 contents
        LDR.N    R0,??DataTable3  ;; 0x40064001
        LDRB     R0,[R0, #+0]
//  203     temp_reg &= ~MCG_C2_RANGE_MASK;  // set RANGE field location to zero
        ANDS     R0,R0,#0xCF
//  204     temp_reg |= (0x2 << 0x4);  // OR in new values
        ORRS     R0,R0,#0x20
//  205     MCG_C2 = temp_reg;  // store new value in MCG_C2
        LDR.N    R1,??DataTable3  ;; 0x40064001
        STRB     R0,[R1, #+0]
//  206     MCG_C4 = 0x0E;  // Low-range DCO output (~10MHz bus).  FCTRIM=%0111.
        LDR.N    R0,??DataTable3_7  ;; 0x40064003
        MOVS     R1,#+14
        STRB     R1,[R0, #+0]
//  207     MCG_C1 = 0x04;  // Select internal clock as MCG source, FRDIV=%000, internal reference selected.
        LDR.N    R0,??DataTable3_3  ;; 0x40064000
        MOVS     R1,#+4
        STRB     R1,[R0, #+0]
//  208  
//  209     while (!(MCG_S & MCG_S_IREFST_MASK)){};   // Wait for Reference Status bit to update 
??mcg_blpi_2_pee_2:
        LDR.N    R0,??DataTable3_4  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+27
        BPL.N    ??mcg_blpi_2_pee_2
//  210     while (((MCG_S & MCG_S_CLKST_MASK) >> MCG_S_CLKST_SHIFT) != 0x0){}; // Wait for clock status bits to update
??mcg_blpi_2_pee_3:
        LDR.N    R0,??DataTable3_4  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        UBFX     R0,R0,#+2,#+2
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BNE.N    ??mcg_blpi_2_pee_3
//  211     
//  212     // Handle FEI to PEE transitions using standard clock initialization routine.
//  213     core_clk_mhz = pll_init(CORE_CLK_MHZ, REF_CLK); 
        MOVS     R1,#+3
        MOVS     R0,#+2
        BL       pll_init
        LDR.N    R1,??DataTable3_8
        STR      R0,[R1, #+0]
//  214 
//  215     /* Use the value obtained from the pll_init function to define variables
//  216     * for the core clock in kHz and also the peripheral clock. These
//  217     * variables can be used by other functions that need awareness of the
//  218     * system frequency.
//  219     */
//  220     core_clk_khz = core_clk_mhz * 1000;
        LDR.N    R0,??DataTable3_8
        LDR      R0,[R0, #+0]
        MOV      R1,#+1000
        MULS     R0,R1,R0
        LDR.N    R1,??DataTable3_9
        STR      R0,[R1, #+0]
//  221     periph_clk_khz = core_clk_khz / (((SIM_CLKDIV1 & SIM_CLKDIV1_OUTDIV2_MASK) >> 24)+ 1);        
        LDR.N    R0,??DataTable3_9
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable3_10  ;; 0x40048044
        LDR      R1,[R1, #+0]
        UBFX     R1,R1,#+24,#+4
        ADDS     R1,R1,#+1
        UDIV     R0,R0,R1
        LDR.N    R1,??DataTable3_11
        STR      R0,[R1, #+0]
//  222 } // end MCG BLPI to PEE
        POP      {R0,PC}          ;; return
//  223 /********************************************************************/
//  224 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  225 void mcg_pbe_2_pee(void)
//  226 {  
//  227   MCG_C1 &= ~MCG_C1_CLKS_MASK; // select PLL as MCG_OUT
mcg_pbe_2_pee:
        LDR.N    R0,??DataTable3_3  ;; 0x40064000
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0x3F
        LDR.N    R1,??DataTable3_3  ;; 0x40064000
        STRB     R0,[R1, #+0]
//  228   // Wait for clock status bits to update 
//  229   while (((MCG_S & MCG_S_CLKST_MASK) >> MCG_S_CLKST_SHIFT) != 0x3){}; 
??mcg_pbe_2_pee_0:
        LDR.N    R0,??DataTable3_4  ;; 0x40064006
        LDRB     R0,[R0, #+0]
        UBFX     R0,R0,#+2,#+2
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+3
        BNE.N    ??mcg_pbe_2_pee_0
//  230 
//  231   switch (CORE_CLK_MHZ) {
//  232     case PLL50:
//  233       core_clk_khz = 50000;
//  234       break;
//  235     case PLL100:
//  236       core_clk_khz = 100000;
//  237       break;
//  238     case PLL96:
//  239       core_clk_khz = 96000;
        LDR.N    R0,??DataTable3_9
        LDR.N    R1,??DataTable3_12  ;; 0x17700
        STR      R1,[R0, #+0]
//  240       break;  
//  241     case PLL48:
//  242       core_clk_khz = 48000;
//  243       break;  
//  244   }
//  245 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable3:
        DC32     0x40064001

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable3_1:
        DC32     0x40048034

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable3_2:
        DC32     0x4007c008

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable3_3:
        DC32     0x40064000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable3_4:
        DC32     0x40064006

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable3_5:
        DC32     0x40064004

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable3_6:
        DC32     0x40064005

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable3_7:
        DC32     0x40064003

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable3_8:
        DC32     core_clk_mhz

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable3_9:
        DC32     core_clk_khz

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable3_10:
        DC32     0x40048044

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable3_11:
        DC32     periph_clk_khz

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable3_12:
        DC32     0x17700

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
// 
// 636 bytes in section .text
//  76 bytes in section .textrw
// 
// 712 bytes of CODE memory
//
//Errors: none
//Warnings: 3
