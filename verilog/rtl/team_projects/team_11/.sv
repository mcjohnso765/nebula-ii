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


  // Your code goes here...


// fa dut(.A(pb[3:0]),.B(pb[7:4]),.Cin(pb[8]),.S(right[0]),.Cout(right[1]));
// ssdec decoding(.in(pb[3:0]),.enable(|pb[3:0]),.out(ss0[6:0]));

// logic [3:0]tomato;
// logic lettuce;
// bcdadd1 adding(.A(pb[3:0]),.B(pb[7:4]),.Cin(pb[8]),.S(tomato),.Cout(lettuce));
// ssdec displayA (.in(pb[3:0]),.enable(1),.out(ss7[6:0]));
// ssdec displayB (.in(pb[7:4]),.enable(1),.out(ss5[6:0]));
// ssdec displayCout(.in({3'b0, lettuce}),.enable(1), .out(ss1[6:0])); 
// ssdec displayS(.in(tomato),.enable(1), .out(ss0[6:0]));
//enc20to5 dut(.in(pb[19:0]),.out(right[4:0]),.strobe(red));


//KEYPAD
//keypad cram(.clk(hz10M), .new_clk(new_clk), .nrst(~reset), .readrow(pb[3:0]), .scancol(right[3:0]), .keycode(keycode), .keyvalid(keyvalid));
ssdec readrowdisplay(.in(pb[3:0]), .enable(1), .out(ss1[6:0]));
ssdec scancoldispaly(.in(right[3:0]), .enable(1), .out(ss0[6:0]));
// ssdec keycodedisplay(.in(keycode[7:4]), .enable(1), .out(ss7[6:0]));
// ssdec keycodedisp(.in(keycode[3:0]), .enable(1), .out(ss6[6:0]));

//keyclk_div toptest(.clk(hz10M), .nrst(~reset), .new_clk(new_clk));
keypad_control cramtest(.readrow(pb[3:0]), .clk(hz10M), .nrst(~reset), .scancol(right[3:0]), .msg_tx_ctrl(msg_tx_ctrl), 
.msg_1(msg_1), .key_count(key_count), .receive_ready(blue), .keyvalid(keyvalid));

ssdec keyvaliddisplay(.in({3'b000,keyvalid}), .enable(1), .out(ss7[6:0]));
ssdec keycountdisplay(.in({2'b00,key_count[1:0]}), .enable(1), .out(ss3[6:0]));
lcd1602 fgpacram(.clk(hz10M), .nrst(~reset), .row_1("                "), .row_2(msg_1),.lcd_en(right[5]), .lcd_rw(right[7]), .lcd_rs(right[4]), .lcd_data(left[7:0]));




// //UART RX
// idle_counter secondcount(.clk(new_clk), .nrst(~reset), .falling_edge(falling_edge), .max(4'b1001),  .no_count(no_count), .countout());
// shift_register shifting_in(.clk(hz10M), .nrst(~reset), .Reg_Start(Reg_Start), .receive_ready(send), .Din(rx_din), .data_receive(data_receive), .show_internal(show_internal), .baud_edge(baud_edge));
// counter counter(.clk(hz10M), .nrst(~reset), .count_start(Count_Start), .baud_edge(baud_edge), .max(4'b1001), .atmax(receive_ready));
// FSM test(.clk(hz10M), .nrst(~reset), .receive_ready(receive_ready), .rx_din(rx_din), .falling_edge(falling_edge), .new_clk(new_clk),
// .state_check(), .Success(success), .Reg_Start(Reg_Start), .Count_Start(Count_Start), .no_count(no_count), .send(send));
// clock_divider baud(.clk(hz10M), .nrst(~reset), .new_clk(new_clk));
// edge_detect detect(.clk(hz10M), .nrst(~reset), .signal_in(rx_din), .falling_edge(falling_edge));
// sr_rx rx_register(.clk(hz10M), .nrst(~reset), .receive_ready(send), .data_receive(data_receive), .new_clk(new_clk), .msg_1(msg_1));
// baud_edge_detect baud_detect(.clk(hz10M), .nrst(~reset), .signal_in(new_clk), .baud_edge(baud_edge));

// //UART TX
// Tx_ext_fsm fsm(.clk(hz10M), .nrst(~reset),.transmit_ready(transmit_ready), .msg_tx_ctrl(msg_tx_ctrl), .stop(stop),.tx_ctrl(tx_ctrl), .count_enable(count_enable));
// Tx_external_shift ext_shift(.clk(hz10M), .nrst(~reset),.msg_tx_ctrl(msg_tx_ctrl), .msg_1(msg_1), .stop(stop), .data_send(data_send));
// Tx_extcounter ext_count(.clk(hz10M), .nrst(~reset), .count_enable(count_enable), .max(5'd16), .stop(stop));
// UART_Tx tx(.clk(hz10M), .nrst(~reset), .data_send(data_send), .tx_ctrl(tx_ctrl), .transmit_ready(transmit_ready), .success(success), .tx_dout(tx_dout));

// Tx_shift_register shifts(.clk(hz10M), .nrst(~reset), .tx_ctrl(tx_ctrl),.enable_s(enable_s & new_clk), .data_send(data_send), .bit_out(bit_out), .count(count));
// Tx_fsm states(.clk(hz10M), .nrst(~reset), .tx_ctrl(tx_ctrl), .bit_out(bit_out), .tx_dout(tx_dout), .enable_t(enable_t), .enable_s(enable_s), .success(success), .ready_signal(ready_signal), .transmit_ready(transmit_ready));
// Tx_intcounter #(.N(4))  counts(.clk(hz10M), .nrst(~reset), .enable_t(enable_t & new_clk), .max(4'd11), .ready_signal(ready_signal), .count(count)); // where's wrap coming from? where's max coming from?  
// Tx_clock_divider #(.N(32)) divider (.clk(hz10M), .nrst(~reset), .new_clk(new_clk)); 



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




endmodule

module keypad_control (
    input logic [3:0]readrow,
    input logic clk,
    input logic nrst,
    output logic [3:0]scancol,
    output logic msg_tx_ctrl,
    output logic [127:0]msg_1,
    output logic [1:0]key_count,
    output logic receive_ready,
    output logic keyvalid
    );

    logic [7:0]keycode;
    //logic keyvalid;
    // logic receive_ready;
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
      next_upper = ~upper; //flip upper's previous state.

      end   //shift is pressed
    if (keycode == 8'b01001000 && upper == 1)
        next_upper = 0;


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

module ssdec (
    input logic [3:0]in,
    input logic enable,
    output logic [6:0]out
  );

  always_comb begin
  out = 7'b0000000;
  if (enable)
    begin 
      case (in)
      4'd0 : out = 7'b0111111;
      4'd1 : out = 7'b0000110;
      4'd2 : out = 7'b1011011;
      4'd3 : out = 7'b1001111;
      4'd4 : out = 7'b1100110;
      4'd5 : out = 7'b1101101;
      4'd6 : out = 7'b1111101;
      4'd7 : out = 7'b0000111;
      4'd8 : out = 7'b1111111;
      4'd9 : out = 7'b1100111;
      4'd10 : out = 7'b1110111;
      4'd11 : out = 7'b1111100;
      4'd12 : out = 7'b0111001;
      4'd13 : out = 7'b1011110;
      4'd14 : out = 7'b1111001;
      4'd15 : out = 7'b1110001;
      default : out = 7'b0000000;
    endcase
  end
  end
endmodule

module button(
	input         clk,     // clock input from FPGA (12MHz)
	input         noisy,   // noisy button input
	output        btn_ctrl // debounced button output one cycle 
  );     
  parameter LIMIT = 120000; // set the bouncing threshold to 10ms, 10ms / (1/12MHz) = 120000 clock cycles
  
  reg    [16:0] r_counter;  // size need to be larger or equal to LIMIT
  reg           r_debounce;
  wire debounce;
	reg  debounce_dly;

  assign debounce = r_debounce;

  assign btn_ctrl = ~debounce_dly & debounce; 
	always @(posedge clk)
			debounce_dly <= debounce;

  always @ (posedge clk) begin
    if (noisy !== r_debounce && r_counter < LIMIT)
      r_counter <= r_counter + 1;
    else if (r_counter == LIMIT) begin
      r_debounce <= noisy;
      r_counter <= 17'b0;
    end
    else  
      r_counter <= 17'b0;
  end
endmodule

module newkeypad(
	input clk,
	input nrst,  
	output receive_ready,
	output reg [7:0] data_received, // only use the lower 8-bit
	
	// keypad interface
	input      [3:0] readrow,
	output reg [3:0] scancol
  );
	reg [1:0] count;
	reg [7:0] keycode;
	reg keyvalid;

	// Scan one column in one clock cycle
	always @(count) begin
		case (count)
			2'b00:   scancol <= 4'b0001;
			2'b01:   scancol <= 4'b0010;
			2'b10:   scancol <= 4'b0100;
			2'b11:   scancol <= 4'b1000;
			//default: scancol <= 4'b0001;
		endcase
	end
  
	// To avoid noise
	button button_control(.clk(clk),.noisy(keyvalid),.btn_ctrl(receive_ready)); 

	always @(posedge clk, negedge nrst) begin
  if (!nrst) begin
  keycode <= 8'b0000_0000;
  keyvalid <= 1'b0;
  count <= 2'b00; end
		
  else begin
    if (readrow != 4'b0000) begin
    keycode <= {scancol, readrow};
    keyvalid <= 1'b1; end
			
    else begin
    keyvalid <= 1'b0;
    count <= count + 2'b01;  end
			
		end
	end
	
	always @(posedge clk) begin
		if (!nrst)
    data_received <= 8'b0;
		else if (receive_ready) begin
    case (keycode)
    8'b0000_0000: data_received <= 8'b0;
    8'b0001_0001: data_received <= "1";
    8'b0001_0010: data_received <= "2";
    8'b0001_0100: data_received <= "3";
    8'b0001_1000: data_received <= "A";
    8'b0010_0001: data_received <= "4";
    8'b0010_0010: data_received <= "5";
    8'b0010_0100: data_received <= "6";
    8'b0010_1000: data_received <= "B";
    8'b0100_0001: data_received <= "7";
    8'b0100_0010: data_received <= "8";
    8'b0100_0100: data_received <= "9";
    8'b0100_1000: data_received <= "C";
    8'b1000_0001: data_received <= "*";
    8'b1000_0010: data_received <= "0";
    8'b1000_0100: data_received <= "#";
    8'b1000_1000: data_received <= "D";
    default:      data_received <= 8'b0;
			endcase
		end
	end
endmodule

module nokia(
  input            clk,
  input            nrst,  
  input      [3:0] readrow,
  output reg [3:0] scancol,
  output reg [127:0] msg_1,
  output msg_tx_ctrl
  );

  wire receive_ready;
  wire [7:0] no_use;
  wire [7:0] keycode;
  reg [7:0] previous_keycode;
  reg [1:0] key_count;
  reg mode; // 0: character, 1: number
  reg upper; // 0: lower-case, 1: upper-case

  newkeypad keypad_base(
    .clk(clk),
    .nrst(nrst),
    .receive_ready(receive_ready),
    .data_received(keycode),
    .readrow(readrow),
    .scancol(scancol)
  );
  
  // Store previous value
  always @(posedge clk) begin
  if (!nrst)
  previous_keycode <= 8'b0;
  else if (receive_ready)
  previous_keycode <= keycode;
  end 

  // key count control
  always @(posedge clk)  begin
    if (!nrst)
    key_count <= 2'b0;
    else if (receive_ready && mode == 1'b0) begin
      if (keycode == "C")
      key_count <= 2'b0;
      else if (previous_keycode == keycode)
      key_count <= key_count + 1'b1;

    end
  end

  // mode control
  always @(posedge clk)  begin
  if (!nrst)
  mode <= 1'b1;
  else if (receive_ready && keycode == "B") begin
  mode <= ~mode; end
  end
  

  // upper/lower case control
  always @(posedge clk)  begin
  if (!nrst)
  upper <= 1'b0;
  else if (receive_ready && keycode == "#") begin
  upper <= ~upper; end
  end
    
  

  // msg_1 control
  always @(posedge clk) begin
    if (!nrst) begin
      msg_1 <= "--    SEND    --                ";
    end
      else if (receive_ready) begin
      case (keycode)
      "A": begin
      //A backspace
      msg_1 <= {" ", msg_1[127:8]};
      end
      "C": begin
      //C confirm
      msg_1 <= {msg_1[119:0], " "};
      end
      "#": begin
      // #
      if (mode) msg_1 <= {msg_1[119:0], "#"};
      else begin
        msg_1[7:0] <= "^";
        end
      end
      "1": begin
      // 1
      if (mode) msg_1 <= {msg_1[119:0], "1"};
      else begin
      if (key_count==2'b00) msg_1[7:0] <= "@";
      else if (key_count==2'b01) msg_1[7:0] <= "_";
      else if (key_count==2'b10) msg_1[7:0] <= "&";
      else if (key_count==2'b11) msg_1[7:0] <= ":";
      end
      end
      "2": begin
      // 2
      if (mode) msg_1 <= {msg_1[119:0], "2"};
      else begin
      if (key_count==2'b00 || key_count==2'b11) msg_1[7:0] <= upper ? "A" : "a";
      else if (key_count==2'b01) msg_1[7:0] <= upper ? "B" : "b";
      else if (key_count==2'b10) msg_1[7:0] <= upper ? "C" : "c";
      end  
      end
      "3": begin
      // 3
      if (mode) msg_1 <= {msg_1[119:0], "3"};
      else begin
      if (key_count==2'b00 || key_count==2'b11) msg_1[7:0] <= upper ? "D" : "d";
      else if (key_count==2'b01) msg_1[7:0] <= upper ? "E" : "e";
      else if (key_count==2'b10) msg_1[7:0] <= upper ? "F" : "f";
      end  
      end
      "4": begin
      // 4
      if (mode) msg_1 <= {msg_1[119:0], "4"};
      else begin
      if (key_count==2'b00 || key_count==2'b11) msg_1[7:0] <= upper ? "G" : "g";
      else if (key_count==2'b01) msg_1[7:0] <= upper ? "H" : "h";
      else if (key_count==2'b10) msg_1[7:0] <= upper ? "I" : "i";
      end
      end
      "5": begin
        // 5
        if (mode) msg_1 <= {msg_1[119:0], "5"};
        else begin
          if (key_count==2'b00 || key_count==2'b11) msg_1[7:0] <= upper ? "J" : "j";
          else if (key_count==2'b01) msg_1[7:0] <= upper ? "K" : "k";
          else if (key_count==2'b10) msg_1[7:0] <= upper ? "L" : "l";
        end
      end
      "6": begin
        // 6
        if (mode) msg_1 <= {msg_1[119:0], "6"};
        else begin
          if (key_count==2'b00 || key_count==2'b11) msg_1[7:0] <= upper ? "M" : "m";
          else if (key_count==2'b01) msg_1[7:0] <= upper ? "N" : "n";
          else if (key_count==2'b10) msg_1[7:0] <= upper ? "O" : "o";
        end
      end
      "7": begin
        // 7
        if (mode) msg_1 <= {msg_1[119:0], "7"};
        else begin
          if (key_count==2'b00) msg_1[7:0] <= upper ? "P" : "p";
          else if (key_count==2'b01) msg_1[7:0] <= upper ? "Q" : "q";
          else if (key_count==2'b10) msg_1[7:0] <= upper ? "R" : "r";
          else if (key_count==2'b11) msg_1[7:0] <= upper ? "S" : "s";
        end
      end
      "8": begin
        // 8
        if (mode) msg_1 <= {msg_1[119:0], "8"};
        else begin
          if (key_count==2'b00 || key_count==2'b11) msg_1[7:0] <= upper ? "T" : "t";
          else if (key_count==2'b01) msg_1[7:0] <= upper ? "U" : "u";
          else if (key_count==2'b10) msg_1[7:0] <= upper ? "V" : "v";
        end
      end
      "9": begin
        // 9
        if (mode) msg_1 <= {msg_1[119:0], "9"};
        else begin
          if (key_count==2'b00) msg_1[7:0] <= upper ? "W" : "w";
          else if (key_count==2'b01) msg_1[7:0] <= upper ? "X" : "x";
          else if (key_count==2'b10) msg_1[7:0] <= upper ? "Y" : "y";
          else if (key_count==2'b11) msg_1[7:0] <= upper ? "Z" : "z";
        end
      end
      "*": begin
        // *
        if (mode) msg_1 <= {msg_1[119:0], "*"};
        else begin
          if (key_count==2'b00) msg_1[7:0] <= "+";
          else if (key_count==2'b01) msg_1[7:0] <= "-";
          else if (key_count==2'b10) msg_1[7:0] <= "/";
          else if (key_count==2'b11) msg_1[7:0] <= "=";
        end
        
      end
      "0": begin
        // 0
        if (mode) msg_1 <= {msg_1[119:0], "0"};
        else begin
          if (key_count==2'b00) msg_1[7:0] <= ",";
          else if (key_count==2'b01) msg_1[7:0] <= ".";
          else if (key_count==2'b10) msg_1[7:0] <= "?";
          else if (key_count==2'b11) msg_1[7:0] <= "!";
        end
      end
      "D": begin
        msg_1 <= "Message sent!                   ";
      end
      default: begin
        msg_1[7:0] <= msg_1[7:0];
      end
        endcase
        
      end
    end

  assign msg_tx_ctrl = receive_ready && (keycode=="D");
endmodule






















// module fa(input logic Cin,A, B, output logic S,Cout);
  //   assign Cout = (A & B) | ((A^B)&Cin);
  //   assign S = A ^ B ^ Cin;
  // endmodule

  // module fa4(
  //   input logic Cin, 
  //   input logic [3:0]A,B,
  //   output logic [3:0]S,
  //   output logic Cout);
  //   logic Cint;
  //   logic Cint2;
  //   logic Cint3;
  //   fa first (.A(A[0]),.B(B[0]),.Cin(Cin),.S(S[0]),.Cout(Cint));
  //   fa second (.A(A[1]),.B(B[1]),.Cin(Cint),.S(S[1]),.Cout(Cint2));
  //   fa third (.A(A[2]),.B(B[2]),.Cin(Cint2),.S(S[2]),.Cout(Cint3));
  //   fa fourth (.A(A[3]),.B(B[3]),.Cin(Cint3),.S(S[3]),.Cout(Cout));
  // endmodule
// module bcdadd1 (
//   input logic [3:0]A,
//   input logic [3:0]B,
//   input logic Cin,
//   output logic [3:0]S,
//   output logic Cout
//   );

//   logic [3:0]Sint;
//   logic Cout_temp;
//   fa4 dut(.A(A),.Bnext_readrow(B),.Cin(Cin),.S(Sint),.Cout(Cout_temp)); //bring in A as the A from push button A
//   always_comb begin
//   if ({Cout_temp, Sint} > 9) begin
//     S = Sint + 6; 
//     Cout = 1;
//   end
//   else begin
//     S = Sint[3:0];
//     Cout = 0;
//   end
//   end
// endmodule 

// module enc20to5(
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

// module synckey(
//   input logic [19:0]in,
//   input logic clk,
//   input logic rst,
//   output logic [4:0]out,
//   output logic strobe
//   );

//   logic Q1;
//   logic Q2;

//   always_ff @ (posedge clk, posedge rst) begin
//     if(rst) 
//     Q1 <= 0;
//     else begin
//     Q1 <= |in;
//   end
//   end
//   always_ff @ (posedge clk, posedge rst) begin
//     if (rst)
//     Q2 <= 1'b0;
//     else begin
//     Q2 <= Q1;
//     end
//   end

//     assign strobe = Q2;  //basically equating strobe to be 1 whenever any button is pressed

//     always_comb begin
//         out = in[19] ? 5'b10011: in[18] ? 5'b10010: 
//         in[17] ? 5'b10001: in[16] ? 5'b10000: in[15] ? 5'b01111: 
//         in[14] ? 5'b01110: in[13] ? 5'b01101: in[12] ? 5'b01100:  
//         in[11] ? 5'b01011: in[10] ? 5'b01010: in[9] ? 5'b01001:  
//         in[8] ? 5'b01000: in[7] ? 5'b00111:  in[6] ? 5'b00110: 
//         in[5] ? 5'b00101:  in[4] ? 5'b00100: in[3] ? 5'b00011:
//         in[2] ? 5'b00010: in[1] ? 5'b00001: 5'b00000;
      
//     end
// endmodule
