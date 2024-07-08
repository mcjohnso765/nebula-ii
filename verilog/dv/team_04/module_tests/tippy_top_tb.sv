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
    .mem_busy(mem_busy), //hardcoding to high
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
    // .vga_adr(vga_adr),
    // .nextInstruction(nextInstruction)
);

//old ram module not used anymore
// ram ranch(
//     .din(data_to_mem),
//     //.addr_r(vga_mem_adr_read), 
//     .addr_r(adr_to_mem), //to load to cpu from mem
//     .addr_w(adr_to_mem), 
//     .write_en(mem_write), 
//     .clk(tb_clk), 
//     .dout(data_from_mem)
// );

//20 chiken nuggets ram module
ram chicken (
   .clk(tb_clk), 
   .nrst(tb_nRst),
    .data_address({2'b0, adr_to_mem[31:2]}), // alu result to be read or written -why are they using dis
  .instruction_address(), // no brainer, it is the insturction address      -wanna use data_from_mem instead somehow??!
  .dm_read_en(mem_read), //we dont have a read enable
  .dm_write_en(mem_write), // enable ports for the read and enable
 .data_to_write(data_to_mem), // data to be written into memory  //=data_to_mem?
 .instruction_read(), // things we got from memory dude -ngl idk what this dos
 .data_read(data_from_mem)  //same with this ^^ - i mean i do actually nvm 
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
    tb_nRst = 1'b0; 
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nRst = 1'b1;
    @(posedge tb_clk);
endtask

task mem_busy_assert;
    #10
    mem_busy = 1'b1;
    #10
    mem_busy = 1'b0;
endtask

// //inject initial instructions
// task write_initial_instructions;
//     mem_busy = 1'b1;
    

//     @(negedge tb_clk);
//     adr_to_mem = 32'd0;
//     data_to_mem = 32'h00700093;
    
//     @(negedge tb_clk);
//     adr_to_mem = 32'd4;
//     data_to_mem = 32'h01500113;
    
//     @(negedge tb_clk);
//     adr_to_mem = 32'd8;
//     data_to_mem = 32'h00808093;
   
// endtask

initial begin
    //signal dump
    $dumpfile("tippy_top.vcd");
    $dumpvars(0, tippy_top_tb); 

    mem_busy = 1'b0;

    reset_dut();
    mem_busy_assert(); //for dummy instruction


    // write_initial_instructions();
    #200000;


    $finish;
end


endmodule

// module ram (din, addr_r, addr_w, write_en, clk, dout); // 512x8
//   parameter addr_width = 32;
//   parameter data_width = 32;
//   input logic [addr_width-1:0] addr_r, addr_w;
//   input logic [data_width-1:0] din;
//   input logic write_en, clk;
//   output logic [data_width-1:0] dout;

//   reg [data_width-1:0] mem [600-1:0];
//   logic [31:0] focus_read = '0, focus_write  ='0;
  
//   always_ff @( posedge clk ) begin 
//       if (write_en) begin
//           mem[addr_w] <= din;
//       end else begin
//           dout <= mem[addr_r];
//       end
//   end

//   endmodule

// module ram ( //og gonna change this up
//     input logic clk, nrst,
//     input logic [31:0] data_address, // alu result to be read or written
//     input logic [31:0] instruction_address, // no brainer, it is the insturction address
//     input logic dm_read_en, dm_write_en, // enable ports for the read and enable
//     input logic [31:0] data_to_write, // data to be written into memory  //=data_to_mem
//     output logic [31:0] instruction_read, data_read // things we got from memory dude
// );

// logic [31:0] mem [4095:0];
// initial $readmemh("cpu.mem", mem, 0, 4095);

// always_ff @(posedge clk) begin
//     if (dm_write_en && data_address[11]) begin
//         mem[data_address[11:0]] <= data_to_write;
//     end

// end

// always_ff @(posedge clk, negedge nrst) begin
//     if (nrst) begin
//         data_read <= '0;
//         instruction_read <= mem[32'b0];
//     end

//     else if (dm_read_en) begin
//         data_read <= mem[data_address[11:0]];

//     end
    
//     else if (!dm_read_en) begin
//         instruction_read <= mem[instruction_address];

//     end

//     else begin
//         instruction_read <= 32'b00000000000000000000000000010011;
//         data_read <= '0;

//     end
// end



// endmodule

// module ram (din, addr_r, addr_w, write_en, clk, dout); // 512x8
//   parameter addr_width = 32;
//   parameter data_width = 32;
//   input logic [addr_width-1:0] addr_r, addr_w;
//   input logic [data_width-1:0] din;
//   input logic write_en, clk;
//   output logic [data_width-1:0] dout;

//   reg [data_width-1:0] mem [600-1:0];
//   logic [31:0] focus_read = '0, focus_write  ='0;
  
//   always_ff @( posedge clk ) begin 
//       if (write_en) begin
//           mem[addr_w] <= din;
//       end else begin
//           dout <= mem[addr_r];
//       end
//   end

//   endmodule

module ram ( //og gonna change this up
    input logic clk, nrst,
    input logic [31:0] data_address, // alu result to be read or written
    input logic [31:0] instruction_address, // no brainer, it is the insturction address
    input logic dm_read_en, dm_write_en, // enable ports for the read and enable
    input logic [31:0] data_to_write, // data to be written into memory  //=data_to_mem
    output logic [31:0] instruction_read, data_read // things we got from memory dude
);

logic [31:0] mem [4095:0];
 `ifdef NOSYNTHESIS
initial $readmemh("cpu.mem", mem, 0, 4095);
    `endif
// always_ff @(posedge clk) begin
//     // if (dm_write_en && data_address[11]) begin
//     //     mem[data_address[11:0]] <= data_to_write;
//     // end

// end

always_ff @(posedge clk, negedge nrst) begin
    if (~nrst) begin
        // for (integer i = 0; i < 4096; i++) begin
        // mem[i] = 32'b0;
        //     case(i)
        //         0: mem[i] = 32'h00000000;
        //         1: mem[i] = 32'h00000193; //addi x3, x0, 0
        //         2: mem[i] = 32'h00300213; //addi x4, x0, 3
        //         3: mem[i] = 32'h00118193; //addi x3, x3, 1
        //         4: mem[i] = 32'h00418463; //beq x3, x4, 8
        //         5: mem[i] = 32'h00419463; //bne x3, x4, 8
        //         6: mem[i] = 32'h00000000;
        //         7: mem[i] = 32'h0041c463; //blt x3, x4, 8
        //         8: mem[i] = 32'h00000000;
        //         9: mem[i] = 32'h0041d463; //bge x3, x4, 8
        //         10: mem[i] = 32'h0041e463; //bltu x3, x4, 8
        //         11: mem[i] = 32'h00000000;
        //         12: mem[i] = 32'h0041f463; //bgeu x3, x4, 8
        //         13: mem[i] = 32'hfe5ff06f; //jal x0, -28

        //     endcase
        // end
        data_read <= '0;
        //instruction_read <= mem[32'b0];
        instruction_read <= 32'h00000000;
    end
    else if (dm_write_en ) begin
        mem[data_address] <= data_to_write;
    end
    else if (dm_read_en) begin
        data_read <= mem[data_address];

    end
    
    else if (!dm_read_en) begin
        instruction_read <= mem[instruction_address];

    end

    else begin
        instruction_read <= 32'b00000000000000000000000000010011;
        data_read <= '0;

    end
end



endmodule
