/*
* This is a template for your top level test bench!
* You are responsible for having a test bench for your top
* level design. Otherwise, your design will not be part
* of the tape-out.
*
* Please also include test benches for your team_01_WB
* and team_01_Wrapper modules, if needed to verify
* interfacing with the Wishbone Bus.
*
* The command to run this test bench is:
* make tbsim-source-team_01-team_01
*/

`timescale 1 ns / 1 ps

module team_01_tb();

    ///////////////////////////////////
    // Write your test bench code here!
    ///////////////////////////////////
// Testbench parameters
    localparam CLK_PERIOD = 100; // 10 MHz clk
    
    logic tb_checking_outputs; 
    logic [7:0] tb_test_num;
    string tb_test_case;

    // DUT ports
   
    //inputs
    logic [31:0] tb_cpu_data_o; 
    logic [3:0]  tb_rows;
    logic tb_clk, tb_reset, tb_busy_o;

    //outputs
    logic tb_lcd_en, tb_lcd_rw, tb_lcd_rs, tb_write_i, tb_read_i;
    logic [3:0] tb_cols, tb_sel_i;
    logic [7:0] tb_lcd_data;
    logic [31:0] tb_cpu_data_i, tb_adr_i;
    
    //Clock Generation
    always begin
        tb_clk = 0;
        #(CLK_PERIOD / 2);
        tb_clk = 1;
        #(CLK_PERIOD / 2);
    end

    //instruction tasks
    task addi_test;
        tb_cpu_data_o = 32'h00100093; // addi x1 , x0,  1
    endtask

    task addi_or_test;
        tb_cpu_data_o = 32'h00100113; // addi x2, x0, 1
    endtask

    task or_test;
        tb_cpu_data_o = 32'h001160b3; // or x3, x1, x2
    endtask
    
    task lui_test;
        tb_cpu_data_o = 32'hfffff0b7; // lui x1, 0xfffff
    endtask

    task slt_test;
        tb_cpu_data_o = 32'h0020a2b3; // slt x5, x1, x2
    endtask

    task beq_test;
        tb_cpu_data_o = 32'h00209463; // beq x1,x2, loop
    endtask

    task jalr_test;
        tb_cpu_data_o = 32'h008000E7; // jalr x1, 8(x0)
    endtask

    task sw_test;
        tb_cpu_data_o = 32'h20102023;
    endtask

    task reset_test;
        tb_reset = 0;
        #CLK_PERIOD;
        @(negedge tb_clk);
        tb_reset = 1;
        @(posedge tb_clk);
    endtask



    // Task to check request unit data leaving
    task checkOutput;
    input logic [31:0] expected_output; 
    input string string_ouptut_name; 
    begin
        tb_checking_outputs = 1'b1; 
        if(tb_cpu_data_i == expected_output)
            $info("Correct output for: %s.", string_ouptut_name);
        else
            $error("Incorrect Output. Expected: %b, Actual: %b", expected_output, tb_cpu_data_i);
        #(1);
        tb_checking_outputs = 1'b0;  
    end
    endtask

    // DUT Portmap
    team_01_cpu DUT(.cpu_dat_o(tb_cpu_data_o),
                .clk(tb_clk),
                .nRST(tb_reset),
                .busy_o(tb_busy_o),
                .rows(tb_rows),
                .cpu_dat_i(tb_cpu_data_i),
                .adr_i(tb_adr_i),
                .sel_i(tb_sel_i),
                .write_i(tb_write_i),
                .read_i(tb_read_i),
                .cols(tb_cols),
                .lcd_en(tb_lcd_en),
                .lcd_rw(tb_lcd_rw),
                .lcd_rs(tb_lcd_rs),
                .lcd_data(tb_lcd_data)
                ); 

    // Main Test Bench Process
    initial begin
        // Signal dump
        $dumpfile("dump.vcd");
        $dumpvars; 

        // Initialize test bench signals

        tb_test_case = "Initializing";

        tb_cpu_data_o = 32'h0;
        tb_clk = 0;
        tb_reset = 1;
        tb_busy_o = 1'b0;
        tb_checking_outputs = 1'b0;
        tb_rows = 4'b0;


        // Wait some time before starting first test case
        #(0.1);

        // ************************************************************************
        // Test Case 0: Reset
        // ************************************************************************
        tb_test_num = 0;
        tb_test_case = "Test Case 0: Reset";
        $display("\n\n%s", tb_test_case);

        reset_test();

        // Wait for a bit before checking for correct functionality
        
        #(CLK_PERIOD); 

        // ************************************************************************
        // Test Case 1: addi 
        // ************************************************************************
        #(CLK_PERIOD);
        tb_test_num += 1;
        tb_test_case = "Test Case 1: addi";
        $display("\n\n%s", tb_test_case);
        
        #(CLK_PERIOD * 3);
        
        // Wait for a bit before checking for correct functionality
        tb_busy_o = 1'b1;
        #(CLK_PERIOD); 
        addi_test();
        tb_busy_o = 1'b0;
        #(CLK_PERIOD * 2);
        tb_cpu_data_o = 32'hBAD1BAD1;

        #(CLK_PERIOD * 2);
        tb_busy_o = 1'b1;
        #(CLK_PERIOD);
        tb_busy_o = 1'b0;
        sw_test();
        #(CLK_PERIOD * 3);

        checkOutput(32'h00000001,"Addi");
    
        // ************************************************************************
        // Test Case 2: or
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 2: or";
        $display("\n\n%s", tb_test_case);

        tb_busy_o = 1'b1;
        #(CLK_PERIOD);
        tb_busy_o = 1'b0;
        addi_or_test();
        #(CLK_PERIOD * 2);
        tb_cpu_data_o = 32'hBAD1BAD1;

        #(CLK_PERIOD * 2);
        tb_busy_o = 1'b1;
        #(CLK_PERIOD);
        tb_busy_o = 1'b0;
        or_test();
        #(CLK_PERIOD * 2);
        tb_cpu_data_o = 32'hBAD1BAD1;

        // Wait for a bit before checking for correct functionality
        #(CLK_PERIOD * 2); 
        tb_busy_o = 1'b1;
        #(CLK_PERIOD);
        sw_test();
        tb_busy_o = 1'b0;
        #(CLK_PERIOD * 4);

        checkOutput(32'h00000001,"Or");

        // ************************************************************************
        // Test Case 3: lui
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 3: lui";
        $display("\n\n%s", tb_test_case);

        #(CLK_PERIOD);
        tb_busy_o = 1'b1;
        #(CLK_PERIOD);
        lui_test();
        tb_busy_o = 1'b0;
        #(CLK_PERIOD * 3);
        tb_cpu_data_o = 32'hBAD1BAD1;

        // Wait for a bit before checking for correct functionality
        #(CLK_PERIOD * 1); 
        tb_busy_o = 1'b1;
        #(CLK_PERIOD);
        sw_test();
        tb_busy_o = 1'b0;
        #(CLK_PERIOD * 5);

        checkOutput(32'hfffff000, "LUI");


        // ************************************************************************
        // Test Case 4: SLT
        // ************************************************************************
        tb_test_num += 1;   
        tb_test_case = "Test Case 4: slt";
        $display("\n\n%s", tb_test_case);

        tb_busy_o = 1'b1;
        #(CLK_PERIOD);
        slt_test();
        tb_busy_o = 1'b0;
        #(CLK_PERIOD * 2);
        tb_cpu_data_o = 32'hBAD1BAD1;

        // Wait for a bit before checking for correct functionality
        #(CLK_PERIOD * 2);
        tb_busy_o = 1'b1;
        #CLK_PERIOD;
        tb_busy_o = 1'b0;
        sw_test();
        #(CLK_PERIOD * 5);

        checkOutput(32'h00000001,"SLT");
            
        // ************************************************************************
        // Test Case 5: beq 
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 5: BEQ";
        $display("\n\n%s", tb_test_case);

        tb_busy_o = 1'b1;
        #CLK_PERIOD;
        beq_test();
        tb_busy_o = 1'b0;
        #(CLK_PERIOD * 2);
        tb_cpu_data_o = 32'hBAD1BAD1;

        // Wait for a bit before checking for correct functionality
        #(CLK_PERIOD * 2); 
        tb_busy_o = 1'b1;
        #CLK_PERIOD;
        tb_busy_o = 1'b0;
        sw_test();
        #(CLK_PERIOD * 5);

        checkOutput(32'h00000001,"BEQ");

        // ************************************************************************
        // Test Case 6: jalr 
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 6: JALR";
        $display("\n\n%s", tb_test_case);

        tb_busy_o = 1'b1;
        #(CLK_PERIOD);
        tb_busy_o = 1'b0;
        jalr_test();
        #(CLK_PERIOD * 2);
        tb_cpu_data_o = 32'hBAD1BAD1;

        #(CLK_PERIOD * 2);
        tb_busy_o = 1'b1;
        #CLK_PERIOD;
        tb_busy_o = 1'b0;
        sw_test();
        #(CLK_PERIOD * 5);

        checkOutput(32'h0000001C,"JALR");
        $finish; 
    end
endmodule