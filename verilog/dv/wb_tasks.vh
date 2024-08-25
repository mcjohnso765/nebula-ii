/*
	Copyright (C) 2020 AUCOHL
    
    Author: Mohamed Shalan (mshalan@aucegypt.edu)
	
	Licensed under the Apache License, Version 2.0 (the "License"); 
	you may not use this file except in compliance with the License. 
	You may obtain a copy of the License at:

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software 
	distributed under the License is distributed on an "AS IS" BASIS, 
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
	See the License for the specific language governing permissions and 
	limitations under the License.
*/

task WB_W_WRITE(input [31:0] addr, input [31:0] data);
    begin : task_body
        @(posedge clk_i);
        #1;
        cyc_i   = 1;
        stb_i   = 1;
        we_i    = 1;
        adr_i   = addr;
        dat_i   = data;
        sel_i   = 4'hF;
        wait (ack_o == 1);
        @(posedge clk_i);
        cyc_i   = 0;
        stb_i   = 0;
    end
endtask

task WB_W_READ(input [31:0] addr, output [31:0] data);
    begin : task_body
        @(posedge clk_i);
        #1;
        cyc_i   = 1;
        stb_i   = 1;
        we_i    = 0;
        adr_i   = addr;
        dat_i   = 0;
        sel_i   = 4'hF;
        wait (ack_o == 1);
        #1;
        data    = dat_o;
        @(posedge clk_i);
        cyc_i   = 0;
        stb_i   = 0;
    end
endtask

// Check Outputs Task
task check_outputs (
    input [33:0] expected_gpio,
    input expected_irq
);
begin
    // NOTE: Make sure you check away from the positive edge!!!
    reg gpio_correct;
    reg done_correct;
    gpio_correct = 1'b0;
    done_correct = 1'b0;
    tb_total_checks += 1;
    tb_sub_checks += 1;

    // Check GPIO
    if(expected_gpio == gpio_out) begin // Check passed
        $info("Correct GPIO output during Test Case #%1d, check #%1d", tb_test_case_num, tb_sub_checks);
        gpio_correct = 1'b1;
    end
    else begin // Check failed
        $error("Correct GPIO output during Test Case #%1d, check #%1d Expected: 0x%1h, Actual: 0x%1h.", tb_test_case_num, tb_sub_checks,
                expected_gpio, gpio_out);
    end

    // Check done
    if(expected_irq == IRQ) begin // Check passed
        $info("Correct done output during Test Case #%1d, check #%1d", tb_test_case_num, tb_sub_checks);
        done_correct = 1'b1;
    end
    else begin // Check failed
        $error("Correct done output during Test Case #%1d, check #%1d Expected: %1d, Actual: %1d.", tb_test_case_num, tb_sub_checks,
                expected_irq, IRQ);
    end

    // Conditional increment of tb_passed
    if (gpio_correct & done_correct) tb_passed += 1;
end
endtask

// Task to cycle through and check all 34 GPIO pin outputs
task cycle_all_gpio (
    input [13:0] prescaler_value,
    output [33:0] tb_expected_gpio
);
begin
    // Cycle and check until end of sequence (GPIO[0] to GPIO[33] should go high)
    integer i;
    for (i = 0; i <= 34; i++) begin
        // Wait 1 ms (1000 clock periods)
        #(10000 * prescaler_value * 100);

        // Wait one more clock cycle (for first period only)
        if (i == 0) #(100);

        // Define expected value
        if (i == 0) tb_expected_gpio = 34'd1;
        else tb_expected_gpio = tb_expected_gpio << 1;
        if (i == 34) #(100);  // Wait 1 more clock cycle for IRQ

        // Check
        check_outputs(tb_expected_gpio, (i == 34));
    end
end
endtask

// Task that acknowledges interrupt
task ack_irq(input [15:0] ic_offset);
    la_data_in[1] = 1'b1;
    WB_W_WRITE({16'b0, ic_offset}, 32'd1); // acknowledge interrupt
endtask