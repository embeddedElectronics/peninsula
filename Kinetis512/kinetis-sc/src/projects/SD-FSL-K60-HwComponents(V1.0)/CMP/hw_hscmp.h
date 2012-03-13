//============================================================================
//文件名称：hw_hscmp.h
//功能概要：K60 比较器底层驱动程序头文件
//版权所有：苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
//版本更新：2011-11-25  V1.0   初始版本
//============================================================================

#ifndef HSCMP_H
#define HSCMP_H 1

	//1 头文件
	#include "common.h"

	//2 宏定义
	//2.1比较模块号宏定义
	#define cmpch0 CMP0_BASE_PTR
	#define cmpch1 CMP1_BASE_PTR
	#define cmpch2 CMP2_BASE_PTR
	  
	//2.2比较引脚宏定义 
	#define GPIO_PIN_MASK            0x1Fu
	#define GPIO_PIN(x)              (((1)<<(x & GPIO_PIN_MASK)))

	//2.3 比较模块中断号处理
	#define CMP0irq 59
	#define CMP1irq 60
	#define CMP2irq 61

	//3函数声明
	

	//============================================================================
	//函数名称：hw_cmp_init
	//函数返回     无
	//参数说明：MoudleNumber: 比较器模块号
	//         reference:参考电压选择  0=VDDA 3.3V 1=VREF 1.2V
	//         plusChannel: 正比较通道号
	//         minusChannel：负比较通道号
	//功能概要：CMP模块初始化
	//============================================================================
	void hw_cmp_init(int MoudleNumber,uint8 reference,uint8 plusChannel,uint8 minusChannel);
	//============================================================================
	//函数名称：hw_dac_set_value
	//函数返回：无
	//参数说明：MoudleNumber: 比较器模块号
	//         value: dac输出的转换值
	//功能概要：开比较中。
	//============================================================================
	void hw_dac_set_value(int MoudleNumber,uint8 value);
	//============================================================================
	//函数名称：hw_enable_cmp_int
	//函数返回：无
	//参数说明：MoudleNumber: 比较器模块号
	//         irqno: 对应irq号
	//功能概要：开比较中。
	//============================================================================
	void hw_enable_cmp_int(int MoudleNumber,uint8 irqno);

	//============================================================================
	//函数名称：hw_disable_cmp_int
	//函数返回：无
	//参数说明：MoudleNumber: 比较器模块号
	//         irqno: 对应irq号
	//功能概要：关比较中断
	//============================================================================
	void hw_disable_cmp_int(int MoudleNumber,uint8 irqno);
	

	//============================================================================
	//函数名称：hw_cmp_get_base_address  
	//函数返回：比较器模块的基址值                                                 
	//参数说明：MoudleNumber:模块号      
	//功能概要：获取比较模块的基址   
	                                                              
	//============================================================================
	CMP_MemMapPtr hw_cmp_get_base_address(uint8 MoudleNumber);
	
#endif  //__ISR_H

