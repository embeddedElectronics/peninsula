//============================================================================
// 文件名称：hw_eth_phy.h                                                          
// 功能概要：以太网物理层驱动头文件
// 版权所有: 苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
// 版本更新: 2011-12-16     V1.0       
//============================================================================

#ifndef __PHY_H__
#define __PHY_H__

#include "common.h"

extern int periph_clk_khz;
#define MII_TIMEOUT		       0x1FFFF
#define MII_LINK_TIMEOUT	   0x1FFFF
//检查连接的最大时间
#define enetLINK_DELAY         500
#define enetMINIMAL_DELAY      2

#define  PHY_ADDRESS   0


//========================================================================
//函数名称：PHYInit()                                                         
//功能概要：初始化EPHY模块                                                
//参数说明：sys_clk_mhz:系统时钟频率 (MHz)                                                                                                 
//函数返回：操作成功返回0，失败返回1                                            
//========================================================================
uint8  hw_phy_init(uint16 sys_clk_mhz);

//========================================================================
//函数名称：hw_eth_phy_LinkState                                                         
//功能概要：检测网络是否已连接                                              
//参数说明：phy_addr:EPHY设备地址                                                                                                 
//函数返回：操作成功返回0，失败返回1                                            
//========================================================================
uint8 hw_eth_phy_LinkState(uint16 phy_addr);


/*MII Register Addresses*/
#define PHY_BMCR                    (0x00)
#define PHY_BMSR                    (0x01)
#define PHY_PHYIDR1                 (0x02)
#define PHY_PHYIDR2                 (0x03)
#define PHY_ANAR                    (0x04)
#define PHY_ANLPAR                  (0x05)
#define PHY_ANLPARNP                (0x05)
#define PHY_ANER                    (0x06)
#define PHY_ANNPTR                  (0x07)
#define PHY_PHYSTS                  (0x10)
#define PHY_MICR                    (0x11)
#define PHY_MISR                    (0x12)
#define PHY_PAGESEL                 (0x13)

/*TSI-EVB definition: National Semiconductor*/
#define PHY_PHYCR2                  (0x1C)

/*TWR definition: Micrel*/
#define PHY_PHYCTRL1                (0x1E)
#define PHY_PHYCTRL2                (0x1F)

/*Bit definitions and macros for PHY_BMCR*/
#define PHY_BMCR_RESET              (0x8000)
#define PHY_BMCR_LOOP               (0x4000)
#define PHY_BMCR_SPEED              (0x2000)
#define PHY_BMCR_AN_ENABLE          (0x1000)
#define PHY_BMCR_POWERDOWN          (0x0800)
#define PHY_BMCR_ISOLATE            (0x0400)
#define PHY_BMCR_AN_RESTART         (0x0200)
#define PHY_BMCR_FDX                (0x0100)
#define PHY_BMCR_COL_TEST           (0x0080)

/*Bit definitions and macros for PHY_BMSR*/
#define PHY_BMSR_100BT4             (0x8000)
#define PHY_BMSR_100BTX_FDX         (0x4000)
#define PHY_BMSR_100BTX             (0x2000)
#define PHY_BMSR_10BT_FDX           (0x1000)
#define PHY_BMSR_10BT               (0x0800)
#define PHY_BMSR_NO_PREAMBLE        (0x0040)
#define PHY_BMSR_AN_COMPLETE        (0x0020)
#define PHY_BMSR_REMOTE_FAULT       (0x0010)
#define PHY_BMSR_AN_ABILITY         (0x0008)
#define PHY_BMSR_LINK               (0x0004)
#define PHY_BMSR_JABBER             (0x0002)
#define PHY_BMSR_EXTENDED           (0x0001)

/*Bit definitions and macros for PHY_ANAR*/
#define PHY_ANAR_NEXT_PAGE          (0x8001)
#define PHY_ANAR_REM_FAULT          (0x2001)
#define PHY_ANAR_PAUSE              (0x0401)
#define PHY_ANAR_100BT4             (0x0201)
#define PHY_ANAR_100BTX_FDX         (0x0101)
#define PHY_ANAR_100BTX             (0x0081)
#define PHY_ANAR_10BT_FDX           (0x0041)
#define PHY_ANAR_10BT               (0x0021)
#define PHY_ANAR_802_3              (0x0001)

/*Bit definitions and macros for PHY_ANLPAR*/
#define PHY_ANLPAR_NEXT_PAGE        (0x8000)
#define PHY_ANLPAR_ACK              (0x4000)
#define PHY_ANLPAR_REM_FAULT        (0x2000)
#define PHY_ANLPAR_PAUSE            (0x0400)
#define PHY_ANLPAR_100BT4           (0x0200)
#define PHY_ANLPAR_100BTX_FDX       (0x0100)
#define PHY_ANLPAR_100BTX           (0x0080)
#define PHY_ANLPAR_10BTX_FDX        (0x0040)
#define PHY_ANLPAR_10BT             (0x0020)


/* Bit definitions of PHY_PHYSTS: National */
#define PHY_PHYSTS_MDIXMODE         (0x4000)
#define PHY_PHYSTS_RX_ERR_LATCH     (0x2000)
#define PHY_PHYSTS_POL_STATUS       (0x1000)
#define PHY_PHYSTS_FALSECARRSENSLAT (0x0800)
#define PHY_PHYSTS_SIGNALDETECT     (0x0400)
#define PHY_PHYSTS_PAGERECEIVED     (0x0100)
#define PHY_PHYSTS_MIIINTERRUPT     (0x0080)
#define PHY_PHYSTS_REMOTEFAULT      (0x0040)
#define PHY_PHYSTS_JABBERDETECT     (0x0020)
#define PHY_PHYSTS_AUTONEGCOMPLETE  (0x0010)
#define PHY_PHYSTS_LOOPBACKSTATUS   (0x0008)
#define PHY_PHYSTS_DUPLEXSTATUS     (0x0004)
#define PHY_PHYSTS_SPEEDSTATUS      (0x0002)
#define PHY_PHYSTS_LINKSTATUS       (0x0001)


/* Bit definitions of PHY_PHYCR2*/
#define PHY_PHYCR2_SYNC_ENET_EN     (0x2000)
#define PHY_PHYCR2_CLK_OUT_RXCLK    (0x1000)
#define PHY_PHYCR2_BC_WRITE         (0x0800)
#define PHY_PHYCR2_PHYTER_COMP      (0x0400)
#define PHY_PHYCR2_SOFT_RESET       (0x0200)
#define PHY_PHYCR2_CLK_OUT_DIS      (0x0001)

/* Bit definition and macros for PHY_PHYCTRL1*/
#define PHY_PHYCTRL1_LED_MASK       (0xC000)
#define PHY_PHYCTRL1_POLARITY       (0x2000)
#define PHY_PHYCTRL1_MDX_STATE      (0x0800)
#define PHY_PHYCTRL1_REMOTE_LOOP    (0x0080)

/* Bit definition and macros for PHY_PHYCTRL2*/
#define PHY_PHYCTRL2_HP_MDIX        (0x8000)
#define PHY_PHYCTRL2_MDIX_SELECT    (0x4000)
#define PHY_PHYCTRL2_PAIRSWAP_DIS   (0x2000)
#define PHY_PHYCTRL2_ENERGY_DET     (0x1000)
#define PHY_PHYCTRL2_FORCE_LINK     (0x0800)
#define PHY_PHYCTRL2_POWER_SAVING   (0x0400)
#define PHY_PHYCTRL2_INT_LEVEL      (0x0200)
#define PHY_PHYCTRL2_EN_JABBER      (0x0100)
#define PHY_PHYCTRL2_AUTONEG_CMPLT  (0x0080)
#define PHY_PHYCTRL2_ENABLE_PAUSE   (0x0040)
#define PHY_PHYCTRL2_PHY_ISOLATE    (0x0020)
#define PHY_PHYCTRL2_OP_MOD_MASK    (0x001C)
#define PHY_PHYCTRL2_EN_SQE_TEST    (0x0002)
#define PHY_PHYCTRL2_DATA_SCRAM_DIS (0x0001)


/* Bit definitions of PHY_PHYCTRL2_OP_MOD_MASK*/
#define PHY_PHYCTRL2_OP_MOD_SHIFT             2
#define PHY_PHYCTRL2_MODE_OP_MOD_STILL_NEG    0
#define PHY_PHYCTRL2_MODE_OP_MOD_10MBPS_HD    1
#define PHY_PHYCTRL2_MODE_OP_MOD_100MBPS_HD   2
#define PHY_PHYCTRL2_MODE_OP_MOD_10MBPS_FD    5
#define PHY_PHYCTRL2_MODE_OP_MOD_100MBPS_FD   6

#endif
