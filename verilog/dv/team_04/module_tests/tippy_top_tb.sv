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
    ram ranch(
        .din(data_to_mem),
        //.addr_r(vga_mem_adr_read), 
	    .addr_r({2'b0, adr_to_mem[31:2]}), //to load to cpu from mem
        .addr_w(adr_to_mem), 
        .write_en(mem_write), 
        .clk(tb_clk), 
        .dout(data_from_mem)
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

    #200000;

    // iram instr(
    //     .din('b0),
    //     //.addr_r(vga_mem_adr_read), 
	//     .addr_r(), //to load to cpu from mem
    //     .addr_w('b0), 
    //     .write_en('b0), 
    //     .clk(clk), 
    //     .dout()
    // );



    $finish;
end


endmodule

// module iram (din, addr_r, addr_w, write_en, clk, dout); // 512x8
//   parameter addr_width = 32;
//   parameter data_width = 32;
//   input [addr_width-1:0] addr_r, addr_w;
//   input [data_width-1:0] din;
//   input write_en, clk;
//   output [data_width-1:0] dout;

//   reg [data_width-1:0] dout; // Register for output.
//   reg [data_width-1:0] mem [99:0];
//   always @(posedge clk)
//   begin

//     dout = mem[addr_r]; // Output register controlled by clock.
//   end

//   always_comb begin
//     mem[0] = 32'h00000000;
//     // mem[1] = 32'h;
//     // mem[2] = 32'h;
//     // mem[3] = 32'h;
//     // mem[4] = 32'h;
//     // mem[5] = 32'h;
//     // mem[6] = 32'h;

//   end
// endmodule

module ram (din, addr_r, addr_w, write_en, clk, dout); // 512x8
  parameter addr_width = 32;
  parameter data_width = 32;
  input [addr_width-1:0] addr_r, addr_w;
  input [data_width-1:0] din;
  input write_en, clk;
  output [data_width-1:0] dout;

  reg [data_width-1:0] dout; // Register for output.
  reg [data_width-1:0] mem [2000-1:0];

    assign dout = mem[addr_r]; // Output register controlled by clock.
    assign mem[0] = 32'h00000000;
    assign mem[1] = 32'h00300213; //addi x4, x0, 3
    assign mem[2] = 32'h00118193;//addi x3, x3, 1
  
  always @(posedge clk) begin
    if (write_en)
    mem[(addr_w)] <= din;
  end


endmodule
