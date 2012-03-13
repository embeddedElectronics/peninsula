Description of MCG_twr_demo

This code has been tested on both the K40 and K60 Tower boards.

The UART settings are baud rate 19200, 8 bits data, 1 bit stop, no parity and no flow control. It is recommended the baud rate not be increased to ensure reliable serial communication in all MCG modes.

Out of reset, the PLL is enabled at 96MHz. There are several commands that allow some basic MCG modes and operations to be performed. 

The list of commands and syntax are as follows:

"rd" - displays the MCG register values and their "index value" for use when writing to the MCG registers

"wrt" <register index> <value> - allows you to write a hexadecimal value to the specified MCG register
                                 For example, wrt 2 45 will write 0x45 to MCG_C3

"atc" <0 = slow, 1 = fast> <frequency in Hz> - allows you to auto trim either the fast or slow IRC. You must be in PEE mode at 96MHz for this to work correctly. It is recommended that the slow IRC be trimmed to 32768 Hz and the fast IRC to 3600000 Hz to ensure the UART baud rate is correct when enterring MCG modes that use the IRC. This should be performed before changing modes.
For example, atc 0 32768 will auto trim the slow IRC to 32768 Hz

"blpi"- transitions from PEE mode to BLPI mode

"pee" - transitions from BLPI mode to PEE mode

"fei" - transitions from PEE mode to FEI mode

"fei2pee - transitions from FEI mode to PEE mode

"adc" - enables the ADC and uses the upper 5 bits of the result register to be used as the VDIV setting in the PLL. This allows for the on-board potentiometer to control the PLL frequency. The ADC count and the PLL frequency are displayed. The continuous loop is exited by hitting any key. Note that due to the constant baud rate updates, the displayed information may initially be garbled when the frequency is changed.

"cstm1" - empty function that can be populated with several mode change function calls. Refer to the available blpi, pee, fei and fei2pee functions for examples of how to use this.

"cstm2" - empty function that can be populated with several mode change function calls. Refer to the available blpi, pee, fei and fei2pee functions for examples of how to use this.

"blpi_pee" - example code from the QRUG. Assumes the MCG is in PEE mode and moves the MCG to BLPI mode. It waits for any key to be typed and then moves the MCG back to PEE mode.

"fei_pee" - example code from the QRUG. Assumes the MCG is in FEI mode and moves the MCG to PEE mode.

"rtc_ref" - example code from the QRUG. Assumes the MCG is in FEI mode and switches the MCG to FEE mode using the RTC 32 kHz clock as the FLL reference clock.

For rev. 1.0 devices, the slow IRC will be trimmed to 39.0625 kHz. Future revisions will be trimmed to the correct 32.768 kHz. This code assumes a factory trim of 32.768 kHz. The slow IRC should be trimmed to 32768Hz by means of the included autotrim software.


There is a set of functions that allow switching between various MCG modes. Using these functions it is possible to move between all modes. It may not be possible to move between modes in the fastest way. these function calls can be added to the cstm1 and cstm2 "commands".
void pee_pbe(void);
void pbe_blpe(void);
void blpe_fbe(void);
void fbe_fee(void);
void fee_fei(void);
void fei_fbi(void);
void fbi_blpi(void);
void blpi_fbi(void);
void fbi_fbe(void);
void fbe_pbe(void);
void pbe_pee(void);

