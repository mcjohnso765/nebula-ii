`timescale 1ns/100ps
module tippy_top_tb ();

localparam CLK_PERIOD = 10;

//input wires    
logic tb_clk, nRst, button, mem_busy;
logic [31:0] data_from_mem;
logic Rx;

//output wires
logic mem_read, mem_write;
logic [31:0] adr_to_mem, data_to_mem;
logic [3:0] sel_to_mem;
logic h_out, v_out, pixel_data;


//instantiate top level
//Full Project: CPU, VGA, UART, and Request Unit to Connect them
tippy_top everest(
    .clk(tb_clk), 
    .nRst(nRst),
    .button(button), 
    .mem_busy(mem_busy), 
    .data_from_mem(data_from_mem),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .adr_to_mem(adr_to_mem), 
    .data_to_mem(data_to_mem),
    .sel_to_mem(sel_to_mem),
    .Rx(Rx),
    .h_out(h_out), 
    .v_out(v_out), 
    .pixel_data(pixel_data)
);

//clock generation
always begin
    tb_clk = 1'b0; 
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1; 
    #(CLK_PERIOD / 2.0); 
end



initial begin
    //signal dump
    $dumpfile("dump.vcd");
    $dumpvars(0, tippy_top_tb); 
end


endmodule