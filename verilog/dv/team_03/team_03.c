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
#define reg_team_05_EN (*(volatile uint32_t*)0x30020000)



#define reg_sample_proj_EN (*(volatile uint32_t*)0x30010000)
#define reg_sample_proj_PRESCALER (*(volatile uint32_t*)0x30010004)
#define reg_sample_proj_IM (*(volatile uint32_t*)0x3001FF00)
#define reg_sample_proj_MIS (*(volatile uint32_t*)0x3001FF04)
#define reg_sample_proj_RIS (*(volatile uint32_t*)0x3001FF08)
#define reg_sample_proj_IC (*(volatile uint32_t*)0x3001FF0C)

#define reg_team_03_proj_EN (*(volatile uint32_t*)0x30020000)


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
#define sram_space1 (*(volatile uint32_t*)0x33000004)
#define sram_space2 (*(volatile uint32_t*)0x33000008)
#define sram_space3 (*(volatile uint32_t*)0x3300000C)
#define sram_space4 (*(volatile uint32_t*)0x33000010)
#define sram_space5 (*(volatile uint32_t*)0x33000014)
#define sram_space6 (*(volatile uint32_t*)0x33000018)
#define sram_space7 (*(volatile uint32_t*)0x3300001C)
#define sram_space8 (*(volatile uint32_t*)0x33000020)
#define sram_space9 (*(volatile uint32_t*)0x33000024)


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

	// reg_spi_enable = 1;
	// reg_spimaster_cs = 0x10001;
	// reg_spimaster_control = 0x0801;

	// reg_spimaster_control = 0xa002;	// Enable, prescaler = 2,
                                        // connect to housekeeping SPI

	// Connect the housekeeping SPI to the SPI master
	// so that the CSB line is not left floating.  This allows
	// all of the GPIO pins to be used for user functions.

	reg_spi_enable = 1;
	reg_wb_enable = 1;
	// Configure lower 8-IOs as user output
	// Observe counter value in the testbench
	reg_mprj_io_0 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_1 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_2 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_3 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_4 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_5 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_6 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_7 =  GPIO_MODE_USER_STD_OUTPUT;

	/* Apply configuration */
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1);

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

   
   
/**
 * 00500513
00800613
00a62023
 */
    // *(&sram_space + 0) = 0x00500513;
    // *(&sram_space + 1) = 0x00300593;
    // *(&sram_space + 2) = 0x00100613;
    // *(&sram_space + 3) = 0x00c58863;
    // *(&sram_space + 4) = 0x00a507b3;
    // *(&sram_space + 5) = 0xfff58593;
    // *(&sram_space + 6) = 0xfe000ae3;
    // *(&sram_space + 7) = 0x00f82023;
    // *(&sram_space + 8) = 0x00082883;
    // *(&sram_space + 12) = 0x00008067;

    // 5 * 5 program 
    *(&sram_space + 0) = 0x00500513;
    *(&sram_space + 1) = 0x00800593;
    *(&sram_space + 2) = 0x00a00613;
    *(&sram_space + 3) = 0x00a5d863;
    *(&sram_space + 4) = 0x00b62023;
    *(&sram_space + 5) = 0x00062503;
    *(&sram_space + 6) = 0x0140006f;
    *(&sram_space + 7) = 0x00a62023;
    *(&sram_space + 8) = 0x00062583;
    *(&sram_space + 9) = 0x00062783;
    *(&sram_space + 10) = 0x00b50263;
    *(&sram_space + 11) = 0x00078863;
    *(&sram_space + 12) = 0x00a888b3;
    *(&sram_space + 13) = 0xfff78793;
    *(&sram_space + 14) = 0xfe000ae3;
    *(&sram_space + 15) = 0x01162423;
    *(&sram_space + 16) = 0x00862903;
    *(&sram_space + 17) = 0x00008067;
    

    // sram_space = 0x00500513;
    // *(&sram_space + 1) = 0x00800593;
    // *(&sram_space + 2) = 0x00a00613;
    // *(&sram_space + 3) = 0x00100813;
    // *(&sram_space + 4) = 0x00a5d863;
    // *(&sram_space + 5) = 0x00b62023;
    // *(&sram_space + 6) = 0x00062503;
    // *(&sram_space + 7) = 0x0140006f;
    // *(&sram_space + 8) = 0x00a62023;
    // *(&sram_space + 9) = 0x00062583;
    // *(&sram_space + 10) = 0x00300793;
    // *(&sram_space + 11) = 0x00b50263;
    // *(&sram_space + 12) = 0x01078863;
    // *(&sram_space + 13) = 0x00b508b3;
    // *(&sram_space + 14) = 0xfff78793;
    // *(&sram_space + 15) = 0xfe000ae3;
    // *(&sram_space + 16) = 0x01162423;
    // *(&sram_space + 17) = 0x00862903;
    // *(&sram_space + 18) = 0x00008067;

    //#10000000


// sram_space = 0x00500513; // li x10, 5
// sram_space1 = 0x00800593; // li x11, 8
// sram_space2 = 0x00a00613; // li x12, 10
// sram_space3 = 0x00a5d863; // bgt x11, x10, BRANCH
// sram_space4 = 0x00a62023; // sw x10, 0(x12)
// sram_space5 = 0x00062583; // lw x11, 0(x12)
// sram_space6 = 0x00008067; // ret
// sram_space7 = 0x00b62023; // sw x11, 0(x12)
// sram_space8 = 0x00062503; // lw x10, 0(x12)
// sram_space9 = 0x00008067; // ret


    // sram_space3 = 0x00b54863;
    // sram_space4 = 0x00a62023;
    // sram_space5 = 0x00062583;
    // sram_space6 = 0x00008067;
    // sram_space7 = 0x00b62023;
    // sram_space8 = 0x00062503;
    // sram_space9 = 0x00008067;

    // (*(volatile uint32_t*)0x33000004) = 0x00800593;
    // (*(volatile uint32_t*)0x33000008) = 0x00a00613;
    // (*(volatile uint32_t*)0x3300000C) = 0x00b54863;
    // (*(volatile uint32_t*)0x33000010) = 0x00a62023;
    // (*(volatile uint32_t*)0x33000014) = 0x00062583;
    // (*(volatile uint32_t*)0x33000018) = 0x00008067;
    // (*(volatile uint32_t*)0x3300001C) = 0x00b62023;
    // (*(volatile uint32_t*)0x33000020) = 0x00062503;
    // (*(volatile uint32_t*)0x33000024) = 0x00008067;
    // Do stuff with SRAM
    // sram_space = 0x00500513; // li x10, 5
    // *(&sram_space + 4) = 0x00a5a023; // sw x10, 0(x12)
    // *(&sram_space + 1) = 0x00800593; // li x11, 8
    // *(&sram_space + 2) = 0x00b54863; // beq x10, x11
    // *(&sram_space + 3) = 0x00a62023; // li x12, 2
    // *(&sram_space + 4) = 0x00062583; // ret
    // *(&sram_space + 5) = 0x00008067; // li x12, 5
    // *(&sram_space + 6) = 0x00b62023;
    // *(&sram_space + 7) = 0x00062503; // ret
    // *(&sram_space + 8) = 0x00008067;

    reg_team_03_proj_EN = 0x1; // enabling the design
 //   reg_sample_proj_EN = (*(&sram_space + 1) == 0xABCDEF78);
  //  reg_sample_proj_EN = (*(&sram_space + 3) == 0x12345678);
}

