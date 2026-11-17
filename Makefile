CC := gcc
CFLAGS := -Wall -Wextra -O2 -Iinclude

TARGET := build/prog
GEN_BIN := build/genmul
GEN_SRC := tools/genmul.c
GEN_OUT := src/mul.c include/mul.h

SRCS := $(shell find src -name '*.c')
SRCS := $(sort $(SRCS) src/mul.c)
OBJS := $(patsubst src/%.c,build/%.o,$(SRCS))
DEPS := $(OBJS:.o=.d)

.PHONY: all clean test

all: $(TARGET)

$(TARGET): $(OBJS) | build
	$(CC) $(CFLAGS) $(OBJS) -o $@

build/%.o: src/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

$(GEN_BIN): $(GEN_SRC) | build
	$(CC) $(CFLAGS) $< -o $@

$(GEN_OUT) &: $(GEN_BIN)
	./$(GEN_BIN)

build/mul.o: $(GEN_OUT)

build:
	mkdir -p $@

test: all
	./tests/test.sh

clean:
	rm -rf build

-include $(DEPS)
# Write it
