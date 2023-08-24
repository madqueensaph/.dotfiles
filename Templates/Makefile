#
# Makefile
# --------
# I worked for like 3 fucking days on this, it's never getting replaced
#

# source files (.c, .h) under "src"
SRC_DIR		:= src
BUILD_DIR	:= build_files

# compiler variables
CC			:= gcc
CFLAGS		:= -std=c17 -pedantic -Wall -Werror -O3
LDLIBS		:= 
TARGET		:= 

# start under "src"; adds file extensions and paths for .o and .d files
FILES		:= 
OBJS		:= $(FILES:%=$(BUILD_DIR)/%.o)
DEPS		:= $(OBJS:%.o=%.d)

# default target; won't compile unless changes are made
all: last_target development

# flags are only present in development mode
development: CFLAGS := $(CFLAGS) -DDEVELOPMENT

# both modes run the same commands
development release: last_target $(TARGET)

# build target executable file
$(TARGET): $(OBJS)
	@echo "========================================"
	@echo "BUILDING TARGET \"$(TARGET)\""
	@echo "----------------------------------------"
	$(CC) $(CFLAGS) -o $(TARGET) $^ $(LDLIBS)
	@echo "========================================"

# checks if last build target is the same, cleans up files if not
last_target:
ifneq ($(MAKECMDGOALS),$(shell cat last_target.txt))
	$(MAKE) clean
endif
	@echo $(MAKECMDGOALS) > last_target.txt

# only builds if source/header file is updated
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@echo "========================================"
	@echo "BUILDING OBJECT \"$@\" FROM \"$<\""
	@echo "----------------------------------------"
	mkdir -p $(BUILD_DIR)/$(subst $(SRC_DIR)/,,$(dir $<))
	$(CC) $(CFLAGS) -MMD -MP -c -o $@ $<

# don't include the dependency rules if doing a clean
ifneq ($(MAKECMDGOALS),clean)
-include $(DEPS)
endif

# cleans up build files
clean:
	@echo "========================================"
	@echo "CLEANING UP FILES"
	@echo "----------------------------------------"
	-rm -r $(BUILD_DIR)/ $(TARGET)
	-rm last_target.txt
	@echo "========================================"

# specifies which targets aren't blocked by a file's existance
.PHONY: all clean last_target development release
