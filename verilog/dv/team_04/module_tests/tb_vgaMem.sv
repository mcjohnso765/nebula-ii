
`timescale 1ms/1ns
module tb_vgaMem();


    // testbench parameters
    integer tb_test_num;
    string tb_test_case;
    localparam CLK_PERIOD = 10; // 100 Hz clk


    // DUT ports
   logic [31:0]  tb_addr_to_mem, // read and write addr
                  tb_data_to_mem, // 
		  tb_data_from_mem; //
    logic tb_MemWrite;
    logic tb_clk, tb_nrst;

    logic [31:0] exp_addr_to_mem,
		             exp_data_to_mem,
                 exp_data_from_mem;
    logic exp_MemWrite;

 //DUT portmap 
vgaMem mem0 (.clk(tb_clk),
		     .nRst(tb_nrst), 
		     .write_enable(tb_MemWrite), //control signal enabling writing
		     .write_address(tb_addr_to_mem), 
		     .write_data(tb_data_to_mem), 
		     .read_address(tb_addr_to_mem), //address and values to be written
		     .read_data(tb_data_from_mem));

   // Clock generation block
    always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end


//main test bench process
    initial begin
	//signal dump
        $dumpfile("dump.vcd");
	    $dumpvars(0, tb_vgaMem); 

        //initializing 
        tb_addr_to_mem =32'b0;
        tb_data_to_mem = 32'b0; 
        tb_MemWrite = 1'b0; 

        //Hard coded reset -waiting 400 clk cycles for mem to load
        @(negedge tb_clk);
        tb_nrst = 1'b0; 
        #(CLK_PERIOD * 400.0);       
        tb_nrst = 1'b1;
        @(posedge tb_clk);

	    
        tb_test_num = 0;
        tb_test_case = "Initializing";
      
	// ************************************************************************
        // Test Case 1: testing for memwrite
        // ************************************************************************

        tb_addr_to_mem = 32'h32a;
        tb_data_to_mem = 32'h8;
        tb_MemWrite = 1'b1;
        #(CLK_PERIOD * 2.0);  
        exp_data_from_mem =32'h8;

      
    if(tb_data_from_mem === exp_data_from_mem) //triple equalto symbol
        $info("Correct data from mem: %s.", "MEMWRITE");
    else
        $error("Incorrect data from mem: %s. Expected: %h. Actual: %h.", "MEMWRITE", exp_data_from_mem, tb_data_from_mem); 
        
      
    $finish;
    end
endmodule


module vgaMem (
    input logic clk,
    nRst, 
    write_enable, //control signal enabling writing
    input logic [31:0] write_address, write_data, read_address, //address and values to be written
    output logic [31:0] read_data
);

    //instantiaate 384 32-bit registers    
    reg [31:0] memory [383:0];

    //write if write signal is HI, always read
    always_ff @( posedge clk, negedge nRst ) begin
        if(~nRst) begin
		for (integer i = 0; i < 384; i++) begin
                memory[i] = 32'b0;
            	end
        end else if (write_enable) begin
            memory[write_address] <= write_data;
        end  
        read_data <= memory[read_address];
    end
endmodule
