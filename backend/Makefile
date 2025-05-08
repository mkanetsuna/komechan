# backend/Makefile
CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -Isrc
LDFLAGS =
TARGET_DIR = bin
TARGET = $(TARGET_DIR)/backend_server
SRC_DIRS = src src/infrastructure/web src/interfaces/controllers src/utils
SOURCES = $(wildcard $(addsuffix /*.c, $(SRC_DIRS)))
OBJECTS = $(SOURCES:.c=.o)

# Default target
all: $(TARGET)

# Linking
$(TARGET): $(OBJECTS)
	@mkdir -p $(TARGET_DIR)
	$(CC) $(OBJECTS) -o $@ $(LDFLAGS)
	@echo "Build successful! Executable: $(TARGET)"

# Compilation
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Clean
clean:
	rm -f $(OBJECTS) $(TARGET)
	@echo "Cleaned build files."

# Run (simple run, assumes server listens on 8080)
run: all
	@echo "Starting server..."
	./$(TARGET)

.PHONY: all clean run