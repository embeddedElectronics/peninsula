//=========================================================================
//文件名称：hw_uart.h
//功能概要：K60 UART底层驱动程序头文件
//=========================================================================

#include "hw_uart.h"

//引用系统外设时钟
extern uint32 periph_clk_khz;

//=================内部函数声明============================================

//=========================================================================
//函数名称：hw_uart_get_base_address                                                        
//功能概要：获取串口的基址                                                
//参数说明：uartNO:串口号      
//函数返回：串口的基址值                                                                  
//=========================================================================
static UART_MemMapPtr hw_uart_get_base_address(uint8 uartNO);

//=================接口函数实现============================================

//=========================================================================
//函数名称：hw_uart_init                                                        
//功能概要：初始化uartx模块。                                                
//参数说明：uartNo:串口号                                                                          
//          baud:波特率，如9600，38400等，一般来说，速度越慢，通信越稳       
//函数返回：函数执行状态：0=正常；非0=异常
//=========================================================================
uint8 hw_uart_init(uint8 uartNo, uint32 baud)
{
    register uint16 sbr, brfa;
    uint8 temp;
    uint32 sysClk = periph_clk_khz;
    UART_MemMapPtr uartch = hw_uart_get_base_address(uartNo);

    //使能引脚功能并启动引脚时钟
    switch (uartNo)
    {
    case UART_0:
        PORTA_PCR1 = PORT_PCR_MUX(0x2); //使能UART0_TXD
        PORTA_PCR2 = PORT_PCR_MUX(0x2); //使能UART0_RXD
        BSET(SIM_SCGC4_UART0_SHIFT, SIM_SCGC4);//启动串口0时钟
        break;
    case UART_1:
        PORTC_PCR4 = PORT_PCR_MUX(0x3); //使能UART1_TXD
        PORTC_PCR3 = PORT_PCR_MUX(0x3); //使能UART1_RXD
        BSET(SIM_SCGC4_UART1_SHIFT, SIM_SCGC4); //启动串口1时钟
        break;
    case UART_2:
        PORTD_PCR3 = PORT_PCR_MUX(0x3); //使能UART2_TXD
        PORTD_PCR2 = PORT_PCR_MUX(0x3); //使能UART2_RXD
        BSET(SIM_SCGC4_UART2_SHIFT, SIM_SCGC4);//启动串口2时钟
        break;
    case UART_3:
        PORTB_PCR11 = PORT_PCR_MUX(0x3); //使能UART3_TXD
        PORTB_PCR10 = PORT_PCR_MUX(0x3); //使能UART3_RXD
        BSET(SIM_SCGC4_UART3_SHIFT, SIM_SCGC4);//启动串口3时钟
        break;
    case UART_4:
        PORTE_PCR24 = PORT_PCR_MUX(0x3); //使能UART4_TXD
        PORTE_PCR25 = PORT_PCR_MUX(0x3); //使能UART4_RXD
        BSET(SIM_SCGC1_UART4_SHIFT, SIM_SCGC1); //启动串口4时钟
        break;
    case UART_5:
        PORTD_PCR9 = PORT_PCR_MUX(0x3); //使能UART5_TXD
        PORTD_PCR8 = PORT_PCR_MUX(0x3); //使能UART5_RXD
        BSET(SIM_SCGC1_UART5_SHIFT, SIM_SCGC1);  //启动串口5时钟
        break;
    default:
        return 1;  //传参错误，返回
    }
    
    //暂时关闭串口发送与接收功能
    UART_C2_REG(uartch) &= ~(UART_C2_TE_MASK | UART_C2_RE_MASK);

    //配置串口工作模式
    //8位无校验模式
    UART_C1_REG(uartch) = 0;
    //配置波特率
    //串口0、1使用的内核时钟是其它串口使用外设时钟频率的2倍
    if (UART_0 == uartNo || UART_1 == uartNo)
        sysClk+=sysClk;  
    
    sbr = (uint16)((sysClk*1000)/(baud * 16));
    temp = UART_BDH_REG(uartch) & ~(UART_BDH_SBR(0x1F));
    UART_BDH_REG(uartch) = temp |  UART_BDH_SBR(((sbr & 0x1F00) >> 8));
    UART_BDL_REG(uartch) = (uint8)(sbr & UART_BDL_SBR_MASK);
    
    brfa = (((sysClk*32000)/(baud * 16)) - (sbr * 32));
    temp = UART_C4_REG(uartch) & ~(UART_C4_BRFA(0x1F));
    UART_C4_REG(uartch) = temp |  UART_C4_BRFA(brfa);    

    //启动发送接收
    UART_C2_REG(uartch) |= (UART_C2_TE_MASK | UART_C2_RE_MASK );
    return 0;
}

//=========================================================================
//函数名称：hw_uart_re1
//参数说明：uartNo: 串口号
//          fp:接收成功标志的指针:*p=0，成功接收；*p=1，接收失败
//函数返回：接收返回字节
//功能概要：串行接收1个字节
//=========================================================================
uint8 hw_uart_re1 (uint8 uartNo,uint8 *fp)
{
    uint32 t;
    uint8  dat;
    UART_MemMapPtr uartch = hw_uart_get_base_address(uartNo);

    for (t = 0; t < 0xFBBB; t++)//查询指定次数
    {
        //判断接收缓冲区是否满
        if (BGET(ReTestBit, ReSendStatusR(uartch)))
        {
            dat = ReSendDataR(uartch);
            *fp= 0;  //收到数据 
            break;
        }
    }//end for
    if(t >= 0xFBBB) 
    {
        dat = 0xFF;
        *fp = 1;  //未收到数据
    }
    return dat;    //返回接收到的数据
}

//=========================================================================
//函数名称：hw_uart_send1
//参数说明：uartNo: 串口号
//          ch:要发送的字节
//函数返回：函数执行状态：0=正常；非0=异常。
//功能概要：串行发送1个字节
//=========================================================================
uint8 hw_uart_send1(uint8 uartNo, uint8 ch)
{
    uint32 t;
    UART_MemMapPtr uartch = hw_uart_get_base_address(uartNo);

    for (t = 0; t < 0xFBBB; t++)
    {
        //判断发送缓冲区是否为空
        if (BGET(SendTestBit, ReSendStatusR(uartch)))
        {
            ReSendDataR(uartch) = ch;
            break;
        }
    }//end for
    if (t >= 0xFBBB)
        return 1; //发送超时
    else
        return 0; //成功发送
    
}

//=========================================================================
//函数名称：hw_uart_reN
//参数说明：uartNo: 串口号                                                   
//          buff: 接收缓冲区
//          len:接收长度
//函数返回：函数执行状态 0=正常;非0=异常
//功能概要：串行 接收n个字节
//=========================================================================
uint8 hw_uart_reN (uint8 uartNo ,uint16 len ,uint8* buff)
{
    uint16 i;
    uint8 flag = 0;
    
    for (i = 0; i < len && 0 == flag; i++)
    {
        buff[i] = hw_uart_re1(uartNo, &flag);
    }
    if (i >= len)
        return 1; //接收失败
    else
        return 0; //接收成功
}

//=========================================================================
//函数名称：hw_uart_sendN
//参数说明：uartNo: 串口号
//          buff: 发送缓冲区
//          len:发送长度
//函数返回： 函数执行状态：0=正常；1=异常。
//功能概要：串行 接收n个字节   
//=========================================================================
uint8 hw_uart_sendN (uint8 uartNo ,uint16 len ,uint8* buff)
{
    uint16 i;
    
    for (i = 0; i < len; i++)
        if (hw_uart_send1(uartNo, buff[i]))
            break;
    if (i >= len)
        return 1;
    else 
        return 0;
}

//=========================================================================
//函数名称：hw_uart_send_string
//参数说明：uartNo:UART模块号
//          buff:要发送的字符串的首地址
//函数返回： 函数执行状态：0=正常；非0=异常。
//功能概要：从指定UART端口发送一个以'\0'结束的字符串
//=========================================================================
uint8 hw_uart_send_string(uint8 uartNo, void *buff)
{
    uint16 i = 0;
    uint8 *buff_ptr = (uint8 *)buff;
    for(i = 0; buff_ptr[i] != '\0'; i++)
    {
        if (hw_uart_send1(uartNo,buff_ptr[i]))
            return 1;
    }
    return 0;
}

//====定义串口IRQ号对应表====
static uint8 table_irq_uart[UART_MAX_NUM] = {45, 47, 49, 51, 53, 55};
//=========================================================================
//函数名称：hw_uart_enable_re_int
//参数说明：uartNo: 串口号
//函数返回：无
//功能概要：开串口接收中断
//=========================================================================
void hw_uart_enable_re_int(uint8 uartNo)
{
    UART_MemMapPtr uartch = hw_uart_get_base_address(uartNo);
    BSET(UART_C2_RIE_SHIFT, UART_C2_REG(uartch));//开放UART接收中断
    enable_irq(table_irq_uart[uartNo]);          //开接收引脚的IRQ中断
}

//=========================================================================
//函数名称：hw_uart_disable_re_int
//参数说明：uartNo: 串口号 
//函数返回：无
//功能概要：关串口接收中断
//=========================================================================
void hw_uart_disable_re_int(uint8 uartNo)
{
    UART_MemMapPtr uartch = hw_uart_get_base_address(uartNo);
    BCLR(UART_C2_RIE_SHIFT, UART_C2_REG(uartch));//开放UART接收中断
    diable_irq(table_irq_uart[uartNo]);          //开接收引脚的IRQ中断
}


//=================内部函数实现============================================
//=========================================================================
//函数名称：hw_uart_get_base_address                                               
//参数说明：uartNO:串口号      
//函数返回：串口的数据体指针       
//功能概要：获取串口的基址                                                         
//=========================================================================
UART_MemMapPtr hw_uart_get_base_address(uint8 uartNO)
{
    switch(uartNO)
    {
    case 0:
        return UART0_BASE_PTR;
        break;
    case 1:
        return UART1_BASE_PTR;
        break;
    case 2:
        return UART2_BASE_PTR;
        break;
    case 3:
        return UART3_BASE_PTR;
        break;
    case 4:
        return UART4_BASE_PTR;
        break;
    case 5:
        return UART5_BASE_PTR;
        break;
    default :
        return 0;
    }
}

