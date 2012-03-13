///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      04/Mar/2012  17:39:53 /
// IAR ANSI C/C++ Compiler V6.10.1.22143/W32 EVALUATION for ARM               /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\gpio /
//                    \hw_sdhc.c                                              /
//    Command line =  "F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\gpi /
//                    o\hw_sdhc.c" -D IAR -D TWR_K60N512 -lCN "F:\My          /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\FLASH_51 /
//                    2KB_PFLASH\List\" -lB "F:\My                            /
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
//                    ASH_512KB_PFLASH\List\hw_sdhc.s                         /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME hw_sdhc

        PUBLIC SDHC_Card
        PUBLIC hw_sdhc_init
        PUBLIC hw_sdhc_ioctl
        PUBLIC hw_sdhc_receive_block
        PUBLIC hw_sdhc_send_block

// F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\gpio\hw_sdhc.c
//    1 //=========================================================================
//    2 // 文件名称：hw_sdhc.c                                                          
//    3 // 功能概要：sdhc构件源文件
//    4 // 版权所有: 苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
//    5 // 版本更新:     时间                     版本                                       修改
//    6 //           2011-12-14     V1.0        SDHC构件初始版本
//    7 //           2011-12-20     V1.1        SDHC构件优化修改
//    8 //=========================================================================
//    9 #include "hw_sdhc.h"
//   10 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   11 SDCARD_STRUCT 		SDHC_Card;
SDHC_Card:
        DS8 24
//   12 
//   13 //SDHC命令，包括每条命令执行时的XFERTYP寄存器各个域的设置
//   14 static const unsigned long ESDHC_COMMAND_XFERTYP[] = 
//   15 {
//   16 	// CMD0
//   17     SDHC_XFERTYP_CMDINX(ESDHC_CMD0) | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_NO),
//   18     SDHC_XFERTYP_CMDINX(ESDHC_CMD1) | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_NO),
//   19     SDHC_XFERTYP_CMDINX(ESDHC_CMD2) | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_136),
//   20     SDHC_XFERTYP_CMDINX(ESDHC_CMD3) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   21     SDHC_XFERTYP_CMDINX(ESDHC_CMD4) | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_NO),
//   22     // CMD5 
//   23     SDHC_XFERTYP_CMDINX(ESDHC_CMD5) | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   24     SDHC_XFERTYP_CMDINX(ESDHC_CMD6) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   25     SDHC_XFERTYP_CMDINX(ESDHC_CMD7) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48BUSY),
//   26     SDHC_XFERTYP_CMDINX(ESDHC_CMD8) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   27     SDHC_XFERTYP_CMDINX(ESDHC_CMD9) | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_136),
//   28     // CMD10 
//   29     SDHC_XFERTYP_CMDINX(ESDHC_CMD10) | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_136),
//   30     SDHC_XFERTYP_CMDINX(ESDHC_CMD11) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   31     SDHC_XFERTYP_CMDINX(ESDHC_CMD12) | SDHC_XFERTYP_CMDTYP(ESDHC_XFERTYP_CMDTYP_ABORT) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48BUSY),
//   32     SDHC_XFERTYP_CMDINX(ESDHC_CMD13) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   33     0,
//   34     // CMD15 
//   35     SDHC_XFERTYP_CMDINX(ESDHC_CMD15) | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_NO),
//   36     SDHC_XFERTYP_CMDINX(ESDHC_CMD16) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   37     SDHC_XFERTYP_CMDINX(ESDHC_CMD17) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   38     SDHC_XFERTYP_CMDINX(ESDHC_CMD18) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   39     0,
//   40     // CMD20 
//   41     SDHC_XFERTYP_CMDINX(ESDHC_CMD20) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   42     0,
//   43     SDHC_XFERTYP_CMDINX(ESDHC_ACMD22) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   44     SDHC_XFERTYP_CMDINX(ESDHC_ACMD23) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   45     SDHC_XFERTYP_CMDINX(ESDHC_CMD24) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   46     // CMD25 
//   47     SDHC_XFERTYP_CMDINX(ESDHC_CMD25) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   48     SDHC_XFERTYP_CMDINX(ESDHC_CMD26) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   49     SDHC_XFERTYP_CMDINX(ESDHC_CMD27) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   50     SDHC_XFERTYP_CMDINX(ESDHC_CMD28) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48BUSY),
//   51     SDHC_XFERTYP_CMDINX(ESDHC_CMD29) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48BUSY),
//   52     // CMD30 
//   53     SDHC_XFERTYP_CMDINX(ESDHC_CMD30) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   54     0,
//   55     SDHC_XFERTYP_CMDINX(ESDHC_CMD32) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   56     SDHC_XFERTYP_CMDINX(ESDHC_CMD33) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   57     SDHC_XFERTYP_CMDINX(ESDHC_CMD34) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   58     // CMD35 
//   59     SDHC_XFERTYP_CMDINX(ESDHC_CMD35) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   60     SDHC_XFERTYP_CMDINX(ESDHC_CMD36) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   61     SDHC_XFERTYP_CMDINX(ESDHC_CMD37) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   62     SDHC_XFERTYP_CMDINX(ESDHC_CMD38) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48BUSY),
//   63     SDHC_XFERTYP_CMDINX(ESDHC_CMD39) | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   64     // CMD40 
//   65     SDHC_XFERTYP_CMDINX(ESDHC_CMD40) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   66     SDHC_XFERTYP_CMDINX(ESDHC_ACMD41) | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   67     SDHC_XFERTYP_CMDINX(ESDHC_CMD42) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48BUSY),
//   68     0,
//   69     0,
//   70     // CMD45 
//   71     0,
//   72     0,
//   73     0,
//   74     0,
//   75     0,
//   76     // CMD50 
//   77     0,
//   78     SDHC_XFERTYP_CMDINX(ESDHC_ACMD51) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   79     SDHC_XFERTYP_CMDINX(ESDHC_CMD52) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   80     SDHC_XFERTYP_CMDINX(ESDHC_CMD53) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   81     0,
//   82     // CMD55 
//   83     SDHC_XFERTYP_CMDINX(ESDHC_CMD55) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48),
//   84     SDHC_XFERTYP_CMDINX(ESDHC_CMD56) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48BUSY),
//   85     0,
//   86     0,
//   87     0,
//   88     // CMD60 
//   89     SDHC_XFERTYP_CMDINX(ESDHC_CMD60) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48BUSY),
//   90     SDHC_XFERTYP_CMDINX(ESDHC_CMD61) | SDHC_XFERTYP_CICEN_MASK | SDHC_XFERTYP_CCCEN_MASK | SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48BUSY),
//   91     0,
//   92     0
//   93 };
//   94 static void SDHC_set_baudrate(uint32 clock, uint32 baudrate);
//   95 static uint8 SDHC_is_running(void);
//   96 static uint32 SDHC_status_wait(uint32 mask);
//   97 static uint32 SDHC_send_command (ESDHC_COMMAND_STRUCT_PTR command);
//   98 
//   99 //=========================================================================
//  100 //函数名称：hw_sdhc_init                                                        
//  101 //功能概要：初始化SDHC模块。                                                
//  102 //参数说明：coreClk：内核时钟                                                    
//  103 //         baud：SDHC通信频率                                 
//  104 //函数返回：成功时返回：ESDHC_OK;其他返回值为错误。                                                               
//  105 //=========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  106 uint32 hw_sdhc_init(uint32 coreClk, uint32 baud)					
//  107 {
hw_sdhc_init:
        PUSH     {R7,LR}
//  108 	SDHC_Card.CARD_TYPE = ESDHC_CARD_NONE;
        LDR.W    R2,??DataTable8
        MOVS     R3,#+0
        STRB     R3,[R2, #+0]
//  109 	
//  110     //使能SDHC模块的时钟门
//  111     SIM_SCGC3 |= SIM_SCGC3_SDHC_MASK;
        LDR.W    R2,??DataTable8_1  ;; 0x40048030
        LDR      R2,[R2, #+0]
        ORRS     R2,R2,#0x20000
        LDR.W    R3,??DataTable8_1  ;; 0x40048030
        STR      R2,[R3, #+0]
//  112     
//  113 	//复位SDHC
//  114     SDHC_SYSCTL = SDHC_SYSCTL_RSTA_MASK | SDHC_SYSCTL_SDCLKFS(0x80);    
        LDR.W    R2,??DataTable8_2  ;; 0x400b102c
        LDR.W    R3,??DataTable8_3  ;; 0x1008000
        STR      R3,[R2, #+0]
//  115     while (SDHC_SYSCTL & SDHC_SYSCTL_RSTA_MASK){};
??hw_sdhc_init_0:
        LDR.W    R2,??DataTable8_2  ;; 0x400b102c
        LDR      R2,[R2, #+0]
        LSLS     R2,R2,#+7
        BMI.N    ??hw_sdhc_init_0
//  116     
//  117     //初始化SDHC相关寄存器
//  118     SDHC_VENDOR = 0;
        LDR.W    R2,??DataTable8_4  ;; 0x400b10c0
        MOVS     R3,#+0
        STR      R3,[R2, #+0]
//  119     SDHC_BLKATTR = SDHC_BLKATTR_BLKCNT(1) | SDHC_BLKATTR_BLKSIZE(512);
        LDR.W    R2,??DataTable8_5  ;; 0x400b1004
        MOVS     R3,#+66048
        STR      R3,[R2, #+0]
//  120     SDHC_PROCTL = SDHC_PROCTL_EMODE(ESDHC_PROCTL_EMODE_INVARIANT) 
//  121                 | SDHC_PROCTL_D3CD_MASK; 
        LDR.W    R2,??DataTable8_6  ;; 0x400b1028
        MOVS     R3,#+40
        STR      R3,[R2, #+0]
//  122     SDHC_WML = SDHC_WML_RDWML(1) | SDHC_WML_WRWML(1);
        LDR.W    R2,??DataTable8_7  ;; 0x400b1044
        MOVS     R3,#+65537
        STR      R3,[R2, #+0]
//  123     
//  124     //设置SDHC模块的通信速率
//  125     SDHC_set_baudrate (coreClk,baud);
        BL       SDHC_set_baudrate
//  126     
//  127     //检查CMD通道和DAT通道是否准备就绪
//  128     while (SDHC_PRSSTAT & (  SDHC_PRSSTAT_CIHB_MASK 
//  129                            | SDHC_PRSSTAT_CDIHB_MASK)){};
??hw_sdhc_init_1:
        LDR.W    R0,??DataTable8_8  ;; 0x400b1024
        LDR      R0,[R0, #+0]
        ANDS     R0,R0,#0x3
        CMP      R0,#+0
        BNE.N    ??hw_sdhc_init_1
//  130 
//  131     //设置复用引脚功能为SDHC
//  132     PORTE_PCR(0) = 0xFFFF & (   PORT_PCR_MUX(4) 
//  133                               | PORT_PCR_PS_MASK 
//  134                               | PORT_PCR_PE_MASK 
//  135                               | PORT_PCR_DSE_MASK); // ESDHC.D1  
        LDR.W    R0,??DataTable8_9  ;; 0x4004d000
        MOVW     R1,#+1091
        STR      R1,[R0, #+0]
//  136     PORTE_PCR(1) = 0xFFFF & (   PORT_PCR_MUX(4) 
//  137                               | PORT_PCR_PS_MASK 
//  138                               | PORT_PCR_PE_MASK 
//  139                               | PORT_PCR_DSE_MASK); // ESDHC.D0  
        LDR.W    R0,??DataTable8_10  ;; 0x4004d004
        MOVW     R1,#+1091
        STR      R1,[R0, #+0]
//  140     PORTE_PCR(2) = 0xFFFF & (   PORT_PCR_MUX(4) 
//  141                               | PORT_PCR_DSE_MASK); // ESDHC.CLK 
        LDR.W    R0,??DataTable8_11  ;; 0x4004d008
        MOV      R1,#+1088
        STR      R1,[R0, #+0]
//  142     PORTE_PCR(3) = 0xFFFF & (   PORT_PCR_MUX(4) 
//  143                               | PORT_PCR_PS_MASK 
//  144                               | PORT_PCR_PE_MASK 
//  145                               | PORT_PCR_DSE_MASK); // ESDHC.CMD 
        LDR.W    R0,??DataTable8_12  ;; 0x4004d00c
        MOVW     R1,#+1091
        STR      R1,[R0, #+0]
//  146     PORTE_PCR(4) = 0xFFFF & (   PORT_PCR_MUX(4) 
//  147                               | PORT_PCR_PS_MASK 
//  148                               | PORT_PCR_PE_MASK 
//  149                               | PORT_PCR_DSE_MASK); // ESDHC.D3  
        LDR.W    R0,??DataTable8_13  ;; 0x4004d010
        MOVW     R1,#+1091
        STR      R1,[R0, #+0]
//  150     PORTE_PCR(5) = 0xFFFF & (   PORT_PCR_MUX(4) 
//  151                               | PORT_PCR_PS_MASK 
//  152                               | PORT_PCR_PE_MASK 
//  153                               | PORT_PCR_DSE_MASK);  // ESDHC.D2  
        LDR.W    R0,??DataTable8_14  ;; 0x4004d014
        MOVW     R1,#+1091
        STR      R1,[R0, #+0]
//  154     
//  155     //清除SDHC模块的中断标志
//  156     SDHC_IRQSTAT = 0xFFFF;
        LDR.W    R0,??DataTable8_15  ;; 0x400b1030
        MOVW     R1,#+65535
        STR      R1,[R0, #+0]
//  157     //使能中断位
//  158     SDHC_IRQSTATEN = SDHC_IRQSTATEN_DEBESEN_MASK 
//  159                    | SDHC_IRQSTATEN_DCESEN_MASK 
//  160                    | SDHC_IRQSTATEN_DTOESEN_MASK 
//  161                    | SDHC_IRQSTATEN_CIESEN_MASK 
//  162                    | SDHC_IRQSTATEN_CEBESEN_MASK 
//  163                    | SDHC_IRQSTATEN_CCESEN_MASK 
//  164                    | SDHC_IRQSTATEN_CTOESEN_MASK 
//  165                    | SDHC_IRQSTATEN_BRRSEN_MASK 
//  166                    | SDHC_IRQSTATEN_BWRSEN_MASK 
//  167                    | SDHC_IRQSTATEN_CRMSEN_MASK
//  168                    | SDHC_IRQSTATEN_TCSEN_MASK 
//  169                    | SDHC_IRQSTATEN_CCSEN_MASK;
        LDR.W    R0,??DataTable8_16  ;; 0x400b1034
        LDR.W    R1,??DataTable8_17  ;; 0x7f00b3
        STR      R1,[R0, #+0]
//  170     
//  171     //80个时钟周期的初始化
//  172     SDHC_SYSCTL |= SDHC_SYSCTL_INITA_MASK;
        LDR.W    R0,??DataTable8_2  ;; 0x400b102c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8000000
        LDR.W    R1,??DataTable8_2  ;; 0x400b102c
        STR      R0,[R1, #+0]
//  173     while (SDHC_SYSCTL & SDHC_SYSCTL_INITA_MASK){};
??hw_sdhc_init_2:
        LDR.W    R0,??DataTable8_2  ;; 0x400b102c
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+4
        BMI.N    ??hw_sdhc_init_2
//  174 
//  175     //检查卡是否已经插入
//  176     if (SDHC_PRSSTAT & SDHC_PRSSTAT_CINS_MASK)
        LDR.W    R0,??DataTable8_8  ;; 0x400b1024
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+15
        BPL.N    ??hw_sdhc_init_3
//  177     {
//  178     	SDHC_Card.CARD_TYPE = ESDHC_CARD_UNKNOWN;
        LDR.W    R0,??DataTable8
        MOVS     R1,#+1
        STRB     R1,[R0, #+0]
//  179     }
//  180     SDHC_IRQSTAT |= SDHC_IRQSTAT_CRM_MASK;
??hw_sdhc_init_3:
        LDR.W    R0,??DataTable8_15  ;; 0x400b1030
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.W    R1,??DataTable8_15  ;; 0x400b1030
        STR      R0,[R1, #+0]
//  181     
//  182     return ESDHC_OK;
        MOVS     R0,#+0
        POP      {R1,PC}          ;; return
//  183 }
//  184 
//  185 //=========================================================================
//  186 //函数名称：hw_sdhc_receive_block                                                         
//  187 //功能概要：接收n个字节                                                 
//  188 //参数说明：buff: 接收缓冲区                                                 
//  189 //		   btr:接收长度                                                     
//  190 //函数返回： 1:成功;0:失败                                                    
//  191 //=========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  192 uint32 hw_sdhc_receive_block (uint8 *buff,uint32 btr)
//  193 {
hw_sdhc_receive_block:
        PUSH     {R4}
//  194     uint32	bytes, i, j;
//  195     uint32	*ptr = (uint32*)buff;
//  196     
//  197     //当可识别的卡插入后，接收数据前，检测DAT通道是否忙（正在使用中）
//  198     if (    (SDHC_Card.CARD_TYPE == ESDHC_CARD_SD) 
//  199          || (SDHC_Card.CARD_TYPE == ESDHC_CARD_SDHC) 
//  200          || (SDHC_Card.CARD_TYPE == ESDHC_CARD_MMC) 
//  201          || (SDHC_Card.CARD_TYPE == ESDHC_CARD_CEATA))
        LDR.W    R2,??DataTable8
        LDRB     R2,[R2, #+0]
        CMP      R2,#+2
        BEQ.N    ??hw_sdhc_receive_block_0
        LDR.W    R2,??DataTable8
        LDRB     R2,[R2, #+0]
        CMP      R2,#+3
        BEQ.N    ??hw_sdhc_receive_block_0
        LDR.W    R2,??DataTable8
        LDRB     R2,[R2, #+0]
        CMP      R2,#+7
        BEQ.N    ??hw_sdhc_receive_block_0
        LDR.W    R2,??DataTable8
        LDRB     R2,[R2, #+0]
        CMP      R2,#+8
        BNE.N    ??hw_sdhc_receive_block_1
//  202     {
//  203         while (SDHC_PRSSTAT & SDHC_PRSSTAT_DLA_MASK){};
??hw_sdhc_receive_block_0:
        LDR.W    R2,??DataTable8_8  ;; 0x400b1024
        LDR      R2,[R2, #+0]
        LSLS     R2,R2,#+29
        BMI.N    ??hw_sdhc_receive_block_0
//  204     }    
//  205     
//  206     //读取数据时，每次读取4个字节
//  207     bytes = btr;
??hw_sdhc_receive_block_1:
        B.N      ??hw_sdhc_receive_block_2
//  208     while (bytes)
//  209     {
//  210         i = bytes > 512 ? 512 : bytes;
//  211         for (j = (i + 3) >> 2; j != 0; j--)
//  212         {
//  213             if (SDHC_IRQSTAT & (    SDHC_IRQSTAT_DEBE_MASK 
//  214                                   | SDHC_IRQSTAT_DCE_MASK 
//  215                                   | SDHC_IRQSTAT_DTOE_MASK))
//  216             {
//  217                 SDHC_IRQSTAT |= SDHC_IRQSTAT_DEBE_MASK 
//  218                               | SDHC_IRQSTAT_DCE_MASK 
//  219                               | SDHC_IRQSTAT_DTOE_MASK 
//  220                               | SDHC_IRQSTAT_BRR_MASK;
//  221                 return 0;
//  222             }
//  223             
//  224             while (0 == (SDHC_PRSSTAT & SDHC_PRSSTAT_BREN_MASK)){};
//  225 
//  226             *ptr++ = SDHC_DATPORT;
//  227         }
//  228         bytes -= i;
??hw_sdhc_receive_block_3:
        SUBS     R1,R1,R2
??hw_sdhc_receive_block_2:
        CMP      R1,#+0
        BEQ.N    ??hw_sdhc_receive_block_4
        CMP      R1,#+512
        BLS.N    ??hw_sdhc_receive_block_5
        MOV      R2,#+512
        B.N      ??hw_sdhc_receive_block_6
??hw_sdhc_receive_block_5:
        MOVS     R2,R1
??hw_sdhc_receive_block_6:
        ADDS     R3,R2,#+3
        LSRS     R3,R3,#+2
        B.N      ??hw_sdhc_receive_block_7
??hw_sdhc_receive_block_8:
        LDR.W    R4,??DataTable8_8  ;; 0x400b1024
        LDR      R4,[R4, #+0]
        LSLS     R4,R4,#+20
        BPL.N    ??hw_sdhc_receive_block_8
        LDR.W    R4,??DataTable8_18  ;; 0x400b1020
        LDR      R4,[R4, #+0]
        STR      R4,[R0, #+0]
        ADDS     R0,R0,#+4
        SUBS     R3,R3,#+1
??hw_sdhc_receive_block_7:
        CMP      R3,#+0
        BEQ.N    ??hw_sdhc_receive_block_3
        LDR.W    R4,??DataTable8_15  ;; 0x400b1030
        LDR      R4,[R4, #+0]
        TST      R4,#0x700000
        BEQ.N    ??hw_sdhc_receive_block_8
        LDR.W    R0,??DataTable8_15  ;; 0x400b1030
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable8_19  ;; 0x700020
        ORRS     R0,R1,R0
        LDR.W    R1,??DataTable8_15  ;; 0x400b1030
        STR      R0,[R1, #+0]
        MOVS     R0,#+0
        B.N      ??hw_sdhc_receive_block_9
//  229     }
//  230     
//  231 	return 1;						// Return with success     
??hw_sdhc_receive_block_4:
        MOVS     R0,#+1
??hw_sdhc_receive_block_9:
        POP      {R4}
        BX       LR               ;; return
//  232 }
//  233 
//  234 //=========================================================================
//  235 //函数名称：hw_sdhc_send_block                                                         
//  236 //功能概要：发送n个字节                                                 
//  237 //参数说明：buff: 发送缓冲区                                                 
//  238 //		   btr:发送长度                                                     
//  239 //函数返回： 1:成功;0:失败                                                    
//  240 //=========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  241 uint32 hw_sdhc_send_block (const uint8 *buff,uint32 btr)
//  242 {
hw_sdhc_send_block:
        PUSH     {R4}
//  243     uint32  bytes, i;
//  244     uint32	*ptr = (uint32*)buff;
//  245 
//  246     //读取数据时，每次读取4个字节
//  247     bytes = btr;
//  248     while (bytes)
??hw_sdhc_send_block_0:
        CMP      R1,#+0
        BEQ.N    ??hw_sdhc_send_block_1
//  249     {
//  250         i = bytes > 512 ? 512 : bytes;
        CMP      R1,#+512
        BLS.N    ??hw_sdhc_send_block_2
        MOV      R2,#+512
        B.N      ??hw_sdhc_send_block_3
??hw_sdhc_send_block_2:
        MOVS     R2,R1
//  251         bytes -= i;
??hw_sdhc_send_block_3:
        SUBS     R1,R1,R2
//  252         for (i = (i + 3) >> 2; i != 0; i--)
        ADDS     R2,R2,#+3
        LSRS     R2,R2,#+2
        B.N      ??hw_sdhc_send_block_4
//  253         {
//  254             if (SDHC_IRQSTAT & (    SDHC_IRQSTAT_DEBE_MASK 
//  255                                   | SDHC_IRQSTAT_DCE_MASK 
//  256                                   | SDHC_IRQSTAT_DTOE_MASK))
//  257             {
//  258             	SDHC_IRQSTAT |= SDHC_IRQSTAT_DEBE_MASK 
//  259             	              | SDHC_IRQSTAT_DCE_MASK 
//  260             	              | SDHC_IRQSTAT_DTOE_MASK 
//  261             	              | SDHC_IRQSTAT_BWR_MASK;
//  262                 return 0;
//  263             }
//  264             while (0 == (SDHC_PRSSTAT & SDHC_PRSSTAT_BWEN_MASK)){};
??hw_sdhc_send_block_5:
        LDR.W    R3,??DataTable8_8  ;; 0x400b1024
        LDR      R3,[R3, #+0]
        LSLS     R3,R3,#+21
        BPL.N    ??hw_sdhc_send_block_5
//  265 
//  266             SDHC_DATPORT = *ptr++;
        LDR.W    R3,??DataTable8_18  ;; 0x400b1020
        LDR      R4,[R0, #+0]
        STR      R4,[R3, #+0]
        ADDS     R0,R0,#+4
        SUBS     R2,R2,#+1
??hw_sdhc_send_block_4:
        CMP      R2,#+0
        BEQ.N    ??hw_sdhc_send_block_0
        LDR.W    R3,??DataTable8_15  ;; 0x400b1030
        LDR      R3,[R3, #+0]
        TST      R3,#0x700000
        BEQ.N    ??hw_sdhc_send_block_5
        LDR.W    R0,??DataTable8_15  ;; 0x400b1030
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable8_20  ;; 0x700010
        ORRS     R0,R1,R0
        LDR.W    R1,??DataTable8_15  ;; 0x400b1030
        STR      R0,[R1, #+0]
        MOVS     R0,#+0
        B.N      ??hw_sdhc_send_block_6
//  267 
//  268         }
//  269     }
//  270 	return 1;
??hw_sdhc_send_block_1:
        MOVS     R0,#+1
??hw_sdhc_send_block_6:
        POP      {R4}
        BX       LR               ;; return
//  271 }
//  272 
//  273 //=========================================================================
//  274 //函数名称：hw_sdhc_ioctl
//  275 //功能概要：配置SDHC模块
//  276 //参数说明：cmd: 配置命令
//  277 //		   param_ptr:数据指针
//  278 //函数返回： 功时返回：ESDHC_OK;其他返回值为错误
//  279 //=========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  280 uint32 hw_sdhc_ioctl(uint32 cmd,void *param_ptr)
//  281 {
hw_sdhc_ioctl:
        PUSH     {R4-R10,LR}
        SUB      SP,SP,#+32
        MOVS     R4,R1
//  282     ESDHC_COMMAND_STRUCT    command; 
//  283     uint8   mem, io, mmc, ceata, mp, hc; //标志当前卡类型
//  284     uint32  i, val;
//  285     uint32  result = ESDHC_OK;
        MOVS     R10,#+0
//  286     uint32  *param32_ptr = param_ptr;
//  287     
//  288     switch (cmd) 
        CMP      R0,#+1
        BEQ.N    ??hw_sdhc_ioctl_0
        BCC.W    ??hw_sdhc_ioctl_1
        CMP      R0,#+3
        BEQ.W    ??hw_sdhc_ioctl_2
        BCC.W    ??hw_sdhc_ioctl_3
        CMP      R0,#+5
        BEQ.W    ??hw_sdhc_ioctl_4
        BCC.W    ??hw_sdhc_ioctl_5
        CMP      R0,#+7
        BEQ.W    ??hw_sdhc_ioctl_6
        BCC.W    ??hw_sdhc_ioctl_7
        CMP      R0,#+9
        BEQ.W    ??hw_sdhc_ioctl_8
        BCC.W    ??hw_sdhc_ioctl_9
        B.N      ??hw_sdhc_ioctl_1
//  289     {
//  290         //初始化SD卡读写系统
//  291         case IO_IOCTL_ESDHC_INIT:        	
//  292             result = hw_sdhc_init (CORE_CLOCK_HZ, BAUD_RATE_HZ);
??hw_sdhc_ioctl_0:
        LDR.W    R1,??DataTable8_21  ;; 0x17d7840
        LDR.W    R0,??DataTable8_22  ;; 0x5b8d800
        BL       hw_sdhc_init
        MOV      R10,R0
//  293             if (ESDHC_OK != result)
        CMP      R10,#+0
        BNE.W    ??hw_sdhc_ioctl_10
//  294             {
//  295                 break;
//  296             }
//  297             
//  298             mem = FALSE;
??hw_sdhc_ioctl_11:
        MOVS     R4,#+0
//  299             io = FALSE;
        MOVS     R5,#+0
//  300             mmc = FALSE;
        MOVS     R6,#+0
//  301             ceata = FALSE;
        MOVS     R7,#+0
//  302             hc = FALSE;
        MOVS     R8,#+0
//  303             mp = FALSE;
        MOVS     R9,#+0
//  304 
//  305             //CMD0,使得SD卡进入空闲模式，复位SD卡
//  306             command.COMMAND = ESDHC_CMD0;
        MOVS     R0,#+0
        STRB     R0,[SP, #+0]
//  307             command.TYPE = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+1]
//  308             command.ARGUMENT = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+4]
//  309             command.READ = FALSE;
        MOVS     R0,#+0
        STRB     R0,[SP, #+8]
//  310             command.BLOCKS = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+12]
//  311             if (SDHC_send_command (&command))
        ADD      R0,SP,#+0
        BL       SDHC_send_command
        CMP      R0,#+0
        BEQ.N    ??hw_sdhc_ioctl_12
//  312             {
//  313                 result = ESDHC_ERROR_INIT_FAILED;
        MOVS     R10,#+1
//  314                 break;
        B.N      ??hw_sdhc_ioctl_10
//  315             }
//  316             
//  317             for(i = 0;i < 2000000;i++)
??hw_sdhc_ioctl_12:
        MOVS     R0,#+0
        B.N      ??hw_sdhc_ioctl_13
??hw_sdhc_ioctl_14:
        ADDS     R0,R0,#+1
??hw_sdhc_ioctl_13:
        LDR.W    R1,??DataTable8_23  ;; 0x1e8480
        CMP      R0,R1
        BCC.N    ??hw_sdhc_ioctl_14
//  318             {
//  319             }
//  320 
//  321             //CMD8
//  322             command.COMMAND = ESDHC_CMD8;
        MOVS     R0,#+8
        STRB     R0,[SP, #+0]
//  323             command.TYPE = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+1]
//  324             command.ARGUMENT = 0x000001AA;
        MOV      R0,#+426
        STR      R0,[SP, #+4]
//  325             command.READ = FALSE;
        MOVS     R0,#+0
        STRB     R0,[SP, #+8]
//  326             command.BLOCKS = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+12]
//  327             val = SDHC_send_command (&command);
        ADD      R0,SP,#+0
        BL       SDHC_send_command
        MOV      R9,R0
//  328             
//  329             if (val == 0)
        CMP      R9,#+0
        BNE.N    ??hw_sdhc_ioctl_15
//  330             {
//  331                 // SDHC卡
//  332             	if (command.RESPONSE[0] != command.ARGUMENT)
        LDR      R0,[SP, #+16]
        LDR      R1,[SP, #+4]
        CMP      R0,R1
        BEQ.N    ??hw_sdhc_ioctl_16
//  333                 {
//  334                     result = ESDHC_ERROR_INIT_FAILED;
        MOVS     R10,#+1
//  335                     break;
        B.N      ??hw_sdhc_ioctl_10
//  336                 }
//  337                 hc = TRUE;
??hw_sdhc_ioctl_16:
        MOVS     R8,#+1
//  338             }
//  339 
//  340             mp = TRUE;
??hw_sdhc_ioctl_15:
        MOVS     R9,#+1
//  341             
//  342             if (mp)
        UXTB     R9,R9            ;; ZeroExt  R9,R9,#+24,#+24
        CMP      R9,#+0
        BEQ.W    ??hw_sdhc_ioctl_17
//  343             {
//  344                 //CMD55，检查是否为MMC卡
//  345                 command.COMMAND = ESDHC_CMD55;
        MOVS     R0,#+55
        STRB     R0,[SP, #+0]
//  346                 command.TYPE = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+1]
//  347                 command.ARGUMENT = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+4]
//  348                 command.READ = FALSE;
        MOVS     R0,#+0
        STRB     R0,[SP, #+8]
//  349                 command.BLOCKS = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+12]
//  350                 val = SDHC_send_command (&command);
        ADD      R0,SP,#+0
        BL       SDHC_send_command
        MOV      R9,R0
//  351                 if (val > 0)
        CMP      R9,#+0
        BEQ.N    ??hw_sdhc_ioctl_18
//  352                 {
//  353                     result = ESDHC_ERROR_INIT_FAILED;
        MOVS     R10,#+1
//  354                     break;
        B.N      ??hw_sdhc_ioctl_10
//  355                 }
//  356                 if (val < 0)
//  357                 {
//  358                     // MMC 或 CE-ATA
//  359                     io = FALSE;
//  360                     mem = FALSE;
//  361                     hc = FALSE;
//  362                     
//  363                     //CMD1
//  364                     command.COMMAND = ESDHC_CMD1;
//  365                     command.TYPE = ESDHC_TYPE_NORMAL;
//  366                     command.ARGUMENT = 0x40300000;
//  367                     command.READ = FALSE;
//  368                     command.BLOCKS = 0;
//  369                     if (SDHC_send_command (&command))
//  370                     {
//  371                         result = ESDHC_ERROR_INIT_FAILED;
//  372                         break;
//  373                     }
//  374                     if (0x20000000 == (command.RESPONSE[0] & 0x60000000))
//  375                     {
//  376                         hc = TRUE;
//  377                     }
//  378                     mmc = TRUE;
//  379 
//  380                     //CMD39
//  381                     command.COMMAND = ESDHC_CMD39;
//  382                     command.TYPE = ESDHC_TYPE_NORMAL;
//  383                     command.ARGUMENT = 0x0C00;
//  384                     command.READ = FALSE;
//  385                     command.BLOCKS = 0;
//  386                     if (SDHC_send_command (&command))
//  387                     {
//  388                         result = ESDHC_ERROR_INIT_FAILED;
//  389                         break;
//  390                     }
//  391                     if (0xCE == (command.RESPONSE[0] >> 8) & 0xFF)
//  392                     {
//  393                         //CMD39
//  394                         command.COMMAND = ESDHC_CMD39;
//  395                         command.TYPE = ESDHC_TYPE_NORMAL;
//  396                         command.ARGUMENT = 0x0D00;
//  397                         command.READ = FALSE;
//  398                         command.BLOCKS = 0;
//  399                         if (SDHC_send_command (&command))
//  400                         {
//  401                             result = ESDHC_ERROR_INIT_FAILED;
//  402                             break;
//  403                         }
//  404                         if (0xAA == (command.RESPONSE[0] >> 8) & 0xFF)
//  405                         {
//  406                             mmc = FALSE;
//  407                             ceata = TRUE;
//  408                         }
//  409                     }
//  410                 }
//  411                 else
//  412                 {
//  413                     //当为SD卡时
//  414                     // ACMD41
//  415                     command.COMMAND = ESDHC_ACMD41;
??hw_sdhc_ioctl_18:
        MOVS     R0,#+105
        STRB     R0,[SP, #+0]
//  416                     command.TYPE = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+1]
//  417                     command.ARGUMENT = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+4]
//  418                     command.READ = FALSE;
        MOVS     R0,#+0
        STRB     R0,[SP, #+8]
//  419                     command.BLOCKS = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+12]
//  420                     if (SDHC_send_command (&command))
        ADD      R0,SP,#+0
        BL       SDHC_send_command
        CMP      R0,#+0
        BEQ.N    ??hw_sdhc_ioctl_19
//  421                     {
//  422                         result = ESDHC_ERROR_INIT_FAILED;
        MOVS     R10,#+1
//  423                         break;
        B.N      ??hw_sdhc_ioctl_10
//  424                     }
//  425                     if (command.RESPONSE[0] & 0x300000)
??hw_sdhc_ioctl_19:
        LDR      R0,[SP, #+16]
        TST      R0,#0x300000
        BEQ.N    ??hw_sdhc_ioctl_17
//  426                     {
//  427                         val = 0;
        MOVS     R9,#+0
//  428                         do 
//  429                         {
//  430                             for(i = 0;i < 500000;i++)
??hw_sdhc_ioctl_20:
        MOVS     R0,#+0
        B.N      ??hw_sdhc_ioctl_21
??hw_sdhc_ioctl_22:
        ADDS     R0,R0,#+1
??hw_sdhc_ioctl_21:
        LDR.W    R1,??DataTable8_24  ;; 0x7a120
        CMP      R0,R1
        BCC.N    ??hw_sdhc_ioctl_22
//  431                             {
//  432                             }
//  433                             val++;
        ADDS     R9,R9,#+1
//  434                             
//  435                             // CMD55 + ACMD41 - Send OCR 
//  436                             command.COMMAND = ESDHC_CMD55;
        MOVS     R0,#+55
        STRB     R0,[SP, #+0]
//  437                             command.TYPE = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+1]
//  438                             command.ARGUMENT = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+4]
//  439                             command.READ = FALSE;
        MOVS     R0,#+0
        STRB     R0,[SP, #+8]
//  440                             command.BLOCKS = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+12]
//  441                             if (SDHC_send_command (&command))
        ADD      R0,SP,#+0
        BL       SDHC_send_command
        CMP      R0,#+0
        BEQ.N    ??hw_sdhc_ioctl_23
//  442                             {
//  443                                 result = ESDHC_ERROR_INIT_FAILED;
        MOVS     R10,#+1
//  444                                 break;
        B.N      ??hw_sdhc_ioctl_24
//  445                             }
//  446 
//  447                             command.COMMAND = ESDHC_ACMD41;
??hw_sdhc_ioctl_23:
        MOVS     R0,#+105
        STRB     R0,[SP, #+0]
//  448                             command.TYPE = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+1]
//  449                             if (hc)
        UXTB     R8,R8            ;; ZeroExt  R8,R8,#+24,#+24
        CMP      R8,#+0
        BEQ.N    ??hw_sdhc_ioctl_25
//  450                             {
//  451                                 command.ARGUMENT = 0x40300000;
        LDR.W    R0,??DataTable8_25  ;; 0x40300000
        STR      R0,[SP, #+4]
        B.N      ??hw_sdhc_ioctl_26
//  452                             }
//  453                             else
//  454                             {
//  455                                 command.ARGUMENT = 0x00300000;
??hw_sdhc_ioctl_25:
        MOVS     R0,#+3145728
        STR      R0,[SP, #+4]
//  456                             }
//  457                             command.READ = FALSE;
??hw_sdhc_ioctl_26:
        MOVS     R0,#+0
        STRB     R0,[SP, #+8]
//  458                             command.BLOCKS = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+12]
//  459                             if (SDHC_send_command (&command))
        ADD      R0,SP,#+0
        BL       SDHC_send_command
        CMP      R0,#+0
        BEQ.N    ??hw_sdhc_ioctl_27
//  460                             {
//  461                                 result = ESDHC_ERROR_INIT_FAILED;
        MOVS     R10,#+1
//  462                                 break;
        B.N      ??hw_sdhc_ioctl_24
//  463                             }
//  464                         } while ((0 == (command.RESPONSE[0] & 0x80000000)) && (val < 10));
??hw_sdhc_ioctl_27:
        LDR      R0,[SP, #+16]
        CMP      R0,#+0
        BMI.N    ??hw_sdhc_ioctl_24
        CMP      R9,#+10
        BCC.N    ??hw_sdhc_ioctl_20
//  465                         if (ESDHC_OK != result)
??hw_sdhc_ioctl_24:
        CMP      R10,#+0
        BNE.W    ??hw_sdhc_ioctl_10
//  466                         {
//  467                             break;
//  468                         }
//  469                         if (val >= 10)
??hw_sdhc_ioctl_28:
        CMP      R9,#+10
        BCC.N    ??hw_sdhc_ioctl_29
//  470                         {
//  471                             hc = FALSE;
        MOVS     R8,#+0
        B.N      ??hw_sdhc_ioctl_17
//  472                         }
//  473                         else
//  474                         {
//  475                             mem = TRUE;
??hw_sdhc_ioctl_29:
        MOVS     R4,#+1
//  476                             if (hc)
        UXTB     R8,R8            ;; ZeroExt  R8,R8,#+24,#+24
        CMP      R8,#+0
        BEQ.N    ??hw_sdhc_ioctl_17
//  477                             {
//  478                                 hc = FALSE;
        MOVS     R8,#+0
//  479                                 if (command.RESPONSE[0] & 0x40000000)
        LDR      R0,[SP, #+16]
        LSLS     R0,R0,#+1
        BPL.N    ??hw_sdhc_ioctl_17
//  480                                 {
//  481                                     hc = TRUE;
        MOVS     R8,#+1
//  482                                 }
//  483                             }
//  484                         }
//  485                     }
//  486                 }
//  487             }
//  488             
//  489             
//  490             if (mmc)
??hw_sdhc_ioctl_17:
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        CMP      R6,#+0
        BEQ.N    ??hw_sdhc_ioctl_30
//  491             {
//  492             	SDHC_Card.CARD_TYPE = ESDHC_CARD_MMC;
        LDR.W    R0,??DataTable8
        MOVS     R1,#+7
        STRB     R1,[R0, #+0]
//  493             }
//  494             if (ceata)
??hw_sdhc_ioctl_30:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        CMP      R7,#+0
        BEQ.N    ??hw_sdhc_ioctl_31
//  495             {
//  496             	SDHC_Card.CARD_TYPE = ESDHC_CARD_CEATA;
        LDR.W    R0,??DataTable8
        MOVS     R1,#+8
        STRB     R1,[R0, #+0]
//  497             }
//  498             if (io)
??hw_sdhc_ioctl_31:
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R5,#+0
        BEQ.N    ??hw_sdhc_ioctl_32
//  499             {
//  500             	SDHC_Card.CARD_TYPE = ESDHC_CARD_SDIO;
        LDR.W    R0,??DataTable8
        MOVS     R1,#+4
        STRB     R1,[R0, #+0]
//  501             }
//  502             if (mem)
??hw_sdhc_ioctl_32:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+0
        BEQ.N    ??hw_sdhc_ioctl_33
//  503             {
//  504             	SDHC_Card.CARD_TYPE = ESDHC_CARD_SD;
        LDR.W    R0,??DataTable8
        MOVS     R1,#+2
        STRB     R1,[R0, #+0]
//  505                 if (hc)
        UXTB     R8,R8            ;; ZeroExt  R8,R8,#+24,#+24
        CMP      R8,#+0
        BEQ.N    ??hw_sdhc_ioctl_33
//  506                 {
//  507                 	SDHC_Card.CARD_TYPE = ESDHC_CARD_SDHC;
        LDR.W    R0,??DataTable8
        MOVS     R1,#+3
        STRB     R1,[R0, #+0]
//  508                 }
//  509             }
//  510             if (io && mem)
??hw_sdhc_ioctl_33:
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R5,#+0
        BEQ.N    ??hw_sdhc_ioctl_34
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+0
        BEQ.N    ??hw_sdhc_ioctl_34
//  511             {
//  512             	SDHC_Card.CARD_TYPE = ESDHC_CARD_SDCOMBO;
        LDR.W    R0,??DataTable8
        MOVS     R1,#+5
        STRB     R1,[R0, #+0]
//  513                 if (hc)
        UXTB     R8,R8            ;; ZeroExt  R8,R8,#+24,#+24
        CMP      R8,#+0
        BEQ.N    ??hw_sdhc_ioctl_34
//  514                 {
//  515                 	SDHC_Card.CARD_TYPE = ESDHC_CARD_SDHCCOMBO;
        LDR.W    R0,??DataTable8
        MOVS     R1,#+6
        STRB     R1,[R0, #+0]
//  516                 }
//  517             }
//  518 
//  519             /*
//  520             //清除引脚复用寄存器
//  521             PORTE_PCR(0) = 0 & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.D1  
//  522             PORTE_PCR(1) = 0 & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.D0  
//  523             PORTE_PCR(2) = 0 & (PORT_PCR_MUX(4) | PORT_PCR_DSE_MASK);                                          // ESDHC.CLK 
//  524             PORTE_PCR(3) = 0 & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.CMD 
//  525             PORTE_PCR(4) = 0 & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.D3  
//  526             PORTE_PCR(5) = 0 & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.D2  
//  527 
//  528             //设置SDHC模块的波特率
//  529             SDHC_set_baudrate (CORE_CLOCK_HZ, BAUD_RATE_HZ);
//  530 
//  531             //设置复用引脚功能为SDHC
//  532             PORTE_PCR(0) = 0xFFFF & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.D1  
//  533             PORTE_PCR(1) = 0xFFFF & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.D0  
//  534             PORTE_PCR(2) = 0xFFFF & (PORT_PCR_MUX(4) | PORT_PCR_DSE_MASK);                                          // ESDHC.CLK 
//  535             PORTE_PCR(3) = 0xFFFF & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.CMD 
//  536             PORTE_PCR(4) = 0xFFFF & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.D3  
//  537             PORTE_PCR(5) = 0xFFFF & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.D2  
//  538 
//  539             //使能SDHC模块的时钟
//  540             SIM_SCGC3 |= SIM_SCGC3_SDHC_MASK;
//  541             */
//  542             break;
??hw_sdhc_ioctl_34:
        B.N      ??hw_sdhc_ioctl_10
//  543         //向卡发送命令
//  544         case IO_IOCTL_ESDHC_SEND_COMMAND:
//  545             val = SDHC_send_command ((ESDHC_COMMAND_STRUCT_PTR)param32_ptr);
??hw_sdhc_ioctl_3:
        MOVS     R0,R4
        BL       SDHC_send_command
        MOV      R9,R0
//  546             if (val > 0)
        CMP      R9,#+0
        BEQ.N    ??hw_sdhc_ioctl_35
//  547             {
//  548                 result = ESDHC_ERROR_COMMAND_FAILED;
        MOVS     R10,#+2
//  549             }
//  550             if (val < 0)
//  551             {
//  552                 result = ESDHC_ERROR_COMMAND_TIMEOUT;
//  553             }
//  554             break;
??hw_sdhc_ioctl_35:
        B.N      ??hw_sdhc_ioctl_10
//  555         //获取当前通信波特率状态
//  556         case IO_IOCTL_ESDHC_GET_BAUDRATE:
//  557             if (NULL == param32_ptr) 
??hw_sdhc_ioctl_5:
        CMP      R4,#+0
        BNE.N    ??hw_sdhc_ioctl_36
//  558             {
//  559                 result = IO_ERROR_INVALID_PARAMETER;
        MOVS     R10,#+12
        B.N      ??hw_sdhc_ioctl_37
//  560             } 
//  561             else 
//  562             {
//  563                 //获取当前设置的波特率
//  564                 val = ((SDHC_SYSCTL & SDHC_SYSCTL_SDCLKFS_MASK) >> SDHC_SYSCTL_SDCLKFS_SHIFT) << 1;
??hw_sdhc_ioctl_36:
        LDR.W    R0,??DataTable8_2  ;; 0x400b102c
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+8,#+8
        LSLS     R9,R0,#+1
//  565                 val *= ((SDHC_SYSCTL & SDHC_SYSCTL_DVS_MASK) >> SDHC_SYSCTL_DVS_SHIFT) + 1;
        LDR.W    R0,??DataTable8_2  ;; 0x400b102c
        LDR      R0,[R0, #+0]
        UBFX     R0,R0,#+4,#+4
        ADDS     R0,R0,#+1
        MUL      R9,R0,R9
//  566                 *param32_ptr = (uint32)(CORE_CLOCK_HZ / val);
        LDR.W    R0,??DataTable8_22  ;; 0x5b8d800
        UDIV     R0,R0,R9
        STR      R0,[R4, #+0]
//  567             }
//  568             break;
??hw_sdhc_ioctl_37:
        B.N      ??hw_sdhc_ioctl_10
//  569         //设定当前通信波特率状态
//  570         case IO_IOCTL_ESDHC_SET_BAUDRATE:
//  571             if (NULL == param32_ptr) 
??hw_sdhc_ioctl_4:
        CMP      R4,#+0
        BNE.N    ??hw_sdhc_ioctl_38
//  572             {
//  573                 result = IO_ERROR_INVALID_PARAMETER;
        MOVS     R10,#+12
        B.N      ??hw_sdhc_ioctl_39
//  574             } 
//  575             else if (0 == (*param32_ptr)) 
??hw_sdhc_ioctl_38:
        LDR      R0,[R4, #+0]
        CMP      R0,#+0
        BNE.N    ??hw_sdhc_ioctl_40
//  576             {
//  577                 result = IO_ERROR_INVALID_PARAMETER;
        MOVS     R10,#+12
        B.N      ??hw_sdhc_ioctl_39
//  578             } 
//  579             else 
//  580             {
//  581                 if (! SDHC_is_running())
??hw_sdhc_ioctl_40:
        BL       SDHC_is_running
        CMP      R0,#+0
        BNE.N    ??hw_sdhc_ioctl_41
//  582                 {
//  583                 	//清除引脚复用寄存器
//  584                     PORTE_PCR(0) = 0 & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.D1  
        LDR.W    R0,??DataTable8_9  ;; 0x4004d000
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//  585                     PORTE_PCR(1) = 0 & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.D0  
        LDR.W    R0,??DataTable8_10  ;; 0x4004d004
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//  586                     PORTE_PCR(2) = 0 & (PORT_PCR_MUX(4) | PORT_PCR_DSE_MASK);                                          // ESDHC.CLK 
        LDR.W    R0,??DataTable8_11  ;; 0x4004d008
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//  587                     PORTE_PCR(3) = 0 & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.CMD 
        LDR.W    R0,??DataTable8_12  ;; 0x4004d00c
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//  588                     PORTE_PCR(4) = 0 & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.D3  
        LDR.W    R0,??DataTable8_13  ;; 0x4004d010
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//  589                     PORTE_PCR(5) = 0 & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.D2  
        LDR.W    R0,??DataTable8_14  ;; 0x4004d014
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//  590 
//  591                     //设置SDHC模块的波特率
//  592                     SDHC_set_baudrate (CORE_CLOCK_HZ, *param32_ptr);
        LDR      R1,[R4, #+0]
        LDR.W    R0,??DataTable8_22  ;; 0x5b8d800
        BL       SDHC_set_baudrate
//  593 
//  594                     //设置复用引脚功能为SDHC
//  595                     PORTE_PCR(0) = 0xFFFF & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.D1  
        LDR.W    R0,??DataTable8_9  ;; 0x4004d000
        MOVW     R1,#+1091
        STR      R1,[R0, #+0]
//  596                     PORTE_PCR(1) = 0xFFFF & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.D0  
        LDR.W    R0,??DataTable8_10  ;; 0x4004d004
        MOVW     R1,#+1091
        STR      R1,[R0, #+0]
//  597                     PORTE_PCR(2) = 0xFFFF & (PORT_PCR_MUX(4) | PORT_PCR_DSE_MASK);                                          // ESDHC.CLK 
        LDR.W    R0,??DataTable8_11  ;; 0x4004d008
        MOV      R1,#+1088
        STR      R1,[R0, #+0]
//  598                     PORTE_PCR(3) = 0xFFFF & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.CMD 
        LDR.W    R0,??DataTable8_12  ;; 0x4004d00c
        MOVW     R1,#+1091
        STR      R1,[R0, #+0]
//  599                     PORTE_PCR(4) = 0xFFFF & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.D3  
        LDR.W    R0,??DataTable8_13  ;; 0x4004d010
        MOVW     R1,#+1091
        STR      R1,[R0, #+0]
//  600                     PORTE_PCR(5) = 0xFFFF & (PORT_PCR_MUX(4) | PORT_PCR_PS_MASK | PORT_PCR_PE_MASK | PORT_PCR_DSE_MASK);    // ESDHC.D2  
        LDR.W    R0,??DataTable8_14  ;; 0x4004d014
        MOVW     R1,#+1091
        STR      R1,[R0, #+0]
//  601 
//  602                     //使能SDHC模块的时钟
//  603                     SIM_SCGC3 |= SIM_SCGC3_SDHC_MASK;
        LDR.W    R0,??DataTable8_1  ;; 0x40048030
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x20000
        LDR.W    R1,??DataTable8_1  ;; 0x40048030
        STR      R0,[R1, #+0]
        B.N      ??hw_sdhc_ioctl_39
//  604                 }
//  605                 else
//  606                 {
//  607                     result = IO_ERROR_DEVICE_BUSY;
??hw_sdhc_ioctl_41:
        MOVS     R10,#+10
//  608                 }
//  609             }
//  610             break;
??hw_sdhc_ioctl_39:
        B.N      ??hw_sdhc_ioctl_10
//  611         //获取块长度
//  612         case IO_IOCTL_ESDHC_GET_BLOCK_SIZE:
//  613             if (NULL == param32_ptr) 
??hw_sdhc_ioctl_9:
        CMP      R4,#+0
        BNE.N    ??hw_sdhc_ioctl_42
//  614             {
//  615                 result = IO_ERROR_INVALID_PARAMETER;
        MOVS     R10,#+12
        B.N      ??hw_sdhc_ioctl_43
//  616             } 
//  617             else 
//  618             {
//  619                 //获取SDHC模块设置的块的大小
//  620                 *param32_ptr = (SDHC_BLKATTR & SDHC_BLKATTR_BLKSIZE_MASK) >> SDHC_BLKATTR_BLKSIZE_SHIFT;
??hw_sdhc_ioctl_42:
        LDR.W    R0,??DataTable8_5  ;; 0x400b1004
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+19
        LSRS     R0,R0,#+19
        STR      R0,[R4, #+0]
//  621             }       
//  622             break;
??hw_sdhc_ioctl_43:
        B.N      ??hw_sdhc_ioctl_10
//  623         //设定块长度
//  624         case IO_IOCTL_ESDHC_SET_BLOCK_SIZE:
//  625             if (NULL == param32_ptr) 
??hw_sdhc_ioctl_8:
        CMP      R4,#+0
        BNE.N    ??hw_sdhc_ioctl_44
//  626             {
//  627                 result = IO_ERROR_INVALID_PARAMETER;
        MOVS     R10,#+12
        B.N      ??hw_sdhc_ioctl_45
//  628             } 
//  629             else 
//  630             {
//  631                 //设置SDHC模块处理的块的大小
//  632                 if (! SDHC_is_running())
??hw_sdhc_ioctl_44:
        BL       SDHC_is_running
        CMP      R0,#+0
        BNE.N    ??hw_sdhc_ioctl_46
//  633                 {
//  634                     if (*param32_ptr > 0x0FFF)
        LDR      R0,[R4, #+0]
        CMP      R0,#+4096
        BCC.N    ??hw_sdhc_ioctl_47
//  635                     {
//  636                         result = IO_ERROR_INVALID_PARAMETER;
        MOVS     R10,#+12
        B.N      ??hw_sdhc_ioctl_45
//  637                     }
//  638                     else
//  639                     {
//  640                         SDHC_BLKATTR &= (~ SDHC_BLKATTR_BLKSIZE_MASK); 
??hw_sdhc_ioctl_47:
        LDR.W    R0,??DataTable8_5  ;; 0x400b1004
        LDR      R0,[R0, #+0]
        LSRS     R0,R0,#+13
        LSLS     R0,R0,#+13
        LDR.W    R1,??DataTable8_5  ;; 0x400b1004
        STR      R0,[R1, #+0]
//  641                         SDHC_BLKATTR |= SDHC_BLKATTR_BLKSIZE(*param32_ptr);
        LDR.W    R0,??DataTable8_5  ;; 0x400b1004
        LDR      R0,[R0, #+0]
        LDR      R1,[R4, #+0]
        LSLS     R1,R1,#+19
        LSRS     R1,R1,#+19
        ORRS     R0,R1,R0
        LDR.W    R1,??DataTable8_5  ;; 0x400b1004
        STR      R0,[R1, #+0]
        B.N      ??hw_sdhc_ioctl_45
//  642                     }
//  643                 }
//  644                 else
//  645                 {
//  646                     result = IO_ERROR_DEVICE_BUSY;
??hw_sdhc_ioctl_46:
        MOVS     R10,#+10
//  647                 }
//  648             }       
//  649             break;
??hw_sdhc_ioctl_45:
        B.N      ??hw_sdhc_ioctl_10
//  650         //获取卡通信总线位宽
//  651         case IO_IOCTL_ESDHC_GET_BUS_WIDTH:
//  652             if (NULL == param32_ptr) 
??hw_sdhc_ioctl_7:
        CMP      R4,#+0
        BNE.N    ??hw_sdhc_ioctl_48
//  653             {
//  654                 result = IO_ERROR_INVALID_PARAMETER;
        MOVS     R10,#+12
        B.N      ??hw_sdhc_ioctl_49
//  655             } 
//  656             else 
//  657             {
//  658                 //获取当前配置的SDHC模块的总线宽度
//  659                 val = (SDHC_PROCTL & SDHC_PROCTL_DTW_MASK) >> SDHC_PROCTL_DTW_SHIFT;
??hw_sdhc_ioctl_48:
        LDR.W    R0,??DataTable8_6  ;; 0x400b1028
        LDR      R0,[R0, #+0]
        UBFX     R9,R0,#+1,#+2
//  660                 if (ESDHC_PROCTL_DTW_1BIT == val)
        CMP      R9,#+0
        BNE.N    ??hw_sdhc_ioctl_50
//  661                 {
//  662                     *param32_ptr = ESDHC_BUS_WIDTH_1BIT;
        MOVS     R0,#+0
        STR      R0,[R4, #+0]
        B.N      ??hw_sdhc_ioctl_49
//  663                 }
//  664                 else if (ESDHC_PROCTL_DTW_4BIT == val)
??hw_sdhc_ioctl_50:
        CMP      R9,#+1
        BNE.N    ??hw_sdhc_ioctl_51
//  665                 {
//  666                     *param32_ptr = ESDHC_BUS_WIDTH_4BIT;
        MOVS     R0,#+1
        STR      R0,[R4, #+0]
        B.N      ??hw_sdhc_ioctl_49
//  667                 }
//  668                 else if (ESDHC_PROCTL_DTW_8BIT == val)
??hw_sdhc_ioctl_51:
        CMP      R9,#+16
        BNE.N    ??hw_sdhc_ioctl_52
//  669                 {
//  670                     *param32_ptr = ESDHC_BUS_WIDTH_8BIT;
        MOVS     R0,#+2
        STR      R0,[R4, #+0]
        B.N      ??hw_sdhc_ioctl_49
//  671                 }
//  672                 else
//  673                 {
//  674                     result = ESDHC_ERROR_INVALID_BUS_WIDTH; 
??hw_sdhc_ioctl_52:
        MOVS     R10,#+5
//  675                 }
//  676             }       
//  677             break;
??hw_sdhc_ioctl_49:
        B.N      ??hw_sdhc_ioctl_10
//  678         //设定卡通信总线位宽
//  679         case IO_IOCTL_ESDHC_SET_BUS_WIDTH:
//  680             if (NULL == param32_ptr) 
??hw_sdhc_ioctl_6:
        CMP      R4,#+0
        BNE.N    ??hw_sdhc_ioctl_53
//  681             {
//  682                 result = IO_ERROR_INVALID_PARAMETER;
        MOVS     R10,#+12
        B.N      ??hw_sdhc_ioctl_54
//  683             } 
//  684             else 
//  685             {
//  686             	//设置SDHC模块的总线宽度
//  687                 if (! SDHC_is_running())
??hw_sdhc_ioctl_53:
        BL       SDHC_is_running
        CMP      R0,#+0
        BNE.N    ??hw_sdhc_ioctl_55
//  688                 {
//  689                     if (ESDHC_BUS_WIDTH_1BIT == *param32_ptr)
        LDR      R0,[R4, #+0]
        CMP      R0,#+0
        BNE.N    ??hw_sdhc_ioctl_56
//  690                     {
//  691                         SDHC_PROCTL &= (~ SDHC_PROCTL_DTW_MASK);
        LDR.N    R0,??DataTable8_6  ;; 0x400b1028
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x6
        LDR.N    R1,??DataTable8_6  ;; 0x400b1028
        STR      R0,[R1, #+0]
//  692                         SDHC_PROCTL |= SDHC_PROCTL_DTW(ESDHC_PROCTL_DTW_1BIT);
        LDR.N    R0,??DataTable8_6  ;; 0x400b1028
        LDR.N    R1,??DataTable8_6  ;; 0x400b1028
        LDR      R1,[R1, #+0]
        STR      R1,[R0, #+0]
        B.N      ??hw_sdhc_ioctl_54
//  693                     }
//  694                     else if (ESDHC_BUS_WIDTH_4BIT == *param32_ptr)
??hw_sdhc_ioctl_56:
        LDR      R0,[R4, #+0]
        CMP      R0,#+1
        BNE.N    ??hw_sdhc_ioctl_57
//  695                     {
//  696                         SDHC_PROCTL &= (~ SDHC_PROCTL_DTW_MASK);
        LDR.N    R0,??DataTable8_6  ;; 0x400b1028
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x6
        LDR.N    R1,??DataTable8_6  ;; 0x400b1028
        STR      R0,[R1, #+0]
//  697                         SDHC_PROCTL |= SDHC_PROCTL_DTW(ESDHC_PROCTL_DTW_4BIT);
        LDR.N    R0,??DataTable8_6  ;; 0x400b1028
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x2
        LDR.N    R1,??DataTable8_6  ;; 0x400b1028
        STR      R0,[R1, #+0]
        B.N      ??hw_sdhc_ioctl_54
//  698                     }
//  699                     else if (ESDHC_BUS_WIDTH_8BIT == *param32_ptr)
??hw_sdhc_ioctl_57:
        LDR      R0,[R4, #+0]
        CMP      R0,#+2
        BNE.N    ??hw_sdhc_ioctl_58
//  700                     {
//  701                         SDHC_PROCTL &= (~ SDHC_PROCTL_DTW_MASK);
        LDR.N    R0,??DataTable8_6  ;; 0x400b1028
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x6
        LDR.N    R1,??DataTable8_6  ;; 0x400b1028
        STR      R0,[R1, #+0]
//  702                         SDHC_PROCTL |= SDHC_PROCTL_DTW(ESDHC_PROCTL_DTW_8BIT);
        LDR.N    R0,??DataTable8_6  ;; 0x400b1028
        LDR.N    R1,??DataTable8_6  ;; 0x400b1028
        LDR      R1,[R1, #+0]
        STR      R1,[R0, #+0]
        B.N      ??hw_sdhc_ioctl_54
//  703                     }
//  704                     else
//  705                     {
//  706                         result = ESDHC_ERROR_INVALID_BUS_WIDTH; 
??hw_sdhc_ioctl_58:
        MOVS     R10,#+5
        B.N      ??hw_sdhc_ioctl_54
//  707                     }
//  708                 }
//  709                 else
//  710                 {
//  711                     result = IO_ERROR_DEVICE_BUSY;
??hw_sdhc_ioctl_55:
        MOVS     R10,#+10
//  712                 }
//  713             }       
//  714             break;
??hw_sdhc_ioctl_54:
        B.N      ??hw_sdhc_ioctl_10
//  715         //获取卡当前状态
//  716         case IO_IOCTL_ESDHC_GET_CARD:
//  717             if (NULL == param32_ptr) 
??hw_sdhc_ioctl_2:
        CMP      R4,#+0
        BNE.N    ??hw_sdhc_ioctl_59
//  718             {
//  719                 result = IO_ERROR_INVALID_PARAMETER;
        MOVS     R10,#+12
        B.N      ??hw_sdhc_ioctl_60
//  720             } 
//  721             else 
//  722             {
//  723                 //等待80个时钟
//  724                 SDHC_SYSCTL |= SDHC_SYSCTL_INITA_MASK;
??hw_sdhc_ioctl_59:
        LDR.N    R0,??DataTable8_2  ;; 0x400b102c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8000000
        LDR.N    R1,??DataTable8_2  ;; 0x400b102c
        STR      R0,[R1, #+0]
//  725                 while (SDHC_SYSCTL & SDHC_SYSCTL_INITA_MASK){};
??hw_sdhc_ioctl_61:
        LDR.N    R0,??DataTable8_2  ;; 0x400b102c
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+4
        BMI.N    ??hw_sdhc_ioctl_61
//  726                     
//  727                 //读取SD卡返回的状态
//  728                 if (SDHC_IRQSTAT & SDHC_IRQSTAT_CRM_MASK)
        LDR.N    R0,??DataTable8_15  ;; 0x400b1030
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??hw_sdhc_ioctl_62
//  729                 {
//  730                     SDHC_IRQSTAT |= SDHC_IRQSTAT_CRM_MASK;
        LDR.N    R0,??DataTable8_15  ;; 0x400b1030
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.N    R1,??DataTable8_15  ;; 0x400b1030
        STR      R0,[R1, #+0]
//  731                     SDHC_Card.CARD_TYPE = ESDHC_CARD_NONE;
        LDR.N    R0,??DataTable8
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//  732                 }
//  733                 if (SDHC_PRSSTAT & SDHC_PRSSTAT_CINS_MASK)
??hw_sdhc_ioctl_62:
        LDR.N    R0,??DataTable8_8  ;; 0x400b1024
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+15
        BPL.N    ??hw_sdhc_ioctl_63
//  734                 {
//  735                     if (ESDHC_CARD_NONE == SDHC_Card.CARD_TYPE)
        LDR.N    R0,??DataTable8
        LDRB     R0,[R0, #+0]
        CMP      R0,#+0
        BNE.N    ??hw_sdhc_ioctl_64
//  736                     {
//  737                     	SDHC_Card.CARD_TYPE = ESDHC_CARD_UNKNOWN;
        LDR.N    R0,??DataTable8
        MOVS     R1,#+1
        STRB     R1,[R0, #+0]
        B.N      ??hw_sdhc_ioctl_64
//  738                     }
//  739                 }
//  740                 else
//  741                 {
//  742                 	SDHC_Card.CARD_TYPE = ESDHC_CARD_NONE;
??hw_sdhc_ioctl_63:
        LDR.N    R0,??DataTable8
        MOVS     R1,#+0
        STRB     R1,[R0, #+0]
//  743                 }
//  744                 *param32_ptr = SDHC_Card.CARD_TYPE;
??hw_sdhc_ioctl_64:
        LDR.N    R0,??DataTable8
        LDRB     R0,[R0, #+0]
        STR      R0,[R4, #+0]
//  745             }
//  746             break;
??hw_sdhc_ioctl_60:
        B.N      ??hw_sdhc_ioctl_10
//  747         default:
//  748             result = IO_ERROR_INVALID_IOCTL_CMD;
??hw_sdhc_ioctl_1:
        MOVS     R10,#+9
//  749             break;
//  750     }
//  751     return result;
??hw_sdhc_ioctl_10:
        MOV      R0,R10
        ADD      SP,SP,#+32
        POP      {R4-R10,PC}      ;; return
//  752 }
//  753 
//  754 
//  755 //=========================================================================
//  756 //函数名称：SDHC_set_baudrate                                                        
//  757 //功能概要：设置SDHC模块的时钟。                                                
//  758 //参数说明：clock:系统时钟                                               
//  759 //         baudrate：波特率                                 
//  760 //函数返回：无                                                               
//  761 //=========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  762 static void SDHC_set_baudrate(uint32 clock,uint32 baudrate)
//  763 {
SDHC_set_baudrate:
        PUSH     {R4-R7}
//  764 	uint32 i, pres, div, min, minpres = 0x80, mindiv = 0x0F;
        MOVS     R2,#+128
        MOVS     R3,#+15
//  765 	int32  val;
//  766 
//  767     //找到相近的分频因子
//  768     min = (uint32)-1;
        MOVS     R6,#-1
//  769     for (pres = 2; pres <= 256; pres <<= 1) 
        MOVS     R4,#+2
        B.N      ??SDHC_set_baudrate_0
//  770     {
//  771         for (div = 1; div <= 16; div++) 
//  772         {
//  773             val = pres * div * baudrate - clock;
??SDHC_set_baudrate_1:
        MUL      R7,R5,R4
        MULS     R7,R1,R7
        SUBS     R7,R7,R0
//  774             if (val >= 0)
        CMP      R7,#+0
        BMI.N    ??SDHC_set_baudrate_2
//  775             {
//  776                 if (min > val) 
        CMP      R7,R6
        BCS.N    ??SDHC_set_baudrate_2
//  777                 {
//  778                     min = val;
        MOVS     R6,R7
//  779                     minpres = pres;
        MOVS     R2,R4
//  780                     mindiv = div;
        MOVS     R3,R5
//  781                 }
//  782             }
//  783         }
??SDHC_set_baudrate_2:
        ADDS     R5,R5,#+1
??SDHC_set_baudrate_3:
        CMP      R5,#+17
        BCC.N    ??SDHC_set_baudrate_1
        LSLS     R4,R4,#+1
??SDHC_set_baudrate_0:
        CMP      R4,#+256
        BHI.N    ??SDHC_set_baudrate_4
        MOVS     R5,#+1
        B.N      ??SDHC_set_baudrate_3
//  784     }
//  785 
//  786     //禁止SDHC模块时钟
//  787     SDHC_SYSCTL &= (~ SDHC_SYSCTL_SDCLKEN_MASK);
??SDHC_set_baudrate_4:
        LDR.N    R0,??DataTable8_2  ;; 0x400b102c
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x8
        LDR.N    R1,??DataTable8_2  ;; 0x400b102c
        STR      R0,[R1, #+0]
//  788 
//  789     //修改分频因子
//  790     div = SDHC_SYSCTL & (~ (SDHC_SYSCTL_DTOCV_MASK | SDHC_SYSCTL_SDCLKFS_MASK | SDHC_SYSCTL_DVS_MASK));
        LDR.N    R0,??DataTable8_2  ;; 0x400b102c
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable8_26  ;; 0xfff0000f
        ANDS     R5,R1,R0
//  791     SDHC_SYSCTL = div | (SDHC_SYSCTL_DTOCV(0x0E) | SDHC_SYSCTL_SDCLKFS(minpres >> 1) | SDHC_SYSCTL_DVS(mindiv - 1));
        LSLS     R0,R2,#+7
        ANDS     R0,R0,#0xFF00
        ORRS     R0,R0,R5
        SUBS     R1,R3,#+1
        LSLS     R1,R1,#+4
        ANDS     R1,R1,#0xF0
        ORRS     R0,R1,R0
        ORRS     R0,R0,#0xE0000
        LDR.N    R1,??DataTable8_2  ;; 0x400b102c
        STR      R0,[R1, #+0]
//  792 
//  793     //等在时钟稳定
//  794     while (0 == (SDHC_PRSSTAT & SDHC_PRSSTAT_SDSTB_MASK))
??SDHC_set_baudrate_5:
        LDR.N    R0,??DataTable8_8  ;; 0x400b1024
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+28
        BMI.N    ??SDHC_set_baudrate_6
//  795     {
//  796 		for(i = 0;i < 200000;i++)
        MOVS     R0,#+0
??SDHC_set_baudrate_7:
        LDR.N    R1,??DataTable8_27  ;; 0x30d40
        CMP      R0,R1
        BCS.N    ??SDHC_set_baudrate_5
        ADDS     R0,R0,#+1
        B.N      ??SDHC_set_baudrate_7
//  797 		{
//  798 		}
//  799     };
//  800 
//  801     //使能SDHC模块时钟
//  802     SDHC_SYSCTL |= SDHC_SYSCTL_SDCLKEN_MASK;
??SDHC_set_baudrate_6:
        LDR.N    R0,??DataTable8_2  ;; 0x400b102c
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x8
        LDR.N    R1,??DataTable8_2  ;; 0x400b102c
        STR      R0,[R1, #+0]
//  803     SDHC_IRQSTAT |= SDHC_IRQSTAT_DTOE_MASK;
        LDR.N    R0,??DataTable8_15  ;; 0x400b1030
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x100000
        LDR.N    R1,??DataTable8_15  ;; 0x400b1030
        STR      R0,[R1, #+0]
//  804 }
        POP      {R4-R7}
        BX       LR               ;; return
//  805 
//  806 //=========================================================================
//  807 //函数名称：SDHC_is_running                                                        
//  808 //功能概要：检测SDHC模块是否忙                                                
//  809 //参数说明：无                              
//  810 //函数返回：1：正忙;0：其他。                                                               
//  811 //=========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  812 static uint8 SDHC_is_running(void)
//  813 {
//  814     return (0 != (SDHC_PRSSTAT & (SDHC_PRSSTAT_RTA_MASK | SDHC_PRSSTAT_WTA_MASK | SDHC_PRSSTAT_DLA_MASK | SDHC_PRSSTAT_CDIHB_MASK | SDHC_PRSSTAT_CIHB_MASK)));
SDHC_is_running:
        LDR.N    R0,??DataTable8_8  ;; 0x400b1024
        LDR      R0,[R0, #+0]
        MOVW     R1,#+775
        TST      R0,R1
        BEQ.N    ??SDHC_is_running_0
        MOVS     R0,#+1
        B.N      ??SDHC_is_running_1
??SDHC_is_running_0:
        MOVS     R0,#+0
??SDHC_is_running_1:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BX       LR               ;; return
//  815 }   
//  816 
//  817 //=========================================================================
//  818 //函数名称：SDHC_status_wait                                                        
//  819 //功能概要：等待中断标志位置位                                                
//  820 //参数说明：mask：待不断的标志位掩码                              
//  821 //函数返回：返回传入的数                                                              
//  822 //=========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  823 static uint32 SDHC_status_wait(uint32 mask)
//  824 {
//  825     uint32	result;
//  826     do
//  827     {
//  828         result = SDHC_IRQSTAT & mask;
SDHC_status_wait:
??SDHC_status_wait_0:
        LDR.N    R1,??DataTable8_15  ;; 0x400b1030
        LDR      R1,[R1, #+0]
        ANDS     R1,R0,R1
//  829     } 
//  830     while (0 == result);
        CMP      R1,#+0
        BEQ.N    ??SDHC_status_wait_0
//  831     return result;
        MOVS     R0,R1
        BX       LR               ;; return
//  832 }
//  833 
//  834 //=========================================================================
//  835 //函数名称：SDHC_send_command                                                        
//  836 //功能概要：发送命令                                                
//  837 //参数说明：command：命令结构体指针                              
//  838 //函数返回：0：成功，1：错误，-1：超时。                                                              
//  839 //=========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  840 static uint32 SDHC_send_command (ESDHC_COMMAND_STRUCT_PTR command)
//  841 {
SDHC_send_command:
        PUSH     {R3-R5,LR}
        MOVS     R4,R0
//  842     uint32	xfertyp;//Transfer Type Register (SDHC_XFERTYP)
//  843     
//  844     //检查和配置命令
//  845     xfertyp = ESDHC_COMMAND_XFERTYP[command->COMMAND & 0x3F];
        LDRB     R0,[R4, #+0]
        ANDS     R0,R0,#0x3F
        ADR.W    R1,ESDHC_COMMAND_XFERTYP
        LDR      R5,[R1, R0, LSL #+2]
//  846     if ((0 == xfertyp) && (0 != command->COMMAND))
        CMP      R5,#+0
        BNE.N    ??SDHC_send_command_0
        LDRB     R0,[R4, #+0]
        CMP      R0,#+0
        BEQ.N    ??SDHC_send_command_0
//  847     {
//  848         return 1;
        MOVS     R0,#+1
        B.N      ??SDHC_send_command_1
//  849     }
//  850 
//  851     //卡移除检测
//  852     SDHC_IRQSTAT |= SDHC_IRQSTAT_CRM_MASK;
??SDHC_send_command_0:
        LDR.N    R0,??DataTable8_15  ;; 0x400b1030
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x80
        LDR.N    R1,??DataTable8_15  ;; 0x400b1030
        STR      R0,[R1, #+0]
//  853 
//  854     //等待CMD通道空闲
//  855     while (SDHC_PRSSTAT & SDHC_PRSSTAT_CIHB_MASK){};
??SDHC_send_command_2:
        LDR.N    R0,??DataTable8_8  ;; 0x400b1024
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+31
        BMI.N    ??SDHC_send_command_2
//  856 
//  857     //设置传输类型寄存器参数
//  858     //写命令参数寄存器(Command Argument Register，SDHC_CMDARG)
//  859     SDHC_CMDARG = command->ARGUMENT;
        LDR      R0,[R4, #+4]
        LDR.N    R1,??DataTable8_28  ;; 0x400b1008
        STR      R0,[R1, #+0]
//  860     //清除XFERTYP寄存器的命令类型域
//  861     xfertyp &= (~ SDHC_XFERTYP_CMDTYP_MASK);
        BICS     R5,R5,#0xC00000
//  862     //设置XFERTYP寄存器的命令类型域
//  863     xfertyp |= SDHC_XFERTYP_CMDTYP(command->TYPE);
        LDRB     R0,[R4, #+1]
        LSLS     R0,R0,#+22
        ANDS     R0,R0,#0xC00000
        ORRS     R5,R0,R5
//  864     //如果为恢复类型
//  865     if (ESDHC_TYPE_RESUME == command->TYPE)
        LDRB     R0,[R4, #+1]
        CMP      R0,#+2
        BNE.N    ??SDHC_send_command_3
//  866     {
//  867     	//如果命令类型为恢复CMD52写功能选择，则置数据传送选择位。
//  868         xfertyp |= SDHC_XFERTYP_DPSEL_MASK;
        ORRS     R5,R5,#0x200000
//  869     }
//  870     //如果是切换忙类型
//  871     if (ESDHC_TYPE_SWITCH_BUSY == command->TYPE)
??SDHC_send_command_3:
        LDRB     R0,[R4, #+1]
        CMP      R0,#+4
        BNE.N    ??SDHC_send_command_4
//  872     {
//  873     	
//  874         if ((xfertyp & SDHC_XFERTYP_RSPTYP_MASK) == SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48))
        ANDS     R0,R5,#0x30000
        CMP      R0,#+131072
        BNE.N    ??SDHC_send_command_5
//  875         {
//  876             xfertyp &= (~ SDHC_XFERTYP_RSPTYP_MASK);
        BICS     R5,R5,#0x30000
//  877             xfertyp |= SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48BUSY);
        ORRS     R5,R5,#0x30000
        B.N      ??SDHC_send_command_4
//  878         }
//  879         else
//  880         {
//  881             xfertyp &= (~ SDHC_XFERTYP_RSPTYP_MASK);
??SDHC_send_command_5:
        BICS     R5,R5,#0x30000
//  882             xfertyp |= SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48);
        ORRS     R5,R5,#0x20000
//  883         }
//  884     }
//  885     //清除块数
//  886     SDHC_BLKATTR &= (~ SDHC_BLKATTR_BLKCNT_MASK);
??SDHC_send_command_4:
        LDR.N    R0,??DataTable8_5  ;; 0x400b1004
        LDR      R0,[R0, #+0]
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        LDR.N    R1,??DataTable8_5  ;; 0x400b1004
        STR      R0,[R1, #+0]
//  887     //块数判断
//  888     if (0 != command->BLOCKS)
        LDR      R0,[R4, #+12]
        CMP      R0,#+0
        BEQ.N    ??SDHC_send_command_6
//  889     {
//  890     	//块不为0
//  891         if ((xfertyp & SDHC_XFERTYP_RSPTYP_MASK) != SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_48BUSY))
        ANDS     R0,R5,#0x30000
        CMP      R0,#+196608
        BEQ.N    ??SDHC_send_command_7
//  892         {
//  893             xfertyp |= SDHC_XFERTYP_DPSEL_MASK;
        ORRS     R5,R5,#0x200000
//  894         }
//  895         if (command->READ)
??SDHC_send_command_7:
        LDRB     R0,[R4, #+8]
        CMP      R0,#+0
        BEQ.N    ??SDHC_send_command_8
//  896         {
//  897             xfertyp |= SDHC_XFERTYP_DTDSEL_MASK;    
        ORRS     R5,R5,#0x10
//  898         }
//  899         if (command->BLOCKS > 1)
??SDHC_send_command_8:
        LDR      R0,[R4, #+12]
        CMP      R0,#+2
        BCC.N    ??SDHC_send_command_9
//  900         {
//  901             xfertyp |= SDHC_XFERTYP_MSBSEL_MASK;    
        ORRS     R5,R5,#0x20
//  902         }
//  903         if ((uint32)-1 != command->BLOCKS)
??SDHC_send_command_9:
        LDR      R0,[R4, #+12]
        CMN      R0,#+1
        BEQ.N    ??SDHC_send_command_6
//  904         {
//  905         	SDHC_BLKATTR |= SDHC_BLKATTR_BLKCNT(command->BLOCKS);
        LDR.N    R0,??DataTable8_5  ;; 0x400b1004
        LDR      R0,[R0, #+0]
        LDR      R1,[R4, #+12]
        ORRS     R0,R0,R1, LSL #+16
        LDR.N    R1,??DataTable8_5  ;; 0x400b1004
        STR      R0,[R1, #+0]
//  906             xfertyp |= SDHC_XFERTYP_BCEN_MASK;
        ORRS     R5,R5,#0x2
//  907         }
//  908     }
//  909 
//  910     //执行命令
//  911     SDHC_DSADDR = 0;
??SDHC_send_command_6:
        LDR.N    R0,??DataTable8_29  ;; 0x400b1000
        MOVS     R1,#+0
        STR      R1,[R0, #+0]
//  912     SDHC_XFERTYP = xfertyp;
        LDR.N    R0,??DataTable8_30  ;; 0x400b100c
        STR      R5,[R0, #+0]
//  913     
//  914     //等待状态寄存器置位
//  915     if (SDHC_status_wait (SDHC_IRQSTAT_CIE_MASK | SDHC_IRQSTAT_CEBE_MASK | SDHC_IRQSTAT_CCE_MASK | SDHC_IRQSTAT_CC_MASK) != SDHC_IRQSTAT_CC_MASK)
        LDR.N    R0,??DataTable8_31  ;; 0xe0001
        BL       SDHC_status_wait
        CMP      R0,#+1
        BEQ.N    ??SDHC_send_command_10
//  916     {
//  917     	SDHC_IRQSTAT |= SDHC_IRQSTAT_CTOE_MASK | SDHC_IRQSTAT_CIE_MASK | SDHC_IRQSTAT_CEBE_MASK | SDHC_IRQSTAT_CCE_MASK | SDHC_IRQSTAT_CC_MASK;
        LDR.N    R0,??DataTable8_15  ;; 0x400b1030
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable8_32  ;; 0xf0001
        ORRS     R0,R1,R0
        LDR.N    R1,??DataTable8_15  ;; 0x400b1030
        STR      R0,[R1, #+0]
//  918         return 1;
        MOVS     R0,#+1
        B.N      ??SDHC_send_command_1
//  919     }
//  920 
//  921     //检测卡是否被移除
//  922     if (SDHC_IRQSTAT & SDHC_IRQSTAT_CRM_MASK)
??SDHC_send_command_10:
        LDR.N    R0,??DataTable8_15  ;; 0x400b1030
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+24
        BPL.N    ??SDHC_send_command_11
//  923     {
//  924     	SDHC_IRQSTAT |= SDHC_IRQSTAT_CTOE_MASK | SDHC_IRQSTAT_CC_MASK;
        LDR.N    R0,??DataTable8_15  ;; 0x400b1030
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x10001
        LDR.N    R1,??DataTable8_15  ;; 0x400b1030
        STR      R0,[R1, #+0]
//  925         return 1;
        MOVS     R0,#+1
        B.N      ??SDHC_send_command_1
//  926     }
//  927 
//  928     //检查命令是否超时
//  929     if (SDHC_IRQSTAT & SDHC_IRQSTAT_CTOE_MASK)
??SDHC_send_command_11:
        LDR.N    R0,??DataTable8_15  ;; 0x400b1030
        LDR      R0,[R0, #+0]
        LSLS     R0,R0,#+15
        BPL.N    ??SDHC_send_command_12
//  930     {
//  931     	SDHC_IRQSTAT |= SDHC_IRQSTAT_CTOE_MASK | SDHC_IRQSTAT_CC_MASK;
        LDR.N    R0,??DataTable8_15  ;; 0x400b1030
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x10001
        LDR.N    R1,??DataTable8_15  ;; 0x400b1030
        STR      R0,[R1, #+0]
//  932         return -1;
        MOVS     R0,#-1
        B.N      ??SDHC_send_command_1
//  933     }
//  934     if ((xfertyp & SDHC_XFERTYP_RSPTYP_MASK) != SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_NO))
??SDHC_send_command_12:
        TST      R5,#0x30000
        BEQ.N    ??SDHC_send_command_13
//  935     {
//  936         command->RESPONSE[0] = SDHC_CMDRSP(0);
        LDR.N    R0,??DataTable8_33  ;; 0x400b1010
        LDR      R0,[R0, #+0]
        STR      R0,[R4, #+16]
//  937         if ((xfertyp & SDHC_XFERTYP_RSPTYP_MASK) == SDHC_XFERTYP_RSPTYP(ESDHC_XFERTYP_RSPTYP_136))
        ANDS     R0,R5,#0x30000
        CMP      R0,#+65536
        BNE.N    ??SDHC_send_command_13
//  938         {
//  939             command->RESPONSE[1] = SDHC_CMDRSP(1);
        LDR.N    R0,??DataTable8_34  ;; 0x400b1014
        LDR      R0,[R0, #+0]
        STR      R0,[R4, #+20]
//  940             command->RESPONSE[2] = SDHC_CMDRSP(2);
        LDR.N    R0,??DataTable8_35  ;; 0x400b1018
        LDR      R0,[R0, #+0]
        STR      R0,[R4, #+24]
//  941             command->RESPONSE[3] = SDHC_CMDRSP(3);
        LDR.N    R0,??DataTable8_36  ;; 0x400b101c
        LDR      R0,[R0, #+0]
        STR      R0,[R4, #+28]
//  942         }
//  943     }
//  944     
//  945     SDHC_IRQSTAT |= SDHC_IRQSTAT_CC_MASK;
??SDHC_send_command_13:
        LDR.N    R0,??DataTable8_15  ;; 0x400b1030
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x1
        LDR.N    R1,??DataTable8_15  ;; 0x400b1030
        STR      R0,[R1, #+0]
//  946 
//  947     return 0;
        MOVS     R0,#+0
??SDHC_send_command_1:
        POP      {R1,R4,R5,PC}    ;; return
//  948 }

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8:
        DC32     SDHC_Card

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_1:
        DC32     0x40048030

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_2:
        DC32     0x400b102c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_3:
        DC32     0x1008000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_4:
        DC32     0x400b10c0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_5:
        DC32     0x400b1004

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_6:
        DC32     0x400b1028

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_7:
        DC32     0x400b1044

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_8:
        DC32     0x400b1024

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_9:
        DC32     0x4004d000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_10:
        DC32     0x4004d004

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_11:
        DC32     0x4004d008

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_12:
        DC32     0x4004d00c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_13:
        DC32     0x4004d010

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_14:
        DC32     0x4004d014

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_15:
        DC32     0x400b1030

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_16:
        DC32     0x400b1034

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_17:
        DC32     0x7f00b3

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_18:
        DC32     0x400b1020

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_19:
        DC32     0x700020

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_20:
        DC32     0x700010

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_21:
        DC32     0x17d7840

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_22:
        DC32     0x5b8d800

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_23:
        DC32     0x1e8480

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_24:
        DC32     0x7a120

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_25:
        DC32     0x40300000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_26:
        DC32     0xfff0000f

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_27:
        DC32     0x30d40

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_28:
        DC32     0x400b1008

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_29:
        DC32     0x400b1000

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_30:
        DC32     0x400b100c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_31:
        DC32     0xe0001

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_32:
        DC32     0xf0001

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_33:
        DC32     0x400b1010

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_34:
        DC32     0x400b1014

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_35:
        DC32     0x400b1018

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable8_36:
        DC32     0x400b101c

        SECTION `.text`:CODE:NOROOT(2)
        DATA
ESDHC_COMMAND_XFERTYP:
        ; Initializer data, 256 bytes
        DC32 0, 16777216, 34144256, 52035584, 67108864, 84017152, 102367232, 119209984, 135921664, 151584768
        DC32 168361984, 186253312, 215678976, 219807744, 0, 251658240, 270139392, 286916608, 303693824, 0
        DC32 337248256, 0, 370802688, 387579904, 404357120, 421134336, 437911552, 454688768, 471531520, 488308736
        DC32 505020416, 0, 538574848, 555352064, 572129280, 588906496, 605683712, 622460928, 639303680, 654442496
        DC32 672792576, 687996928, 706412544, 0, 0, 0, 0, 0, 0, 0
        DC32 0, 857341952, 874119168, 890896384, 0, 924450816, 941293568, 0, 0, 0
        DC32 1008402432, 1025179648, 0, 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
//  949 
// 
//    24 bytes in section .bss
// 2 664 bytes in section .text
// 
// 2 664 bytes of CODE memory
//    24 bytes of DATA memory
//
//Errors: none
//Warnings: 5
