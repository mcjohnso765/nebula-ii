module t04_ram (din, addr_r, addr_w, write_en, clk, dout); // 512x8
  parameter addr_width = 32;
  parameter data_width = 32;
  input [addr_width-1:0] addr_r, addr_w;
  input [data_width-1:0] din;
  input write_en, clk;
  output [data_width-1:0] dout;

  reg [data_width-1:0] dout; // Register for output.
  reg [data_width-1:0] mem [384-1:0];
  always @(posedge clk)
	//always@(negedge clk) //timing in load/store
  	begin
    if (write_en)
    mem[(addr_w)] <= din;
  end
	always_comb begin
    dout = mem[addr_r]; // Output register controlled by clock.
	end
endmodule

//changes made include addding always_comb block