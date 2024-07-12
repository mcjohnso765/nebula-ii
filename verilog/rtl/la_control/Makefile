WB_DIRECTORY := $(shell pwd)

#Extract the folder name (e.g. team_1_proj)
WB_DIRECTORY_NAME := $(notdir $(WB_DIRECTORY))

#If the yml does not exist in this directory, this generates it from the team_1_proj.sv file
.PHONY: generate_wb_yaml
generate_wb_yaml:
	@if [ ! -f $(WB_DIRECTORY_NAME).yml ]; then \
		python3 $(BUS_WRAP_ROOT)/scripts/v2yaml.py $(WB_DIRECTORY_NAME).sv $(WB_DIRECTORY_NAME) > $(WB_DIRECTORY_NAME).yml; \
    fi


#This removes the team_1_proj_WB.v file and generates a new one using the yml in this directory
.PHONY: generate_wb_wrapper
generate_wb_wrapper:
	@if [ ! -f $(WB_DIRECTORY_NAME)_WB.v ]; then \
        python3 $(BUS_WRAP_ROOT)/scripts/bus_wrap.py $(WB_DIRECTORY_NAME).yml -wb > $(WB_DIRECTORY_NAME)_WB.v; \
    fi
	