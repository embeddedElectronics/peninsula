#include"USB.h"
#include "USB_Desc.h"


/* Arrays and global buffers */

#pragma data_alignment=512
tBDT tBDTtable[16];

UINT8 gu8EP0_OUT_ODD_Buffer[EP0_SIZE];
UINT8 gu8EP0_OUT_EVEN_Buffer[EP0_SIZE];
UINT8 gu8EP0_IN_ODD_Buffer[EP0_SIZE];
UINT8 gu8EP0_IN_EVEN_Buffer[EP0_SIZE];
UINT8 gu8EP1_OUT_ODD_Buffer[EP1_SIZE];
UINT8 gu8EP1_OUT_EVEN_Buffer[EP1_SIZE];
UINT8 gu8EP1_IN_ODD_Buffer[EP1_SIZE];
UINT8 gu8EP1_IN_EVEN_Buffer[EP1_SIZE];
UINT8 gu8EP2_OUT_ODD_Buffer[EP2_SIZE];
UINT8 gu8EP2_OUT_EVEN_Buffer[EP2_SIZE];
UINT8 gu8EP2_IN_ODD_Buffer[EP2_SIZE];
UINT8 gu8EP2_IN_EVEN_Buffer[EP2_SIZE];
UINT8 gu8EP3_OUT_ODD_Buffer[EP3_SIZE];
UINT8 gu8EP3_OUT_EVEN_Buffer[EP3_SIZE];
UINT8 gu8EP3_IN_ODD_Buffer[EP3_SIZE];
UINT8 gu8EP3_IN_EVEN_Buffer[EP3_SIZE];

UINT8 *BufferPointer[]=
{
    gu8EP0_OUT_ODD_Buffer,
    gu8EP0_OUT_EVEN_Buffer,
    gu8EP0_IN_ODD_Buffer,
    gu8EP0_IN_EVEN_Buffer,
    gu8EP1_OUT_ODD_Buffer,
    gu8EP1_OUT_EVEN_Buffer,
    gu8EP1_IN_ODD_Buffer,
    gu8EP1_IN_EVEN_Buffer,
    gu8EP2_OUT_ODD_Buffer,
    gu8EP2_OUT_EVEN_Buffer,
    gu8EP2_IN_ODD_Buffer,
    gu8EP2_IN_EVEN_Buffer,
    gu8EP3_OUT_ODD_Buffer,
    gu8EP3_OUT_EVEN_Buffer,
    gu8EP3_IN_ODD_Buffer,
    gu8EP3_IN_EVEN_Buffer
};

const UINT8 cEP_Size[]=
{
    EP0_SIZE,    
    EP0_SIZE,    
    EP0_SIZE,    
    EP0_SIZE,    
    EP1_SIZE,    
    EP1_SIZE,    
    EP1_SIZE,    
    EP1_SIZE,    
    EP2_SIZE,    
    EP2_SIZE,    
    EP2_SIZE,    
    EP2_SIZE,    
    EP3_SIZE,
    EP3_SIZE,
    EP3_SIZE,
    EP3_SIZE
};

const UINT8* String_Table[4]=
{
    String_Descriptor0,
    String_Descriptor1,
    String_Descriptor2,
    String_Descriptor3
};




/* Global Variables for USB Handling */
UINT8 gu8USB_Flags;
UINT8 gu8USBClearFlags;
UINT8 *pu8IN_DataPointer;
UINT8 gu8IN_Counter;
UINT8 gu8USB_Toogle_flags;
UINT8 gu8USB_PingPong_flags;
UINT8 gu8Dummy;
UINT16 gu8Status;
UINT8 gu8Interface;
UINT8 gu8HALT_EP;
UINT8 gu8USB_State;
tUSB_Setup *Setup_Pkt;
 



/**********************************************************/
void USB_Init(void)
{  
    /* Software Configuration */
    Setup_Pkt=(tUSB_Setup*)BufferPointer[bEP0OUT_ODD];
    gu8USB_State=uPOWER;

    /* MPU Configuration */
    MPU_CESR=0;                                     // MPU is disable. All accesses from all bus masters are allowed

    /* SIM Configuration */
    #ifdef USB_CLOCK_CLKIN
    FLAG_SET(SIM_SCGC5_PORTE_SHIFT,SIM_SCGC5); 
    PORTE_PCR26=(0|PORT_PCR_MUX(7));                // Enabling PTE26 as CLK input    
    #endif    
    
    #ifdef USB_CLOCK_PLL
    FLAG_SET(SIM_SOPT2_PLLFLLSEL_SHIFT,SIM_SOPT2);  // Select PLL output
    #endif
    
    #ifndef USB_CLOCK_CLKIN
    FLAG_SET(SIM_SOPT2_USBSRC_SHIFT,SIM_SOPT2);     // PLL/FLL selected as CLK source
    #endif

    SIM_CLKDIV2|=USB_FARCTIONAL_VALUE;              // USB Freq Divider
    SIM_SCGC4|=(SIM_SCGC4_USBOTG_MASK);             // USB Clock Gating
    
    
    /* NVIC Configuration */
    extern uint32 __VECTOR_RAM[];           //Get vector table that was copied to RAM
    __VECTOR_RAM[89]=(UINT32)USB_Device_ISR;      //replace ISR
    //NVICICER2|=(1<<9);                     //Clear any pending interrupts on USB
    NVICISER2|=(1<<9);                     //Enable interrupts from USB module  

    /* USB Module Configuration */
    // Reset USB Module
    USB0_USBTRC0|=USB_USBTRC0_USBRESET_MASK;
    while(FLAG_CHK(USB_USBTRC0_USBRESET_SHIFT,USB0_USBTRC0)){};
    
    // Set BDT Base Register
    USB0_BDTPAGE1=(UINT8)((UINT32)tBDTtable>>8);
    USB0_BDTPAGE2=(UINT8)((UINT32)tBDTtable>>16);
    USB0_BDTPAGE3=(UINT8)((UINT32)tBDTtable>>24);

    // Clear USB Reset flag
    FLAG_SET(USB_ISTAT_USBRST_MASK,USB0_ISTAT);

    // Enable USB Reset Interrupt
    FLAG_SET(USB_INTEN_USBRSTEN_SHIFT,USB0_INTEN);
    
    // Enable weak pull downs
    USB0_USBCTRL=0x40;

    USB0_USBTRC0|=0x40;

    USB0_CTL|=0x01;
    
    // Pull up enable
    FLAG_SET(USB_CONTROL_DPPULLUPNONOTG_SHIFT,USB0_CONTROL);    
}



/**********************************************************/
void EP_IN_Transfer(UINT8 u8EP,UINT8 *pu8DataPointer,UINT8 u8DataSize)
{
    UINT8 *pu8EPBuffer;
    UINT8 u8EPSize; 
    UINT16 u16Lenght=0;    
    UINT8 u8EndPointFlag;    

    /* Adjust the buffer location */
    u8EndPointFlag=u8EP;
    if(u8EP)
        u8EP=(UINT8)(u8EP<<2);
    u8EP+=2;
    
    
    
    /* Assign the proper EP buffer */
    pu8EPBuffer=BufferPointer[u8EP];
    
    /* Check if is a pending transfer */
    if(FLAG_CHK(fIN,gu8USBClearFlags))
    {
        pu8IN_DataPointer=pu8DataPointer;
        gu8IN_Counter=u8DataSize;       

        u16Lenght=(Setup_Pkt->wLength_h<<8)+Setup_Pkt->wLength_l ;
        if((u16Lenght < u8DataSize) && (u8EP==2))
        {
            gu8IN_Counter=Setup_Pkt->wLength_l;
        }
    }

    /* Check transfer Size */
    if(gu8IN_Counter > cEP_Size[u8EP])
    {
        u8EPSize = cEP_Size[u8EP];
        gu8IN_Counter-=cEP_Size[u8EP];
        FLAG_CLR(fIN,gu8USBClearFlags);
    }
    else
    {
        u8EPSize = gu8IN_Counter;
        gu8IN_Counter=0;
        FLAG_SET(fIN,gu8USBClearFlags);
    }
    
    /* Copy User buffer to EP buffer */
    tBDTtable[u8EP].Cnt=(u8EPSize);
    
    while(u8EPSize--)
         *pu8EPBuffer++=*pu8IN_DataPointer++;
                                                             

    /* USB Flags Handling */
    if(FLAG_CHK(u8EndPointFlag,gu8USB_Toogle_flags))
    {
        tBDTtable[u8EP].Stat._byte= kUDATA0;
        FLAG_CLR(u8EndPointFlag,gu8USB_Toogle_flags);
    } 
    else
    {
        tBDTtable[u8EP].Stat._byte= kUDATA1;
        FLAG_SET(u8EndPointFlag,gu8USB_Toogle_flags);
    }

}


/**********************************************************/
UINT8 EP_OUT_Transfer(UINT8 u8EP,UINT8 *pu8DataPointer)
{
    UINT8 *pu8EPBuffer;
    UINT8 u8EPSize; 
    

    /* Adjust the buffer location */
    u8EP++;

    /* Assign the proper EP buffer */
    pu8EPBuffer=BufferPointer[u8EP];
    
    /* Copy User buffer to EP buffer */
    u8EPSize=tBDTtable[u8EP].Cnt;
    u8EP=u8EPSize;
    
    while(u8EPSize--)
         *pu8DataPointer++=*pu8EPBuffer++;
    return(u8EP);
}

/**********************************************************/
UINT16 USB_EP_OUT_SizeCheck(UINT8 u8EP)
{
    UINT8 u8EPSize; 
    /* Read Buffer Size */
    u8EPSize=SWAP16(tBDTtable[u8EP<<2].Cnt);
    return(u8EPSize&0x03FF);
}

/**********************************************************/
void USB_Set_Interface(void)
{
    /* EndPoint Register settings */
    USB0_ENDPT1= EP1_VALUE | USB_ENDPT_EPHSHK_MASK;                         
    USB0_ENDPT2= EP2_VALUE | USB_ENDPT_EPHSHK_MASK;                         
    USB0_ENDPT3= EP3_VALUE | USB_ENDPT_EPHSHK_MASK;                         
    USB0_ENDPT4= EP4_VALUE | USB_ENDPT_EPHSHK_MASK;                         
    USB0_ENDPT5= EP5_VALUE | USB_ENDPT_EPHSHK_MASK;                         
    USB0_ENDPT6= EP6_VALUE | USB_ENDPT_EPHSHK_MASK;                         
  

    /* EndPoint 1 BDT Settings*/
    tBDTtable[bEP1IN_ODD].Stat._byte= kMCU;
    tBDTtable[bEP1IN_ODD].Cnt = 0x00;
    tBDTtable[bEP1IN_ODD].Addr =(UINT32)gu8EP1_IN_ODD_Buffer;

    /* EndPoint 2 BDT Settings*/
    tBDTtable[bEP2IN_ODD].Stat._byte= kMCU;
    tBDTtable[bEP2IN_ODD].Cnt = 0x00;
    tBDTtable[bEP2IN_ODD].Addr =(UINT32)gu8EP2_IN_ODD_Buffer;            

    /* EndPoint 3 BDT Settings*/
    tBDTtable[bEP3OUT_ODD].Stat._byte= kSIE;
    tBDTtable[bEP3OUT_ODD].Cnt = 0xFF;
    tBDTtable[bEP3OUT_ODD].Addr =(UINT32)gu8EP3_OUT_ODD_Buffer;            
}


/**********************************************************/
void USB_StdReq_Handler(void)
{

    switch(Setup_Pkt->bRequest)
    {
        case mSET_ADDRESS:
            EP_IN_Transfer(EP0,0,0);
            gu8USB_State=uADDRESS;
            break;
      
        case mGET_DESC:
            switch(Setup_Pkt->wValue_h) 
            {
                case mDEVICE:
                    EP_IN_Transfer(EP0,(UINT8*)Device_Descriptor,sizeof(Device_Descriptor));
                    break;
                    
                case mCONFIGURATION:
                    EP_IN_Transfer(EP0,(UINT8*)Configuration_Descriptor,sizeof(Configuration_Descriptor));
                    break;
        
                case mSTRING:
                    EP_IN_Transfer(EP0,(UINT8*)String_Table[Setup_Pkt->wValue_l],String_Table[Setup_Pkt->wValue_l][0]);
                    break;

                default:
                    USB_EP0_Stall();
                    break;  
            }
            break;

        case mSET_CONFIG:
            gu8Dummy=Setup_Pkt->wValue_h+Setup_Pkt->wValue_l;
            if(Setup_Pkt->wValue_h+Setup_Pkt->wValue_l) 
            {
                USB_Set_Interface();                         
                EP_IN_Transfer(EP0,0,0);
                gu8USB_State=uENUMERATED;
            }
            break;
      
        case mGET_CONFIG:
            EP_IN_Transfer(EP0,(UINT8*)&gu8Dummy,1);
            break;

        case mGET_STATUS:
            gu8Status=0;
            EP_IN_Transfer(EP0,(UINT8*)&gu8Status,2);
            break;


        default:
            USB_EP0_Stall();                              
            break;
    }
}

/**********************************************************/
void USB_Setup_Handler(void)
{
    UINT8 u8State;
    
    FLAG_CLR(0,gu8USB_Toogle_flags);
    switch(Setup_Pkt->bmRequestType & 0x1F)
    {
        case DEVICE_REQ:
            if((Setup_Pkt->bmRequestType & 0x1F)== STANDARD_REQ)
            {
                //tBDTtable[bEP0IN_ODD].Stat._byte= kUDATA1;
                
                USB_StdReq_Handler();            
            }
            tBDTtable[bEP0OUT_ODD].Stat._byte= kUDATA0;
            break;        

        case INTERFACE_REQ:
            u8State=USB_InterfaceReq_Handler();    

            if(u8State==uSETUP)
                tBDTtable[bEP0OUT_ODD].Stat._byte= kUDATA0;
            else
                tBDTtable[bEP0OUT_ODD].Stat._byte= kUDATA1;            
            break;        

        case ENDPOINT_REQ:
            USB_Endpoint_Setup_Handler();
            tBDTtable[bEP0OUT_ODD].Stat._byte= kUDATA0;
            break;        

        default:
            USB_EP0_Stall();  
            break;        
    }
        
    //USB_CTL&=!USB_CTL_TXSUSPENDTOKENBUSY_MASK;
      
    //CTL_TXSUSPEND_TOKENBUSY=0;
    FLAG_CLR(USB_CTL_TXSUSPENDTOKENBUSY_SHIFT,USB0_CTL);
}

/**********************************************************/
void USB_Endpoint_Setup_Handler(void)
{
    UINT16 u16Status;
    

    switch(Setup_Pkt->bRequest)
    {        
        case GET_STATUS:
            if(FLAG_CHK(Setup_Pkt->wIndex_h,gu8HALT_EP))
                u16Status=0x0100;
            else
                u16Status=0x0000;
            
            EP_IN_Transfer(EP0,(UINT8*)&u16Status,2);
            break;

        case CLEAR_FEATURE:
            FLAG_CLR(Setup_Pkt->wIndex_h,gu8HALT_EP); 
            EP_IN_Transfer(EP0,0,0);
            break;

        case SET_FEATURE:
            FLAG_SET(Setup_Pkt->wIndex_h,gu8HALT_EP); 
            EP_IN_Transfer(EP0,0,0);
            break;

        default:
            break;
    }
}

/**********************************************************/
void USB_Handler(void)
{
    UINT8 u8EndPoint;
    UINT8 u8IN;
    
    u8IN=USB0_STAT & 0x08;
    u8EndPoint=USB0_STAT >> 4;
    

    /* Data EndPoints */
    if(u8EndPoint)
    {
        if(!u8IN)
        {
            usbMCU_CONTROL(u8EndPoint);
            FLAG_SET(u8EndPoint,gu8USB_Flags);  
            //tBDTtable[u8EndPoint+1].Stat._byte= kSIE;            
            //tBDTtable[u8EndPoint+1].Stat._byte= kMCU;            
        }
    }


    /* Control EndPoint */
    else
    {
        if(u8IN)
            USB_EP0_IN_Handler();        
        else
        {
            if(tBDTtable[bEP0OUT_ODD].Stat.RecPid.PID == mSETUP_TOKEN)
                USB_Setup_Handler();
            else
                USB_EP0_OUT_Handler();
        }

    }
}

/**********************************************************/
void USB_EP0_IN_Handler(void)
{
    if(gu8USB_State==uADDRESS)
    {
        USB0_ADDR = Setup_Pkt->wValue_l;
        gu8USB_State=uREADY;
        FLAG_SET(fIN,gu8USBClearFlags);
    }
    EP_IN_Transfer(0,0,0);    
}


/**********************************************************/
void USB_EP0_Stall(void)
{
   
    FLAG_SET(USB_ENDPT_EPSTALL_SHIFT,USB0_ENDPT0);
    //ENDPT0_EP_STALL = 1;                      
    tBDTtable[bEP0OUT_ODD].Stat._byte = kUDATA0; 
    tBDTtable[bEP0OUT_ODD].Cnt = EP0_SIZE;       
}


/**********************************************************/
void USB_EP0_OUT_Handler(void)
{
    
    FLAG_SET(0,gu8USB_Flags);
    //tBDTtable[bEP0OUT_ODD].Cnt = EP0_SIZE; 
    tBDTtable[bEP0OUT_ODD].Stat._byte = kUDATA0;
    //tBDTtable[bEP0IN].Stat._byte = kUDATA1;      
    
}


/**********************************************************/
void USB_Stall_Handler(void) 
{
    if(FLAG_CHK(USB_ENDPT_EPSTALL_SHIFT,USB0_ENDPT0))
        FLAG_CLR(USB_ENDPT_EPSTALL_SHIFT,USB0_ENDPT0);
    FLAG_SET(USB_ISTAT_STALL_SHIFT,USB0_ISTAT);
}


/**********************************************************/
void USB_Reset_Handler(void)
{
    //PMC_VLPR_Exit();
      
    /* Software Flags */
    gu8USBClearFlags=0xFF;
    gu8USB_Toogle_flags=0;
    gu8USB_PingPong_flags=0x00;
    
    /* Disable all data EP registers */
    USB0_ENDPT1=0x00;
    USB0_ENDPT2=0x00;
    USB0_ENDPT3=0x00;
    USB0_ENDPT4=0x00;
    USB0_ENDPT5=0x00;
    USB0_ENDPT6=0x00;

    /* EP0 BDT Setup */
    // EP0 OUT BDT Settings
    tBDTtable[bEP0OUT_ODD].Cnt = EP0_SIZE;
    tBDTtable[bEP0OUT_ODD].Addr =(UINT32)gu8EP0_OUT_ODD_Buffer;
    tBDTtable[bEP0OUT_ODD].Stat._byte = kUDATA1;         
    // EP0 OUT BDT Settings 
    tBDTtable[bEP0OUT_EVEN].Cnt = EP0_SIZE;
    tBDTtable[bEP0OUT_EVEN].Addr =(UINT32)gu8EP0_OUT_EVEN_Buffer;
    tBDTtable[bEP0OUT_EVEN].Stat._byte = kUDATA1;         
    // EP0 IN BDT Settings 
    tBDTtable[bEP0IN_ODD].Cnt = EP0_SIZE;              
    tBDTtable[bEP0IN_ODD].Addr =(UINT32)gu8EP0_IN_ODD_Buffer;      
    tBDTtable[bEP0IN_ODD].Stat._byte = kUDATA0;   
    // EP0 IN BDT Settings 
    tBDTtable[bEP0IN_EVEN].Cnt = (EP0_SIZE);              
    tBDTtable[bEP0IN_EVEN].Addr =(UINT32)gu8EP0_IN_EVEN_Buffer;      
    tBDTtable[bEP0IN_EVEN].Stat._byte = kUDATA0;        

    // Enable EP0
    USB0_ENDPT0=0x0D;

    // Clear all Error flags
    USB0_ERRSTAT=0xFF;
    
    // CLear all USB ISR flags
    USB0_ISTAT=0xFF;

    // Set default Address
    USB0_ADDR=0x00;

    // Enable all error sources
    USB0_ERREN=0xFF;

    // USB Interrupt Enablers
    FLAG_SET(USB_INTEN_TOKDNEEN_SHIFT,USB0_INTEN);
    FLAG_SET(USB_INTEN_SOFTOKEN_SHIFT,USB0_INTEN);
    FLAG_SET(USB_INTEN_ERROREN_SHIFT,USB0_INTEN); 
    FLAG_SET(USB_INTEN_USBRSTEN_SHIFT,USB0_INTEN);    
}





/**********************************************************/
void USB_Device_ISR(void)
{
    //PMC_VLPR_Exit();
    
    FLAG_SET(1,GPIOC_PDOR);
  
    if(FLAG_CHK(USB_ISTAT_USBRST_SHIFT,USB0_ISTAT)) 
    {
        // Clear Reset Flag 
        //USB_ISTAT = USB_ISTAT_USBRST_MASK;   

        // Handle RESET Interrupt 
        USB_Reset_Handler();
   
        // Clearing this bit allows the SIE to continue token processing
        //   and clear suspend condition 
        //CTL_TXSUSPEND_TOKENBUSY = 0;
        //FLAG_CLR(USB_CTL_TXSUSPENDTOKENBUSY_SHIFT,USB_CTL);
        // No need to process other interrupts 
        return;
    }
    
    
    if(FLAG_CHK(USB_ISTAT_SOFTOK_SHIFT,USB0_ISTAT)) 
    {
        USB0_ISTAT = USB_ISTAT_SOFTOK_MASK;   
    }
    
    
    
    if(FLAG_CHK(USB_ISTAT_STALL_SHIFT,USB0_ISTAT)) 
    //if(INT_STAT_STALL && INT_ENB_STALL_EN )
    {
        USB_Stall_Handler();
    }
    
    
     if(FLAG_CHK(USB_ISTAT_TOKDNE_SHIFT,USB0_ISTAT)) 
    {

        FLAG_SET(USB_CTL_ODDRST_SHIFT,USB0_CTL);
        USB_Handler();
        FLAG_SET(USB_ISTAT_TOKDNE_SHIFT,USB0_ISTAT);
    }
    
    
    if(FLAG_CHK(USB_ISTAT_SLEEP_SHIFT,USB0_ISTAT)) 
    //if(INT_STAT_SLEEP && INT_ENB_SLEEP_EN_MASK)
    {
            // Clear RESUME Interrupt if Pending 
        //INT_STAT = INT_STAT_RESUME_MASK;
          //u8ISRCounter++;  
      //FLAG_SET(USB_ISTAT_RESUME_SHIFT,USB_ISTAT);
        
        // Clear SLEEP Interrupt 
        FLAG_SET(USB_ISTAT_SLEEP_SHIFT,USB0_ISTAT);
        //INT_STAT = INT_STAT_SLEEP_MASK;
        //FLAG_SET(USB_INTEN_RESUME_SHIFT,USB_ISTAT);
        //INT_ENB_RESUME_EN = 1;
        
    }
    
    if(FLAG_CHK(USB_ISTAT_ERROR_SHIFT,USB0_ISTAT)) 
    //if(INT_STAT_ERROR && INT_ENB_ERROR_EN )
    {
        FLAG_CHK(USB_ISTAT_ERROR_SHIFT,USB0_ISTAT);
        //printf("\nUSB Error\n");
        //INT_STAT_ERROR=1;

    }
}

