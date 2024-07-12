TEAM_PROJECT_FOLDER := $(shell pwd)

#Extract the folder name (e.g. team_1_proj)
TEAM_PROJECT_FOLDER_NAME := $(notdir $(TEAM_PROJECT_FOLDER))

#If the yml does not exist in this directory, this generates it from the team_1_proj.sv file
.PHONY: generate_wb_yaml
generate_wb_yaml:
	@if [ ! -f $(TEAM_PROJECT_FOLDER_NAME).yml ]; then \
		python3 $(BUS_WRAP_ROOT)/scripts/v2yaml.py $(TEAM_PROJECT_FOLDER)/$(TEAM_PROJECT_FOLDER_NAME).sv $(TEAM_PROJECT_FOLDER_NAME) > $(TEAM_PROJECT_FOLDER_NAME).yml; \
    fi


#This removes the team_1_proj_WB.v file and generates a new one using the yml in this directory
.PHONY: generate_wb_wrapper
generate_wb_wrapper:
	@if [ ! -f $(TEAM_PROJECT_FOLDER_NAME)_WB.v ]; then \
        python3 $(BUS_WRAP_ROOT)/scripts/bus_wrap.py $(TEAM_PROJECT_FOLDER_NAME).yml -wb > $(TEAM_PROJECT_FOLDER_NAME)_WB.v; \
    fi