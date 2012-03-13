//=========================================================================
//�ļ����ƣ�hw_uart.h
//���ܸ�Ҫ��K60 UART�ײ���������ͷ�ļ�
//=========================================================================

#include "hw_uart.h"

//����ϵͳ����ʱ��
extern uint32 periph_clk_khz;

//=================�ڲ���������============================================

//=========================================================================
//�������ƣ�hw_uart_get_base_address                                                        
//���ܸ�Ҫ����ȡ���ڵĻ�ַ                                                
//����˵����uartNO:���ں�      
//�������أ����ڵĻ�ֵַ                                                                  
//=========================================================================
static UART_MemMapPtr hw_uart_get_base_address(uint8 uartNO);

//=================�ӿں���ʵ��============================================

//=========================================================================
//�������ƣ�hw_uart_init                                                        
//���ܸ�Ҫ����ʼ��uartxģ�顣                                                
//����˵����uartNo:���ں�                                                                          
//          baud:�����ʣ���9600��38400�ȣ�һ����˵���ٶ�Խ����ͨ��Խ��       
//�������أ�����ִ��״̬��0=��������0=�쳣
//=========================================================================
uint8 hw_uart_init(uint8 uartNo, uint32 baud)
{
    register uint16 sbr, brfa;
    uint8 temp;
    uint32 sysClk = periph_clk_khz;
    UART_MemMapPtr uartch = hw_uart_get_base_address(uartNo);

    //ʹ�����Ź��ܲ���������ʱ��
    switch (uartNo)
    {
    case UART_0:
        PORTA_PCR1 = PORT_PCR_MUX(0x2); //ʹ��UART0_TXD
        PORTA_PCR2 = PORT_PCR_MUX(0x2); //ʹ��UART0_RXD
        BSET(SIM_SCGC4_UART0_SHIFT, SIM_SCGC4);//��������0ʱ��
        break;
    case UART_1:
        PORTC_PCR4 = PORT_PCR_MUX(0x3); //ʹ��UART1_TXD
        PORTC_PCR3 = PORT_PCR_MUX(0x3); //ʹ��UART1_RXD
        BSET(SIM_SCGC4_UART1_SHIFT, SIM_SCGC4); //��������1ʱ��
        break;
    case UART_2:
        PORTD_PCR3 = PORT_PCR_MUX(0x3); //ʹ��UART2_TXD
        PORTD_PCR2 = PORT_PCR_MUX(0x3); //ʹ��UART2_RXD
        BSET(SIM_SCGC4_UART2_SHIFT, SIM_SCGC4);//��������2ʱ��
        break;
    case UART_3:
        PORTB_PCR11 = PORT_PCR_MUX(0x3); //ʹ��UART3_TXD
        PORTB_PCR10 = PORT_PCR_MUX(0x3); //ʹ��UART3_RXD
        BSET(SIM_SCGC4_UART3_SHIFT, SIM_SCGC4);//��������3ʱ��
        break;
    case UART_4:
        PORTE_PCR24 = PORT_PCR_MUX(0x3); //ʹ��UART4_TXD
        PORTE_PCR25 = PORT_PCR_MUX(0x3); //ʹ��UART4_RXD
        BSET(SIM_SCGC1_UART4_SHIFT, SIM_SCGC1); //��������4ʱ��
        break;
    case UART_5:
        PORTD_PCR9 = PORT_PCR_MUX(0x3); //ʹ��UART5_TXD
        PORTD_PCR8 = PORT_PCR_MUX(0x3); //ʹ��UART5_RXD
        BSET(SIM_SCGC1_UART5_SHIFT, SIM_SCGC1);  //��������5ʱ��
        break;
    default:
        return 1;  //���δ��󣬷���
    }
    
    //��ʱ�رմ��ڷ�������չ���
    UART_C2_REG(uartch) &= ~(UART_C2_TE_MASK | UART_C2_RE_MASK);

    //���ô��ڹ���ģʽ
    //8λ��У��ģʽ
    UART_C1_REG(uartch) = 0;
    //���ò�����
    //����0��1ʹ�õ��ں�ʱ������������ʹ������ʱ��Ƶ�ʵ�2��
    if (UART_0 == uartNo || UART_1 == uartNo)
        sysClk+=sysClk;  
    
    sbr = (uint16)((sysClk*1000)/(baud * 16));
    temp = UART_BDH_REG(uartch) & ~(UART_BDH_SBR(0x1F));
    UART_BDH_REG(uartch) = temp |  UART_BDH_SBR(((sbr & 0x1F00) >> 8));
    UART_BDL_REG(uartch) = (uint8)(sbr & UART_BDL_SBR_MASK);
    
    brfa = (((sysClk*32000)/(baud * 16)) - (sbr * 32));
    temp = UART_C4_REG(uartch) & ~(UART_C4_BRFA(0x1F));
    UART_C4_REG(uartch) = temp |  UART_C4_BRFA(brfa);    

    //�������ͽ���
    UART_C2_REG(uartch) |= (UART_C2_TE_MASK | UART_C2_RE_MASK );
    return 0;
}

//=========================================================================
//�������ƣ�hw_uart_re1
//����˵����uartNo: ���ں�
//          fp:���ճɹ���־��ָ��:*p=0���ɹ����գ�*p=1������ʧ��
//�������أ����շ����ֽ�
//���ܸ�Ҫ�����н���1���ֽ�
//=========================================================================
uint8 hw_uart_re1 (uint8 uartNo,uint8 *fp)
{
    uint32 t;
    uint8  dat;
    UART_MemMapPtr uartch = hw_uart_get_base_address(uartNo);

    for (t = 0; t < 0xFBBB; t++)//��ѯָ������
    {
        //�жϽ��ջ������Ƿ���
        if (BGET(ReTestBit, ReSendStatusR(uartch)))
        {
            dat = ReSendDataR(uartch);
            *fp= 0;  //�յ����� 
            break;
        }
    }//end for
    if(t >= 0xFBBB) 
    {
        dat = 0xFF;
        *fp = 1;  //δ�յ�����
    }
    return dat;    //���ؽ��յ�������
}

//=========================================================================
//�������ƣ�hw_uart_send1
//����˵����uartNo: ���ں�
//          ch:Ҫ���͵��ֽ�
//�������أ�����ִ��״̬��0=��������0=�쳣��
//���ܸ�Ҫ�����з���1���ֽ�
//=========================================================================
uint8 hw_uart_send1(uint8 uartNo, uint8 ch)
{
    uint32 t;
    UART_MemMapPtr uartch = hw_uart_get_base_address(uartNo);

    for (t = 0; t < 0xFBBB; t++)
    {
        //�жϷ��ͻ������Ƿ�Ϊ��
        if (BGET(SendTestBit, ReSendStatusR(uartch)))
        {
            ReSendDataR(uartch) = ch;
            break;
        }
    }//end for
    if (t >= 0xFBBB)
        return 1; //���ͳ�ʱ
    else
        return 0; //�ɹ�����
    
}

//=========================================================================
//�������ƣ�hw_uart_reN
//����˵����uartNo: ���ں�                                                   
//          buff: ���ջ�����
//          len:���ճ���
//�������أ�����ִ��״̬ 0=����;��0=�쳣
//���ܸ�Ҫ������ ����n���ֽ�
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
        return 1; //����ʧ��
    else
        return 0; //���ճɹ�
}

//=========================================================================
//�������ƣ�hw_uart_sendN
//����˵����uartNo: ���ں�
//          buff: ���ͻ�����
//          len:���ͳ���
//�������أ� ����ִ��״̬��0=������1=�쳣��
//���ܸ�Ҫ������ ����n���ֽ�   
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
//�������ƣ�hw_uart_send_string
//����˵����uartNo:UARTģ���
//          buff:Ҫ���͵��ַ������׵�ַ
//�������أ� ����ִ��״̬��0=��������0=�쳣��
//���ܸ�Ҫ����ָ��UART�˿ڷ���һ����'\0'�������ַ���
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

//====���崮��IRQ�Ŷ�Ӧ��====
static uint8 table_irq_uart[UART_MAX_NUM] = {45, 47, 49, 51, 53, 55};
//=========================================================================
//�������ƣ�hw_uart_enable_re_int
//����˵����uartNo: ���ں�
//�������أ���
//���ܸ�Ҫ�������ڽ����ж�
//=========================================================================
void hw_uart_enable_re_int(uint8 uartNo)
{
    UART_MemMapPtr uartch = hw_uart_get_base_address(uartNo);
    BSET(UART_C2_RIE_SHIFT, UART_C2_REG(uartch));//����UART�����ж�
    enable_irq(table_irq_uart[uartNo]);          //���������ŵ�IRQ�ж�
}

//=========================================================================
//�������ƣ�hw_uart_disable_re_int
//����˵����uartNo: ���ں� 
//�������أ���
//���ܸ�Ҫ���ش��ڽ����ж�
//=========================================================================
void hw_uart_disable_re_int(uint8 uartNo)
{
    UART_MemMapPtr uartch = hw_uart_get_base_address(uartNo);
    BCLR(UART_C2_RIE_SHIFT, UART_C2_REG(uartch));//����UART�����ж�
    diable_irq(table_irq_uart[uartNo]);          //���������ŵ�IRQ�ж�
}


//=================�ڲ�����ʵ��============================================
//=========================================================================
//�������ƣ�hw_uart_get_base_address                                               
//����˵����uartNO:���ں�      
//�������أ����ڵ�������ָ��       
//���ܸ�Ҫ����ȡ���ڵĻ�ַ                                                         
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

