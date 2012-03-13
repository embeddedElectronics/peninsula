//============================================================================
//文件名称：common.h
//功能概要：包含了芯片寄存器映像头文件，类型宏定义等
//版权所有：苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
//更新记录：2011-11-13   V1.0     初始版本
//         2011-12-20   V1.1     规范排版
//============================================================================


#ifndef _COMMON_H_
#define _COMMON_H_

//1 头文件
#include "MK60N512VMD100.h"   //寄存器映像头文件

//2 宏定义
//2.1 存储器段的宏定义
#pragma define_section relocate_code ".relocate_code" ".relocate_code" ".relocate_code" far_abs RX
#pragma define_section relocate_data ".relocate_data" ".relocate_data" ".relocate_data" RW
#pragma define_section relocate_const ".relocate_const" ".relocate_const" ".relocate_const" far_abs R
#define __relocate_code__   __declspec(relocate_code)
#define __relocate_data__   __declspec(relocate_data)
#define __relocate_const__  __declspec(relocate_const)

//2.2 用于中断的宏定义
#define ARM_INTERRUPT_LEVEL_BITS          4   //中断优先级宏定义
#define EnableInterrupts  asm(" CPSIE i");    //开总中断
#define DisableInterrupts asm(" CPSID i");    //关总中断

//2.3 置位、清位、获得寄存器一位的状态
#define BSET(bit,Register)  ((Register)|= (1<<(bit)))    //置寄存器的一位
#define BCLR(bit,Register)  ((Register) &= ~(1<<(bit)))  //清寄存器的一位
#define BGET(bit,Register)  (((Register) >> (bit)) & 1)  //获得寄存器一位的状态

//2.2 类型别名宏定义
typedef unsigned char         uint8;  // 无符号8位数，字节
typedef unsigned short int    uint16; // 无符号16位数，字
typedef unsigned long int     uint32; // 无符号32位数，长字

typedef volatile uint8        vuint8;  // 不优化无符号8位数，字节
typedef volatile uint16       vuint16; // 不优化无符号16位数，字
typedef volatile uint32       vuint32; // 不优化无符号32位数，长字

typedef signed char           int8;   // 有符号8位数
typedef short int             int16;  // 有符号16位数
typedef int                   int32;  // 有符号32位数

typedef volatile int8         vint8;  // 不优化有符号8位数
typedef volatile int16        vint16; // 不优化有符号16位数
typedef volatile int32        vint32; // 不优化有符号32位数

typedef unsigned char     BYTE;  		/*unsigned 8 bit definition */
typedef unsigned short    WORD; 		/*unsigned 16 bit definition*/
typedef unsigned long     DWORD; 		/*unsigned 32 bit definition*/
typedef long int    	  LONG;  		/*signed 32 bit definition*/

#define NULL (void *)0
#define FALSE        0
#define TRUE         1


#endif 
