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
//    2 #include "hw_sdhc.h"        //�洢�豸��������д������������SD��
//    3 //#include "ch375.h"	   //�洢�豸��������д������������U��
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
//   10         |���ϵ��� ԭ������ģ�� znFAT�ļ�ϵͳ 5.01 |
//   11         +-----------------------------------------+
//   12 
//   13   ��Դ���Ȩ�� ���� ȫȨ���У��������ã�������������֪
//   14         �Ͻ�����������ҵĿ�ģ�Υ�߱ؾ�������Ը�
//   15          ���ϵ��� 
//   16              ->��Ʒ��վ http://www.znmcu.cn/
//   17              ->��Ʒ��̳ http://bbs.znmcu.cn/
//   18              ->��Ʒ���� http://shop.znmcu.cn/
//   19              ->��Ʒ��ѯ QQ:987582714 MSN:yzn07@126.com
//   20 	                WW:yzn07
//   21 ˵����znFAT���෽���ԣ�ȷ������ȷ�����ȶ��ԣ������ʹ�ã�
//   22       ����bug�����֪��лл����				  
//   23 ********************************************************/
//   24 
//   25 //ȫ�ֱ�������

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
//   31 uint8 FAT32_Buffer[512]; //�������ݶ�д������,���ⲿ�ṩ
FAT32_Buffer:
        DS8 512
//   32 
//   33 extern struct FAT32_Init_Arg *pArg; //��ʼ�������ṹ��ָ�룬����ָ��ĳһ�洢�豸�ĳ�ʼ�������ṹ�壬���ⲿ�ṩ
//   34 

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   35 unsigned char (*pRS)(unsigned long,unsigned char *); //ָ��ʵ�ʴ洢�豸�Ķ����������ĺ���ָ�룬����ʵ�ֶ��豸��֧��
pRS:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
//   36 unsigned char (*pWS)(unsigned long,unsigned char *); //ָ��ʵ�ʴ洢�豸��д���������ĺ���ָ�룬����ʵ�ֶ��豸��֧��
pWS:
        DS8 4
//   37 
//   38 extern unsigned char Dev_No;
//   39 
//   40 /******************************************************************
//   41  - ����������znFAT�Ĵ洢�豸�ײ������ӿڣ���ȡ�洢�豸��addr������
//   42              512���ֽڵ����ݷ���buf���ݻ�������
//   43  - ����ģ�飺znFAT�ļ�ϵͳģ��
//   44  - �������ԣ��ڲ���������洢�豸�ĵײ������Խӣ�
//   45  - ����˵����addr:������ַ
//   46              buf:ָ�����ݻ�����
//   47  - ����˵����0��ʾ��ȡ�����ɹ�������ʧ��
//   48  - ע����������������Ǿ������ϵ����ִ洢�豸����SD������Ч����U�̡�
//   49        CF��ͨ���ڳ����ж�̬���л���ͬ���豸�������Ӷ�ʵ�ֶ��豸(��ͬ
//   50 	   ʱ�Զ��ִ洢�豸���в����������SD�������ļ���U�̵ȵ�)����ͬ
//   51 	   �������л���ֻ��Ҫ�ڳ����иı�Dev_No���ȫ�ֱ�����ֵ����
//   52  ******************************************************************/
//   53 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   54 uint8 FAT32_ReadSector(uint32 addr,uint8 *buf) 
//   55 {
FAT32_ReadSector:
        PUSH     {R7,LR}
//   56  return(disk_read(0,buf,addr,1));  //�滻��ʵ�ʴ洢����������������������SD������������
        MOVS     R3,#+1
        MOVS     R2,R0
        MOVS     R0,#+0
        BL       disk_read
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        POP      {R1,PC}          ;; return
//   57 }
//   58 
//   59 /******************************************************************
//   60  - ����������znFAT�Ĵ洢�豸�ײ������ӿڣ���buf���ݻ������е�512��
//   61              �ֽڵ�����д�뵽�洢�豸��addr������
//   62  - ����ģ�飺znFAT�ļ�ϵͳģ��
//   63  - �������ԣ��ڲ���������洢�豸�ĵײ������Խӣ�
//   64  - ����˵����addr:������ַ
//   65              buf:ָ�����ݻ�����
//   66  - ����˵����0��ʾ��ȡ�����ɹ�������ʧ��
//   67  - ע����
//   68  ******************************************************************/
//   69 

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
//   70 uint8 FAT32_WriteSector(uint32 addr,uint8 *buf)
//   71 {
FAT32_WriteSector:
        PUSH     {R7,LR}
//   72  return(disk_write(0,buf,addr,1)); //�滻��ʵ�ʴ洢��������д������������SD������д����
        MOVS     R3,#+1
        MOVS     R2,R0
        MOVS     R0,#+0
        BL       disk_write
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        POP      {R1,PC}          ;; return
//   73 }
//   74 
//   75 /******************************************************************
//   76  - ����������С��ת��ˣ���LittleEndian��BigEndian
//   77  - ����ģ�飺znFAT�ļ�ϵͳģ��
//   78  - �������ԣ��ڲ�
//   79  - ����˵����dat:ָ��ҪתΪ��˵��ֽ�����
//   80              len:ҪתΪ��˵��ֽ����г���
//   81  - ����˵����תΪ���ģʽ���ֽ���������������
//   82  - ע�����磺С��ģʽ��       0x33 0x22 0x11 0x00  (���ֽ���ǰ)
//   83              תΪ���ģʽ��Ϊ 0x00 0x11 0x22 0x33  (���ֽ���ǰ)
//   84              ��������ֵΪ   0x00112233
//   85              (CISC��CPUͨ����С�˵ģ�����FAT32Ҳ���ΪС�ˣ�����Ƭ��
//   86               ����RISC��CPU��ͨ����˵���Ǵ�˵ģ�������Ҫ�����������
//   87               �ڵĴ�Ŵ�����е��������ܵõ���ȷ����ֵ)
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
//   97   temp+=dat[i]*fact; //�����ֽڳ�����Ӧ��Ȩֵ���ۼ�
??LE2BE_1:
        UXTB     R4,R4            ;; ZeroExt  R4,R4,#+24,#+24
        LDRB     R5,[R4, R0]
        MLA      R2,R3,R5,R2
//   98   fact*=256; //����Ȩֵ
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
//  104  - ������������С���ַ�תΪ��д
//  105  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  106  - �������ԣ��ڲ�
//  107  - ����˵����c:Ҫת��Ϊ��д���ַ�            
//  108  - ����˵����Ҫת�����ֽڵ���Ӧ�Ĵ�д�ַ�
//  109  - ע��ֻ��Сд�ַ���Ч���������a~z��Сд�ַ�����ֱ�ӷ���
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
//  119  - ������������ȡ0�����������û��MBR(��������¼)
//  120  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  121  - �������ԣ��ڲ�
//  122  - ����˵������     
//  123  - ����˵����1��ʾ��⵽MBR��0��ʾû�м�⵽MBR
//  124  - ע����Щ�洢�豸��ʽ��ΪFAT32�Ժ�û��MBR����0��������DBR
//  125        �����MBR������Ҫ������н������Եõ�DBR������λ�ã�ͬʱMBR��
//  126        ����������������������Ϣ
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
//  145  - �����������õ�DBR���ڵ�������(���û��MBR����DBR����0����)
//  146  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  147  - �������ԣ��ڲ�
//  148  - ����˵������     
//  149  - ����˵����DBR��������ַ
//  150  - ע��DBR�а����˺ܶ����õĲ�����Ϣ�������ȷ��λDBR������λ�ã��Ǽ�Ϊ
//  151        ��Ҫ�ģ����潫��ר�ŵĺ�����DBR���н�������ȷ����DBR��ʵ��FAT32��
//  152        ����
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
//  171  - ������������ȡ������������
//  172  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  173  - �������ԣ��ⲿ��ʹ�û�ʹ��
//  174  - ����˵������     
//  175  - ����˵������������ֵ����λΪ�ֽ�
//  176  - ע������õ�����������FAT32������������һ��С��ʵ�ʵ���������
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
//  189  - ������������ȡFSInfo��ȡ�����һ�����ÿ��д�
//  190  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  191  - �������ԣ��ڲ�
//  192  - ����˵������     
//  193  - ����˵���������һ�����ÿ��д�
//  194  - ע��FAT32�е�FSInfo����(����1����)�м�¼�������һ�����ÿ��д�
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
//  204  - ����������FAT32�ļ�ϵͳ��ʼ��
//  205  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  206  - �������ԣ��ⲿ��ʹ�û�ʹ��
//  207  - ����˵����FAT32_Init_Arg���͵Ľṹ��ָ�룬����װ��һЩ��Ҫ�Ĳ�����Ϣ��
//  208              �Ա�����ʹ��     
//  209  - ����˵������
//  210  - ע����ʹ��znFATǰ����������Ǳ����ȱ����õģ����ܶ������Ϣװ�뵽
//  211        argָ��Ľṹ���У�����������С����Ŀ¼��λ�á�FAT���С�ȵȡ�
//  212        ��Щ�������󲿷���������DBR��BPB�У���˴˺�����Ҫ������DBR�Ĳ�������
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
//  219  bpb=(struct FAT32_BPB *)(FAT32_Buffer);               //�����ݻ�����ָ��תΪstruct FAT32_BPB ��ָ��
        LDR.W    R4,??DataTable14
//  220 
//  221  pArg->DEV_No=Dev_No; //װ���豸��
        LDR.W    R0,??DataTable14_2
        LDR      R0,[R0, #+0]
        LDR.W    R1,??DataTable15_1
        LDRB     R1,[R1, #+0]
        STRB     R1,[R0, #+0]
//  222 
//  223  pArg->BPB_Sector_No   =FAT32_Find_DBR();               //FAT32_FindBPB()���Է���BPB���ڵ�������
        BL       FAT32_Find_DBR
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STRB     R0,[R1, #+1]
//  224  pArg->BPB_Sector_No   =FAT32_Find_DBR();               //FAT32_FindBPB()���Է���BPB���ڵ�������
        BL       FAT32_Find_DBR
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STRB     R0,[R1, #+1]
//  225  pArg->Total_Size      =FAT32_Get_Total_Size();         //FAT32_Get_Total_Size()���Է��ش��̵�����������λ���ֽ�
        BL       FAT32_Get_Total_Size
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STR      R0,[R1, #+4]
//  226 
//  227  pArg->FATsectors      =LE2BE((bpb->BPB_FATSz32)    ,4);//װ��FAT��ռ�õ���������FATsectors��
        MOVS     R1,#+4
        ADDS     R0,R4,#+36
        BL       LE2BE
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STR      R0,[R1, #+16]
//  228  pArg->FirstDirClust   =LE2BE((bpb->BPB_RootClus)   ,4);//װ���Ŀ¼�غŵ�FirstDirClust��
        MOVS     R1,#+4
        ADDS     R0,R4,#+44
        BL       LE2BE
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STR      R0,[R1, #+8]
//  229  pArg->BytesPerSector  =LE2BE((bpb->BPB_BytesPerSec),2);//װ��ÿ�����ֽ�����BytesPerSector��
        MOVS     R1,#+2
        ADDS     R0,R4,#+11
        BL       LE2BE
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STR      R0,[R1, #+12]
//  230  pArg->SectorsPerClust =LE2BE((bpb->BPB_SecPerClus) ,1);//װ��ÿ����������SectorsPerClust ��
        MOVS     R1,#+1
        ADDS     R0,R4,#+13
        BL       LE2BE
        LDR.W    R1,??DataTable14_2
        LDR      R1,[R1, #+0]
        STR      R0,[R1, #+20]
//  231  pArg->FirstFATSector  =LE2BE((bpb->BPB_RsvdSecCnt) ,2)+pArg->BPB_Sector_No;//װ���һ��FAT�������ŵ�FirstFATSector ��
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
//  232  pArg->FirstDirSector  =(pArg->FirstFATSector)+(bpb->BPB_NumFATs[0])*(pArg->FATsectors); //װ���һ��Ŀ¼������FirstDirSector��
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
//  234  pArg->Total_Size      =FAT32_Get_Total_Size();         //FAT32_Get_Total_Size()���Է��ش��̵�����������λ����
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
//  240  - ������������ȡʣ������
//  241  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  242  - �������ԣ��ⲿ��ʹ�û�ʹ��
//  243  - ����˵������    
//  244  - ����˵����ʣ����������λ�ֽ�
//  245  - ע����FSInfo�ж�ȡ���д��������Ӽ���õ�ʣ�����������λ�ֽ�
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
//  261  - ��������������FSInfo�еĿ��ÿ��дص�����
//  262  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  263  - �������ԣ��ڲ�
//  264  - ����˵����PlusOrMinus:���ÿ��д�����1���1    
//  265  - ����˵������
//  266  - ע�������ļ���׷�����ݡ�ɾ���ļ��Ȳ��������ܻ�ʹ���õĿ��д����仯
//  267        Ҫ��ʱ����
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
//  288  - ��������������FSInfo�е���һ�����ÿ��дصĴغ�
//  289  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  290  - �������ԣ��ڲ�
//  291  - ����˵����Last_Clu:��Ҫ���µ�FSInfo�е���һ�����ÿ��дصĴغ�    
//  292  - ����˵������
//  293  - ע��FSInfo�е���һ�����ÿ��дغſ��Ը��ļ�ϵͳһ���ο���ֱ�Ӹ����ļ�ϵͳ
//  294        ��һ�����õĿ��д���ʲô�ط�
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
//  308  - ���������������һ���صĴغ�
//  309  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  310  - �������ԣ��ڲ�
//  311  - ����˵����LastCluster:��׼�غ�  
//  312  - ����˵����LastClutster����һ�صĴغ�
//  313  - ע�������һ�صĴغţ�����ƾ��FAT��������¼�Ĵ�����ϵ��ʵ�ֵ�
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
//  329  - �����������Ƚ�Ŀ¼��
//  330  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  331  - �������ԣ��ڲ�
//  332  - ����˵����a:ָ��Ŀ¼��1��ָ��
//  333              b:ָ��Ŀ¼��2��ָ��
//  334  - ����˵�����������Ŀ¼����ͬ�ͷ���1������Ϊ0
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
//  348  - �����������ļ���ƥ��(֧�ִ�*?ͨ������ļ�����ƥ��)
//  349  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  350  - �������ԣ��ڲ�
//  351  - ����˵����pat:Դ�ļ��������Ժ�*��?ͨ��� �� *.txt �� A?.mp3�ȵ�
//  352              name:Ŀ���ļ���
//  353  - ����˵������������ļ���ƥ��ͷ���1������Ϊ0
//  354  - ע������ͨ���ļ���ƥ�䣬�����������ӣ����� A*.txt �� ABC.txt��ƥ���
//  355    ͬʱ�� ABCDE.txtҲ��ƥ��ġ��˹������ļ�ö���н����õ�������ƥ��
//  356    �ļ�������һ���������ļ�
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
//  407  - ����������FAT32���ļ�Ŀ¼����ļ����ֶ�(8���ֽ�)��תΪ��ͨ���ļ���
//  408              �磺ABC     MP3 ��תΪ ABC.MP3
//  409  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  410  - �������ԣ��ڲ�
//  411  - ����˵����dName��ָ���ļ�Ŀ¼����ļ����ֶε�ָ��
//  412              pName��ָ��ת����ɺ���ļ���
//  413  - ����˵������
//  414  - ע���˺�����������FilenameMatch�������Ϳ���ʵ�ֶ��ļ���ͨ��ƥ��
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
//  432  - �������������ַ����е�Сд�ַ���תΪ��д�ַ�
//  433  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  434  - �������ԣ��ڲ�
//  435  - ����˵����str��ָ���ת�����ַ���
//  436  - ����˵������
//  437  - ע�����ļ���������£��ļ����е��ַ���ʵ���Ǵ�д�ַ���Ϊ�˷��㣬���ļ�
//  438        ����תΪ��д
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
//  451  - ��������������һ��Ŀ¼
//  452  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  453  - �������ԣ��ⲿ��ʹ�û�ʹ��
//  454  - ����˵����path:Ŀ¼��·�� ���磺"\\dir1\\dir2\\" �����һ������\\���� 
//  455  - ����˵��������Ŀ¼�Ŀ�ʼ�غţ��������Ŀ¼ʧ�ܣ�����Ŀ¼�����ڣ��򷵻�0
//  456  - ע���˺����ɺ����FAT32_Open_File�Ⱥ������ã�����ʵ�ִ�����Ŀ¼�µ��ļ�
//  457        �������û�����
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
//  526  - ������������һ���ļ�(֧���ļ���ͨ�䣬�� A*.txt �� *.*)
//  527  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  528  - �������ԣ��ⲿ��ʹ�û�ʹ��
//  529  - ����˵����pfi: FileInfoStruct���͵Ľṹ��ָ�룬����װ���ļ��Ĳ�����Ϣ
//  530               �����ļ��Ĵ�С���ļ������ơ��ļ��Ŀ�ʼ�صȵȣ��Ա�����ʹ��
//  531              filepath: �ļ���·����֧�������Ŀ¼ ����
//  532               "\\dir1\\dir2\\dir3\\....\\test.txt"
//  533 			 item�����ļ�������ͨ���*��?������£�ʵ����֮ƥ����ļ�����
//  534 			 һ����item���Ǵ򿪵��ļ����������������ͨ���������ļ���6����
//  535 			 ���item=3����ô�˺����ͻ����6���ļ��а�˳���ź�Ϊ3���Ǹ�
//  536 			 �ļ�(item��Ŵ�0��ʼ)
//  537  - ����˵����0���ɹ� 1���ļ������� 2��Ŀ¼������
//  538  - ע�����ļ����ɹ��кܶ�ԭ�򣬱����ļ������ڡ��ļ���ĳһ��Ŀ¼������
//  539        ͨ������������������ļ�����С��item��ֵ�ȵ�
//  540 	   ͨ������£��ļ�����û��ͨ�����item��ֵ����ȡ0�Ϳ�����
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
//  568 	if(FilenameMatch(temp_dir_name,temp_file_name) && pFile->deName[0]!=0xe5 && pFile->deAttributes&0x20) //ƥ���ļ���
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
//  633  - �����������ļ���λ
//  634  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  635  - �������ԣ��ⲿ��ʹ�û�ʹ��
//  636  - ����˵����pfi:FileInfoStruct���͵Ľṹ��ָ�룬����װ���ļ�������Ϣ���ļ�
//  637              ��λ��pfi��ָ��Ľṹ���е���ز����ͱ������ˣ������ļ��ĵ�ǰ
//  638              �������ļ���ǰ�����е�λ�ã��ļ��ĵ�ǰƫ�����ȵȣ��Ա�����ʹ��
//  639              offset:Ҫ��λ��ƫ���������offset�����ļ��Ĵ�С����λ���ļ���
//  640              ĩβ
//  641  - ����˵�����ļ���λ�ɹ�����0������Ϊ1
//  642  - ע���˺����������FAT32_Read_File���ã�����ʵ�ִ�ָ��λ�ö�ȡ���ݣ�������
//  643        �û�ֱ�ӵ���Щ����
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
//  664  if((offset-pfi->FileCurOffset)>=(pArg->BytesPerSector-pfi->FileCurPos))	 //Ŀ��ƫ�������ļ���ǰƫ����������ֽ�����С���ļ��ڵ�ǰ�����е�λ�õ�����ĩβ���ֽ���
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
//  718  - �������������ļ���ĳһ��λ�ô�����ȡһ�����ȵ����ݣ��������ݻ�������
//  719  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  720  - �������ԣ��ⲿ��ʹ�û�ʹ��
//  721  - ����˵����pfi:FileInfoStruct���͵Ľṹ��ָ�룬����װ���ļ�������Ϣ���ļ�
//  722              ��ȡ�Ĺ����У��˽ṹ���е���ز�������£������ļ��ĵ�ǰƫ������
//  723              �ļ��ĵ�ǰ�������ļ��ĵ�ǰ�صȵ�
//  724              offset:Ҫ��λ��ƫ������ҪС���ļ��Ĵ�С 
//  725              len:Ҫ��ȡ�����ݵĳ��ȣ����len+offset�����ļ��Ĵ�С����ʵ�ʶ�
//  726              ȡ���������Ǵ�offset��ʼ���ļ�����
//  727              pbuf:���ݻ�����
//  728  - ����˵������ȡ����ʵ�ʵ����ݳ��ȣ������ȡʧ�ܣ�����ָ����ƫ�����������ļ�
//  729              ��С���򷵻�0
//  730  - ע���ڶ�ȡһ���ļ�������ǰ�������Ƚ����ļ���FAT32_Open_File��
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
//  839  - �������������ļ�ĳһλ�ö�ȡһ�����ȵ����ݣ���pfun��ָ��ĺ���������
//  840  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  841  - �������ԣ��ⲿ��ʹ�û�ʹ��
//  842  - ����˵����pfi:FileInfoStruct���͵Ľṹ��ָ�룬����װ���ļ�������Ϣ���ļ�
//  843              ��ȡ�Ĺ����У��˽ṹ���е���ز�������£������ļ��ĵ�ǰƫ������
//  844              �ļ��ĵ�ǰ�������ļ��ĵ�ǰ�صȵ�
//  845              offset:Ҫ��λ��ƫ������ҪС���ļ��Ĵ�С 
//  846              len:Ҫ��ȡ�����ݵĳ��ȣ����len+offset�����ļ��Ĵ�С����ʵ�ʶ�
//  847              ȡ���������Ǵ�offset��ʼ���ļ�����
//  848              pfun:�Զ�ȡ�����ݵĴ�������pfunָ��������������������
//  849              �����������ȥ���������Ƿ��ڻ������У����ǰ�����ͨ�����ڷ���
//  850              ��ȥ��ֻ��Ҫpfunȥָ����Ӧ�Ĵ�����������
//  851  - ����˵������ȡ����ʵ�ʵ����ݳ��ȣ������ȡʧ�ܣ�����ָ����ƫ�����������ļ�
//  852              ��С���򷵻�0
//  853  - ע���ڶ�ȡһ���ļ�������ǰ�������Ƚ����ļ���FAT32_Open_File��
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
//  962  - ����������Ѱ�ҿ��õĿ��д�
//  963  - ����ģ�飺znFAT�ļ�ϵͳģ��
//  964  - �������ԣ��ڲ�
//  965  - ����˵������
//  966  - ����˵��������ҵ��˿��дأ����ؿ��дصĴغţ����򷵻�0
//  967  - ע��Ѱ�ҿ��д��Ǵ���Ŀ¼/�ļ��Լ����ļ�д�����ݵĻ�����������ܺܿ��Ѱ
//  968        �ҵ����дأ���ô����Ŀ¼/�ļ��Լ����ļ�д��������Щ����Ҳ��ȽϿ졣
//  969        �������Ǿ�������ʼ�Ĵ�����ȥѰ�ң�����ʹ���˶����������㷨���Դ�
//  970        ���Ϻõ�Ч����������д�û���ҵ������п��ܾ�˵���洢�豸�Ѿ�û�пռ�
//  971        ��
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
// 1004  - ��������������ļ�/Ŀ¼��
// 1005  - ����ģ�飺znFAT�ļ�ϵͳģ��
// 1006  - �������ԣ��ڲ�
// 1007  - ����˵����prec:ָ��һ��direntry���͵Ľṹ�壬���Ľṹ����FAT32���ļ�/
// 1008              Ŀ¼��Ľṹ
// 1009              name:�ļ���Ŀ¼������
// 1010              is_dir:ָʾ����ļ�/Ŀ¼�����ļ�����Ŀ¼���ֱ�����ʵ���ļ���
// 1011              Ŀ¼�Ĵ��� 1��ʾ����Ŀ¼ 0��ʾ�����ļ�
// 1012  - ����˵������
// 1013  - ע�����ﴴ���ļ���Ŀ¼�ķ����ǣ��Ƚ��ļ���Ŀ¼����Ϣ��䵽һ���ṹ���У�
// 1014        Ȼ���ٽ�����ṹ�������д�뵽�洢�豸����Ӧ����������Ӧλ����ȥ����
// 1015        ����������ļ���Ŀ¼�Ĵ�����
// 1016        ������ļ���Ŀ¼����Ϣʱ���ļ���Ŀ¼���״ز�û�����ȥ������ȫ0
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
// 1121  - ��������������FAT��
// 1122  - ����ģ�飺znFAT�ļ�ϵͳģ��
// 1123  - �������ԣ��ڲ�
// 1124  - ����˵����cluster:Ҫ���µĴ����
// 1125              dat:Ҫ����Ӧ�Ĵ������Ϊdat
// 1126  - ����˵������
// 1127  - ע�������ļ�д�������ݺ���Ҫ��FAT����и����Ա��������ݵĴ�����ϵ 
// 1128        ɾ���ļ���ʱ��Ҳ��Ҫ�����ļ��Ĵ����������������ļ��Ĵ�����ϵ
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
// 1149  - �������������ĳ���ص��������������0
// 1150  - ����ģ�飺znFAT�ļ�ϵͳģ��
// 1151  - �������ԣ��ڲ�
// 1152  - ����˵����cluster:Ҫ��յĴصĴغ�
// 1153  - ����˵������
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
// 1171  - �����������ڴ洢�豸�д���һ���ļ�/Ŀ¼��
// 1172  - ����ģ�飺znFAT�ļ�ϵͳģ��
// 1173  - �������ԣ��ڲ�
// 1174  - ����˵����pfi:ָ��FileInfoStruct���͵Ľṹ�壬����װ�ظմ������ļ�����Ϣ
// 1175                  Ҳ����˵�������������Ŀ¼����˽ṹ�岻�ᱻ����
// 1176              cluster:��cluster������д����ļ�/Ŀ¼�����ʵ��������Ŀ¼��
// 1177                  �����ļ���Ŀ¼������ͨ��FAT32_Enter_Dir����ȡĳһ��Ŀ¼�Ŀ�
// 1178                  ʼ��
// 1179              name:�ļ�/Ŀ¼������
// 1180              is_dir:ָʾҪ���������ļ�����Ŀ¼���ļ���Ŀ¼�Ĵ��������ǲ�ͬ��
// 1181                  1��ʾ����Ŀ¼ 0��ʾ�����ļ�
// 1182  - ����˵�����ɹ�����1��ʧ�ܷ���-1
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
// 1311  - ������������ĳһ���ļ�׷������
// 1312  - ����ģ�飺znFAT�ļ�ϵͳģ��
// 1313  - �������ԣ��ⲿ��ʹ�û�ʹ��
// 1314  - ����˵����pfi:ָ��FileInfoStruct���͵Ľṹ�壬����װ�ظմ������ļ�����Ϣ
// 1315              len:Ҫ׷�ӵ����ݳ���
// 1316              pbuf:ָ�����ݻ�������ָ��
// 1317  - ����˵�����ɹ�����ʵ��д������ݳ��ȣ�ʧ�ܷ���0
// 1318  - ע��׷������ʧ�ܺ��п����Ǵ洢�豸�Ѿ�û�пռ��ˣ�Ҳ�����Ҳ������д���
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
// 1350    if(!(temp_file_size%(pArg->SectorsPerClust*pArg->BytesPerSector))) //�ڴص���ĩβ�ٽ�ط�����ҪѰ���´�
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
// 1373   FAT32_WriteSector(pfi->FileCurSector,FAT32_Buffer); //���ݽӷ�  
??FAT32_Add_Dat_9:
        LDR.W    R1,??DataTable23
        LDR      R0,[R4, #+24]
        BL       FAT32_WriteSector
// 1374   
// 1375   if(pfi->FileCurSector-(SOC(pfi->FileCurCluster))<(pArg->SectorsPerClust-1)) //�ж��ǲ���һ���ص����һ������,�Ƚ���ǰ�������������� 
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
// 1460  - ��������������Ŀ¼(֧�������Ŀ¼����)
// 1461  - ����ģ�飺znFAT�ļ�ϵͳģ��
// 1462  - �������ԣ��ⲿ��ʹ�û�ʹ��
// 1463  - ����˵����pfi:����
// 1464              dirpath:Ŀ¼·�� ���� "\\dir1\\dir2\\dir3\\....\\dirn\\"
// 1465              ��������\\����
// 1466  - ����˵�����ɹ�����0��ʧ�ܷ���1
// 1467  - ע������м�ĳһ��Ŀ¼�����ڣ�������������·����dir3�����ڣ���ô�˺�����
// 1468        �������Ŀ¼��Ȼ���ټ���ȥ����������Ŀ¼
// 1469        ����Ŀ¼ʧ���п�������Ϊ�洢�豸�ռ䲻��
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
// 1485  - ���������������ļ�(֧�������Ŀ¼����)
// 1486  - ����ģ�飺znFAT�ļ�ϵͳģ��
// 1487  - �������ԣ��ⲿ��ʹ�û�ʹ��
// 1488  - ����˵����pfi:һ��ָ��FileInfoStruct���͵Ľṹ���ָ�룬����װ���´�����
// 1489              �ļ���Ϣ������´������ļ������ٴ򿪾Ϳ���ֱ��������
// 1490              filepath:�ļ�·�� ���� "\\dir1\\dir2\\dir3\\....\\dirn\\test.txt"
// 1491  - ����˵����0���ɹ� 1���ļ��Ѵ��� 2�������ļ�Ŀ¼ʧ�� 3�������ļ�ʧ��
// 1492  - ע������ļ�·����ĳһ���м�Ŀ¼�����ڣ���ô�˺����ᴴ�����Ŀ¼���ټ���
// 1493        ȥ����������Ŀ¼��һֱ�������ļ�������ɡ�
// 1494        �����ļ�ʧ���п�������Ϊ�洢�豸�ռ䲻�㣬���Ǵ��ļ��Ѿ�����
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
// 1521  - ����������ɾ���ļ�(֧�������Ŀ¼)
// 1522  - ����ģ�飺znFAT�ļ�ϵͳģ��
// 1523  - �������ԣ��ⲿ��ʹ�û�ʹ��
// 1524  - ����˵����filepath:�ļ�·�� ���� "\\dir1\\dir2\\dir3\\....\\dirn\\test.txt"
// 1525  - ����˵����1:�ļ���Ŀ¼·�������� 0:�ɹ�
// 1526  - ע��ɾ������ļ���FAT���еĴ�����ϵ��ȫ���ƻ�
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
// 1561  - �����������ļ�����(Դ�ļ�·����Ŀ���ļ�·����֧���������Ŀ¼������֧��
// 1562              �ļ���ͨ��)
// 1563  - ����ģ�飺znFAT�ļ�ϵͳģ��
// 1564  - �������ԣ��ⲿ��ʹ�û�ʹ��
// 1565  - ����˵����pArg1:��Դ�ļ����ڵĴ洢�豸�ĳ�ʼ�����ṹ���ָ��
// 1566              pArg2:��Ŀ���ļ����ڵĴ洢�豸�ĳ�ʼ�����ṹ���ָ��
// 1567              sfilename:Դ�ļ�·����Ҳ���ǿ�������������Դ
// 1568              tfilename:Ŀ���ļ�·����Ҳ�����������յ�д����ļ�
// 1569                        ���� "\\dir1\\dir2\\dir3\\....\\dirn\\test.txt" 
// 1570              file_buf:����������Ҫ�õ������ݻ��������˻���������Խ��
// 1571                       �����ٶ�Խ��
// 1572              buf_size:���ݻ������Ĵ�С 
// 1573  - ����˵����1:Ŀ¼�ļ�����ʧ�� 2:Դ�ļ��򿪴�� 0:�ɹ�
// 1574  - ע���˺���֧�ֶ��豸֮����ļ�������pArg1��pArg2������Դ�洢�豸��Ŀ��
// 1575        �洢�豸�ĳ�ʼ������Ϣ���Ӷ�����ͬʱ�������洢�豸���в�����
// 1576 	   znFAT 5.01�濪ʼ֧�ֶ��豸�����豸����໥���ݿ���������͵�Ӧ��
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
// 1612  - �����������ļ�������
// 1613  - ����ģ�飺znFAT�ļ�ϵͳģ��
// 1614  - �������ԣ��ⲿ��ʹ�û�ʹ��
// 1615  - ����˵����filename:��Ҫ��������Դ�ļ���·�� ��\a.txt
// 1616              newfilename:Ŀ���ļ��� ��b.txt (עĿ���ļ����ǵ������ļ�����
// 1617 			 ����·��)
// 1618  - ����˵����1:Դ�ļ��򿪴�� 0:�ɹ�
// 1619  - ע����
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
// 1626  if(FAT32_Open_File(&fi,filename,0)) return 1; //�ļ���ʧ��
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
// 1646  - �����������ļ��ر�
// 1647  - ����ģ�飺znFAT�ļ�ϵͳģ��
// 1648  - �������ԣ��ⲿ��ʹ�û�ʹ��
// 1649  - ����˵����pfi:ָ��ǰ�򿪵��ļ����ļ���Ϣ�ṹ
// 1650  - ����˵����0:�ɹ�
// 1651  - ע����
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
// 1664  - �����������ļ��½�
// 1665  - ����ģ�飺FAT�ļ�ϵͳģ��
// 1666  - �������ԣ��ⲿ��ʹ�û�ʹ��
// 1667  - ����˵����pfi:һ��ָ��FileInfoStruct���͵Ľṹ���ָ�룬����װ���´�����
// 1668              �ļ���Ϣ������´������ļ������ٴ򿪾Ϳ���ֱ��������
// 1669              filepath:�ļ�·�� ���� "\\dir1\\dir2\\dir3\\....\\dirn\\test.txt"
// 1670  - ����˵����0���ɹ� 1���ļ��Ѵ���,���´��� 2�������ļ�Ŀ¼ʧ�� 3�������ļ�ʧ��
// 1671  - ע����
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
