This project is a simple low power TSI example. 

By default the OS-JTAG is used for the terminal output. The terminal should be configured for 115200 8-N-1.

Supported platforms:
- TWR_K40X256
- TWR_K60N512

The tsi_low_pwr.eww file will open the project for all of the supported platforms. Pick the specific project that corresponds to your hardware. Use flash based programming due the nature of the low power operations of the MCU.

NOTE: if switching between platforms it is a good idea to do a make clean to make sure the code is properly configured for the new platform.

