//============================================================================
//文件名称：hw_tsi.h
//功能概要：K60 tsi底层驱动程序头文件
//版权所有：苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
//版本更新：2011-11-25  V1.0   初始版本
//============================================================================

#ifndef __TSI_H__
#define __TSI_H__

    //1 头文件
    #include "common.h"
    #include "hw_uart.h"
    
    //2 宏定义

    //启动TSI模块
    #define TSI_ENABLE  TSI0_GENCS |=  TSI_GENCS_TSIEN_MASK
    //关闭TSI模块
    #define TSI_DISABLE TSI0_GENCS &= ~TSI_GENCS_TSIEN_MASK
    
    //启动TSI中断触发模式，同时启动自动周期扫描  
    //TSI Vector is 99. IRQ# is 99-16=83
    #define hw_tsi_enable_interrupt do {\
                  enable_irq(83);\
                  TSI0_GENCS |= (TSI_GENCS_TSIIE_MASK|TSI_GENCS_STM_MASK);\
            } while (0)
    //放弃TSI中断触发模式，同时放弃自动周期扫描
    #define hw_tsi_disable_interrupt do {\
                  TSI0_GENCS &= ~(TSI_GENCS_TSIIE_MASK|TSI_GENCS_STM_MASK);\
            } while (0)
//TSI端口加载掩码
#define TSI_PORTA_MASK   0xE000
#define TSI_PORTB_MASK   0x1FC1
#define TSI_PORTC_MASK   0x003E

//TSI通道掩码
#define TSI_CH0_MASK     0x0001
#define TSI_CH1_MASK     0x0002
#define TSI_CH2_MASK     0x0004
#define TSI_CH3_MASK     0x0008
#define TSI_CH4_MASK     0x0010
#define TSI_CH5_MASK     0x0020
#define TSI_CH6_MASK     0x0040
#define TSI_CH7_MASK     0x0080
#define TSI_CH8_MASK     0x0100
#define TSI_CH9_MASK     0x0200
#define TSI_CH10_MASK    0x0400
#define TSI_CH11_MASK    0x0800
#define TSI_CH12_MASK    0x1000
#define TSI_CH13_MASK    0x2000
#define TSI_CH14_MASK    0x4000
#define TSI_CH15_MASK    0x8000
              
//TSI通道计数寄存器
#define TSI_CH0_CNTR     (uint16)((TSI0_CNTR1)&0x0000FFFF)
#define TSI_CH1_CNTR     (uint16)((TSI0_CNTR1>>16)&0x0000FFFF)
#define TSI_CH2_CNTR     (uint16)((TSI0_CNTR3)&0x0000FFFF)
#define TSI_CH3_CNTR     (uint16)((TSI0_CNTR3>>16)&0x0000FFFF)
#define TSI_CH4_CNTR     (uint16)((TSI0_CNTR5)&0x0000FFFF)
#define TSI_CH5_CNTR     (uint16)((TSI0_CNTR5>>16)&0x0000FFFF)
#define TSI_CH6_CNTR     (uint16)((TSI0_CNTR7)&0x0000FFFF)
#define TSI_CH7_CNTR     (uint16)((TSI0_CNTR7>>16)&0x0000FFFF)
#define TSI_CH8_CNTR     (uint16)((TSI0_CNTR9)&0x0000FFFF)
#define TSI_CH9_CNTR     (uint16)((TSI0_CNTR9>>16)&0x0000FFFF)
#define TSI_CH10_CNTR    (uint16)((TSI0_CNTR11)&0x0000FFFF)
#define TSI_CH11_CNTR    (uint16)((TSI0_CNTR11>>16)&0x0000FFFF)
#define TSI_CH12_CNTR    (uint16)((TSI0_CNTR13)&0x0000FFFF)
#define TSI_CH13_CNTR    (uint16)((TSI0_CNTR13>>16)&0x0000FFFF)
#define TSI_CH14_CNTR    (uint16)((TSI0_CNTR15)&0x0000FFFF)
#define TSI_CH15_CNTR    (uint16)((TSI0_CNTR15>>16)&0x0000FFFF)        



//3 函数声明
//============================================================================
//函数名称：hw_tsi_init                                                  
//功能概要：初始化TSI模块                                                  
//参数说明：chnlIDs:16位无符号数，                                          
//                 为1位的对应通道为启动TSI功能
//                 为0的对应通道为不启动TSI功能                                          
//函数返回： 无                                                               
//============================================================================
void hw_tsi_init(uint16 chnlIDs);
    
//============================================================================
//函数名称：hw_tsi_get_value16                                                  
//功能概要：获取指定所有16个TSI通道的计数值                                                  
//参数说明：values[]:16位无符号数组，保存各通道计数值，                                                                                    
//函数返回： 为一次性获取所有TSI通道的计数值                                                                
//============================================================================
void hw_tsi_get_value16(uint16 values[]);


//============================================================================
//函数名称：hw_tsi_get_value1                                                  
//功能概要：获取指定TSI通道的计数值                                                 
//参数说明：chnlID:8位无符号数，要获取计数值的通道号                                                                                    
//函数返回： 返回指定通道的计数值                                                               
//============================================================================
uint16 hw_tsi_get_value1(uint8 chnlID);
    
//============================================================================
//函数名称：hw_tsi_set_threshold1                                                  
//功能概要：设定指定通道的阈值                                                  
//参数说明：chnlID:8位无符号数，要设定的通道号                               
//            low:   设定阈值下限                                              
//           high:  设定阈值上限                                                                                      
//函数返回： 无                                                             
//============================================================================
void hw_tsi_set_threshold1(uint8 chnlID, uint16 low, uint16 high);

//============================================================================
//函数名称：hw_tsi_set_threshold16                                                  
//功能概要：设定所有16个通道的阈值                                                
//参数说明：chnlID:8位无符号数，要设定的通道号                               
//           lows: 设定阈值下限数组                                         
//          highs:设定阈值上限数组                                                                                                                         
//函数返回： 无                                                             
//============================================================================
void hw_tsi_set_threshold16(uint16 lows[], uint16 highs[]);

#endif 
