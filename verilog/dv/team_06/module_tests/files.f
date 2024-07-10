# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
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
# SPDX-License-Identifier: Apache-2.0

# Caravel user project includes
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/user_project_wrapper.v
#-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/user_proj_example.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/nebula_ii.v

# Wishbone Bus Wrap includes
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/wb_wrapper.vh
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/dv/tb_macros.vh
#-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/dv/wb_tasks.vh

# Wishbone Interconnect  
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/wishbone_interconnect/wishbone_arbitrator.sv
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/wishbone_interconnect/wishbone_decoder.sv

# Wishbone Manager Control
#-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/wishbone_manager/wishbone_manager.sv

# GPIO Control
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/gpio_control/gpio_control_WB.sv
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/gpio_control/gpio_control_Wrapper.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/gpio_control/gpio_control.sv
 
# LA Control
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/la_control/la_control_WB.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/la_control/la_control_Wrapper.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/la_control/la_control.sv

# Sample Team project
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/BorderGen.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/Body_Control.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/DirectionLogic.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/SyncEdge.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/apple_check_wall_mode.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/apple_gen_all.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/apple_luck_selector.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/apple_wrapper.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/assembly.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/body_wrapper.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/clock.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/collisionDetector.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/collisionLogic.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/collisionLogic_wall.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/gameMode.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/gameState.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/game_speed_selector.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/lcd1602.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/main_file.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/rand_wall_mode.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/random_num_gen.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/random_num_gen_wall_mode.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/two_apple_mode.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/wall-wrapper.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/fsm.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/sound.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/image_generator.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/clk_enable.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/counter.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/sync.v  
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/edgeDetect.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/fsm_control.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/frame_tracker.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/pixel_updater.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/display_wrapper.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/display.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/update_controller.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/command_lut2.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/synchronizer.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/edge_detect.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/rtl/team_projects/team_06/converted_submodules/clk_div.v
    

# SRAM
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/../ip/EF_SRAM_1024x32/hdl/SRAM_1024x32.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/../ip/EF_SRAM_1024x32/hdl/ram_controller.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/../ip/EF_SRAM_1024x32/hdl/EF_SRAM_1024x32_wrapper.v
-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/../ip/EF_SRAM_1024x32/hdl/beh_models/EF_SRAM_1024x32.tt_180V_25C.v
#-v /home/shay/a/tsiverts/nebula-ii-team-06/verilog/../ip/EF_SRAM_1024x32/hdl/EF_SRAM_1024x32_wrapper_LVS.v
