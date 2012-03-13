################################################################################
# 自动生成的文件。不要编辑！
################################################################################

-include ../../../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS_QUOTED += \
"../Sources/hwComponent/UART/hw_uart.c" \

C_SRCS += \
../Sources/hwComponent/UART/hw_uart.c \

OBJS += \
./Sources/hwComponent/UART/hw_uart.obj \

C_DEPS += \
./Sources/hwComponent/UART/hw_uart.d \

OBJS_QUOTED += \
"./Sources/hwComponent/UART/hw_uart.obj" \

OBJS_OS_FORMAT += \
./Sources/hwComponent/UART/hw_uart.obj \


# Each subdirectory must supply rules for building sources it contributes
Sources/hwComponent/UART/hw_uart.obj: ../Sources/hwComponent/UART/hw_uart.c
	@echo '正在构建文件： $<'
	@echo '正在调用： ARM Compiler'
	"$(ARM_ToolsDirEnv)/mwccarm" -gccinc @@"Sources/hwComponent/UART/hw_uart.args" -o "Sources/hwComponent/UART/hw_uart.obj" -c "$<" -MD -gccdep
	@echo '已结束构建： $<'
	@echo ' '

Sources/hwComponent/UART/%.d: ../Sources/hwComponent/UART/%.c
	@echo '正在生成依赖文件： $@'
	
	@echo ' '


