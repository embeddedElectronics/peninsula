//=========================================================================
// 文件名称：hw_sdhc.h                                                         
// 功能概要：sdhc构件源文件
// 版权所有: 苏州大学飞思卡尔嵌入式中心(sumcu.suda.edu.cn)
// 版本更新: 2011-12-14     V1.0        SDHC构件初始版本
//          2011-12-20     V1.1        SDHC构件优化修改
//=========================================================================

#ifndef __SDHC_H__
#define __SDHC_H__

#include "common.h"
//#include "hw_gpio.h"

extern int core_clk_khz;

//命令处理结构体
typedef struct esdhc_command_struct
{
    uint8  COMMAND;     //命令码
    uint8  TYPE;        //命令类型
    uint32 ARGUMENT;    //命令参数
    uint8  READ;        //是否为读访问
    uint32 BLOCKS;      //操作块数
    uint32 RESPONSE[4]; //应答
} ESDHC_COMMAND_STRUCT, *ESDHC_COMMAND_STRUCT_PTR;

//保存SDHC设备各种操作信息
typedef struct io_sdcard_struct
{
    uint8  CARD_TYPE;  //保存插入设备类型
    uint32 BITS;       //设置SDHC模块的读取和写入时的位宽
    uint32 SD_TIMEOUT; //设置SDHC命令超时时间
    uint32 NUM_BLOCKS; //插入的设备的模块数
    uint8  SDHC;       //保存插入设备是否为SDHC，如果为TRUE，起始地址=扇区*512
    uint8  VERSION2;   //判断是否为SD 2.0以上的卡
    uint32 ADDRESS;    //设备地址

} SDCARD_STRUCT, *SDCARD_STRUCT_PTR;

#define CORE_CLOCK_HZ	   96000000 //MCU内核时钟
#define BAUD_RATE_HZ       25000000 //SDHC模块通信波特率

//定义MCU为小端
#define MCU_ENDIAN  LITTLE_ENDIAN

//定义设备块大小
#define IO_SDCARD_BLOCK_SIZE_POWER   (9)
#define IO_SDCARD_BLOCK_SIZE         (1 << IO_SDCARD_BLOCK_SIZE_POWER)

//SD卡检测定义
#define SDCARD_DETECT_PORT       PORT_E
#define SDCARD_DETECT_PIN        28
#define SDCARD_PROTECT_PORT      PORT_E
#define SDCARD_PROTECT_PIN       27

#define GPIO_PIN_MASK            0x1Fu
#define GPIO_PIN(x)              (((1)<<(x & GPIO_PIN_MASK)))

#define SDCARD_GPIO_DETECT       (GPIOE_PDIR & GPIO_PDIR_PDI(GPIO_PIN(SDCARD_DETECT_PIN)))
#define SDCARD_GPIO_PROTECT		 (GPIOE_PDIR & GPIO_PDIR_PDI(GPIO_PIN(SDCARD_PROTECT_PIN)))

//IOCTL函数命令定义
#define IO_IOCTL_ESDHC_INIT                  (0x01)
#define IO_IOCTL_ESDHC_SEND_COMMAND          (0x02)
#define IO_IOCTL_ESDHC_GET_CARD              (0x03)
#define IO_IOCTL_ESDHC_GET_BAUDRATE          (0x04)
#define IO_IOCTL_ESDHC_SET_BAUDRATE          (0x05)
#define IO_IOCTL_ESDHC_GET_BUS_WIDTH         (0x06)
#define IO_IOCTL_ESDHC_SET_BUS_WIDTH         (0x07)
#define IO_IOCTL_ESDHC_GET_BLOCK_SIZE        (0x08)
#define IO_IOCTL_ESDHC_SET_BLOCK_SIZE        (0x09)

//IOCTL处理结果和返回值
#define IO_OK                      (0)

#define IO_DEVICE_DOES_NOT_EXIST   (0x01)
#define IO_ERROR_READ              (0x02)
#define IO_ERROR_WRITE             (0x03)
#define IO_ERROR_SEEK              (0x04)
#define IO_ERROR_WRITE_PROTECTED   (0x05)
#define IO_ERROR_READ_ACCESS       (0x06)
#define IO_ERROR_WRITE_ACCESS      (0x07)
#define IO_ERROR_SEEK_ACCESS       (0x08)
#define IO_ERROR_INVALID_IOCTL_CMD (0x09)
#define IO_ERROR_DEVICE_BUSY       (0x0A)
#define IO_ERROR_DEVICE_INVALID    (0x0B)
#define IO_ERROR_INVALID_PARAMETER (0x0C)

#define IO_ERROR_TIMEOUT           (0x10)
#define IO_ERROR_INQUIRE           (0x11)

// ESDHC错误码
#define ESDHC_OK                             (0x00)
#define ESDHC_ERROR_INIT_FAILED              (0x01)
#define ESDHC_ERROR_COMMAND_FAILED           (0x02)
#define ESDHC_ERROR_COMMAND_TIMEOUT          (0x03)
#define ESDHC_ERROR_DATA_TRANSFER            (0x04)
#define ESDHC_ERROR_INVALID_BUS_WIDTH        (0x05)
#define ESDHC_ERROR_IO        				 (0x06)

// ESDHC总线宽度
#define ESDHC_BUS_WIDTH_1BIT                 (0x00)
#define ESDHC_BUS_WIDTH_4BIT                 (0x01)
#define ESDHC_BUS_WIDTH_8BIT                 (0x02)

// ESDHC卡类型
#define ESDHC_CARD_NONE                      (0x00)
#define ESDHC_CARD_UNKNOWN                   (0x01)
#define ESDHC_CARD_SD                        (0x02)
#define ESDHC_CARD_SDHC                      (0x03)
#define ESDHC_CARD_SDIO                      (0x04)
#define ESDHC_CARD_SDCOMBO                   (0x05)
#define ESDHC_CARD_SDHCCOMBO                 (0x06)
#define ESDHC_CARD_MMC                       (0x07)
#define ESDHC_CARD_CEATA                     (0x08)

// ESDHC命令类型
#define ESDHC_TYPE_NORMAL                    (0x00)
#define ESDHC_TYPE_SUSPEND                   (0x01)
#define ESDHC_TYPE_RESUME                    (0x02)
#define ESDHC_TYPE_ABORT                     (0x03)
#define ESDHC_TYPE_SWITCH_BUSY               (0x04)

// ESDHC命令
#define ESDHC_CMD0                           (0)
#define ESDHC_CMD1                           (1)
#define ESDHC_CMD2                           (2)
#define ESDHC_CMD3                           (3)
#define ESDHC_CMD4                           (4)
#define ESDHC_CMD5                           (5)
#define ESDHC_CMD6                           (6)
#define ESDHC_CMD7                           (7)
#define ESDHC_CMD8                           (8)
#define ESDHC_CMD9                           (9)
#define ESDHC_CMD10                          (10)
#define ESDHC_CMD11                          (11)
#define ESDHC_CMD12                          (12)
#define ESDHC_CMD13                          (13)
#define ESDHC_CMD15                          (15)
#define ESDHC_CMD16                          (16)
#define ESDHC_CMD17                          (17)
#define ESDHC_CMD18                          (18)
#define ESDHC_CMD20                          (20)
#define ESDHC_CMD24                          (24)
#define ESDHC_CMD25                          (25)
#define ESDHC_CMD26                          (26)
#define ESDHC_CMD27                          (27)
#define ESDHC_CMD28                          (28)
#define ESDHC_CMD29                          (29)
#define ESDHC_CMD30                          (30)
#define ESDHC_CMD32                          (32)
#define ESDHC_CMD33                          (33)
#define ESDHC_CMD34                          (34)
#define ESDHC_CMD35                          (35)
#define ESDHC_CMD36                          (36)
#define ESDHC_CMD37                          (37)
#define ESDHC_CMD38                          (38)
#define ESDHC_CMD39                          (39)
#define ESDHC_CMD40                          (40)
#define ESDHC_CMD42                          (42)
#define ESDHC_CMD52                          (52)
#define ESDHC_CMD53                          (53)
#define ESDHC_CMD55                          (55)
#define ESDHC_CMD56                          (56)
#define ESDHC_CMD60                          (60)
#define ESDHC_CMD61                          (61)
#define ESDHC_ACMD6                          (0x40 + 6)
#define ESDHC_ACMD13                         (0x40 + 13)
#define ESDHC_ACMD22                         (0x40 + 22)
#define ESDHC_ACMD23                         (0x40 + 23)
#define ESDHC_ACMD41                         (0x40 + 41)
#define ESDHC_ACMD42                         (0x40 + 42)
#define ESDHC_ACMD51                         (0x40 + 51)

#define ESDHC_XFERTYP_RSPTYP_NO              (0x00)
#define ESDHC_XFERTYP_RSPTYP_136             (0x01)
#define ESDHC_XFERTYP_RSPTYP_48              (0x02)
#define ESDHC_XFERTYP_RSPTYP_48BUSY          (0x03)

#define ESDHC_XFERTYP_CMDTYP_ABORT           (0x03)

#define ESDHC_PROCTL_EMODE_INVARIANT         (0x02)

//数据协议通道位数定义
#define ESDHC_PROCTL_DTW_1BIT                (0x00)
#define ESDHC_PROCTL_DTW_4BIT                (0x01)
#define ESDHC_PROCTL_DTW_8BIT                (0x10)

//=================接口函数声明============================================
//=========================================================================
//函数名称：hw_sdhc_init                                                        
//功能概要：初始化SDHC模块。                                                
//参数说明：coreClk：内核时钟                                                    
//         baud：SDHC通信频率                                 
//函数返回：成功时返回：ESDHC_OK;其它返回值为错误。                                                               
//=========================================================================
uint32 hw_sdhc_init(uint32 coreClk, uint32 baud);

//=========================================================================
//函数名称：hw_sdhc_receive_block                                                         
//功能概要：接收n个字节                                                 
//参数说明：buff: 接收缓冲区                                                 
//		   btr:接收长度                                                     
//函数返回： 1:成功;0:失败                                                    
//=========================================================================
uint32 hw_sdhc_receive_block (uint8 *buff, uint32 btr);

//=========================================================================
//函数名称：hw_sdhc_send_block                                                         
//功能概要：发送n个字节                                                 
//参数说明：buff: 发送缓冲区                                                 
//		   btr:发送长度                                                     
//函数返回： 1:成功;0:失败                                                    
//=========================================================================
uint32 hw_sdhc_send_block (const uint8 *buff, uint32 btr);

//=========================================================================
//函数名称：hw_sdhc_ioctl                                                         
//功能概要：配置SDHC模块                                                 
//参数说明：cmd: 配置命令                                                 
//		   param_ptr:数据指针                                                     
//函数返回： 功时返回：ESDHC_OK;其它返回值为错误                                                    
//=========================================================================
uint32 hw_sdhc_ioctl(uint32 cmd,void *param_ptr);

extern SDCARD_STRUCT 		SDHC_Card;

#endif // SDHC_H_
