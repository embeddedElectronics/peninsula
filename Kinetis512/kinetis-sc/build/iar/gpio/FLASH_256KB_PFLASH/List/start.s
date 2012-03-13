///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      04/Mar/2012  11:32:51 /
// IAR ANSI C/C++ Compiler V6.10.1.22143/W32 EVALUATION for ARM               /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  F:\My Works\K60\Kinetis512\kinetis-sc\src\cpu\start.c   /
//    Command line =  "F:\My Works\K60\Kinetis512\kinetis-sc\src\cpu\start.c" /
//                     -D IAR -D TWR_K60N512 -lCN "F:\My                      /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\FLASH_25 /
//                    6KB_PFLASH\List\" -lB "F:\My                            /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\FLASH_25 /
//                    6KB_PFLASH\List\" -o "F:\My                             /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\FLASH_25 /
//                    6KB_PFLASH\Obj\" --no_cse --no_unroll --no_inline       /
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
//                    ASH_256KB_PFLASH\List\start.s                           /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME start

        EXTERN common_startup
        EXTERN main
        EXTERN printf
        EXTERN sysinit
        EXTERN wdog_disable

        PUBLIC cpu_identify
        PUBLIC flash_identify
        PUBLIC start

// F:\My Works\K60\Kinetis512\kinetis-sc\src\cpu\start.c
//    1 /*
//    2  * File:	start.c
//    3  * Purpose:	Kinetis start up routines. 
//    4  *
//    5  * Notes:		
//    6  */
//    7 
//    8 #include "start.h"
//    9 #include "common.h"
//   10 #include "wdog.h"
//   11 #include "sysinit.h"
//   12 
//   13 /********************************************************************/
//   14 /*!
//   15  * \brief   Kinetis Start
//   16  * \return  None
//   17  *
//   18  * This function calls all of the needed starup routines and then 
//   19  * branches to the main process.
//   20  */

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   21 void start(void)
//   22 {
start:
        PUSH     {R7,LR}
//   23 	/* Disable the watchdog timer */
//   24 	wdog_disable();
        BL       wdog_disable
//   25 
//   26 	/* Copy any vector or data sections that need to be in RAM */
//   27 	common_startup();
        BL       common_startup
//   28 
//   29 	/* Perform processor initialization */
//   30 	sysinit();
        BL       sysinit
//   31         
//   32     printf("\n\n");
        ADR.N    R0,??DataTable53  ;; 0x0A, 0x0A, 0x00, 0x00
        BL       printf
//   33 	
//   34 	/* Determine the last cause(s) of reset */
//   35 	if (MC_SRSH & MC_SRSH_SW_MASK)
        LDR.W    R0,??DataTable55  ;; 0x4007e000
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+29
        BPL.N    ??start_0
//   36 		printf("Software Reset\n");
        ADR.W    R0,`?<Constant "Software Reset\\n">`
        BL       printf
//   37 	if (MC_SRSH & MC_SRSH_LOCKUP_MASK)
??start_0:
        LDR.W    R0,??DataTable55  ;; 0x4007e000
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+30
        BPL.N    ??start_1
//   38 		printf("Core Lockup Event Reset\n");
        ADR.W    R0,`?<Constant "Core Lockup Event Reset\\n">`
        BL       printf
//   39 	if (MC_SRSH & MC_SRSH_JTAG_MASK)
??start_1:
        LDR.W    R0,??DataTable55  ;; 0x4007e000
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+31
        BPL.N    ??start_2
//   40 		printf("JTAG Reset\n");
        ADR.W    R0,`?<Constant "JTAG Reset\\n">`
        BL       printf
//   41 	
//   42 	if (MC_SRSL & MC_SRSL_POR_MASK)
??start_2:
        LDR.W    R0,??DataTable55_1  ;; 0x4007e001
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??start_3
//   43 		printf("Power-on Reset\n");
        ADR.W    R0,`?<Constant "Power-on Reset\\n">`
        BL       printf
//   44 	if (MC_SRSL & MC_SRSL_PIN_MASK)
??start_3:
        LDR.W    R0,??DataTable55_1  ;; 0x4007e001
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+25
        BPL.N    ??start_4
//   45 		printf("External Pin Reset\n");
        ADR.W    R0,`?<Constant "External Pin Reset\\n">`
        BL       printf
//   46 	if (MC_SRSL & MC_SRSL_COP_MASK)
??start_4:
        LDR.W    R0,??DataTable55_1  ;; 0x4007e001
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+26
        BPL.N    ??start_5
//   47 		printf("Watchdog(COP) Reset\n");
        ADR.W    R0,`?<Constant "Watchdog(COP) Reset\\n">`
        BL       printf
//   48 	if (MC_SRSL & MC_SRSL_LOC_MASK)
??start_5:
        LDR.W    R0,??DataTable55_1  ;; 0x4007e001
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+29
        BPL.N    ??start_6
//   49 		printf("Loss of Clock Reset\n");
        ADR.W    R0,`?<Constant "Loss of Clock Reset\\n">`
        BL       printf
//   50 	if (MC_SRSL & MC_SRSL_LVD_MASK)
??start_6:
        LDR.W    R0,??DataTable55_1  ;; 0x4007e001
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+30
        BPL.N    ??start_7
//   51 		printf("Low-voltage Detect Reset\n");
        ADR.W    R0,`?<Constant "Low-voltage Detect Re...">`
        BL       printf
//   52 	if (MC_SRSL & MC_SRSL_WAKEUP_MASK)
??start_7:
        LDR.W    R0,??DataTable55_1  ;; 0x4007e001
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+31
        BPL.N    ??start_8
//   53 		printf("LLWU Reset\n");	
        ADR.W    R0,`?<Constant "LLWU Reset\\n">`
        BL       printf
//   54 	
//   55 
//   56 	/* Determine specific Kinetis device and revision */
//   57 	cpu_identify();
??start_8:
        BL       cpu_identify
//   58 	
//   59 	/* Jump to main process */
//   60 	main();
        BL       main
//   61 
//   62 	/* No actions to perform after this so wait forever */
//   63 	while(1);
??start_9:
        B.N      ??start_9
//   64 }

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable53:
        DC8      0x0A, 0x0A, 0x00, 0x00
//   65 /********************************************************************/
//   66 /*!
//   67  * \brief   Kinetis Identify
//   68  * \return  None
//   69  *
//   70  * This is primarly a reporting function that displays information
//   71  * about the specific CPU to the default terminal including:
//   72  * - Kinetis family
//   73  * - package
//   74  * - die revision
//   75  * - P-flash size
//   76  * - Ram size
//   77  */

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   78 void cpu_identify (void)
//   79 {
cpu_identify:
        PUSH     {R7,LR}
//   80     /* Determine the Kinetis family */
//   81     switch((SIM_SDID & SIM_SDID_FAMID(0x7))>>SIM_SDID_FAMID_SHIFT) 
        LDR.N    R0,??DataTable55_2  ;; 0x40048024
        LDR      R0,[R0, #+0]
        LSRS     R0,R0,#+4
        ANDS     R0,R0,#0x7
        CMP      R0,#+0
        BEQ.N    ??cpu_identify_0
        CMP      R0,#+2
        BEQ.N    ??cpu_identify_1
        BCC.N    ??cpu_identify_2
        CMP      R0,#+4
        BEQ.N    ??cpu_identify_3
        BCC.N    ??cpu_identify_4
        CMP      R0,#+6
        BEQ.N    ??cpu_identify_5
        BCC.N    ??cpu_identify_6
        CMP      R0,#+7
        BEQ.N    ??cpu_identify_7
        B.N      ??cpu_identify_8
//   82     {  
//   83     	case 0x0:
//   84     		printf("\nK10-");
??cpu_identify_0:
        ADR.W    R0,`?<Constant "\\nK10-">`
        BL       printf
//   85     		break;
        B.N      ??cpu_identify_9
//   86     	case 0x1:
//   87     		printf("\nK20-");
??cpu_identify_2:
        ADR.W    R0,`?<Constant "\\nK20-">`
        BL       printf
//   88     		break;
        B.N      ??cpu_identify_9
//   89     	case 0x2:
//   90     		printf("\nK30-");
??cpu_identify_1:
        ADR.W    R0,`?<Constant "\\nK30-">`
        BL       printf
//   91     		break;
        B.N      ??cpu_identify_9
//   92     	case 0x3:
//   93     		printf("\nK40-");
??cpu_identify_4:
        ADR.W    R0,`?<Constant "\\nK40-">`
        BL       printf
//   94     		break;
        B.N      ??cpu_identify_9
//   95     	case 0x4:
//   96     		printf("\nK60-");
??cpu_identify_3:
        ADR.W    R0,`?<Constant "\\nK60-">`
        BL       printf
//   97     		break;
        B.N      ??cpu_identify_9
//   98     	case 0x5:
//   99     		printf("\nK70-");
??cpu_identify_6:
        ADR.W    R0,`?<Constant "\\nK70-">`
        BL       printf
//  100     		break;
        B.N      ??cpu_identify_9
//  101     	case 0x6:
//  102     		printf("\nK50-");
??cpu_identify_5:
        ADR.W    R0,`?<Constant "\\nK50-">`
        BL       printf
//  103     		break;
        B.N      ??cpu_identify_9
//  104     	case 0x7:
//  105     		printf("\nK53-");
??cpu_identify_7:
        ADR.W    R0,`?<Constant "\\nK53-">`
        BL       printf
//  106     		break;
        B.N      ??cpu_identify_9
//  107 	default:
//  108 		printf("\nUnrecognized Kinetis family device.\n");  
??cpu_identify_8:
        ADR.W    R0,`?<Constant "\\nUnrecognized Kinetis...">`
        BL       printf
//  109 		break;  	
//  110     }
//  111 
//  112     /* Determine the package size */
//  113     switch((SIM_SDID & SIM_SDID_PINID(0xF))>>SIM_SDID_PINID_SHIFT) 
??cpu_identify_9:
        LDR.N    R0,??DataTable55_2  ;; 0x40048024
        LDR      R0,[R0, #+0]
        ANDS     R0,R0,#0xF
        CMP      R0,#+2
        BEQ.N    ??cpu_identify_10
        CMP      R0,#+4
        BEQ.N    ??cpu_identify_11
        CMP      R0,#+5
        BEQ.N    ??cpu_identify_12
        CMP      R0,#+6
        BEQ.N    ??cpu_identify_13
        CMP      R0,#+7
        BEQ.N    ??cpu_identify_14
        CMP      R0,#+8
        BEQ.N    ??cpu_identify_15
        CMP      R0,#+9
        BEQ.N    ??cpu_identify_16
        CMP      R0,#+10
        BEQ.N    ??cpu_identify_17
        CMP      R0,#+12
        BEQ.N    ??cpu_identify_18
        CMP      R0,#+14
        BEQ.N    ??cpu_identify_19
        B.N      ??cpu_identify_20
//  114     {  
//  115     	case 0x2:
//  116     		printf("32pin       ");
??cpu_identify_10:
        ADR.W    R0,`?<Constant "32pin       ">`
        BL       printf
//  117     		break;
        B.N      ??cpu_identify_21
//  118     	case 0x4:
//  119     		printf("48pin       ");
??cpu_identify_11:
        ADR.W    R0,`?<Constant "48pin       ">`
        BL       printf
//  120     		break;
        B.N      ??cpu_identify_21
//  121     	case 0x5:
//  122     		printf("64pin       ");
??cpu_identify_12:
        ADR.W    R0,`?<Constant "64pin       ">`
        BL       printf
//  123     		break;
        B.N      ??cpu_identify_21
//  124     	case 0x6:
//  125     		printf("80pin       ");
??cpu_identify_13:
        ADR.W    R0,`?<Constant "80pin       ">`
        BL       printf
//  126     		break;
        B.N      ??cpu_identify_21
//  127     	case 0x7:
//  128     		printf("81pin       ");
??cpu_identify_14:
        ADR.W    R0,`?<Constant "81pin       ">`
        BL       printf
//  129     		break;
        B.N      ??cpu_identify_21
//  130     	case 0x8:
//  131     		printf("100pin      ");
??cpu_identify_15:
        ADR.W    R0,`?<Constant "100pin      ">`
        BL       printf
//  132     		break;
        B.N      ??cpu_identify_21
//  133     	case 0x9:
//  134     		printf("104pin      ");
??cpu_identify_16:
        ADR.W    R0,`?<Constant "104pin      ">`
        BL       printf
//  135     		break;
        B.N      ??cpu_identify_21
//  136     	case 0xA:
//  137     		printf("144pin      ");
??cpu_identify_17:
        ADR.W    R0,`?<Constant "144pin      ">`
        BL       printf
//  138     		break;
        B.N      ??cpu_identify_21
//  139     	case 0xC:
//  140     		printf("196pin      ");
??cpu_identify_18:
        ADR.W    R0,`?<Constant "196pin      ">`
        BL       printf
//  141     		break;
        B.N      ??cpu_identify_21
//  142     	case 0xE:
//  143     		printf("256pin      ");
??cpu_identify_19:
        ADR.W    R0,`?<Constant "256pin      ">`
        BL       printf
//  144     		break;
        B.N      ??cpu_identify_21
//  145 	default:
//  146 		printf("\nUnrecognized Kinetis package code.      ");  
??cpu_identify_20:
        ADR.W    R0,`?<Constant "\\nUnrecognized Kinetis...">_1`
        BL       printf
//  147 		break;  	
//  148     }                
//  149 
//  150     /* Determine the revision ID */
//  151     printf("Silicon rev %d     \n", (SIM_SDID & SIM_SDID_REVID(0xF))>>SIM_SDID_REVID_SHIFT);
??cpu_identify_21:
        LDR.N    R0,??DataTable55_2  ;; 0x40048024
        LDR      R0,[R0, #+0]
        UBFX     R1,R0,#+12,#+4
        ADR.W    R0,`?<Constant "Silicon rev %d     \\n">`
        BL       printf
//  152     
//  153     
//  154     /* Determine the flash revision */
//  155     flash_identify();    
        BL       flash_identify
//  156     
//  157     /* Determine the P-flash size */
//  158     switch((SIM_FCFG1 & SIM_FCFG1_FSIZE(0xFF))>>SIM_FCFG1_FSIZE_SHIFT)
        LDR.N    R0,??DataTable55_3  ;; 0x4004804c
        LDR      R0,[R0, #+0]
        LSRS     R0,R0,#+24
        CMP      R0,#+0
        BEQ.N    ??cpu_identify_22
        CMP      R0,#+1
        BEQ.N    ??cpu_identify_23
        CMP      R0,#+2
        BEQ.N    ??cpu_identify_24
        CMP      R0,#+3
        BEQ.N    ??cpu_identify_25
        CMP      R0,#+4
        BEQ.N    ??cpu_identify_26
        CMP      R0,#+5
        BEQ.N    ??cpu_identify_27
        CMP      R0,#+6
        BEQ.N    ??cpu_identify_28
        CMP      R0,#+7
        BEQ.N    ??cpu_identify_29
        CMP      R0,#+8
        BEQ.N    ??cpu_identify_30
        CMP      R0,#+9
        BEQ.N    ??cpu_identify_31
        CMP      R0,#+10
        BEQ.N    ??cpu_identify_32
        CMP      R0,#+11
        BEQ.N    ??cpu_identify_33
        CMP      R0,#+12
        BEQ.N    ??cpu_identify_34
        CMP      R0,#+255
        BEQ.N    ??cpu_identify_35
        B.N      ??cpu_identify_36
//  159     {
//  160     	case 0x0:
//  161     		printf("12 kBytes of P-flash	");
??cpu_identify_22:
        ADR.W    R0,`?<Constant "12 kBytes of P-flash\\t">`
        BL       printf
//  162     		break;
        B.N      ??cpu_identify_37
//  163     	case 0x1:
//  164     		printf("16 kBytes of P-flash	");
??cpu_identify_23:
        ADR.W    R0,`?<Constant "16 kBytes of P-flash\\t">`
        BL       printf
//  165     		break;
        B.N      ??cpu_identify_37
//  166     	case 0x2:
//  167     		printf("32 kBytes of P-flash	");
??cpu_identify_24:
        ADR.W    R0,`?<Constant "32 kBytes of P-flash\\t">`
        BL       printf
//  168     		break;
        B.N      ??cpu_identify_37
//  169     	case 0x3:
//  170     		printf("48 kBytes of P-flash	");
??cpu_identify_25:
        ADR.W    R0,`?<Constant "48 kBytes of P-flash\\t">`
        BL       printf
//  171     		break;
        B.N      ??cpu_identify_37
//  172     	case 0x4:
//  173     		printf("64 kBytes of P-flash	");
??cpu_identify_26:
        ADR.W    R0,`?<Constant "64 kBytes of P-flash\\t">`
        BL       printf
//  174     		break;
        B.N      ??cpu_identify_37
//  175     	case 0x5:
//  176     		printf("96 kBytes of P-flash	");
??cpu_identify_27:
        ADR.W    R0,`?<Constant "96 kBytes of P-flash\\t">`
        BL       printf
//  177     		break;
        B.N      ??cpu_identify_37
//  178     	case 0x6:
//  179     		printf("128 kBytes of P-flash	");
??cpu_identify_28:
        ADR.W    R0,`?<Constant "128 kBytes of P-flash\\t">`
        BL       printf
//  180     		break;
        B.N      ??cpu_identify_37
//  181     	case 0x7:
//  182     		printf("192 kBytes of P-flash	");
??cpu_identify_29:
        ADR.W    R0,`?<Constant "192 kBytes of P-flash\\t">`
        BL       printf
//  183     		break;
        B.N      ??cpu_identify_37
//  184     	case 0x8:
//  185     		printf("256 kBytes of P-flash	");
??cpu_identify_30:
        ADR.W    R0,`?<Constant "256 kBytes of P-flash\\t">`
        BL       printf
//  186     		break;
        B.N      ??cpu_identify_37
//  187     	case 0x9:
//  188     		printf("320 kBytes of P-flash	");
??cpu_identify_31:
        ADR.W    R0,`?<Constant "320 kBytes of P-flash\\t">`
        BL       printf
//  189     		break;
        B.N      ??cpu_identify_37
//  190     	case 0xA:
//  191     		printf("384 kBytes of P-flash	");
??cpu_identify_32:
        ADR.W    R0,`?<Constant "384 kBytes of P-flash\\t">`
        BL       printf
//  192     		break;
        B.N      ??cpu_identify_37
//  193     	case 0xB:
//  194     		printf("448 kBytes of P-flash	");
??cpu_identify_33:
        ADR.W    R0,`?<Constant "448 kBytes of P-flash\\t">`
        BL       printf
//  195     		break;
        B.N      ??cpu_identify_37
//  196     	case 0xC:
//  197     		printf("512 kBytes of P-flash	");
??cpu_identify_34:
        ADR.W    R0,`?<Constant "512 kBytes of P-flash\\t">`
        BL       printf
//  198     		break;
        B.N      ??cpu_identify_37
//  199     	case 0xFF:
//  200     		printf("Full size P-flash	");
??cpu_identify_35:
        ADR.W    R0,`?<Constant "Full size P-flash\\t">`
        BL       printf
//  201     		break;
        B.N      ??cpu_identify_37
//  202 		default:
//  203 			printf("ERR!! Undefined P-flash size\n");  
??cpu_identify_36:
        ADR.W    R0,`?<Constant "ERR!! Undefined P-fla...">`
        BL       printf
//  204 			break;  		
//  205     }
//  206 
//  207     /* Determine the RAM size */
//  208     switch((SIM_SOPT1 & SIM_SOPT1_RAMSIZE(0xF))>>SIM_SOPT1_RAMSIZE_SHIFT)
??cpu_identify_37:
        LDR.N    R0,??DataTable55_4  ;; 0x40047000
        LDR      R0,[R0, #+0]
        LSRS     R0,R0,#+12
        ANDS     R0,R0,#0xF
        CMP      R0,#+5
        BEQ.N    ??cpu_identify_38
        CMP      R0,#+7
        BEQ.N    ??cpu_identify_39
        CMP      R0,#+8
        BEQ.N    ??cpu_identify_40
        CMP      R0,#+9
        BEQ.N    ??cpu_identify_41
        B.N      ??cpu_identify_42
//  209     {
//  210     	case 0x5:
//  211     		printf(" 32 kBytes of RAM\n\n");
??cpu_identify_38:
        ADR.W    R0,`?<Constant " 32 kBytes of RAM\\n\\n">`
        BL       printf
//  212     		break;
        B.N      ??cpu_identify_43
//  213     	case 0x7:
//  214     		printf(" 64 kBytes of RAM\n\n");
??cpu_identify_39:
        ADR.W    R0,`?<Constant " 64 kBytes of RAM\\n\\n">`
        BL       printf
//  215     		break;
        B.N      ??cpu_identify_43
//  216     	case 0x8:
//  217     		printf(" 96 kBytes of RAM\n\n");
??cpu_identify_40:
        ADR.W    R0,`?<Constant " 96 kBytes of RAM\\n\\n">`
        BL       printf
//  218     		break;
        B.N      ??cpu_identify_43
//  219     	case 0x9:
//  220     		printf(" 128 kBytes of RAM\n\n");
??cpu_identify_41:
        ADR.W    R0,`?<Constant " 128 kBytes of RAM\\n\\n">`
        BL       printf
//  221     		break;
        B.N      ??cpu_identify_43
//  222 		default:
//  223 			printf(" ERR!! Undefined RAM size\n\n");  
??cpu_identify_42:
        ADR.W    R0,`?<Constant " ERR!! Undefined RAM ...">`
        BL       printf
//  224 			break;  		
//  225     }
//  226 }
??cpu_identify_43:
        POP      {R0,PC}          ;; return
//  227 /********************************************************************/
//  228 /*!
//  229  * \brief   flash Identify
//  230  * \return  None
//  231  *
//  232  * This is primarly a reporting function that displays information
//  233  * about the specific flash parameters and flash version ID for 
//  234  * the current device. These parameters are obtained using a special
//  235  * flash command call "read resource." The first four bytes returned
//  236  * are the flash parameter revision, and the second four bytes are
//  237  * the flash version ID.
//  238  */

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  239 void flash_identify (void)
//  240 {
flash_identify:
        PUSH     {R7,LR}
//  241     /* Get the flash parameter version */
//  242 
//  243     /* Write the flash FCCOB registers with the values for a read resource command */
//  244     FTFL_FCCOB0 = 0x03;
        LDR.N    R0,??DataTable55_5  ;; 0x40020007
        MOVS     R1,#+3
        STRB     R1,[R0, #+0]
//  245     FTFL_FCCOB1 = 0x00;
        LDR.N    R0,??DataTable55_6  ;; 0x40020006
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//  246     FTFL_FCCOB2 = 0x00;
        LDR.N    R0,??DataTable55_7  ;; 0x40020005
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//  247     FTFL_FCCOB3 = 0x00;
        LDR.N    R0,??DataTable55_8  ;; 0x40020004
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//  248     FTFL_FCCOB8 = 0x01;
        LDR.N    R0,??DataTable55_9  ;; 0x4002000f
        MOVS     R1,#+1
        STRB     R1,[R0, #+0]
//  249 
//  250     /* All required FCCOBx registers are written, so launch the command */
//  251     FTFL_FSTAT = FTFL_FSTAT_CCIF_MASK;
        LDR.N    R0,??DataTable55_10  ;; 0x40020000
        MOVS     R1,#+128
        STRB     R1,[R0, #+0]
//  252 
//  253     /* Wait for the command to complete */
//  254     while(!(FTFL_FSTAT & FTFL_FSTAT_CCIF_MASK));
??flash_identify_0:
        LDR.N    R0,??DataTable55_10  ;; 0x40020000
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??flash_identify_0
//  255     
//  256     printf("Flash parameter version %d.%d.%d.%d\n",FTFL_FCCOB4,FTFL_FCCOB5,FTFL_FCCOB6,FTFL_FCCOB7);
        LDR.N    R0,??DataTable55_11  ;; 0x40020008
        LDRB     R0,[R0, #+0]
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        STR      R0,[SP, #+0]
        LDR.N    R0,??DataTable55_12  ;; 0x40020009
        LDRB     R3,[R0, #+0]
        UXTB     R3,R3            ;; ZeroExt  R3,R3,#+24,#+24
        LDR.N    R0,??DataTable55_13  ;; 0x4002000a
        LDRB     R2,[R0, #+0]
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        LDR.N    R0,??DataTable55_14  ;; 0x4002000b
        LDRB     R1,[R0, #+0]
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        ADR.W    R0,`?<Constant "Flash parameter versi...">`
        BL       printf
//  257 
//  258     /* Get the flash version ID */   
//  259 
//  260     /* Write the flash FCCOB registers with the values for a read resource command */
//  261     FTFL_FCCOB0 = 0x03;
        LDR.N    R0,??DataTable55_5  ;; 0x40020007
        MOVS     R1,#+3
        STRB     R1,[R0, #+0]
//  262     FTFL_FCCOB1 = 0x00;
        LDR.N    R0,??DataTable55_6  ;; 0x40020006
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//  263     FTFL_FCCOB2 = 0x00;
        LDR.N    R0,??DataTable55_7  ;; 0x40020005
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//  264     FTFL_FCCOB3 = 0x04;
        LDR.N    R0,??DataTable55_8  ;; 0x40020004
        MOVS     R1,#+4
        STRB     R1,[R0, #+0]
//  265     FTFL_FCCOB8 = 0x01;
        LDR.N    R0,??DataTable55_9  ;; 0x4002000f
        MOVS     R1,#+1
        STRB     R1,[R0, #+0]
//  266 
//  267     /* All required FCCOBx registers are written, so launch the command */
//  268     FTFL_FSTAT = FTFL_FSTAT_CCIF_MASK;
        LDR.N    R0,??DataTable55_10  ;; 0x40020000
        MOVS     R1,#+128
        STRB     R1,[R0, #+0]
//  269 
//  270     /* Wait for the command to complete */
//  271     while(!(FTFL_FSTAT & FTFL_FSTAT_CCIF_MASK));
??flash_identify_1:
        LDR.N    R0,??DataTable55_10  ;; 0x40020000
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??flash_identify_1
//  272 
//  273     printf("Flash version ID %d.%d.%d.%d\n",FTFL_FCCOB4,FTFL_FCCOB5,FTFL_FCCOB6,FTFL_FCCOB7);  
        LDR.N    R0,??DataTable55_11  ;; 0x40020008
        LDRB     R0,[R0, #+0]
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        STR      R0,[SP, #+0]
        LDR.N    R0,??DataTable55_12  ;; 0x40020009
        LDRB     R3,[R0, #+0]
        UXTB     R3,R3            ;; ZeroExt  R3,R3,#+24,#+24
        LDR.N    R0,??DataTable55_13  ;; 0x4002000a
        LDRB     R2,[R0, #+0]
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        LDR.N    R0,??DataTable55_14  ;; 0x4002000b
        LDRB     R1,[R0, #+0]
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        ADR.W    R0,`?<Constant "Flash version ID %d.%...">`
        BL       printf
//  274 }
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable55:
        DC32     0x4007e000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable55_1:
        DC32     0x4007e001

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable55_2:
        DC32     0x40048024

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable55_3:
        DC32     0x4004804c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable55_4:
        DC32     0x40047000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable55_5:
        DC32     0x40020007

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable55_6:
        DC32     0x40020006

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable55_7:
        DC32     0x40020005

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable55_8:
        DC32     0x40020004

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable55_9:
        DC32     0x4002000f

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable55_10:
        DC32     0x40020000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable55_11:
        DC32     0x40020008

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable55_12:
        DC32     0x40020009

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable55_13:
        DC32     0x4002000a

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable55_14:
        DC32     0x4002000b

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "\\n\\n">`:
        ; Initializer data, 4 bytes
        DC8 10, 10, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "Software Reset\\n">`:
        ; Initializer data, 16 bytes
        DC8 83, 111, 102, 116, 119, 97, 114, 101, 32, 82
        DC8 101, 115, 101, 116, 10, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "Core Lockup Event Reset\\n">`:
        ; Initializer data, 28 bytes
        DC8 67, 111, 114, 101, 32, 76, 111, 99, 107, 117
        DC8 112, 32, 69, 118, 101, 110, 116, 32, 82, 101
        DC8 115, 101, 116, 10, 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "JTAG Reset\\n">`:
        ; Initializer data, 12 bytes
        DC8 74, 84, 65, 71, 32, 82, 101, 115, 101, 116
        DC8 10, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "Power-on Reset\\n">`:
        ; Initializer data, 16 bytes
        DC8 80, 111, 119, 101, 114, 45, 111, 110, 32, 82
        DC8 101, 115, 101, 116, 10, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "External Pin Reset\\n">`:
        ; Initializer data, 20 bytes
        DC8 69, 120, 116, 101, 114, 110, 97, 108, 32, 80
        DC8 105, 110, 32, 82, 101, 115, 101, 116, 10, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "Watchdog(COP) Reset\\n">`:
        ; Initializer data, 24 bytes
        DC8 87, 97, 116, 99, 104, 100, 111, 103, 40, 67
        DC8 79, 80, 41, 32, 82, 101, 115, 101, 116, 10
        DC8 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "Loss of Clock Reset\\n">`:
        ; Initializer data, 24 bytes
        DC8 76, 111, 115, 115, 32, 111, 102, 32, 67, 108
        DC8 111, 99, 107, 32, 82, 101, 115, 101, 116, 10
        DC8 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "Low-voltage Detect Re...">`:
        ; Initializer data, 28 bytes
        DC8 76, 111, 119, 45, 118, 111, 108, 116, 97, 103
        DC8 101, 32, 68, 101, 116, 101, 99, 116, 32, 82
        DC8 101, 115, 101, 116, 10, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "LLWU Reset\\n">`:
        ; Initializer data, 12 bytes
        DC8 76, 76, 87, 85, 32, 82, 101, 115, 101, 116
        DC8 10, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "\\nK10-">`:
        ; Initializer data, 8 bytes
        DC8 10, 75, 49, 48, 45, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "\\nK20-">`:
        ; Initializer data, 8 bytes
        DC8 10, 75, 50, 48, 45, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "\\nK30-">`:
        ; Initializer data, 8 bytes
        DC8 10, 75, 51, 48, 45, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "\\nK40-">`:
        ; Initializer data, 8 bytes
        DC8 10, 75, 52, 48, 45, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "\\nK60-">`:
        ; Initializer data, 8 bytes
        DC8 10, 75, 54, 48, 45, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "\\nK70-">`:
        ; Initializer data, 8 bytes
        DC8 10, 75, 55, 48, 45, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "\\nK50-">`:
        ; Initializer data, 8 bytes
        DC8 10, 75, 53, 48, 45, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "\\nK53-">`:
        ; Initializer data, 8 bytes
        DC8 10, 75, 53, 51, 45, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "\\nUnrecognized Kinetis...">`:
        ; Initializer data, 40 bytes
        DC8 10, 85, 110, 114, 101, 99, 111, 103, 110, 105
        DC8 122, 101, 100, 32, 75, 105, 110, 101, 116, 105
        DC8 115, 32, 102, 97, 109, 105, 108, 121, 32, 100
        DC8 101, 118, 105, 99, 101, 46, 10, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "32pin       ">`:
        ; Initializer data, 16 bytes
        DC8 51, 50, 112, 105, 110, 32, 32, 32, 32, 32
        DC8 32, 32, 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "48pin       ">`:
        ; Initializer data, 16 bytes
        DC8 52, 56, 112, 105, 110, 32, 32, 32, 32, 32
        DC8 32, 32, 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "64pin       ">`:
        ; Initializer data, 16 bytes
        DC8 54, 52, 112, 105, 110, 32, 32, 32, 32, 32
        DC8 32, 32, 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "80pin       ">`:
        ; Initializer data, 16 bytes
        DC8 56, 48, 112, 105, 110, 32, 32, 32, 32, 32
        DC8 32, 32, 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "81pin       ">`:
        ; Initializer data, 16 bytes
        DC8 56, 49, 112, 105, 110, 32, 32, 32, 32, 32
        DC8 32, 32, 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "100pin      ">`:
        ; Initializer data, 16 bytes
        DC8 49, 48, 48, 112, 105, 110, 32, 32, 32, 32
        DC8 32, 32, 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "104pin      ">`:
        ; Initializer data, 16 bytes
        DC8 49, 48, 52, 112, 105, 110, 32, 32, 32, 32
        DC8 32, 32, 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "144pin      ">`:
        ; Initializer data, 16 bytes
        DC8 49, 52, 52, 112, 105, 110, 32, 32, 32, 32
        DC8 32, 32, 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "196pin      ">`:
        ; Initializer data, 16 bytes
        DC8 49, 57, 54, 112, 105, 110, 32, 32, 32, 32
        DC8 32, 32, 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "256pin      ">`:
        ; Initializer data, 16 bytes
        DC8 50, 53, 54, 112, 105, 110, 32, 32, 32, 32
        DC8 32, 32, 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "\\nUnrecognized Kinetis...">_1`:
        ; Initializer data, 44 bytes
        DC8 10, 85, 110, 114, 101, 99, 111, 103, 110, 105
        DC8 122, 101, 100, 32, 75, 105, 110, 101, 116, 105
        DC8 115, 32, 112, 97, 99, 107, 97, 103, 101, 32
        DC8 99, 111, 100, 101, 46, 32, 32, 32, 32, 32
        DC8 32, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "Silicon rev %d     \\n">`:
        ; Initializer data, 24 bytes
        DC8 83, 105, 108, 105, 99, 111, 110, 32, 114, 101
        DC8 118, 32, 37, 100, 32, 32, 32, 32, 32, 10
        DC8 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "12 kBytes of P-flash\\t">`:
        ; Initializer data, 24 bytes
        DC8 49, 50, 32, 107, 66, 121, 116, 101, 115, 32
        DC8 111, 102, 32, 80, 45, 102, 108, 97, 115, 104
        DC8 9, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "16 kBytes of P-flash\\t">`:
        ; Initializer data, 24 bytes
        DC8 49, 54, 32, 107, 66, 121, 116, 101, 115, 32
        DC8 111, 102, 32, 80, 45, 102, 108, 97, 115, 104
        DC8 9, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "32 kBytes of P-flash\\t">`:
        ; Initializer data, 24 bytes
        DC8 51, 50, 32, 107, 66, 121, 116, 101, 115, 32
        DC8 111, 102, 32, 80, 45, 102, 108, 97, 115, 104
        DC8 9, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "48 kBytes of P-flash\\t">`:
        ; Initializer data, 24 bytes
        DC8 52, 56, 32, 107, 66, 121, 116, 101, 115, 32
        DC8 111, 102, 32, 80, 45, 102, 108, 97, 115, 104
        DC8 9, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "64 kBytes of P-flash\\t">`:
        ; Initializer data, 24 bytes
        DC8 54, 52, 32, 107, 66, 121, 116, 101, 115, 32
        DC8 111, 102, 32, 80, 45, 102, 108, 97, 115, 104
        DC8 9, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "96 kBytes of P-flash\\t">`:
        ; Initializer data, 24 bytes
        DC8 57, 54, 32, 107, 66, 121, 116, 101, 115, 32
        DC8 111, 102, 32, 80, 45, 102, 108, 97, 115, 104
        DC8 9, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "128 kBytes of P-flash\\t">`:
        ; Initializer data, 24 bytes
        DC8 49, 50, 56, 32, 107, 66, 121, 116, 101, 115
        DC8 32, 111, 102, 32, 80, 45, 102, 108, 97, 115
        DC8 104, 9, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "192 kBytes of P-flash\\t">`:
        ; Initializer data, 24 bytes
        DC8 49, 57, 50, 32, 107, 66, 121, 116, 101, 115
        DC8 32, 111, 102, 32, 80, 45, 102, 108, 97, 115
        DC8 104, 9, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "256 kBytes of P-flash\\t">`:
        ; Initializer data, 24 bytes
        DC8 50, 53, 54, 32, 107, 66, 121, 116, 101, 115
        DC8 32, 111, 102, 32, 80, 45, 102, 108, 97, 115
        DC8 104, 9, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "320 kBytes of P-flash\\t">`:
        ; Initializer data, 24 bytes
        DC8 51, 50, 48, 32, 107, 66, 121, 116, 101, 115
        DC8 32, 111, 102, 32, 80, 45, 102, 108, 97, 115
        DC8 104, 9, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "384 kBytes of P-flash\\t">`:
        ; Initializer data, 24 bytes
        DC8 51, 56, 52, 32, 107, 66, 121, 116, 101, 115
        DC8 32, 111, 102, 32, 80, 45, 102, 108, 97, 115
        DC8 104, 9, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "448 kBytes of P-flash\\t">`:
        ; Initializer data, 24 bytes
        DC8 52, 52, 56, 32, 107, 66, 121, 116, 101, 115
        DC8 32, 111, 102, 32, 80, 45, 102, 108, 97, 115
        DC8 104, 9, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "512 kBytes of P-flash\\t">`:
        ; Initializer data, 24 bytes
        DC8 53, 49, 50, 32, 107, 66, 121, 116, 101, 115
        DC8 32, 111, 102, 32, 80, 45, 102, 108, 97, 115
        DC8 104, 9, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "Full size P-flash\\t">`:
        ; Initializer data, 20 bytes
        DC8 70, 117, 108, 108, 32, 115, 105, 122, 101, 32
        DC8 80, 45, 102, 108, 97, 115, 104, 9, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "ERR!! Undefined P-fla...">`:
        ; Initializer data, 32 bytes
        DC8 69, 82, 82, 33, 33, 32, 85, 110, 100, 101
        DC8 102, 105, 110, 101, 100, 32, 80, 45, 102, 108
        DC8 97, 115, 104, 32, 115, 105, 122, 101, 10, 0
        DC8 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant " 32 kBytes of RAM\\n\\n">`:
        ; Initializer data, 20 bytes
        DC8 32, 51, 50, 32, 107, 66, 121, 116, 101, 115
        DC8 32, 111, 102, 32, 82, 65, 77, 10, 10, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant " 64 kBytes of RAM\\n\\n">`:
        ; Initializer data, 20 bytes
        DC8 32, 54, 52, 32, 107, 66, 121, 116, 101, 115
        DC8 32, 111, 102, 32, 82, 65, 77, 10, 10, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant " 96 kBytes of RAM\\n\\n">`:
        ; Initializer data, 20 bytes
        DC8 32, 57, 54, 32, 107, 66, 121, 116, 101, 115
        DC8 32, 111, 102, 32, 82, 65, 77, 10, 10, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant " 128 kBytes of RAM\\n\\n">`:
        ; Initializer data, 24 bytes
        DC8 32, 49, 50, 56, 32, 107, 66, 121, 116, 101
        DC8 115, 32, 111, 102, 32, 82, 65, 77, 10, 10
        DC8 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant " ERR!! Undefined RAM ...">`:
        ; Initializer data, 28 bytes
        DC8 32, 69, 82, 82, 33, 33, 32, 85, 110, 100
        DC8 101, 102, 105, 110, 101, 100, 32, 82, 65, 77
        DC8 32, 115, 105, 122, 101, 10, 10, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "Flash parameter versi...">`:
        ; Initializer data, 40 bytes
        DC8 70, 108, 97, 115, 104, 32, 112, 97, 114, 97
        DC8 109, 101, 116, 101, 114, 32, 118, 101, 114, 115
        DC8 105, 111, 110, 32, 37, 100, 46, 37, 100, 46
        DC8 37, 100, 46, 37, 100, 10, 0, 0, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "Flash version ID %d.%...">`:
        ; Initializer data, 32 bytes
        DC8 70, 108, 97, 115, 104, 32, 118, 101, 114, 115
        DC8 105, 111, 110, 32, 73, 68, 32, 37, 100, 46
        DC8 37, 100, 46, 37, 100, 46, 37, 100, 10, 0
        DC8 0, 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
//  275 /********************************************************************/
//  276 
// 
// 2 076 bytes in section .text
// 
// 2 076 bytes of CODE memory
//
//Errors: none
//Warnings: 12
