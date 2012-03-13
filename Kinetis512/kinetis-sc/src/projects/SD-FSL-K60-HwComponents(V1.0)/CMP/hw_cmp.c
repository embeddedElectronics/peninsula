//============================================================================
//文件名称：hw_hscmp.c
//功能概要：K60 比较器底层驱动程序文件
//版权所有：苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
//版本更新：2011-11-25  V1.0   初始版本
//============================================================================
#include "hw_cmp.h"



//============================================================================
//函数名称：hw_cmp_init
//函数返回     无
//参数说明：MoudleNumber: 比较器模块号
//         reference:参考电压选择  0=VDDA 3.3V 1=VREF 1.2V
//         plusChannel: 正比较通道号
//         minusChannel：负比较通道号
//功能概要：CMP模块初始化
//============================================================================
void hw_cmp_init(int MoudleNumber,uint8 reference,uint8 plusChannel,uint8 minusChannel)
{
	    //通过获取模块号选择比较器基址
		CMP_MemMapPtr cmpch = hw_cmp_get_base_address(MoudleNumber);
		//使能比较模块时钟
		SIM_SCGC4 |=SIM_SCGC4_CMP_MASK;
				
		//初始化寄存器
		CMP_CR0_REG(cmpch) = 0;
		CMP_CR1_REG(cmpch) = 0;
		CMP_FPR_REG(cmpch) = 0;
		//如果设置了标志清除中断标志
		CMP_SCR_REG(cmpch) = 0x06;  
		CMP_DACCR_REG(cmpch) = 0;
		CMP_MUXCR_REG(cmpch) = 0;
		
		//配置寄存器
		//过滤，数字延时禁止
		CMP_CR0_REG(cmpch) = 0x00;  
		//连续模式，高速比较，无过滤输出，输出引脚禁止
		CMP_CR1_REG(cmpch) = 0x15;  
		//过滤禁止
		CMP_FPR_REG(cmpch) = 0x00; 
		//使能上升沿和下降沿中断，清标志位
		CMP_SCR_REG(cmpch) = 0x1E;  
		
		
		if(reference==0)//参考电压选择VDD3.3V
		{		
			//6位参考DAC使能，选择VDD作为DAC参考电压
			CMP_DACCR_REG(cmpch) |= 0xC0;
		}
		else//参考电压选择VREF OUT 1.2V
		{
			//6位参考DAC使能，选择VREF作为DAC参考电
			CMP_DACCR_REG(cmpch) |= 0x80;
		}
		
		
		CMP_MUXCR_REG(cmpch) |= 0xC0;//将两个复用器使能
		
		
		//选择复用器通道
		//正通道选择，模块7为DAC输出
		if(plusChannel>7)
			plusChannel = 7;
		if(plusChannel<0)
			plusChannel = 0;
		CMP_MUXCR_REG(cmpch) |= CMP_MUXCR_PSEL(plusChannel);
				
		//负通道选择，模块7为DAC输出
		if(minusChannel>7)
			minusChannel = 7;
		if(minusChannel<0)
			minusChannel = 0;
		CMP_MUXCR_REG(cmpch) |= CMP_MUXCR_MSEL(minusChannel);	
		
		
		//使能输出引脚
		CMP_CR1_REG(cmpch) |= CMP_CR1_OPE_MASK; 
		
		
		//选择输出引脚
		if(cmpch == cmpch0)
		{
			//使能PTC5为HSCMP0输出比较引脚
			PORTC_PCR5=PORT_PCR_MUX(6);  
		}
		else if(cmpch == cmpch1)
		{
			//使能PTC4为HSCMP1输出比较引脚
			PORTC_PCR4=PORT_PCR_MUX(6); 
		}
		else
		{
			//使能PTB22为HSCMP2输出比较引脚
			PORTB_PCR22=PORT_PCR_MUX(6); 
		}
}


//============================================================================
//函数名称：hw_dac_set_value
//函数返回：无
//参数说明：MoudleNumber: 比较器模块号
//         value: dac输出的转换值
//功能概要：开比较中。
//============================================================================
void hw_dac_set_value(int MoudleNumber,uint8 value)
{
	 //通过获取模块号选择比较器基址
	 CMP_MemMapPtr cmpch = hw_cmp_get_base_address(MoudleNumber);
	 CMP_DACCR_REG(cmpch) |= CMP_DACCR_VOSEL(value);
}



//============================================================================
//函数名称：hw_enable_cmp_int
//函数返回：无
//参数说明：MoudleNumber: 比较器模块号
//功能概要：开比较中。
//============================================================================
void hw_enable_cmp_int(int MoudleNumber)
{
	//通过获取模块号选择比较器基址
	 CMP_MemMapPtr cmpch = hw_cmp_get_base_address(MoudleNumber);
	//开放cmp接收中断,上升沿下降沿均触发
	 CMP_SCR_REG(cmpch)|=  CMP_SCR_IEF_MASK  | CMP_SCR_IER_MASK; 
	 enable_irq(CMP0irq + MoudleNumber);   
	 CMP0_SCR |= CMP_SCR_CFR_MASK; //清标志
	 CMP0_SCR |= CMP_SCR_CFF_MASK; //清标志
	
}

//============================================================================
//函数名称：hw_disable_cmp_int
//函数返回：无
//参数说明：MoudleNumber: 比较器模块号
//功能概要：关比较中断
//============================================================================
void hw_disable_cmp_int(int MoudleNumber)
{
	//通过获取模块号选择比较器基址
    CMP_MemMapPtr cmpch = hw_cmp_get_base_address(MoudleNumber);
	//关闭cmp接收中断,上升沿下降沿均关闭
	CMP_SCR_REG(cmpch)&=(~CMP_SCR_IEF_MASK) | (~CMP_SCR_IER_MASK );   
	//关接收引脚的IRQ中断
	disable_irq(CMP0irq + MoudleNumber);
	
}

//============================================================================
//函数名称：hw_cmp_get_base_address  
//函数返回：比较器模块的基址值                                                 
//参数说明：MoudleNumber:模块号      
//功能概要：获取比较模块的基址   
                                                              
//============================================================================
CMP_MemMapPtr hw_cmp_get_base_address(uint8 MoudleNumber)
{
	switch(MoudleNumber)
	{
	case 0:
		return CMP0_BASE_PTR;
		break;
	case 1:
		return CMP1_BASE_PTR;
		break;
	case 2:
		return CMP2_BASE_PTR;
		break;
	}
}

