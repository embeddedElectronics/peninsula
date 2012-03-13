DESCRIPTION:
------------
------------
This project is a simple TCP/IP stack (uIP) using FreeRTOS. 

By default the OS-JTAG is used for the terminal output. The terminal should be configured for 115200 8-N-1.

Supported platforms:
- TWR_K60N512

Supported Targets:
- FLASH_512KB_PFLASH
- RAM_128KB

The freertos_lwip.eww file will open the project for all of the supported platforms. Pick the specific project that corresponds to your hardware.

NOTE: if switching between platforms it is a good idea to do a make clean to make sure the code is properly configured for the new platform.

Build the TOWER system with the following jumpers for ENET:



HARDWARE CONFIGURATION:
-----------------------
-----------------------
Build the TOWER system with the following jumpers for ENET:

TWR-K60N512 board:
J523: set 2-3
VREGIN: set

TWR-SER board:
ETH_CONFIG: set 9-10 only
CLKIN_SEL: set 2-3
CLK_SEL: set 3-4 only
OSC_DIS: out

PC CONFIGURATION:
Static IP configuration
IP: 192.168.0.1
MASK: 255.255.255.0

Crossover or Straigh ethernet cable from TWR-SER RJ45 connector to PC RJ45 connector

Program thru OSJTAG


HOW TO RUN THE DEMO:
----------------
----------------
Only go to http://192.168.0.201 in your favorite internet browser

Remember to disable proxy service in case you're using

Web page will show RTOS tasks running and stack consumption.