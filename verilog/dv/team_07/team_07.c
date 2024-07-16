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

// List of Wishbone Slave Addresses
// Sample Project
#define reg_team_07_EN (*(volatile uint32_t*)0x30070000)

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
	Sample Team Project Test:
		- Configures all IO pins as outputs
		- Configures all IO and LA pins to be selected by sample project
		- Enables sample project design through WB
		- Enables design's output cycling through LA inputs
		- Checks GPIO outputs consistently
		- Stops output cycling through LA inputs
		- "Acknowledges" interrupt, and enables cycling again
*/

void main()
{

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

	// Configure IO[0] and IO[37:5] to outputs
	// reg_mprj_io_0 =  GPIO_MODE_USER_STD_OUTPUT;
	// reg_mprj_io_5 = GPIO_MODE_USER_STD_OUTPUT;
    // reg_mprj_io_6 = GPIO_MODE_USER_STD_OUTPUT;
    // reg_mprj_io_7 = GPIO_MODE_USER_STD_OUTPUT;
    // reg_mprj_io_8 = GPIO_MODE_USER_STD_OUTPUT;
    // reg_mprj_io_9 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_10 = GPIO_MODE_USER_STD_OUTPUT;  // output, ssdec_sdi
    reg_mprj_io_11 = GPIO_MODE_USER_STD_OUTPUT;  // output, ssdec_ss
    reg_mprj_io_12 = GPIO_MODE_USER_STD_OUTPUT;  // output, ssdec_sck
    reg_mprj_io_13 = GPIO_MODE_USER_STD_OUTPUT;	 // output, tft_sck
    reg_mprj_io_14 = GPIO_MODE_USER_STD_OUTPUT;  // output, tft_sdi
    reg_mprj_io_15 = GPIO_MODE_USER_STD_OUTPUT;  // output, tft_dc
    reg_mprj_io_16 = GPIO_MODE_USER_STD_OUTPUT;  // output, tft_rst
    reg_mprj_io_17 = GPIO_MODE_USER_STD_OUTPUT;  // output, tft_cs
    reg_mprj_io_18 = GPIO_MODE_USER_STD_OUTPUT;  // output, tft_state[0]
    reg_mprj_io_19 = GPIO_MODE_USER_STD_OUTPUT;  // output, tft_state[1]
    reg_mprj_io_20 = GPIO_MODE_USER_STD_OUTPUT;  // output, tft_state[2]
    reg_mprj_io_21 = GPIO_MODE_USER_STD_OUTPUT;	 // output, audio
    reg_mprj_io_22 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;	 // input, button[0]
    reg_mprj_io_23 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;	 // input, button[1]
    reg_mprj_io_24 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;	 // input, button[2]
    reg_mprj_io_25 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;	 // input, button[3]
    reg_mprj_io_26 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;	 // input, button[4]
    reg_mprj_io_27 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;	 // input, button[5]
    // reg_mprj_io_28 = GPIO_MODE_USER_STD_OUTPUT;
    // reg_mprj_io_29 = GPIO_MODE_USER_STD_OUTPUT;
    // reg_mprj_io_30 = GPIO_MODE_USER_STD_OUTPUT;
    // reg_mprj_io_31 = GPIO_MODE_USER_STD_OUTPUT;
    // reg_mprj_io_32 = GPIO_MODE_USER_STD_OUTPUT;
    // reg_mprj_io_33 = GPIO_MODE_USER_STD_OUTPUT;
    // reg_mprj_io_34 = GPIO_MODE_USER_STD_OUTPUT;
    // reg_mprj_io_35 = GPIO_MODE_USER_STD_OUTPUT;
    // reg_mprj_io_36 = GPIO_MODE_USER_STD_OUTPUT;
    // reg_mprj_io_37 = GPIO_MODE_USER_STD_OUTPUT;

	// Now, apply configuration
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1);

	// Configure All LA probes as inputs to the cpu 
	reg_la0_oenb = reg_la0_iena = 0x00000000;    // [31:0]
	reg_la1_oenb = reg_la1_iena = 0x00000000;    // [63:32]
	reg_la2_oenb = reg_la2_iena = 0x00000000;    // [95:64]
	reg_la3_oenb = reg_la3_iena = 0x00000000;    // [127:96]

	// Configure GPIOs outputs to be selected by sample project
	reg_gpio_PIN_0TO7 = 0x77777777;
	reg_gpio_PIN_8TO15 = 0x77777777;
	reg_gpio_PIN_16TO23 = 0x77777777;
	reg_gpio_PIN_24TO31 = 0x77777777;
	reg_gpio_PIN_32TO37 = 0x777777;

	// Enable your design
	reg_team_07_EN = 1;
}
