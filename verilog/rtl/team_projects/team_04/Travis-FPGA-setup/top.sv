
module top(
  // I/O ports
  input  logic hz100, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);

  logic Hz10M;
  logic [1:0] count, next_count;
  
/////////////////////////////////////gives us our 10 MHz clock via clock divider/////////////////////
  always @(posedge hz100 or posedge reset) begin
      if (reset) begin
          Hz10M <= 1'b0;
      end else begin
          Hz10M <= ~Hz10M;
      end
  end


  ram ranch(
    .din(data_to_mem),
    .addr_r({2'b0, adr_to_mem[31:2]}),
    .addr_w({2'b0, adr_to_mem[31:2]}),
    .write_en(mem_write),
    .clk(Hz10M),
    .dout(data_from_mem)
  );



logic [31:0] data_from_mem, adr_to_mem, data_to_mem;
  logic mem_write;
  t04_tippy_top tt(
    .clk(Hz10M),
    .nRst(~reset),
    .button(),
    
    .mem_busy(1'b0),
    .data_from_mem(data_from_mem),
    .mem_read(),
    .mem_write(mem_write),

    .adr_to_mem(adr_to_mem),
    .data_to_mem(data_to_mem),
    .sel_to_mem(),

    .Rx(pb[1]),

    .h_out(left[6]),
    .v_out(left[5]),
    .pixel_data(left[7])
  );
  
///////////////////////////This is the code that Travis has been working on since we first integrated the CPU System///////////////////
// very_top topbottom(        
//     .clk(Hz10M), .nRst(~reset), .button(pb[0]),

//     .Rx(pb[1]),
    
//     .h_out(left[6]), 
//     .v_out(left[5]), 
//     .pixel_data(left[7])
    
// );
//////////////////To test this code, comment out the other modules in this file////////////////////////////////


  assign right[0] = Hz10M; 


endmodule



module t04_ram (din, addr_r, addr_w, write_en, clk, dout); // 512x8
    parameter addr_width = 32;
    parameter data_width = 32;
    input [addr_width-1:0] addr_r, addr_w;
    input [data_width-1:0] din;
    input write_en, clk;
    output [data_width-1:0] dout;

    reg [data_width-1:0] dout; // Register for output.
    reg [data_width-1:0] mem [2000-1:0];
    
    // initial begin
    //     $readmemh("instrList.txt", mem);
    // end

    always @(posedge clk)
    begin
        // mem[1000] <= 32'h1;

        mem[00] <= 32'h00000000;
        mem[01] <= 32'h03c00093;
        mem[02] <= 32'h02400113;
        mem[03] <= 32'h01800193;
        mem[04] <= 32'h0ff00213;
        mem[05] <= 32'h3e102423;
        mem[06] <= 32'h3e202623;
        mem[07] <= 32'h3e102823;
        mem[08] <= 32'h3e302a23;
        mem[09] <= 32'h3e402c23;
        mem[10] <= 32'h3e302e23;
        mem[11] <= 32'h40302023;
        mem[12] <= 32'h40202223;
        mem[13] <= 32'h40202423;
        mem[14] <= 32'h40202623;
        
        if (write_en) begin
            mem[(addr_w)] <= din;
        end
        dout <= mem[addr_r]; // Output register controlled by clock.
    end

    

endmodule
