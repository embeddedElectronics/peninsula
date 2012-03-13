//============================================================================
//文件名称：hw_dac.c
//功能概要：K60 DAC底层驱动程序文件
//版权所有：苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
//更新记录：2011-11-17   V1.0    初始版本
//============================================================================

#include "hw_dac.h"               //包含DAC驱动程序头文件   

//============================================================================
//函数名称：hw_dac_init
//函数返回：无
//参数说明：ModelNumber：通道号0、1。                         
//         RefVoltage：参考电压选择。0=1.2V，1=3.3V。
//功能概要：初始化DAC模块设定。
//============================================================================
void hw_dac_init(uint8 ModelNumber,uint8 RefVoltage)
{
    uint8 VreRF = DAC_SEL_VREFO;
    if(RefVoltage == 1)
    {
        VreRF =  DAC_SEL_VDDA;                  //3.3V 
    }
    
    if(ModelNumber == 0)
    {
        SIM_SCGC2 |= SIM_SCGC2_DAC0_MASK ;      //使能DAC 0               
        hw_dac_set(DAC0_BASE_PTR,VreRF);
    }
    else
    {
        SIM_SCGC2 |= SIM_SCGC2_DAC1_MASK ;      //使能DAC 1
        hw_dac_set(DAC1_BASE_PTR,VreRF);
    }
}
    
//============================================================================
//函数名称：hw_dac_convert
//函数返回：DAC完成标志。0=完成失败，1=完成成功 
//参数说明：ModelNumber: 通道号0、1
//         VReference: 参考电压转换值  范围（0~4095）
//功能概要：执行DAC转换。
//============================================================================   
uint8 hw_dac_convert(uint8 ModelNumber, uint16 VReference)
{
    if(0 == ModelNumber)
    {
        if(VReference != hw_dac_set_buffer(DAC0_BASE_PTR, 0, VReference))
        {
            return 0;
        }
    }
    else if(1 == ModelNumber)
    {
        if(VReference != hw_dac_set_buffer(DAC1_BASE_PTR, 0, VReference))
        {
            return 0;
        } 
    }
    else 
    {
        return 0;
    }  
    return 1;
}
  

//内部函数

//============================================================================
//函数名称：hw_dac_set_buffer
//函数返回：设置的缓冲区大小值
//参数说明：dacx_base_ptr：DACx基指针      
//          dacindex    ：缓冲区号
//          buffval      ：缓冲区值
//功能概要：设置DACx缓冲区
//============================================================================ 
int hw_dac_set_buffer( DAC_MemMapPtr dacx_base_ptr, uint8 dacindex, int buffval)
{
    int temp = 0; 
    //设置缓冲区低字节
    DAC_DATL_REG(dacx_base_ptr, dacindex)  =   (buffval&0x0ff); 
    //设置缓冲区高字节
    DAC_DATH_REG(dacx_base_ptr, dacindex)  =   (buffval&0xf00) >>8;                                
    temp =( DAC_DATL_REG(dacx_base_ptr, dacindex)|( DAC_DATH_REG(dacx_base_ptr, dacindex)<<8));   
    return temp ;
}


    
//============================================================================
//函数名称：hw_dac_set
//函数返回：无
//参数说明：dacx_base_ptr：DACx基指针
//                VrefSel：      参考电压
//功能概要：配置DAC模块   
//============================================================================  
void hw_dac_set(DAC_MemMapPtr dacx_base_ptr, uint8 VrefSel)
{
	 //配置DAC_C0寄存器
     DAC_C0_REG(dacx_base_ptr)  = (
                                   DAC_BFB_PTR_INT_DISABLE|//缓冲区置底中断禁止            
                                   DAC_BFT_PTR_INT_DISABLE|//缓冲区置顶中断禁止              
                                   DAC_BFWM_INT_DISABLE   |//水印中断禁止           
                                   DAC_HP_MODE            |//高功耗模式          
                                   DAC_SW_TRIG_STOP       |//软触发无效          
                                   DAC_SEL_SW_TRIG        |//选择软件触发      
                                   VrefSel                |//选择参考电压         
                                   DAC_ENABLE              //使能DAC0模块 
                                   );  
    //如果选择了VREFO作为参考电压
    if ( VrefSel == DAC_SEL_VREFO )
    {
    	//开启VREF模块时钟
		SIM_SCGC4 |= SIM_SCGC4_VREF_MASK ;
		VREF_SC = 0x81 ;      
		//等待内部电压参考稳定
		while (!(VREF_SC & VREF_SC_VREFST_MASK))
		{
		} 
    }
	 //配置DAC_C1寄存器
     DAC_C1_REG(dacx_base_ptr)= ( 
                                 DAC_BF_DISABLE           |//DAC缓冲区禁止              
                                 DAC_BF_NORMAL_MODE       |//DAC选择区选择正常工作模式         
                                 DAC_BFWM_1WORD           |//DAC缓冲区水印选择1字节
                                 DAC_DMA_DISABLE           //DMA禁止
                                 ) ;
     //配置DAC_C2寄存器
     DAC_C2_REG(dacx_base_ptr) = DAC_SET_PTR_AT_BF(0)     | //设置缓冲区读指针指向0
								 DAC_SET_PTR_UP_LIMIT(0x0f);//设置缓冲区上限为15
}
    

