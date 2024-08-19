/* Module Name: tb_keypad_fsm
 * Description: Test bench for keypad_fsm module
 */

`timescale 1 ms / 100us

module tb_keypad();

    // Test bench parameters
    localparam CLK_PERIOD = 10; // 100 Hz clock
    logic tb_checking_outputs;
    integer tb_test_num;
    string tb_test_case;

    // DUT ports
    logic tb_clk, tb_nRst_i;
    logic [3:0] tb_read_row_i;
    logic tb_ready_o, tb_game_end_o, tb_toggle_state_o;
    logic [7:0] tb_data_o;

    // Reset DUT Task
    task reset_dut;
        @(negedge tb_clk);
        tb_nRst_i = 1'b0; // Activate reset
        tb_read_row_i = 4'd0;

        @(negedge tb_clk);
        @(negedge tb_clk);
        tb_nRst_i = 1'b1; // Deactivate reset

        @(posedge tb_clk);
    endtask

    // Task to check current data
    task check_data_o;
    input logic [7:0] exp_data_o;
    begin
        @(negedge tb_clk);
        tb_checking_outputs = 1'b1;
        if (tb_data_o == exp_data_o)
            $info("Correct Data: %b", exp_data_o);
        else
            $error("Incorrect data. Expected: %b. Actual: %b", exp_data_o, tb_data_o);
       
        #(1);
        tb_checking_outputs = 1'b0;
    end
    endtask

    // Task to check ready signal
    task check_ready_o;
    input logic exp_ready_o;
    begin
        //@(negedge tb_clk);
        tb_checking_outputs = 1'b1;
        if (tb_ready_o == exp_ready_o)
            $info("Correct: %d", exp_ready_o);
        else
            $error("Incorrect. Expected: %d. Actual: %d", exp_ready_o, tb_ready_o);
        #(1);
        tb_checking_outputs = 1'b0;
    end
    endtask

    // Task to check game end signal
    task check_game_end_o;
    input logic exp_game_end_o;
    begin
        //@(negedge tb_clk);
        tb_checking_outputs = 1'b1;
        if (tb_game_end_o == exp_game_end_o)
            $info("Correct: %d", exp_game_end_o);
        else
            $error("Incorrect. Expected: %d. Actual: %d", exp_game_end_o, tb_game_end_o);
        #(1);
        tb_checking_outputs = 1'b0;
    end
    endtask
    
    task check_toggle_state_o;
    input logic exp_toggle_state_o;
    begin
        tb_checking_outputs = 1'b1;
        if (tb_toggle_state_o == exp_toggle_state_o)
            $info("Correct: %d", exp_toggle_state_o);
        else
            $error("Incorrect. Expected: %d. Actual: %d", exp_toggle_state_o, tb_toggle_state_o);
        #(1);
    end
    endtask

    // Clock generation block
    always begin
        tb_clk = 1'b0;
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1;
        #(CLK_PERIOD / 2.0);
    end

    // DUT Port Map
    keypad_controller_fsm_int_top DUT (.clk (tb_clk),
                                        .nRst (tb_nRst_i),
                                        .read_row (tb_read_row_i),
                                        .ready (tb_ready_o),
                                        .game_end (tb_game_end_o),
                                        .toggle_state (tb_toggle_state_o),
                                        .data (tb_data_o));

    // Main Test Bench Processes
    initial begin
        // Signal dump
        $dumpfile("dump.vcd");
        $dumpvars;

        // Initialize test bench signals
        tb_nRst_i = 1'b1;
        tb_read_row_i = 4'd0;
        tb_checking_outputs = 1'b0;
        tb_test_num = -1;
        tb_test_case = "Initializing";

        // Wait some time before starting first test case
        #(0.1);

        // **************************************
        // Test Case 0: Power-on-Reset of the DUT
        // **************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 0: Power-on-Reset of the DUT";
        $display("\n\n%s", tb_test_case);

        @(negedge tb_clk);
        tb_read_row_i = 4'b1000; // R0 C1 -> 'A'
        
        @(negedge tb_clk);
        tb_nRst_i = 1'b0; // Activate reset

        // Wait for a bit before checking for correct functionality
        #(2);
        // All columns are inactive, so no key press is registered
        @(negedge tb_clk);
        check_data_o(8'd0);
        check_ready_o(1'b0);
        check_game_end_o(1'b0);
        // TODO add toggle_state check?

        // Check that the reset value is maintained during a clock cycle
        @(negedge tb_clk);
        check_data_o(8'd0);
        check_ready_o(1'b0);
        check_game_end_o(1'b0);      

        // Release the reset away from a clock edge
        @(negedge tb_clk);
        tb_nRst_i = 1'b1; // Deactivate reset

        // Check that internal state was correctly kept after reset release
        @(negedge tb_clk);
        check_data_o(8'd0);
        check_ready_o(1'b0);
        check_game_end_o(1'b0);

        // ********************************************************
        // Test Case 1: Toggle through 3-letter set and wrap around
        // ********************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 1: Toggle through 3-letter set and wrap around";
        $display("\n\n%s", tb_test_case);

        @(negedge tb_clk);
        reset_dut;

        // Letter set 2 (DEF), state S0 (1x)
        repeat (3) @(negedge tb_clk);
        tb_read_row_i = 4'b1000; // {4'b1000, 4'b0010} - R0 C2 -> 'D'

        // Check outputs
        repeat (2) @(negedge tb_clk);
        check_data_o(8'd68);

        // Let go of key to stop hold
        @(negedge tb_clk);
        tb_read_row_i = 4'd0;

        repeat (4) @(negedge tb_clk);
        tb_read_row_i = 4'b1000; // E

        repeat (2) @(negedge tb_clk);
        check_data_o(8'd69);

        @(negedge tb_clk);
        tb_read_row_i = 4'd0;

        repeat (4) @(negedge tb_clk);
        tb_read_row_i = 4'b1000; // F

        repeat (2) @(negedge tb_clk);
        check_data_o(8'd70);

        @(negedge tb_clk);
        tb_read_row_i = 4'd0;

        repeat (4) @(negedge tb_clk);
        tb_read_row_i = 4'b1000; // D

        repeat (2) @(negedge tb_clk);
        check_data_o(8'd68);

        // **********************
        // Test Case 2: Clear key
        // **********************
        tb_test_num += 1;
        tb_test_case = "Test Case 2: Clear key";
        $display("\n\n%s", tb_test_case);

        @(negedge tb_clk);
        reset_dut;

        @(negedge tb_clk); // R1 C0 (key_4)
        tb_read_row_i = 4'b0100;

        repeat (2) @(negedge tb_clk);
        check_data_o(8'd71); // G

        @(negedge tb_clk);
        tb_read_row_i = 4'd0;

        @(negedge tb_clk); // R3 C0 (clear_key)
        tb_read_row_i = 4'b0001;

        repeat (2) @(negedge tb_clk);
        check_data_o(8'd0); // Cleared

        // ************************************************************
        // Test Case 3: Non-default letter of set, change sets, go back
        // ************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 3: Non-default letter of set, change sets, go back";
        $display("\n\n%s", tb_test_case);

        @(negedge tb_clk);
        reset_dut;

        @(negedge tb_clk); // R1 C0 (key_4)
        tb_read_row_i = 4'b0100;

        repeat (2) @(negedge tb_clk); // Check data (G)
        check_data_o(8'd71);

        @(negedge tb_clk); // Release
        tb_read_row_i = 4'd0;

        repeat (4) @(negedge tb_clk); // R1 C0 (key_4)
        tb_read_row_i = 4'b0100;

        repeat (2) @(negedge tb_clk); // Check data (H)
        check_data_o(8'd72);

        @(negedge tb_clk); // Release
        tb_read_row_i = 4'd0;

        @(negedge tb_clk); // R0 C1 (key_2)
        tb_read_row_i = 4'b1000;

        repeat (2) @(negedge tb_clk); // Check data (A)
        check_data_o(8'd65);

        @(negedge tb_clk); // Release
        tb_read_row_i = 4'd0;

        repeat (3) @(negedge tb_clk); // R1 C0 (key_4)
        tb_read_row_i = 4'b0100;

        repeat (2) @(negedge tb_clk); // Check data (G)
        check_data_o(8'd71);

        // **********************************************
        // Test Case 4: Invalid key (no impact on letter)
        // **********************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 4: Invalid key (no impact on letter)";
        $display("\n\n%s", tb_test_case);

        @(negedge tb_clk);
        reset_dut;

        repeat (2) @(negedge tb_clk); // R1 C1 (key_5)
        tb_read_row_i = 4'b0100;

        repeat (2) @(negedge tb_clk);
        check_data_o(8'd74); // J

        @(negedge tb_clk);
        tb_read_row_i = 4'd0;

        repeat (2) @(negedge tb_clk); // R0 C0 (key_1, invalid_key)
        tb_read_row_i = 4'b1000;

        repeat (2) @(negedge tb_clk);
        check_data_o(8'd74); // No impact on letter (J)

        // *****************************************
        // Test Case 5: Submit letter (ready signal)
        // *****************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 5: Submit letter (ready signal)";
        $display("\n\n%s", tb_test_case);

        @(negedge tb_clk);
        tb_read_row_i = 4'd0;

        @(posedge tb_clk);
        #(0.5); // R3 C0 (submit_letter_key)
        tb_read_row_i = 4'b0001;

        @(posedge tb_clk);
        #(0.5);
        check_data_o(8'd74); // J, from previous test case (not reset)
        check_ready_o(1'b1);

        @(posedge tb_clk); // State should change to INIT at next positive clock edge
        #(0.5);
        check_data_o(8'd0); // Letter is reset
        check_ready_o(1'b0);

        // *****************************************************
        // Test Case 6: Game end key (data clear, game end high)
        // *****************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 6: Game end key (data clear, game end high)";
        $display("\n\n%s", tb_test_case);

        @(negedge tb_clk);
        reset_dut;

        repeat (3) @(negedge tb_clk); // R1 C2
        tb_read_row_i = 4'b0100;

        repeat (2) @(negedge tb_clk);
        check_data_o(8'd77); // M

        @(negedge tb_clk);
        tb_read_row_i = 4'd0;

        @(posedge tb_clk);
        #(0.5); // R2 C3 (game_end_key)
        tb_read_row_i = 4'b0010;

        //@(posedge tb_clk);
        //#(0.5);
        
        repeat (3) @(negedge tb_clk);
        check_game_end_o(1'b1);
        check_data_o(8'd0); // Letter is reset

        // ********************************************************
        // Test Case 7: Toggle through 4-letter set and wrap around
        // ********************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 7: Toggle through 4-letter set and wrap around";
        $display("\n\n%s", tb_test_case);

        @(negedge tb_clk);
        reset_dut;
        
        @(negedge tb_clk); // R2 C0
        tb_read_row_i = 4'b0010;

        repeat (2) @(negedge tb_clk);
        check_data_o(8'd80);

        @(negedge tb_clk); // Release
        tb_read_row_i = 4'd0;

        repeat (4) @(negedge tb_clk); // R2 C0
        tb_read_row_i = 4'b0010;

        repeat (2) @(negedge tb_clk);
        check_data_o(8'd81);

        @(negedge tb_clk); // Release
        tb_read_row_i = 4'd0;

        repeat (4) @(negedge tb_clk); // R2 C0
        tb_read_row_i = 4'b0010;

        repeat (2) @(negedge tb_clk);
        check_data_o(8'd82);

        @(negedge tb_clk); // Release
        tb_read_row_i = 4'd0;

        repeat (4) @(negedge tb_clk); // R2 C0
        tb_read_row_i = 4'b0010;

        repeat (2) @(negedge tb_clk);
        check_data_o(8'd83);

        @(negedge tb_clk);
        tb_read_row_i = 4'd0;

        repeat (4) @(negedge tb_clk); // R2 C0
        tb_read_row_i = 4'b0010;

        repeat (2) @(negedge tb_clk);
        check_data_o(8'd80);

        // ********************************************************
        // Test Case 8: Submit word (data clear, toggle state high)
        // ********************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 8: Submit word (data clear, toggle state high)";
        $display("\n\n%s", tb_test_case);

        @(negedge tb_clk); // Release (C0)
        tb_read_row_i = 4'd0;

        repeat (2) @(negedge tb_clk); // R3 C2 (submit_word_key)
        tb_read_row_i = 4'b0001;

        repeat (2) @(negedge tb_clk);
        check_toggle_state_o(1'b1);
        check_data_o(8'd0);

    $finish;
    end
endmodule
