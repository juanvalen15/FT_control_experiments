DIRS:=$(wildcard os_tile_* app_*)

HEX_FILES:= $(foreach dir, $(DIRS),$(dir)/out.hex)

all: $(HEX_FILES)

clean: $(foreach dir, $(DIRS), clean-$(dir)) 


%/out.hex: % 
	make -C $^

clean-%: %
	make -C $^ clean
