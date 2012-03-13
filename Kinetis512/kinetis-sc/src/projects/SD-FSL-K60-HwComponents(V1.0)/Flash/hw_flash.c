//============================================================================
//�ļ����ƣ�hw_flash.c
//���ܸ�Ҫ��K60 Flash����/д��ײ���������Դ�ļ�
//============================================================================

//����ͷ�ļ�
#include "hw_flash.h" 


// Flash�������궨�� ���ڲ�ʹ�� 
#define CCIF    (1<<7)
#define ACCERR  (1<<5)
#define FPVIOL  (1<<4)
#define MGSTAT0 (1<<0)


//Flash����궨�壬�ڲ�ʹ��
#define RD1BLK    0x00   // ������Flash
#define RD1SEC    0x01   // ����������
#define PGMCHK    0x02   // д����
#define RDRSRC    0x03   // ��Ŀ������
#define PGM4      0x06   // д�볤��
#define ERSBLK    0x08   // ��������Flash
#define ERSSCR    0x09   // ����Flash����
#define PGMSEC    0x0B   // д������
#define RD1ALL    0x40   // �����еĿ�
#define RDONCE    0x41   // ֻ��һ��
#define PGMONCE   0x43   // ֻдһ��
#define ERSALL    0x44   // �������п�
#define VFYKEY    0x45   // ��֤���ŷ���Կ��
#define PGMPART   0x80   // д�����
#define SETRAM    0x81   // �趨FlexRAM����

//=================�ڲ����ú�������==========================================
//==========================================================================
//�������ƣ�hw_flash_sign_off
//�������أ���
//����˵������
//���ܸ�Ҫ������Flash�洢�����������FlashԤ��ȡ����
//==========================================================================
static void hw_flash_sign_off(void);

//==========================================================================
//�������ƣ�hw_flash_cmd_launch
//�������أ�0-�ɹ� 1-ʧ��
//����˵������
//���ܸ�Ҫ������Flash����
//==========================================================================
static uint32 hw_flash_cmd_launch(void);

//===========================================================================

//=================�ⲿ�ӿں���==============================================
//==========================================================================
//�������ƣ�hw_flash_init
//�������أ���
//����˵������
//���ܸ�Ҫ����ʼ��flashģ��
//==========================================================================
void hw_flash_init(void)
{
	//���FMC������
    hw_flash_sign_off();
    
    // ��ֹ���Ź�
    WDOG_UNLOCK = 0xC520;
    WDOG_UNLOCK = 0xD928;
    WDOG_STCTRLH = 0;    // ��ֹ���Ź�
    
    // �ȴ��������
    while(!(FTFL_FSTAT & CCIF));
    
    // ������ʳ����־λ
    FTFL_FSTAT = ACCERR | FPVIOL;
}

//==========================================================================
//�������ƣ�hw_flash_erase_sector
//�������أ�����ִ��ִ��״̬��0=��������0=�쳣��
//����˵����sectorNo�������ţ�K60N512ʵ��ʹ��0~255��
//���ܸ�Ҫ������ָ��flash����
//==========================================================================
uint8 hw_flash_erase_sector(uint16 sectorNo)
{
    union
    {
        uint32  word;
        uint8   byte[4];
    } dest;
    
    dest.word    = (uint32)(sectorNo*(1<<11));

    // ���ò�������
    FTFL_FCCOB0 = ERSSCR; // ������������
    
    // ����Ŀ���ַ
    FTFL_FCCOB1 = dest.byte[2];
    FTFL_FCCOB2 = dest.byte[1];
    FTFL_FCCOB3 = dest.byte[0];
    
    // ִ����������
    if(1 == hw_flash_cmd_launch())    //��ִ��������ִ���
        return 1;     //�����������
   
    // ������sector0ʱ��������豸
    if(dest.word <= 0x800)
    {
        // д��4�ֽ�
        FTFL_FCCOB0 = PGM4; 
        // ����Ŀ���ַ
        FTFL_FCCOB1 = 0x00;
        FTFL_FCCOB2 = 0x04;
        FTFL_FCCOB3 = 0x0C;
        // ����
        FTFL_FCCOB4 = 0xFF;
        FTFL_FCCOB5 = 0xFF;
        FTFL_FCCOB6 = 0xFF;
        FTFL_FCCOB7 = 0xFE;
        // ִ����������
        if(1 == hw_flash_cmd_launch())  //��ִ��������ִ���
            return 2;   //�����������
    }  
    
    return 0;  //�ɹ�����
}

//==========================================================================
//�������ƣ�hw_flash_write
//�������أ�����ִ��״̬��0=��������0=�쳣��
//����˵����sectNo��Ŀ�������� ��K60N512ʵ��ʹ��0~255��
//         offset:д�������ڲ�ƫ�Ƶ�ַ��0~2043��
//         cnt��д���ֽ���Ŀ��0~2043��
//         buf��Դ���ݻ������׵�ַ
//���ܸ�Ҫ��flashд�����
//==========================================================================
uint8 hw_flash_write(uint16 sectNo,uint16 offset,uint16 cnt,uint8 buf[])
{
    uint32 size;
    uint32 destaddr;
    
    union
    {
        uint32   word;
        uint8_t  byte[4];
    } dest;
    
    if(offset%4 != 0)
        return 1;   //�����趨����ƫ����δ���루4�ֽڶ��룩
    
    // ����д������
    FTFL_FCCOB0 = PGM4;
    destaddr = (uint32)(sectNo*(1<<11) + offset);//�����ַ
    dest.word = destaddr;
    for(size=0; size<cnt; size+=4, dest.word+=4, buf+=4)
    {
        // ����Ŀ���ַ
        FTFL_FCCOB1 = dest.byte[2];
        FTFL_FCCOB2 = dest.byte[1];
        FTFL_FCCOB3 = dest.byte[0];
 
        // ��������
        FTFL_FCCOB4 = buf[3];
        FTFL_FCCOB5 = buf[2];
        FTFL_FCCOB6 = buf[1];
        FTFL_FCCOB7 = buf[0];
        
        if(1 == hw_flash_cmd_launch()) 
            return 2;  //д���������
    }
    
    return 0;  //�ɹ�ִ��
}

//=================�ڲ�����ʵ��=============================================
//==========================================================================
//�������ƣ�hw_flash_sign_off
//�������أ���
//����˵������
//���ܸ�Ҫ������Flash�洢�����������FlashԤ��ȡ����
//==========================================================================
void hw_flash_sign_off(void)
{  
    // �������
    FMC_PFB0CR |= FMC_PFB0CR_S_B_INV_MASK;
    FMC_PFB1CR |= FMC_PFB0CR_S_B_INV_MASK;
}

//==========================================================================
//�������ƣ�hw_flash_cmd_launch
//�������أ�0-�ɹ� 1-ʧ��
//����˵������
//���ܸ�Ҫ������Flash����
//==========================================================================
static uint32 hw_flash_cmd_launch(void)
{
    // ������ʴ����־λ�ͷǷ����ʱ�־λ
    FTFL_FSTAT = ACCERR | FPVIOL;
    
    // ��������
    FTFL_FSTAT = CCIF;

    // �ȴ��������
    while(!(FTFL_FSTAT & CCIF));

    // �������־
    if(FTFL_FSTAT & (ACCERR | FPVIOL | MGSTAT0))
        return 1 ; //ִ���������
  
    return 0; //ִ������ɹ�
}
//==========================================================================
