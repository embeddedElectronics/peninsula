//============================================================================
//文件名称：hw_i2c.h  
//功能概要：uart构件头文件
//版权所有：苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
//版本更新：2011-11-17     V1.0       stone    编写了K60的i2c驱动
//============================================================================

#ifndef __I2C_H__
#define __I2C_H__
	
#include "common.h"
#include "hw_i2c.h"



//============================================================================
//函数名称：hw_i2c_init                                                        
//功能概要：初始化IICX模块。                                                
//参数说明：MoudleNum:模块号                                                         
//函数返回：无                                                                  
//============================================================================
void hw_i2c_init(int MoudleNum)
{
	//获取i2c模块基址
	I2C_MemMapPtr num = hw_i2c_get_base_address(MoudleNum);
	
	if(num == I2C0)
	{
		//打开I2C0模块时钟
		SIM_SCGC4 |= SIM_SCGC4_I2C0_MASK; 
		//配置引脚复用为I2C0功能
		//I2C0 SCL使用PTD8
		//I2C0 SDA使用PTD9
		PORTD_PCR9 = PORT_PCR_MUX(2);
		PORTD_PCR8 = PORT_PCR_MUX(2);
		//设置 MULT 和 ICR   
		//芯片手册推荐设置100K以减小MCU负载
		//k60的MCU总线频率为48M，在总线上分频
		I2C0_F  = 0x65;   
		//使能I2C0，不发送应答信号
		I2C0_C1 = I2C_C1_IICEN_MASK | I2C_C1_TXAK_MASK;      
	}
	else
	{
		//打开I2C1模块时钟
		SIM_SCGC4 |= SIM_SCGC4_I2C1_MASK; 
		//配置引脚复用为I2C1功能
		//I2C1 SCL使用PTC10
		//I2C1 SDA使用PTC11
		PORTC_PCR10 = PORT_PCR_MUX(2);
		PORTC_PCR11 = PORT_PCR_MUX(2);
		//设置 MULT 和 ICR   
		//芯片手册推荐设置100K以减小MCU负载
		//k60的MCU总线频率为48M，在总线上分频
		I2C1_F  = 0x65;   
		//使能I2C1，不发送应答信号
		I2C1_C1 = I2C_C1_IICEN_MASK | I2C_C1_TXAK_MASK;      
	}
}

//============================================================================
//函数名称：hw_send_signal                                                        
//功能概要：根据需要产生开始或停止信号   。                                                
//参数说明：         MoudleNum:模块号       
//          Signal: 'S'(Start),产生开始信号      'O'(Over),  产生停止信号               
//函数返回：无                                                                  
//============================================================================
void hw_send_signal(uint8 Signal,int MoudleNum)
{
	//获取i2c模块基址
	I2C_MemMapPtr num = hw_i2c_get_base_address(MoudleNum);
	
	if(num == I2C0)//模块0
	{
		if (Signal == 'S')    
		{
		  i2c0_Start(); //主机模式选择位MST由0变为1,可以产生开始信号  
		}
		else if (Signal == 'O')
		{
		  i2c0_Stop();//主机模式选择位MST由1变为0,可以产生停止信号
		}
	}
	else if(num == I2C1)//模块1
	{
		if (Signal == 'S')    
		{
		  i2c1_Start(); //主机模式选择位MST由0变为1,可以产生开始信号  
		}
		else if (Signal == 'O')
		{
		  i2c1_Stop();//主机模式选择位MST由1变为0,可以产生停止信号
		}
	}
	        
                                              
      
}



//============================================================================
//函数名称：hw_wait                                                        
//功能概要： 在时限内,循环检测接收应答标志位,或传送完成标志位,判断MCU         
//          是否接收到应答信号或一个字节是否已在总线上传送完毕                                            
//参数说明：         MoudleNum:模块号       
//             x:x = 'A'(Ack),等待应答;x = 'T'(Transmission),等待一个字节        
//                 数据传输完成                   
//函数返回：0:收到应答信号或一个字节传送完毕;
//         1:未收到应答信号或一个 字节没传送完                                                                                                                            
//============================================================================

uint8 hw_wait(uint8 x,int MoudleNum)

{
    uint16 ErrTime, i;
    I2C_MemMapPtr num = hw_i2c_get_base_address(MoudleNum);
    ErrTime = 255*10;            //定义查询超时时限
    
    
    //获取i2c模块基址
    
    
	for (i = 0;i < ErrTime;i++)
	{
		if (x == 'A')           //等待应答信号
		{
			  if(( I2C_S_REG(num)  & I2C_S_RXAK_MASK)==0)
				 return 0;      //传送完一个字节后,收到了从机的应答信号               
		}
		else if (x == 'T')      //等待传送完成一个字节信号
		{
			if ((I2C_S_REG(num) & I2C_S_IICIF_MASK) != 0)    
			{
				(I2C_S_REG(num) |=(0 | I2C_S_IICIF_MASK));  //清IICIF标志位
				return 0;       //成功发送完一个字节
			}       
		}
	}
	if (i >= ErrTime)
		return 1;               //超时,没有收到应答信号或发送完一个字节   	
}


//============================================================================
//函数名称：hw_iic_read1                                                        
//功能概要：从从机读1个字节数据                                            
//参数说明：  MoudleNum:模块号       
//          DeviceAddr:设备地址    
//          AccessAddr:访问地址
//          Data:带回收到的一个字节数据  
//函数返回：为0,成功读一个字节;为1,读一个字节失败  
//函数说明: 内部调用 hw_send_signal,hw_wait  
//============================================================================
uint8 hw_iic_read1(int MoudleNum,uint8 DeviceAddr, uint8 AccessAddr, uint8 *Data)
{      
      
	//获取i2c模块基址
	I2C_MemMapPtr num = hw_i2c_get_base_address(MoudleNum);
	
	I2C_C1_REG(num)     |= 0x10;           //TX = 1,MCU设置为发送模式
	hw_send_signal('S',MoudleNum);               //发送开始信号 
	I2C_D_REG(num)  = DeviceAddr & 0xfe;   //发送设备地址,并通知从机接收数据
	 
	if (hw_wait('T',MoudleNum))                  //等待一个字节数据传送完成  
	{      

		return 1;                         //没有传送成功,读一个字节失败   
	}
	if (hw_wait('A',MoudleNum))                 //等待从机应答信号 
	{

		return 1;                         //没有等到应答信号,读一个字节失败 
	}
	I2C_D_REG(num)  = AccessAddr;        //发送访问地址    
	if (hw_wait('T',MoudleNum))                //等待一个字节数据传送完成 
	{
	 
		return 1;                        //没有传送成功,读一个字节失败
	}
	if (hw_wait('A',MoudleNum))                //等待从机应答信号   
	{
	  
		return 1;                        //没有等到应答信号,读一个字节失败  
	}
	I2C_C1_REG(num) |= 0x04;//当MCU在主机模 式下，向该位写1将产生一个重新开始信号  
	I2C_D_REG(num) = DeviceAddr | 0x01; //通知从机改为发送数据    
	if (hw_wait('T',MoudleNum))               //等待一个字节数据传送完成  
	{
	 
		return 1;                       //没有传送成功,读一个字节失败 
	}
	if (hw_wait('A',MoudleNum))               //等待从机应答信号  
	{
	 
		return 1;                      //没有等到应答信号,读一个字节失败
	}
	I2C_C1_REG(num) &= 0xef;           //TX = 0,MCU设置为接收模式    
	*Data = I2C_D_REG(num);            //读出IIC1D,准备接收数据   
	if (hw_wait('T',MoudleNum))              //等待一个字节数据传送完成  
	{  
	 
		return 1;                      //没有传送成功,读一个字节失败  
	}
	hw_send_signal('O',MoudleNum);           //发送停止信号    
	*Data = I2C_D_REG(num);            //读出接收到的一个数据    
	
	return 0;                          //正确接收到一个字节数据
	
}

//============================================================================
//函数名称：hw_iic_write1                                                        
//功能概要：向从机写1个字节数据                                           
//参数说明：  MoudleNum:模块号       
//          DeviceAddr:设备地址    
//          AccessAddr:访问地址
//          Data:要发给从机的1个字节数据  
//函数返回：为0,成功写一个字节;为1,写一个字节失败 
//函数说明: 内部调用 hw_send_signal,hw_wait  
//============================================================================

uint8 hw_iic_write1(int MoudleNum,uint8 DeviceAddr, uint8 AccessAddr, uint8 Data)
{
	//获取i2c模块基址
	I2C_MemMapPtr num = hw_i2c_get_base_address(MoudleNum);
	
	I2C_C1_REG(num) |= 0x10;             //TX = 1,MCU设置为发送模式
    hw_send_signal('S',MoudleNum);             //发送开始信号
    I2C_D_REG(num) = DeviceAddr & 0xfe;  //发送设备地址,并通知从机接收数据
    if (hw_wait('T',MoudleNum))                //等待一个字节数据传送完成
        return 1;                        //没有传送成功,写一个字节失败
    if (hw_wait('A',MoudleNum))               //等待从机应答信号
        return 1;                       //没有等到应答信号,写一个字节失败   
    I2C_D_REG(num) = AccessAddr;         //发送访问地址
    if (hw_wait('T',MoudleNum))               //等待一个字节数据传送完成
        return 1;                       //没有传送成功,写一个字节失败
    if (hw_wait('A',MoudleNum))               //等待从机应答信号
        return 1;                      //没有等到应答信号,写一个字节失败   
    I2C_D_REG(num) = Data;             //写数据
    if (hw_wait('T',MoudleNum))              //等待一个字节数据传送完成
        return 1;                      //没有传送成功,写一个字节失败
    if (hw_wait('A',MoudleNum))              //等待从机应答信号
        return 1;                      //没有等到应答信号,写一个字节失败   
    hw_send_signal('O',MoudleNum);           //发送停止信号
    return 0;
}


//============================================================================
//函数名称：hw_iic_readn                                                        
//功能概要： 从从机读N个字节数据                                             
//参数说明：  MoudleNum:模块号       
//          DeviceAddr:设备地址    
//          AccessAddr:访问地址
//          Data:读出数据的缓冲区
//          N:从从机读的字节个数 
//函数返回： 为0,成功读N个字节;为1,读N个字节失败  
//函数说明: 内部调用hw_iic_read1  
//============================================================================
uint8 hw_iic_readn(int MoudleNum,uint8 DeviceAddr, uint8 AccessAddr, uint8 Data[], uint8 N)
{
    uint16 i, j;
    for (i = 0;i < N;i++)
    {
        for(j = 0;j <15*40 ;j++); //最小延时(发送的每个字节之间要有时间间隔)
        if (hw_iic_read1(MoudleNum,DeviceAddr, AccessAddr + i, &Data[i]))  
            return 1;             //其中一个字节没有接收到,返回失败标志:1
    }
    if (i >= N)
        return 0;                 //成功接收N个数据,返回成功标志:0
}


//============================================================================
//函数名称：hw_iic_writen                                                        
//功能概要： 向从机写N个字节数据                                              
//参数说明：  MoudleNum:模块号       
//          DeviceAddr:设备地址    
//          AccessAddr:访问地址
//          Data:要写入的数据  
//          N:从从机读的字节个数 
//函数返回： 为0,成功写N个字节;为1,写N个字节失败
//函数说明: 内部调用hw_iic_write1   
//============================================================================
uint8 hw_iic_writen(int MoudleNum,uint8 DeviceAddr, uint8 AccessAddr,uint8 Data[], uint8 N)
{
    uint16 i, j;
    for (i = 0;i < N;i++)
    {
        for(j = 0;j < 15*40;j++); //最小延时(发送的每个字节之间要有时间间隔)
        if (hw_iic_write1(MoudleNum,DeviceAddr, AccessAddr + i, Data[i]))
            return 1;            //其中一个字节没有发送出去,返回失败标志:1
    }
    if (i >= N)
        return 0;                //成功发送N个数据,返回成功标志:0
}
//============================================================================
//函数名称：hw_i2c_get_base_address                                                        
//功能概要：获取i2c模块的基址                                                
//参数说明：i2cNO:i2c模块号      
//函数返回：i2c模块的基址值                                                                  
//============================================================================
I2C_MemMapPtr hw_i2c_get_base_address(int i2cNO)
{
	switch(i2cNO)
	{
	case 0:
		return I2C0_BASE_PTR;
		break;
	case 1:
		return I2C1_BASE_PTR;
		break;
	
	}
}
#endif 
