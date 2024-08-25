# SPDX-FileCopyrightText: 2020 Efabless Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

MAKEFLAGS+=--warn-undefined-variables

export OPENLANE_RUN_TAG = $(shell date '+%y_%m_%d_%H_%M')
OPENLANE_TAG ?= 2023.07.19-1
OPENLANE_IMAGE_NAME ?= efabless/openlane:$(OPENLANE_TAG)
designs = $(shell find * -maxdepth 0 -type d)
current_design = null

ROOTLESS ?= 0
USER_ARGS = -u $$(id -u $$USER):$$(id -g $$USER)
ifeq ($(ROOTLESS), 1)
	USER_ARGS =
endif

# openlane_cmd = \
# 	"flow.tcl \
# 	-design $$(realpath ./$*) \
# 	-save_path $$(realpath ..) \
# 	-save \
# 	-tag $(OPENLANE_RUN_TAG) \
# 	-overwrite \
# 	-ignore_mismatches"
# openlane_cmd_interactive = "flow.tcl -it -file $$(realpath ./$*/interactive.tcl)"

# docker_mounts = \
# 	-v $$(realpath $(PWD)/..):$$(realpath $(PWD)/..) \
# 	-v $(PDK_ROOT):$(PDK_ROOT) \
# 	-v $(CARAVEL_ROOT):$(CARAVEL_ROOT) \
# 	-v $(OPENLANE_ROOT):/openlane

# docker_env = \
# 	-e PDK_ROOT=$(PDK_ROOT) \
# 	-e PDK=$(PDK) \
# 	-e MISMATCHES_OK=1 \
# 	-e CARAVEL_ROOT=$(CARAVEL_ROOT) \
# 	-e OPENLANE_RUN_TAG=$(OPENLANE_RUN_TAG)

# ifneq ($(MCW_ROOT),)
# docker_env += -e MCW_ROOT=$(MCW_ROOT)
# docker_mounts += -v $(MCW_ROOT):$(MCW_ROOT)
# endif

# docker_startup_mode = $(shell test -t 0 && echo "-it" || echo "--rm" )
# docker_run = \
# 	docker run $(docker_startup_mode) \
# 	$(USER_ARGS) \
# 	$(docker_mounts) \
# 	$(docker_env) \

# list:
# 	@echo $(designs)

# .PHONY: $(designs)
# $(designs) : export current_design=$@
# $(designs) : % : ./%/config.json
# ifneq (,$(wildcard ./$(current_design)/interactive.tcl))
# 	$(docker_run) \
# 		$(OPENLANE_IMAGE_NAME) sh -c $(openlane_cmd_interactive)
# else
# 	# $(current_design)
# 	mkdir -p ./$*/runs/$(OPENLANE_RUN_TAG) 
# 	rm -rf ./$*/runs/$*
# 	ln -s $$(realpath ./$*/runs/$(OPENLANE_RUN_TAG)) ./$*/runs/$*
# 	$(docker_run) \
# 		$(OPENLANE_IMAGE_NAME) sh -c $(openlane_cmd)
# endif
# 	@mkdir -p ../signoff/$*/
# 	@cp ./$*/runs/$*/OPENLANE_VERSION ../signoff/$*/
# 	@cp ./$*/runs/$*/PDK_SOURCES ../signoff/$*/
# 	@cp ./$*/runs/$*/reports/*.csv ../signoff/$*/

# .PHONY: openlane
# openlane: check-openlane-env
# 	if [ -d "$(OPENLANE_ROOT)" ]; then\
# 		echo "Deleting exisiting $(OPENLANE_ROOT)" && \
# 		rm -rf $(OPENLANE_ROOT) && sleep 2; \
# 		fi
# 	git clone https://github.com/The-OpenROAD-Project/OpenLane -b $(OPENLANE_TAG) --depth=1 $(OPENLANE_ROOT) && \
# 		cd $(OPENLANE_ROOT) && \
# 		export OPENLANE_IMAGE_NAME=efabless/openlane:$(OPENLANE_TAG) && \
# 		export IMAGE_NAME=efabless/openlane:$(OPENLANE_TAG) && \
# 		$(MAKE) pull-openlane

# .PHONY: check-openlane-env
# check-openlane-env:
# ifeq ($(OPENLANE_ROOT),)
# 	@echo "Please export OPENLANE_ROOT"
# 	@exit 1
# endif




# To avoid erasing the nanoHUB's OL2 installation, I'm removing this from target below.
# You can add it back later when running outside nanoHUB:
#if [ -d "$(OPENLANE2_ROOT)" ]; then\
#		echo "Deleting exisiting $(OPENLANE2_ROOT)" && \
#		rm -rf $(OPENLANE2_ROOT) && sleep 2; \
#	fi

#https://openlane2.readthedocs.io/en/latest/getting_started/common/nix_installation/installation_win.html
.PHONY: openlane2
openlane2: check-openlane2-env
	nix-env -f "<nixpkgs>" -iA cachix
	sudo env PATH="$$PATH" cachix use openlane
	-sudo pkill nix-daemon
	git clone https://github.com/efabless/openlane2/ $(OPENLANE2_ROOT)
	nix-shell --run "openlane --log-level ERROR --condensed --show-progress-bar --smoke-test" --pure $(OPENLANE2_ROOT)/shell.nix 

.PHONY: check-openlane2-env
check-openlane2-env:
ifeq ($(OPENLANE2_ROOT),)
	@echo "Please export OPENLANE2_ROOT"
	@exit 1
endif

# Add quotations to command if not running in nanoHUB
openlane_cmd = \
	"openlane \
	--run-tag $(OPENLANE_RUN_TAG) \
	$*/config.json"
openlane_cmd_interactive = "flow.tcl -it -file $$(realpath ./$*/interactive.tcl)"


list:
	@echo $(designs)

.PHONY: $(designs)
$(designs) : export current_design=$@
$(designs) : % : ./%/config.json
	mkdir -p ./$*/runs/$(OPENLANE_RUN_TAG) 
	rm -rf ./$*/runs/$*
	ln -s $$(realpath ./$*/runs/$(OPENLANE_RUN_TAG)) ./$*/runs/$*
# $(openlane_cmd)
	nix-shell --run $(openlane_cmd) --pure $(OPENLANE2_ROOT)/shell.nix
#If not in nanoHUB, run this instead: nix-shell --run $(openlane_cmd) --pure $(OPENLANE2_ROOT)/shell.nix
#https://github.com/efabless/caravel_user_project_ol2/blob/main/openlane/Makefile
	@mkdir -p $(PROJECT_ROOT)/signoff/$*/
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/final/*.csv $(PROJECT_ROOT)/signoff/$*/
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/final/def/* $(PROJECT_ROOT)/def/$*.def
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/final/sdc/* $(PROJECT_ROOT)/sdc/$*.sdc
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/final/gds/* $(PROJECT_ROOT)/gds/$*.gds
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/final/lef/* $(PROJECT_ROOT)/lef/$*.lef
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/*magic-streamout/*.mag $(PROJECT_ROOT)/mag/$*.mag
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/final/pnl/* $(PROJECT_ROOT)/verilog/gl/$*.v
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/final/spice/* $(PROJECT_ROOT)/spi/lvs/$*.spice
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/final/spef/nom/* $(PROJECT_ROOT)/spef/multicorner/$*.nom.spef
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/final/spef/nom/* $(PROJECT_ROOT)/spef/$*.spef
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/final/spef/min/* $(PROJECT_ROOT)/spef/multicorner/$*.min.spef
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/final/spef/max/* $(PROJECT_ROOT)/spef/multicorner/$*.max.spef
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/final/lib/nom*tt*/* $(PROJECT_ROOT)/lib/$*.lib
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/resolved.json $(PROJECT_ROOT)/signoff/$*/
	@mkdir -p $(PROJECT_ROOT)/signoff/$*/openlane-signoff/timing-reports
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/*magic-drc/reports/* $(PROJECT_ROOT)/signoff/$*/openlane-signoff/
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/*netgen-lvs/reports/lvs.netgen.rpt $(PROJECT_ROOT)/signoff/$*/openlane-signoff/
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/*netgen-lvs/reports/lvs.netgen.rpt $(PROJECT_ROOT)/signoff/$*/openlane-signoff/
	@cp $(PROJECT_ROOT)/openlane/$*/runs/$*/*netgen-lvs/netgen-lvs.log $(PROJECT_ROOT)/signoff/$*/openlane-signoff/
	@cp -r $(PROJECT_ROOT)/openlane/$*/runs/$*/*openroad-stapostpnr/summary.rpt $(PROJECT_ROOT)/signoff/$*/openlane-signoff/timing-reports
#   I had ChatGPT rewrite this last bit to work in more shells, but it seems to work
	@find $(PROJECT_ROOT)/openlane/$*/runs/$*/*openroad-stapostpnr/*/*.rpt -type 'f' -print0 | \
	xargs -0 -I {} sh -c '\
		file="{}"; \
		target_dir=$(PROJECT_ROOT)/signoff/$*/openlane-signoff/timing-reports/$$(basename $$(dirname $$file)); \
		mkdir -p $$target_dir; \
		cp $$file $$target_dir/;'

	@find $(PROJECT_ROOT)/openlane/$*/runs/$*/final/sdf -type 'f' -print0 | \
	xargs -0 -I {} sh -c '\
		file="{}"; \
		target_dir=$(PROJECT_ROOT)/signoff/$*/sdf/$$(basename $$(dirname $$file)); \
		mkdir -p $$target_dir; \
		cp $$file $$target_dir/$*.sdf;'