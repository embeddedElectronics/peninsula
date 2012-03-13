//============================================================================
//文件名称：hw_tsi.c
//功能概要：K60 tsi底层驱动程序文件
//版权所有：苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
//版本更新：2011-11-25  V1.0   初始版本
//============================================================================

#include "hw_tsi.h"

//============================================================================
//函数名称：hw_tsi_init                                                  
//功能概要：初始化TSI模块                                                  
//参数说明：chnlIDs:16位无符号数，                                          
//                 为1位的对应通道为启动TSI功能
//                 为0的对应通道为不启动TSI功能                                          
//函数返回： 无                                                               
//============================================================================
void hw_tsi_init(uint16 chnlIDs)
{
	//启动TSI模块时钟  
    SIM_SCGC5 |= (SIM_SCGC5_TSI_MASK); 

    //设定TSI的工作参数,默认未启动TSI中断,软件触发扫描
    TSI0_GENCS |= ((TSI_GENCS_NSCN(10))      //对每个TSI电极扫描次数的设定，此处设为10次
                  |(TSI_GENCS_PS(3)))      //对扫描频率的预分频设定，此处设为2^3
                  |(TSI_GENCS_TSIIE_MASK) ;  //启动TSI中断
    
    TSI0_SCANC |= ((TSI_SCANC_EXTCHRG(3))    //外部振荡器充电电流选择设定，此处设为4uA
                  |(TSI_SCANC_REFCHRG(31))   //参考时钟充电电路选择设定，此处设为32uA
                  |(TSI_SCANC_DELVOL(7))     //增量电压选择设定，此处设为600mV
                  |(TSI_SCANC_SMOD(0))       //设定扫描模数，此处设定为连续扫描
                  |(TSI_SCANC_AMPSC(0)));    //激活模式预分频，此处设定值为1，即不分频
   
    //引脚功能使能
    TSI0_PEN |= chnlIDs;
 
    //TSI功能使能
    TSI0_GENCS |= (TSI_GENCS_TSIEN_MASK);
}


//============================================================================
//函数名称：hw_tsi_get_value16                                                  
//功能概要：获取指定所有16个TSI通道的计数值                                                  
//参数说明：values[]:16位无符号数组，保存各通道计数值，                                                                                    
//函数返回： 为一次性获取所有TSI通道的计数值                                                                
//============================================================================
void hw_tsi_get_value16(uint16 values[])
{
	//启动一次软件触发扫描
    TSI0_GENCS |= TSI_GENCS_SWTS_MASK;
    //等待扫描完成    
    while(!TSI0_GENCS&TSI_GENCS_EOSF_MASK){};
        
    //读取计数寄存器中的值
    values[0]  = TSI_CH0_CNTR;
    values[1]  = TSI_CH1_CNTR;
    values[2]  = TSI_CH2_CNTR;
    values[3]  = TSI_CH3_CNTR;
    values[4]  = TSI_CH4_CNTR;
    values[5]  = TSI_CH5_CNTR;
    values[6]  = TSI_CH6_CNTR;
    values[7]  = TSI_CH7_CNTR;
    values[8]  = TSI_CH8_CNTR;
    values[9]  = TSI_CH9_CNTR;
    values[10] = TSI_CH10_CNTR;
    values[11] = TSI_CH11_CNTR;
    values[12] = TSI_CH12_CNTR;
    values[13] = TSI_CH13_CNTR;
    values[14] = TSI_CH14_CNTR;
    values[15] = TSI_CH15_CNTR;
 
    TSI0_GENCS |= TSI_GENCS_OUTRGF_MASK; //清超出范围标志位
    TSI0_GENCS |= TSI_GENCS_EOSF_MASK;  //清扫描结束标志位
    TSI0_STATUS = 0xFFFFFFFF;  //清状态位
    
}


//============================================================================
//函数名称：hw_tsi_get_value1                                                  
//功能概要：获取指定TSI通道的计数值                                                 
//参数说明：chnlID:8位无符号数，要获取计数值的通道号                                                                                    
//函数返回： 返回指定通道的计数值                                                               
//============================================================================
uint16 hw_tsi_get_value1(uint8 chnlID)
{
    uint16 values[16];
    
    if (chnlID >15) 
    {
        chnlID = 15;
    }
    
    hw_tsi_get_value16(values);
    
    return values[chnlID];
}


//============================================================================
//函数名称：hw_tsi_set_threshold1                                                  
//功能概要：设定指定通道的阈值                                                  
//参数说明：chnlID:8位无符号数，要设定的通道号                               
//            low:   设定阈值下限                                              
//           high:  设定阈值上限                                                                                      
//函数返回： 无                                                             
//============================================================================

void hw_tsi_set_threshold1(uint8 chnlID, uint16 low, uint16 high)
{
    uint32 thresholdValue;
    
    thresholdValue = low;
    thresholdValue = (thresholdValue<<16)|high;
    TSI_THRESHLD_REG(TSI0_BASE_PTR, chnlID) = thresholdValue;
}
//============================================================================
//函数名称：hw_tsi_set_threshold16                                                  
//功能概要：设定所有16个通道的阈值                                                
//参数说明：chnlID:8位无符号数，要设定的通道号                               
//           lows: 设定阈值下限数组                                         
//          highs:设定阈值上限数组                                                                                                                         
//函数返回： 无                                                             
//============================================================================
void hw_tsi_set_threshold16(uint16 lows[], uint16 highs[])
{
    uint8 i;
    for (i = 0; i < 16; i++)
    {
        hw_tsi_set_threshold1(i, lows[i], highs[i]);
    }
}


