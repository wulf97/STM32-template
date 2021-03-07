include ../../config


#####################################################################################################
SRC_DIR := src
INCLUDE_PATH += -I inc
BUILD_DIR := $(addprefix ../../, $(BUILD_DIR))
OBJ_DIR := $(BUILD_DIR)/obj
LIB_DIR := $(BUILD_DIR)/lib

OBJ := \
	event_groups.o \
	heap_1.o \
	list.o \
	port.o \
	queue.o \
	stream_buffer.o \
	tasks.o \
	timers.o \
	mpu_wrappers.o



#####################################################################################################
all: $(addprefix $(OBJ_DIR)/, $(OBJ))
	$(AR) q $(LIB_DIR)/libFreeRTOS.a $(addprefix $(OBJ_DIR)/, $(OBJ))

$(OBJ_DIR)%.o: src%.c
	$(CC) $(CFLAGS) $(INCLUDE_PATH) -c $< -o $@


clean:
	rm $(addprefix $(OBJ_DIR)/, $(OBJ))
	rm $(LIB_DIR)/libFreeRTOS.a
