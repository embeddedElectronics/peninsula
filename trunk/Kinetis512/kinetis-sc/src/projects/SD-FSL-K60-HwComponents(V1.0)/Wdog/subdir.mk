################################################################################
# �Զ����ɵ��ļ�����Ҫ�༭��
################################################################################

-include ../../../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS_QUOTED += \
"../Sources/hwComponent/Wdog/wdog.c" \

C_SRCS += \
../Sources/hwComponent/Wdog/wdog.c \

OBJS += \
./Sources/hwComponent/Wdog/wdog.obj \

C_DEPS += \
./Sources/hwComponent/Wdog/wdog.d \

OBJS_QUOTED += \
"./Sources/hwComponent/Wdog/wdog.obj" \

OBJS_OS_FORMAT += \
./Sources/hwComponent/Wdog/wdog.obj \


# Each subdirectory must supply rules for building sources it contributes
Sources/hwComponent/Wdog/wdog.obj: ../Sources/hwComponent/Wdog/wdog.c
	@echo '���ڹ����ļ��� $<'
	@echo '���ڵ��ã� ARM Compiler'
	"$(ARM_ToolsDirEnv)/mwccarm" -gccinc @@"Sources/hwComponent/Wdog/wdog.args" -o "Sources/hwComponent/Wdog/wdog.obj" -c "$<" -MD -gccdep
	@echo '�ѽ��������� $<'
	@echo ' '

Sources/hwComponent/Wdog/%.d: ../Sources/hwComponent/Wdog/%.c
	@echo '�������������ļ��� $@'
	
	@echo ' '


