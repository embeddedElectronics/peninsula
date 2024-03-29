//============================================================================
// 文件名称：hw_pdb.c                                                          
// 功能概要：PDB构件源文件
// 版权所有: 苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
// 版本更新:     时间                     版本                                       修改
//           2011-11-17     V1.0       编写了K60的PDB驱动
//============================================================================
#include "hw_pdb.h"

//==========================================================================
//函数名称：hw_pdb_init                                                  
//功能概要：PDB初始化
//         1.设置成软件触发器输入
//         2.使能PDB模块
//         3.预分频设置成0
//         4. LDMOD = 0: 在设置完LDOK后立即加载
//         5. 使能PDB中断
//         注意：只有在使能PDB模块后，才可以写入通道延时值                                                 
//参数说明：无                                                    
//函数返回：无                                                               
//==========================================================================
void hw_pdb_init(void)
{
	//1.开PDB时钟
	SIM_SCGC6 |= (SIM_SCGC6_PDB_MASK);
	
	//2.初始化PDB状态与控制寄存器
	PDB0_SC = 0x00000000; //LDMOD = 0: 在设置完LDOK后立即加载
	// 必须在写缓冲区寄存器之前使能PDB，否则只是之前的值
	PDB0_SC |= PDB_SC_PDBEN_MASK;  //使能 PDB	
	PDB0_SC |= PDB_SC_TRGSEL(0xF); //软件触发器
	PDB0_SC |= PDB_SC_CONT_MASK;   //使能连续模式 

	//3.初始化PDB通道1控制寄存器1
	PDB0_CH1C1 = PDB_C1_TOS(3)|PDB_C1_EN(3);   //使能预触发器输出到  ADC1
	
	
	//4.初始化PDB通道1延时寄存器
	PDB0_CH1DLY0 = 0;
	PDB0_CH1DLY1 = 3648;    // 延时 = 76us
	
	//5.初始化PDB模寄存器
	PDB0_MOD = 48000;     //设置PDB_MOD时间=1ms，相应的采样频率Fs=1KHz

	//6.初始化PDB中断延时寄存器
	PDB0_IDLY = 48000;    //设置中断延时值
	
	
	PDB0_SC |= PDB_SC_LDOK_MASK;//加载延时值
	
	PDB0_SC |= PDB_SC_PDBIE_MASK; //使能PDB中断
	PDB0_SC &= ~PDB_SC_DMAEN_MASK;
	//PDB0_SC |= PDB_SC_PDBEIE_MASK; //使能PDB 序列错误中断
	
	PDB0_SC |= PDB_SC_SWTRIG_MASK;//设置成软件触发器
}

//==========================================================================
//函数名称：hw_enable_pdb_int                                                  
//功能概要：开pdb中断                                                   
//参数说明：无                                                    
//函数返回：无                                                               
//==========================================================================
void hw_enable_pdb_int(void)
{
	enable_irq(PDB_isr_no);
}

//==========================================================================
//函数名称：hw_disable_pdb_int                                               
//功能概要：关pdb中断                                                   
//参数说明：无                                                                                                           
//函数返回：无                                                               
//==========================================================================
void hw_disable_pdb_int(void)
{
	disable_irq(PDB_isr_no);
}


