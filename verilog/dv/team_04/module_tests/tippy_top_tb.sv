`timescale 1ns/100ps
module tippy_top_tb ();

localparam CLK_PERIOD = 10;

//input wires    
logic tb_clk, tb_nRst, button, mem_busy;
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
    .nRst(tb_nRst),
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
    .addr_r(adr_to_mem), //to load to cpu from mem
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

//power-on reset task
task reset_dut;  
    @(negedge tb_clk);
    tb_nRst = 1'b0; 
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nRst = 1'b1;
    @(posedge tb_clk);
endtask

//inject initial instructions
task write_initial_instructions;
    mem_busy = 1'b1;
    

    @(negedge tb_clk);
    adr_to_mem = 32'd0;
    data_to_mem = 32'h00700093;
    
    @(negedge tb_clk);
    adr_to_mem = 32'd4;
    data_to_mem = 32'h01500113;
    
    @(negedge tb_clk);
    adr_to_mem = 32'd8;
    data_to_mem = 32'h00808093;
   
endtask

initial begin
    //signal dump
    $dumpfile("dump.vcd");
    $dumpvars(0, tippy_top_tb); 

    reset_dut();
    write_initial_instructions();
    #200000;


    $finish;
end


endmodule

module ram (din, addr_r, addr_w, write_en, clk, dout); // 512x8
  parameter addr_width = 32;
  parameter data_width = 32;
  input logic [addr_width-1:0] addr_r, addr_w;
  input logic [data_width-1:0] din;
  input logic write_en, clk;
  output logic [data_width-1:0] dout;

  reg [data_width-1:0] mem [600-1:0];
  logic [31:0] focus_read = '0, focus_write  ='0;
  
  always_ff @( posedge clk ) begin 
      if (write_en) begin
          mem[addr_w] <= din;
      end else begin
          dout <= mem[addr_r];
      end
  end

  endmodule
