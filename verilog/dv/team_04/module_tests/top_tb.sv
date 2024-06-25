// typedef enum logic [3:0] {
//     ADD=0, SUB=1, SLL=2, SLT=3, SLTU=4, XOR=5, SRL=6, SRA=7,OR=8, AND=9,
//     BEQ=10, BNE=11, BLT=12, BGE=13, BLTU=14, BGEU=15, ERR = 4'bxxxx
//     } operation_t;


`timescale 1ms/1ns
module tb_top ();
    
    logic tb_clk, nrst;
    localparam CLK_PERIOD = 10; // 100 Hz clk


    logic [31:0] instruction; //instruction to CPU
    logic [31:0] alu_result;  //numerical/logical output of ALU
    logic zero_flag, //ALU flag whenever output == 0
        eq_flag, //ALU branch flag used for beq, bge, and bgeu
        less_flag, //ALU flag used for blt, bltu
        err_flag; //ALU flag invalid operation, from ALU

    top CPU(.instruction(instruction), .zero_flag(zero_flag), .alu_result(alu_result), .eq_flag(eq_flag), .less_flag(less_flag), .err_flag(err_flag), .clk(tb_clk), .nrst(nrst));


    // Clock generation block
    always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end


    // Reset DUT Task
    task reset_dut;
        @(negedge tb_clk);
        nrst = 1'b0; 
        @(negedge tb_clk);
        @(negedge tb_clk);
        nrst = 1'b1;
        @(posedge tb_clk);
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars; 

        //initialize
        reset_dut;

        //load 5 into x1
        instruction = 32'b00000000010100001000000010010011; //addi x1, x1, 5

        #(CLK_PERIOD * 2.0);
        
        $display("ALU Result: %b", alu_result);

        ////////////////////////////////////////////////////
        ////////////////////////////////////////////////////
        ////////////////////////////////////////////////////
        
        //load 5 into x2
        instruction = 32'b00000000010100010000000100010011; // addi x2, x2, 5

        #(CLK_PERIOD * 2.0);

        $display("ALU Result: %b", alu_result);

        ////////////////////////////////////////////////////
        ////////////////////////////////////////////////////
        ////////////////////////////////////////////////////

        //add x1 & x2
        instruction = 32'b00000000001000001000000110110011; //add x3, x1, x2

        #(CLK_PERIOD * 2.0);

        $display("ALU Result: %b", alu_result);

    end
    
endmodule

