ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
TEST_DIR := $(ROOT_DIR)/.tests

export XDG_CONFIG_HOME := $(TEST_DIR)/config
export XDG_DATA_HOME := $(TEST_DIR)/data
export XDG_STATE_HOME := $(TEST_DIR)/state
export XDG_CACHE_HOME := $(TEST_DIR)/cache

XDG_DIRS := $(XDG_CONFIG_HOME) $(XDG_DATA_HOME) $(XDG_STATE_HOME) $(XDG_CACHE_HOME)

NVIM_FLAGS := --headless --noplugin
MINIMAL_INIT := tests/minimal_init.lua
TEST_COMMAND := PlenaryBustedDirectory tests/ { minimal_init = '$(MINIMAL_INIT)' }
DICT_SETUP := lua require('dict').setup()
DICT_COMMAND := Dict hello

.PHONY: test dict xdg-dirs

test: xdg-dirs
	@nvim $(NVIM_FLAGS) -u $(MINIMAL_INIT) -c "$(TEST_COMMAND)"

dict: xdg-dirs
	@nvim $(NVIM_FLAGS) -u $(MINIMAL_INIT) \
		-c "$(DICT_SETUP)" \
		-c "$(DICT_COMMAND)" \
		-c "lua vim.wait(2000)" \
		-c q

xdg-dirs:
	@mkdir -p $(XDG_DIRS)
