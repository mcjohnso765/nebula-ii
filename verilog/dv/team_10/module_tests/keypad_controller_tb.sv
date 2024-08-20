/* Module Name: tb_keypad_controller
 * Description: Test bench for keypad_controller module
 */

`timescale 1 ms / 100us

module keypad_controller_tb ();

    // Test bench parameters
    localparam CLK_PERIOD = 10; // 100 Hz clock
    logic tb_checking_outputs;
    integer tb_test_num;
    string tb_test_case;

    // DUT ports
    logic tb_clk, tb_nRst_i;
    logic [3:0] tb_read_row_i;
    logic [7:0] tb_cur_key_o;
    logic tb_strobe_o;
    logic [3:0] tb_scan_col_o;

    // Reset DUT Task
    task reset_dut;
        @(negedge tb_clk);
        tb_nRst_i = 1'b0;

        @(negedge tb_clk);
        @(negedge tb_clk);
        tb_nRst_i = 1'b1;
        tb_read_row_i = 4'd0;

        @(posedge tb_clk);
    endtask

    // Task to check current key tb_checking_outputs
    task check_key_o;
    input logic [7:0] exp_key_o;
    begin
        tb_checking_outputs = 1'b1;
        if (tb_cur_key_o == exp_key_o)
            $info("Correct Key: %b", exp_key_o); //string_rc_key);
        else
            $error("Incorrect key. Expected: %b. Actual: %b", exp_key_o, tb_cur_key_o); // string_rc_key, tb_string_cur_key);
        #(1);
        tb_checking_outputs = 1'b0;
    end
    endtask

    // Task to check strobe output
    task check_strobe_o;
    input logic exp_strobe_o;
    begin
        tb_checking_outputs = 1'b1;
        if (tb_strobe_o == exp_strobe_o)
            $info("Correct strobe: %d", exp_strobe_o);
        else
            $error("Incorrect strobe. Expected: %d. Actual: %d.", exp_strobe_o, tb_strobe_o);
        #(1);
        tb_checking_outputs = 1'b0;
    end
    endtask

    task check_scan_col_o;
    input logic [3:0] exp_col_o;
    begin
        tb_checking_outputs = 1'b1;
        if (tb_scan_col_o == exp_col_o)
            $info("Correct column: %b", exp_col_o);
        else
            $error("Incorrect column. Expected: %b. Actual: %b.", exp_col_o, tb_scan_col_o);
        #(1);
        tb_checking_outputs = 1'b0;
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
    keypad_controller DUT (.clk (tb_clk),
                           .nRst (tb_nRst_i),
                           .read_row (tb_read_row_i),
                           .cur_key (tb_cur_key_o),
                           .strobe (tb_strobe_o),
                           .scan_col (tb_scan_col_o));

    // Main Test Bench Processes
    initial begin
        // Signal dump
        $dumpfile("dump.vcd");
        $dumpvars;

        // Initialize test bench signals
        tb_read_row_i = 4'd0;
        tb_nRst_i = 1'b1;
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
        tb_read_row_i = 4'b1000; // Press button (e.g., in row 0)
        tb_nRst_i = 1'b0; // Activate reset

        @(negedge tb_clk);
        check_scan_col_o(4'd0);
        check_key_o(8'd0);

        @(posedge tb_clk);
        #(0.1);
        check_strobe_o(1'b0);

        // Check that the reset value is maintained during a clock cycle
        @(negedge tb_clk);
        check_scan_col_o(4'd0);
        check_key_o(8'd0);

        @(posedge tb_clk);
        #(0.1);
        check_strobe_o(1'b0);

        // Release the reset away from a clock edge
        @(negedge tb_clk);
        tb_nRst_i = 1'b1; // Deactivate the chip reset

        // Check that internal state was correctly kept after reset release
        @(negedge tb_clk);
        check_scan_col_o(4'd0);
        check_key_o(8'd0);

        @(posedge tb_clk);
        #(0.1);
        check_strobe_o(1'b1);

        // *********************************************
        // Test Case 1: Check flipping of active columns
        // *********************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 1: Check flipping of active columns";
        $display("\n\n%s", tb_test_case);

        // Pressing the buttons in each row has no effect
        tb_read_row_i = 4'b1111;
        #(0.1);

        // None are initially active
        check_scan_col_o(4'b0000);
        check_key_o(8'd0);

        @(negedge tb_clk);
        tb_read_row_i = 4'd0;

        @(negedge tb_clk);
        check_scan_col_o(4'b1000);
        check_key_o(8'd0);

        @(negedge tb_clk);
        check_scan_col_o(4'b0100);
        check_key_o(8'd0);

        @(negedge tb_clk);
        check_scan_col_o(4'b0010);
        check_key_o(8'd0);

        @(negedge tb_clk);
        check_scan_col_o(4'b0001);
        check_key_o(8'd0);

        @(negedge tb_clk);
        check_scan_col_o(4'b1000);
        check_key_o(8'd0);

        // ******************************************
        // Test Case 2: Verify a few key combinations
        // ******************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 2: Verify a few key combinations";
        $display("\n\n%s", tb_test_case);

        reset_dut;
        @(negedge tb_clk);
        tb_read_row_i = 4'b0010;
        #(1);
        check_key_o(8'b00101000);

        repeat (2) @(posedge tb_clk);
        #(1);
        check_strobe_o(1'b1);

        reset_dut;
        repeat (2) @(negedge tb_clk);
        tb_read_row_i = 4'b0100;
        #(1);
        check_key_o(8'b01000100);

        repeat (2) @(posedge tb_clk);
        #(1);
        check_strobe_o(1'b1);

        reset_dut;
        repeat (3) @(negedge tb_clk);
        tb_read_row_i = 4'b0001;
        #(1);

        check_key_o(8'b00010010);

        repeat (2) @(posedge tb_clk);
        #(1);
        check_strobe_o(1'b1);

        // *************************************************************************
        // Test Case 3: Check that strobe does not persist for multiple clock cycles
        // *************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 3: Check that strobe does not persist for multiple clock cycles";
        $display("\n\n%s", tb_test_case);

        reset_dut;
        
        @(negedge tb_clk);
        tb_read_row_i = 4'b1000;
        check_scan_col_o(4'b1000);
        check_key_o(8'b10001000);

        @(posedge tb_clk);
        @(posedge tb_clk);
        #(1);
        check_strobe_o(1'b1);

        #(CLK_PERIOD * 10);
        @(posedge tb_clk);
        #(1);
        check_strobe_o(1'b0);

        // ******************************************************************************************
        // Test Case 4: Check that active column is held (cur_key stays constant) while row value set
        // ******************************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 4: Check that active column is held (cur_key stays constant) while row value set";
        $display("\n\n%s", tb_test_case);

        // After setting read_row to certain val, cur_key
        // should stay same over mult. clock cycles
        // (hold active column until unpressed)

        @(negedge tb_clk);
        check_scan_col_o(4'b1000);
        check_key_o(8'b10001000);

        @(negedge tb_clk);
        tb_read_row_i = 4'd0;

        @(negedge tb_clk);
        check_scan_col_o(4'b0100);
        check_key_o(8'd0);
    $finish;
    end
endmodule