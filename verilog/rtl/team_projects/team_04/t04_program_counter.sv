`default_nettype none
// // Empty top module

// module top (
//   // I/O ports
//   input  logic hz100, reset,
//   input  logic [20:0] pb,
//   output logic [7:0] left, right,
//          ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
//   output logic red, green, blue,

//   // UART ports
//   output logic [7:0] txdata,
//   input  logic [7:0] rxdata,
//   output logic txclk, rxclk,
//   input  logic txready, rxready
// );

//   // Your code goes here...

//   logic [4:0] pbOut;
//   logic pbStrobe;
//   synckey synckey (
//     .rst(reset),
//     .clk(hz100),
//     .in({4'b0, pb[15:0]}),
//     .out(pbOut),
//     .strobe(pbStrobe)
//   );

//   logic [31:0] instructionAddress, linkAddress, immJumpValue;
//   logic doForceJump, doCondJump, condJumpValue;
//   assign doForceJump = pb[19] == 1;
//   assign doCondJump = pb[18] == 1;
//   assign condJumpValue = pb[17] == 1;
//   assign left[7] = doForceJump;
//   assign left[6] = doCondJump;
//   assign left[5] = condJumpValue;
//   always_comb begin
//     if(pbOut <= 3) begin
//       immJumpValue = (({27'b0,pbOut}+1) * 4);
//     end else begin
//       if(pbOut <= 7) begin
//         immJumpValue = (({27'b0,pbOut}-3) * -4);
//       end else begin
//         immJumpValue = 0;
//       end
//     end


//   end
//   program_counter PC (
//     .nRst(~reset),
//     .enable(pbStrobe),
//     .clk(hz100),
//     .immJumpValue(immJumpValue),
//     .regJumpValue(0),
//     .doForceJump(doForceJump),
//     .doCondJump(doCondJump),
//     .condJumpValue(condJumpValue),
//     .doRegJump(0),
//     .sendLink(0),
//     .instructionAddress(instructionAddress),
//     .linkAddress(linkAddress),

//     .next(red) //REMOVE
//   );

//   logic [31:0] address0, address1, address2, address3, address4;
//   assign address0 = instructionAddress % 10;
//   assign address1 = (instructionAddress / 10) % 10;
//   assign address2 = (instructionAddress / 100) % 10;
//   assign address3 = (instructionAddress / 1000) % 10;
//   assign address4 = (instructionAddress / 10000) % 10;
  
  
//   ssdec SS0 (
//     .in(address0[3:0]),
//     .enable(1),
//     .out(ss0)
//   );
//   ssdec SS1 (
//     .in(address1[3:0]),
//     .enable(1),
//     .out(ss1)
//   );
//   ssdec SS2 (
//     .in(address2[3:0]),
//     .enable(1),
//     .out(ss2)
//   );
//   ssdec SS3 (
//     .in(address3[3:0]),
//     .enable(1),
//     .out(ss3)
//   );
//   ssdec SS4 (
//     .in(address4[3:0]),
//     .enable(1),
//     .out(ss4)
//   );
  
  
// endmodule

// // Add more modules down here...
// module ssdec (
//   input logic [3:0] in,
//   input logic enable,
//   output logic [7:0] out
// );

//   always_comb begin

//     case(enable)

//     1'b0 : begin out = 8'b00000000; end
//     1'b1 : begin
//       case(in)
//         4'b0000 : begin out = 8'b00111111; end //0
//         4'b0001 : begin out = 8'b00000110; end //1
//         4'b0010 : begin out = 8'b01011011; end //2
//         4'b0011 : begin out = 8'b01001111; end //3

//         4'b0100 : begin out = 8'b01100110; end //4
//         4'b0101 : begin out = 8'b01101101; end //5
//         4'b0110 : begin out = 8'b01111101; end //6
//         4'b0111 : begin out = 8'b00000111; end //7

//         4'b1000 : begin out = 8'b01111111; end //8
//         4'b1001 : begin out = 8'b01100111; end //9
//         4'b1010 : begin out = 8'b01110111; end //A
//         4'b1011 : begin out = 8'b01111100; end //B
        
//         4'b1100 : begin out = 8'b00111001; end //C
//         4'b1101 : begin out = 8'b01011110; end //D
//         4'b1110 : begin out = 8'b01111001; end //E
//         4'b1111 : begin out = 8'b01110001; end //F

//       endcase
//     end

//     endcase

//   end

// endmodule

// module synckey ( //includes edge detection
//   input logic clk, rst,
//   input logic [19:0] in,
//   output logic [4:0] out,
//   output logic strobe
// );

//   always_comb begin
//     out = 0;
//     for(integer i = 0; i < 20; i++)
//       if(in[i[4:0]]) begin
//         out = i[4:0];
//       end
//   end

//   logic ff_middle;
//   logic ff_end;

//   always_ff @(posedge clk, posedge rst) begin
//     if(rst) begin
//       ff_middle <= 0;
//     end
//     else begin
//       ff_middle <= |in;
//     end
//   end

//   always_ff @(posedge clk, posedge rst) begin
//     if(rst) begin
//       ff_end <= 0;
//     end
//     else begin
//       ff_end <= ff_middle;
//     end
//   end

//   assign strobe = ff_middle & ~ff_end;

// endmodule

module t04_program_counter (
  input logic nRst, enable, clk,
  input logic [31:0] immJumpValue, regJumpValue,
  input logic doForceJump, doCondJump, condJumpValue, doRegJump, AUIlink,
  output logic [31:0] instructionAddress, linkAddress

);

  always_comb begin
    if (doForceJump) begin
        linkAddress = instructionAddress + 32'd4;
    end else if (AUIlink) begin
        linkAddress = instructionAddress + immJumpValue;
    end else begin
        linkAddress = 32'h0;
    end
  end
  
  always_ff @( negedge clk, negedge nRst ) begin //michael 6/28 - changed from negedge to posedge :)
    if(~nRst) begin
      instructionAddress <= 32'd0;
    //   linkAddress <= 32'd0;
    end else begin
      if (enable) begin


        // if (doForceJump) begin
        //   linkAddress <= instructionAddress + 32'd4;
        // end else if (AUIlink) begin
        //   linkAddress <= instructionAddress + immJumpValue;
        // end else begin
        //   linkAddress <= 32'h0;
        // end

        if (doForceJump | (doCondJump & condJumpValue)) begin

          if (doRegJump & !doCondJump) begin
            instructionAddress <= regJumpValue + immJumpValue;
          end else begin
            instructionAddress <= instructionAddress + immJumpValue;
          end
        end else begin
          instructionAddress <= instructionAddress + 32'd4;
        end
      end else begin
        instructionAddress <= instructionAddress;
        // linkAddress <= 32'd0;
      end
    end
  end

// always_ff @( posedge clk ) begin
//     if(AUIlink) begin
//         linkAddress <= instructionAddress + immJumpValue;
//     end
// end
endmodule


//changes made to accomodate auipc functionality