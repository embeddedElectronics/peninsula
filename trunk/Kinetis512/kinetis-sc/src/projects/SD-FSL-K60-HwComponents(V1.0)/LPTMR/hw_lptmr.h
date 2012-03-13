//============================================================================
// 文件名称：hw_lptmr.h                                                          
// 功能概要：lptmr构件头文件(Low Power Timer)
// 版权所有: 苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
// 版本更新:     时间                     版本                                       修改
//           2011-12-4     V0.8       编写了K60的LPTMR驱动
//============================================================================
#ifndef __lptmr_H__
#define __lptmr_H__


#include "common.h"

//Pin Select constants for CSR[TPS]
#define HSCMP      0x0
#define LPTMR_ALT1 0x1  // PORTA19 pin 18
#define LPTMR_ALT2 0x2  // PORTC5
#define LPTMR_ALT3 0x3

//CSR[TPP] constants
#define RISING 0
#define FALLING LPTMR_CSR_TPP_MASK

//中断号
#define LPTMRLPTMR_irq (101-16) //85

//============================================================================
//函数名称：hw_lptmr_internal_ref_init
//函数返回：无
//参数说明：内部参考时钟初始化
//功能概要：采用内部参考时钟（PSC=0X0）
//         内部参考时钟有两个时钟源:(1)MCG_C2[IRCS]=0,使用慢速内部时钟(32kHz)
//                                 (2)MCG_C2[IRCS]=1,使用快速内部时钟(2Mhz)   
//         本例采用的是快速时钟源，周期= compare_value/ClkBus/prescale=4秒
//         prescale = 2^(8+1)=512,ClkBus=2Mhz,compare_value=15625
//============================================================================
void hw_lptmr_internal_ref_init();

//============================================================================
//函数名称：hw_lptmr_LPO_init
//函数返回：无
//参数说明：LPO时钟初始化
//功能概要：采用LPO时钟（PSC=0X1,1kHz）   
//         本例采用的是快速时钟源，周期= compare_value/ClkBus/prescale=5秒
//         prescale = 无,ClkBus=1kHz,compare_value=5000
//============================================================================
void hw_lptmr_LPO_init();

//============================================================================
//函数名称：hw_lptmr_32khz_init
//函数返回：无
//参数说明：LDO时钟初始化
//功能概要：采用二级外部参考时钟（PSC=0x2,32kHz）   
//         SOPT1[OSC32KSEL]=1,使用连接到XTAL32上的32kHz RTC crystal
//         SOPT1[OSC32KSEL]=0,使用连32kHz 系统 crystal，需要主板上有32kHz的crystal
//
//         周期= compare_value/ClkBus/prescale=5秒
//         prescale = 无,ClkBus=1kHz,compare_value=5000
//============================================================================
void hw_lptmr_32khz_init();

//============================================================================
//函数名称：hw_lptmr_external_clk_init
//函数返回：无
//参数说明：外部时钟初始化
//功能概要：采用二级外部参考时钟（PSC=0x3,50MHz）   
//
//         周期= compare_value/ClkBus/prescale=1秒
//         prescale = 1024,ClkBus=48MHz,compare_value=46875
//============================================================================
void hw_lptmr_external_clk_init();

//============================================================================
//函数名称：hw_lptmr_pulse_counter
//函数返回：无
//参数说明：选择的引脚（仅1,2）
//功能概要：脉冲累加功能 仅LPTMR0_ALT1和LPTMR0_ALT2引脚
//         LPTMR0_ALT1是引脚PORTA19 (ALT6)
//         LPTMR0_ALT2是引脚PORTC5 (ALT4).
//         
//============================================================================
void hw_lptmr_pulse_counter(char pin_select);

//============================================================================
//函数名称：hw_lptmr_clear_registers
//函数返回：无
//参数说明：无
//功能概要：清LPT模块的所有寄存器
//============================================================================
void hw_lptmr_clear_registers();

//============================================================================
//函数名称：hw_enable_lptmr_int
//函数返回：无
//参数说明：无
//功能概要：开启LPT定时器中断
//============================================================================
void hw_enable_lptmr_int();

//============================================================================
//函数名称：hw_disable_lptmr_int
//函数返回：无
//参数说明：无
//功能概要：关闭LPT定时器中断
//============================================================================
void hw_disable_lptmr_int();

#endif /* __LPTMR_H__ */
