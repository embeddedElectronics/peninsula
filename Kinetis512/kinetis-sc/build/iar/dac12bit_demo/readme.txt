Supported platforms:

 * TWR-K40X256, REVA. User can probe DAC0(L3) at test point TP18 and DAC1(L4) at test point TP16
 * TWR-K60N512, REVA. User can probe DAC0(L3) at test point TP23 and DAC1(L4) at test point TP22 
 * TWR-K40X256, REVB. User can probe DAC0(L3) at test point TP4  and DAC1(L4) at test point TP3
 * TWR-K60N512, REVC. User can probe DAC0(L3) at test point TP1  and DAC1(L4) at test point TP7

NOTE: 
-By default the OS-JTAG is used for the terminal output. The terminal should be configured for 115200 8-N-1.
 The dac12bit_demo.eww file will open the project for all of the supported platforms. Pick the specific project that corresponds to your hardware.
-When switching between platforms it is a good idea to do a make clean to make sure the code is properly configured for the new platform.



This project consists of five example demos for the k40/K60 12-bit DAC0 and DAC1 modules. Please   

DEMO 1:
                This demo showcases DAC module's capability to select an input reference voltage from either  
                1 ) The external VDDA pin 
                2 ) The internal on-chip fixed reference voltage from the output of the VREF module.
                You will observe at each of the DAC0 and DAC1 pin, a repeated ramp linear signal will be generated. 
                The peak/max of the ramp signal generated by DAC0 or DAC1 is restricted by the corresponding input voltage reference value. 
                Since DAC0 selects at a lower input voltage reference from VREF output at about 1.2V(varies from part to part) and DAC1 selects a higher input voltage
                reference from VDDA pin at about 3.3V, the peak of DAC0 signal will be less than the DAC1 signal
                Notice Demo 1 sets up DAC modules in non-buffer mode. This means that DAC output solely base on the 
                  digital value stores at DAC_DAT0 register. As in buffered mode, the DAC output value is base on the DAC_DATx value where the read pointer
                points to.
                
DEMO 2: 
                This demo showcases the DAC module capability when configured as buffered mode
                When DAC is enabled buffered mode, the DAC output value is base on the DAC_DATx 
                value where the read pointer points to. There are totally 16 word DAC buffer(DAC_DAT0 to DAC_DAT16) for each
                DAC module. There are two configuration that you can choose to advance the read pointer to the next
                buffer. One is Software trigger another is hardware trigger by PDB timmer module. Also, in buffer mode
                You can define where the read pointer goes to after reading the top limit pointer.
                we will show case Software trigger and Normal mode.
               

DEMO 3
                Same configuration from DEMO 2 except we are runing in SWING mode.
                Observe DACx output, you will notice the ramp will go down after it ramp up.
                  


DEMO 4
                Same configuration from DEMO 3 except we are runing in ONE_TIME mode. 
                Observe DACx output, you will notice the ramp up will only occur once and won't repeat.
                 
DEMO 5
                This is an example of using hardware trigger by the PDB module, to advance to the next 
                read pointer in buffer mode. You will notice DAC output changes intervals are defined by the 
                value specified in the PDB_DACINTx register. See PDB_DAC0_TriggerInit or PDB_DAC1_TriggerInit
                for detail.
                  





