//============================================================================
//�ļ����ƣ�hw_gpio.c
//���ܸ�Ҫ��K60 GPIO�ײ���������ʵ�ִ����ļ�
//��Ȩ���У�sumcu.suda.edu.cn
//�汾���£�2011-11-13 ��ʼ�汾
//============================================================================

#include "hw_gpio.h"    

//============================================================================
//����  ��:_hw_gpio_enable_port
//��������:����ִ��״̬
//��������:��������GPIO�˿ڵ�ʱ�ӡ�
//         ���߲��������á�
//============================================================================
uint8 hw_gpio_enable_port (void)
{
 	  SIM_SCGC5 |=   SIM_SCGC5_PORTA_MASK \
	               | SIM_SCGC5_PORTB_MASK \
	               | SIM_SCGC5_PORTC_MASK \
	               | SIM_SCGC5_PORTD_MASK \
	               | SIM_SCGC5_PORTE_MASK;
    
	  return 0;
}

//============================================================================
//����  ��:hw_gpio_get_port_addr
//         hw_gpio_get_pt_addr
//��������:�˿ںŶ�Ӧ�Ķ˿ڼĴ�����ָ��
//��������:���˿ں�ת���ɶ˿ڼĴ�����ָ�롣
//         ���ײ������ڲ����á�
//============================================================================
PORT_MemMapPtr hw_gpio_get_port_addr (
    uint8 port   //�˿ںţ��ɺ궨��
)
{
	PORT_MemMapPtr p;
    
    switch(port)
    {
    case PORT_A:
        p = PORTA_BASE_PTR;
        break;
    case PORT_B:
        p = PORTB_BASE_PTR;
        break;
    case PORT_C:
        p = PORTC_BASE_PTR;
        break;
    case PORT_D:
        p = PORTD_BASE_PTR;
        break;
    case PORT_E:
        p = PORTE_BASE_PTR;
        break;
    default:
        return 0; //���������Ч����
    }
    
    return p;
}

GPIO_MemMapPtr hw_gpio_get_pt_addr(
	uint8 port  //�˿ںţ��ɺ궨��
) 
{
	GPIO_MemMapPtr p;
    
    switch(port)
    {
    case PORT_A:
        p = PTA_BASE_PTR;
        break;
    case PORT_B:
        p = PTB_BASE_PTR;
        break;
    case PORT_C:
        p = PTC_BASE_PTR;
        break;
    case PORT_D:
        p = PTD_BASE_PTR;
        break;
    case PORT_E:
        p = PTE_BASE_PTR;
        break;
    default:
        return 0; //���������Ч����
    }
    
    return p;
}

//============================================================================
//����  ��:hw_gpio_init
//��������:����ִ��״̬��0=�ɹ�������Ϊ�쳣��
//��������:��ʼ���˿���ΪGPIO���ŵĹ��ܡ�
//============================================================================
uint8 hw_gpio_init (
    uint8 port,  //�˿ںš��ɺ궨�塣
    uint8 pin,   //���źš�0��31��
    uint8 dir,   //���ŷ��� 1=�����0=���롣
    uint8 state  //���ų�ʼ״̬��1=�ߵ�ƽ��0=�͵�ƽ
)
{
    //��GPIO�˿ں�ת���ɶ˿ڼĴ�����ָ��
    GPIO_MemMapPtr pt = hw_gpio_get_pt_addr(port);
    PORT_MemMapPtr p  = hw_gpio_get_port_addr(port);
    if (!p) return 1;  //��������
     
    //�趨ͨ�ö˿����ſ��ƼĴ�����ֵ���趨ΪGPIO����
    PORT_PCR_REG(p, pin) = (0|PORT_PCR_MUX(1));

    if(dir == 1) //�����ű�����Ϊ���
    {
        GPIO_PDDR_REG(pt) |= (1<<pin);
    	 
    	  //�趨���ų�ʼ��״̬
        if(state == 1)
			      GPIO_PDOR_REG(pt) |= (1<<pin);
			  else
			      GPIO_PDOR_REG(pt) &= ~(1<<pin);
    }
    else //�����ű�����Ϊ���� 
    {
        GPIO_PDDR_REG(pt) &= ~(1<<pin);
    }

    return 0;  //�ɹ�����
}

//============================================================================
//����  ��:hw_gpio_get
//��������:ָ������״̬��0=�͵�ƽ��1=�ߵ�ƽ��
//��������:��ȡָ������״̬��
//============================================================================
uint8 hw_gpio_get (
    uint8 port,  //�˿ںš��ɺ궨�塣
    uint8 pin   //���źš�0��31��
)
{
    //��GPIO�˿ں�ת���ɶ˿ڼĴ�����ָ��
	GPIO_MemMapPtr pt = hw_gpio_get_pt_addr(port);
    
    //�鿴����״̬
    if (GPIO_PDIR_REG(pt) & GPIO_PDIR_PDI(pin)== 0)
    {
        return 0;  //�ߵ�ƽ
    }
    else
    {
        return 1;  //�͵�ƽ
    }
}

//============================================================================
//����  ��:hw_gpio_get_value
//��������:����ִ��״̬��0=�͵�ƽ��1=�ߵ�ƽ��
//��������:��ȡָ������״̬��
//============================================================================
uint8 hw_gpio_set(
    uint8 port,  //�˿ںš��ɺ궨�塣
    uint8 pin,   //���źš�0��31��
    uint8 state  //���ų�ʼ״̬��1=�ߵ�ƽ��0=�͵�ƽ
)
{
    //��GPIO�˿ں�ת���ɶ˿ڼĴ�����ָ��
    GPIO_MemMapPtr pt = hw_gpio_get_pt_addr(port);
	  
	  if (state == 0) //����Ϊ�͵�ƽ
	      GPIO_PDOR_REG(pt) &= ~(1<<pin);
	  else            //����Ϊ�ߵ�ƽ
	      GPIO_PDOR_REG(pt) |= (1<<pin);
	  
    return 0;
}

//============================================================================
//����  ��:hw_gpio_reverse
//��������:��
//��������:��תָ������״̬��
//============================================================================
void hw_gpio_reverse (
    uint8 port,  //�˿ںţ��ɺ궨�塣
    uint8 pin    //���źţ�0��31��
)
{
    //��GPIO�˿ں�ת���ɶ˿ڼĴ�����ָ��
    GPIO_MemMapPtr pt = hw_gpio_get_pt_addr(port);
	  
    GPIO_PDOR_REG(pt) ^= (1<<pin);
}
