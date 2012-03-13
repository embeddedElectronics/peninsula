///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      04/Mar/2012  11:29:59 /
// IAR ANSI C/C++ Compiler V6.10.1.22143/W32 EVALUATION for ARM               /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\gpio /
//                    \diskio.c                                               /
//    Command line =  "F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\gpi /
//                    o\diskio.c" -D IAR -D TWR_K60N512 -lCN "F:\My           /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\RAM_32KB /
//                    \List\" -lB "F:\My Works\K60\Kinetis512\kinetis-sc\buil /
//                    d\iar\gpio\RAM_32KB\List\" -o "F:\My                    /
//                    Works\K60\Kinetis512\kinetis-sc\build\iar\gpio\RAM_32KB /
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
//                    M_32KB\List\diskio.s                                    /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME diskio

        EXTERN SDHC_Card
        EXTERN hw_sdhc_ioctl
        EXTERN hw_sdhc_receive_block
        EXTERN hw_sdhc_send_block

        PUBLIC GetCardStat
        PUBLIC SetCardStat
        PUBLIC disk_initialize
        PUBLIC disk_ioctl
        PUBLIC disk_read
        PUBLIC disk_status
        PUBLIC disk_timerproc
        PUBLIC disk_write

// F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\gpio\diskio.c
//    1 //=========================================================================
//    2 // 文件名称：diskio.h
//    3 // 功能概要：diskio构件源文件
//    4 // 版权所有: 苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
//    5 // 版本更新:  2011-12-14     V1.0        diskio构件初始版本
//    6 //           2011-12-20     V1.1        diskio构件优化修改
//    7 //=========================================================================
//    8 #include  "hw_sdhc.h"
//    9 #include  "diskio.h"
//   10 
//   11 //SD卡状态属性访问器

        SECTION `.data`:DATA:REORDER:NOROOT(0)
//   12 static volatile unsigned char Stat   = STA_NOINIT; //保存SD卡状态
Stat:
        DATA
        DC8 1

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   13 uint8 GetCardStat(void) { return Stat; }
GetCardStat:
        LDR.W    R0,??DataTable7
        LDRB     R0,[R0, #+0]
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   14 void SetCardStat(uint8 state) { Stat = state; }
SetCardStat:
        LDR.W    R1,??DataTable7
        STRB     R0,[R1, #+0]
        BX       LR               ;; return
//   15 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   16 static volatile unsigned int  Timer = 0; //读写时间
Timer:
        DS8 4
//   17 
//   18 //=========================================================================
//   19 //函数名称：disk_initialize
//   20 //功能概要：初始化数据盘（只支持数据盘0） 
//   21 //参数说明：drv:设备号
//   22 //函数返回：RES_OK：成功；其它：失败
//   23 //=========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   24 DRESULT disk_initialize (unsigned char drv)
//   25 {
disk_initialize:
        PUSH     {R4,LR}
        SUB      SP,SP,#+40
//   26     uint32  param, c_size, c_size_mult, read_bl_len;
//   27     ESDHC_COMMAND_STRUCT  command;
//   28     SDCARD_STRUCT_PTR     sdcard_ptr = (SDCARD_STRUCT_PTR)&SDHC_Card;
        LDR.W    R4,??DataTable7_1
//   29 
//   30     //检查参数
//   31     if (drv || (NULL == sdcard_ptr)) return RES_PARERR; //仅仅支持设备0
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BNE.N    ??disk_initialize_0
        CMP      R4,#+0
        BNE.N    ??disk_initialize_1
??disk_initialize_0:
        MOVS     R0,#+4
        B.N      ??disk_initialize_2
//   32     //检查卡插入状态
//   33     if (Stat & STA_NODISK) return RES_NOTRDY; //SD卡未插入
??disk_initialize_1:
        LDR.W    R0,??DataTable7
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+30
        BPL.N    ??disk_initialize_3
        MOVS     R0,#+3
        B.N      ??disk_initialize_2
//   34 
//   35     //初始化SD卡设备登记信息
//   36     sdcard_ptr->BITS = ESDHC_BUS_WIDTH_4BIT;//设置位宽为4位
??disk_initialize_3:
        MOVS     R0,#+1
        STR      R0,[R4, #+4]
//   37     sdcard_ptr->SD_TIMEOUT = 0;
        MOVS     R0,#+0
        STR      R0,[R4, #+8]
//   38     sdcard_ptr->NUM_BLOCKS = 0;
        MOVS     R0,#+0
        STR      R0,[R4, #+12]
//   39     sdcard_ptr->ADDRESS    = 0;
        MOVS     R0,#+0
        STR      R0,[R4, #+20]
//   40     sdcard_ptr->SDHC       = FALSE;
        MOVS     R0,#+0
        STRB     R0,[R4, #+16]
//   41     sdcard_ptr->VERSION2   = FALSE;
        MOVS     R0,#+0
        STRB     R0,[R4, #+17]
//   42 
//   43     //检测并初始化SD卡
//   44     if (ESDHC_OK != hw_sdhc_ioctl (IO_IOCTL_ESDHC_INIT, NULL))
        MOVS     R1,#+0
        MOVS     R0,#+1
        BL       hw_sdhc_ioctl
        CMP      R0,#+0
        BEQ.N    ??disk_initialize_4
//   45         return RES_ERROR;
        MOVS     R0,#+1
        B.N      ??disk_initialize_2
//   46 
//   47     //获取SD卡类型
//   48     param = 0;
??disk_initialize_4:
        MOVS     R0,#+0
        STR      R0,[SP, #+0]
//   49     if (ESDHC_OK != hw_sdhc_ioctl (IO_IOCTL_ESDHC_GET_CARD, &param))
        ADD      R1,SP,#+0
        MOVS     R0,#+3
        BL       hw_sdhc_ioctl
        CMP      R0,#+0
        BEQ.N    ??disk_initialize_5
//   50         return RES_ERROR;
        MOVS     R0,#+1
        B.N      ??disk_initialize_2
//   51     if (    (ESDHC_CARD_SD == param) 
//   52          || (ESDHC_CARD_SDHC == param) 
//   53          || (ESDHC_CARD_SDCOMBO == param) 
//   54          || (ESDHC_CARD_SDHCCOMBO == param))
??disk_initialize_5:
        LDR      R0,[SP, #+0]
        CMP      R0,#+2
        BEQ.N    ??disk_initialize_6
        LDR      R0,[SP, #+0]
        CMP      R0,#+3
        BEQ.N    ??disk_initialize_6
        LDR      R0,[SP, #+0]
        CMP      R0,#+5
        BEQ.N    ??disk_initialize_6
        LDR      R0,[SP, #+0]
        CMP      R0,#+6
        BNE.N    ??disk_initialize_7
//   55     {
//   56         if ((ESDHC_CARD_SDHC == param) || (ESDHC_CARD_SDHCCOMBO == param))
??disk_initialize_6:
        LDR      R0,[SP, #+0]
        CMP      R0,#+3
        BEQ.N    ??disk_initialize_8
        LDR      R0,[SP, #+0]
        CMP      R0,#+6
        BNE.N    ??disk_initialize_9
//   57         {
//   58             sdcard_ptr->SDHC = TRUE;
??disk_initialize_8:
        MOVS     R0,#+1
        STRB     R0,[R4, #+16]
//   59         }
//   60     }
//   61     else
//   62         return RES_PARERR;
//   63 
//   64     //SD卡标识
//   65     command.COMMAND  = ESDHC_CMD2;
??disk_initialize_9:
        MOVS     R0,#+2
        STRB     R0,[SP, #+4]
//   66     command.TYPE     = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+5]
//   67     command.ARGUMENT = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+8]
//   68     command.READ     = FALSE;
        MOVS     R0,#+0
        STRB     R0,[SP, #+12]
//   69     command.BLOCKS   = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+16]
//   70     if (ESDHC_OK != hw_sdhc_ioctl (IO_IOCTL_ESDHC_SEND_COMMAND, &command))
        ADD      R1,SP,#+4
        MOVS     R0,#+2
        BL       hw_sdhc_ioctl
        CMP      R0,#+0
        BNE.N    ??disk_initialize_10
//   71         return RES_ERROR;
//   72 
//   73     //获取SD卡地址
//   74     command.COMMAND  = ESDHC_CMD3;
        MOVS     R0,#+3
        STRB     R0,[SP, #+4]
//   75     command.TYPE     = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+5]
//   76     command.ARGUMENT = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+8]
//   77     command.READ     = FALSE;
        MOVS     R0,#+0
        STRB     R0,[SP, #+12]
//   78     command.BLOCKS   = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+16]
//   79     if (ESDHC_OK != hw_sdhc_ioctl (IO_IOCTL_ESDHC_SEND_COMMAND, &command))
        ADD      R1,SP,#+4
        MOVS     R0,#+2
        BL       hw_sdhc_ioctl
        CMP      R0,#+0
        BEQ.N    ??disk_initialize_11
//   80         return RES_ERROR;
        MOVS     R0,#+1
        B.N      ??disk_initialize_2
??disk_initialize_7:
        MOVS     R0,#+4
        B.N      ??disk_initialize_2
??disk_initialize_10:
        MOVS     R0,#+1
        B.N      ??disk_initialize_2
//   81     sdcard_ptr->ADDRESS = command.RESPONSE[0] & 0xFFFF0000;
??disk_initialize_11:
        LDR      R0,[SP, #+20]
        LSRS     R0,R0,#+16
        LSLS     R0,R0,#+16
        STR      R0,[R4, #+20]
//   82     
//   83     //获取SD卡读写属性参数
//   84     command.COMMAND  = ESDHC_CMD9;
        MOVS     R0,#+9
        STRB     R0,[SP, #+4]
//   85     command.TYPE     = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+5]
//   86     command.ARGUMENT = sdcard_ptr->ADDRESS;
        LDR      R0,[R4, #+20]
        STR      R0,[SP, #+8]
//   87     command.READ     = FALSE;
        MOVS     R0,#+0
        STRB     R0,[SP, #+12]
//   88     command.BLOCKS   = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+16]
//   89     if (ESDHC_OK != hw_sdhc_ioctl (IO_IOCTL_ESDHC_SEND_COMMAND, &command))
        ADD      R1,SP,#+4
        MOVS     R0,#+2
        BL       hw_sdhc_ioctl
        CMP      R0,#+0
        BEQ.N    ??disk_initialize_12
//   90         return RES_ERROR;
        MOVS     R0,#+1
        B.N      ??disk_initialize_2
//   91     if (0 == (command.RESPONSE[3] & 0x00C00000))
??disk_initialize_12:
        LDR      R0,[SP, #+32]
        TST      R0,#0xC00000
        BNE.N    ??disk_initialize_13
//   92     {
//   93         read_bl_len = (command.RESPONSE[2] >> 8) & 0x0F;
        LDR      R0,[SP, #+28]
        UBFX     R2,R0,#+8,#+4
//   94         c_size = command.RESPONSE[2] & 0x03;
        LDRB     R0,[SP, #+28]
        ANDS     R0,R0,#0x3
//   95         c_size = (c_size << 10) | (command.RESPONSE[1] >> 22);
        LDR      R1,[SP, #+24]
        LSRS     R1,R1,#+22
        ORRS     R0,R1,R0, LSL #+10
//   96         c_size_mult = (command.RESPONSE[1] >> 7) & 0x07;
        LDR      R1,[SP, #+24]
        UBFX     R1,R1,#+7,#+3
//   97         sdcard_ptr->NUM_BLOCKS = (c_size+1)*(1<<(c_size_mult+2))*(1<<(read_bl_len-9));
        ADDS     R0,R0,#+1
        MOVS     R3,#+1
        ADDS     R1,R1,#+2
        LSLS     R1,R3,R1
        MULS     R0,R1,R0
        MOVS     R1,#+1
        SUBS     R2,R2,#+9
        LSLS     R1,R1,R2
        MULS     R0,R1,R0
        STR      R0,[R4, #+12]
        B.N      ??disk_initialize_14
//   98     }
//   99     else
//  100     {
//  101         sdcard_ptr->VERSION2 = TRUE;
??disk_initialize_13:
        MOVS     R0,#+1
        STRB     R0,[R4, #+17]
//  102         c_size = (command.RESPONSE[1] >> 8) & 0x003FFFFF;
        LDR      R0,[SP, #+24]
        UBFX     R0,R0,#+8,#+22
//  103         sdcard_ptr->NUM_BLOCKS = (c_size + 1) << 10;
        ADDS     R0,R0,#+1
        LSLS     R0,R0,#+10
        STR      R0,[R4, #+12]
//  104     }
//  105 
//  106     //选择SD卡
//  107     command.COMMAND  = ESDHC_CMD7;
??disk_initialize_14:
        MOVS     R0,#+7
        STRB     R0,[SP, #+4]
//  108     command.TYPE     = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+5]
//  109     command.ARGUMENT = sdcard_ptr->ADDRESS;
        LDR      R0,[R4, #+20]
        STR      R0,[SP, #+8]
//  110     command.READ     = FALSE;
        MOVS     R0,#+0
        STRB     R0,[SP, #+12]
//  111     command.BLOCKS   = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+16]
//  112     if (ESDHC_OK != hw_sdhc_ioctl (IO_IOCTL_ESDHC_SEND_COMMAND, &command))
        ADD      R1,SP,#+4
        MOVS     R0,#+2
        BL       hw_sdhc_ioctl
        CMP      R0,#+0
        BEQ.N    ??disk_initialize_15
//  113         return RES_ERROR;
        MOVS     R0,#+1
        B.N      ??disk_initialize_2
//  114 
//  115     //设置块大小
//  116     command.COMMAND  = ESDHC_CMD16;
??disk_initialize_15:
        MOVS     R0,#+16
        STRB     R0,[SP, #+4]
//  117     command.TYPE     = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+5]
//  118     command.ARGUMENT = IO_SDCARD_BLOCK_SIZE;
        MOV      R0,#+512
        STR      R0,[SP, #+8]
//  119     command.READ     = FALSE;
        MOVS     R0,#+0
        STRB     R0,[SP, #+12]
//  120     command.BLOCKS   = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+16]
//  121     if (ESDHC_OK != hw_sdhc_ioctl (IO_IOCTL_ESDHC_SEND_COMMAND, &command))
        ADD      R1,SP,#+4
        MOVS     R0,#+2
        BL       hw_sdhc_ioctl
        CMP      R0,#+0
        BEQ.N    ??disk_initialize_16
//  122         return RES_ERROR;
        MOVS     R0,#+1
        B.N      ??disk_initialize_2
//  123 
//  124     if (ESDHC_BUS_WIDTH_4BIT == sdcard_ptr->BITS)
??disk_initialize_16:
        LDR      R0,[R4, #+4]
        CMP      R0,#+1
        BNE.N    ??disk_initialize_17
//  125     {
//  126         //发送特殊的命令CMD55
//  127         command.COMMAND  = ESDHC_CMD55;
        MOVS     R0,#+55
        STRB     R0,[SP, #+4]
//  128         command.TYPE     = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+5]
//  129         command.ARGUMENT = sdcard_ptr->ADDRESS;
        LDR      R0,[R4, #+20]
        STR      R0,[SP, #+8]
//  130         command.READ     = FALSE;
        MOVS     R0,#+0
        STRB     R0,[SP, #+12]
//  131         command.BLOCKS  = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+16]
//  132         if (ESDHC_OK != hw_sdhc_ioctl (IO_IOCTL_ESDHC_SEND_COMMAND, &command))
        ADD      R1,SP,#+4
        MOVS     R0,#+2
        BL       hw_sdhc_ioctl
        CMP      R0,#+0
        BEQ.N    ??disk_initialize_18
//  133             return RES_ERROR;
        MOVS     R0,#+1
        B.N      ??disk_initialize_2
//  134 
//  135         //设置数据位宽为4位
//  136         command.COMMAND = ESDHC_ACMD6;
??disk_initialize_18:
        MOVS     R0,#+70
        STRB     R0,[SP, #+4]
//  137         command.TYPE = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+5]
//  138         command.ARGUMENT = 2;
        MOVS     R0,#+2
        STR      R0,[SP, #+8]
//  139         command.READ = FALSE;
        MOVS     R0,#+0
        STRB     R0,[SP, #+12]
//  140         command.BLOCKS = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+16]
//  141         if (ESDHC_OK != hw_sdhc_ioctl (IO_IOCTL_ESDHC_SEND_COMMAND, &command))
        ADD      R1,SP,#+4
        MOVS     R0,#+2
        BL       hw_sdhc_ioctl
        CMP      R0,#+0
        BEQ.N    ??disk_initialize_19
//  142             return RES_ERROR;
        MOVS     R0,#+1
        B.N      ??disk_initialize_2
//  143 
//  144         param = ESDHC_BUS_WIDTH_4BIT;
??disk_initialize_19:
        MOVS     R0,#+1
        STR      R0,[SP, #+0]
//  145         if (ESDHC_OK != hw_sdhc_ioctl (IO_IOCTL_ESDHC_SET_BUS_WIDTH, &param))
        ADD      R1,SP,#+0
        MOVS     R0,#+7
        BL       hw_sdhc_ioctl
        CMP      R0,#+0
        BEQ.N    ??disk_initialize_17
//  146             return RES_ERROR;
        MOVS     R0,#+1
        B.N      ??disk_initialize_2
//  147     }
//  148 
//  149     Stat &= ~STA_NOINIT;//清除数据盘状态
??disk_initialize_17:
        LDR.N    R0,??DataTable7
        LDRB     R0,[R0, #+0]
        ANDS     R0,R0,#0xFE
        LDR.N    R1,??DataTable7
        STRB     R0,[R1, #+0]
//  150     
//  151     return RES_OK;
        MOVS     R0,#+0
??disk_initialize_2:
        ADD      SP,SP,#+40
        POP      {R4,PC}          ;; return
//  152 }
//  153 
//  154 //=========================================================================
//  155 //函数名称：disk_read                                                        
//  156 //功能概要：读数据盘扇区                                                
//  157 //参数说明：drv:设备号
//  158 //         buff:用于存储读取的数据的缓存区
//  159 //         sector:起始扇区号
//  160 //         count:扇区数
//  161 //函数返回：RES_OK：成功，其它：失败                                                              
//  162 //=========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  163 DRESULT disk_read(uint8 drv,uint8 *buff,uint32 sector, uint8 count)
//  164 {
disk_read:
        PUSH     {R4,R5,LR}
        SUB      SP,SP,#+36
        MOVS     R4,R1
        MOVS     R5,R3
//  165     ESDHC_COMMAND_STRUCT command;
//  166     SDCARD_STRUCT_PTR    sdcard_ptr = (SDCARD_STRUCT_PTR)&SDHC_Card;
        LDR.N    R1,??DataTable7_1
//  167 	
//  168     //检查参数
//  169     if (drv || !count) return RES_PARERR;
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BNE.N    ??disk_read_0
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R5,#+0
        BNE.N    ??disk_read_1
??disk_read_0:
        MOVS     R0,#+4
        B.N      ??disk_read_2
//  170     if (Stat & STA_NOINIT) return RES_NOTRDY;
??disk_read_1:
        LDR.N    R0,??DataTable7
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+31
        BPL.N    ??disk_read_3
        MOVS     R0,#+3
        B.N      ??disk_read_2
//  171     if ((NULL == buff)) return RES_ERROR;
??disk_read_3:
        CMP      R4,#+0
        BNE.N    ??disk_read_4
        MOVS     R0,#+1
        B.N      ??disk_read_2
//  172 	
//  173     if (!sdcard_ptr->SDHC)
??disk_read_4:
        LDRB     R0,[R1, #+16]
        CMP      R0,#+0
        BNE.N    ??disk_read_5
//  174         //sector *= 512;//扇区号转化为起始地址
//  175         sector = sector << IO_SDCARD_BLOCK_SIZE_POWER;
        LSLS     R2,R2,#+9
//  176 
//  177     if (count == 1)//读单个扇区
??disk_read_5:
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R5,#+1
        BNE.N    ??disk_read_6
//  178     {
//  179         command.COMMAND  = ESDHC_CMD17;
        MOVS     R0,#+17
        STRB     R0,[SP, #+0]
//  180         command.TYPE     = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+1]
//  181         command.ARGUMENT = sector;
        STR      R2,[SP, #+4]
//  182         command.READ     = TRUE;
        MOVS     R0,#+1
        STRB     R0,[SP, #+8]
//  183         command.BLOCKS   = count;	
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        STR      R5,[SP, #+12]
//  184 
//  185         if (ESDHC_OK == hw_sdhc_ioctl (IO_IOCTL_ESDHC_SEND_COMMAND, &command))
        ADD      R1,SP,#+0
        MOVS     R0,#+2
        BL       hw_sdhc_ioctl
        CMP      R0,#+0
        BNE.N    ??disk_read_7
//  186         {
//  187             //if (hw_sdhc_receive_block(buff, 512))
//  188             if (hw_sdhc_receive_block(buff, IO_SDCARD_BLOCK_SIZE))
        MOV      R1,#+512
        MOVS     R0,R4
        BL       hw_sdhc_receive_block
        CMP      R0,#+0
        BEQ.N    ??disk_read_7
//  189                 count = 0;
        MOVS     R5,#+0
        B.N      ??disk_read_7
//  190         }
//  191     }
//  192     else //读多个扇区
//  193     {     
//  194         command.COMMAND  = ESDHC_CMD18;
??disk_read_6:
        MOVS     R0,#+18
        STRB     R0,[SP, #+0]
//  195         command.TYPE     = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+1]
//  196         command.ARGUMENT = sector;
        STR      R2,[SP, #+4]
//  197         command.READ     = TRUE;
        MOVS     R0,#+1
        STRB     R0,[SP, #+8]
//  198         command.BLOCKS   = count;		
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        STR      R5,[SP, #+12]
//  199 
//  200         if (ESDHC_OK == hw_sdhc_ioctl (IO_IOCTL_ESDHC_SEND_COMMAND, &command))
        ADD      R1,SP,#+0
        MOVS     R0,#+2
        BL       hw_sdhc_ioctl
        CMP      R0,#+0
        BNE.N    ??disk_read_7
//  201         {
//  202             if (hw_sdhc_receive_block(buff, IO_SDCARD_BLOCK_SIZE*count))
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        MOV      R0,#+512
        MUL      R1,R0,R5
        MOVS     R0,R4
        BL       hw_sdhc_receive_block
        CMP      R0,#+0
        BEQ.N    ??disk_read_7
//  203                 count = 0;
        MOVS     R5,#+0
//  204         }
//  205     }
//  206 
//  207     return count ? RES_ERROR : RES_OK;
??disk_read_7:
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R5,#+0
        BEQ.N    ??disk_read_8
        MOVS     R0,#+1
        B.N      ??disk_read_9
??disk_read_8:
        MOVS     R0,#+0
??disk_read_9:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
??disk_read_2:
        ADD      SP,SP,#+36
        POP      {R4,R5,PC}       ;; return
//  208 }
//  209 
//  210 //=========================================================================
//  211 //函数名称：disk_write                                                        
//  212 //功能概要：写数据盘扇区                                                
//  213 //参数说明：drv:设备号
//  214 //         buff:待写入SD卡的数据的缓存区首地址
//  215 //         sector:起始扇区号
//  216 //         count:扇区数
//  217 //函数返回：RES_OK：成功，其它：失败                                                              
//  218 //=========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  219 DRESULT disk_write(uint8 drv,const uint8 *buff,uint32 sector,uint8  count)
//  220 {
disk_write:
        PUSH     {R4-R6,LR}
        SUB      SP,SP,#+32
        MOVS     R6,R1
        MOVS     R5,R3
//  221     ESDHC_COMMAND_STRUCT command;
//  222     SDCARD_STRUCT_PTR    sdcard_ptr = (SDCARD_STRUCT_PTR)&SDHC_Card;
        LDR.N    R4,??DataTable7_1
//  223 
//  224     //检查参数
//  225     if (drv || !count) return RES_PARERR;
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BNE.N    ??disk_write_0
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R5,#+0
        BNE.N    ??disk_write_1
??disk_write_0:
        MOVS     R0,#+4
        B.N      ??disk_write_2
//  226     if (Stat & STA_NOINIT) return RES_NOTRDY;
??disk_write_1:
        LDR.N    R0,??DataTable7
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+31
        BPL.N    ??disk_write_3
        MOVS     R0,#+3
        B.N      ??disk_write_2
//  227     if (Stat & STA_PROTECT) return RES_WRPRT;
??disk_write_3:
        LDR.N    R0,??DataTable7
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+29
        BPL.N    ??disk_write_4
        MOVS     R0,#+2
        B.N      ??disk_write_2
//  228 
//  229     //检测缓存区是否为空
//  230     if ((NULL == buff)) return RES_ERROR;
??disk_write_4:
        CMP      R6,#+0
        BNE.N    ??disk_write_5
        MOVS     R0,#+1
        B.N      ??disk_write_2
//  231 
//  232 
//  233     if (!sdcard_ptr->SDHC)
??disk_write_5:
        LDRB     R0,[R4, #+16]
        CMP      R0,#+0
        BNE.N    ??disk_write_6
//  234         //sector *= 512;	//扇区号转化为起始地址
//  235         sector = sector << IO_SDCARD_BLOCK_SIZE_POWER; 
        LSLS     R2,R2,#+9
//  236 
//  237     if (count == 1)	//写单个扇区
??disk_write_6:
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R5,#+1
        BNE.N    ??disk_write_7
//  238     {
//  239         command.COMMAND  = ESDHC_CMD24;
        MOVS     R0,#+24
        STRB     R0,[SP, #+0]
//  240         command.TYPE     = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+1]
//  241         command.ARGUMENT = sector;
        STR      R2,[SP, #+4]
//  242         command.READ = FALSE;
        MOVS     R0,#+0
        STRB     R0,[SP, #+8]
//  243         command.BLOCKS = count;
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        STR      R5,[SP, #+12]
//  244 
//  245         if (ESDHC_OK == hw_sdhc_ioctl (IO_IOCTL_ESDHC_SEND_COMMAND, &command))
        ADD      R1,SP,#+0
        MOVS     R0,#+2
        BL       hw_sdhc_ioctl
        CMP      R0,#+0
        BNE.N    ??disk_write_8
//  246         {
//  247             //if (hw_sdhc_send_block(buff,512))
//  248             if (hw_sdhc_send_block(buff, IO_SDCARD_BLOCK_SIZE))
        MOV      R1,#+512
        MOVS     R0,R6
        BL       hw_sdhc_send_block
        CMP      R0,#+0
        BEQ.N    ??disk_write_8
//  249                 count = 0;
        MOVS     R5,#+0
        B.N      ??disk_write_8
//  250         }
//  251     }
//  252     else //写多个扇区
//  253     {
//  254         command.COMMAND  = ESDHC_CMD25;
??disk_write_7:
        MOVS     R0,#+25
        STRB     R0,[SP, #+0]
//  255         command.TYPE     = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+1]
//  256         command.ARGUMENT = sector;
        STR      R2,[SP, #+4]
//  257         command.READ     = FALSE;
        MOVS     R0,#+0
        STRB     R0,[SP, #+8]
//  258         command.BLOCKS   = count;
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        STR      R5,[SP, #+12]
//  259 
//  260         if (ESDHC_OK == hw_sdhc_ioctl (IO_IOCTL_ESDHC_SEND_COMMAND, &command))
        ADD      R1,SP,#+0
        MOVS     R0,#+2
        BL       hw_sdhc_ioctl
        CMP      R0,#+0
        BNE.N    ??disk_write_8
//  261         {
//  262             if (hw_sdhc_send_block(buff,IO_SDCARD_BLOCK_SIZE*count))
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        MOV      R0,#+512
        MUL      R1,R0,R5
        MOVS     R0,R6
        BL       hw_sdhc_send_block
        CMP      R0,#+0
        BEQ.N    ??disk_write_8
//  263                 count = 0;
        MOVS     R5,#+0
//  264         }
//  265     }
//  266 
//  267     //等待完成
//  268     do
//  269     {
//  270         command.COMMAND  = ESDHC_CMD13;
??disk_write_8:
        MOVS     R0,#+13
        STRB     R0,[SP, #+0]
//  271         command.TYPE     = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+1]
//  272         command.ARGUMENT = sdcard_ptr->ADDRESS;
        LDR      R0,[R4, #+20]
        STR      R0,[SP, #+4]
//  273         command.READ     = FALSE;
        MOVS     R0,#+0
        STRB     R0,[SP, #+8]
//  274         command.BLOCKS   = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+12]
//  275     if (ESDHC_OK != hw_sdhc_ioctl (IO_IOCTL_ESDHC_SEND_COMMAND, &command))
        ADD      R1,SP,#+0
        MOVS     R0,#+2
        BL       hw_sdhc_ioctl
        CMP      R0,#+0
        BEQ.N    ??disk_write_9
//  276         return RES_ERROR;
        MOVS     R0,#+1
        B.N      ??disk_write_2
//  277     
//  278     if (command.RESPONSE[0] & 0xFFD98008)
??disk_write_9:
        LDR      R0,[SP, #+16]
        LDR.N    R1,??DataTable7_2  ;; 0xffd98008
        TST      R0,R1
        BEQ.N    ??disk_write_10
//  279         return RES_ERROR;
        MOVS     R0,#+1
        B.N      ??disk_write_2
//  280 
//  281     } while (0x000000900 != (command.RESPONSE[0] & 0x00001F00));		
??disk_write_10:
        LDR      R0,[SP, #+16]
        ANDS     R0,R0,#0x1F00
        CMP      R0,#+2304
        BNE.N    ??disk_write_8
//  282 
//  283     return count ? RES_ERROR : RES_OK;
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R5,#+0
        BEQ.N    ??disk_write_11
        MOVS     R0,#+1
        B.N      ??disk_write_12
??disk_write_11:
        MOVS     R0,#+0
??disk_write_12:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
??disk_write_2:
        ADD      SP,SP,#+32
        POP      {R4-R6,PC}       ;; return
//  284 }
//  285 
//  286 
//  287 //=========================================================================
//  288 //函数名称：disk_ioctl                                                        
//  289 //功能概要：数据盘控制                                                
//  290 //参数说明：drv:设备号
//  291 //         ctrl:命令
//  292 //         buff:数据的缓存区首地址
//  293 //函数返回：RES_OK：成功，其它：失败                                                              
//  294 //=========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  295 DRESULT disk_ioctl(uint8 drv,uint8 ctrl,void  *buff)
//  296 {
disk_ioctl:
        PUSH     {R4,LR}
        SUB      SP,SP,#+32
        MOVS     R4,R2
//  297     DRESULT 			 res;
//  298     ESDHC_COMMAND_STRUCT command;
//  299     SDCARD_STRUCT_PTR	 sdcard_ptr = (SDCARD_STRUCT_PTR)&SDHC_Card;	
        LDR.N    R2,??DataTable7_1
//  300     
//  301     if (drv) return RES_PARERR;
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??disk_ioctl_0
        MOVS     R0,#+4
        B.N      ??disk_ioctl_1
//  302     if (Stat & STA_NOINIT) return RES_NOTRDY;
??disk_ioctl_0:
        LDR.N    R0,??DataTable7
        LDRB     R0,[R0, #+0]
        LSLS     R0,R0,#+31
        BPL.N    ??disk_ioctl_2
        MOVS     R0,#+3
        B.N      ??disk_ioctl_1
//  303     
//  304     res = RES_ERROR;
??disk_ioctl_2:
        MOVS     R0,#+1
//  305     switch (ctrl) 
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        CMP      R1,#+0
        BEQ.N    ??disk_ioctl_3
        CMP      R1,#+1
        BEQ.N    ??disk_ioctl_4
        CMP      R1,#+2
        BEQ.N    ??disk_ioctl_5
        CMP      R1,#+3
        BEQ.N    ??disk_ioctl_6
        CMP      R1,#+5
        BEQ.N    ??disk_ioctl_7
        B.N      ??disk_ioctl_8
//  306     {
//  307     case CTRL_SYNC :
//  308         res = RES_OK;
??disk_ioctl_3:
        MOVS     R0,#+0
//  309         break;
        B.N      ??disk_ioctl_9
//  310     case GET_SECTOR_COUNT :
//  311         *(unsigned long*)buff = sdcard_ptr->NUM_BLOCKS;
??disk_ioctl_4:
        LDR      R0,[R2, #+12]
        STR      R0,[R4, #+0]
//  312         res = RES_OK;
        MOVS     R0,#+0
//  313         break; 
        B.N      ??disk_ioctl_9
//  314     case GET_SECTOR_SIZE :
//  315         *(unsigned short*)buff = IO_SDCARD_BLOCK_SIZE;
??disk_ioctl_5:
        MOV      R0,#+512
        STRH     R0,[R4, #+0]
//  316         res = RES_OK;
        MOVS     R0,#+0
//  317         break;
        B.N      ??disk_ioctl_9
//  318     case GET_BLOCK_SIZE :
//  319         command.COMMAND  = ESDHC_CMD9;
??disk_ioctl_6:
        MOVS     R0,#+9
        STRB     R0,[SP, #+0]
//  320         command.TYPE     = ESDHC_TYPE_NORMAL;
        MOVS     R0,#+0
        STRB     R0,[SP, #+1]
//  321         command.ARGUMENT = sdcard_ptr->ADDRESS;
        LDR      R0,[R2, #+20]
        STR      R0,[SP, #+4]
//  322         command.READ     = FALSE;
        MOVS     R0,#+0
        STRB     R0,[SP, #+8]
//  323         command.BLOCKS   = 0;
        MOVS     R0,#+0
        STR      R0,[SP, #+12]
//  324         if (ESDHC_OK != hw_sdhc_ioctl (IO_IOCTL_ESDHC_SEND_COMMAND, &command))
        ADD      R1,SP,#+0
        MOVS     R0,#+2
        BL       hw_sdhc_ioctl
        CMP      R0,#+0
        BEQ.N    ??disk_ioctl_10
//  325             return RES_ERROR;
        MOVS     R0,#+1
        B.N      ??disk_ioctl_1
//  326 
//  327         if (0 == (command.RESPONSE[3] & 0x00C00000)) //SD V1
??disk_ioctl_10:
        LDR      R0,[SP, #+28]
        TST      R0,#0xC00000
        BNE.N    ??disk_ioctl_11
//  328             *(unsigned long*)buff = ((((command.RESPONSE[2] >> 18) & 0x7F) + 1) << (((command.RESPONSE[3] >> 8) & 0x03) - 1));
        LDR      R0,[SP, #+24]
        UBFX     R0,R0,#+18,#+7
        ADDS     R0,R0,#+1
        LDR      R1,[SP, #+28]
        LSRS     R1,R1,#+8
        ANDS     R1,R1,#0x3
        SUBS     R1,R1,#+1
        LSLS     R0,R0,R1
        STR      R0,[R4, #+0]
        B.N      ??disk_ioctl_12
//  329         else //SD V2
//  330             *(unsigned long*)buff = (((command.RESPONSE[2] >> 18) & 0x7F) << (((command.RESPONSE[3] >> 8) & 0x03) - 1));				
??disk_ioctl_11:
        LDR      R0,[SP, #+24]
        UBFX     R0,R0,#+18,#+7
        LDR      R1,[SP, #+28]
        LSRS     R1,R1,#+8
        ANDS     R1,R1,#0x3
        SUBS     R1,R1,#+1
        LSLS     R0,R0,R1
        STR      R0,[R4, #+0]
//  331         res = RES_OK;
??disk_ioctl_12:
        MOVS     R0,#+0
//  332         break;
        B.N      ??disk_ioctl_9
//  333     case CTRL_DISK_TYPE:
//  334         res = sdcard_ptr->CARD_TYPE;
??disk_ioctl_7:
        LDRB     R0,[R2, #+0]
//  335     default:
//  336         res = RES_PARERR;
??disk_ioctl_8:
        MOVS     R0,#+4
//  337     }
//  338     
//  339     return res;
??disk_ioctl_9:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
??disk_ioctl_1:
        ADD      SP,SP,#+32
        POP      {R4,PC}          ;; return
//  340 }
//  341 
//  342 //=========================================================================
//  343 //函数名称：disk_status                                                        
//  344 //功能概要：返回数据盘状态                                              
//  345 //参数说明：drv：数据盘号
//  346 //函数返回：状态                                                        
//  347 //=========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  348 uint8 disk_status (uint8 drv)
//  349 {
//  350     if (drv) return STA_NOINIT;
disk_status:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??disk_status_0
        MOVS     R0,#+1
        B.N      ??disk_status_1
//  351     return Stat;
??disk_status_0:
        LDR.N    R0,??DataTable7
        LDRB     R0,[R0, #+0]
??disk_status_1:
        BX       LR               ;; return
//  352 }
//  353 
//  354 //=========================================================================
//  355 //函数名称：disk_timerproc                                                        
//  356 //功能概要：检测SD卡状态                                              
//  357 //参数说明：无
//  358 //函数返回：无                                                        
//  359 //=========================================================================

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  360 void disk_timerproc (void)
//  361 {
//  362     uint8 s;	
//  363     
//  364     Timer++;
disk_timerproc:
        LDR.N    R0,??DataTable7_3
        LDR      R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.N    R1,??DataTable7_3
        STR      R0,[R1, #+0]
//  365     s = Stat;
        LDR.N    R0,??DataTable7
        LDRB     R0,[R0, #+0]
//  366     
//  367     if (SDCARD_GPIO_PROTECT == 0)				      
        LDR.N    R1,??DataTable7_4  ;; 0x400ff110
        LDR      R1,[R1, #+0]
        LSLS     R1,R1,#+4
        BMI.N    ??disk_timerproc_0
//  368     {
//  369         s &= ~STA_PROTECT;	           //写使能
        ANDS     R0,R0,#0xFB
        B.N      ??disk_timerproc_1
//  370     }
//  371     else					          
//  372     {
//  373         s |= STA_PROTECT;			   //写保护
??disk_timerproc_0:
        ORRS     R0,R0,#0x4
//  374     }
//  375     if (SDCARD_GPIO_DETECT == 0)	   //卡插入
??disk_timerproc_1:
        LDR.N    R1,??DataTable7_4  ;; 0x400ff110
        LDR      R1,[R1, #+0]
        LSLS     R1,R1,#+3
        BMI.N    ??disk_timerproc_2
//  376         s &= ~STA_NODISK;
        ANDS     R0,R0,#0xFD
        B.N      ??disk_timerproc_3
//  377     else					           //卡不存在
//  378         s |= (STA_NODISK | STA_NOINIT);
??disk_timerproc_2:
        ORRS     R0,R0,#0x3
//  379     
//  380     Stat = s;				           //更新卡状态
??disk_timerproc_3:
        LDR.N    R1,??DataTable7
        STRB     R0,[R1, #+0]
//  381 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable7:
        DC32     Stat

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable7_1:
        DC32     SDHC_Card

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable7_2:
        DC32     0xffd98008

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable7_3:
        DC32     Timer

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable7_4:
        DC32     0x400ff110

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
// 
//     4 bytes in section .bss
//     1 byte  in section .data
// 1 316 bytes in section .text
// 
// 1 316 bytes of CODE memory
//     5 bytes of DATA memory
//
//Errors: none
//Warnings: 4
