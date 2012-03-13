//============================================================================
//文件名称：hw_flash.h
//功能概要：K60 Flash擦除/写入底层驱动程序头文件
//版权所有：苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
//版本更新：2011-11-20  V1.0   初始版本
//         2011-12-16  V1.1  （1）清除冗余代码
//                           （2）规范注释
//============================================================================

#ifndef _HW_FLASH_H
#define _HW_FLASH_H

//k60N512包含512K的程序Flash
//512K的程序Flash分为256个扇区，每个扇区2K大小
//    sector（2K）为擦除最小单位
//    长字（32b）为写的最小单位

#include "common.h"

//==========================================================================
//函数名称：hw_flash_init
//函数返回：无
//参数说明：无
//功能概要：初始化flash模块
//==========================================================================
void hw_flash_init();

//==========================================================================
//函数名称：hw_flash_erase_sector
//函数返回：函数执行执行状态：0=正常；非0=异常。
//参数说明：sectorNo：扇区号（K60N512实际使用0~255）
//功能概要：擦除指定flash扇区
//==========================================================================
uint8 hw_flash_erase_sector(uint16 sectorNo);

//==========================================================================
//函数名称：hw_flash_write
//函数返回：函数执行状态：0=正常；非0=异常。
//参数说明：sectNo：目标扇区号 （K60N512实际使用0~255）
//         offset:写入扇区内部偏移地址（0~2043）
//         cnt：写入字节数目（0~2043）
//         buf：源数据缓冲区首地址
//功能概要：flash写入操作
//==========================================================================
uint8 hw_flash_write(uint16 sectNo,uint16 offset,uint16 cnt,uint8 buf[]);

#endif //_HW_FLASH_H__ 
