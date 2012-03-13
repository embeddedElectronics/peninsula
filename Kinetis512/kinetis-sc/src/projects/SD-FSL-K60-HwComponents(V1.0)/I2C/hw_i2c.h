//============================================================================
//文件名称：hw_i2c.c 
//功能概要：i2c构件源文件
//版权所有：苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
//版本更新：2011-11-20     V1.0       stone    编写了K60的i2c驱动
//============================================================================

#define PCF8563Write                         0xA2
#define PCF8563Read                          0xA3

//I2C0宏定义
#define i2c0_Start()           I2C0_C1     |= I2C_C1_MST_MASK  //产生开始信号                             
#define i2c0_Stop()             I2C0_C1  &= ~I2C_C1_MST_MASK   //产生结束信号                          
#define i2c0_Wait()               while((I2C0_S & I2C_S_IICIF_MASK)==0) {} \
                                  I2C0_S |= I2C_S_IICIF_MASK;//清该寄存器标志

//I2C宏定义
#define i2c1_Start()           I2C1_C1     |= I2C_C1_MST_MASK  //产生开始信号                             
#define i2c1_Stop()             I2C1_C1  &= ~I2C_C1_MST_MASK   //产生结束信号                          
#define i2c1_Wait()               while((I2C1_S & I2C_S_IICIF_MASK)==0) {} \
                                  I2C1_S |= I2C_S_IICIF_MASK;//清该寄存器标志

//模块宏定义
#define I2C0 I2C0_BASE_PTR
#define I2C1 I2C1_BASE_PTR



  // 功能接口(IIC通信函数声明)


//============================================================================
//函数名称：hw_i2c_init                                                        
//功能概要：初始化IICX模块                                                
//参数说明：MoudleNum:模块号                                                         
//函数返回：无                                                                  
//============================================================================
void hw_i2c_init(int MoudleNum); 

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
uint8 hw_iic_read1(int MoudleNum,uint8 DeviceAddr, uint8 AccessAddr, uint8 *Data);

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

uint8 hw_iic_write1(int MoudleNum,uint8 DeviceAddr, uint8 AccessAddr, uint8 Data);

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
uint8 hw_iic_readn(int MoudleNum,uint8 DeviceAddr, uint8 AccessAddr, uint8 Data[], uint8 N);

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
uint8 hw_iic_writen(int MoudleNum,uint8 DeviceAddr, uint8 AccessAddr,uint8 Data[], uint8 N);
//============================================================================
//函数名称：hw_i2c_get_base_address                                                        
//功能概要：获取i2c模块的基址                                                
//参数说明：i2cNO:i2c模块号      
//函数返回：i2c模块的基址值                                                                  
//============================================================================
I2C_MemMapPtr hw_i2c_get_base_address(int i2cNO);
