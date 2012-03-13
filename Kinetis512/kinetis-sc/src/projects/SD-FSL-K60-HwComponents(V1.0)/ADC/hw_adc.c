//============================================================================
//文件名称：hw_adc.c  
//功能概要：adc构件源文件
//版权所有：苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
//版本更新：2011-11-13  V1.0   初始版本
//          2011-11-21   V1.1   规范排版风格
//============================================================================

#include "hw_adc.h"

//============================================================================
//函数名称：hw_adc_init
//函数返回：0 成功 ，1 失败
//参数说明：MoudelNumber：模块号
//功能概要：AD初始化
//============================================================================
uint8 hw_adc_init(int MoudelNumber)
{
    if(MoudelNumber == 0)//模块0
    {
    	//打开ADC0模块时钟
        SIM_SCGC6 |= (SIM_SCGC6_ADC0_MASK );
    }
    else if(MoudelNumber == 1)//模块1
    {      
    	//打开ADC1模块时钟
        SIM_SCGC3 |= (SIM_SCGC3_ADC1_MASK );
    }
    else
    {
        return 0;
    }
    
    return 1;
}



//============================================================================
//函数名称：hw_ad_once
//函数返回：16位无符号的AD值 
//参数说明：MoudelNumber：模块号
//               Channel：通道号
//              accuracy：精度
//功能概要：采集一次一路模拟量的AD值    
//============================================================================
uint16 hw_adc_once(int MoudelNumber,int Channel,uint8 accuracy)//采集某路模拟量的AD值
{
		uint16 result = 0;
		uint8 ADCCfg1Mode = 0;
		ADC_MemMapPtr ADCMoudel;//保存ADC模块地址指针
				
		switch(accuracy)
		{
			 case 8:
			   ADCCfg1Mode = 0x00;
			   break;
			 case 12:
			   ADCCfg1Mode = 0x01;
			   break;
			 case 10:
			   ADCCfg1Mode = 0x02;
			   break;
			 case 16:
			   ADCCfg1Mode = 0x03;
			   break;
			 default:
			   ADCCfg1Mode = 0x00;
		}
		
		
		if(MoudelNumber==0)//选择ADC模块0
		{
		   ADCMoudel = ADC0_BASE_PTR;
		}
		else               //选择ADC模块1
		{
		   ADCMoudel = ADC1_BASE_PTR;
		}
		
		//配置正常电源模式，总线时钟，总线时钟4分频，长采样时间使能，设置精度
		ADC_CFG1_REG(ADCMoudel) = ADLPC_NORMAL
								 | ADC_CFG1_ADIV(ADIV_4)
								 | ADLSMP_LONG
								 | ADC_CFG1_MODE(ADCCfg1Mode)
								 | ADC_CFG1_ADICLK(ADICLK_BUS);
		   
		//配置禁止异步时钟使能输出，ADxxat通道选择，高速配置，长采样时间   
		ADC_CFG2_REG(ADCMoudel)  =    MUXSEL_ADCA
								 | ADACKEN_DISABLED
								 | ADHSC_HISPEED
								 | ADC_CFG2_ADLSTS(ADLSTS_20) ;
								
		//设置通道号
		ADC_SC1_REG(ADCMoudel,A) = AIEN_ON | DIFF_SINGLE | ADC_SC1_ADCH(Channel);
	    //等待转换完成
    	while (( ADC_SC1_REG(ADCMoudel,A) & ADC_SC1_COCO_MASK ) != ADC_SC1_COCO_MASK)
		{

		}
	    //读取转化结果
		result = ADC_R_REG(ADCMoudel,A);       
		//清ADC转换完成标志
		ADC_SC1_REG(ADCMoudel,A) &= ~ADC_SC1_COCO_MASK;

    return result;
}

//============================================================================
//函数名称：hw_ad_mid
//函数返回：16位无符号的AD值 
//参数说明：MoudelNumber：模块号
//               Channel：通道号
//              accuracy：精度
//功能概要：中值滤波后的结果(范围:0-4095) 
//============================================================================
uint16 hw_adc_mid(int MoudelNumber,int Channel,uint8 accuracy) 
{
	uint16 i,j,k,tmp;
	//1.取3次A/D转换结果
	i = hw_adc_once(MoudelNumber,Channel,accuracy);
	j = hw_adc_once(MoudelNumber,Channel,accuracy);
	k = hw_adc_once(MoudelNumber,Channel,accuracy);
	//2.取中值
	if (i > j)
	{
		tmp = i; i = j; j = tmp;
	}
	if (k > j) 
	  tmp = j;
	else if(k > i) 
	  tmp = k;
    else 
      tmp = i;
	return tmp;
}

//============================================================================
//函数名称：hw_ad_ave
//函数返回：16位无符号的AD值 
//参数说明：MoudelNumber：模块号
//               Channel：通道号
//              accuracy：精度
//                     N:均值滤波次数(范围:0~255)
//功能概要：均值滤波后的结果(范围:0-4095) 
//============================================================================
uint16 hw_adc_ave(int MoudelNumber,int Channel,uint8 accuracy,uint8 N) 
{
	uint32 tmp = 0;
	uint8  i;
    for(i = 0; i < N; i++)
		tmp += hw_adc_mid(MoudelNumber,Channel,accuracy);
	tmp = tmp / N; 
    return (uint16)tmp;
}
