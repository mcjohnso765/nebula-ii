// `timescale 1ms/10ps
    //   module tb;
    //   logic [3:0]A,B;
    //   logic Cin; 
    //   logic [3:0]S; 
    //   logic Cout;

    //   bcdadd1 binarydecoder (.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));

    //   function integer bcdsum (input [3:0]A, input [3:0]B, input Cin);
    //       if ((A + B + Cin) > 9)
    //       return A + B + Cin + 6;
    //       else
    //       return A + B +Cin;

    //   endfunction

    //   initial begin
    //     // make sure to dump the signals so we can see them in the waveform
    //     $dumpfile("sim.vcd");
    //     $dumpvars(0, tb);
    //     // for loop to test all possible inputs
    //     for (integer i = 0; i <= 9; i++) begin
    //     for (integer j = 0; j <= 9; j++) begin
    //     for (integer k = 0; k <= 1; k++) begin
    //     // set our input signals
    //     A = i; B = j; Cin = k;
    //     #1;
    //     if (bcdsum(A, B, Cin) != {Cout,S})
    //       $display("A=%b, B=%b, Cin=%b, Cout=%b, S=%b, expected=%d", A, B, Cin, Cout, S, bcdsum(A,B,Cin));
    //     // display inputs and outputs
    //     //$display("A=%b, B=%b, Cin=%b, Cout=%b, S=%b", A, B, Cin, Cout, S);
    //   end
    //   end
    //   end
    //   // finish the simulation
    //   #1 $finish;
    //   end
    // endmodule


    // `timescale 1ns/10ps
    //   module tb;
    //     logic [19:0]in;
    //     logic [4:0]out;
    //     logic strobe;
        
    //     synckey dut (.in(in), .out(out), .strobe(strobe));// do i put push buttons here or does testbench use something else as inputs?])

    //       initial begin 
    //         $dumpfile("sim.vcd");
    //         $dumpvars(0,tb);
            
    //         // test cases:
    //         in = 20'b00000000000001100000;
    //         #10;
    //         if (out != 5'd6) begin
    //           $display("the value is supposed to be 96 but you got %d", out);
    //         end

    //         in = 20'b00000000000000000110;
    //         #10;
    //         if (out != 5'd2) begin
    //           $display("the value is supposed to be 6 but you got %d", out);
    //         end

    //         in = 20'b00000000010000000000;
    //         #10;
    //         if (out != 5'd10) begin
    //           $display("the value is supposed to be 1024 but you got %d", out);
    //         end

    //         in = '0;
    //         for (integer i = 0; i <20; i ++) begin
    //           #10
    //           // make test cases outside the for loop 
    //           in[i] = 1'b1;


    //           if(i != 0) begin in[i-1] = 1'b1; end
            
    //           if(i == 0 && out != 0 && strobe == 1'b1) begin  $display("the value is supposed to be %d but you got %d", i, out); end
    //           else if (out != i - 1 && i != 0 && strobe == 1'b1) begin  $display("the value is supposed to be %d but you got %d", i, out); end
    //         end

    //         $finish;
    //       end 


    //   endmodule


    //   module enc20to5(
    //   input logic [19:0]in,
    //   output logic [4:0]out,
    //   output logic strobe
    //   );
    //   assign strobe = |in;
    //     always_comb begin
    //       out = in[19] ? 5'b10011: in[18] ? 5'b10010: 
    //       in[17] ? 5'b10001: in[16] ? 5'b10000: in[15] ? 5'b01111: 
    //       in[14] ? 5'b01110: in[13] ? 5'b01101: in[12] ? 5'b01100:  
    //       in[11] ? 5'b01011: in[10] ? 5'b01010: in[9] ? 5'b01001:  
    //       in[8] ? 5'b01000: in[7] ? 5'b00111:  in[6] ? 5'b00110: 
    //       in[5] ? 5'b00101:  in[4] ? 5'b00100: in[3] ? 5'b00011:
    //       in[2] ? 5'b00010: in[1] ? 5'b00001: 5'b00000;
        
    //     end
// endmodule

// module keypad(

//   input clk,
//   input rst,
//   input logic [3:0]readrow,
//   output logic [3:0]scancol,
//   output logic [7:0]keycode,
//   output logic keyvalid
//   );

//   logic [1:0]count;
//   always_ff @(posedge clk, posedge reset) begin
//     if (rst)
//       keycode = 8'b0
//     else begin
//       scancol = scancol + 1
//       keycode = keycode;
//       keyvalid = 1;  end
//     end
//   always_comb begin
//     //initialize
//     count = 2'b00;
//     scancol = 4'b0000;
//         case ({readrow,scancol})

//           //row 1
//           {4'b0001,4'b0000}: keycode = 8'b0;  //nobutton
//           {4'b0001,4'b0001}: keycode = 8'b00010001;    //1   
//           {4'b0001,4'b0010}: keycode = 8'b00010010;    //2
//           {4'b0001,4'b0100}: keycode = 8'b00010100;    //3
//           {4'b0001,4'b1000}: keycode = 8'b00011000;    //A
//           //row 2
//           {4'b0010,4'b0000}: keycode = 8'b0;
//           {4'b0010,4'b0001}: keycode = 8'b00100001;    //4   
//           {4'b0010,4'b0010}: keycode = 8'b00100010;    //5
//           {4'b0010,4'b0100}: keycode = 8'b00100100;    //6
//           {4'b0010,4'b1000}: keycode = 8'b00101000;    //B
//           //row 3
//           {4'b0100,4'b0000}: keycode = 8'b0;
//           {4'b0100,4'b0001}: keycode = 8'b01000001;    //7   
//           {4'b0100,4'b0010}: keycode = 8'b01000010;    //8
//           {4'b0100,4'b0100}: keycode = 8'b01000100;    //9
//           {4'b0100,4'b1000}: keycode = 8'b01001000;    //C
//           //row 4
//           {4'b1000,4'b0000}: keycode = 8'b0;
//           {4'b1000,4'b0001}: keycode = 8'b10000001;    //*   
//           {4'b1000,4'b0010}: keycode = 8'b10000010;    //0
//           {4'b1000,4'b0100}: keycode = 8'b10000100;    //#
//           {4'b1000,4'b1000}: keycode = 8'b10001000;    //D
//           endcase


//     end
// endmodule

//KEYPAD TESTBENCH
`timescale 1ms/10ns
  module tb_keypad;
    localparam CLK_PERIOD        = 2.5;  // 400 MHz     
    localparam  RESET_OUTPUT_VALUE = 8'b0;
    logic [3:0]readrow;
    logic [3:0]scancol;
    logic [7:0]keycode;
    logic keyvalid;


        // DUT Inputs
    logic tb_clk;
    logic tb_nrst;


    always begin
        tb_clk = 0; // set clock initially to be 0 so that they are no time violations at the rising edge 
        #(CLK_PERIOD / 2);
        tb_clk = 1;
        #(CLK_PERIOD / 2);
    end


//generate clock first and reset. don't use #10, use clock instead. 
    // logic 
    
    keypad dut(.clk(tb_clk), .rst(tb_nrst), .readrow(readrow), .scancol(scancol), .keycode(keycode), .keyvalid(keyvalid));
      initial begin 
        $dumpfile("sim.vcd");
        $dumpvars(0,tb_keypad);
        
        // TESTCASES
            //test 1: scancol goes column by column and checks each row
        readrow = 4'b000;
        tb_nrst = 1;
        @(posedge tb_clk);
        tb_nrst = 0;
        @(posedge tb_clk);    

        // for (int i = 0; i <5; i++) begin

        //     $display ("the column being scanned is column %b", scancol);
        //     $display ("the row that the button is in is the %b row", readrow);
       
        //     #(CLK_PERIOD * 1); end

      //test 2: the readrow input works
          readrow = 4'b0000;
          #(CLK_PERIOD * 2);
          readrow = 4'b0001;
          #(CLK_PERIOD * 2);
          readrow = 4'b0010;
          #(CLK_PERIOD * 1);
          readrow = 4'b0100;
          #(CLK_PERIOD * 1);          
          readrow = 4'b1000;
          #(CLK_PERIOD * 1);    


      //test 3: keypad can output a keycode 
          readrow = 4'b0000;
          #(CLK_PERIOD * 1);
          readrow = 4'b0100;     
        $finish; 
      end 


  endmodule