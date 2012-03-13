################################################################################
# 自动生成的文件。不要编辑！
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
	@echo '正在构建文件： $<'
	@echo '正在调用： ARM Compiler'
	"$(ARM_ToolsDirEnv)/mwccarm" -gccinc @@"Sources/hwComponent/Wdog/wdog.args" -o "Sources/hwComponent/Wdog/wdog.obj" -c "$<" -MD -gccdep
	@echo '已结束构建： $<'
	@echo ' '

Sources/hwComponent/Wdog/%.d: ../Sources/hwComponent/Wdog/%.c
	@echo '正在生成依赖文件： $@'
	
	@echo ' '


