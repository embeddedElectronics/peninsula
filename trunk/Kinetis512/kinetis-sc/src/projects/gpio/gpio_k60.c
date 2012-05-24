/*
 * File:		gpio_k60.c
 * Purpose:		LED and Switch Example
 *
 *                      Configures GPIO for the LED and push buttons on the TWR-K60N512
 *                      Blue LED - On
 *                      Green LED - Toggles on/off
 *                      Orange LED - On if SW2 pressed
 *                      Yellow LED - On if SW1 pressed
 *
 *                      Also configures push buttons for falling IRQ's. ISR
 *                        configured in vector table in isr.h
 *
 


#define GPIO_PIN_MASK            0x1Fu
#define GPIO_PIN(x)              (((1)<<(x & GPIO_PIN_MASK)))*/

#include "common.h"
#include "MK60N512VMD100.h"
#include "k60_tower.h"
#include "hw_sdhc.h"
#include "diskio.h"
#include "FAT32.h"
#include "BMP.h"

#define RowEnd  260
#define LineEnd  100
#define lie  60//51  

//#define PTT  (GPIOD_PDIR & 0x00000100u)




//位带操作,实现51类似的GPIO控制功能
//具体实现思想,参考<<CM3权威指南>>第五章(87页~92页)
//参考正点原子STM32不完全手册
//IO口操作宏定义
#define BITBAND(addr, bitnum) ((addr & 0xF0000000)+0x2000000+((addr &0xFFFFF)<<5)+(bitnum<<2)) 
#define MEM_ADDR(addr)  *((volatile unsigned long  *)(addr)) 
#define BIT_ADDR(addr, bitnum)   MEM_ADDR(BITBAND(addr, bitnum)) 
//IO口地址映射
#define GPIOA_ODR_Addr    (PTA_BASE_PTR+0) //0x4001080C 
#define GPIOB_ODR_Addr    (PTB_BASE_PTR+0) //0x40010C0C 
#define GPIOC_ODR_Addr    (PTC_BASE_PTR+0) //0x4001100C 
#define GPIOD_ODR_Addr    (PTD_BASE_PTR+0) //0x4001140C 
#define GPIOE_ODR_Addr    (PTE_BASE_PTR+0) //0x4001180C 
   

#define GPIOA_IDR_Addr    (PTA_BASE_PTR+0x10) //0x40010808 
#define GPIOB_IDR_Addr    (PTB_BASE_PTR+0x10) //0x40010C08 
#define GPIOC_IDR_Addr    (PTC_BASE_PTR+0x10) //0x40011008 
#define GPIOD_IDR_Addr    (PTD_BASE_PTR+0x10) //0x40011408 
#define GPIOE_IDR_Addr    (PTE_BASE_PTR+0x10) //0x40011808 


//IO口操作,只对单一的IO口!
#define PAout(n)   BIT_ADDR(GPIOA_ODR_Addr,n)  //输出 
#define PAin(n)    BIT_ADDR(GPIOA_IDR_Addr,n)  //输入 
  
#define PBout(n)   BIT_ADDR(GPIOB_ODR_Addr,n)  //输出 
#define PBin(n)    BIT_ADDR(GPIOB_IDR_Addr,n)  //输入 

#define PCout(n)   BIT_ADDR(GPIOC_ODR_Addr,n)  //输出 
#define PCin(n)    BIT_ADDR(GPIOC_IDR_Addr,n)  //输入 

#define PDout(n)   BIT_ADDR(GPIOD_ODR_Addr,n)  //输出 
#define PDin(n)    BIT_ADDR(GPIOD_IDR_Addr,n)  //输入 

#define PEout(n)   BIT_ADDR(GPIOE_ODR_Addr,n)  //输出 
#define PEin(n)    BIT_ADDR(GPIOE_IDR_Addr,n)  //输入



//#define GPIOE_ODR_Addr    (PTE_BASE+0) //0x4001180C 
#define PEin(n)    BIT_ADDR(GPIOE_IDR_Addr,n)  //输入 
#define KEY0_PIN  5    
#define KEY0      PEin(KEY0_PIN) //PE0 




int ucTimeDelayFlag;
unsigned char gpline=0 , gpflag=0 , gppoint=0 ;

unsigned char Pic[lie][LineEnd];
unsigned int CLie=0;
unsigned int LieCount=0,RowCount;
unsigned int GPflag;
int temp;


const unsigned int GetPic[61]={20,24,28,32,36,40,44,48,52,56,
                              59,62,65,68,71,74,77,80,83,86,
                              89,91,93,95,97,99,101,103,105,107,
                              109,110,111,112,113,114,115,116,117,118,
                              119,120,121,122,123,124,125,126,127,128,
                              129,130,131,132,133,134,135,136,137,138,
                              139
                         };
//FAT32文件系统变量
struct FAT32_Init_Arg *pArg;
struct FAT32_Init_Arg FatArg;
struct FileInfoStruct FileInfo;
uint8 Dev_No=0;
//BMP变量
RGBQUAD ColorTable[256];
//BMP测试数据
uint8 pic[80][70];
void delay(int num)                                   
{ 
     unsigned int ii,jj; 
    for(ii=0;ii<num;ii++) 
       for(jj=0;jj<59;jj++); 
}


void IRQ_Init(void)
{
	//PORTD_PCR8 = PORT_PCR_MUX(0x1); // GPIO is alt1 function for this pin
        PORTA_PCR15 = PORT_PCR_MUX(0x1);
	/* Configure the PTE26 pin for rising edge interrupts */
	//PORTD_PCR8 |= PORT_PCR_IRQC(0x9);
        PORTA_PCR15 |= PORT_PCR_IRQC(0x9);
        /*
        0000 Interrupt/DMA Request disabled.
        0001 DMA Request on rising edge.
        0010 DMA Request on falling edge.
        0011 DMA Request on either edge.
        0100 Reserved.
        1000 Interrupt when logic zero.
        1001 Interrupt on rising edge.
        1010 Interrupt on falling edge.
        1011 Interrupt on either edge.
        1100 Interrupt when logic one.
        */
	//PORTE_PCR26 = 1 << 8 | 0xA << 16 | 1;
	//GPIOD_PDDR |= 0 << 8;
        //GPIOA_PDDR |= 0 << 15;
        
        PORTC_PCR0 = PORT_PCR_MUX(0x1);
        GPIOC_PDDR = 0x00000000u;
}
void Timer0( unsigned int timeout );
void ISR_PTA(void)    //行同步
{
	PORTA_ISFR = 1 << 15;
        
        //GPIOA_PTOR |= 1 << 10;
	//delay2();
        disable_irq(87);
        //enable_irq(90);
    
        if(LieCount==GetPic[CLie]) 
        {  
          delay(3);   
          for(RowCount=0;RowCount<LineEnd;RowCount++)
          {  
            Pic[CLie][RowCount] = (GPIOC_PDIR & (~GPIO_PDIR_PDI(0))) * 0xFF; 
            /*temp = (GPIOC_PDIR & 0x00000001u);
            if(temp > 0)
            {
              temp = 0;
            }*/
          }
         CLie++; 
        }
        LieCount++; 
        if(CLie==60)GPflag=1;
        Timer0(1);
        PIT_TCTRL0 |= PIT_TCTRL_TEN_MASK;
        enable_irq(68);
}

void ISR_PTD(void)    //场同步
{
	PORTD_ISFR = 1 << 8;
	//GPIOA_PTOR |= 1 << 11;
        //disable_irq(90);
        
        Timer0(0x15A0);
        
        PIT_TCTRL0 |= PIT_TCTRL_TEN_MASK;
        enable_irq(68);
        
        while(GPflag==0);     
}


void Timer_Init()
{
  SIM_SCGC6 |= SIM_SCGC6_PIT_MASK;
  PIT_MCR &= ~PIT_MCR_MDIS_MASK;
}
void Timer0( unsigned int timeout )
{
    PIT_LDVAL0 = timeout;
    PIT_TCTRL0 |= PIT_TCTRL_TEN_MASK |PIT_TCTRL_TIE_MASK;
    //enable_irq(68);
}
void PIT0_ISR(void)
{
    PIT_TFLG0 |= PIT_TFLG_TIF_MASK;
    PIT_TCTRL0 &= ~PIT_TCTRL_TEN_MASK;
    //GPIOA_PTOR |= 1 << 10;
    disable_irq(68);
    
    if(GPflag==0)
    {
      delay(10);
      enable_irq(87);
    }
     
}
void Timer1( unsigned int timeout )
{
    PIT_LDVAL1 = timeout;
    
    PIT_TCTRL1 |= PIT_TCTRL_TEN_MASK |PIT_TCTRL_TIE_MASK;
    //enable_irq(69);
}
void PIT1_ISR(void)
{
    PIT_TFLG1 |= PIT_TFLG_TIF_MASK;
    GPIOA_PTOR |= 1 << 10;
    
    disable_irq(69);
}
void Timer2( unsigned int timeout )
{
    PIT_LDVAL2 = timeout;
    PIT_TCTRL2 |= PIT_TCTRL_TEN_MASK |PIT_TCTRL_TIE_MASK;
    //enable_irq(70);
}
void PIT2_ISR(void)
{
    PIT_TFLG2 |= PIT_TFLG_TIF_MASK;
    GPIOA_PTOR |= 1 << 10;
 
    disable_irq(70);
}
void Timer3( unsigned int timeout )
{
    PIT_LDVAL3 = timeout;
    
    PIT_TCTRL3 |= PIT_TCTRL_TEN_MASK |PIT_TCTRL_TIE_MASK;
    //enable_irq(71);
}
void PIT3_ISR(void)
{
    PIT_TFLG3 |= PIT_TFLG_TIF_MASK;
    GPIOA_PTOR |= 1 << 10;
    
    disable_irq(71);
}

//设置系统主频率
void Pll_Init(void)		//pll = 外部晶振(50) / MCG_C5_PRDIV *  MCG_C6_VDIV
{
	uint32_t temp_reg;

	//这里处在默认的FEI模式
	//首先移动到FBE模式

	MCG_C2 = 0;  
	//MCG_C2 = MCG_C2_RANGE(2) | MCG_C2_HGO_MASK | MCG_C2_EREFS_MASK;
	//初始化晶振后释放锁定状态的振荡器和GPIO
	SIM_SCGC4 |= SIM_SCGC4_LLWU_MASK;
	LLWU_CS |= LLWU_CS_ACKISO_MASK;


	MCG_C1 = MCG_C1_CLKS(2) | MCG_C1_FRDIV(3);
	//选择外部晶振，参考分频器，清IREFS来启动外部晶振
	//011 If RANGE = 0, Divide Factor is 8; for all other RANGE values, Divide Factor is 256.

	//等待晶振稳定	    
	//while (!(MCG_S & MCG_S_OSCINIT_MASK)){}              //等待锁相环初始化结束
	while (MCG_S & MCG_S_IREFST_MASK){}                  //等待时钟切换到外部参考时钟
	while (((MCG_S & MCG_S_CLKST_MASK) >> MCG_S_CLKST_SHIFT) != 0x2){}

	//进入FBE模式,

	MCG_C5 = MCG_C5_PRDIV(0x13);       //	1 - 25    
	//Selects the amount to divide down the external reference clock for the PLL.
	//The resulting frequency must be in the range of 2 MHz to 4 MHz. 
	//	00000 1 01000  9 10000 17 11000 25
	//	00001 2 01001 10 10001 18 11001 Reserved
	//	00010 3 01010 11 10010 19 11010 Reserved
	//	00011 4 01011 12 10011 20 11011 Reserved
	//	00100 5 01100 13 10100 21 11100 Reserved
	//	00101 6 01101 14 10101 22 11101 Reserved
	//	00110 7 01110 15 10110 23 11110 Reserved
	//	00111 8 01111 16 10111 24 11111 Reserved

	//确保MCG_C6处于复位状态，禁止LOLIE、PLL、和时钟控制器，清PLL VCO分频器
	MCG_C6 = 0x0;

	//保存FMC_PFAPR当前的值
	temp_reg = FMC_PFAPR;

	//通过M&PFD置位M0PFD来禁止预取功能
	FMC_PFAPR |= FMC_PFAPR_M7PFD_MASK | FMC_PFAPR_M6PFD_MASK | FMC_PFAPR_M5PFD_MASK
		| FMC_PFAPR_M4PFD_MASK | FMC_PFAPR_M3PFD_MASK | FMC_PFAPR_M2PFD_MASK
		| FMC_PFAPR_M1PFD_MASK | FMC_PFAPR_M0PFD_MASK;  

	///设置系统分频器
	//MCG=PLL, core = MCG, bus = MCG/2, FlexBus = MCG/2, Flash clock= MCG/4
	SIM_CLKDIV1 = SIM_CLKDIV1_OUTDIV1(0) | SIM_CLKDIV1_OUTDIV2(1) 
		| SIM_CLKDIV1_OUTDIV3(1) | SIM_CLKDIV1_OUTDIV4(3);  

	//OUTDIV1  sets the divide value for the core/system clock		1 - 16
	//0x00 == 1
	//0x0F == 16
	//OUTDIV2 sets the divide value for the peripheral clock		1 - 16
	//0x00 == 1
	//0x0F == 16
	//OUTDIV3 sets the divide value for the FlexBus clock driven to the external pin (FB_CLK).
	//1 - 16
	//OUTDIV4 sets the divide value for the flash clock				1 - 16

	//重新存FMC_PFAPR的原始值
	FMC_PFAPR = temp_reg; 

	//设置VCO分频器，使能PLL为100MHz, LOLIE=0, PLLS=1, CME=0, VDIV=26
	MCG_C6 = MCG_C6_PLLS_MASK | MCG_C6_VDIV(0x10);	//	24 - 55
	/*
	Generate an interrupt request on loss of lock.
	PLL Select
	Controls whether the PLL or FLL output is selected as the MCG source when CLKS[1:0]=00. If the PLLS
	bit is cleared and PLLCLKEN is not set, the PLL is disabled in all modes. If the PLLS is set, the FLL is
	disabled in all modes.
	0 FLL is selected.
	1 PLL is selected (PRDIV need to be programmed to the correct divider to generate a PLL reference
	clock in the range of 2 - 4 MHz prior to setting the PLLS bit).
	*/
	//	00000 24	 01000 32	 10000 40	 11000 48
	//	00001 25	 01001 33	 10001 41	 11001 49
	//	00010 26	 01010 34	 10010 42	 11010 50
	//	00011 27	 01011 35	 10011 43	 11011 51
	//	00100 28	 01100 36	 10100 44	 11100 52
	//	00101 29	 01101 37	 10101 45	 11101 53
	//	00110 30	 01110 38	 10110 46	 11110 54
	//	00111 31	 01111 39	 10111 47	 11111 55

	while (!(MCG_S & MCG_S_PLLST_MASK)){}; // wait for PLL status bit to set    
	while (!(MCG_S & MCG_S_LOCK_MASK)){}; // Wait for LOCK bit to set    

	//进入PBE模式    
	//通过清零CLKS位来进入PEE模式
	// CLKS=0, FRDIV=3, IREFS=0, IRCLKEN=0, IREFSTEN=0
	MCG_C1 &= ~MCG_C1_CLKS_MASK;

	//等待时钟状态位更新
	while (((MCG_S & MCG_S_CLKST_MASK) >> MCG_S_CLKST_SHIFT) != 0x3){};
	//SIM_CLKDIV2 |= SIM_CLKDIV2_USBDIV(1);    

	/*	//时钟检测
	//设置跟踪时钟为内核时钟
	SIM_SOPT2 |= SIM_SOPT2_TRACECLKSEL_MASK; 
	//在PTA6引脚上使能TRACE_CLKOU功能
	PORTA_PCR6 = ( PORT_PCR_MUX(0x7));  
	*/
}


void main(void)
{	
	int i=0;
        uint8 info[9];
        DRESULT sd_state;    //SD卡操作状态
        //SD数据缓存
        uint8  sdhc_dat_buffer1[512];      
        uint8  sdhc_dat_buffer2[512];
        //FAT32文件系统变量
        uint8 CreateTime[6]={0x09,0x07,0x0d,0x0d,0x14,0x0f};
               
        info[0]=0x53;
        info[1]=0x65;
        info[2]=0x72;
        info[3]=0x61;
        info[4]=0x70;
        info[5]=0x68;
        info[6]=0x6C;
        info[7]=0x69;
        info[8]=0x69;
        
        Pll_Init();   //设置系统主频率 
	//关中断
        DisableInterrupts;
        //SDHC模式初始化
        sd_state = disk_initialize(0);
        //FAT32 struct init
        pArg=&FatArg;
        FAT32_Init();
        InitColorTable(ColorTable);
        
	//开启各个GPIO口的转换时钟
	SIM_SCGC5 = SIM_SCGC5_PORTA_MASK | SIM_SCGC5_PORTB_MASK | SIM_SCGC5_PORTC_MASK | SIM_SCGC5_PORTD_MASK | SIM_SCGC5_PORTE_MASK;
	
	//禁止总中断
        // PIT_Init();
        //PORTA_PCR10 = 1 << 8 | 1 << 5;
	//GPIOA_PDDR |= 1 << 10;
        
        //开中断
        EnableInterrupts;
        //enable_irq(70);
        //PIT_TCTRL2 |= PIT_TCTRL_TIE_MASK;
	//IRQ_Init();
        //Timer_Init();
        
	for(;;)  
	{	
           /* gpline=0;                          //一场中行计数清零
            gpflag=0;                          //清除场采集结束标志
            gppoint=0;
             
            PORTD_PCR8 = 1 << 8 ;
	    GPIOD_PDDR |= 0 << 8;
            while((GPIOD_PDIR & (~GPIO_PDIR_PDI(8)))!= 0x0) ;
            
            Timer0(0x15A0);
        
            PIT_TCTRL0 |= PIT_TCTRL_TEN_MASK;
            enable_irq(68);
            
            while(GPflag==0);   
            
            
            
            
	    PORTA_PCR10 = 1 << 8 | 1 << 5;
	    GPIOA_PDDR |= 1 << 10;*/
		//用户添加自己的代码
            //enable_irq(90);
            
            
            
            
            //disable_irq(90);
          
         
            if (RES_OK == sd_state&&i==0/**/)
            {
                FAT32_Create_File(&FileInfo,"\\3.txt",CreateTime);
	        FAT32_Add_Dat(&FileInfo,sizeof(info),info);
                FAT32_Add_Dat(&FileInfo,sizeof(info),info);
                
	        BmpBIT8Write(/*&FileInfo,*/"\\6.bmp",80,70,pic,ColorTable);
                
                
                i++;
            }
          
	}	
}




