///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      04/Mar/2012  11:29:58 /
// IAR ANSI C/C++ Compiler V6.10.1.22143/W32 EVALUATION for ARM               /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\gpio /
//                    \FAT32.c                                                /
//    Command line =  "F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\gpi /
//                    o\FAT32.c" -D IAR -D TWR_K60N512 -lCN "F:\My            /
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
//                    M_32KB\List\FAT32.s                                     /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME FAT32

        EXTERN Dev_No
        EXTERN __iar_Strchr
        EXTERN disk_read
        EXTERN disk_write
        EXTERN pArg
        EXTERN strcpy
        EXTERN strlen

        PUBLIC Compare_Dir_Name
        PUBLIC FAT32_Add_Dat
        PUBLIC FAT32_Buffer
        PUBLIC FAT32_Create_Dir
        PUBLIC FAT32_Create_File
        PUBLIC FAT32_Create_Rec
        PUBLIC FAT32_Del_File
        PUBLIC FAT32_Empty_Cluster
        PUBLIC FAT32_Enter_Dir
        PUBLIC FAT32_File_Close
        PUBLIC FAT32_Find_DBR
        PUBLIC FAT32_Find_Free_Clust
        PUBLIC FAT32_GetNextCluster
        PUBLIC FAT32_Get_Remain_Cap
        PUBLIC FAT32_Get_Total_Size
        PUBLIC FAT32_Init
        PUBLIC FAT32_Modify_FAT
        PUBLIC FAT32_New_File
        PUBLIC FAT32_Open_File
        PUBLIC FAT32_ReadSector
        PUBLIC FAT32_Read_File
        PUBLIC FAT32_Rename_File
        PUBLIC FAT32_Seek_File
        PUBLIC FAT32_Update_FSInfo_Free_Clu
        PUBLIC FAT32_Update_FSInfo_Last_Clu
        PUBLIC FAT32_WriteSector
        PUBLIC FAT32_XCopy_File
        PUBLIC FAT32_is_MBR
        PUBLIC FAT32_toFileName
        PUBLIC FilenameMatch
        PUBLIC Fill_Rec_Inf
        PUBLIC L2U
        PUBLIC LE2BE
        PUBLIC Search_Last_Usable_Cluster
        PUBLIC Str2Up
        PUBLIC idata
        PUBLIC pRS
        PUBLIC pWS
        PUBLIC strchr
        PUBLIC temp_dir_cluster
        PUBLIC temp_dir_name
        PUBLIC temp_last_cluster
        PUBLIC temp_rec

// F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\gpio\FAT32.c
//    1 #include "FAT32.h"
//    2 #include "hw_sdhc.h"        //存储设备的扇区读写驱动，这里是SD卡
//    3 //#include "ch375.h"	   //存储设备的扇区读写驱动，这里是U盘
//    4 //#include "cf.h"
//    5 #include "string.h"

        SECTION `.text`:CODE:REORDER:NOROOT(1)
        SECTION_GROUP strchr
        THUMB
// __intrinsic __interwork __softfp char *strchr(char const *, int)
strchr:
        PUSH     {R7,LR}
        BL       __iar_Strchr
        POP      {R1,PC}          ;; return
//    6 
//    7 /*******************************************************
//    8 
//    9         +-----------------------------------------+
//   10         |振南电子 原创程序模块 znFAT文件系统 5.01 |
//   11         +-----------------------------------------+
//   12 
//   13   此源码版权属 振南 全权享有，如欲引用，敬请署名并告知
//   14         严禁随意用于商业目的，违者必究，后果自负
//   15          振南电子 
//   16              ->产品网站 http://www.znmcu.cn/
//   17              ->产品论坛 http://bbs.znmcu.cn/
//   18              ->产品网店 http://shop.znmcu.cn/
//   19              ->产品咨询 QQ:987582714 MSN:yzn07@126.com
//   20 	                WW:yzn07
//   21 说明：znFAT经多方测试，确保其正确性与稳定性，请放心使用，
//   22       如有bug敬请告知，谢谢！！				  
//   23 ********************************************************/
//   24 
//   25 //全局变量定义

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   26 struct direntry idata,temp_rec;
idata:
        DS8 32

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
temp_rec:
        DS8 32

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   27 int8 temp_dir_name[13]; 
temp_dir_name:
        DS8 16

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   28 uint32 temp_dir_cluster;
temp_dir_cluster:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   29 uint32 temp_last_cluster;
temp_last_cluster:
        DS8 4
//   30 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   31 uint8 FAT32_Buffer[512]; //扇区数据读写缓冲区,由外部提供
FAT32_Buffer:
        DS8 512
//   32 
//   33 extern struct FAT32_Init_Arg *pArg; //初始化参数结构体指针，用以指向某一存储设备的初始化参数结构体，由外部提供
//   34 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   35 unsigned char (*pRS)(unsigned long,unsigned char *); //指向实际存储设备的读扇区函数的函数指针，用以实现对设备的支持
pRS:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   36 unsigned char (*pWS)(unsigned long,unsigned char *); //指向实际存储设备的写扇区函数的函数指针，用以实现对设备的支持
pWS:
        DS8 4
//   37 
//   38 extern unsigned char Dev_No;
//   39 
//   40 /******************************************************************
//   41  - 功能描述：znFAT的存储设备底层驱动接口，读取存储设备的addr扇区的
//   42              512个字节的数据放入buf数据缓冲区中
//   43  - 隶属模块：znFAT文件系统模块
//   44  - 函数属性：内部（用于与存储设备的底层驱动对接）
//   45  - 参数说明：addr:扇区地址
//   46              buf:指向数据缓冲区
//   47  - 返回说明：0表示读取扇区成功，否则失败
//   48  - 注：这里加入了天狼星精华板上的三种存储设备，即SD卡（有效）、U盘、
//   49        CF卡通过在程序中动态的切换不同的设备驱动，从而实现多设备(即同
//   50 	   时对多种存储设备进行操作，比如从SD卡拷贝文件到U盘等等)，不同
//   51 	   驱动的切换，只需要在程序中改变Dev_No这个全局变量的值即可
//   52  ******************************************************************/
//   53 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   54 uint8 FAT32_ReadSector(uint32 addr,uint8 *buf) 
//   55 {
FAT32_ReadSector:
        PUSH     {R7,LR}
//   56  return(disk_read(0,buf,addr,1));  //替换成实际存储器的扇区读函数，这里是SD卡扇区读函数
        MOVS     R3,#+1
        MOVS     R2,R0
        MOVS     R0,#+0
        BL       disk_read
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        POP      {R1,PC}          ;; return
//   57 }
//   58 
//   59 /******************************************************************
//   60  - 功能描述：znFAT的存储设备底层驱动接口，将buf数据缓冲区中的512个
//   61              字节的数据写入到存储设备的addr扇区中
//   62  - 隶属模块：znFAT文件系统模块
//   63  - 函数属性：内部（用于与存储设备的底层驱动对接）
//   64  - 参数说明：addr:扇区地址
//   65              buf:指向数据缓冲区
//   66  - 返回说明：0表示读取扇区成功，否则失败
//   67  - 注：略
//   68  ******************************************************************/
//   69 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   70 uint8 FAT32_WriteSector(uint32 addr,uint8 *buf)
//   71 {
FAT32_WriteSector:
        PUSH     {R7,LR}
//   72  return(disk_write(0,buf,addr,1)); //替换成实际存储器的扇区写函数，这里是SD卡扇区写函数
        MOVS     R3,#+1
        MOVS     R2,R0
        MOVS     R0,#+0
        BL       disk_write
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        POP      {R1,PC}          ;; return
//   73 }
//   74 
//   75 /******************************************************************
//   76  - 功能描述：小端转大端，即LittleEndian车BigEndian
//   77  - 隶属模块：znFAT文件系统模块
//   78  - 函数属性：内部
//   79  - 参数说明：dat:指向要转为大端的字节序列
//   80              len:要转为大端的字节序列长度
//   81  - 返回说明：转为大端模式后，字节序列所表达的数据
//   82  - 注：比如：小端模式的       0x33 0x22 0x11 0x00  (低字节在前)
//   83              转为大端模式后为 0x00 0x11 0x22 0x33  (高字节在前)
//   84              所表达的数值为   0x00112233
//   85              (CISC的CPU通常是小端的，所以FAT32也设计为小端，而单片机
//   86               这种RISC的CPU，通常来说都是大端的，所以需要这个函数将字
//   87               节的存放次序进行调整，才能得到正确的数值)
//   88  ******************************************************************/
//   89 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   90 uint32 LE2BE(uint8 *dat,uint8 len) 
//   91 {
LE2BE:
        PUSH     {R4,R5}
//   92  uint32 temp=0;
        MOVS     R2,#+0
//   93  uint32 fact=1;
        MOVS     R3,#+1
//   94  uint8  i=0;
        MOVS     R4,#+0
//   95  for(i=0;i<len;i++)
        MOVS     R5,#+0
        MOVS     R4,R5
        B.N      ??LE2BE_0
//   96  {
//   97   temp+=dat[i]*fact; //将各字节乘以相应的权值后累加
??LE2BE_1:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        LDRB     R5,[R4, R0]
        MLA      R2,R3,R5,R2
//   98   fact*=256; //更新权值
        MOV      R5,#+256
        MULS     R3,R5,R3
//   99  }
        ADDS     R4,R4,#+1
??LE2BE_0:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        CMP      R4,R1
        BCC.N    ??LE2BE_1
//  100  return temp;
        MOVS     R0,R2
        POP      {R4,R5}
        BX       LR               ;; return
//  101 }
//  102 
//  103 /******************************************************************
//  104  - 功能描述：将小字字符转为大写
//  105  - 隶属模块：znFAT文件系统模块
//  106  - 函数属性：内部
//  107  - 参数说明：c:要转换为大写的字符            
//  108  - 返回说明：要转换的字节的相应的大写字符
//  109  - 注：只对小写字符有效，如果不是a~z的小写字符，将直接返回
//  110  ******************************************************************/
//  111 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  112 int8 L2U(int8 c)
//  113 {
//  114  if(c>='a' && c<='z') return c+'A'-'a';         
L2U:
        SUBS     R1,R0,#+97
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        CMP      R1,#+26
        BCS.N    ??L2U_0
        SUBS     R0,R0,#+32
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        B.N      ??L2U_1
//  115  else return c;
??L2U_0:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
??L2U_1:
        BX       LR               ;; return
//  116 }
//  117 
//  118 /******************************************************************
//  119  - 功能描述：读取0扇区，检测有没有MBR(主引导记录)
//  120  - 隶属模块：znFAT文件系统模块
//  121  - 函数属性：内部
//  122  - 参数说明：无     
//  123  - 返回说明：1表示检测到MBR，0表示没有检测到MBR
//  124  - 注：有些存储设备格式化为FAT32以后，没有MBR，则0扇区就是DBR
//  125        如果有MBR，就需要对其进行解析，以得到DBR的扇区位置，同时MBR中
//  126        还含分区、分区容量等信息
//  127  ******************************************************************/
//  128 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  129 uint8 FAT32_is_MBR()
//  130 {
FAT32_is_MBR:
        PUSH     {R7,LR}
//  131  uint8 result;
//  132  FAT32_ReadSector(0,FAT32_Buffer);
        LDR.W    R1,??DataTable14
        MOVS     R0,#+0
        BL       FAT32_ReadSector
//  133  if(FAT32_Buffer[0]!=0xeb) 
        LDR.W    R0,??DataTable14
        LDRB     R0,[R0, #+0]
        CMP      R0,#+235
        BEQ.N    ??FAT32_is_MBR_0
//  134  {
//  135   result=1;
        MOVS     R0,#+1
        B.N      ??FAT32_is_MBR_1
//  136  }
//  137  else 
//  138  {
//  139   result=0;
??FAT32_is_MBR_0:
        MOVS     R0,#+0
//  140  }
//  141  return result;
??FAT32_is_MBR_1:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        POP      {R1,PC}          ;; return
//  142 }
//  143 
//  144 /***********************************************************************
//  145  - 功能描述：得到DBR所在的扇区号(如果没有MBR，则DBR就在0扇区)
//  146  - 隶属模块：znFAT文件系统模块
//  147  - 函数属性：内部
//  148  - 参数说明：无     
//  149  - 返回说明：DBR的扇区地址
//  150  - 注：DBR中包含了很多有用的参数信息，因此正确定位DBR扇区的位置，是极为
//  151        重要的，后面将有专门的函数对DBR进行解析，正确解析DBR是实现FAT32的
//  152        基础
//  153  ***********************************************************************/
//  154 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  155 uint16 FAT32_Find_DBR()
//  156 {
FAT32_Find_DBR:
        PUSH     {R7,LR}
//  157  uint16 sec_dbr;
//  158  FAT32_ReadSector(0,FAT32_Buffer);
        LDR.W    R1,??DataTable14
        MOVS     R0,#+0
        BL       FAT32_ReadSector
//  159  if(FAT32_Buffer[0]!=0xeb) 
        LDR.W    R0,??DataTable14
        LDRB     R0,[R0, #+0]
        CMP      R0,#+235
        BEQ.N    ??FAT32_Find_DBR_0
//  160  {
//  161   sec_dbr=LE2BE(((((struct PartSector *)(FAT32_Buffer))->Part[0]).StartLBA),4);
        MOVS     R1,#+4
        LDR.W    R0,??DataTable14_1
        BL       LE2BE
        B.N      ??FAT32_Find_DBR_1
//  162  }
//  163  else
//  164  {
//  165   sec_dbr=0;
??FAT32_Find_DBR_0:
        MOVS     R0,#+0
//  166  }
//  167  return sec_dbr;
??FAT32_Find_DBR_1:
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        POP      {R1,PC}          ;; return
//  168 }
//  169 
//  170 /***********************************************************************
//  171  - 功能描述：获取分区的总容量
//  172  - 隶属模块：znFAT文件系统模块
//  173  - 函数属性：外部，使用户使用
//  174  - 参数说明：无     
//  175  - 返回说明：分区容量值，单位为字节
//  176  - 注：这里得到的总容量是FAT32分区的容量，一定小于实际的物理容量
//  177  ***********************************************************************/
//  178 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  179 uint32 FAT32_Get_Total_Size() 
//  180 {
FAT32_Get_Total_Size:
        PUSH     {R7,LR}
//  181  uint32 temp;
//  182  FAT32_ReadSector(pArg->BPB_Sector_No,FAT32_Buffer);
        LDR.W    R1,??DataTable14
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDRB     R0,[R0, #+1]
        BL       FAT32_ReadSector
//  183  FAT32_ReadSector(pArg->BPB_Sector_No,FAT32_Buffer);
        LDR.W    R1,??DataTable14
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDRB     R0,[R0, #+1]
        BL       FAT32_ReadSector
//  184  temp=((LE2BE((((struct FAT32_BPB *)(FAT32_Buffer))->BPB_TotSec32),4)))*pArg->BytesPerSector;
        MOVS     R1,#+4
        LDR.W    R0,??DataTable14_3
        BL       LE2BE
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        MULS     R0,R1,R0
//  185  return temp;
        POP      {R1,PC}          ;; return
//  186 }
//  187 
//  188 /***********************************************************************
//  189  - 功能描述：读取FSInfo获取最近的一个可用空闲簇
//  190  - 隶属模块：znFAT文件系统模块
//  191  - 函数属性：内部
//  192  - 参数说明：无     
//  193  - 返回说明：最近的一个可用空闲簇
//  194  - 注：FAT32中的FSInfo扇区(绝对1扇区)中记录了最近的一个可用空闲簇
//  195  ***********************************************************************/
//  196 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  197 uint32 Search_Last_Usable_Cluster()
//  198 {
Search_Last_Usable_Cluster:
        PUSH     {R7,LR}
//  199  FAT32_ReadSector(1+pArg->BPB_Sector_No,FAT32_Buffer);
        LDR.W    R1,??DataTable14
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDRB     R0,[R0, #+1]
        ADDS     R0,R0,#+1
        BL       FAT32_ReadSector
//  200  return LE2BE(((struct FSInfo *)FAT32_Buffer)->Last_Cluster,4);
        MOVS     R1,#+4
        LDR.W    R0,??DataTable15
        BL       LE2BE
        POP      {R1,PC}          ;; return
//  201 }
//  202 
//  203 /***********************************************************************
//  204  - 功能描述：FAT32文件系统初始化
//  205  - 隶属模块：znFAT文件系统模块
//  206  - 函数属性：外部，使用户使用
//  207  - 参数说明：FAT32_Init_Arg类型的结构体指针，用于装载一些重要的参数信息，
//  208              以备后面使用     
//  209  - 返回说明：无
//  210  - 注：在使用znFAT前，这个函数是必须先被调用的，将很多参数信息装入到
//  211        arg指向的结构体中，比如扇区大小、根目录的位置、FAT表大小等等。
//  212        这些参数绝大部分是来自于DBR的BPB中，因此此函数主要在作对DBR的参数解析
//  213  ***********************************************************************/
//  214 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  215 void FAT32_Init()
//  216 {
FAT32_Init:
        PUSH     {R4,LR}
//  217  struct FAT32_BPB *bpb;
//  218 
//  219  bpb=(struct FAT32_BPB *)(FAT32_Buffer);               //将数据缓冲区指针转为struct FAT32_BPB 型指针
        LDR.W    R4,??DataTable14
//  220 
//  221  pArg->DEV_No=Dev_No; //装入设备号
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable15_1
        LDRB     R1,[R1, #+0]
        STRB     R1,[R0, #+0]
//  222 
//  223  pArg->BPB_Sector_No   =FAT32_Find_DBR();               //FAT32_FindBPB()可以返回BPB所在的扇区号
        BL       FAT32_Find_DBR
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STRB     R0,[R1, #+1]
//  224  pArg->BPB_Sector_No   =FAT32_Find_DBR();               //FAT32_FindBPB()可以返回BPB所在的扇区号
        BL       FAT32_Find_DBR
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STRB     R0,[R1, #+1]
//  225  pArg->Total_Size      =FAT32_Get_Total_Size();         //FAT32_Get_Total_Size()可以返回磁盘的总容量，单位是字节
        BL       FAT32_Get_Total_Size
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STR      R0,[R1, #+4]
//  226 
//  227  pArg->FATsectors      =LE2BE((bpb->BPB_FATSz32)    ,4);//装入FAT表占用的扇区数到FATsectors中
        MOVS     R1,#+4
        ADDS     R0,R4,#+36
        BL       LE2BE
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STR      R0,[R1, #+16]
//  228  pArg->FirstDirClust   =LE2BE((bpb->BPB_RootClus)   ,4);//装入根目录簇号到FirstDirClust中
        MOVS     R1,#+4
        ADDS     R0,R4,#+44
        BL       LE2BE
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STR      R0,[R1, #+8]
//  229  pArg->BytesPerSector  =LE2BE((bpb->BPB_BytesPerSec),2);//装入每扇区字节数到BytesPerSector中
        MOVS     R1,#+2
        ADDS     R0,R4,#+11
        BL       LE2BE
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STR      R0,[R1, #+12]
//  230  pArg->SectorsPerClust =LE2BE((bpb->BPB_SecPerClus) ,1);//装入每簇扇区数到SectorsPerClust 中
        MOVS     R1,#+1
        ADDS     R0,R4,#+13
        BL       LE2BE
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STR      R0,[R1, #+20]
//  231  pArg->FirstFATSector  =LE2BE((bpb->BPB_RsvdSecCnt) ,2)+pArg->BPB_Sector_No;//装入第一个FAT表扇区号到FirstFATSector 中
        MOVS     R1,#+2
        ADDS     R0,R4,#+14
        BL       LE2BE
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDRB     R1,[R1, #+1]
        UXTAB    R0,R0,R1
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STR      R0,[R1, #+24]
//  232  pArg->FirstDirSector  =(pArg->FirstFATSector)+(bpb->BPB_NumFATs[0])*(pArg->FATsectors); //装入第一个目录扇区到FirstDirSector中
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+24]
        LDRB     R1,[R4, #+16]
        LDR.W    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+16]
        MLA      R0,R2,R1,R0
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STR      R0,[R1, #+28]
//  233  
//  234  pArg->Total_Size      =FAT32_Get_Total_Size();         //FAT32_Get_Total_Size()可以返回磁盘的总容量，单位是兆
        BL       FAT32_Get_Total_Size
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STR      R0,[R1, #+4]
//  235  
//  236  temp_last_cluster=Search_Last_Usable_Cluster();
        BL       Search_Last_Usable_Cluster
        LDR.W    R1,??DataTable15_2
        STR      R0,[R1, #+0]
//  237 }
        POP      {R4,PC}          ;; return
//  238 
//  239 /***********************************************************************
//  240  - 功能描述：获取剩余容量
//  241  - 隶属模块：znFAT文件系统模块
//  242  - 函数属性：外部，使用户使用
//  243  - 参数说明：无    
//  244  - 返回说明：剩余容量，单位字节
//  245  - 注：从FSInfo中读取空闲簇数，而从计算得到剩余的容量，单位字节
//  246  ***********************************************************************/
//  247 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  248 uint32 FAT32_Get_Remain_Cap()
//  249 {
FAT32_Get_Remain_Cap:
        PUSH     {R7,LR}
//  250  FAT32_ReadSector(1+pArg->BPB_Sector_No,FAT32_Buffer);
        LDR.W    R1,??DataTable14
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDRB     R0,[R0, #+1]
        ADDS     R0,R0,#+1
        BL       FAT32_ReadSector
//  251  if(((struct FSInfo *)FAT32_Buffer)->Free_Cluster[0]==0xff 
//  252  && ((struct FSInfo *)FAT32_Buffer)->Free_Cluster[1]==0xff 
//  253  && ((struct FSInfo *)FAT32_Buffer)->Free_Cluster[2]==0xff 
//  254  && ((struct FSInfo *)FAT32_Buffer)->Free_Cluster[3]==0xff)
        LDR.W    R0,??DataTable14
        LDRB     R0,[R0, #+488]
        CMP      R0,#+255
        BNE.N    ??FAT32_Get_Remain_Cap_0
        LDR.W    R0,??DataTable14
        LDRB     R0,[R0, #+489]
        CMP      R0,#+255
        BNE.N    ??FAT32_Get_Remain_Cap_0
        LDR.W    R0,??DataTable14
        LDRB     R0,[R0, #+490]
        CMP      R0,#+255
        BNE.N    ??FAT32_Get_Remain_Cap_0
        LDR.W    R0,??DataTable14
        LDRB     R0,[R0, #+491]
        CMP      R0,#+255
        BNE.N    ??FAT32_Get_Remain_Cap_0
//  255  return pArg->Total_Size;
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+4]
        B.N      ??FAT32_Get_Remain_Cap_1
//  256  else
//  257  return LE2BE(((struct FSInfo *)FAT32_Buffer)->Free_Cluster,4)*pArg->SectorsPerClust*pArg->BytesPerSector; 
??FAT32_Get_Remain_Cap_0:
        MOVS     R1,#+4
        LDR.W    R0,??DataTable15_3
        BL       LE2BE
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        MULS     R0,R1,R0
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        MULS     R0,R1,R0
??FAT32_Get_Remain_Cap_1:
        POP      {R1,PC}          ;; return
//  258 }
//  259 
//  260 /***********************************************************************
//  261  - 功能描述：更新FSInfo中的可用空闲簇的数量
//  262  - 隶属模块：znFAT文件系统模块
//  263  - 函数属性：内部
//  264  - 参数说明：PlusOrMinus:可用空闲簇数加1或减1    
//  265  - 返回说明：无
//  266  - 注：创建文件、追加数据、删除文件等操作都可能会使可用的空闲簇数变化
//  267        要及时更新
//  268  ***********************************************************************/
//  269 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  270 void FAT32_Update_FSInfo_Free_Clu(uint32 PlusOrMinus)
//  271 {
FAT32_Update_FSInfo_Free_Clu:
        PUSH     {R4,LR}
        SUB      SP,SP,#+8
        MOVS     R4,R0
//  272  uint32 Free_Clu=0;
        MOVS     R0,#+0
        STR      R0,[SP, #+0]
//  273  FAT32_ReadSector(1+pArg->BPB_Sector_No,FAT32_Buffer);
        LDR.W    R1,??DataTable14
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDRB     R0,[R0, #+1]
        ADDS     R0,R0,#+1
        BL       FAT32_ReadSector
//  274 
//  275  Free_Clu=(FAT32_Get_Remain_Cap())/(pArg->SectorsPerClust*pArg->BytesPerSector);
        BL       FAT32_Get_Remain_Cap
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+12]
        MULS     R1,R2,R1
        UDIV     R0,R0,R1
        STR      R0,[SP, #+0]
//  276 
//  277  if(PlusOrMinus) Free_Clu++;
        CMP      R4,#+0
        BEQ.N    ??FAT32_Update_FSInfo_Free_Clu_0
        LDR      R0,[SP, #+0]
        ADDS     R0,R0,#+1
        STR      R0,[SP, #+0]
        B.N      ??FAT32_Update_FSInfo_Free_Clu_1
//  278  else Free_Clu--;
??FAT32_Update_FSInfo_Free_Clu_0:
        LDR      R0,[SP, #+0]
        SUBS     R0,R0,#+1
        STR      R0,[SP, #+0]
//  279 
//  280  ((struct FSInfo *)FAT32_Buffer)->Free_Cluster[0]=((unsigned char *)&Free_Clu)[3]; 
??FAT32_Update_FSInfo_Free_Clu_1:
        LDR.W    R0,??DataTable14
        LDRB     R1,[SP, #+3]
        STRB     R1,[R0, #+488]
//  281  ((struct FSInfo *)FAT32_Buffer)->Free_Cluster[1]=((unsigned char *)&Free_Clu)[2];
        LDR.W    R0,??DataTable14
        LDRB     R1,[SP, #+2]
        STRB     R1,[R0, #+489]
//  282  ((struct FSInfo *)FAT32_Buffer)->Free_Cluster[2]=((unsigned char *)&Free_Clu)[1];
        LDR.W    R0,??DataTable14
        LDRB     R1,[SP, #+1]
        STRB     R1,[R0, #+490]
//  283  ((struct FSInfo *)FAT32_Buffer)->Free_Cluster[3]=((unsigned char *)&Free_Clu)[0];
        LDR.W    R0,??DataTable14
        LDRB     R1,[SP, #+0]
        STRB     R1,[R0, #+491]
//  284  FAT32_WriteSector(1+pArg->BPB_Sector_No,FAT32_Buffer);   
        LDR.W    R1,??DataTable14
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDRB     R0,[R0, #+1]
        ADDS     R0,R0,#+1
        BL       FAT32_WriteSector
//  285 }
        POP      {R0,R1,R4,PC}    ;; return
//  286 
//  287 /***********************************************************************
//  288  - 功能描述：更新FSInfo中的下一个可用空闲簇的簇号
//  289  - 隶属模块：znFAT文件系统模块
//  290  - 函数属性：内部
//  291  - 参数说明：Last_Clu:将要更新到FSInfo中的下一个可用空闲簇的簇号    
//  292  - 返回说明：无
//  293  - 注：FSInfo中的下一个可用空闲簇号可以给文件系统一个参考，直接告诉文件系统
//  294        下一个可用的空闲簇在什么地方
//  295  ***********************************************************************/
//  296 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  297 void FAT32_Update_FSInfo_Last_Clu(uint32 Last_Clu)
//  298 {
FAT32_Update_FSInfo_Last_Clu:
        PUSH     {R0,LR}
//  299  FAT32_ReadSector(1+pArg->BPB_Sector_No,FAT32_Buffer);  
        LDR.W    R1,??DataTable14
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDRB     R0,[R0, #+1]
        ADDS     R0,R0,#+1
        BL       FAT32_ReadSector
//  300  ((struct FSInfo *)FAT32_Buffer)->Last_Cluster[0]=((unsigned char *)&Last_Clu)[3]; 
        LDR.W    R0,??DataTable14
        LDRB     R1,[SP, #+3]
        STRB     R1,[R0, #+492]
//  301  ((struct FSInfo *)FAT32_Buffer)->Last_Cluster[1]=((unsigned char *)&Last_Clu)[2];
        LDR.W    R0,??DataTable14
        LDRB     R1,[SP, #+2]
        STRB     R1,[R0, #+493]
//  302  ((struct FSInfo *)FAT32_Buffer)->Last_Cluster[2]=((unsigned char *)&Last_Clu)[1];
        LDR.W    R0,??DataTable14
        LDRB     R1,[SP, #+1]
        STRB     R1,[R0, #+494]
//  303  ((struct FSInfo *)FAT32_Buffer)->Last_Cluster[3]=((unsigned char *)&Last_Clu)[0];
        LDR.W    R0,??DataTable14
        LDRB     R1,[SP, #+0]
        STRB     R1,[R0, #+495]
//  304  FAT32_WriteSector(1+pArg->BPB_Sector_No,FAT32_Buffer);
        LDR.W    R1,??DataTable14
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDRB     R0,[R0, #+1]
        ADDS     R0,R0,#+1
        BL       FAT32_WriteSector
//  305 }
        POP      {R0,PC}          ;; return
//  306 
//  307 /***********************************************************************
//  308  - 功能描述：获得下一个簇的簇号
//  309  - 隶属模块：znFAT文件系统模块
//  310  - 函数属性：内部
//  311  - 参数说明：LastCluster:基准簇号  
//  312  - 返回说明：LastClutster的下一簇的簇号
//  313  - 注：获得下一簇的簇号，就是凭借FAT表中所记录的簇链关系来实现的
//  314  ***********************************************************************/
//  315 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  316 uint32 FAT32_GetNextCluster(uint32 LastCluster)
//  317 {
FAT32_GetNextCluster:
        PUSH     {R4,LR}
        MOVS     R4,R0
//  318  uint32 temp;
//  319  struct FAT32_FAT *pFAT;
//  320  struct FAT32_FAT_Item *pFAT_Item;
//  321  temp=((LastCluster/128)+pArg->FirstFATSector);
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+24]
        ADDS     R0,R0,R4, LSR #+7
//  322  FAT32_ReadSector(temp,FAT32_Buffer);
        LDR.W    R1,??DataTable14
        BL       FAT32_ReadSector
//  323  pFAT=(struct FAT32_FAT *)FAT32_Buffer;
        LDR.W    R0,??DataTable14
//  324  pFAT_Item=&((pFAT->Items)[LastCluster%128]);
        MOVS     R1,#+128
        UDIV     R2,R4,R1
        MLS      R2,R2,R1,R4
        ADDS     R0,R0,R2, LSL #+2
//  325  return LE2BE((uint8 *)pFAT_Item,4);
        MOVS     R1,#+4
        BL       LE2BE
        POP      {R4,PC}          ;; return
//  326 }
//  327 
//  328 /***********************************************************************
//  329  - 功能描述：比较目录名
//  330  - 隶属模块：znFAT文件系统模块
//  331  - 函数属性：内部
//  332  - 参数说明：a:指向目录名1的指针
//  333              b:指向目录名2的指针
//  334  - 返回说明：如果两个目录名相同就返回1，否则为0
//  335  ***********************************************************************/
//  336 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  337 uint8 Compare_Dir_Name(int8 *a,int8 *b)
//  338 {
Compare_Dir_Name:
        PUSH     {R4}
//  339  uint8 i;
//  340  for(i=0;i<8;i++)
        MOVS     R2,#+0
        B.N      ??Compare_Dir_Name_0
??Compare_Dir_Name_1:
        ADDS     R2,R2,#+1
??Compare_Dir_Name_0:
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        CMP      R2,#+8
        BCS.N    ??Compare_Dir_Name_2
//  341  {
//  342   if(a[i]!=b[i]) return 0;
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        LDRB     R3,[R2, R0]
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        LDRB     R4,[R2, R1]
        CMP      R3,R4
        BEQ.N    ??Compare_Dir_Name_1
        MOVS     R0,#+0
        B.N      ??Compare_Dir_Name_3
//  343  }
//  344  return 1;
??Compare_Dir_Name_2:
        MOVS     R0,#+1
??Compare_Dir_Name_3:
        POP      {R4}
        BX       LR               ;; return
//  345 }
//  346 
//  347 /***********************************************************************
//  348  - 功能描述：文件名匹配(支持带*?通配符的文件名的匹配)
//  349  - 隶属模块：znFAT文件系统模块
//  350  - 函数属性：内部
//  351  - 参数说明：pat:源文件名，可以含*或?通配符 如 *.txt 或 A?.mp3等等
//  352              name:目标文件名
//  353  - 返回说明：如果两个文件名匹配就返回1，否则为0
//  354  - 注：关于通配文件名匹配，有这样的例子，比如 A*.txt 与 ABC.txt是匹配的
//  355    同时与 ABCDE.txt也是匹配的。此功能在文件枚举中将会用到，用来匹配
//  356    文件名符合一定条件的文件
//  357  ***********************************************************************/
//  358 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  359 uint8 FilenameMatch(int8 *pat,int8 *name)
//  360 {
FilenameMatch:
        PUSH     {R3-R7,LR}
        MOVS     R6,R0
        MOVS     R4,R1
//  361  int16 match,ndone;
//  362  int8 *cpp,*cpn;
//  363  cpp=pat;
//  364  cpn=name;
        MOVS     R0,R4
//  365  match=1;
        MOVS     R5,#+1
//  366  ndone=1;
        MOVS     R7,#+1
        B.N      ??FilenameMatch_0
//  367  while(ndone)
//  368  {
//  369   switch (*cpp)
//  370   {
//  371    case '*':
//  372             cpp++;
//  373             cpn=strchr(cpn,*cpp);
//  374             if(cpn==NULL)
//  375             {
//  376              cpn=name;
//  377              while(*cpn) cpn++;
??FilenameMatch_1:
        ADDS     R0,R0,#+1
??FilenameMatch_2:
        LDRB     R1,[R0, #+0]
        CMP      R1,#+0
        BNE.N    ??FilenameMatch_1
//  378             }
//  379             break;
??FilenameMatch_3:
??FilenameMatch_0:
        SXTH     R7,R7            ;; SignExt  R7,R7,#+16,#+16
        CMP      R7,#+0
        BEQ.N    ??FilenameMatch_4
        LDRB     R1,[R6, #+0]
        CMP      R1,#+0
        BEQ.N    ??FilenameMatch_5
        CMP      R1,#+42
        BEQ.N    ??FilenameMatch_6
        CMP      R1,#+63
        BEQ.N    ??FilenameMatch_7
        B.N      ??FilenameMatch_8
??FilenameMatch_6:
        ADDS     R6,R6,#+1
        LDRB     R1,[R6, #+0]
        BL       strchr
        CMP      R0,#+0
        BNE.N    ??FilenameMatch_3
        MOVS     R0,R4
        B.N      ??FilenameMatch_2
//  380    case '?':
//  381             cpp++;
??FilenameMatch_7:
        ADDS     R6,R6,#+1
//  382             cpn++;
        ADDS     R0,R0,#+1
//  383             break;
        B.N      ??FilenameMatch_0
//  384    case 0:
//  385             if(*cpn!=0)
??FilenameMatch_5:
        LDRB     R1,[R0, #+0]
        CMP      R1,#+0
        BEQ.N    ??FilenameMatch_9
//  386             match=0;
        MOVS     R5,#+0
//  387             ndone=0;
??FilenameMatch_9:
        MOVS     R7,#+0
//  388             break;
        B.N      ??FilenameMatch_0
//  389    default:
//  390             if((*cpp)==(*cpn))
??FilenameMatch_8:
        LDRB     R1,[R6, #+0]
        LDRB     R2,[R0, #+0]
        CMP      R1,R2
        BNE.N    ??FilenameMatch_10
//  391             {
//  392              cpp++;
        ADDS     R6,R6,#+1
//  393              cpn++;
        ADDS     R0,R0,#+1
        B.N      ??FilenameMatch_11
//  394             }
//  395             else
//  396             {
//  397              match=0;
??FilenameMatch_10:
        MOVS     R5,#+0
//  398              ndone=0;
        MOVS     R7,#+0
//  399             }
//  400             break;
??FilenameMatch_11:
        B.N      ??FilenameMatch_0
//  401   }
//  402  }
//  403  return(match);
??FilenameMatch_4:
        MOVS     R0,R5
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        POP      {R1,R4-R7,PC}    ;; return
//  404 }
//  405 
//  406 /***********************************************************************
//  407  - 功能描述：FAT32的文件目录项的文件名字段(8个字节)，转为普通的文件名
//  408              如：ABC     MP3 将转为 ABC.MP3
//  409  - 隶属模块：znFAT文件系统模块
//  410  - 函数属性：内部
//  411  - 参数说明：dName：指向文件目录项的文件名字段的指针
//  412              pName：指向转换完成后的文件名
//  413  - 返回说明：无
//  414  - 注：此函数配合上面的FilenameMatch函数，就可以实现对文件名通配匹配
//  415  ***********************************************************************/
//  416 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  417 void FAT32_toFileName(char *dName,char *pName)
//  418 {
FAT32_toFileName:
        PUSH     {R3-R7,LR}
        MOVS     R4,R0
        MOVS     R5,R1
//  419  char i=7,j=0,k=0;
        MOVS     R6,#+7
        MOVS     R7,#+0
        MOVS     R0,#+0
//  420  while(dName[i--]==' ');
??FAT32_toFileName_0:
        MOVS     R0,R6
        SUBS     R6,R0,#+1
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LDRB     R0,[R0, R4]
        CMP      R0,#+32
        BEQ.N    ??FAT32_toFileName_0
//  421  for(j=0;j<i+2;j++) pName[j]=L2U(dName[j]);
        MOVS     R7,#+0
        B.N      ??FAT32_toFileName_1
??FAT32_toFileName_2:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        LDRB     R0,[R7, R4]
        BL       L2U
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        STRB     R0,[R7, R5]
        ADDS     R7,R7,#+1
??FAT32_toFileName_1:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        ADDS     R0,R6,#+2
        CMP      R7,R0
        BLT.N    ??FAT32_toFileName_2
//  422  pName[j++]='.';
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        MOVS     R0,#+46
        STRB     R0,[R7, R5]
        ADDS     R7,R7,#+1
//  423  i=10;
        MOVS     R6,#+10
//  424  while(dName[i--]==' ');
??FAT32_toFileName_3:
        MOVS     R0,R6
        SUBS     R6,R0,#+1
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LDRB     R0,[R0, R4]
        CMP      R0,#+32
        BEQ.N    ??FAT32_toFileName_3
//  425  k=j+i-6;
        ADDS     R0,R6,R7
        SUBS     R0,R0,#+6
//  426  i=0;
        MOVS     R6,#+0
        B.N      ??FAT32_toFileName_4
//  427  for(;j<k;j++) pName[j]=dName[8+(i++)];
??FAT32_toFileName_5:
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        ADDS     R1,R6,R4
        LDRB     R1,[R1, #+8]
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        STRB     R1,[R7, R5]
        ADDS     R6,R6,#+1
        ADDS     R7,R7,#+1
??FAT32_toFileName_4:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R7,R0
        BCC.N    ??FAT32_toFileName_5
//  428  pName[j]=0; 
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        MOVS     R0,#+0
        STRB     R0,[R7, R5]
//  429 }
        POP      {R0,R4-R7,PC}    ;; return
//  430 
//  431 /***********************************************************************
//  432  - 功能描述：将字符串中的小写字符都转为大写字符
//  433  - 隶属模块：znFAT文件系统模块
//  434  - 函数属性：内部
//  435  - 参数说明：str：指向待转换的字符串
//  436  - 返回说明：无
//  437  - 注：短文件名的情况下，文件名中的字符其实都是大写字符，为了方便，将文件
//  438        名都转为大写
//  439  ***********************************************************************/
//  440 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  441 void Str2Up(char *str)
//  442 {
Str2Up:
        PUSH     {R4-R6,LR}
        MOVS     R4,R0
//  443  unsigned char len=strlen(str),i;
        MOVS     R0,R4
        BL       strlen
        MOVS     R5,R0
//  444  for(i=0;i<len;i++)
        MOVS     R6,#+0
        B.N      ??Str2Up_0
//  445  {
//  446   str[i]=L2U(str[i]); 
??Str2Up_1:
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        LDRB     R0,[R6, R4]
        BL       L2U
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        STRB     R0,[R6, R4]
//  447  } 
        ADDS     R6,R6,#+1
??Str2Up_0:
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        CMP      R6,R5
        BCC.N    ??Str2Up_1
//  448 }
        POP      {R4-R6,PC}       ;; return
//  449 
//  450 /**************************************************************************
//  451  - 功能描述：进入一个目录
//  452  - 隶属模块：znFAT文件系统模块
//  453  - 函数属性：外部，使用户使用
//  454  - 参数说明：path:目录的路径 形如："\\dir1\\dir2\\" ，最后一定是以\\结束 
//  455  - 返回说明：返回目录的开始簇号，如果进入目录失败，比如目录不存在，则返回0
//  456  - 注：此函数由后面的FAT32_Open_File等函数调用，用来实现打开任意目录下的文件
//  457        不建议用户调用
//  458  **************************************************************************/
//  459 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  460 uint32 FAT32_Enter_Dir(int8 *path)
//  461 {
FAT32_Enter_Dir:
        PUSH     {R0,R4-R11,LR}
        SUB      SP,SP,#+24
//  462  uint32 Cur_Clust,sec_temp,iSec,iDir,Old_Clust;
//  463  uint8 i=1,counter=0,flag=0;
        MOVS     R5,#+1
        MOVS     R6,#+0
        MOVS     R7,#+0
//  464  struct direntry *pDir;
//  465  int8 name[20];
//  466 
//  467  Cur_Clust=pArg->FirstDirClust;
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDR      R4,[R0, #+8]
//  468  if(path[1]==0 && path[0]=='\\') return Cur_Clust;
        LDR      R0,[SP, #+24]
        LDRB     R0,[R0, #+1]
        CMP      R0,#+0
        BNE.N    ??FAT32_Enter_Dir_0
        LDR      R0,[SP, #+24]
        LDRB     R0,[R0, #+0]
        CMP      R0,#+92
        BNE.N    ??FAT32_Enter_Dir_0
        MOVS     R0,R4
        B.N      ??FAT32_Enter_Dir_1
//  469  else
//  470  {
//  471   while(path[i]!=0)
//  472   {
//  473    if(path[i]=='\\')
//  474    {
//  475     for(;counter<8;counter++)
//  476 	{
//  477 	 name[counter]=' ';
//  478 	}
//  479 	name[counter]=0;
//  480 	counter=0;
//  481 	
//  482 	do
//  483 	{
//  484 	 sec_temp=(SOC(Cur_Clust));
//  485 	 for(iSec=sec_temp;iSec<sec_temp+pArg->SectorsPerClust;iSec++)
//  486 	 {
//  487 	  FAT32_ReadSector(iSec,FAT32_Buffer);
//  488 	  for(iDir=0;iDir<pArg->BytesPerSector;iDir+=sizeof(struct direntry))
//  489       {
//  490        pDir=((struct direntry *)(FAT32_Buffer+iDir));
//  491 	   if(Compare_Dir_Name(pDir->deName,name))
//  492 	   {
//  493 	    flag=1;
//  494 		Cur_Clust=LE2BE(pDir->deLowCluster,2)+LE2BE(pDir->deHighClust,2)*65536;
//  495 		iDir=pArg->BytesPerSector;
//  496 		iSec=sec_temp+pArg->SectorsPerClust;
//  497 	   } 
//  498 	  }
//  499 	 }
//  500 	 Old_Clust=Cur_Clust;
//  501 	}while(!flag && (Cur_Clust=FAT32_GetNextCluster(Cur_Clust))!=0x0fffffff);
//  502 	if(!flag) 
//  503 	{
//  504 	 temp_dir_cluster=Old_Clust;
//  505 	 strcpy(temp_dir_name,name);
//  506 	 flag=0;
//  507 	 return 0;
//  508 	}
//  509 	flag=0; 
//  510    }
//  511    else
//  512    {
//  513     name[counter++]=(L2U(path[i]));
??FAT32_Enter_Dir_2:
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        LDR      R0,[SP, #+24]
        LDRB     R0,[R5, R0]
        BL       L2U
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        ADD      R1,SP,#+0
        STRB     R0,[R6, R1]
        ADDS     R6,R6,#+1
//  514    }
//  515    i++;
??FAT32_Enter_Dir_3:
        ADDS     R5,R5,#+1
??FAT32_Enter_Dir_0:
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        LDR      R0,[SP, #+24]
        LDRB     R0,[R5, R0]
        CMP      R0,#+0
        BEQ.W    ??FAT32_Enter_Dir_4
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        LDR      R0,[SP, #+24]
        LDRB     R0,[R5, R0]
        CMP      R0,#+92
        BNE.N    ??FAT32_Enter_Dir_2
        B.N      ??FAT32_Enter_Dir_5
??FAT32_Enter_Dir_6:
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        ADD      R0,SP,#+0
        MOVS     R1,#+32
        STRB     R1,[R6, R0]
        ADDS     R6,R6,#+1
??FAT32_Enter_Dir_5:
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        CMP      R6,#+8
        BCC.N    ??FAT32_Enter_Dir_6
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        ADD      R0,SP,#+0
        MOVS     R1,#+0
        STRB     R1,[R6, R0]
        MOVS     R6,#+0
??FAT32_Enter_Dir_7:
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+8]
        SUBS     R0,R4,R0
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R8,R1,R0,R2
        MOV      R10,R8
        B.N      ??FAT32_Enter_Dir_8
??FAT32_Enter_Dir_9:
        LDR.W    R0,??DataTable14
        ADDS     R9,R11,R0
        ADD      R1,SP,#+0
        MOV      R0,R9
        BL       Compare_Dir_Name
        CMP      R0,#+0
        BEQ.N    ??FAT32_Enter_Dir_10
        MOVS     R7,#+1
        MOVS     R1,#+2
        ADDS     R0,R9,#+26
        BL       LE2BE
        MOVS     R4,R0
        MOVS     R1,#+2
        ADDS     R0,R9,#+20
        BL       LE2BE
        MOVS     R1,#+65536
        MLA      R4,R1,R0,R4
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDR      R11,[R0, #+12]
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+20]
        ADDS     R10,R0,R8
??FAT32_Enter_Dir_10:
        ADDS     R11,R11,#+32
??FAT32_Enter_Dir_11:
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+12]
        CMP      R11,R0
        BCC.N    ??FAT32_Enter_Dir_9
        ADDS     R10,R10,#+1
??FAT32_Enter_Dir_8:
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+20]
        ADDS     R0,R0,R8
        CMP      R10,R0
        BCS.N    ??FAT32_Enter_Dir_12
        LDR.W    R1,??DataTable14
        MOV      R0,R10
        BL       FAT32_ReadSector
        MOVS     R11,#+0
        B.N      ??FAT32_Enter_Dir_11
??FAT32_Enter_Dir_12:
        MOV      R8,R4
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        CMP      R7,#+0
        BNE.N    ??FAT32_Enter_Dir_13
        MOVS     R0,R4
        BL       FAT32_GetNextCluster
        MOVS     R4,R0
        MVNS     R1,#-268435456
        CMP      R0,R1
        BNE.N    ??FAT32_Enter_Dir_7
??FAT32_Enter_Dir_13:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        CMP      R7,#+0
        BNE.N    ??FAT32_Enter_Dir_14
        LDR.W    R0,??DataTable17
        STR      R8,[R0, #+0]
        ADD      R1,SP,#+0
        LDR.W    R0,??DataTable17_1
        BL       strcpy
        MOVS     R7,#+0
        MOVS     R0,#+0
        B.N      ??FAT32_Enter_Dir_1
??FAT32_Enter_Dir_14:
        MOVS     R7,#+0
        B.N      ??FAT32_Enter_Dir_3
//  516   }
//  517  }
//  518  name[counter]=0; 
??FAT32_Enter_Dir_4:
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        ADD      R0,SP,#+0
        MOVS     R1,#+0
        STRB     R1,[R6, R0]
//  519  flag=1;
        MOVS     R7,#+1
//  520  temp_dir_cluster=Cur_Clust;
        LDR.W    R0,??DataTable17
        STR      R4,[R0, #+0]
//  521  strcpy(temp_dir_name,name);
        ADD      R1,SP,#+0
        LDR.W    R0,??DataTable17_1
        BL       strcpy
//  522  return Cur_Clust;
        MOVS     R0,R4
??FAT32_Enter_Dir_1:
        ADD      SP,SP,#+28
        POP      {R4-R11,PC}      ;; return
//  523 }
//  524 
//  525 /**************************************************************************
//  526  - 功能描述：打开一个文件(支持文件名通配，如 A*.txt 或 *.*)
//  527  - 隶属模块：znFAT文件系统模块
//  528  - 函数属性：外部，使用户使用
//  529  - 参数说明：pfi: FileInfoStruct类型的结构体指针，用来装载文件的参数信息
//  530               比如文件的大小、文件的名称、文件的开始簇等等，以备后面使用
//  531              filepath: 文件的路径，支持任意层目录 比如
//  532               "\\dir1\\dir2\\dir3\\....\\test.txt"
//  533 			 item：在文件名中有通配符*或?的情况下，实现与之匹配的文件并非
//  534 			 一个，item就是打开的文件的项数，比如符合通配条件的文件有6个，
//  535 			 如果item=3，那么此函数就会打开这6个文件中按顺序排号为3的那个
//  536 			 文件(item编号从0开始)
//  537  - 返回说明：0：成功 1：文件不存在 2：目录不存在
//  538  - 注：打开文件不成功有很多原因，比如文件不存在、文件的某一级目录不存在
//  539        通配情况下满足条件的文件项数小于item的值等等
//  540 	   通常情况下，文件名中没有通配符，item的值我们取0就可以了
//  541  **************************************************************************/
//  542 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  543 uint8 FAT32_Open_File(struct FileInfoStruct *pfi,int8 *filepath,unsigned long item)
//  544 {
FAT32_Open_File:
        PUSH     {R2,R4-R11,LR}
        SUB      SP,SP,#+16
        MOVS     R5,R0
//  545  uint32 Cur_Clust,sec_temp,iSec,iFile,iItem=0;
        MOVS     R6,#+0
//  546  uint8 flag=0,index=0,i=0;
        MOVS     R7,#+0
        MOVS     R0,#+0
        MOVS     R2,#+0
        B.N      ??FAT32_Open_File_0
//  547  struct direntry *pFile;
//  548  int8 temp_file_name[13];
//  549  while(filepath[i]!=0)
//  550  {
//  551   if(filepath[i]=='\\') index=i;
??FAT32_Open_File_1:
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        LDRB     R0,[R2, R1]
        CMP      R0,#+92
        BNE.N    ??FAT32_Open_File_2
        MOVS     R0,R2
//  552   i++;
??FAT32_Open_File_2:
        ADDS     R2,R2,#+1
//  553  }
??FAT32_Open_File_0:
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        LDRB     R0,[R2, R1]
        CMP      R0,#+0
        BNE.N    ??FAT32_Open_File_1
//  554 
//  555  if(Cur_Clust=FAT32_Enter_Dir(filepath))
        MOVS     R0,R1
        BL       FAT32_Enter_Dir
        MOVS     R4,R0
        CMP      R0,#+0
        BEQ.W    ??FAT32_Open_File_3
//  556  {
//  557   Str2Up(temp_dir_name);
        LDR.W    R0,??DataTable17_1
        BL       Str2Up
//  558  do
//  559  { 
//  560   sec_temp=SOC(Cur_Clust);
??FAT32_Open_File_4:
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+8]
        SUBS     R0,R4,R0
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R11,R1,R0,R2
//  561   for(iSec=sec_temp;iSec<sec_temp+pArg->SectorsPerClust;iSec++)
        MOV      R8,R11
        B.N      ??FAT32_Open_File_5
??FAT32_Open_File_6:
        ADDS     R8,R8,#+1
??FAT32_Open_File_5:
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+20]
        ADDS     R0,R0,R11
        CMP      R8,R0
        BCS.W    ??FAT32_Open_File_7
//  562   {	
//  563    FAT32_ReadSector(iSec,FAT32_Buffer);
        LDR.W    R1,??DataTable14
        MOV      R0,R8
        BL       FAT32_ReadSector
//  564    for(iFile=0;iFile<pArg->BytesPerSector;iFile+=sizeof(struct direntry))
        MOVS     R9,#+0
        B.N      ??FAT32_Open_File_8
//  565    {
//  566     pFile=((struct direntry *)(FAT32_Buffer+iFile));
//  567 	FAT32_toFileName(pFile->deName,temp_file_name);
//  568 	if(FilenameMatch(temp_dir_name,temp_file_name) && pFile->deName[0]!=0xe5 && pFile->deAttributes&0x20) //匹配文件名
//  569 	{
//  570 	 if(item==iItem)
//  571 	 {	 
//  572 	 flag=1;
//  573      Cur_Clust=LE2BE(pFile->deLowCluster,2)+LE2BE(pFile->deHighClust,2)*65536;
//  574 
//  575      pfi->FileSize=LE2BE(pFile->deFileSize,4);
//  576 	 strcpy(pfi->FileName,temp_file_name);
//  577 	 pfi->FileStartCluster=LE2BE(pFile->deLowCluster,2)+LE2BE(pFile->deHighClust,2)*65536;
//  578 	 pfi->FileCurCluster=pfi->FileStartCluster;
//  579 	 pfi->FileCurSector=SOC(pfi->FileStartCluster);
//  580 	 pfi->FileCurPos=0;
//  581 	 pfi->FileCurOffset=0;
//  582 	 pfi->Rec_Sec=iSec;
//  583 	 pfi->nRec=iFile;
//  584 
//  585 	 pfi->FileAttr=pFile->deAttributes;
//  586 	 sec_temp=LE2BE(pFile->deCTime,2);
//  587 	 (pfi->FileCreateTime).sec=(sec_temp&0x001f)*2;
//  588 	 (pfi->FileCreateTime).min=((sec_temp>>5)&0x003f);
//  589 	 (pfi->FileCreateTime).hour=((sec_temp>>11)&0x001f);
//  590 	 sec_temp=LE2BE(pFile->deCDate,2);
//  591 	 (pfi->FileCreateDate).day=((sec_temp)&0x001f);
//  592 	 (pfi->FileCreateDate).month=((sec_temp>>5)&0x000f);
//  593 	 (pfi->FileCreateDate).year=((sec_temp>>9)&0x007f)+1980;
//  594 
//  595 	 sec_temp=LE2BE(pFile->deMTime,2);
//  596 	 (pfi->FileMTime).sec=(sec_temp&0x001f)*2;
//  597 	 (pfi->FileMTime).min=((sec_temp>>5)&0x003f);
//  598 	 (pfi->FileMTime).hour=((sec_temp>>11)&0x001f);
//  599 	 sec_temp=LE2BE(pFile->deMDate,2);
//  600 	 (pfi->FileMDate).day=((sec_temp)&0x001f);
//  601 	 (pfi->FileMDate).month=((sec_temp>>5)&0x000f);
//  602 	 (pfi->FileMDate).year=((sec_temp>>9)&0x007f)+1980;
//  603 
//  604 	 sec_temp=LE2BE(pFile->deADate,2);
//  605 	 (pfi->FileADate).day=((sec_temp)&0x001f);
//  606 	 (pfi->FileADate).month=((sec_temp>>5)&0x000f);
//  607 	 (pfi->FileADate).year=((sec_temp>>9)&0x007f)+1980;
//  608 	    
//  609 	 iFile=pArg->BytesPerSector;
//  610 	 iSec=sec_temp+pArg->SectorsPerClust;
//  611 	 }
//  612 	 else
//  613 	 {
//  614 	  iItem++;
??FAT32_Open_File_9:
        ADDS     R6,R6,#+1
//  615 	 }
??FAT32_Open_File_10:
        ADDS     R9,R9,#+32
??FAT32_Open_File_8:
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+12]
        CMP      R9,R0
        BCS.N    ??FAT32_Open_File_6
        LDR.W    R0,??DataTable14
        ADDS     R10,R9,R0
        ADD      R1,SP,#+0
        MOV      R0,R10
        BL       FAT32_toFileName
        ADD      R1,SP,#+0
        LDR.W    R0,??DataTable17_1
        BL       FilenameMatch
        CMP      R0,#+0
        BEQ.N    ??FAT32_Open_File_10
        LDRB     R0,[R10, #+0]
        CMP      R0,#+229
        BEQ.N    ??FAT32_Open_File_10
        LDRB     R0,[R10, #+11]
        LSLS     R0,R0,#+26
        BPL.N    ??FAT32_Open_File_10
        LDR      R0,[SP, #+16]
        CMP      R0,R6
        BNE.N    ??FAT32_Open_File_9
        MOVS     R7,#+1
        MOVS     R1,#+2
        ADDS     R0,R10,#+26
        BL       LE2BE
        MOVS     R4,R0
        MOVS     R1,#+2
        ADDS     R0,R10,#+20
        BL       LE2BE
        MOVS     R1,#+65536
        MLA      R4,R1,R0,R4
        MOVS     R1,#+4
        ADDS     R0,R10,#+28
        BL       LE2BE
        STR      R0,[R5, #+20]
        ADD      R1,SP,#+0
        MOVS     R0,R5
        BL       strcpy
        MOVS     R1,#+2
        ADDS     R0,R10,#+26
        BL       LE2BE
        MOV      R11,R0
        MOVS     R1,#+2
        ADDS     R0,R10,#+20
        BL       LE2BE
        MOVS     R1,#+65536
        MLA      R0,R1,R0,R11
        STR      R0,[R5, #+12]
        LDR      R0,[R5, #+12]
        STR      R0,[R5, #+16]
        LDR      R0,[R5, #+12]
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+8]
        SUBS     R0,R0,R1
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R0,R1,R0,R2
        STR      R0,[R5, #+24]
        MOVS     R0,#+0
        STRH     R0,[R5, #+28]
        MOVS     R0,#+0
        STR      R0,[R5, #+32]
        STR      R8,[R5, #+36]
        STRH     R9,[R5, #+40]
        LDRB     R0,[R10, #+11]
        STRB     R0,[R5, #+42]
        MOVS     R1,#+2
        ADDS     R0,R10,#+14
        BL       LE2BE
        MOV      R11,R0
        ANDS     R0,R11,#0x1F
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LSLS     R0,R0,#+1
        STRB     R0,[R5, #+45]
        LSRS     R0,R11,#+5
        ANDS     R0,R0,#0x3F
        STRB     R0,[R5, #+44]
        LSRS     R0,R11,#+11
        ANDS     R0,R0,#0x1F
        STRB     R0,[R5, #+43]
        MOVS     R1,#+2
        ADDS     R0,R10,#+16
        BL       LE2BE
        MOV      R11,R0
        ANDS     R0,R11,#0x1F
        STRB     R0,[R5, #+49]
        LSRS     R0,R11,#+5
        ANDS     R0,R0,#0xF
        STRB     R0,[R5, #+48]
        UBFX     R0,R11,#+9,#+7
        ADDW     R0,R0,#+1980
        STRH     R0,[R5, #+46]
        MOVS     R1,#+2
        ADDS     R0,R10,#+22
        BL       LE2BE
        MOV      R11,R0
        ANDS     R0,R11,#0x1F
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LSLS     R0,R0,#+1
        STRB     R0,[R5, #+52]
        LSRS     R0,R11,#+5
        ANDS     R0,R0,#0x3F
        STRB     R0,[R5, #+51]
        LSRS     R0,R11,#+11
        ANDS     R0,R0,#0x1F
        STRB     R0,[R5, #+50]
        MOVS     R1,#+2
        ADDS     R0,R10,#+24
        BL       LE2BE
        MOV      R11,R0
        ANDS     R0,R11,#0x1F
        STRB     R0,[R5, #+57]
        LSRS     R0,R11,#+5
        ANDS     R0,R0,#0xF
        STRB     R0,[R5, #+56]
        UBFX     R0,R11,#+9,#+7
        ADDW     R0,R0,#+1980
        STRH     R0,[R5, #+54]
        MOVS     R1,#+2
        ADDS     R0,R10,#+18
        BL       LE2BE
        MOV      R11,R0
        ANDS     R0,R11,#0x1F
        STRB     R0,[R5, #+61]
        LSRS     R0,R11,#+5
        ANDS     R0,R0,#0xF
        STRB     R0,[R5, #+60]
        UBFX     R0,R11,#+9,#+7
        ADDW     R0,R0,#+1980
        STRH     R0,[R5, #+58]
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDR      R9,[R0, #+12]
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+20]
        ADDS     R8,R0,R11
        B.N      ??FAT32_Open_File_10
//  616 	} 
//  617    }
//  618   }
//  619  }while(!flag && (Cur_Clust=FAT32_GetNextCluster(Cur_Clust))!=0x0fffffff);
??FAT32_Open_File_7:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        CMP      R7,#+0
        BNE.N    ??FAT32_Open_File_11
        MOVS     R0,R4
        BL       FAT32_GetNextCluster
        MOVS     R4,R0
        MVNS     R1,#-268435456
        CMP      R0,R1
        BNE.W    ??FAT32_Open_File_4
//  620  if(!flag) 
??FAT32_Open_File_11:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        CMP      R7,#+0
        BNE.N    ??FAT32_Open_File_12
//  621  {
//  622   return 1;
        MOVS     R0,#+1
        B.N      ??FAT32_Open_File_13
//  623  }
//  624  return 0;
??FAT32_Open_File_12:
        MOVS     R0,#+0
        B.N      ??FAT32_Open_File_13
//  625  }
//  626  else
//  627  {
//  628   return 2; 
??FAT32_Open_File_3:
        MOVS     R0,#+2
??FAT32_Open_File_13:
        ADD      SP,SP,#+20
        POP      {R4-R11,PC}      ;; return
//  629  }
//  630 }
//  631 
//  632 /**************************************************************************
//  633  - 功能描述：文件定位
//  634  - 隶属模块：znFAT文件系统模块
//  635  - 函数属性：外部，使用户使用
//  636  - 参数说明：pfi:FileInfoStruct类型的结构体指针，用于装载文件参数信息，文件
//  637              定位后，pfi所指向的结构体中的相关参数就被更新了，比如文件的当前
//  638              扇区，文件当前扇区中的位置，文件的当前偏移量等等，以备后面使用
//  639              offset:要定位的偏移量，如果offset大于文件的大小，则定位到文件的
//  640              末尾
//  641  - 返回说明：文件定位成功返回0，否则为1
//  642  - 注：此函数被下面的FAT32_Read_File调用，用于实现从指定位置读取数据，不建议
//  643        用户直接调用些函数
//  644  **************************************************************************/
//  645 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  646 uint8 FAT32_Seek_File(struct FileInfoStruct *pfi,uint32 offset)
//  647 {
FAT32_Seek_File:
        PUSH     {R3-R7,LR}
        MOVS     R4,R0
        MOVS     R5,R1
//  648  uint32 i,temp;
//  649 
//  650 if(offset<=pfi->FileSize)
        LDR      R0,[R4, #+20]
        CMP      R0,R5
        BCC.W    ??FAT32_Seek_File_0
//  651 { 
//  652  if(offset==pfi->FileCurOffset)
        LDR      R0,[R4, #+32]
        CMP      R5,R0
        BNE.N    ??FAT32_Seek_File_1
//  653  {
//  654   pfi->FileCurPos%=pArg->BytesPerSector;
        LDRH     R0,[R4, #+28]
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        UDIV     R2,R0,R1
        MLS      R0,R1,R2,R0
        STRH     R0,[R4, #+28]
//  655   return 1;  
        MOVS     R0,#+1
        B.N      ??FAT32_Seek_File_2
//  656  }
//  657  if(offset<pfi->FileCurOffset) 
??FAT32_Seek_File_1:
        LDR      R0,[R4, #+32]
        CMP      R5,R0
        BCS.N    ??FAT32_Seek_File_3
//  658  {
//  659   pfi->FileCurCluster=pfi->FileStartCluster;
        LDR      R0,[R4, #+12]
        STR      R0,[R4, #+16]
//  660   pfi->FileCurSector=SOC(pfi->FileCurCluster);
        LDR      R0,[R4, #+16]
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+8]
        SUBS     R0,R0,R1
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R0,R1,R0,R2
        STR      R0,[R4, #+24]
//  661   pfi->FileCurPos=0;
        MOVS     R0,#+0
        STRH     R0,[R4, #+28]
//  662   pfi->FileCurOffset=0;
        MOVS     R0,#+0
        STR      R0,[R4, #+32]
//  663  } 
//  664  if((offset-pfi->FileCurOffset)>=(pArg->BytesPerSector-pfi->FileCurPos))	 //目标偏移量与文件当前偏移量所差的字节数不小于文件在当前扇区中的位置到扇区末尾的字节数
??FAT32_Seek_File_3:
        LDR      R0,[R4, #+32]
        SUBS     R0,R5,R0
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        LDRH     R2,[R4, #+28]
        SUBS     R1,R1,R2
        CMP      R0,R1
        BCC.W    ??FAT32_Seek_File_4
//  665  {
//  666   pfi->FileCurOffset+=(pArg->BytesPerSector-pfi->FileCurPos);
        LDR      R0,[R4, #+32]
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        ADDS     R0,R1,R0
        LDRH     R1,[R4, #+28]
        SUBS     R0,R0,R1
        STR      R0,[R4, #+32]
//  667   pfi->FileCurPos=0;
        MOVS     R0,#+0
        STRH     R0,[R4, #+28]
//  668   if(pfi->FileCurSector-SOC(pfi->FileCurCluster)==(pArg->SectorsPerClust-1))
        LDR      R0,[R4, #+24]
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+8]
        LDR      R3,[R4, #+16]
        SUBS     R2,R2,R3
        MLA      R0,R2,R1,R0
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+28]
        SUBS     R0,R0,R1
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        SUBS     R1,R1,#+1
        CMP      R0,R1
        BNE.N    ??FAT32_Seek_File_5
//  669   {
//  670    pfi->FileCurCluster=FAT32_GetNextCluster(pfi->FileCurCluster);
        LDR      R0,[R4, #+16]
        BL       FAT32_GetNextCluster
        STR      R0,[R4, #+16]
//  671    pfi->FileCurSector=SOC(pfi->FileCurCluster);
        LDR      R0,[R4, #+16]
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+8]
        SUBS     R0,R0,R1
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R0,R1,R0,R2
        STR      R0,[R4, #+24]
        B.N      ??FAT32_Seek_File_6
//  672   }
//  673   else
//  674   {
//  675    pfi->FileCurSector++; 
??FAT32_Seek_File_5:
        LDR      R0,[R4, #+24]
        ADDS     R0,R0,#+1
        STR      R0,[R4, #+24]
//  676   }
//  677  }
//  678  else
//  679  {
//  680   pfi->FileCurPos=(pfi->FileCurPos+offset-pfi->FileCurOffset)%pArg->BytesPerSector;
//  681   pfi->FileCurOffset=offset;
//  682   return 1;
//  683  }
//  684  temp=SOC(pfi->FileCurCluster);
??FAT32_Seek_File_6:
        LDR      R0,[R4, #+16]
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+8]
        SUBS     R0,R0,R1
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R6,R1,R0,R2
//  685  if((offset-(pfi->FileCurOffset))/pArg->BytesPerSector+(pfi->FileCurSector-temp)>(pArg->SectorsPerClust-1))
        LDR      R0,[R4, #+32]
        SUBS     R0,R5,R0
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        UDIV     R0,R0,R1
        LDR      R1,[R4, #+24]
        ADDS     R0,R1,R0
        SUBS     R0,R0,R6
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        SUBS     R1,R1,#+1
        CMP      R1,R0
        BCS.N    ??FAT32_Seek_File_7
//  686  {
//  687   pfi->FileCurOffset+=(((pArg->SectorsPerClust)-(pfi->FileCurSector-(SOC(pfi->FileCurCluster))))*pArg->BytesPerSector);
        LDR      R0,[R4, #+32]
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR      R2,[R4, #+24]
        SUBS     R1,R1,R2
        LDR.W    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+20]
        LDR.W    R3,??DataTable14_2
        LDR      R3,[R3, #+0]
        LDR      R3,[R3, #+8]
        LDR      R6,[R4, #+16]
        SUBS     R3,R3,R6
        MLS      R1,R3,R2,R1
        LDR.W    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        ADDS     R1,R2,R1
        LDR.W    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+12]
        MLA      R0,R2,R1,R0
        STR      R0,[R4, #+32]
//  688   pfi->FileCurCluster=FAT32_GetNextCluster(pfi->FileCurCluster);
        LDR      R0,[R4, #+16]
        BL       FAT32_GetNextCluster
        STR      R0,[R4, #+16]
//  689   pfi->FileCurSector=SOC(pfi->FileCurCluster);
        LDR      R0,[R4, #+16]
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+8]
        SUBS     R0,R0,R1
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R0,R1,R0,R2
        STR      R0,[R4, #+24]
//  690   pfi->FileCurPos=0;
        MOVS     R0,#+0
        STRH     R0,[R4, #+28]
//  691  }
//  692  else
//  693  {
//  694   pfi->FileCurSector+=(offset-pfi->FileCurOffset)/pArg->BytesPerSector;
//  695   pfi->FileCurPos=(offset-pfi->FileCurOffset)%pArg->BytesPerSector;
//  696   pfi->FileCurOffset=offset;
//  697   return 1;
//  698  }
//  699 
//  700  temp=(offset-pfi->FileCurOffset)/(pArg->BytesPerSector*pArg->SectorsPerClust);
        LDR      R0,[R4, #+32]
        SUBS     R0,R5,R0
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        LDR.W    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+20]
        MULS     R1,R2,R1
        UDIV     R6,R0,R1
//  701  for(i=0;i<temp;i++)
        MOVS     R7,#+0
        B.N      ??FAT32_Seek_File_8
??FAT32_Seek_File_4:
        LDRH     R0,[R4, #+28]
        UXTAH    R0,R5,R0
        LDR      R1,[R4, #+32]
        SUBS     R0,R0,R1
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        UDIV     R2,R0,R1
        MLS      R0,R1,R2,R0
        STRH     R0,[R4, #+28]
        STR      R5,[R4, #+32]
        MOVS     R0,#+1
        B.N      ??FAT32_Seek_File_2
??FAT32_Seek_File_7:
        LDR      R0,[R4, #+24]
        LDR      R1,[R4, #+32]
        SUBS     R1,R5,R1
        LDR.W    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+12]
        UDIV     R1,R1,R2
        ADDS     R0,R1,R0
        STR      R0,[R4, #+24]
        LDR      R0,[R4, #+32]
        SUBS     R0,R5,R0
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        UDIV     R2,R0,R1
        MLS      R0,R1,R2,R0
        STRH     R0,[R4, #+28]
        STR      R5,[R4, #+32]
        MOVS     R0,#+1
        B.N      ??FAT32_Seek_File_2
//  702  {
//  703   pfi->FileCurCluster=FAT32_GetNextCluster(pfi->FileCurCluster);
??FAT32_Seek_File_9:
        LDR      R0,[R4, #+16]
        BL       FAT32_GetNextCluster
        STR      R0,[R4, #+16]
//  704  }
        ADDS     R7,R7,#+1
??FAT32_Seek_File_8:
        CMP      R7,R6
        BCC.N    ??FAT32_Seek_File_9
//  705  pfi->FileCurOffset+=(temp*(pArg->BytesPerSector*pArg->SectorsPerClust));
        LDR      R0,[R4, #+32]
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        MUL      R1,R1,R6
        LDR.N    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+20]
        MLA      R0,R2,R1,R0
        STR      R0,[R4, #+32]
//  706  pfi->FileCurSector=(SOC(pfi->FileCurCluster))+(offset-pfi->FileCurOffset)/pArg->BytesPerSector;
        LDR      R0,[R4, #+16]
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+8]
        SUBS     R0,R0,R1
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.N    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R0,R1,R0,R2
        LDR      R1,[R4, #+32]
        SUBS     R1,R5,R1
        LDR.N    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+12]
        UDIV     R1,R1,R2
        ADDS     R0,R1,R0
        STR      R0,[R4, #+24]
//  707  pfi->FileCurPos=((offset-pfi->FileCurOffset))%pArg->BytesPerSector;
        LDR      R0,[R4, #+32]
        SUBS     R0,R5,R0
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        UDIV     R2,R0,R1
        MLS      R0,R1,R2,R0
        STRH     R0,[R4, #+28]
//  708  pfi->FileCurOffset=offset;
        STR      R5,[R4, #+32]
//  709 }
//  710 else
//  711 {
//  712  return 1;
//  713 }
//  714  return 0;
        MOVS     R0,#+0
        B.N      ??FAT32_Seek_File_2
??FAT32_Seek_File_0:
        MOVS     R0,#+1
??FAT32_Seek_File_2:
        POP      {R1,R4-R7,PC}    ;; return
//  715 }
//  716 
//  717 /**************************************************************************
//  718  - 功能描述：从文件的某一个位置处，读取一定长度的数据，放入数据缓冲区中
//  719  - 隶属模块：znFAT文件系统模块
//  720  - 函数属性：外部，使用户使用
//  721  - 参数说明：pfi:FileInfoStruct类型的结构体指针，用于装载文件参数信息，文件
//  722              读取的过程中，此结构体中的相关参数会更新，比如文件的当前偏移量、
//  723              文件的当前扇区，文件的当前簇等等
//  724              offset:要定位的偏移量，要小于文件的大小 
//  725              len:要读取的数据的长度，如果len+offset大于文件的大小，则实际读
//  726              取的数据量是从offset开始到文件结束
//  727              pbuf:数据缓冲区
//  728  - 返回说明：读取到的实际的数据长度，如果读取失败，比如指定的偏移量大于了文件
//  729              大小，则返回0
//  730  - 注：在读取一个文件的数据前，必须先将该文件用FAT32_Open_File打开
//  731  **************************************************************************/
//  732 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  733 uint32 FAT32_Read_File(struct FileInfoStruct *pfi,uint32 offset,uint32 len,uint8 *pbuf)
//  734 {
FAT32_Read_File:
        PUSH     {R4-R10,LR}
        MOVS     R4,R0
        MOVS     R5,R2
        MOVS     R6,R3
//  735  uint32 i,j,k,temp;
//  736  uint32 counter=0;
        MOVS     R10,#+0
//  737  if(offset<pfi->FileSize)
        LDR      R0,[R4, #+20]
        CMP      R1,R0
        BCS.W    ??FAT32_Read_File_0
//  738  {
//  739   if(offset+len>pfi->FileSize) len=pfi->FileSize-offset;
        LDR      R0,[R4, #+20]
        ADDS     R2,R5,R1
        CMP      R0,R2
        BCS.N    ??FAT32_Read_File_1
        LDR      R0,[R4, #+20]
        SUBS     R5,R0,R1
//  740   FAT32_Seek_File(pfi,offset);
??FAT32_Read_File_1:
        MOVS     R0,R4
        BL       FAT32_Seek_File
//  741   
//  742   FAT32_ReadSector(pfi->FileCurSector,FAT32_Buffer);
        LDR.N    R1,??DataTable14
        LDR      R0,[R4, #+24]
        BL       FAT32_ReadSector
//  743   for(i=pfi->FileCurPos;i<pArg->BytesPerSector;i++)
        LDRH     R0,[R4, #+28]
        B.N      ??FAT32_Read_File_2
//  744   {
//  745    if(counter>=len) 
//  746    {
//  747      return len;
//  748    }
//  749    pbuf[counter]=FAT32_Buffer[i];
??FAT32_Read_File_3:
        LDR.N    R1,??DataTable14
        LDRB     R1,[R0, R1]
        STRB     R1,[R10, R6]
//  750    counter++;
        ADDS     R10,R10,#+1
//  751    pfi->FileCurPos++;
        LDRH     R1,[R4, #+28]
        ADDS     R1,R1,#+1
        STRH     R1,[R4, #+28]
//  752    pfi->FileCurOffset++;
        LDR      R1,[R4, #+32]
        ADDS     R1,R1,#+1
        STR      R1,[R4, #+32]
        ADDS     R0,R0,#+1
??FAT32_Read_File_2:
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        CMP      R0,R1
        BCS.N    ??FAT32_Read_File_4
        CMP      R10,R5
        BCC.N    ??FAT32_Read_File_3
        MOVS     R0,R5
        B.N      ??FAT32_Read_File_5
//  753   }
//  754   if(pfi->FileCurSector-(SOC(pfi->FileCurCluster))!=(pArg->SectorsPerClust-1))
??FAT32_Read_File_4:
        LDR      R0,[R4, #+24]
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.N    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+8]
        LDR      R3,[R4, #+16]
        SUBS     R2,R2,R3
        MLA      R0,R2,R1,R0
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+28]
        SUBS     R0,R0,R1
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        SUBS     R1,R1,#+1
        CMP      R0,R1
        BEQ.N    ??FAT32_Read_File_6
//  755   {
//  756    for(j=pfi->FileCurSector+1;j<(SOC(pfi->FileCurCluster))+pArg->SectorsPerClust;j++)
        LDR      R0,[R4, #+24]
        ADDS     R9,R0,#+1
        B.N      ??FAT32_Read_File_7
??FAT32_Read_File_8:
        ADDS     R9,R9,#+1
??FAT32_Read_File_7:
        LDR      R0,[R4, #+16]
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+8]
        SUBS     R0,R0,R1
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.N    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R0,R1,R0,R2
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        ADDS     R0,R1,R0
        CMP      R9,R0
        BCS.N    ??FAT32_Read_File_6
//  757    {
//  758     FAT32_ReadSector(j,FAT32_Buffer);
        LDR.N    R1,??DataTable14
        MOV      R0,R9
        BL       FAT32_ReadSector
//  759     pfi->FileCurSector=j;
        STR      R9,[R4, #+24]
//  760     for(i=0;i<pArg->BytesPerSector;i++)
        MOVS     R0,#+0
        B.N      ??FAT32_Read_File_9
//  761     {
//  762      if(counter>=len)
//  763      {
//  764        return len;
//  765      }
//  766      pbuf[counter]=FAT32_Buffer[i];
??FAT32_Read_File_10:
        LDR.N    R1,??DataTable14
        LDRB     R1,[R0, R1]
        STRB     R1,[R10, R6]
//  767      counter++;
        ADDS     R10,R10,#+1
//  768      pfi->FileCurPos++;
        LDRH     R1,[R4, #+28]
        ADDS     R1,R1,#+1
        STRH     R1,[R4, #+28]
//  769      pfi->FileCurOffset++;
        LDR      R1,[R4, #+32]
        ADDS     R1,R1,#+1
        STR      R1,[R4, #+32]
        ADDS     R0,R0,#+1
??FAT32_Read_File_9:
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        CMP      R0,R1
        BCS.N    ??FAT32_Read_File_8
        CMP      R10,R5
        BCC.N    ??FAT32_Read_File_10
        MOVS     R0,R5
        B.N      ??FAT32_Read_File_5
//  770     }
//  771    }
//  772   } 
//  773   temp=(len-counter)/(pArg->BytesPerSector*pArg->SectorsPerClust);
??FAT32_Read_File_6:
        SUBS     R0,R5,R10
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        LDR.N    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+20]
        MULS     R1,R2,R1
        UDIV     R7,R0,R1
//  774   for(k=0;k<temp;k++)
        MOVS     R8,#+0
        B.N      ??FAT32_Read_File_11
??FAT32_Read_File_12:
        ADDS     R8,R8,#+1
??FAT32_Read_File_11:
        CMP      R8,R7
        BCS.N    ??FAT32_Read_File_13
//  775   {
//  776    pfi->FileCurCluster=FAT32_GetNextCluster(pfi->FileCurCluster);
        LDR      R0,[R4, #+16]
        BL       FAT32_GetNextCluster
        STR      R0,[R4, #+16]
//  777    for(j=(SOC(pfi->FileCurCluster));j<(SOC(pfi->FileCurCluster))+pArg->SectorsPerClust;j++)
        LDR      R0,[R4, #+16]
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+8]
        SUBS     R0,R0,R1
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.N    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R9,R1,R0,R2
        B.N      ??FAT32_Read_File_14
??FAT32_Read_File_15:
        ADDS     R9,R9,#+1
??FAT32_Read_File_14:
        LDR      R0,[R4, #+16]
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+8]
        SUBS     R0,R0,R1
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.N    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R0,R1,R0,R2
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        ADDS     R0,R1,R0
        CMP      R9,R0
        BCS.N    ??FAT32_Read_File_12
//  778    {
//  779     FAT32_ReadSector(j,FAT32_Buffer);
        LDR.N    R1,??DataTable14
        MOV      R0,R9
        BL       FAT32_ReadSector
//  780     pfi->FileCurSector=j;
        STR      R9,[R4, #+24]
//  781     for(i=0;i<pArg->BytesPerSector;i++)
        MOVS     R0,#+0
        B.N      ??FAT32_Read_File_16
//  782     {
//  783      if(counter>=len)  
//  784  	 {
//  785        return len;
//  786      }
//  787      pbuf[counter]=FAT32_Buffer[i];
??FAT32_Read_File_17:
        LDR.N    R1,??DataTable14
        LDRB     R1,[R0, R1]
        STRB     R1,[R10, R6]
//  788      counter++;
        ADDS     R10,R10,#+1
//  789      pfi->FileCurOffset++;
        LDR      R1,[R4, #+32]
        ADDS     R1,R1,#+1
        STR      R1,[R4, #+32]
//  790 	 pfi->FileCurPos++;
        LDRH     R1,[R4, #+28]
        ADDS     R1,R1,#+1
        STRH     R1,[R4, #+28]
//  791 	 pfi->FileCurPos%=pArg->BytesPerSector;
        LDRH     R1,[R4, #+28]
        LDR.N    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+12]
        UDIV     R3,R1,R2
        MLS      R1,R2,R3,R1
        STRH     R1,[R4, #+28]
        ADDS     R0,R0,#+1
??FAT32_Read_File_16:
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        CMP      R0,R1
        BCS.N    ??FAT32_Read_File_15
        CMP      R10,R5
        BCC.N    ??FAT32_Read_File_17
        MOVS     R0,R5
        B.N      ??FAT32_Read_File_5
//  792     } 
//  793    }    
//  794   }
//  795   pfi->FileCurCluster=FAT32_GetNextCluster(pfi->FileCurCluster);
??FAT32_Read_File_13:
        LDR      R0,[R4, #+16]
        BL       FAT32_GetNextCluster
        STR      R0,[R4, #+16]
//  796   temp=(SOC(pfi->FileCurCluster))+((len-counter)/pArg->BytesPerSector);
        LDR      R0,[R4, #+16]
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+8]
        SUBS     R0,R0,R1
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.N    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R0,R1,R0,R2
        SUBS     R1,R5,R10
        LDR.N    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+12]
        UDIV     R1,R1,R2
        ADDS     R7,R1,R0
//  797   pfi->FileCurSector=(SOC(pfi->FileCurCluster));
        LDR      R0,[R4, #+16]
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+8]
        SUBS     R0,R0,R1
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.N    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R0,R1,R0,R2
        STR      R0,[R4, #+24]
//  798   for(j=(SOC(pfi->FileCurCluster));j<temp;j++)
        LDR      R0,[R4, #+16]
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+8]
        SUBS     R0,R0,R1
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.N    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R9,R1,R0,R2
        B.N      ??FAT32_Read_File_18
??FAT32_Read_File_19:
        ADDS     R9,R9,#+1
??FAT32_Read_File_18:
        CMP      R9,R7
        BCS.N    ??FAT32_Read_File_20
//  799   {
//  800    FAT32_ReadSector(j,FAT32_Buffer);
        LDR.N    R1,??DataTable14
        MOV      R0,R9
        BL       FAT32_ReadSector
//  801    pfi->FileCurSector=j;
        STR      R9,[R4, #+24]
//  802    for(i=0;i<pArg->BytesPerSector;i++)
        MOVS     R0,#+0
        B.N      ??FAT32_Read_File_21
//  803    {
//  804     if(counter>=len) 
//  805     {
//  806       return len;
//  807     }
//  808     pbuf[counter]=FAT32_Buffer[i];
??FAT32_Read_File_22:
        LDR.N    R1,??DataTable14
        LDRB     R1,[R0, R1]
        STRB     R1,[R10, R6]
//  809     counter++;
        ADDS     R10,R10,#+1
//  810     pfi->FileCurPos++;
        LDRH     R1,[R4, #+28]
        ADDS     R1,R1,#+1
        STRH     R1,[R4, #+28]
//  811     pfi->FileCurPos%=pArg->BytesPerSector;
        LDRH     R1,[R4, #+28]
        LDR.N    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+12]
        UDIV     R3,R1,R2
        MLS      R1,R2,R3,R1
        STRH     R1,[R4, #+28]
//  812     pfi->FileCurOffset++;
        LDR      R1,[R4, #+32]
        ADDS     R1,R1,#+1
        STR      R1,[R4, #+32]
        ADDS     R0,R0,#+1
??FAT32_Read_File_21:
        LDR.N    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        CMP      R0,R1
        BCS.N    ??FAT32_Read_File_19
        CMP      R10,R5
        BCC.N    ??FAT32_Read_File_22
        MOVS     R0,R5
        B.N      ??FAT32_Read_File_5
//  813    }   
//  814   }
//  815   pfi->FileCurSector=j;
??FAT32_Read_File_20:
        STR      R9,[R4, #+24]
//  816   FAT32_ReadSector(pfi->FileCurSector,FAT32_Buffer);
        LDR.N    R1,??DataTable14
        LDR      R0,[R4, #+24]
        BL       FAT32_ReadSector
//  817   temp=len-counter;
        SUBS     R7,R5,R10
//  818   for(i=0;i<temp;i++)
        MOVS     R0,#+0
        B.N      ??FAT32_Read_File_23
//  819   {
//  820    if(counter>=len) 
//  821    {
//  822      return len;
//  823    }
//  824    pbuf[counter]=FAT32_Buffer[i];
??FAT32_Read_File_24:
        LDR.N    R1,??DataTable14
        LDRB     R1,[R0, R1]
        STRB     R1,[R10, R6]
//  825    counter++;
        ADDS     R10,R10,#+1
//  826    pfi->FileCurPos++;
        LDRH     R1,[R4, #+28]
        ADDS     R1,R1,#+1
        STRH     R1,[R4, #+28]
//  827    pfi->FileCurPos%=pArg->BytesPerSector;
        LDRH     R1,[R4, #+28]
        LDR.N    R2,??DataTable14_2
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+12]
        UDIV     R3,R1,R2
        MLS      R1,R2,R3,R1
        STRH     R1,[R4, #+28]
//  828    pfi->FileCurOffset++;  
        LDR      R1,[R4, #+32]
        ADDS     R1,R1,#+1
        STR      R1,[R4, #+32]
        ADDS     R0,R0,#+1
??FAT32_Read_File_23:
        CMP      R0,R7
        BCS.N    ??FAT32_Read_File_25
        CMP      R10,R5
        BCC.N    ??FAT32_Read_File_24
        MOVS     R0,R5
        B.N      ??FAT32_Read_File_5
//  829   }
//  830  }
//  831  else
//  832  {
//  833   len=0;
??FAT32_Read_File_0:
        MOVS     R5,#+0
//  834  }
//  835  return len;
??FAT32_Read_File_25:
        MOVS     R0,R5
??FAT32_Read_File_5:
        POP      {R4-R10,PC}      ;; return
//  836 }

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable14:
        DC32     FAT32_Buffer

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable14_1:
        DC32     FAT32_Buffer+0x1C6

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable14_2:
        DC32     pArg

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable14_3:
        DC32     FAT32_Buffer+0x20
//  837 
//  838 /**************************************************************************
//  839  - 功能描述：从文件某一位置读取一定长度的数据，由pfun所指向的函数来处理
//  840  - 隶属模块：znFAT文件系统模块
//  841  - 函数属性：外部，使用户使用
//  842  - 参数说明：pfi:FileInfoStruct类型的结构体指针，用于装载文件参数信息，文件
//  843              读取的过程中，此结构体中的相关参数会更新，比如文件的当前偏移量、
//  844              文件的当前扇区，文件的当前簇等等
//  845              offset:要定位的偏移量，要小于文件的大小 
//  846              len:要读取的数据的长度，如果len+offset大于文件的大小，则实际读
//  847              取的数据量是从offset开始到文件结束
//  848              pfun:对读取的数据的处理函数，pfun指向处理函数，这样可以灵活的
//  849              配置数据如何去处理，比如是放在缓冲区中，还是把数据通过串口发送
//  850              出去，只需要pfun去指向相应的处理函数可以了
//  851  - 返回说明：读取到的实际的数据长度，如果读取失败，比如指定的偏移量大于了文件
//  852              大小，则返回0
//  853  - 注：在读取一个文件的数据前，必须先将该文件用FAT32_Open_File打开
//  854  **************************************************************************/
//  855 /*
//  856 uint32 FAT32_Read_FileX(struct FileInfoStruct *pfi,uint32 offset,uint32 len,void (*pfun)(uint8))
//  857 {
//  858  uint32 i,j,k,temp;
//  859  uint32 counter=0;
//  860  if(offset<pfi->FileSize)
//  861  {
//  862   if(offset+len>pfi->FileSize) len=pfi->FileSize-offset;
//  863   FAT32_Seek_File(pfi,offset);
//  864   
//  865   FAT32_ReadSector(pfi->FileCurSector,FAT32_Buffer);
//  866   for(i=pfi->FileCurPos;i<pArg->BytesPerSector;i++)
//  867   {
//  868    if(counter>=len) 
//  869    {
//  870      return len;
//  871    }
//  872    (*pfun)(FAT32_Buffer[i]);
//  873    counter++;
//  874    pfi->FileCurPos++;
//  875    pfi->FileCurOffset++;
//  876   }
//  877   if(pfi->FileCurSector-(SOC(pfi->FileCurCluster))!=(pArg->SectorsPerClust-1))
//  878   {
//  879    for(j=pfi->FileCurSector+1;j<(SOC(pfi->FileCurCluster))+pArg->SectorsPerClust;j++)
//  880    {
//  881     FAT32_ReadSector(j,FAT32_Buffer);
//  882     pfi->FileCurSector=j;
//  883     for(i=0;i<pArg->BytesPerSector;i++)
//  884     {
//  885      if(counter>=len)
//  886      {
//  887        return len;
//  888      }
//  889      (*pfun)(FAT32_Buffer[i]);
//  890      counter++;
//  891      pfi->FileCurPos++;
//  892      pfi->FileCurOffset++;
//  893     }
//  894    }
//  895   } 
//  896   temp=(len-counter)/(pArg->BytesPerSector*pArg->SectorsPerClust);
//  897   for(k=0;k<temp;k++)
//  898   {
//  899    pfi->FileCurCluster=FAT32_GetNextCluster(pfi->FileCurCluster);
//  900    for(j=(SOC(pfi->FileCurCluster));j<(SOC(pfi->FileCurCluster))+pArg->SectorsPerClust;j++)
//  901    {
//  902     FAT32_ReadSector(j,FAT32_Buffer);
//  903     pfi->FileCurSector=j;
//  904     for(i=0;i<pArg->BytesPerSector;i++)
//  905     {
//  906      if(counter>=len)  
//  907  	 {
//  908        return len;
//  909      }
//  910      (*pfun)(FAT32_Buffer[i]);
//  911      counter++;
//  912      pfi->FileCurOffset++;
//  913 	 pfi->FileCurPos++;
//  914 	 pfi->FileCurPos%=pArg->BytesPerSector;
//  915     } 
//  916    }    
//  917   }
//  918   pfi->FileCurCluster=FAT32_GetNextCluster(pfi->FileCurCluster);
//  919   temp=(SOC(pfi->FileCurCluster))+((len-counter)/pArg->BytesPerSector);
//  920   pfi->FileCurSector=(SOC(pfi->FileCurCluster));
//  921   for(j=(SOC(pfi->FileCurCluster));j<temp;j++)
//  922   {
//  923    FAT32_ReadSector(j,FAT32_Buffer);
//  924    pfi->FileCurSector=j;
//  925    for(i=0;i<pArg->BytesPerSector;i++)
//  926    {
//  927     if(counter>=len) 
//  928     {
//  929       return len;
//  930     }
//  931     (*pfun)(FAT32_Buffer[i]);
//  932     counter++;
//  933     pfi->FileCurPos++;
//  934     pfi->FileCurPos%=pArg->BytesPerSector;
//  935     pfi->FileCurOffset++;
//  936    }   
//  937   }
//  938   pfi->FileCurSector=j;
//  939   FAT32_ReadSector(pfi->FileCurSector,FAT32_Buffer);
//  940   temp=len-counter;
//  941   for(i=0;i<temp;i++)
//  942   {
//  943    if(counter>=len) 
//  944    {
//  945      return len;
//  946    }
//  947    (*pfun)(FAT32_Buffer[i]);
//  948    counter++;
//  949    pfi->FileCurPos++;
//  950    pfi->FileCurPos%=pArg->BytesPerSector;
//  951    pfi->FileCurOffset++;  
//  952   }
//  953  }
//  954  else
//  955  {
//  956   len=0;
//  957  }
//  958  return len;
//  959 }
//  960 */
//  961 /**************************************************************************
//  962  - 功能描述：寻找可用的空闲簇
//  963  - 隶属模块：znFAT文件系统模块
//  964  - 函数属性：内部
//  965  - 参数说明：无
//  966  - 返回说明：如果找到了空闲簇，返回空闲簇的簇号，否则返回0
//  967  - 注：寻找空闲簇是创建目录/文件以及向文件写入数据的基础，它如果能很快的寻
//  968        找到空闲簇，那么创建目录/文件以及向文件写入数据这些操作也会比较快。
//  969        所以我们绝不会从最开始的簇依次去寻找，而是使用了二分搜索的算法，以达
//  970        到较好的效果。如果空闲簇没有找到，很有可能就说明存储设备已经没有空间
//  971        了
//  972  **************************************************************************/
//  973 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//  974 uint32 FAT32_Find_Free_Clust(unsigned char flag)
//  975 {
FAT32_Find_Free_Clust:
        PUSH     {R3-R7,LR}
        MOVS     R4,R0
//  976  uint32 iClu,iSec;
//  977  struct FAT32_FAT *pFAT;
//  978  for(iSec=pArg->FirstFATSector+temp_last_cluster/128;iSec<pArg->FirstFATSector+pArg->FATsectors;iSec++)
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+24]
        LDR.N    R1,??DataTable15_2
        LDR      R1,[R1, #+0]
        ADDS     R5,R0,R1, LSR #+7
        B.N      ??FAT32_Find_Free_Clust_0
??FAT32_Find_Free_Clust_1:
        ADDS     R5,R5,#+1
??FAT32_Find_Free_Clust_0:
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+24]
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+16]
        ADDS     R0,R1,R0
        CMP      R5,R0
        BCS.N    ??FAT32_Find_Free_Clust_2
//  979  {
//  980   FAT32_ReadSector(iSec,FAT32_Buffer);
        LDR.W    R1,??DataTable23
        MOVS     R0,R5
        BL       FAT32_ReadSector
//  981   pFAT=(struct FAT32_FAT *)FAT32_Buffer;
        LDR.W    R7,??DataTable23
//  982   for(iClu=0;iClu<pArg->BytesPerSector/4;iClu++)
        MOVS     R6,#+0
        B.N      ??FAT32_Find_Free_Clust_3
??FAT32_Find_Free_Clust_4:
        ADDS     R6,R6,#+1
??FAT32_Find_Free_Clust_3:
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+12]
        CMP      R6,R0, LSR #+2
        BCS.N    ??FAT32_Find_Free_Clust_1
//  983   {
//  984    if(LE2BE((uint8 *)(&((pFAT->Items))[iClu]),4)==0)
        MOVS     R1,#+4
        ADDS     R0,R7,R6, LSL #+2
        BL       LE2BE
        CMP      R0,#+0
        BNE.N    ??FAT32_Find_Free_Clust_4
//  985    {
//  986     if(!flag)
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        CMP      R4,#+0
        BNE.N    ??FAT32_Find_Free_Clust_5
//  987 	{
//  988 	 FAT32_Update_FSInfo_Free_Clu(0);
        MOVS     R0,#+0
        BL       FAT32_Update_FSInfo_Free_Clu
//  989 	 temp_last_cluster=128*(iSec-pArg->FirstFATSector)+iClu;	   
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+24]
        SUBS     R0,R5,R0
        MOVS     R1,#+128
        MLA      R0,R1,R0,R6
        LDR.N    R1,??DataTable15_2
        STR      R0,[R1, #+0]
//  990      return temp_last_cluster;
        LDR.N    R0,??DataTable15_2
        LDR      R0,[R0, #+0]
        B.N      ??FAT32_Find_Free_Clust_6
//  991 	}
//  992 	else
//  993 	{
//  994 	 FAT32_Update_FSInfo_Last_Clu(128*(iSec-pArg->FirstFATSector)+iClu);
??FAT32_Find_Free_Clust_5:
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+24]
        SUBS     R0,R5,R0
        MOVS     R1,#+128
        MLA      R0,R1,R0,R6
        BL       FAT32_Update_FSInfo_Last_Clu
//  995 	 return 128*(iSec-pArg->FirstFATSector)+iClu;
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+24]
        SUBS     R0,R5,R0
        MOVS     R1,#+128
        MLA      R0,R1,R0,R6
        B.N      ??FAT32_Find_Free_Clust_6
//  996 	}
//  997    }
//  998   }
//  999  }
// 1000  return 0;
??FAT32_Find_Free_Clust_2:
        MOVS     R0,#+0
??FAT32_Find_Free_Clust_6:
        POP      {R1,R4-R7,PC}    ;; return
// 1001 }

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable15:
        DC32     FAT32_Buffer+0x1EC

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable15_1:
        DC32     Dev_No

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable15_2:
        DC32     temp_last_cluster

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable15_3:
        DC32     FAT32_Buffer+0x1E8
// 1002 
// 1003 /**************************************************************************
// 1004  - 功能描述：填充文件/目录项
// 1005  - 隶属模块：znFAT文件系统模块
// 1006  - 函数属性：内部
// 1007  - 参数说明：prec:指向一个direntry类型的结构体，它的结构就是FAT32中文件/
// 1008              目录项的结构
// 1009              name:文件或目录的名称
// 1010              is_dir:指示这个文件/目录项是文件还是目录，分别用来实现文件、
// 1011              目录的创建 1表示创建目录 0表示创建文件
// 1012  - 返回说明：无
// 1013  - 注：这里创建文件或目录的方法是，先将文件或目录的信息填充到一个结构体中，
// 1014        然后再将这个结构体的数据写入到存储设备的相应的扇区的相应位置上去，这
// 1015        样就完成了文件或目录的创建。
// 1016        在填充文件或目录的信息时，文件或目录的首簇并没有填进去，而是全0
// 1017  **************************************************************************/
// 1018 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// 1019 void Fill_Rec_Inf(struct direntry *prec,int8 *name,uint8 is_dir,uint8 *ptd)
// 1020 {
Fill_Rec_Inf:
        PUSH     {R3-R9,LR}
        MOVS     R4,R0
        MOV      R8,R1
        MOVS     R6,R2
        MOVS     R5,R3
// 1021  uint8 i=0,len=0;
        MOVS     R7,#+0
        MOVS     R9,#+0
// 1022  uint16 temp;
// 1023 
// 1024  if(is_dir)
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        CMP      R6,#+0
        BEQ.N    ??Fill_Rec_Inf_0
// 1025  {
// 1026   len=strlen(name);
        MOV      R0,R8
        BL       strlen
        MOV      R9,R0
// 1027   if(len>8)
        UXTB     R9,R9            ;; ZeroExt  R9,R9,#+24,#+24
        CMP      R9,#+9
        BCC.N    ??Fill_Rec_Inf_1
// 1028   {
// 1029    for(i=0;i<6;i++)
        MOVS     R7,#+0
        B.N      ??Fill_Rec_Inf_2
// 1030    {
// 1031     (prec->deName)[i]=L2U(name[i]);
??Fill_Rec_Inf_3:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        LDRB     R0,[R7, R8]
        BL       L2U
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        STRB     R0,[R7, R4]
// 1032    }
        ADDS     R7,R7,#+1
??Fill_Rec_Inf_2:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        CMP      R7,#+6
        BCC.N    ??Fill_Rec_Inf_3
// 1033    (prec->deName)[6]='~';
        MOVS     R0,#+126
        STRB     R0,[R4, #+6]
// 1034    (prec->deName)[7]='1';
        MOVS     R0,#+49
        STRB     R0,[R4, #+7]
// 1035   }
// 1036   else
// 1037   {
// 1038    for(i=0;i<len;i++)
// 1039    {
// 1040     (prec->deName)[i]=L2U(name[i]);
// 1041    }
// 1042    for(;i<8;i++)
// 1043    {
// 1044     (prec->deName)[i]=' ';
// 1045    }
// 1046   }
// 1047   for(i=0;i<3;i++)
??Fill_Rec_Inf_4:
        MOVS     R7,#+0
??Fill_Rec_Inf_5:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        CMP      R7,#+3
        BCS.W    ??Fill_Rec_Inf_6
// 1048   {
// 1049    (prec->deExtension)[i]=' ';
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        ADDS     R0,R7,R4
        MOVS     R1,#+32
        STRB     R1,[R0, #+8]
// 1050   }
        ADDS     R7,R7,#+1
        B.N      ??Fill_Rec_Inf_5
??Fill_Rec_Inf_1:
        MOVS     R7,#+0
        B.N      ??Fill_Rec_Inf_7
??Fill_Rec_Inf_8:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        LDRB     R0,[R7, R8]
        BL       L2U
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        STRB     R0,[R7, R4]
        ADDS     R7,R7,#+1
??Fill_Rec_Inf_7:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        UXTB     R9,R9            ;; ZeroExt  R9,R9,#+24,#+24
        CMP      R7,R9
        BCC.N    ??Fill_Rec_Inf_8
??Fill_Rec_Inf_9:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        CMP      R7,#+8
        BCS.N    ??Fill_Rec_Inf_4
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        MOVS     R0,#+32
        STRB     R0,[R7, R4]
        ADDS     R7,R7,#+1
        B.N      ??Fill_Rec_Inf_9
// 1051  }
// 1052  else
// 1053  {
// 1054   while(name[len]!='.' && name[len]!=0) len++;
??Fill_Rec_Inf_10:
        ADDS     R9,R9,#+1
??Fill_Rec_Inf_0:
        UXTB     R9,R9            ;; ZeroExt  R9,R9,#+24,#+24
        LDRB     R0,[R9, R8]
        CMP      R0,#+46
        BEQ.N    ??Fill_Rec_Inf_11
        UXTB     R9,R9            ;; ZeroExt  R9,R9,#+24,#+24
        LDRB     R0,[R9, R8]
        CMP      R0,#+0
        BNE.N    ??Fill_Rec_Inf_10
// 1055   if(len>8)
??Fill_Rec_Inf_11:
        UXTB     R9,R9            ;; ZeroExt  R9,R9,#+24,#+24
        CMP      R9,#+9
        BCC.N    ??Fill_Rec_Inf_12
// 1056   {
// 1057    for(i=0;i<6;i++)
        MOVS     R7,#+0
        B.N      ??Fill_Rec_Inf_13
// 1058    {
// 1059     (prec->deName)[i]=L2U(name[i]);
??Fill_Rec_Inf_14:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        LDRB     R0,[R7, R8]
        BL       L2U
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        STRB     R0,[R7, R4]
// 1060    }
        ADDS     R7,R7,#+1
??Fill_Rec_Inf_13:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        CMP      R7,#+6
        BCC.N    ??Fill_Rec_Inf_14
// 1061    (prec->deName)[6]='~';
        MOVS     R0,#+126
        STRB     R0,[R4, #+6]
// 1062    (prec->deName)[7]='1';
        MOVS     R0,#+49
        STRB     R0,[R4, #+7]
// 1063   }
// 1064   else
// 1065   {
// 1066    for(i=0;i<len;i++)
// 1067    {
// 1068     (prec->deName)[i]=L2U(name[i]);
// 1069    }
// 1070    for(;i<8;i++)
// 1071    {
// 1072     (prec->deName)[i]=' ';
// 1073    }
// 1074   }
// 1075   if(name[len]==0)
??Fill_Rec_Inf_15:
        UXTB     R9,R9            ;; ZeroExt  R9,R9,#+24,#+24
        LDRB     R0,[R9, R8]
        CMP      R0,#+0
        BNE.N    ??Fill_Rec_Inf_16
// 1076   {
// 1077    for(i=0;i<3;i++)
        MOVS     R7,#+0
??Fill_Rec_Inf_17:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        CMP      R7,#+3
        BCS.N    ??Fill_Rec_Inf_6
// 1078    {
// 1079     (prec->deExtension)[i]=' ';
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        ADDS     R0,R7,R4
        MOVS     R1,#+32
        STRB     R1,[R0, #+8]
// 1080    }
        ADDS     R7,R7,#+1
        B.N      ??Fill_Rec_Inf_17
// 1081   }
??Fill_Rec_Inf_12:
        MOVS     R7,#+0
        B.N      ??Fill_Rec_Inf_18
??Fill_Rec_Inf_19:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        LDRB     R0,[R7, R8]
        BL       L2U
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        STRB     R0,[R7, R4]
        ADDS     R7,R7,#+1
??Fill_Rec_Inf_18:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        UXTB     R9,R9            ;; ZeroExt  R9,R9,#+24,#+24
        CMP      R7,R9
        BCC.N    ??Fill_Rec_Inf_19
??Fill_Rec_Inf_20:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        CMP      R7,#+8
        BCS.N    ??Fill_Rec_Inf_15
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        MOVS     R0,#+32
        STRB     R0,[R7, R4]
        ADDS     R7,R7,#+1
        B.N      ??Fill_Rec_Inf_20
// 1082   else
// 1083   {
// 1084    for(i=0;i<3;i++)
??Fill_Rec_Inf_16:
        MOVS     R7,#+0
        B.N      ??Fill_Rec_Inf_21
// 1085    {
// 1086     (prec->deExtension)[i]=' ';
??Fill_Rec_Inf_22:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        ADDS     R0,R7,R4
        MOVS     R1,#+32
        STRB     R1,[R0, #+8]
// 1087    }
        ADDS     R7,R7,#+1
??Fill_Rec_Inf_21:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        CMP      R7,#+3
        BCC.N    ??Fill_Rec_Inf_22
// 1088    len++;
        ADDS     R9,R9,#+1
// 1089    i=0;
        MOVS     R7,#+0
        B.N      ??Fill_Rec_Inf_23
// 1090    while(name[len]!=0)
// 1091    {
// 1092     (prec->deExtension)[i++]=L2U(name[len]);
??Fill_Rec_Inf_24:
        UXTB     R9,R9            ;; ZeroExt  R9,R9,#+24,#+24
        LDRB     R0,[R9, R8]
        BL       L2U
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        ADDS     R1,R7,R4
        STRB     R0,[R1, #+8]
        ADDS     R7,R7,#+1
// 1093 	len++;
        ADDS     R9,R9,#+1
// 1094    }
??Fill_Rec_Inf_23:
        UXTB     R9,R9            ;; ZeroExt  R9,R9,#+24,#+24
        LDRB     R0,[R9, R8]
        CMP      R0,#+0
        BNE.N    ??Fill_Rec_Inf_24
// 1095   }
// 1096  }
// 1097  if(is_dir)
??Fill_Rec_Inf_6:
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        CMP      R6,#+0
        BEQ.N    ??Fill_Rec_Inf_25
// 1098   (prec->deAttributes)=0x10;
        MOVS     R0,#+16
        STRB     R0,[R4, #+11]
        B.N      ??Fill_Rec_Inf_26
// 1099  else
// 1100   (prec->deAttributes)=0x20;
??Fill_Rec_Inf_25:
        MOVS     R0,#+32
        STRB     R0,[R4, #+11]
// 1101  
// 1102  temp=MAKE_FILE_TIME(ptd[3],ptd[4],ptd[5]);
??Fill_Rec_Inf_26:
        LDRB     R0,[R5, #+3]
        LDRB     R1,[R5, #+4]
        LSLS     R1,R1,#+5
        ADDS     R0,R1,R0, LSL #+11
        LDRB     R1,[R5, #+5]
        ADDS     R0,R0,R1, LSR #+1
// 1103  (prec->deCTime)[0]=temp;
        STRB     R0,[R4, #+14]
// 1104  (prec->deCTime)[1]=temp>>8;
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        LSRS     R0,R0,#+8
        STRB     R0,[R4, #+15]
// 1105  temp=MAKE_FILE_DATE(ptd[0],ptd[1],ptd[2]);
        LDRB     R0,[R5, #+0]
        ADDS     R0,R0,#+20
        LDRB     R1,[R5, #+1]
        LSLS     R1,R1,#+5
        ADDS     R0,R1,R0, LSL #+9
        LDRB     R1,[R5, #+2]
        UXTAB    R0,R0,R1
// 1106  (prec->deCDate)[0]=temp;
        STRB     R0,[R4, #+16]
// 1107  (prec->deCDate)[1]=temp>>8;
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        LSRS     R0,R0,#+8
        STRB     R0,[R4, #+17]
// 1108 
// 1109  (prec->deLowerCase)=0;
        MOVS     R0,#+0
        STRB     R0,[R4, #+12]
// 1110  (prec->deHighClust)[0]=0;
        MOVS     R0,#+0
        STRB     R0,[R4, #+20]
// 1111  (prec->deHighClust)[1]=0;
        MOVS     R0,#+0
        STRB     R0,[R4, #+21]
// 1112  (prec->deLowCluster)[0]=0;
        MOVS     R0,#+0
        STRB     R0,[R4, #+26]
// 1113  (prec->deLowCluster)[1]=0;
        MOVS     R0,#+0
        STRB     R0,[R4, #+27]
// 1114  for(i=0;i<4;i++)
        MOVS     R7,#+0
        B.N      ??Fill_Rec_Inf_27
// 1115  {
// 1116   (prec->deFileSize)[i]=0;
??Fill_Rec_Inf_28:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        ADDS     R0,R7,R4
        MOVS     R1,#+0
        STRB     R1,[R0, #+28]
// 1117  }				
        ADDS     R7,R7,#+1
??Fill_Rec_Inf_27:
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        CMP      R7,#+4
        BCC.N    ??Fill_Rec_Inf_28
// 1118 }
        POP      {R0,R4-R9,PC}    ;; return
// 1119 
// 1120 /**************************************************************************
// 1121  - 功能描述：更新FAT表
// 1122  - 隶属模块：znFAT文件系统模块
// 1123  - 函数属性：内部
// 1124  - 参数说明：cluster:要更新的簇项号
// 1125              dat:要将相应的簇项更新为dat
// 1126  - 返回说明：无
// 1127  - 注：在向文件写入了数据后，需要对FAT表进行更表，以表明新数据的簇链关系 
// 1128        删除文件的时候，也需要将该文件的簇项进行清除，销毁文件的簇链关系
// 1129  **************************************************************************/
// 1130 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// 1131 void FAT32_Modify_FAT(uint32 cluster,uint32 dat)
// 1132 {
FAT32_Modify_FAT:
        PUSH     {R3-R5,LR}
        MOVS     R4,R0
        MOVS     R5,R1
// 1133  FAT32_ReadSector(pArg->FirstFATSector+(cluster*4/pArg->BytesPerSector),FAT32_Buffer);
        LDR.W    R1,??DataTable23
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+24]
        LSLS     R2,R4,#+2
        LDR.W    R3,??DataTable24
        LDR      R3,[R3, #+0]
        LDR      R3,[R3, #+12]
        UDIV     R2,R2,R3
        ADDS     R0,R2,R0
        BL       FAT32_ReadSector
// 1134  FAT32_Buffer[((cluster*4)%pArg->BytesPerSector)+0]=dat&0x000000ff;
        LSLS     R0,R4,#+2
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        UDIV     R2,R0,R1
        MLS      R0,R1,R2,R0
        LDR.W    R1,??DataTable23
        STRB     R5,[R0, R1]
// 1135  FAT32_Buffer[((cluster*4)%pArg->BytesPerSector)+1]=(dat&0x0000ff00)>>8;
        LSLS     R0,R4,#+2
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        UDIV     R2,R0,R1
        MLS      R0,R1,R2,R0
        LDR.W    R1,??DataTable23
        ADDS     R0,R0,R1
        LSRS     R1,R5,#+8
        STRB     R1,[R0, #+1]
// 1136  FAT32_Buffer[((cluster*4)%pArg->BytesPerSector)+2]=(dat&0x00ff0000)>>16;
        LSLS     R0,R4,#+2
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        UDIV     R2,R0,R1
        MLS      R0,R1,R2,R0
        LDR.W    R1,??DataTable23
        ADDS     R0,R0,R1
        LSRS     R1,R5,#+16
        STRB     R1,[R0, #+2]
// 1137  FAT32_Buffer[((cluster*4)%pArg->BytesPerSector)+3]=(dat&0xff000000)>>24;
        LSLS     R0,R4,#+2
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        UDIV     R2,R0,R1
        MLS      R0,R1,R2,R0
        LDR.W    R1,??DataTable23
        ADDS     R0,R0,R1
        LSRS     R1,R5,#+24
        STRB     R1,[R0, #+3]
// 1138  FAT32_WriteSector(pArg->FirstFATSector+(cluster*4/pArg->BytesPerSector),FAT32_Buffer);
        LDR.W    R1,??DataTable23
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+24]
        LSLS     R2,R4,#+2
        LDR.W    R3,??DataTable24
        LDR      R3,[R3, #+0]
        LDR      R3,[R3, #+12]
        UDIV     R2,R2,R3
        ADDS     R0,R2,R0
        BL       FAT32_WriteSector
// 1139 
// 1140  FAT32_ReadSector(pArg->FirstFATSector+pArg->FATsectors+(cluster*4/pArg->BytesPerSector),FAT32_Buffer);
        LDR.W    R1,??DataTable23
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+24]
        LDR.W    R2,??DataTable24
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+16]
        ADDS     R0,R2,R0
        LSLS     R2,R4,#+2
        LDR.W    R3,??DataTable24
        LDR      R3,[R3, #+0]
        LDR      R3,[R3, #+12]
        UDIV     R2,R2,R3
        ADDS     R0,R2,R0
        BL       FAT32_ReadSector
// 1141  FAT32_Buffer[((cluster*4)%pArg->BytesPerSector)+0]=dat&0x000000ff;
        LSLS     R0,R4,#+2
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        UDIV     R2,R0,R1
        MLS      R0,R1,R2,R0
        LDR.W    R1,??DataTable23
        STRB     R5,[R0, R1]
// 1142  FAT32_Buffer[((cluster*4)%pArg->BytesPerSector)+1]=(dat&0x0000ff00)>>8;
        LSLS     R0,R4,#+2
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        UDIV     R2,R0,R1
        MLS      R0,R1,R2,R0
        LDR.W    R1,??DataTable23
        ADDS     R0,R0,R1
        LSRS     R1,R5,#+8
        STRB     R1,[R0, #+1]
// 1143  FAT32_Buffer[((cluster*4)%pArg->BytesPerSector)+2]=(dat&0x00ff0000)>>16;
        LSLS     R0,R4,#+2
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        UDIV     R2,R0,R1
        MLS      R0,R1,R2,R0
        LDR.W    R1,??DataTable23
        ADDS     R0,R0,R1
        LSRS     R1,R5,#+16
        STRB     R1,[R0, #+2]
// 1144  FAT32_Buffer[((cluster*4)%pArg->BytesPerSector)+3]=(dat&0xff000000)>>24;
        LSLS     R0,R4,#+2
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        UDIV     R2,R0,R1
        MLS      R0,R1,R2,R0
        LDR.W    R1,??DataTable23
        ADDS     R0,R0,R1
        LSRS     R1,R5,#+24
        STRB     R1,[R0, #+3]
// 1145  FAT32_WriteSector(pArg->FirstFATSector+pArg->FATsectors+(cluster*4/pArg->BytesPerSector),FAT32_Buffer); 
        LDR.W    R1,??DataTable23
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+24]
        LDR.W    R2,??DataTable24
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+16]
        ADDS     R0,R2,R0
        LSLS     R2,R4,#+2
        LDR.W    R3,??DataTable24
        LDR      R3,[R3, #+0]
        LDR      R3,[R3, #+12]
        UDIV     R2,R2,R3
        ADDS     R0,R2,R0
        BL       FAT32_WriteSector
// 1146 }
        POP      {R0,R4,R5,PC}    ;; return
// 1147 
// 1148 /**************************************************************************
// 1149  - 功能描述：清空某个簇的所有扇区，填充0
// 1150  - 隶属模块：znFAT文件系统模块
// 1151  - 函数属性：内部
// 1152  - 参数说明：cluster:要清空的簇的簇号
// 1153  - 返回说明：无
// 1154  **************************************************************************/
// 1155 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// 1156 void FAT32_Empty_Cluster(uint32 Cluster)
// 1157 {
FAT32_Empty_Cluster:
        PUSH     {R3-R5,LR}
        MOVS     R4,R0
// 1158  uint32 iSec;
// 1159  uint16 i;
// 1160  for(i=0;i<pArg->BytesPerSector;i++)
        MOVS     R0,#+0
        B.N      ??FAT32_Empty_Cluster_0
// 1161  {
// 1162   FAT32_Buffer[i]=0;
??FAT32_Empty_Cluster_1:
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        LDR.W    R1,??DataTable23
        MOVS     R2,#+0
        STRB     R2,[R0, R1]
// 1163  }
        ADDS     R0,R0,#+1
??FAT32_Empty_Cluster_0:
        UXTH     R0,R0            ;; ZeroExt  R0,R0,#+16,#+16
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        CMP      R0,R1
        BCC.N    ??FAT32_Empty_Cluster_1
// 1164  for(iSec=SOC(Cluster);iSec<SOC(Cluster)+pArg->SectorsPerClust;iSec++)
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+8]
        SUBS     R0,R4,R0
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable24
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R5,R1,R0,R2
        B.N      ??FAT32_Empty_Cluster_2
// 1165  {
// 1166   FAT32_WriteSector(iSec,FAT32_Buffer);
??FAT32_Empty_Cluster_3:
        LDR.W    R1,??DataTable23
        MOVS     R0,R5
        BL       FAT32_WriteSector
// 1167  }
        ADDS     R5,R5,#+1
??FAT32_Empty_Cluster_2:
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+8]
        SUBS     R0,R4,R0
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable24
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R0,R1,R0,R2
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        ADDS     R0,R1,R0
        CMP      R5,R0
        BCC.N    ??FAT32_Empty_Cluster_3
// 1168 }
        POP      {R0,R4,R5,PC}    ;; return

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17:
        DC32     temp_dir_cluster

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable17_1:
        DC32     temp_dir_name
// 1169 
// 1170 /**************************************************************************
// 1171  - 功能描述：在存储设备中创建一个文件/目录项
// 1172  - 隶属模块：znFAT文件系统模块
// 1173  - 函数属性：内部
// 1174  - 参数说明：pfi:指向FileInfoStruct类型的结构体，用于装载刚创建的文件的信息
// 1175                  也就是说，如果创建的是目录，则此结构体不会被更新
// 1176              cluster:在cluster这个簇中创建文件/目录项，用于实现在任意目录下
// 1177                  创建文件或目录，可以通过FAT32_Enter_Dir来获取某一个目录的开
// 1178                  始簇
// 1179              name:文件/目录的名称
// 1180              is_dir:指示要创建的是文件还是目录，文件与目录的创建方法是不同的
// 1181                  1表示创建目录 0表示创建文件
// 1182  - 返回说明：成功返回1，失败返回-1
// 1183  **************************************************************************/
// 1184 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// 1185 uint8 FAT32_Create_Rec(struct FileInfoStruct *pfi,uint32 cluster,int8 *name,uint8 is_dir,uint8 *ptd)
// 1186 {
FAT32_Create_Rec:
        PUSH     {R0,R2,R4-R11,LR}
        SUB      SP,SP,#+12
        MOVS     R5,R1
        MOVS     R6,R3
// 1187  uint32 iSec,iRec,temp_sec,temp_clu,new_clu,i,old_clu;
// 1188  uint8 flag=0;
        MOVS     R8,#+0
// 1189  uint16 temp_Rec;
// 1190  struct direntry *pRec;
// 1191  Fill_Rec_Inf(&temp_rec,name,is_dir,ptd);
        LDR      R3,[SP, #+56]
        MOVS     R2,R6
        UXTB     R2,R2            ;; ZeroExt  R2,R2,#+24,#+24
        LDR      R1,[SP, #+16]
        LDR.W    R0,??DataTable24_1
        BL       Fill_Rec_Inf
// 1192  do
// 1193  {
// 1194   old_clu=cluster;
??FAT32_Create_Rec_0:
        STR      R5,[SP, #+4]
// 1195   temp_sec=SOC(cluster);
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+8]
        SUBS     R0,R5,R0
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable24
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R7,R1,R0,R2
// 1196   for(iSec=temp_sec;iSec<temp_sec+pArg->SectorsPerClust;iSec++)
        MOV      R10,R7
        B.N      ??FAT32_Create_Rec_1
??FAT32_Create_Rec_2:
        ADDS     R10,R10,#+1
??FAT32_Create_Rec_1:
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+20]
        ADDS     R0,R0,R7
        CMP      R10,R0
        BCS.N    ??FAT32_Create_Rec_3
// 1197   {
// 1198    FAT32_ReadSector(iSec,FAT32_Buffer);
        LDR.W    R1,??DataTable23
        MOV      R0,R10
        BL       FAT32_ReadSector
// 1199    for(iRec=0;iRec<pArg->BytesPerSector;iRec+=sizeof(struct direntry))
        MOVS     R9,#+0
        B.N      ??FAT32_Create_Rec_4
// 1200    {
// 1201     pRec=(struct direntry *)(FAT32_Buffer+iRec);
// 1202 	if((pRec->deName)[0]==0)
// 1203 	{
// 1204 	 flag=1;
// 1205 	 if(is_dir)
// 1206 	 {
// 1207 	  if(!(new_clu=FAT32_Find_Free_Clust(0))) return -1;
// 1208 	  FAT32_Modify_FAT(new_clu,0x0fffffff);
// 1209 	  (temp_rec.deHighClust)[0]=(new_clu&0x00ff0000)>>16;
// 1210       (temp_rec.deHighClust)[1]=(new_clu&0xff000000)>>24;
// 1211       (temp_rec.deLowCluster)[0]=(new_clu&0x000000ff);
// 1212       (temp_rec.deLowCluster)[1]=(new_clu&0x0000ff00)>>8;
// 1213 	 }
// 1214 	 FAT32_ReadSector(iSec,FAT32_Buffer);
// 1215 	 for(i=0;i<sizeof(struct direntry);i++)
// 1216 	 {
// 1217 	  ((uint8 *)pRec)[i]=((uint8 *)(&temp_rec))[i];
??FAT32_Create_Rec_5:
        LDR.W    R1,??DataTable24_1
        LDRB     R1,[R0, R1]
        STRB     R1,[R0, R11]
// 1218 	 }
        ADDS     R0,R0,#+1
??FAT32_Create_Rec_6:
        CMP      R0,#+32
        BCC.N    ??FAT32_Create_Rec_5
// 1219 	 FAT32_WriteSector(iSec,FAT32_Buffer);
        LDR.W    R1,??DataTable23
        MOV      R0,R10
        BL       FAT32_WriteSector
// 1220 	 temp_sec=iSec;
        MOV      R7,R10
// 1221 	 temp_Rec=iRec;
        STRH     R9,[SP, #+0]
// 1222 	 iRec=pArg->BytesPerSector;
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R9,[R0, #+12]
// 1223 	 iSec=temp_sec+pArg->SectorsPerClust;
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+20]
        ADDS     R10,R0,R7
??FAT32_Create_Rec_7:
        ADDS     R9,R9,#+32
??FAT32_Create_Rec_4:
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+12]
        CMP      R9,R0
        BCS.N    ??FAT32_Create_Rec_2
        LDR.W    R0,??DataTable23
        ADDS     R11,R9,R0
        LDRB     R0,[R11, #+0]
        CMP      R0,#+0
        BNE.N    ??FAT32_Create_Rec_7
        MOVS     R8,#+1
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        CMP      R6,#+0
        BEQ.N    ??FAT32_Create_Rec_8
        MOVS     R0,#+0
        BL       FAT32_Find_Free_Clust
        MOVS     R4,R0
        CMP      R0,#+0
        BNE.N    ??FAT32_Create_Rec_9
        MOVS     R0,#+255
        B.N      ??FAT32_Create_Rec_10
??FAT32_Create_Rec_9:
        MVNS     R1,#-268435456
        MOVS     R0,R4
        BL       FAT32_Modify_FAT
        LSRS     R0,R4,#+16
        LDR.W    R1,??DataTable24_1
        STRB     R0,[R1, #+20]
        LSRS     R0,R4,#+24
        LDR.W    R1,??DataTable24_1
        STRB     R0,[R1, #+21]
        LDR.W    R0,??DataTable24_1
        STRB     R4,[R0, #+26]
        LSRS     R0,R4,#+8
        LDR.W    R1,??DataTable24_1
        STRB     R0,[R1, #+27]
??FAT32_Create_Rec_8:
        LDR.W    R1,??DataTable23
        MOV      R0,R10
        BL       FAT32_ReadSector
        MOVS     R0,#+0
        B.N      ??FAT32_Create_Rec_6
// 1224 	}
// 1225    }
// 1226   }
// 1227  }while(!flag && (cluster=FAT32_GetNextCluster(cluster))!=0x0fffffff);
??FAT32_Create_Rec_3:
        UXTB     R8,R8            ;; ZeroExt  R8,R8,#+24,#+24
        CMP      R8,#+0
        BNE.N    ??FAT32_Create_Rec_11
        MOVS     R0,R5
        BL       FAT32_GetNextCluster
        MOVS     R5,R0
        MVNS     R1,#-268435456
        CMP      R0,R1
        BNE.W    ??FAT32_Create_Rec_0
// 1228  if(!flag)
??FAT32_Create_Rec_11:
        UXTB     R8,R8            ;; ZeroExt  R8,R8,#+24,#+24
        CMP      R8,#+0
        BNE.N    ??FAT32_Create_Rec_12
// 1229  {
// 1230   if(!(temp_clu=FAT32_Find_Free_Clust(0))) return -1;
        MOVS     R0,#+0
        BL       FAT32_Find_Free_Clust
        MOVS     R7,R0
        CMP      R7,#+0
        BNE.N    ??FAT32_Create_Rec_13
        MOVS     R0,#+255
        B.N      ??FAT32_Create_Rec_10
// 1231   FAT32_Modify_FAT(temp_clu,0x0fffffff);
??FAT32_Create_Rec_13:
        MVNS     R1,#-268435456
        MOVS     R0,R7
        BL       FAT32_Modify_FAT
// 1232   FAT32_Modify_FAT(old_clu,temp_clu);
        MOVS     R1,R7
        LDR      R0,[SP, #+4]
        BL       FAT32_Modify_FAT
// 1233   temp_sec=SOC(temp_clu);
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+8]
        SUBS     R0,R7,R0
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable24
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R7,R1,R0,R2
// 1234   temp_Rec=0;
        MOVS     R0,#+0
        STRH     R0,[SP, #+0]
// 1235   FAT32_ReadSector(temp_sec,FAT32_Buffer);
        LDR.W    R1,??DataTable23
        MOVS     R0,R7
        BL       FAT32_ReadSector
// 1236   if(is_dir)
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        CMP      R6,#+0
        BEQ.N    ??FAT32_Create_Rec_14
// 1237   {
// 1238    if(!(new_clu=FAT32_Find_Free_Clust(0))) return -1;
        MOVS     R0,#+0
        BL       FAT32_Find_Free_Clust
        MOVS     R4,R0
        CMP      R0,#+0
        BNE.N    ??FAT32_Create_Rec_15
        MOVS     R0,#+255
        B.N      ??FAT32_Create_Rec_10
// 1239    FAT32_Modify_FAT(new_clu,0x0fffffff);
??FAT32_Create_Rec_15:
        MVNS     R1,#-268435456
        MOVS     R0,R4
        BL       FAT32_Modify_FAT
// 1240    FAT32_ReadSector(temp_sec,FAT32_Buffer);
        LDR.W    R1,??DataTable23
        MOVS     R0,R7
        BL       FAT32_ReadSector
// 1241    (temp_rec.deHighClust)[0]=(new_clu&0x00ff0000)>>16;
        LSRS     R0,R4,#+16
        LDR.W    R1,??DataTable24_1
        STRB     R0,[R1, #+20]
// 1242    (temp_rec.deHighClust)[1]=(new_clu&0xff000000)>>24;
        LSRS     R0,R4,#+24
        LDR.W    R1,??DataTable24_1
        STRB     R0,[R1, #+21]
// 1243    (temp_rec.deLowCluster)[0]=(new_clu&0x000000ff);
        LDR.W    R0,??DataTable24_1
        STRB     R4,[R0, #+26]
// 1244    (temp_rec.deLowCluster)[1]=(new_clu&0x0000ff00)>>8;
        LSRS     R0,R4,#+8
        LDR.W    R1,??DataTable24_1
        STRB     R0,[R1, #+27]
// 1245   }
// 1246   for(i=0;i<sizeof(struct direntry);i++)
??FAT32_Create_Rec_14:
        MOVS     R0,#+0
        B.N      ??FAT32_Create_Rec_16
// 1247   {
// 1248    FAT32_Buffer[i]=((uint8 *)(&temp_rec))[i]; 
??FAT32_Create_Rec_17:
        LDR.W    R1,??DataTable23
        LDR.W    R2,??DataTable24_1
        LDRB     R2,[R0, R2]
        STRB     R2,[R0, R1]
// 1249   }
        ADDS     R0,R0,#+1
??FAT32_Create_Rec_16:
        CMP      R0,#+32
        BCC.N    ??FAT32_Create_Rec_17
// 1250   FAT32_WriteSector(temp_sec,FAT32_Buffer);
        LDR.W    R1,??DataTable23
        MOVS     R0,R7
        BL       FAT32_WriteSector
// 1251  }
// 1252  if(is_dir)
??FAT32_Create_Rec_12:
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        CMP      R6,#+0
        BEQ.W    ??FAT32_Create_Rec_18
// 1253  {
// 1254   FAT32_Empty_Cluster(new_clu);
        MOVS     R0,R4
        BL       FAT32_Empty_Cluster
// 1255 
// 1256   Fill_Rec_Inf(&temp_rec,".",1,ptd);
        LDR      R3,[SP, #+56]
        MOVS     R2,#+1
        ADR.N    R1,??DataTable18  ;; "."
        LDR.W    R0,??DataTable24_1
        BL       Fill_Rec_Inf
// 1257   (temp_rec.deHighClust)[0]=(new_clu&0x00ff0000)>>16;
        LSRS     R0,R4,#+16
        LDR.W    R1,??DataTable24_1
        STRB     R0,[R1, #+20]
// 1258   (temp_rec.deHighClust)[1]=(new_clu&0xff000000)>>24;
        LSRS     R0,R4,#+24
        LDR.W    R1,??DataTable24_1
        STRB     R0,[R1, #+21]
// 1259   (temp_rec.deLowCluster)[0]=(new_clu&0x000000ff);
        LDR.W    R0,??DataTable24_1
        STRB     R4,[R0, #+26]
// 1260   (temp_rec.deLowCluster)[1]=(new_clu&0x0000ff00)>>8;
        LSRS     R0,R4,#+8
        LDR.W    R1,??DataTable24_1
        STRB     R0,[R1, #+27]
// 1261   for(i=0;i<sizeof(struct direntry);i++)
        MOVS     R0,#+0
        B.N      ??FAT32_Create_Rec_19
// 1262   {
// 1263    FAT32_Buffer[i]=((uint8 *)(&temp_rec))[i]; 
??FAT32_Create_Rec_20:
        LDR.W    R1,??DataTable23
        LDR.W    R2,??DataTable24_1
        LDRB     R2,[R0, R2]
        STRB     R2,[R0, R1]
// 1264   }
        ADDS     R0,R0,#+1
??FAT32_Create_Rec_19:
        CMP      R0,#+32
        BCC.N    ??FAT32_Create_Rec_20
// 1265   Fill_Rec_Inf(&temp_rec,"..",1,ptd);
        LDR      R3,[SP, #+56]
        MOVS     R2,#+1
        ADR.N    R1,??DataTable18_1  ;; 0x2E, 0x2E, 0x00, 0x00
        LDR.W    R0,??DataTable24_1
        BL       Fill_Rec_Inf
// 1266   if(cluster==pArg->FirstDirClust)
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+8]
        CMP      R5,R0
        BNE.N    ??FAT32_Create_Rec_21
// 1267   {
// 1268    (temp_rec.deHighClust)[0]=0;
        LDR.W    R0,??DataTable24_1
        MOVS     R1,#+0
        STRB     R1,[R0, #+20]
// 1269    (temp_rec.deHighClust)[1]=0;
        LDR.W    R0,??DataTable24_1
        MOVS     R1,#+0
        STRB     R1,[R0, #+21]
// 1270    (temp_rec.deLowCluster)[0]=0;
        LDR.W    R0,??DataTable24_1
        MOVS     R1,#+0
        STRB     R1,[R0, #+26]
// 1271    (temp_rec.deLowCluster)[1]=0;
        LDR.W    R0,??DataTable24_1
        MOVS     R1,#+0
        STRB     R1,[R0, #+27]
        B.N      ??FAT32_Create_Rec_22
// 1272   }
// 1273   else
// 1274   {
// 1275    (temp_rec.deHighClust)[0]=(cluster&0x00ff0000)>>16;
??FAT32_Create_Rec_21:
        LSRS     R0,R5,#+16
        LDR.W    R1,??DataTable24_1
        STRB     R0,[R1, #+20]
// 1276    (temp_rec.deHighClust)[1]=(cluster&0xff000000)>>24;
        LSRS     R0,R5,#+24
        LDR.W    R1,??DataTable24_1
        STRB     R0,[R1, #+21]
// 1277    (temp_rec.deLowCluster)[0]=(cluster&0x000000ff);
        LDR.W    R0,??DataTable24_1
        STRB     R5,[R0, #+26]
// 1278    (temp_rec.deLowCluster)[1]=(cluster&0x0000ff00)>>8;
        LSRS     R0,R5,#+8
        LDR.W    R1,??DataTable24_1
        STRB     R0,[R1, #+27]
// 1279   }
// 1280     
// 1281   for(i=sizeof(struct direntry);i<2*sizeof(struct direntry);i++)
??FAT32_Create_Rec_22:
        MOVS     R0,#+32
        B.N      ??FAT32_Create_Rec_23
// 1282   {
// 1283    FAT32_Buffer[i]=((uint8 *)(&temp_rec))[i-sizeof(struct direntry)]; 
??FAT32_Create_Rec_24:
        LDR.W    R1,??DataTable24_1
        ADDS     R1,R0,R1
        LDRB     R1,[R1, #-32]
        LDR.W    R2,??DataTable23
        STRB     R1,[R0, R2]
// 1284   }
        ADDS     R0,R0,#+1
??FAT32_Create_Rec_23:
        CMP      R0,#+64
        BCC.N    ??FAT32_Create_Rec_24
// 1285   for(;i<pArg->BytesPerSector;i++)
??FAT32_Create_Rec_25:
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        CMP      R0,R1
        BCS.N    ??FAT32_Create_Rec_26
// 1286   {
// 1287    FAT32_Buffer[i]=0;
        LDR.W    R1,??DataTable23
        MOVS     R2,#+0
        STRB     R2,[R0, R1]
// 1288   }		
        ADDS     R0,R0,#+1
        B.N      ??FAT32_Create_Rec_25
// 1289   temp_sec=SOC(new_clu);
??FAT32_Create_Rec_26:
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+8]
        SUBS     R0,R4,R0
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable24
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R7,R1,R0,R2
// 1290   FAT32_WriteSector(temp_sec,FAT32_Buffer);
        LDR.W    R1,??DataTable23
        MOVS     R0,R7
        BL       FAT32_WriteSector
        B.N      ??FAT32_Create_Rec_27
// 1291  }
// 1292  else
// 1293  {
// 1294   strcpy(pfi->FileName,name);
??FAT32_Create_Rec_18:
        LDR      R1,[SP, #+16]
        LDR      R0,[SP, #+12]
        BL       strcpy
// 1295   pfi->FileStartCluster=0;
        LDR      R0,[SP, #+12]
        MOVS     R1,#+0
        STR      R1,[R0, #+12]
// 1296   pfi->FileCurCluster=0;
        LDR      R0,[SP, #+12]
        MOVS     R1,#+0
        STR      R1,[R0, #+16]
// 1297   pfi->FileSize=0;
        LDR      R0,[SP, #+12]
        MOVS     R1,#+0
        STR      R1,[R0, #+20]
// 1298   pfi->FileCurSector=0;
        LDR      R0,[SP, #+12]
        MOVS     R1,#+0
        STR      R1,[R0, #+24]
// 1299   pfi->FileCurPos=0;
        LDR      R0,[SP, #+12]
        MOVS     R1,#+0
        STRH     R1,[R0, #+28]
// 1300   pfi->FileCurOffset=0;
        LDR      R0,[SP, #+12]
        MOVS     R1,#+0
        STR      R1,[R0, #+32]
// 1301   pfi->Rec_Sec=temp_sec;
        LDR      R0,[SP, #+12]
        STR      R7,[R0, #+36]
// 1302   pfi->nRec=temp_Rec;
        LDR      R0,[SP, #+12]
        LDRH     R1,[SP, #+0]
        STRH     R1,[R0, #+40]
// 1303 
// 1304   pfi->FileAttr=temp_rec.deAttributes;
        LDR      R0,[SP, #+12]
        LDR.W    R1,??DataTable24_1
        LDRB     R1,[R1, #+11]
        STRB     R1,[R0, #+42]
// 1305  }
// 1306  FAT32_Find_Free_Clust(1);
??FAT32_Create_Rec_27:
        MOVS     R0,#+1
        BL       FAT32_Find_Free_Clust
// 1307  return 1;
        MOVS     R0,#+1
??FAT32_Create_Rec_10:
        ADD      SP,SP,#+20
        POP      {R4-R11,PC}      ;; return
// 1308 }

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable18:
        DC8      ".",0x0,0x0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable18_1:
        DC8      0x2E, 0x2E, 0x00, 0x00
// 1309 
// 1310 /**************************************************************************
// 1311  - 功能描述：向某一个文件追加数据
// 1312  - 隶属模块：znFAT文件系统模块
// 1313  - 函数属性：外部，使用户使用
// 1314  - 参数说明：pfi:指向FileInfoStruct类型的结构体，用于装载刚创建的文件的信息
// 1315              len:要追加的数据长度
// 1316              pbuf:指向数据缓冲区的指针
// 1317  - 返回说明：成功返回实际写入的数据长度，失败返回0
// 1318  - 注：追加数据失败很有可能是存储设备已经没有空间了，也就是找不到空闲簇了
// 1319  **************************************************************************/
// 1320 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// 1321 uint32 FAT32_Add_Dat(struct FileInfoStruct *pfi,uint32 len,uint8 *pbuf)
// 1322 {
FAT32_Add_Dat:
        PUSH     {R3-R11,LR}
        MOVS     R4,R0
        MOVS     R5,R1
        MOV      R8,R2
// 1323  uint32 i=0,counter=0,iSec,iClu;
        MOVS     R0,#+0
        MOVS     R9,#+0
// 1324  uint32 temp_sub,temp_file_size,new_clu,temp_sec;
// 1325  struct direntry *prec;
// 1326  if(len>0)
        CMP      R5,#+0
        BEQ.W    ??FAT32_Add_Dat_0
// 1327  {
// 1328   FAT32_ReadSector(pfi->Rec_Sec,FAT32_Buffer);
        LDR.W    R1,??DataTable23
        LDR      R0,[R4, #+36]
        BL       FAT32_ReadSector
// 1329   prec=(struct direntry *)(FAT32_Buffer+pfi->nRec);
        LDRH     R0,[R4, #+40]
        LDR.W    R1,??DataTable23
        ADDS     R10,R0,R1
// 1330   temp_file_size=LE2BE((prec->deFileSize),4);
        MOVS     R1,#+4
        ADDS     R0,R10,#+28
        BL       LE2BE
        MOVS     R6,R0
// 1331   if(!temp_file_size)
        CMP      R6,#+0
        BNE.N    ??FAT32_Add_Dat_1
// 1332   {   
// 1333    if(!(new_clu=FAT32_Find_Free_Clust(0))) return 0;
        MOVS     R0,#+0
        BL       FAT32_Find_Free_Clust
        MOVS     R7,R0
        CMP      R7,#+0
        BNE.N    ??FAT32_Add_Dat_2
        MOVS     R0,#+0
        B.N      ??FAT32_Add_Dat_3
// 1334    FAT32_Modify_FAT(new_clu,0x0fffffff);
??FAT32_Add_Dat_2:
        MVNS     R1,#-268435456
        MOVS     R0,R7
        BL       FAT32_Modify_FAT
// 1335    pfi->FileStartCluster=new_clu;
        STR      R7,[R4, #+12]
// 1336    pfi->FileCurCluster=pfi->FileStartCluster;
        LDR      R0,[R4, #+12]
        STR      R0,[R4, #+16]
// 1337    pfi->FileSize=0;
        MOVS     R0,#+0
        STR      R0,[R4, #+20]
// 1338    pfi->FileCurSector=SOC(pfi->FileCurCluster);
        LDR      R0,[R4, #+16]
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+8]
        SUBS     R0,R0,R1
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable24
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R0,R1,R0,R2
        STR      R0,[R4, #+24]
// 1339    pfi->FileCurPos=0;
        MOVS     R0,#+0
        STRH     R0,[R4, #+28]
// 1340    pfi->FileCurOffset=0;
        MOVS     R0,#+0
        STR      R0,[R4, #+32]
// 1341    FAT32_ReadSector(pfi->Rec_Sec,FAT32_Buffer);
        LDR.W    R1,??DataTable23
        LDR      R0,[R4, #+36]
        BL       FAT32_ReadSector
// 1342    (prec->deHighClust)[0]=(new_clu&0x00ff0000)>>16;
        LSRS     R0,R7,#+16
        STRB     R0,[R10, #+20]
// 1343    (prec->deHighClust)[1]=(new_clu&0xff000000)>>24;
        LSRS     R0,R7,#+24
        STRB     R0,[R10, #+21]
// 1344    (prec->deLowCluster)[0]=(new_clu&0x000000ff);
        STRB     R7,[R10, #+26]
// 1345    (prec->deLowCluster)[1]=(new_clu&0x0000ff00)>>8;
        LSRS     R0,R7,#+8
        STRB     R0,[R10, #+27]
// 1346    FAT32_WriteSector(pfi->Rec_Sec,FAT32_Buffer);
        LDR.W    R1,??DataTable23
        LDR      R0,[R4, #+36]
        BL       FAT32_WriteSector
        B.N      ??FAT32_Add_Dat_4
// 1347   }
// 1348   else
// 1349   {
// 1350    if(!(temp_file_size%(pArg->SectorsPerClust*pArg->BytesPerSector))) //在簇的最末尾临界地方，需要寻找新簇
??FAT32_Add_Dat_1:
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+20]
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        MULS     R0,R1,R0
        UDIV     R1,R6,R0
        MLS      R0,R0,R1,R6
        CMP      R0,#+0
        BNE.N    ??FAT32_Add_Dat_5
// 1351    {
// 1352     FAT32_Seek_File(pfi,pfi->FileSize-1);
        LDR      R0,[R4, #+20]
        SUBS     R1,R0,#+1
        MOVS     R0,R4
        BL       FAT32_Seek_File
// 1353     if(!(new_clu=FAT32_Find_Free_Clust(0))) return 0;
        MOVS     R0,#+0
        BL       FAT32_Find_Free_Clust
        MOVS     R7,R0
        CMP      R7,#+0
        BNE.N    ??FAT32_Add_Dat_6
        MOVS     R0,#+0
        B.N      ??FAT32_Add_Dat_3
// 1354 	FAT32_Modify_FAT(pfi->FileCurCluster,new_clu);
??FAT32_Add_Dat_6:
        MOVS     R1,R7
        LDR      R0,[R4, #+16]
        BL       FAT32_Modify_FAT
// 1355     FAT32_Modify_FAT(new_clu,0x0fffffff);     
        MVNS     R1,#-268435456
        MOVS     R0,R7
        BL       FAT32_Modify_FAT
// 1356    }
// 1357    FAT32_Seek_File(pfi,pfi->FileSize);
??FAT32_Add_Dat_5:
        LDR      R1,[R4, #+20]
        MOVS     R0,R4
        BL       FAT32_Seek_File
// 1358   }
// 1359 
// 1360   iSec=pfi->FileCurSector;
??FAT32_Add_Dat_4:
        LDR      R7,[R4, #+24]
// 1361 
// 1362   FAT32_ReadSector(iSec,FAT32_Buffer);
        LDR.W    R1,??DataTable23
        MOVS     R0,R7
        BL       FAT32_ReadSector
// 1363   for(i=pfi->FileCurPos;i<pArg->BytesPerSector;i++)
        LDRH     R0,[R4, #+28]
        B.N      ??FAT32_Add_Dat_7
??FAT32_Add_Dat_8:
        ADDS     R0,R0,#+1
??FAT32_Add_Dat_7:
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        CMP      R0,R1
        BCS.N    ??FAT32_Add_Dat_9
// 1364   {
// 1365    FAT32_Buffer[i]=pbuf[counter];
        LDRB     R1,[R9, R8]
        LDR.W    R2,??DataTable23
        STRB     R1,[R0, R2]
// 1366    counter++;
        ADDS     R9,R9,#+1
// 1367    if(counter>=len) 
        CMP      R9,R5
        BCC.N    ??FAT32_Add_Dat_8
// 1368    {
// 1369     iSec=pfi->FileCurSector;
        LDR      R7,[R4, #+24]
// 1370     goto end;
        B.N      ??FAT32_Add_Dat_10
// 1371    }
// 1372   }
// 1373   FAT32_WriteSector(pfi->FileCurSector,FAT32_Buffer); //数据接缝  
??FAT32_Add_Dat_9:
        LDR.W    R1,??DataTable23
        LDR      R0,[R4, #+24]
        BL       FAT32_WriteSector
// 1374   
// 1375   if(pfi->FileCurSector-(SOC(pfi->FileCurCluster))<(pArg->SectorsPerClust-1)) //判断是不是一个簇的最后一个扇区,先将当前簇所有扇区填满 
        LDR      R0,[R4, #+24]
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable24
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+8]
        LDR      R3,[R4, #+16]
        SUBS     R2,R2,R3
        MLA      R0,R2,R1,R0
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+28]
        SUBS     R0,R0,R1
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        SUBS     R1,R1,#+1
        CMP      R0,R1
        BCS.N    ??FAT32_Add_Dat_11
// 1376   {
// 1377    for(iSec=pfi->FileCurSector+1;iSec<=(SOC(pfi->FileCurCluster)+pArg->SectorsPerClust-1);iSec++)
        LDR      R0,[R4, #+24]
        ADDS     R7,R0,#+1
        B.N      ??FAT32_Add_Dat_12
// 1378    {
// 1379     for(i=0;i<pArg->BytesPerSector;i++)
// 1380     {
// 1381 	 FAT32_Buffer[i]=pbuf[counter];
// 1382 	 counter++;
// 1383      if(counter>=len) 
// 1384 	 {
// 1385 	  goto end;
// 1386 	 }
// 1387     }
// 1388     FAT32_WriteSector(iSec,FAT32_Buffer);
??FAT32_Add_Dat_13:
        LDR.W    R1,??DataTable23
        MOVS     R0,R7
        BL       FAT32_WriteSector
        ADDS     R7,R7,#+1
??FAT32_Add_Dat_12:
        LDR      R0,[R4, #+16]
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+8]
        SUBS     R0,R0,R1
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable24
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R0,R1,R0,R2
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        ADDS     R0,R1,R0
        SUBS     R0,R0,#+1
        CMP      R0,R7
        BCC.N    ??FAT32_Add_Dat_11
        MOVS     R0,#+0
        B.N      ??FAT32_Add_Dat_14
??FAT32_Add_Dat_15:
        ADDS     R0,R0,#+1
??FAT32_Add_Dat_14:
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        CMP      R0,R1
        BCS.N    ??FAT32_Add_Dat_13
        LDRB     R1,[R9, R8]
        LDR.W    R2,??DataTable23
        STRB     R1,[R0, R2]
        ADDS     R9,R9,#+1
        CMP      R9,R5
        BCC.N    ??FAT32_Add_Dat_15
        B.N      ??FAT32_Add_Dat_10
// 1389    }
// 1390   }
// 1391   
// 1392   temp_sub=len-counter;
??FAT32_Add_Dat_11:
        SUBS     R0,R5,R9
        STR      R0,[SP, #+0]
// 1393   for(iClu=0;iClu<temp_sub/(pArg->SectorsPerClust*pArg->BytesPerSector);iClu++)
        MOVS     R10,#+0
        B.N      ??FAT32_Add_Dat_16
??FAT32_Add_Dat_17:
        ADDS     R10,R10,#+1
??FAT32_Add_Dat_16:
        LDR      R0,[SP, #+0]
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable24
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+12]
        MULS     R1,R2,R1
        UDIV     R0,R0,R1
        CMP      R10,R0
        BCS.N    ??FAT32_Add_Dat_18
// 1394   {
// 1395    if(!(new_clu=FAT32_Find_Free_Clust(0))) return 0;
        MOVS     R0,#+0
        BL       FAT32_Find_Free_Clust
        MOVS     R7,R0
        CMP      R7,#+0
        BNE.N    ??FAT32_Add_Dat_19
        MOVS     R0,#+0
        B.N      ??FAT32_Add_Dat_3
// 1396    FAT32_Modify_FAT(pfi->FileCurCluster,new_clu);
??FAT32_Add_Dat_19:
        MOVS     R1,R7
        LDR      R0,[R4, #+16]
        BL       FAT32_Modify_FAT
// 1397    FAT32_Modify_FAT(new_clu,0x0fffffff);
        MVNS     R1,#-268435456
        MOVS     R0,R7
        BL       FAT32_Modify_FAT
// 1398    pfi->FileCurCluster=new_clu;
        STR      R7,[R4, #+16]
// 1399 
// 1400    temp_sec=SOC(new_clu);
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+8]
        SUBS     R0,R7,R0
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.W    R2,??DataTable24
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R11,R1,R0,R2
// 1401    for(iSec=temp_sec;iSec<temp_sec+pArg->SectorsPerClust;iSec++)
        MOV      R7,R11
        B.N      ??FAT32_Add_Dat_20
// 1402    {
// 1403     for(i=0;i<pArg->BytesPerSector;i++)
// 1404 	{
// 1405    	 FAT32_Buffer[i]=pbuf[counter];
??FAT32_Add_Dat_21:
        LDRB     R1,[R9, R8]
        LDR.N    R2,??DataTable23
        STRB     R1,[R0, R2]
// 1406 	 counter++;
        ADDS     R9,R9,#+1
// 1407 	} 
        ADDS     R0,R0,#+1
??FAT32_Add_Dat_22:
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        CMP      R0,R1
        BCC.N    ??FAT32_Add_Dat_21
// 1408 	FAT32_WriteSector(iSec,FAT32_Buffer);
        LDR.N    R1,??DataTable23
        MOVS     R0,R7
        BL       FAT32_WriteSector
        ADDS     R7,R7,#+1
??FAT32_Add_Dat_20:
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+20]
        ADDS     R0,R0,R11
        CMP      R7,R0
        BCS.N    ??FAT32_Add_Dat_17
        MOVS     R0,#+0
        B.N      ??FAT32_Add_Dat_22
// 1409    }
// 1410   }
// 1411 
// 1412   temp_sub=len-counter;
??FAT32_Add_Dat_18:
        SUBS     R0,R5,R9
        STR      R0,[SP, #+0]
// 1413   if(temp_sub)
        LDR      R0,[SP, #+0]
        CMP      R0,#+0
        BEQ.N    ??FAT32_Add_Dat_23
// 1414   {
// 1415    if(!(new_clu=FAT32_Find_Free_Clust(0))) return 0;
        MOVS     R0,#+0
        BL       FAT32_Find_Free_Clust
        MOVS     R7,R0
        CMP      R7,#+0
        BNE.N    ??FAT32_Add_Dat_24
        MOVS     R0,#+0
        B.N      ??FAT32_Add_Dat_3
// 1416    FAT32_Modify_FAT(pfi->FileCurCluster,new_clu);
??FAT32_Add_Dat_24:
        MOVS     R1,R7
        LDR      R0,[R4, #+16]
        BL       FAT32_Modify_FAT
// 1417    FAT32_Modify_FAT(new_clu,0x0fffffff);
        MVNS     R1,#-268435456
        MOVS     R0,R7
        BL       FAT32_Modify_FAT
// 1418    pfi->FileCurCluster=new_clu;
        STR      R7,[R4, #+16]
// 1419    temp_sec=SOC(new_clu);
        LDR.W    R0,??DataTable24
        LDR      R0,[R0, #+0]
        LDR      R0,[R0, #+8]
        SUBS     R0,R7,R0
        LDR.W    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+20]
        LDR.N    R2,??DataTable24
        LDR      R2,[R2, #+0]
        LDR      R2,[R2, #+28]
        MLA      R11,R1,R0,R2
// 1420    for(iSec=temp_sec;iSec<temp_sec+temp_sub/pArg->BytesPerSector;iSec++)
        MOV      R7,R11
        B.N      ??FAT32_Add_Dat_25
// 1421    {
// 1422     for(i=0;i<pArg->BytesPerSector;i++)
// 1423 	{
// 1424    	 FAT32_Buffer[i]=pbuf[counter];
??FAT32_Add_Dat_26:
        LDRB     R1,[R9, R8]
        LDR.N    R2,??DataTable23
        STRB     R1,[R0, R2]
// 1425 	 counter++;
        ADDS     R9,R9,#+1
// 1426 	} 
        ADDS     R0,R0,#+1
??FAT32_Add_Dat_27:
        LDR.N    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        CMP      R0,R1
        BCC.N    ??FAT32_Add_Dat_26
// 1427 	FAT32_WriteSector(iSec,FAT32_Buffer);    
        LDR.N    R1,??DataTable23
        MOVS     R0,R7
        BL       FAT32_WriteSector
        ADDS     R7,R7,#+1
??FAT32_Add_Dat_25:
        LDR      R0,[SP, #+0]
        LDR.N    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        UDIV     R0,R0,R1
        ADDS     R0,R0,R11
        CMP      R7,R0
        BCS.N    ??FAT32_Add_Dat_23
        MOVS     R0,#+0
        B.N      ??FAT32_Add_Dat_27
// 1428    }   
// 1429   }
// 1430 
// 1431   temp_sub=len-counter;
??FAT32_Add_Dat_23:
        SUBS     R0,R5,R9
        STR      R0,[SP, #+0]
// 1432   if(temp_sub)
        LDR      R0,[SP, #+0]
        CMP      R0,#+0
        BEQ.N    ??FAT32_Add_Dat_10
// 1433   {
// 1434    for(i=0;i<pArg->BytesPerSector;i++)
        MOVS     R0,#+0
        B.N      ??FAT32_Add_Dat_28
// 1435    {
// 1436    	FAT32_Buffer[i]=pbuf[counter];
??FAT32_Add_Dat_29:
        LDRB     R1,[R9, R8]
        LDR.N    R2,??DataTable23
        STRB     R1,[R0, R2]
// 1437 	counter++;
        ADDS     R9,R9,#+1
// 1438    } 
        ADDS     R0,R0,#+1
??FAT32_Add_Dat_28:
        LDR.N    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        CMP      R0,R1
        BCC.N    ??FAT32_Add_Dat_29
// 1439    FAT32_WriteSector(iSec,FAT32_Buffer);   
        LDR.N    R1,??DataTable23
        MOVS     R0,R7
        BL       FAT32_WriteSector
// 1440   }
// 1441 end:
// 1442   FAT32_WriteSector(iSec,FAT32_Buffer);
??FAT32_Add_Dat_10:
        LDR.N    R1,??DataTable23
        MOVS     R0,R7
        BL       FAT32_WriteSector
// 1443   FAT32_ReadSector(pfi->Rec_Sec,FAT32_Buffer);
        LDR.N    R1,??DataTable23
        LDR      R0,[R4, #+36]
        BL       FAT32_ReadSector
// 1444   (((struct direntry *)(FAT32_Buffer+pfi->nRec))->deFileSize)[0]=((temp_file_size+len)&0x000000ff);
        LDRH     R0,[R4, #+40]
        LDR.N    R1,??DataTable23
        ADDS     R0,R0,R1
        ADDS     R1,R5,R6
        STRB     R1,[R0, #+28]
// 1445   (((struct direntry *)(FAT32_Buffer+pfi->nRec))->deFileSize)[1]=((temp_file_size+len)&0x0000ff00)>>8;
        LDRH     R0,[R4, #+40]
        LDR.N    R1,??DataTable23
        ADDS     R0,R0,R1
        ADDS     R1,R5,R6
        LSRS     R1,R1,#+8
        STRB     R1,[R0, #+29]
// 1446   (((struct direntry *)(FAT32_Buffer+pfi->nRec))->deFileSize)[2]=((temp_file_size+len)&0x00ff0000)>>16;
        LDRH     R0,[R4, #+40]
        LDR.N    R1,??DataTable23
        ADDS     R0,R0,R1
        ADDS     R1,R5,R6
        LSRS     R1,R1,#+16
        STRB     R1,[R0, #+30]
// 1447   (((struct direntry *)(FAT32_Buffer+pfi->nRec))->deFileSize)[3]=((temp_file_size+len)&0xff000000)>>24;
        LDRH     R0,[R4, #+40]
        LDR.N    R1,??DataTable23
        ADDS     R0,R0,R1
        ADDS     R1,R5,R6
        LSRS     R1,R1,#+24
        STRB     R1,[R0, #+31]
// 1448   FAT32_WriteSector(pfi->Rec_Sec,FAT32_Buffer);
        LDR.N    R1,??DataTable23
        LDR      R0,[R4, #+36]
        BL       FAT32_WriteSector
// 1449 
// 1450   pfi->FileSize=(temp_file_size+len);
        ADDS     R0,R5,R6
        STR      R0,[R4, #+20]
// 1451   pfi->FileCurSector=(pfi->FileSize%pArg->BytesPerSector)?iSec:iSec+1;
        LDR      R0,[R4, #+20]
        LDR.N    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        UDIV     R2,R0,R1
        MLS      R0,R1,R2,R0
        CMP      R0,#+0
        BNE.N    ??FAT32_Add_Dat_30
??FAT32_Add_Dat_31:
        ADDS     R7,R7,#+1
??FAT32_Add_Dat_30:
        STR      R7,[R4, #+24]
// 1452   pfi->FileCurPos=pfi->FileSize%pArg->BytesPerSector;
        LDR      R0,[R4, #+20]
        LDR.N    R1,??DataTable24
        LDR      R1,[R1, #+0]
        LDR      R1,[R1, #+12]
        UDIV     R2,R0,R1
        MLS      R0,R1,R2,R0
        STRH     R0,[R4, #+28]
// 1453   pfi->FileCurOffset=pfi->FileSize;
        LDR      R0,[R4, #+20]
        STR      R0,[R4, #+32]
// 1454  }
// 1455  FAT32_Find_Free_Clust(1);
??FAT32_Add_Dat_0:
        MOVS     R0,#+1
        BL       FAT32_Find_Free_Clust
// 1456  return len;
        MOVS     R0,R5
??FAT32_Add_Dat_3:
        POP      {R1,R4-R11,PC}   ;; return
// 1457 }
// 1458 
// 1459 /**************************************************************************
// 1460  - 功能描述：创建目录(支持任意层目录创建)
// 1461  - 隶属模块：znFAT文件系统模块
// 1462  - 函数属性：外部，使用户使用
// 1463  - 参数说明：pfi:无用
// 1464              dirpath:目录路径 比如 "\\dir1\\dir2\\dir3\\....\\dirn\\"
// 1465              最后必须是\\结束
// 1466  - 返回说明：成功返回0，失败返回1
// 1467  - 注：如果中间某一级目录不存在，比如上面的这个路径中dir3不存在，那么此函数会
// 1468        创建这个目录，然后再继续去创建更深层的目录
// 1469        创建目录失败有可能是因为存储设备空间不足
// 1470  **************************************************************************/
// 1471 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// 1472 uint8 FAT32_Create_Dir(struct FileInfoStruct *pfi,int8 *dirpath,uint8 *ptd)
// 1473 {
FAT32_Create_Dir:
        PUSH     {R4-R6,LR}
        SUB      SP,SP,#+8
        MOVS     R4,R0
        MOVS     R5,R1
        MOVS     R6,R2
        B.N      ??FAT32_Create_Dir_0
// 1474  while(!FAT32_Enter_Dir(dirpath))
// 1475  {
// 1476   if(FAT32_Create_Rec(pfi,temp_dir_cluster,temp_dir_name,1,ptd)==-1)
??FAT32_Create_Dir_1:
        STR      R6,[SP, #+0]
        MOVS     R3,#+1
        LDR.N    R2,??DataTable24_2
        LDR.N    R0,??DataTable24_3
        LDR      R1,[R0, #+0]
        MOVS     R0,R4
        BL       FAT32_Create_Rec
// 1477   {
// 1478    return 1;
// 1479   }
// 1480  }
??FAT32_Create_Dir_0:
        MOVS     R0,R5
        BL       FAT32_Enter_Dir
        CMP      R0,#+0
        BEQ.N    ??FAT32_Create_Dir_1
// 1481  return 0;
        MOVS     R0,#+0
        POP      {R1,R2,R4-R6,PC}  ;; return
// 1482 }
// 1483 
// 1484 /**************************************************************************
// 1485  - 功能描述：创建文件(支持任意层目录创建)
// 1486  - 隶属模块：znFAT文件系统模块
// 1487  - 函数属性：外部，使用户使用
// 1488  - 参数说明：pfi:一个指向FileInfoStruct类型的结构体的指针，用来装载新创建的
// 1489              文件信息，因此新创建的文件不用再打开就可以直接来操作
// 1490              filepath:文件路径 比如 "\\dir1\\dir2\\dir3\\....\\dirn\\test.txt"
// 1491  - 返回说明：0：成功 1：文件已存在 2：创建文件目录失败 3：创建文件失败
// 1492  - 注：如果文件路径中某一个中间目录不存在，那么此函数会创建这个目录，再继续
// 1493        去创建更深层的目录，一直到最后把文件创建完成。
// 1494        创建文件失败有可能是因为存储设备空间不足，或是此文件已经存在
// 1495  **************************************************************************/
// 1496 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// 1497 uint8 FAT32_Create_File(struct FileInfoStruct *pfi,int8 *filepath,uint8 *ptd)
// 1498 {
FAT32_Create_File:
        PUSH     {R4-R6,LR}
        SUB      SP,SP,#+8
        MOVS     R4,R0
        MOVS     R5,R1
        MOVS     R6,R2
// 1499  if(FAT32_Open_File(pfi,filepath,0))
        MOVS     R2,#+0
        MOVS     R1,R5
        MOVS     R0,R4
        BL       FAT32_Open_File
        CMP      R0,#+0
        BEQ.N    ??FAT32_Create_File_0
// 1500  {
// 1501   if(!FAT32_Create_Dir(pfi,filepath,ptd))
        MOVS     R2,R6
        MOVS     R1,R5
        MOVS     R0,R4
        BL       FAT32_Create_Dir
        CMP      R0,#+0
        BNE.N    ??FAT32_Create_File_1
// 1502   {
// 1503    if(FAT32_Create_Rec(pfi,temp_dir_cluster,temp_dir_name,0,ptd)==-1)
        STR      R6,[SP, #+0]
        MOVS     R3,#+0
        LDR.N    R2,??DataTable24_2
        LDR.N    R0,??DataTable24_3
        LDR      R1,[R0, #+0]
        MOVS     R0,R4
        BL       FAT32_Create_Rec
        MOVS     R1,R0
// 1504    {
// 1505     return 3;
// 1506    }    
// 1507   }
// 1508   else
// 1509   {
// 1510    return 2;   
// 1511   }
// 1512  }
// 1513  else
// 1514  {
// 1515   return 1;
// 1516  }
// 1517  return 0;
        MOVS     R0,#+0
        B.N      ??FAT32_Create_File_2
??FAT32_Create_File_1:
        MOVS     R0,#+2
        B.N      ??FAT32_Create_File_2
??FAT32_Create_File_0:
        MOVS     R0,#+1
??FAT32_Create_File_2:
        POP      {R1,R2,R4-R6,PC}  ;; return
// 1518 }
// 1519 
// 1520 /**************************************************************************
// 1521  - 功能描述：删除文件(支持任意层目录)
// 1522  - 隶属模块：znFAT文件系统模块
// 1523  - 函数属性：外部，使用户使用
// 1524  - 参数说明：filepath:文件路径 比如 "\\dir1\\dir2\\dir3\\....\\dirn\\test.txt"
// 1525  - 返回说明：1:文件或目录路径不存在 0:成功
// 1526  - 注：删除后的文件的FAT表中的簇链关系完全被破坏
// 1527  **************************************************************************/
// 1528 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// 1529 uint8 FAT32_Del_File(int8 *filepath)
// 1530 {
FAT32_Del_File:
        PUSH     {R4,R5,LR}
        SUB      SP,SP,#+68
// 1531  uint32 cur_clu,next_clu;
// 1532  struct FileInfoStruct fi;
// 1533  
// 1534  if(FAT32_Open_File(&fi,filepath,0))
        MOVS     R2,#+0
        MOVS     R1,R0
        ADD      R0,SP,#+0
        BL       FAT32_Open_File
        CMP      R0,#+0
        BEQ.N    ??FAT32_Del_File_0
// 1535  {
// 1536   return 1;
        MOVS     R0,#+1
        B.N      ??FAT32_Del_File_1
// 1537  }
// 1538  FAT32_ReadSector(fi.Rec_Sec,FAT32_Buffer);
??FAT32_Del_File_0:
        LDR.N    R1,??DataTable23
        LDR      R0,[SP, #+36]
        BL       FAT32_ReadSector
// 1539  *(FAT32_Buffer+fi.nRec)=0xe5;
        LDRH     R0,[SP, #+40]
        LDR.N    R1,??DataTable23
        MOVS     R2,#+229
        STRB     R2,[R0, R1]
// 1540  FAT32_WriteSector(fi.Rec_Sec,FAT32_Buffer);
        LDR.N    R1,??DataTable23
        LDR      R0,[SP, #+36]
        BL       FAT32_WriteSector
// 1541  
// 1542  if(cur_clu=fi.FileStartCluster)
        LDR      R4,[SP, #+12]
        CMP      R4,#+0
        BEQ.N    ??FAT32_Del_File_2
// 1543  {
// 1544   if(cur_clu<Search_Last_Usable_Cluster()) 
        BL       Search_Last_Usable_Cluster
        CMP      R4,R0
        BCS.N    ??FAT32_Del_File_3
// 1545    FAT32_Update_FSInfo_Last_Clu(cur_clu);
        MOVS     R0,R4
        BL       FAT32_Update_FSInfo_Last_Clu
// 1546   FAT32_Update_FSInfo_Free_Clu(1);
??FAT32_Del_File_3:
        MOVS     R0,#+1
        BL       FAT32_Update_FSInfo_Free_Clu
// 1547   next_clu=FAT32_GetNextCluster(cur_clu);
        MOVS     R0,R4
        BL       FAT32_GetNextCluster
        MOVS     R5,R0
        B.N      ??FAT32_Del_File_4
// 1548   while(next_clu!=0x0fffffff)
// 1549   {
// 1550    FAT32_Update_FSInfo_Free_Clu(1);
??FAT32_Del_File_5:
        MOVS     R0,#+1
        BL       FAT32_Update_FSInfo_Free_Clu
// 1551    FAT32_Modify_FAT(cur_clu,0x00000000);
        MOVS     R1,#+0
        MOVS     R0,R4
        BL       FAT32_Modify_FAT
// 1552    cur_clu=next_clu;
        MOVS     R4,R5
// 1553    next_clu=FAT32_GetNextCluster(cur_clu);
        MOVS     R0,R4
        BL       FAT32_GetNextCluster
        MOVS     R5,R0
// 1554   }
??FAT32_Del_File_4:
        MVNS     R0,#-268435456
        CMP      R5,R0
        BNE.N    ??FAT32_Del_File_5
// 1555   FAT32_Modify_FAT(cur_clu,0x00000000);
        MOVS     R1,#+0
        MOVS     R0,R4
        BL       FAT32_Modify_FAT
// 1556  }
// 1557  return 0;
??FAT32_Del_File_2:
        MOVS     R0,#+0
??FAT32_Del_File_1:
        ADD      SP,SP,#+68
        POP      {R4,R5,PC}       ;; return
// 1558 }
// 1559 
// 1560 /**************************************************************************
// 1561  - 功能描述：文件拷贝(源文件路径与目标文件路径均支持任意深层目录，并且支持
// 1562              文件名通配)
// 1563  - 隶属模块：znFAT文件系统模块
// 1564  - 函数属性：外部，使用户使用
// 1565  - 参数说明：pArg1:是源文件所在的存储设备的初始参数结构体的指针
// 1566              pArg2:是目标文件所在的存储设备的初始参数结构体的指针
// 1567              sfilename:源文件路径，也就是拷贝操作的数据源
// 1568              tfilename:目标文件路径，也就是数据最终到写入的文件
// 1569                        比如 "\\dir1\\dir2\\dir3\\....\\dirn\\test.txt" 
// 1570              file_buf:拷贝过程中要用到的数据缓冲区，此缓冲区容量越大，
// 1571                       拷贝速度越快
// 1572              buf_size:数据缓冲区的大小 
// 1573  - 返回说明：1:目录文件创建失败 2:源文件打开打败 0:成功
// 1574  - 注：此函数支持多设备之间的文件拷贝，pArg1与pArg2引入了源存储设备与目的
// 1575        存储设备的初始参数信息，从而可以同时对两个存储设备进行操作。
// 1576 	   znFAT 5.01版开始支持多设备，多设备间的相互数据拷贝是最典型的应用
// 1577  **************************************************************************/
// 1578 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// 1579 unsigned char FAT32_XCopy_File(struct FAT32_Init_Arg *pArg1,struct FAT32_Init_Arg *pArg2,int8 *sfilename,int8 *tfilename,uint8 *file_buf,uint32 buf_size,unsigned char *pt)
// 1580 {
FAT32_XCopy_File:
        PUSH     {R4-R8,LR}
        SUB      SP,SP,#+128
        MOVS     R7,R0
        MOVS     R6,R1
        MOV      R8,R2
        MOVS     R1,R3
        LDR      R4,[SP, #+152]
        LDR      R5,[SP, #+156]
        LDR      R2,[SP, #+160]
// 1581  struct FileInfoStruct FileInfo2,FileInfo1;
// 1582  uint32 i;
// 1583 
// 1584  Dev_No=pArg2->DEV_No;
        LDR.N    R0,??DataTable24_4
        LDRB     R3,[R6, #+0]
        STRB     R3,[R0, #+0]
// 1585  pArg=pArg2;
        LDR.N    R0,??DataTable24
        STR      R6,[R0, #+0]
// 1586  if(FAT32_Create_File(&FileInfo1,tfilename,pt)) return 1;
        ADD      R0,SP,#+0
        BL       FAT32_Create_File
        CMP      R0,#+0
        BEQ.N    ??FAT32_XCopy_File_0
        MOVS     R0,#+1
        B.N      ??FAT32_XCopy_File_1
// 1587  Dev_No=pArg1->DEV_No;
??FAT32_XCopy_File_0:
        LDR.N    R0,??DataTable24_4
        LDRB     R1,[R7, #+0]
        STRB     R1,[R0, #+0]
// 1588  pArg=pArg1;
        LDR.N    R0,??DataTable24
        STR      R7,[R0, #+0]
// 1589  if(FAT32_Open_File(&FileInfo2,sfilename,0)) return 2;
        MOVS     R2,#+0
        MOV      R1,R8
        ADD      R0,SP,#+64
        BL       FAT32_Open_File
        CMP      R0,#+0
        BEQ.N    ??FAT32_XCopy_File_2
        MOVS     R0,#+2
        B.N      ??FAT32_XCopy_File_1
// 1590 
// 1591  for(i=0;i<FileInfo2.FileSize/buf_size;i++)
??FAT32_XCopy_File_2:
        MOVS     R8,#+0
        B.N      ??FAT32_XCopy_File_3
// 1592  {
// 1593   Dev_No=pArg1->DEV_No;
??FAT32_XCopy_File_4:
        LDR.N    R0,??DataTable24_4
        LDRB     R1,[R7, #+0]
        STRB     R1,[R0, #+0]
// 1594   pArg=pArg1;
        LDR.N    R0,??DataTable24
        STR      R7,[R0, #+0]
// 1595   FAT32_Read_File(&FileInfo2,i*buf_size,buf_size,file_buf);
        MOVS     R3,R4
        MOVS     R2,R5
        MUL      R1,R5,R8
        ADD      R0,SP,#+64
        BL       FAT32_Read_File
// 1596   Dev_No=pArg2->DEV_No;
        LDR.N    R0,??DataTable24_4
        LDRB     R1,[R6, #+0]
        STRB     R1,[R0, #+0]
// 1597   pArg=pArg2;
        LDR.N    R0,??DataTable24
        STR      R6,[R0, #+0]
// 1598   FAT32_Add_Dat(&FileInfo1,buf_size,file_buf);
        MOVS     R2,R4
        MOVS     R1,R5
        ADD      R0,SP,#+0
        BL       FAT32_Add_Dat
// 1599  }
        ADDS     R8,R8,#+1
??FAT32_XCopy_File_3:
        LDR      R0,[SP, #+84]
        UDIV     R0,R0,R5
        CMP      R8,R0
        BCC.N    ??FAT32_XCopy_File_4
// 1600 
// 1601  Dev_No=pArg1->DEV_No;
        LDR.N    R0,??DataTable24_4
        LDRB     R1,[R7, #+0]
        STRB     R1,[R0, #+0]
// 1602  pArg=pArg1; 
        LDR.N    R0,??DataTable24
        STR      R7,[R0, #+0]
// 1603  FAT32_Read_File(&FileInfo2,i*buf_size,FileInfo2.FileSize%buf_size,file_buf);
        LDR      R0,[SP, #+84]
        MOVS     R3,R4
        UDIV     R1,R0,R5
        MLS      R2,R5,R1,R0
        MUL      R1,R5,R8
        ADD      R0,SP,#+64
        BL       FAT32_Read_File
// 1604  Dev_No=pArg2->DEV_No;
        LDR.N    R0,??DataTable24_4
        LDRB     R1,[R6, #+0]
        STRB     R1,[R0, #+0]
// 1605  pArg=pArg2;
        LDR.N    R0,??DataTable24
        STR      R6,[R0, #+0]
// 1606  FAT32_Add_Dat(&FileInfo1,FileInfo2.FileSize%buf_size,file_buf);
        LDR      R0,[SP, #+84]
        MOVS     R2,R4
        UDIV     R1,R0,R5
        MLS      R1,R5,R1,R0
        ADD      R0,SP,#+0
        BL       FAT32_Add_Dat
// 1607 
// 1608  return 0;
        MOVS     R0,#+0
??FAT32_XCopy_File_1:
        ADD      SP,SP,#+128
        POP      {R4-R8,PC}       ;; return
// 1609 }

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable23:
        DC32     FAT32_Buffer
// 1610 
// 1611 /**************************************************************************
// 1612  - 功能描述：文件重命名
// 1613  - 隶属模块：znFAT文件系统模块
// 1614  - 函数属性：外部，使用户使用
// 1615  - 参数说明：filename:将要重命名的源文件的路径 如\a.txt
// 1616              newfilename:目标文件名 如b.txt (注目标文件名是单纯的文件名，
// 1617 			 不含路径)
// 1618  - 返回说明：1:源文件打开打败 0:成功
// 1619  - 注：无
// 1620  **************************************************************************/
// 1621 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// 1622 uint8 FAT32_Rename_File(int8 *filename,int8 *newfilename)
// 1623 {
FAT32_Rename_File:
        PUSH     {R4-R6,LR}
        SUB      SP,SP,#+64
        MOVS     R4,R1
// 1624  struct FileInfoStruct fi;
// 1625  uint8 i=0,j=0;
        MOVS     R6,#+0
        MOVS     R5,#+0
// 1626  if(FAT32_Open_File(&fi,filename,0)) return 1; //文件打开失败
        MOVS     R2,#+0
        MOVS     R1,R0
        ADD      R0,SP,#+0
        BL       FAT32_Open_File
        CMP      R0,#+0
        BEQ.N    ??FAT32_Rename_File_0
        MOVS     R0,#+1
        B.N      ??FAT32_Rename_File_1
// 1627  FAT32_ReadSector(fi.Rec_Sec,FAT32_Buffer);
??FAT32_Rename_File_0:
        LDR.N    R1,??DataTable24_5
        LDR      R0,[SP, #+36]
        BL       FAT32_ReadSector
// 1628  for(i=0;i<11;i++) (FAT32_Buffer+fi.nRec)[i]=0x20;
        MOVS     R6,#+0
        B.N      ??FAT32_Rename_File_2
??FAT32_Rename_File_3:
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        LDRH     R0,[SP, #+40]
        LDR.N    R1,??DataTable24_5
        ADDS     R0,R0,R1
        MOVS     R1,#+32
        STRB     R1,[R6, R0]
        ADDS     R6,R6,#+1
??FAT32_Rename_File_2:
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        CMP      R6,#+11
        BCC.N    ??FAT32_Rename_File_3
// 1629  i=0;
        MOVS     R6,#+0
        B.N      ??FAT32_Rename_File_4
// 1630  while(newfilename[i]!='.')
// 1631  {
// 1632   (FAT32_Buffer+fi.nRec)[i]=L2U(newfilename[i]);
??FAT32_Rename_File_5:
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        LDRB     R0,[R6, R4]
        BL       L2U
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        LDRH     R1,[SP, #+40]
        LDR.N    R2,??DataTable24_5
        ADDS     R1,R1,R2
        STRB     R0,[R6, R1]
// 1633   i++;
        ADDS     R6,R6,#+1
// 1634  }
??FAT32_Rename_File_4:
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        LDRB     R0,[R6, R4]
        CMP      R0,#+46
        BNE.N    ??FAT32_Rename_File_5
// 1635  i++;
        ADDS     R6,R6,#+1
        B.N      ??FAT32_Rename_File_6
// 1636  while(newfilename[i])
// 1637  {
// 1638   (FAT32_Buffer+fi.nRec+8)[j]=L2U(newfilename[i]);
??FAT32_Rename_File_7:
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        LDRB     R0,[R6, R4]
        BL       L2U
        UXTB     R5,R5            ;; ZeroExt  R5,R5,#+24,#+24
        LDRH     R1,[SP, #+40]
        LDR.N    R2,??DataTable24_5
        ADDS     R1,R1,R2
        ADDS     R1,R5,R1
        STRB     R0,[R1, #+8]
// 1639   i++;j++;
        ADDS     R6,R6,#+1
        ADDS     R5,R5,#+1
// 1640  }
??FAT32_Rename_File_6:
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        LDRB     R0,[R6, R4]
        CMP      R0,#+0
        BNE.N    ??FAT32_Rename_File_7
// 1641  FAT32_WriteSector(fi.Rec_Sec,FAT32_Buffer);
        LDR.N    R1,??DataTable24_5
        LDR      R0,[SP, #+36]
        BL       FAT32_WriteSector
// 1642  return 0;
        MOVS     R0,#+0
??FAT32_Rename_File_1:
        ADD      SP,SP,#+64
        POP      {R4-R6,PC}       ;; return
// 1643 }

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable24:
        DC32     pArg

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable24_1:
        DC32     temp_rec

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable24_2:
        DC32     temp_dir_name

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable24_3:
        DC32     temp_dir_cluster

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable24_4:
        DC32     Dev_No

        SECTION `.text`:CODE:NOROOT(2)
        DATA
??DataTable24_5:
        DC32     FAT32_Buffer
// 1644 
// 1645 /**************************************************************************
// 1646  - 功能描述：文件关闭
// 1647  - 隶属模块：znFAT文件系统模块
// 1648  - 函数属性：外部，使用户使用
// 1649  - 参数说明：pfi:指向当前打开的文件的文件信息结构
// 1650  - 返回说明：0:成功
// 1651  - 注：无
// 1652  **************************************************************************/
// 1653 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// 1654 uint8 FAT32_File_Close(struct FileInfoStruct *pfi)
// 1655 {
// 1656  uint16 i=0;							
FAT32_File_Close:
        MOVS     R1,#+0
// 1657  for(i=0;i<sizeof(struct FileInfoStruct);i++)
        MOVS     R2,#+0
        MOVS     R1,R2
        B.N      ??FAT32_File_Close_0
// 1658  {
// 1659   ((uint8 *)pfi)[i]=0;
??FAT32_File_Close_1:
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        MOVS     R2,#+0
        STRB     R2,[R1, R0]
// 1660  }
        ADDS     R1,R1,#+1
??FAT32_File_Close_0:
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        CMP      R1,#+64
        BCC.N    ??FAT32_File_Close_1
// 1661  return 0;
        MOVS     R0,#+0
        BX       LR               ;; return
// 1662 }
// 1663 /**************************************************************************
// 1664  - 功能描述：文件新建
// 1665  - 隶属模块：FAT文件系统模块
// 1666  - 函数属性：外部，使用户使用
// 1667  - 参数说明：pfi:一个指向FileInfoStruct类型的结构体的指针，用来装载新创建的
// 1668              文件信息，因此新创建的文件不用再打开就可以直接来操作
// 1669              filepath:文件路径 比如 "\\dir1\\dir2\\dir3\\....\\dirn\\test.txt"
// 1670  - 返回说明：0：成功 1：文件已存在,重新创建 2：创建文件目录失败 3：创建文件失败
// 1671  - 注：无
// 1672  **************************************************************************/

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// 1673  uint8 FAT32_New_File(struct FileInfoStruct *pfi,int8 *filepath,uint8 *ptd){
FAT32_New_File:
        PUSH     {R4-R6,LR}
        MOVS     R4,R0
        MOVS     R5,R1
        MOVS     R6,R2
// 1674   uint8 result;
// 1675   result=FAT32_Create_File(pfi,filepath,ptd);
        MOVS     R2,R6
        MOVS     R1,R5
        MOVS     R0,R4
        BL       FAT32_Create_File
// 1676   if(result!=0){
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BEQ.N    ??FAT32_New_File_0
// 1677     
// 1678     if(result==1){
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+1
        BNE.N    ??FAT32_New_File_1
// 1679       
// 1680       FAT32_Del_File(filepath);
        MOVS     R0,R5
        BL       FAT32_Del_File
// 1681       FAT32_Create_File(pfi,filepath,ptd);
        MOVS     R2,R6
        MOVS     R1,R5
        MOVS     R0,R4
        BL       FAT32_Create_File
// 1682       return 1;
        MOVS     R0,#+1
        B.N      ??FAT32_New_File_2
// 1683     }
// 1684     else
// 1685       return result;
??FAT32_New_File_1:
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        B.N      ??FAT32_New_File_2
// 1686   }else
// 1687     return 0;
??FAT32_New_File_0:
        MOVS     R0,#+0
??FAT32_New_File_2:
        POP      {R4-R6,PC}       ;; return
// 1688  }

        SECTION `.text`:CODE:NOROOT(1)
        DATA
`?<Constant ".">`:
        ; Initializer data, 2 bytes
        DC8 46, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant "..">`:
        ; Initializer data, 4 bytes
        DC8 46, 46, 0, 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
// 
//   608 bytes in section .bss
// 7 212 bytes in section .text
// 
// 7 204 bytes of CODE memory (+ 8 bytes shared)
//   608 bytes of DATA memory
//
//Errors: none
//Warnings: 12
