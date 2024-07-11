/*
 * SPDX-FileCopyrightText: 2020 Efabless Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * SPDX-License-Identifier: Apache-2.0
 */

// This include is relative to $CARAVEL_PATH (see Makefile)
#include <defs.h>
#include <stub.c>

#define reg_team_01_EN (*(volatile uint32_t*)0x30010000)
#define reg_team_01_PRESCALER (*(volatile uint32_t*)0x30010004)
#define reg_team_01_IM (*(volatile uint32_t*)0x3001FF00)
#define reg_team_01_MIS (*(volatile uint32_t*)0x3001FF04)
#define reg_team_01_RIS (*(volatile uint32_t*)0x3001FF08)
#define reg_team_01_IC (*(volatile uint32_t*)0x3001FF0C)

// GPIO Control
#define reg_gpio_PIN_0TO7 (*(volatile uint32_t*)0x32000000)
#define reg_gpio_PIN_8TO15 (*(volatile uint32_t*)0x32000004)
#define reg_gpio_PIN_16TO23 (*(volatile uint32_t*)0x32000008)
#define reg_gpio_PIN_24TO31 (*(volatile uint32_t*)0x3200000C)
#define reg_gpio_PIN_32TO37 (*(volatile uint32_t*)0x32000010)

// LA Control
#define reg_la_sel (*(volatile uint32_t*)0x31000000)

// SRAM address space
#define sram_space (*(volatile uint32_t*)0x33000000)

/*
	IO Test:
		- Configures MPRJ lower 8-IO pins as outputs
		- Observes counter value through the MPRJ lower 8 IO pins (in the testbench)
*/

void main()
{
	/* 
	IO Control Registers
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 3-bits | 1-bit | 1-bit | 1-bit  | 1-bit  | 1-bit | 1-bit   | 1-bit   | 1-bit | 1-bit | 1-bit   |

	Output: 0000_0110_0000_1110  (0x1808) = GPIO_MODE_USER_STD_OUTPUT
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 110    | 0     | 0     | 0      | 0      | 0     | 0       | 1       | 0     | 0     | 0       |
	
	 
	Input: 0000_0001_0000_1111 (0x0402) = GPIO_MODE_USER_STD_INPUT_NOPULL
	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
	| 001    | 0     | 0     | 0      | 0      | 0     | 0       | 0       | 0     | 1     | 0       |

	*/

	/* Set up the housekeeping SPI to be connected internally so	*/
	/* that external pin changes don't affect it.			*/

	reg_spi_enable = 1;
    reg_wb_enable = 1;
	// reg_spimaster_cs = 0x10001;
	// reg_spimaster_control = 0x0801;

	// reg_spimaster_control = 0xa002;	// Enable, prescaler = 2,
                                        // connect to housekeeping SPI

	// Connect the housekeeping SPI to the SPI master
	// so that the CSB line is not left floating.  This allows
	// all of the GPIO pins to be used for user functions.

	// Configure lower 8-IOs as user output
	// Observe counter value in the testbench
	reg_mprj_io_5 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_6 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_7 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_8 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_9 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_10 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_11 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_12 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_13 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_14 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_15 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_16 =  GPIO_MODE_USER_STD_INPUT_NOPULL;
	reg_mprj_io_17 =  GPIO_MODE_USER_STD_INPUT_NOPULL;
	reg_mprj_io_18 =  GPIO_MODE_USER_STD_INPUT_NOPULL;
	reg_mprj_io_19 =  GPIO_MODE_USER_STD_INPUT_NOPULL;
	reg_mprj_io_20 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_21 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_22 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_23 =  GPIO_MODE_USER_STD_OUTPUT;

	/* Apply configuration */
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1);

	// Configure All LA probes as inputs to the cpu 
	reg_la0_oenb = reg_la0_iena = 0x00000000;    // [31:0]
	reg_la1_oenb = reg_la1_iena = 0x00000000;    // [63:32]
	reg_la2_oenb = reg_la2_iena = 0x00000000;    // [95:64]
	reg_la3_oenb = reg_la3_iena = 0x00000000;    // [127:96]

	// Configure GPIOs outputs to be selected by sample project
	reg_gpio_PIN_0TO7 = 0x11111111;
	reg_gpio_PIN_8TO15 = 0x11111111;
	reg_gpio_PIN_16TO23 = 0x11111111;
	reg_gpio_PIN_24TO31 = 0x11111111;
	reg_gpio_PIN_32TO37 = 0x111111;

    // Do stuff with SRAM
    sram_space = 0x330001b7;
    *(&sram_space + 1) = 0x03900213;
    *(&sram_space + 2) = 0x4041a023;
    

	//mem map register wrapper file
	//managment core check if 0x30010008
	// = 1


	//wire enable to zero


    // write sram
    // write
    // write
    // write

    // write your design (enable)
    reg_team_01_EN = 1;
    // your design:
    // read from sram
}

