Kinetis Sample Code

1) Contents

This package contains a number of bare-metal example projects for the Kinetis family processors including header files and initialization code.

Currently supported hardware platforms are:
- TWR_K40X256
- TWR_K60N512

2) Directory Structure

kinetis-sc\
|--- build\
|--- src\

build\ - All development toolchain specific files are located in this
         subdirectory.

src\   - All source files are arranged in folders inside this 
         directory.

The src\ tree is broken up as follows:

src\common\    - Common utilities such as printf and stdlib are 
                 provided in this directory
src\cpu\       - CPU specific initialization and header files here
src\drivers\   - Drivers for some of the various peripherals are  
                 provided here.
src\platforms\ - Each supported platform has a header file that defines
                 board specific information, such as the input clock
                 frequency used for that board.
src\projects\  - This directory holds all the individual example
                 project source code


3) Toolchain Support

Currently the IAR and CW10.1 toolchains are supported.

3.1) IAR Embedded Workbench

IAR workspace, project, linker, and support files are provided in 
kinetis-sc\build\iar.  Each example has it's own directory and
within that directory is a workspace file (.eww) that will load the
supported projects (usually one project for each supported hardware
platform). Each project contains several configuration options that
can be selected using a drop menu. The configuration support different
link targets for different Kinetis memory configurations (e.g. RAM_128KB
or FLASH_512KB_PFLASH).

3.2) CodeWarrior 10.1

CodeWarrior 10.1 project files can be found in the kinetis-sc\build\cw folder. The folder also contains a cw_readme.txt file with information on how to import projects into CodeWarrior.


4) Examples

There are many example projects that hightlight the operation of different
modules. The "hello_world" demo is the simplest example, and this project
is the baseline used for developing other examples. The hello_world project 
will perform basic initialization for the board and then display the device 
configuration information on the terminal (default baud rate is 115200). 

Each example includes a readme.txt file in the workspace or project directory
that gives a description of what the project does and describes any configuration
needed to use it.


5) Creating new projects

The kinetis-sc\build\iar\make_new_project.exe or kinetis-sc\build\cw\make_new_cs_project.exe files can be used to clone the hello_world project for the appropriate toolchain. The script will prompt you for a name to use for the new project, then creates copies of all needed files and folders.





