#
# Makefile
# --------
# I worked for like 3 fucking days on this, it's never getting replaced
#

# Directory variables to determine the structure of the project; source files under "src"
SRC_DIR		:= src
BUILD_DIR	:= build_files

# Compiler variables
CC			:= gcc
CFLAGS		:= -std=c17 -pedantic -Wall -Werror -O3
LDLIBS		:= 
TARGET		:= test

# Start under "src"; adds extensions and directory information for object and dependency files
FILES		:= 
OBJS		:= $(FILES:%=$(BUILD_DIR)/%.o)
DEPS		:= $(OBJS:%.o=%.d)

# Default target; won't compile unless object files update
all: $(TARGET)

# Builds executable from object files
$(TARGET): $(OBJS)
	@echo "========================================"
	@echo "BUILDING TARGET \"$(TARGET)\""
	@echo "----------------------------------------"
	$(CC) $(CFLAGS) -o $(TARGET) $^ $(LDLIBS)
	@echo "========================================"

# Builds object files for quicker compiles; only builds if source/header file is updated
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@echo "========================================"
	@echo "BUILDING OBJECT \"$@\" FROM \"$<\""
	@echo "----------------------------------------"
	mkdir -p $(BUILD_DIR)/$(subst $(SRC_DIR)/,,$(dir $<))
	$(CC) $(CFLAGS) -MMD -MP -c -o $@ $<

# Don't include the dependency rules if doing a claen
ifneq ($(MAKECMDGOALS),clean)
-include $(DEPS)
endif

# Useful to prepare project for sending, but also to do every once in a while because messy
clean:
	@echo "========================================"
	@echo "CLEANING UP FILES"
	@echo "----------------------------------------"
	-rm -r $(BUILD_DIR)/ $(TARGET)
	@echo "========================================"


# Specifies which targets aren't blocked by a file's existance
.PHONY: all clean
