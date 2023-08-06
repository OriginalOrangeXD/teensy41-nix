include $(TEENSY_PATH)/include/flags.mk

CXXFLAGS += -std=gnu++20

LIBS = -lm -lstdc++ -lteensy-core

CPP_FILES := $(wildcard *.cpp)
TARGETS := $(CPP_FILES:.cpp=.hex)

%.elf: %.o
	$(CC) $(LDFLAGS) -o $@ $< $(LIBS)

%.hex: %.elf
	$(SIZE) $<
	$(OBJCOPY) -O ihex -R .eeprom $< $@

all: $(TARGETS)
