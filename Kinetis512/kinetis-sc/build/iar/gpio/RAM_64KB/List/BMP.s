///////////////////////////////////////////////////////////////////////////////
//                                                                            /
//                                                      06/Mar/2012  12:46:31 /
// IAR ANSI C/C++ Compiler V6.10.1.22143/W32 EVALUATION for ARM               /
// Copyright 1999-2010 IAR Systems AB.                                        /
//                                                                            /
//    Cpu mode     =  thumb                                                   /
//    Endian       =  little                                                  /
//    Source file  =  F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\gpio /
//                    \BMP.c                                                  /
//    Command line =  "F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\gpi /
//                    o\BMP.c" -D IAR -D TWR_K60N512 -lCN "F:\My              /
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
//                    M_64KB\List\BMP.s                                       /
//                                                                            /
//                                                                            /
///////////////////////////////////////////////////////////////////////////////

        NAME BMP

        EXTERN FAT32_Add_Dat
        EXTERN FAT32_Create_File
        EXTERN __aeabi_memcpy4

        PUBLIC BmpBIT8Write
        PUBLIC InitColorTable
        PUBLIC biBitCount
        PUBLIC bmpHeight
        PUBLIC bmpWidth
        PUBLIC create_Time
        PUBLIC fileHead
        PUBLIC head
        PUBLIC pBmpBuf

// F:\My Works\K60\Kinetis512\kinetis-sc\src\projects\gpio\BMP.c
//    1 #include "BMP.h"
//    2 #include "FAT32.h"

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//    3 unsigned char *pBmpBuf;//读入图像数据的指针
pBmpBuf:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//    4 int bmpWidth;//图像的宽
bmpWidth:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//    5 int bmpHeight;//图像的高
bmpHeight:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//    6 int biBitCount;//图像类型，每像素位数
biBitCount:
        DS8 4
//    7 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//    8 BITMAPFILEHEADER fileHead;
fileHead:
        DS8 16

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//    9 BITMAPINFOHEADER head;
head:
        DS8 40

        SECTION `.data`:DATA:REORDER:NOROOT(2)
//   10 uint8 create_Time[6]={0x09,0x07,0x0d,0x0d,0x14,0x0f};  //创建时间貌似修改了没有用
create_Time:
        DATA
        DC8 9, 7, 13, 13, 20, 15, 0, 0

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   11 void InitColorTable(RGBQUAD* colorTable) {
//   12   uint16 i;
//   13   for (i=0;i<256;i++)
InitColorTable:
        MOVS     R1,#+0
        B.N      ??InitColorTable_0
//   14 	{
//   15 		colorTable[i].rgbBlue=i;
??InitColorTable_1:
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        STRB     R1,[R0, R1, LSL #+2]
//   16 		colorTable[i].rgbGreen=i;
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        ADDS     R2,R0,R1, LSL #+2
        STRB     R1,[R2, #+1]
//   17 		colorTable[i].rgbRed=i;
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        ADDS     R2,R0,R1, LSL #+2
        STRB     R1,[R2, #+2]
//   18 		colorTable[i].rgbReserved=0;
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        ADDS     R2,R0,R1, LSL #+2
        MOVS     R3,#+0
        STRB     R3,[R2, #+3]
//   19 	} 
        ADDS     R1,R1,#+1
??InitColorTable_0:
        MOV      R2,#+256
        UXTH     R1,R1            ;; ZeroExt  R1,R1,#+16,#+16
        CMP      R1,R2
        BCC.N    ??InitColorTable_1
//   20 }
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   21 void BmpBIT8Write(/*struct FileInfoStruct* fileInfo,*/uint8* fileName,uint8 xSize,uint8 ySize,uint8* imgBuf,RGBQUAD* colorTable){
BmpBIT8Write:
        PUSH     {R4-R7,LR}
        SUB      SP,SP,#+132
        MOVS     R4,R0
        MOVS     R7,R1
        MOVS     R6,R2
        MOVS     R5,R3
//   22   struct FileInfoStruct fileInfo;
//   23   uint8 CreateTime[6]={0x09,0x07,0x0d,0x0d,0x14,0x0f};
        ADD      R0,SP,#+0
        ADR.W    R1,`?<Constant {9, 7, 13, 13, 20, 15}>`
        LDM      R1!,{R2,R3}
        STM      R0!,{R2,R3}
        SUBS     R1,R1,#+8
        SUBS     R0,R0,#+8
//   24   uint8 fhead[]={0x42,0x4D,0xF6,0x16,00,00,00,00,00,0x00, //每行十个数字
//   25   0x36,0x04,00,00,0x28,00,00,00,0x50,0x00,
//   26   00,00,0x46,00,00,00,0x01,00,0x08,00,
//   27   00,00,00,00,0xC0,0x12,00,00,00,00,
//   28   00,00,00,00,00,00,00,00,00,00,
//   29   00,00,00,00};
        ADD      R0,SP,#+8
        ADR.W    R1,`?<Constant {66, 77, 246, 22, 0, 0, 0, 0, 0, 0,`
        MOVS     R2,#+56
        BL       __aeabi_memcpy4
//   30   uint8 fileSize,imgSize;
//   31   fileSize=xSize*ySize+54+1024;
        UXTB     R7,R7            ;; ZeroExt  R7,R7,#+24,#+24
        UXTB     R6,R6            ;; ZeroExt  R6,R6,#+24,#+24
        MUL      R0,R6,R7
        ADDS     R0,R0,#+54
//   32   imgSize=xSize*ySize;
        MUL      R1,R6,R7
//   33   fhead[2]=fileSize&0x00FF;
        STRB     R0,[SP, #+10]
//   34   fhead[3]=(fileSize>>2)&0x00FF;
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        LSRS     R0,R0,#+2
        STRB     R0,[SP, #+11]
//   35   fhead[18]=xSize;
        STRB     R7,[SP, #+26]
//   36   fhead[22]=ySize;
        STRB     R6,[SP, #+30]
//   37   fhead[34]=imgSize&0x00FF;
        STRB     R1,[SP, #+42]
//   38   fhead[35]=(imgSize>>2)&0x00FF;
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        LSRS     R0,R1,#+2
        STRB     R0,[SP, #+43]
//   39   FAT32_Create_File(&fileInfo,fileName,CreateTime);
        ADD      R2,SP,#+0
        MOVS     R1,R4
        ADD      R0,SP,#+64
        BL       FAT32_Create_File
//   40   FAT32_Add_Dat(&fileInfo,sizeof(fhead),fhead);
        ADD      R2,SP,#+8
        MOVS     R1,#+54
        ADD      R0,SP,#+64
        BL       FAT32_Add_Dat
//   41   //FAT32_Add_Dat(&fileInfo,sizeof(colorTable),(uint8*)colorTable);
//   42   FAT32_Add_Dat(&fileInfo,sizeof(imgBuf),imgBuf);  
        MOVS     R2,R5
        MOVS     R1,#+4
        ADD      R0,SP,#+64
        BL       FAT32_Add_Dat
//   43 }
        ADD      SP,SP,#+132
        POP      {R4-R7,PC}       ;; return

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant {9, 7, 13, 13, 20, 15}>`:
        ; Initializer data, 8 bytes
        DC8 9, 7, 13, 13, 20, 15, 0, 0

        SECTION `.text`:CODE:NOROOT(2)
        DATA
`?<Constant {66, 77, 246, 22, 0, 0, 0, 0, 0, 0,`:
        ; Initializer data, 56 bytes
        DC8 66, 77, 246, 22, 0, 0, 0, 0, 0, 0
        DC8 54, 4, 0, 0, 40, 0, 0, 0, 80, 0
        DC8 0, 0, 70, 0, 0, 0, 1, 0, 8, 0
        DC8 0, 0, 0, 0, 192, 18, 0, 0, 0, 0
        DC8 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        DC8 0, 0, 0, 0, 0, 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)

        END
// 
//  72 bytes in section .bss
//   8 bytes in section .data
// 232 bytes in section .text
// 
// 232 bytes of CODE memory
//  80 bytes of DATA memory
//
//Errors: none
//Warnings: 4
