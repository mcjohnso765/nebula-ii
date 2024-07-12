// // /* Original generated C file
// //  * SPDX-FileCopyrightText: 2020 Efabless Corporation
// //  *
// //  * Licensed under the Apache License, Version 2.0 (the "License");
// //  * you may not use this file except in compliance with the License.
// //  * You may obtain a copy of the License at
// //  *
// //  *      http://www.apache.org/licenses/LICENSE-2.0
// //  *
// //  * Unless required by applicable law or agreed to in writing, software
// //  * distributed under the License is distributed on an "AS IS" BASIS,
// //  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// //  * See the License for the specific language governing permissions and
// //  * limitations under the License.
// //  * SPDX-License-Identifier: Apache-2.0
// //  */

// // // This include is relative to $CARAVEL_PATH (see Makefile)
// // #include <defs.h>
// // #include <stub.c>

// // /*
// // 	IO Test:
// // 		- Configures MPRJ lower 8-IO pins as outputs
// // 		- Observes counter value through the MPRJ lower 8 IO pins (in the testbench)
// // */

// // void main()
// // {
// // 	/* 
// // 	IO Control Registers
// // 	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
// // 	| 3-bits | 1-bit | 1-bit | 1-bit  | 1-bit  | 1-bit | 1-bit   | 1-bit   | 1-bit | 1-bit | 1-bit   |

// // 	Output: 0000_0110_0000_1110  (0x1808) = GPIO_MODE_USER_STD_OUTPUT
// // 	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
// // 	| 110    | 0     | 0     | 0      | 0      | 0     | 0       | 1       | 0     | 0     | 0       |
	
	 
// // 	Input: 0000_0001_0000_1111 (0x0402) = GPIO_MODE_USER_STD_INPUT_NOPULL
// // 	| DM     | VTRIP | SLOW  | AN_POL | AN_SEL | AN_EN | MOD_SEL | INP_DIS | HOLDH | OEB_N | MGMT_EN |
// // 	| 001    | 0     | 0     | 0      | 0      | 0     | 0       | 0       | 0     | 1     | 0       |

// // 	*/

// // 	/* Set up the housekeeping SPI to be connected internally so	*/
// // 	/* that external pin changes don't affect it.			*/

// // 	// reg_spi_enable = 1;
// // 	// reg_spimaster_cs = 0x10001;
// // 	// reg_spimaster_control = 0x0801;

// // 	// reg_spimaster_control = 0xa002;	// Enable, prescaler = 2,
// //                                         // connect to housekeeping SPI

// // 	// Connect the housekeeping SPI to the SPI master
// // 	// so that the CSB line is not left floating.  This allows
// // 	// all of the GPIO pins to be used for user functions.

// // 	// Configure lower 8-IOs as user output
// // 	// Observe counter value in the testbench
// // 	reg_mprj_io_0 =  GPIO_MODE_USER_STD_OUTPUT;
// // 	reg_mprj_io_1 =  GPIO_MODE_USER_STD_OUTPUT;
// // 	reg_mprj_io_2 =  GPIO_MODE_USER_STD_OUTPUT;
// // 	reg_mprj_io_3 =  GPIO_MODE_USER_STD_OUTPUT;
// // 	reg_mprj_io_4 =  GPIO_MODE_USER_STD_OUTPUT;
// // 	reg_mprj_io_5 =  GPIO_MODE_USER_STD_OUTPUT;
// // 	reg_mprj_io_6 =  GPIO_MODE_USER_STD_OUTPUT;
// // 	reg_mprj_io_7 =  GPIO_MODE_USER_STD_OUTPUT;

// // 	/* Apply configuration */
// // 	reg_mprj_xfer = 1;
// // 	while (reg_mprj_xfer == 1);
// // }

// //C file copied from WB tb
// /* 
//  * SPDX-FileCopyrightText: 2020 Efabless Corporation
//  *
//  * Licensed under the Apache License, Version 2.0 (the "License");
//  * you may not use this file except in compliance with the License.
//  * You may obtain a copy of the License at
//  *
//  *      http://www.apache.org/licenses/LICENSE-2.0
//  *
//  * Unless required by applicable law or agreed to in writing, software
//  * distributed under the License is distributed on an "AS IS" BASIS,
//  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  * See the License for the specific language governing permissions and
//  * limitations under the License.
//  * SPDX-License-Identifier: Apache-2.0
//  */

// // This include is relative to $CARAVEL_PATH (see Makefile)
// #include <defs.h>
// #include <stub.c>

// // List of Wishbone Slave Addresses
// // Sample Project
// #define reg_sample_proj_EN (*(volatile uint32_t*)0x30010000)
// #define reg_sample_proj_PRESCALER (*(volatile uint32_t*)0x30010004)
// #define reg_sample_proj_IM (*(volatile uint32_t*)0x3001FF00)
// #define reg_sample_proj_MIS (*(volatile uint32_t*)0x3001FF04)
// #define reg_sample_proj_RIS (*(volatile uint32_t*)0x3001FF08)
// #define reg_sample_proj_IC (*(volatile uint32_t*)0x3001FF0C)

// // GPIO Control
// #define reg_gpio_PIN_0TO7 (*(volatile uint32_t*)0x32000000)
// #define reg_gpio_PIN_8TO15 (*(volatile uint32_t*)0x32000004)
// #define reg_gpio_PIN_16TO23 (*(volatile uint32_t*)0x32000008)
// #define reg_gpio_PIN_24TO31 (*(volatile uint32_t*)0x3200000C)
// #define reg_gpio_PIN_32TO37 (*(volatile uint32_t*)0x32000010)

// // LA Control
// #define reg_la_sel (*(volatile uint32_t*)0x31000000)

// // SRAM address space
// #define sram_space (*(volatile uint32_t*)0x33000000)

// // Team 4 Space
// // how its going to look for final integration:
// // #define reg_team_04_EN (*(volatile uint32_t*)0x30040000)

// // for testing purpose
// #define reg_team_04_EN (*(volatile uint32_t*)0x30010000)


// /*
// 	Sample Team Project Test:
// 		- Configures all IO pins as outputs
// 		- Configures all IO and LA pins to be selected by sample project
// 		- Enables sample project design through WB
// 		- Enables design's output cycling through LA inputs
// 		- Checks GPIO outputs consistently
// 		- Stops output cycling through LA inputs
// 		- "Acknowledges" interrupt, and enables cycling again
// */

// void main()
// {

// 	/* Set up the housekeeping SPI to be connected internally so	*/
// 	/* that external pin changes don't affect it.			*/

// 	reg_spi_enable = 1;
//     reg_wb_enable = 1;
// 	// reg_spimaster_cs = 0x10001;
// 	// reg_spimaster_control = 0x0801;

// 	// reg_spimaster_control = 0xa002;	// Enable, prescaler = 2,
//                                         // connect to housekeeping SPI

// 	// Connect the housekeeping SPI to the SPI master
// 	// so that the CSB line is not left floating.  This allows
// 	// all of the GPIO pins to be used for user functions.

// 	// Configure IO[0] and IO[37:5] to outputs
// 	reg_mprj_io_0 =  GPIO_MODE_USER_STD_OUTPUT;
// 	reg_mprj_io_5 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_6 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_7 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_8 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;
//     reg_mprj_io_9 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_10 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_11 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_12 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_13 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_14 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_15 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_16 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_17 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_18 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_19 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_20 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_21 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_22 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_23 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_24 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_25 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_26 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_27 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_28 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_29 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_30 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_31 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_32 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_33 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_34 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_35 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_36 = GPIO_MODE_USER_STD_OUTPUT;
//     reg_mprj_io_37 = GPIO_MODE_USER_STD_OUTPUT;

// 	// Now, apply configuration
// 	reg_mprj_xfer = 1;
// 	while (reg_mprj_xfer == 1);

// 	// Configure All LA probes as inputs to the cpu 
// 	reg_la0_oenb = reg_la0_iena = 0x00000000;    // [31:0]
// 	reg_la1_oenb = reg_la1_iena = 0x00000000;    // [63:32]
// 	reg_la2_oenb = reg_la2_iena = 0x00000000;    // [95:64]
// 	reg_la3_oenb = reg_la3_iena = 0x00000000;    // [127:96]

// 	// Configure GPIOs outputs to be selected by sample project
// 	reg_gpio_PIN_0TO7 = 0x44444444;
// 	reg_gpio_PIN_8TO15 = 0x44444444;
// 	reg_gpio_PIN_16TO23 = 0x44444444;
// 	reg_gpio_PIN_24TO31 = 0x44444444;
// 	reg_gpio_PIN_32TO37 = 0x444444;

//     // Do stuff with SRAM
//     sram_space = 0xFEED0000; // write 0xFEED000 to address 0x33000000
//     *(&sram_space + 1) = 0xABCDEF78;  // write 0xABCDEF78 to address 0x33000004
//     *(&sram_space + 3) = 0x12345678;  // write 0x12345678 to address 0x3300000C
//     reg_sample_proj_EN = (sram_space == 0xFEED0000);
//     reg_sample_proj_EN = (*(&sram_space + 1) == 0xABCDEF78);
//     reg_sample_proj_EN = (*(&sram_space + 3) == 0x12345678);

//     // Write instructions in hex to SRAM
// 	*(&sram_space + 4) = 0x00000000;
// 	*(&sram_space + 5) = 0x00000000;
// 	*(&sram_space + 6) = 0x00000193; //addi x3, x0, 0
// 	*(&sram_space + 7) = 0x00300213; //addi x4, x0, 3
// 	*(&sram_space + 8) = 0x00118193; //addi x3, x3, 1
// 	*(&sram_space + 9) = 0x00418463; //beq x3, x4, 8
// 	*(&sram_space + 10) = 0x00419463; //bne x3, x4, 8
// 	*(&sram_space + 11) = 0x00000000;
// 	*(&sram_space + 12) = 0x0041c463; //blt x3, x4, 8
// 	*(&sram_space + 13) = 0x00000000;
// 	*(&sram_space + 14) = 0x0041d463; //bge x3, x4, 8
// 	*(&sram_space + 15) = 0x0041e463; //bltu x3, x4, 8
// 	*(&sram_space + 16) = 0x00000000;
// 	*(&sram_space + 17) = 0x0041f463; //bgeu x3, x4, 8
// 	*(&sram_space + 18) = 0xfe5ff06f; //jal x0, -28


//     // Enable CPU
//     reg_team_04_EN = 0x1;
// }


// WB_TEST
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
#define reg_sample_proj_EN (*(volatile uint32_t*)0x30010000)
#define reg_sample_proj_PRESCALER (*(volatile uint32_t*)0x30010004)
#define reg_sample_proj_IM (*(volatile uint32_t*)0x3001FF00)
#define reg_sample_proj_MIS (*(volatile uint32_t*)0x3001FF04)
#define reg_sample_proj_RIS (*(volatile uint32_t*)0x3001FF08)
#define reg_sample_proj_IC (*(volatile uint32_t*)0x3001FF0C)

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

// Team 4 Space
#define reg_team_04_EN (*(volatile uint32_t*)0x30040000)
#define reg_team_04_START_ADR (*(volatile uint32_t*)0x30040004)
#define reg_team_04_MEM_SIZE (*(volatile uint32_t*)0x30040008)


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
	reg_mprj_io_0 =  GPIO_MODE_USER_STD_OUTPUT;
	reg_mprj_io_5 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_6 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_7 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_8 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_9 = GPIO_MODE_USER_STD_INPUT_PULLDOWN;
    reg_mprj_io_10 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_11 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_12 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_13 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_14 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_15 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_16 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_17 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_18 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_19 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_20 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_21 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_22 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_23 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_24 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_25 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_26 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_27 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_28 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_29 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_30 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_31 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_32 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_33 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_34 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_35 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_36 = GPIO_MODE_USER_STD_OUTPUT;
    reg_mprj_io_37 = GPIO_MODE_USER_STD_OUTPUT;

	// Now, apply configuration
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1);

	// Configure All LA probes as inputs to the cpu 
	reg_la0_oenb = reg_la0_iena = 0x00000000;    // [31:0]
	reg_la1_oenb = reg_la1_iena = 0x00000000;    // [63:32]
	reg_la2_oenb = reg_la2_iena = 0x00000000;    // [95:64]
	reg_la3_oenb = reg_la3_iena = 0x00000000;    // [127:96]

	// Configure GPIOs outputs to be selected by sample project
    // Change all the 1s to 4s
	reg_gpio_PIN_0TO7 = 0x44444444;
	reg_gpio_PIN_8TO15 = 0x44444444;
	reg_gpio_PIN_16TO23 = 0x44444444;
	reg_gpio_PIN_24TO31 = 0x44444444;
	reg_gpio_PIN_32TO37 = 0x444444;

    // // Do stuff with SRAM
    sram_space = 0xFEED0000; // write 0xFEED000 to address 0x33000000
    // *(&sram_space + 1) = 0xABCDEF78;  // write 0xABCDEF78 to address 0x33000004
    // *(&sram_space + 3) = 0x12345678;  // write 0x12345678 to address 0x3300000C
    // reg_sample_proj_EN = (sram_space == 0xFEED0000);
    // reg_sample_proj_EN = (*(&sram_space + 1) == 0xABCDEF78);
    // reg_sample_proj_EN = (*(&sram_space + 3) == 0x12345678);

    // Write instructions in hex to SRAM
	
	// sw
	// *(&sram_space + 1) = 0x0c502423; //sw x5, 200(x0)
	*(&sram_space + 1) = 0x03300313; //addi x6, x0, 0x33
	*(&sram_space + 2) = 0x01831313; //slli x6, x6, 24
	*(&sram_space + 3) = 0x05400293;  //addi x5, x0, 0x54
	*(&sram_space + 4) = 0x06502223; //sw x5, 100(x0)
	

	*(&sram_space + 5) = 0x0db00293; //addi x5, x0, 219
	*(&sram_space + 6) = 0x00500a13; //addi x20, x0, 5

	*(&sram_space + 7) = 0x02002f83; //lw x31, 32(x0)
	*(&sram_space + 8) = 0x003e7517; //auipc x10, 999
	*(&sram_space + 9) = 0x0feed5b7; //lui x11, 65261

	//*(&sram_space + 21) = 0x0c600623; //sb x6, 204(x0)
	//*(&sram_space + 22) = 0x0c601823; //sh x6, 208(x0)
	// *(&sram_space + 24) = 0x0f000803; //lb x16, 240(x0)
	// *(&sram_space + 25) = 0x0f401883; //lh x17, 244(x0)
	// *(&sram_space + 27) = 0x0f004903; //lbu x18, 240(x0)
	// *(&sram_space + 28) = 0x0fend405903; //lhu x18, 244(x0)
	*(&sram_space + 22) = 0x0000006f; //jal x0, 0
	
	//unsigned int j = 1;
	// Load VGA memory
	// for (int i = 1023; i > 950; i--) {
	// 	if (i % 4 == 0) {
	// 	*(&sram_space + i) = 0x0f0f0f0f;
	// 	} else if (i% 4 == 1) {
	// 	*(&sram_space + i) = 0x55555555;
	// 	} else if (i % 4 == 2) {
	// 	*(&sram_space + i) = 0xFFFFFFFF;
	// 	} else {
	// 	*(&sram_space + i) = 0x12345678;
	// 	}
	// }


	
	// lw
	// *(&sram_space + 1) = 0x06300093;
	// *(&sram_space + 2) = 0x3e700113;
	// *(&sram_space + 3) = 0x001101b3;
	// *(&sram_space + 4) = 0x00209213;
	
	// *(&sram_space + 50) = 0x0000ffff;
	
	// *(&sram_space + 3) = 0x0c802303;

	
	
	
	//addi x4, x0, 3
	//addi x3, x0, 0
	// *(&sram_space + 8) = 0x00118193; //addi x3, x3, 1
	// *(&sram_space + 9) = 0x00418463; //beq x3, x4, 8
	// *(&sram_space + 10) = 0x00419463; //bne x3, x4, 8
	// *(&sram_space + 11) = 0x00000000;
	// *(&sram_space + 12) = 0x0041c463; //blt x3, x4, 8
	// *(&sram_space + 13) = 0x00000000;
	// *(&sram_space + 14) = 0x0041d463; //bge x3, x4, 8
	// *(&sram_space + 15) = 0x0041e463; //bltu x3, x4, 8
	// *(&sram_space + 16) = 0x00000000;
	// *(&sram_space + 17) = 0x0041f463; //bgeu x3, x4, 8
	// *(&sram_space + 18) = 0xfe5ff06f; //jal x0, -28

	// Set memory size
	reg_team_04_MEM_SIZE = 4096;

	// Set start address
	reg_team_04_START_ADR = 0x33000000;

    // Enable CPU
    reg_team_04_EN = 1;
}
