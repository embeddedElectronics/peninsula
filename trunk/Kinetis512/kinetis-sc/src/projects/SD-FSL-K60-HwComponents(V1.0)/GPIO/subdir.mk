################################################################################
# �Զ����ɵ��ļ�����Ҫ�༭��
################################################################################

-include ../../../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS_QUOTED += \
"../Sources/hwComponent/GPIO/hw_gpio.c" \

C_SRCS += \
../Sources/hwComponent/GPIO/hw_gpio.c \

OBJS += \
./Sources/hwComponent/GPIO/hw_gpio.obj \

C_DEPS += \
./Sources/hwComponent/GPIO/hw_gpio.d \

OBJS_QUOTED += \
"./Sources/hwComponent/GPIO/hw_gpio.obj" \

OBJS_OS_FORMAT += \
./Sources/hwComponent/GPIO/hw_gpio.obj \


# Each subdirectory must supply rules for building sources it contributes
Sources/hwComponent/GPIO/hw_gpio.obj: ../Sources/hwComponent/GPIO/hw_gpio.c
	@echo '���ڹ����ļ��� $<'
	@echo '���ڵ��ã� ARM Compiler'
	"$(ARM_ToolsDirEnv)/mwccarm" -gccinc @@"Sources/hwComponent/GPIO/hw_gpio.args" -o "Sources/hwComponent/GPIO/hw_gpio.obj" -c "$<" -MD -gccdep
	@echo '�ѽ��������� $<'
	@echo ' '

Sources/hwComponent/GPIO/%.d: ../Sources/hwComponent/GPIO/%.c
	@echo '�������������ļ��� $@'
	
	@echo ' '


