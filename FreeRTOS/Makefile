include config

#####################################################################################################
SRC_DIR := src
LIBS := -lFreeRTOS
LIBS_NAME := \
	$(LIB_DIR)/libFreeRTOS.a
INCLUDE_PATH += \
	-I arch \
	-I lib/CMSIS/Core/inc \
	-I lib/FreeRTOS/inc

#####################################################################################################
OBJ := \
	boot.o \
	system_stm32f4xx.o \
	main.o

#####################################################################################################
# Preparing section
$(shell mkdir $(BUILD_DIR))
$(shell mkdir $(OBJ_DIR))
$(shell mkdir $(LIB_DIR))

#####################################################################################################
# General build rules

# Link all object files in elf and make bin file
all: $(addprefix $(OBJ_DIR)/, $(OBJ)) $(LIBS_NAME)
	$(CC) $(LDFLAGS) -L $(LIB_DIR) -T ld/$(LD_MAP) $(addprefix $(OBJ_DIR)/, $(OBJ)) $(LIBS) -o $(BUILD_DIR)/$(TARGET).elf
	$(OBJCOPY) -O binary -S $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).bin
	$(SIZE) $(BUILD_DIR)/$(TARGET).elf

# Load firmware
flash: $(BUILD_DIR)/$(TARGET).bin
	$(FLASH) write $< 0x08000000

$(OBJ_DIR)/boot.o: boot/$(BOOT)
	$(ASM) $(ASFLAGS) -c $< -o $@

$(OBJ_DIR)/system_stm32f4xx.o: arch/system_stm32f4xx.c
	$(CC) $(CFLAGS) $(INCLUDE_PATH) -c $< -o $@

#####################################################################################################
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) $(INCLUDE_PATH) -c $< -o $@

$(LIB_DIR)/libFreeRTOS.a:
	make -C lib/FreeRTOS
#####################################################################################################
# clean build directory
clean:
	rm $(OBJ_DIR)/*.o
	rm $(LIB_DIR)/*.a
