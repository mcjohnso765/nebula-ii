// $Id: $
// File name:   team_11.sv
// Created:     MM/DD/YYYY
// Author:      <Full Name>
// Description: <Module Description>

`default_nettype none

module team_11 (
    // HW
    input logic clk, nrst,
    
    input logic en, //This signal is an enable signal for your chip. Your design should disable if this is low.

    // Logic Analyzer - Grant access to all 128 LA
    input wire [127:0] la_data_in,
    output wire [127:0] la_data_out,
    input wire [127:0] la_oenb,

    // 34 out of 38 GPIOs (Note: if you need up to 38 GPIO, discuss with a TA)
    input  wire [33:0] gpio_in, // Breakout Board Pins
    output wire [33:0] gpio_out, // Breakout Board Pins
    output wire [33:0] gpio_oeb, // Active Low Output Enable
    
    /*
    * Add other I/O ports that you wish to interface with the
    * Wishbone bus to the management core. For examples you can 
    * add registers that can be written to with the Wishbone bus
    */
);

    // All outputs must have a value even if not used
    assign la_data_out = 128'b0;
    assign gpio_out = 34'b0; //Inputs, but set low anyways
    assign gpio_oeb = '1;//All 1's inputs
    /*
    * Place code and sub-module instantiations here.
    */

endmodule

`default_nettype none
// Empty top module

// `include "FPGA_TEMPLATE/debouncer.sv"
// `include "FPGA_TEMPLATE/decoder.sv"
// `include "FPGA_TEMPLATE/keypad.sv"
// `include "FPGA_TEMPLATE/controls.sv"
// `include "FPGA_TEMPLATE/buffer.sv"
// `include "src/Tx_external_shift.sv"
// `include "src/Tx_extcounter.sv"
// `include "src/Tx_ext_fsm.sv"
// `include "src/keypad_control.sv"
// `include "src/UART_Tx.sv"

module top (
  // I/O ports
  input  logic hz10M, reset,
  input  logic [20:0] pb,
  output logic [7:0] left,
  output logic [7:0] right,
  output logic [7:0]ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
 );



//KEYPAD
//keypad cram(.clk(hz10M), .new_clk(new_clk), .nrst(~reset), .readrow(pb[3:0]), .scancol(right[3:0]), .keycode(keycode), .keyvalid(keyvalid));
// ssdec readrowdisplay(.in(pb[3:0]), .enable(1), .out(ss1[6:0]));
// ssdec scancoldispaly(.in(right[3:0]), .enable(1), .out(ss0[6:0]));
// ssdec keycodedisplay(.in(keycode[7:4]), .enable(1), .out(ss7[6:0]));
// ssdec keycodedisp(.in(keycode[3:0]), .enable(1), .out(ss6[6:0]));
// ssdec keyvaliddisplay(.in({3'b000,keyvalid}), .enable(1), .out(ss7[6:0]));
// ssdec keycountdisplay(.in({2'b00,key_count[1:0]}), .enable(1), .out(ss3[6:0]));
//keyclk_div toptest(.clk(hz10M), .nrst(~reset), .new_clk(new_clk));

keypad_control cramtest(.readrow(pb[3:0]), .clk(hz10M), .nrst(~reset), .scancol(right[3:0]), .msg_tx_ctrl(msg_tx_ctrl), 
.msg_1(msg_1), .key_count(key_count), .keyvalid(keyvalid), .msg_2(msg_2));

lcd1602 sending(.clk(hz10M), .nrst(~reset), .row_1(msg), .row_2(msg_1),.lcd_en(right[5]), .lcd_rw(right[7]), .lcd_rs(right[4]), .lcd_data(left[7:0]));


logic receive_ready;
logic [7:0]keycode_previous;
logic upper;
logic mode;
logic [1:0] key_count;
logic [127:0] row_1;
logic [127:0] msg_1;
logic msg_tx_ctrl;
logic [3:0]scancol;
logic [3:0]readrow;
logic [7:0]keycode;
logic keyvalid;
logic new_clk;
logic noisy;
logic btn_ctrl;
logic strobe;
logic [127:0]msg_2;

logic Reg_Start, Count_Start;
logic falling_edge;
logic Ready;
logic no_count;
logic send;
logic start;
logic baud_edge;
logic [8:0]show_internal;
logic success;
logic [7:0]data_receive;
logic rx_din;


logic [127:0]msg;
logic count_enable;
logic stop;    
logic bit_out; 
logic [3:0] count;
logic [3:0] max;
logic enable_s; 
logic enable_t; 
logic ready_signal; // input to fsm from counter
logic [7:0]new_data;
logic tx_dout;
logic tx_ctrl;
logic [7:0]data_send;
logic transmit_ready;
logic state;
endmodule

module keypad_control(
    input logic [3:0]readrow,
    input logic clk,
    input logic nrst,
    output logic [3:0]scancol,
    output logic msg_tx_ctrl,
    output logic [127:0]msg_1,
    output logic [1:0]key_count,
    //output logic receive_ready,
    output logic keyvalid,
    output logic [127:0]msg_2
    );

    logic [7:0]keycode;
    //logic keyvalid;
    logic receive_ready;
    logic [7:0]keycode_previous;
    logic upper;
    logic mode;
    //logic [1:0]key_count;
    logic new_clk;
    logic noisy;
    logic btn_ctrl;
    logic at_max;
    logic [29:0]max;

    keyclk_div clkdivtop(.clk(clk), .nrst(nrst), .at_max(at_max), .max(30'd100000));
    keypad keypadtop(.clk(clk), .enable(at_max), .nrst(nrst), .readrow(readrow), .scancol(scancol), .keycode(keycode), .keyvalid(keyvalid));
    //newkeypad keypadtop(.clk(clk), .nrst(nrst), .receive_ready(receive_ready), .data_received(keycode), .readrow(readrow), .scancol(scancol));
    buffer buffertop(.keycode(keycode), .clk(clk), .nrst(nrst), .receive_ready(receive_ready), .keycode_previous(keycode_previous));
    controls controlstop(.clk(clk), .strobe(receive_ready), .nrst(nrst), .keycode_previous(keycode_previous), .keycode(keycode), .upper(upper), .mode(mode), .key_count(key_count), .msg_tx_ctrl(msg_tx_ctrl));
    decoder decodertop(.clk(clk), .nrst(nrst), .keycode(keycode), .keycode_previous(keycode_previous), .key_count(key_count), .mode(mode), 
    .upper(upper), .data_received(msg_1), .receive_ready(receive_ready));
    debouncer debouncertop(.clk(clk), .nrst(nrst), .keyvalid(keyvalid), .strobe(receive_ready));
    //fakemessage fpgatrial(.clk(clk), .nrst(nrst), .msg_tx_ctrl(msg_tx_ctrl), .msg_1(msg_1), .msg_2(msg_2));
    //button btntop(.clk(clk), .noisy(noisy), .btn_ctrl(btn_ctrl));
    //nokia nokiatop(.clk(clk), .nrst(nrst), .readrow(readrow), .scancol(scancol), .msg_1(msg_1), .msg_tx_ctrl(msg_tx_ctrl));
endmodule

module keyclk_div(
    input logic clk,
    input logic nrst,
    input logic [29:0]max,
    output logic at_max
    );

    // parameter OG_CLK = 100; /// 2.4 GHz signal ie 2400000000
    // parameter BAUD_RATE = 0.000001; // a higher baud rate means a higher rate of transmission, it's essentially a unit of measurement that represents the number of signal changes
    // parameter DIV_FACTOR = 1200000; // so input signal divided by the rate of transmission 

    logic next_clk;
    logic [29:0]count;
    logic [29:0]next_count;


    // always_ff @(posedge clk, negedge nrst) begin
    //     if(!nrst) begin
    //         count <= 0;
    //         new_clk <= 1; // it's one not 0 because when it resets the clk starts on the posedge of the clk we're not starting on negedge of clock
    //     end
    //     else begin
    //         count <= next_count; 
    //         new_clk <= next_clk;
    //     end
    // end

    always_ff @(posedge clk, negedge nrst) begin
        if (!nrst) 
           
            count <= 30'b0;
        else
            count <= next_count;
            end

    // always_comb begin
    //     next_clk = new_clk;
    //     next_count = count + 1; 

    //     if(count == DIV_FACTOR -1) begin   
    //         next_count = 0; 
    //         next_clk = ~new_clk; 
    //     end 
    // end
    assign at_max = (count == max);
        always_comb begin
            if(at_max)
                next_count = 30'b0;
            else
                next_count = count + 1;


    end
endmodule

module buffer(
    input logic [7:0]keycode,
    input logic clk,
    input logic nrst,
    input logic receive_ready,
    output logic [7:0]keycode_previous
    );

  logic [7:0]nextkeycode;
    
  always_ff @(posedge clk, negedge nrst) 
    if (!nrst) 
      keycode_previous <= 8'b0;

    else 
      keycode_previous <= nextkeycode;
      


    always_comb begin
    nextkeycode = keycode_previous;
    if (receive_ready)
      nextkeycode = keycode;
    else 
      nextkeycode = keycode_previous;
    end
endmodule

module controls(
  input logic [7:0]keycode_previous,
  input logic [7:0]keycode,
  input clk,
  input nrst,
  input logic strobe,
  output logic upper,
  output logic mode,
  output logic [1:0]key_count,
  output logic msg_tx_ctrl
  );

  logic next_mode;
  logic next_upper;
  logic [1:0]previous_key_count;
  logic next_msg_tx_ctrl;

  always_ff @ (posedge clk, negedge nrst) begin
    if (!nrst) begin
      mode <= 0;
      upper <= 0;     
      previous_key_count <= 2'b0;
      msg_tx_ctrl <= 0; end
    else begin
      mode <= next_mode;
      upper <= next_upper;
      previous_key_count <= key_count;
      msg_tx_ctrl <= next_msg_tx_ctrl; end
  end


  always_comb begin        //MODE CONTROL

    next_mode = mode;

    if (keycode == 8'b00101000) next_mode = ~mode;  //if B is pressed while in number mode, change to letter mode
            //letter mode
    //else if (keycode == 8'b00101000 && mode == 1) next_mode = 0; //if B is pressed while in number mode, change back to number mode
    else next_mode = mode;    //default mode is number mode

  end   
    
  always_comb begin        //SHIFT	
   next_upper = upper;
    if (keycode == 8'b10000100)  begin  //if in letter mode and # is pressed
      next_upper = ~upper;  //flip upper's previous state.
    end else next_upper = upper;
    end

  always_comb begin      //KEYCOUNT CONTROL
    key_count = previous_key_count;
    if (strobe) begin
      if (keycode_previous == keycode && key_count == 2'b00) 
      key_count = 2'b01; //if there's one repeat value, make the key count 1
      else if (keycode_previous == keycode && key_count == 2'b01) 
      key_count = 2'b10;  //if there's two repeat values (3 of the same)
      else if (keycode_previous == keycode && key_count == 2'b10) 
      key_count = 2'b11;  //if there's 3 repeat values (4 of the same)
      else if ( keycode_previous == keycode && key_count == 2'b11 ) 
      key_count = 2'b00;
      else if (keycode == 8'b01001000) key_count = 2'b00;  //if C is pressed reset keycount 	
      else key_count = 2'b0; 
  end 
    end


  always_comb begin    //MSG Control
    //next_msg_tx_ctrl = msg_tx_ctrl;

    if (keycode == 8'b10001000) next_msg_tx_ctrl = 1; //if D is pressed 
    else next_msg_tx_ctrl = 0; end
endmodule

module debouncer(
  input clk,
  input nrst,
  input logic keyvalid,
  output logic strobe
  );

  logic receive_ready, next_receive_ready;
  
  always_ff @(posedge clk, negedge nrst) begin
    if(!nrst) begin
      receive_ready <= 0;
      
    end else begin
      receive_ready <= keyvalid;
      next_receive_ready <= receive_ready;
      
    end
  end

  assign strobe = ((~next_receive_ready) & (receive_ready));

  // always_comb begin
  //   //next_receive_ready = receive_ready;
  //   if (keyvalid == 1)
  //   next_receive_ready = 1'b1;
  //   else 
  //   next_receive_ready = 1'b0;
  // end
endmodule

module decoder(

  input logic [7:0]keycode,
  input logic [7:0]keycode_previous,
  input logic [1:0]key_count,
  input logic mode,
  input clk,
  input nrst,
  input logic upper,
  input logic receive_ready,
  output logic [127:0]data_received
  );

  logic [127:0] next_data_received;
  //initialize
  

  always_ff @(posedge clk, negedge nrst)  //shift register to make the values move to the left after each letter is confirmed or each number is pressed
    if(!nrst)
    data_received <= "                "; //space
    else  
    data_received <= next_data_received;
  

  always_comb begin
    next_data_received = data_received;
    if(receive_ready) begin
     case(keycode)
   
        8'b00010001: begin //button1
          if(mode == 0)	next_data_received[7:0]=  8'b00110001;  //1
          else if (mode == 1 && upper ==0 && key_count == 2'b00) next_data_received[7:0] = 8'b01000000;  //@
          else if (mode == 1 && upper ==0 && key_count == 2'b01) next_data_received[7:0] = 8'b01011111;  //_ 
          else if (mode == 1 && upper ==0 && key_count == 2'b10) next_data_received[7:0] = 8'b00100110;  //&
          else if (mode == 1 && upper ==0 && key_count == 2'b11) next_data_received[7:0] = 8'b00111010;  //:

          else if (mode == 1 && upper ==1 && key_count == 2'b00) next_data_received[7:0] = 8'b01000000; // @
          else if (mode == 1 && upper ==1 && key_count == 2'b01) next_data_received[7:0] = 8'b01011111; // _
          else if (mode == 1 && upper ==1 && key_count == 2'b10) next_data_received[7:0] = 8'b00100110; // &
          else if (mode == 1 && upper ==1 && key_count == 2'b11) next_data_received[7:0] = 8'b00111010; // :
        end
        8'b00010010: begin //button2
          if(mode == 0) next_data_received[7:0] = 8'b00110010; //2
          else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received[7:0] =8'b01100001; //a
          else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received[7:0] =8'b01100010; //b
          else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received[7:0] =8'b01100011; //c
          else if (mode == 1&& upper ==0 && key_count == 2'b11) next_data_received[7:0] = data_received[7:0];

          else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received[7:0] =8'b01000001; // A
          else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received[7:0] =8'b01000010; // B
          else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received[7:0] =8'b01000011; // C
          else if (mode == 1&& upper ==1 && key_count == 2'b11) next_data_received[7:0] = data_received[7:0]; 
        end
        8'b00010100: begin //button3
          if(mode == 0) next_data_received[7:0]=  8'b00110011;  //3
          else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received[7:0] =8'b01100100; //d
          else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received[7:0] =8'b01100101; //e
          else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received[7:0] =8'b01100110 ;//f
          else if (mode == 1&& upper ==0 && key_count == 2'b11) next_data_received[7:0] =data_received[7:0];

          else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received[7:0] =8'b01000100;// D
          else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received[7:0] =8'b01000101; // E
          else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received[7:0] =8'b01000110 ;//  F
          else if (mode == 1&& upper ==1 && key_count == 2'b11) next_data_received[7:0] =data_received[7:0];
        end
        8'b00100001: begin //button4
          if(mode == 0) next_data_received[7:0]= 8'b00110100; //4   
          else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received[7:0] = 8'b01100111 ; //g
          else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received[7:0] = 8'b01101000 ; //h
          else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received[7:0] = 8'b01101001 ; //i
          else if (mode == 1&& upper ==0 && key_count == 2'b11) next_data_received[7:0] = data_received[7:0];

          else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received[7:0] = 8'b01000111; // G
          else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received[7:0] = 8'b01001000; // H
          else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received[7:0] = 8'b01001001; // I
          else if (mode == 1&& upper ==1 && key_count == 2'b11) next_data_received[7:0] = data_received[7:0];
        end
        8'b00100010: begin //button5
          if(mode == 0) next_data_received[7:0]=  8'b00110101;  //5
          else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received[7:0] =8'b01101010; //j
          else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received[7:0] =8'b01101011; //k
          else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received[7:0] =8'b01101100; //l
          else if (mode == 1&& upper ==0 && key_count == 2'b11) next_data_received[7:0] = data_received[7:0];

          else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received[7:0] =8'b01001010;// J
          else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received[7:0] =8'b01001011;// K
          else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received[7:0] =8'b01001100; // L
          else if (mode == 1&& upper ==1 && key_count == 2'b11) next_data_received[7:0] = data_received[7:0];
        end
        8'b00100100: begin //button6
          if(mode == 0) next_data_received[7:0]=   8'b00110110;  //6
          else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received[7:0] =8'b01101101;//m
          else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received[7:0] =8'b01101110; //n
          else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received[7:0] =8'b01101111; //o
          else if (mode == 1&& upper ==0 && key_count == 2'b11) next_data_received[7:0] = data_received[7:0];

          else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received[7:0] =8'b01001101; // M
          else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received[7:0] =8'b01001110;// N
          else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received[7:0] =8'b01001111; //  O
          else if (mode == 1&& upper ==1 && key_count == 2'b11) next_data_received[7:0] = data_received[7:0];
        end
        8'b01000001: begin //button7
          if(mode == 0) next_data_received[7:0]=   8'b00110111;  //7  
          else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received[7:0] =8'b01110000;//p
          else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received[7:0] =8'b01110001; //q
          else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received[7:0] =8'b01110010; //r
          else if (mode == 1&& upper ==0 && key_count == 2'b11) next_data_received[7:0] =8'b01110011;//s

          else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received[7:0] =8'b01010000; // P
          else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received[7:0] =8'b01010001; // Q
          else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received[7:0] =8'b01010010;// R
          else if (mode == 1&& upper ==1 && key_count == 2'b11) next_data_received[7:0] =8'b01010011; // S
        end
        8'b01000010: begin //button8
          if(mode == 0) next_data_received[7:0]= 8'b00111000;  //8
          else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received[7:0] =8'b01110100; //t
          else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received[7:0] =8'b01110101;  //u
          else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received[7:0] =8'b01110110;  //v
          else if (mode == 1&& upper ==0 && key_count == 2'b11) next_data_received[7:0] =data_received[7:0];

          else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received[7:0] =8'b01010100;  //T
          else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received[7:0] =8'b01010101; //U
          else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received[7:0] =8'b01010110; // V
          else if (mode == 1&& upper ==1 && key_count == 2'b11) next_data_received[7:0] =data_received[7:0];
        end
        8'b01000100: begin //button9
          if(mode == 0) next_data_received[7:0]=  8'b00111001;  //9
          else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received[7:0] =8'b01110111; //w
          else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received[7:0] =8'b01111000;  //x
          else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received[7:0] =8'b01111001;  //y
          else if (mode == 1&& upper ==0 && key_count == 2'b11) next_data_received[7:0] =8'b01111010; //z

          else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received[7:0] =8'b01010111;  //W
          else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received[7:0] =8'b01011000;  //X
          else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received[7:0] =8'b01011001;  //Y 
          else if (mode == 1&& upper ==1 && key_count == 2'b11) next_data_received[7:0] =8'b01011010;  //Z
        end
        8'b10000001: begin //button*
          if(mode == 0)  next_data_received[7:0]=   8'b00101010;   //*
          else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received[7:0] =8'b00101011; // +
          else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received[7:0] =8'b00101101;  //-
          else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received[7:0] =8'b00101111; // /
          else if (mode == 1&& upper ==0 && key_count == 2'b11) next_data_received[7:0] =8'b00111101; // =

          else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received[7:0] =8'b00101011;  // +
          else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received[7:0] =8'b00101101;   // -
          else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received[7:0] =8'b00101111; //  /
          else if (mode == 1&& upper ==1 && key_count == 2'b11) next_data_received[7:0] =8'b00111101; // =
        end
        8'b10000010: begin //Button0
          if(mode == 0)  next_data_received[7:0]=   8'b00110000;  //0
          else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received[7:0] =8'b00101100; // ,
          else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received[7:0] =8'b00101110;  // .
          else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received[7:0] =8'b00111111;  // ?
          else if (mode == 1&& upper ==0 && key_count == 2'b11) next_data_received[7:0] =8'b00100001; // !

          else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received[7:0] =8'b00101100; // ,
          else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received[7:0] =8'b00101110;  // .
          else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received[7:0] =8'b00111111;  // ?
          else if (mode == 1&& upper ==1 && key_count == 2'b11) next_data_received[7:0] =8'b00100001; // !
        end
        8'b10000100: begin //button#
          next_data_received= data_received;  //shift

        end
        8'b00011000: begin //buttonA
          next_data_received = {8'b00100000, data_received[127:8]};//shift letters all to the right
        end
        8'b01001000:begin //buttonC
          // if(mode == 0) next_data_received[7:0] = 8'b00100000; //C normally acts as space if in number mode
          // else if (mode == 1 && key_count == 2'b0) next_data_received[7:0] = 8'b00100000; //C is a space if in letter mode and keycount = 0
          // else if(mode == 1 && key_count != 2'b0) next_data_received[127:0] = {data_received[119:0], 8'b00100000}; //confirm the letter and go back to cases to see which button should be confirmed
          next_data_received[127:0] = {data_received[119:0], 8'b00100000}; //if there's not repeated presses
        end
        8'b10001000: begin //buttonD
        
        if(key_count %2 == 0) next_data_received = "__MESSAGE_SENT__"; //if in number mode, just send anyways and clear the screen
        else next_data_received = "                ";
        end
        default: next_data_received = data_received;
      endcase
    end else next_data_received = data_received;

  end
endmodule

module keypad(

  input clk,
  input nrst,
  input enable,
  input logic [3:0]readrow,
  output logic [3:0]scancol,
  output logic [7:0]keycode,
  output logic keyvalid
  );

  logic [2:0]state;
  logic [2:0] nextstate;
  logic [7:0]next_keycode;
  logic next_keyvalid;
  logic [3:0]next_scancol;

  logic [3:0]next_readrow;
  logic [3:0]nextnext_readrow;
  logic receive_ready;

  always_ff @(posedge clk, negedge nrst) 
  if (!nrst) begin
  keycode <= 8'b0;
  state <= 3'b0; 
  // nextstate <= 3'b0;   
  keyvalid <= 1'b0;  
  scancol <= 4'b0000; end

  else begin
  
  keyvalid <= next_keyvalid;
  //state <= nextstate + 1;
  scancol <= next_scancol;
  keycode <= next_keycode;  end 
        

      // else begin
      // keycode <= next_keycode;
      // state <= nextstate;
      // keyvalid <= next_keyvalid;   
      // 

  always_ff @(posedge clk, negedge nrst) //synchronizer for readrow
    if (!nrst) begin  
    next_readrow <= 4'b0;
    nextnext_readrow <= 4'b0;
    end  
    else begin
    next_readrow <= readrow;
    nextnext_readrow <= next_readrow;
    end  


  always_comb begin
  if(|readrow) begin
    next_scancol = scancol;
    end

  else begin
  if (enable) begin
    case(scancol)
    4'b1111: next_scancol = 4'b1110;
    4'b1110: next_scancol = 4'b1101;
    4'b1101: next_scancol = 4'b1011;
    4'b1011: next_scancol = 4'b0111;
    4'b0111: next_scancol = 4'b1111;
    default: next_scancol = 4'b1111;


    endcase 
  end else next_scancol = scancol; end
      
    end
    // case(state)

    //   3'b000: begin //IDLE
    //   if (new_clk) begin  
    //   if(readrow != 4'b0000) begin //if this is the correct column, then don't move to the next state
    //   next_scancol = scancol;
    //   nextstate = 3'b101; end          
    //   else begin
    //   next_scancol = 4'b0001; 
    //   nextstate = 3'b001;end
    //   end
    //   end

    //   3'b001: begin //COL1
    //   if(new_clk) begin
    //   if(readrow != 4'b0000) begin
    //   next_scancol = scancol;
    //   nextstate = 3'b101; end  
    //   else begin
    //   next_scancol = 4'b0010;
    //   nextstate = 3'b010; end
    //   end 
    //   end

    //   3'b010: begin
    //   if (new_clk) begin
    //   if (readrow != 4'b0000) begin
    //   next_scancol = scancol;
    //   nextstate = 3'b101; end
    //   else begin
    //   next_scancol = 4'b0100;
    //   nextstate = 3'b011; end  
    //   end
    //   end 

    //   3'b011: begin
    //   if(new_clk) begin
    //   if (readrow != 4'b0000) begin
    //   next_scancol = scancol;
    //   nextstate = 3'b101; end  
    //   else begin
    //   next_scancol = 4'b1000;
    //   nextstate = 3'b000; end         
    //   end
    //   end

    //   3'b100: begin
    //   if(new_clk) begin
    //   if (readrow != 4'b0000) begin
    //   next_scancol = scancol;
    //   nextstate = 3'b101; end  
    //   else begin
    //   next_scancol = 4'b0001;
    //   nextstate = 3'b000; end         
    //   end
    //   end

    //   3'b101: begin //CORRECT
    //   if(new_clk) begin
    //   next_scancol = scancol;    
    //   nextstate = 3'b000;
    //   end
    //   end
      
    //   default: begin
    //   next_scancol = scancol;
    //   nextstate = state; end//default is IDLE state
    // endcase

  // always_comb begin
  // if(readrow == 4'b0 && new_clk) begin //if there's no readrow input, move to the nextstate aka scan the next col
  
  // if(state == 3'b100)
  // nextstate = 3'b001; 
  // else 
  // nextstate = state + 3'b01; end
  // else 
  // nextstate = state; end
  

  always_comb begin
    next_keyvalid = keyvalid;

    if (readrow != 4'b0) begin //only make a keycode if the readrow is not 0
      next_keycode = {readrow, ~scancol};
      next_keyvalid = 1'b1;
        

    end else begin
      next_keycode = 8'b0;
      next_keyvalid = 1'b0;
    end

    // Strobe?
    //if ((|next_readrow) & ~(|nextnext_readrow)) //if nextreadrow and nextnextreadrow have some input, check that they are different
      //next_keyvalid = 1'b1;
  end

    // case ({readrow,scancol})
    // //row 1
    // {4'b0001,4'b0001}: begin 
    // next_keycode = 8'b00010001; 
    // next_keyvalid = 1'b1;
    //  end   //1   
    // {4'b0001,4'b0010}: begin 
    // next_keycode = 8'b00010010; 
    // next_keyvalid = 1'b1;
    //  end    //2
    // {4'b0001,4'b0100}: begin 
    // next_keycode = 8'b00010100; 
    // next_keyvalid = 1'b1;
    //  end    //3
    // {4'b0001,4'b1000}: begin 
    // next_keycode = 8'b00011000; 
    // next_keyvalid = 1'b1;
    //  end    //A
    
    // //row 2

    // {4'b0010,4'b0001}: begin 
    // next_keycode = 8'b00100001; 
    // next_keyvalid = 1'b1;

    //  end    //4   
    // {4'b0010,4'b0010}: begin 
    // next_keycode = 8'b00100010; 
    // next_keyvalid = 1'b1;

    //  end    //5
    // {4'b0010,4'b0100}: begin 
    // next_keycode = 8'b00100100; 
    // next_keyvalid = 1'b1;

    //  end    //6
    // {4'b0010,4'b1000}: begin 
    // next_keycode = 8'b00101000; 
    // next_keyvalid = 1'b1;

    //  end    //B
    
    // //row 3
    // {4'b0100,4'b0001}: begin 
    // next_keycode = 8'b01000001; 
    // next_keyvalid = 1'b1;
    //  end    //7   
    // {4'b0100,4'b0010}: begin 
    // next_keycode = 8'b01000010; 
    // next_keyvalid = 1'b1;
    //  end    //8
    // {4'b0100,4'b0100}: begin 
    // next_keycode = 8'b01000100; 
    // next_keyvalid = 1'b1;
    //  end    //9
    // {4'b0100,4'b1000}: begin 
    // next_keycode = 8'b01001000; 
    // next_keyvalid = 1'b1;
    //  end    //C

    // //row 4
    // {4'b1000,4'b0001}: begin 
    // next_keycode = 8'b10000001; 
    // next_keyvalid = 1'b1;
    //  end    //*   
    // {4'b1000,4'b0010}: begin 
    // next_keycode = 8'b10000010; 
    // next_keyvalid = 1'b1;
    //  end    //0
    // {4'b1000,4'b0100}: begin 
    // next_keycode = 8'b10000100;
    // next_keyvalid = 1'b1;
    //  end    //#
    // {4'b1000,4'b1000}: begin 
    // next_keycode = 8'b10001000; 
    // next_keyvalid = 1'b1;
    //  end    //D

    // default: begin
    // next_keycode = 8'b0; 
    // next_keyvalid = 1'b0; end
    // endcase
    // end
endmodule

module lcd1602 #(parameter clk_div = 20_000)(
    input logic clk,
    input logic nrst,
    
    // Data to be displayed
    input logic [127:0] row_1,
    input logic [127:0] row_2,
    
    // LCD control signal
    output logic lcd_en,
    output logic lcd_rw,
    output reg lcd_rs,
    output reg [7:0] lcd_data
    );
    //logic lcd_ctrl;
    reg [7:0] currentState;
    reg [7:0] nextState;
    reg [17:0] cnt_20ms;
    reg [14:0] cnt_500hz;
    wire delay_done;
    logic lcd_ctrl;




    localparam TIME_500HZ = clk_div; 
    // Wait for 20 ms before intializing.
    localparam TIME_20MS = TIME_500HZ * 10;
    
    // Set lcd_data accroding to datasheet
    localparam IDLE = 8'h00,                
               SET_FUNCTION = 8'h01,       
               DISP_OFF = 8'h03,
               DISP_CLEAR = 8'h02,
               ENTRY_MODE = 8'h06,
               DISP_ON = 8'h07,
               ROW1_ADDR = 8'h05,       
               ROW1_0 = 8'h04,
               ROW1_1 = 8'h0C,
               ROW1_2 = 8'h0D,
               ROW1_3 = 8'h0F,
               ROW1_4 = 8'h0E,
               ROW1_5 = 8'h0A,
               ROW1_6 = 8'h0B,
               ROW1_7 = 8'h09,
               ROW1_8 = 8'h08,
               ROW1_9 = 8'h18,
               ROW1_A = 8'h19,
               ROW1_B = 8'h1B,
               ROW1_C = 8'h1A,
               ROW1_D = 8'h1E,
               ROW1_E = 8'h1F,
               ROW1_F = 8'h1D,
               ROW2_ADDR = 8'h1C,
               ROW2_0 = 8'h14,
               ROW2_1 = 8'h15,
               ROW2_2 = 8'h17,
               ROW2_3 = 8'h16,
               ROW2_4 = 8'h12,
               ROW2_5 = 8'h13,
               ROW2_6 = 8'h11,
               ROW2_7 = 8'h10,
               ROW2_8 = 8'h30,
               ROW2_9 = 8'h31,
               ROW2_A = 8'h33,
               ROW2_B = 8'h32,
               ROW2_C = 8'h36,
               ROW2_D = 8'h37,
               ROW2_E = 8'h35,
               ROW2_F = 8'h34;

    assign delay_done = (cnt_20ms==TIME_20MS-1) ? 1'b1 : 1'b0;
    always @(posedge clk, negedge nrst) begin
        if (!nrst) begin
            cnt_20ms <= 0;
        end
        else if (cnt_20ms == TIME_20MS-1) begin
            cnt_20ms <= cnt_20ms;
        end
        else
            cnt_20ms <= cnt_20ms + 1;
    end 

    //500HZ for lcd
    always  @(posedge clk, negedge nrst) begin
        if(!nrst)begin
            cnt_500hz <= 0;
        end
        else if(delay_done)begin
            if(cnt_500hz == TIME_500HZ - 1)
                cnt_500hz <= 0;
            else
                cnt_500hz<=cnt_500hz + 1 ;
        end
        else
            cnt_500hz <= 0;
    end

    assign lcd_en = (cnt_500hz > (TIME_500HZ-1)/2)? 1'b0 : 1'b1; 
    assign lcd_ctrl = (cnt_500hz == TIME_500HZ - 1) ? 1'b1 : 1'b0;

    always  @(posedge clk, negedge nrst) begin
        if(!nrst)
            currentState <= IDLE;
        else if (lcd_ctrl)
            currentState <= nextState;
        else
            currentState <= currentState;
    end

    always  @(*) begin
        case (currentState)
            IDLE: nextState = SET_FUNCTION;
            SET_FUNCTION: nextState = DISP_OFF;
            DISP_OFF: nextState = DISP_CLEAR;
            DISP_CLEAR: nextState = ENTRY_MODE;
            ENTRY_MODE: nextState = DISP_ON;
            DISP_ON: nextState = ROW1_ADDR;
            ROW1_ADDR: nextState = ROW1_0;
            ROW1_0: nextState = ROW1_1;
            ROW1_1: nextState = ROW1_2;
            ROW1_2: nextState = ROW1_3;
            ROW1_3: nextState = ROW1_4;
            ROW1_4: nextState = ROW1_5;
            ROW1_5: nextState = ROW1_6;
            ROW1_6: nextState = ROW1_7;
            ROW1_7: nextState = ROW1_8;
            ROW1_8: nextState = ROW1_9;
            ROW1_9: nextState = ROW1_A;
            ROW1_A: nextState = ROW1_B;
            ROW1_B: nextState = ROW1_C;
            ROW1_C: nextState = ROW1_D;
            ROW1_D: nextState = ROW1_E;
            ROW1_E: nextState = ROW1_F;
            ROW1_F: nextState = ROW2_ADDR    ;
            ROW2_ADDR: nextState = ROW2_0;
            ROW2_0: nextState = ROW2_1;
            ROW2_1: nextState = ROW2_2;
            ROW2_2: nextState = ROW2_3;
            ROW2_3: nextState = ROW2_4;
            ROW2_4: nextState = ROW2_5;
            ROW2_5: nextState = ROW2_6;
            ROW2_6: nextState = ROW2_7;
            ROW2_7: nextState = ROW2_8;
            ROW2_8: nextState = ROW2_9;
            ROW2_9: nextState = ROW2_A;
            ROW2_A: nextState = ROW2_B;
            ROW2_B: nextState = ROW2_C;
            ROW2_C: nextState = ROW2_D;
            ROW2_D: nextState = ROW2_E;
            ROW2_E: nextState = ROW2_F;
            ROW2_F: nextState = ROW1_ADDR;
            default: nextState = IDLE;
        endcase 
    end   

    // LCD control sigal
    assign lcd_rw = 1'b0;
    always  @(posedge clk, negedge nrst) begin
        if(!nrst) begin
            lcd_rs <= 1'b0;   //order or data  0: order 1:data
        end
        else if (lcd_ctrl) begin
            if((nextState==SET_FUNCTION) || (nextState==DISP_OFF) || (nextState==DISP_CLEAR) || (nextState==ENTRY_MODE)||
                (nextState==DISP_ON ) || (nextState==ROW1_ADDR)|| (nextState==ROW2_ADDR))
                lcd_rs <= 1'b0;
            else
                lcd_rs <= 1'b1;
        end
        else begin
            lcd_rs <= lcd_rs;
        end     
    end                   

    always  @(posedge clk) begin
        if (!nrst) begin
            lcd_data <= 8'h00;
        end
        else if(lcd_ctrl) begin
            case(nextState)
                IDLE: lcd_data <= 8'hxx;
                SET_FUNCTION: lcd_data <= 8'h38; //2 lines and 5×7 matrix
                DISP_OFF: lcd_data <= 8'h08;
                DISP_CLEAR: lcd_data <= 8'h01;
                ENTRY_MODE: lcd_data <= 8'h06;
                DISP_ON: lcd_data <= 8'h0C;  //Display ON, cursor OFF
                ROW1_ADDR: lcd_data <= 8'h80; //Force cursor to beginning of first line
                ROW1_0: lcd_data <= row_1 [127:120];
                ROW1_1: lcd_data <= row_1 [119:112];
                ROW1_2: lcd_data <= row_1 [111:104];
                ROW1_3: lcd_data <= row_1 [103: 96];
                ROW1_4: lcd_data <= row_1 [ 95: 88];
                ROW1_5: lcd_data <= row_1 [ 87: 80];
                ROW1_6: lcd_data <= row_1 [ 79: 72];
                ROW1_7: lcd_data <= row_1 [ 71: 64];
                ROW1_8: lcd_data <= row_1 [ 63: 56];
                ROW1_9: lcd_data <= row_1 [ 55: 48];
                ROW1_A: lcd_data <= row_1 [ 47: 40];
                ROW1_B: lcd_data <= row_1 [ 39: 32];
                ROW1_C: lcd_data <= row_1 [ 31: 24];
                ROW1_D: lcd_data <= row_1 [ 23: 16];
                ROW1_E: lcd_data <= row_1 [ 15:  8];
                ROW1_F: lcd_data <= row_1 [  7:  0];

                ROW2_ADDR: lcd_data <= 8'hC0;      //Force cursor to beginning of second line
                ROW2_0: lcd_data <= row_2 [127:120];
                ROW2_1: lcd_data <= row_2 [119:112];
                ROW2_2: lcd_data <= row_2 [111:104];
                ROW2_3: lcd_data <= row_2 [103: 96];
                ROW2_4: lcd_data <= row_2 [ 95: 88];
                ROW2_5: lcd_data <= row_2 [ 87: 80];
                ROW2_6: lcd_data <= row_2 [ 79: 72];
                ROW2_7: lcd_data <= row_2 [ 71: 64];
                ROW2_8: lcd_data <= row_2 [ 63: 56];
                ROW2_9: lcd_data <= row_2 [ 55: 48];
                ROW2_A: lcd_data <= row_2 [ 47: 40];
                ROW2_B: lcd_data <= row_2 [ 39: 32];
                ROW2_C: lcd_data <= row_2 [ 31: 24];
                ROW2_D: lcd_data <= row_2 [ 23: 16];
                ROW2_E: lcd_data <= row_2 [ 15:  8];
                ROW2_F: lcd_data <= row_2 [  7:  0];
                default: lcd_data <= 8'hxx;
            endcase                     
        end
        else
            lcd_data <= lcd_data ;
    end
endmodule





// endmodule
module ssdec (
    input logic [3:0] in,
    input logic enable,
    output logic [6:0] out
 );
    assign out = {enable, in} == 5'b10000 ? 7'b0111111:
    {enable, in} == 5'b10001 ? 7'b0000110: //1
    {enable, in} == 5'b10010 ? 7'b1011011: //2
    {enable, in} == 5'b10011 ? 7'b1001111: //3
    {enable, in} == 5'b10100 ? 7'b1100110: //4
    {enable, in} == 5'b10101 ? 7'b1101101: //5
    {enable, in} == 5'b10110 ? 7'b1111101: //6
    {enable, in} == 5'b10111 ? 7'b0000111: //7
    {enable, in} == 5'b11000 ? 7'b1111111: //8
    {enable, in} == 5'b11001 ? 7'b1100111: //9
    {enable, in} == 5'b11010 ? 7'b1110111: //A or 10
    {enable, in} == 5'b11011 ? 7'b1111100: //b
    {enable, in} == 5'b11100 ? 7'b0111001: //C
    {enable, in} == 5'b11101 ? 7'b1011110: //d
    {enable, in} == 5'b11110 ? 7'b1111001: //E
    {enable, in} == 5'b11111 ? 7'b1110001: //F
    7'b0000000;
endmodule


