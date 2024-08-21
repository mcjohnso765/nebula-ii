`default_nettype none

module keypad_control(
    input logic [3:0]readrow,
    input logic clk,
    input logic nrst,
    output logic [3:0]scancol,
    output logic msg_tx_ctrl,
    output logic [127:0]msg_1
    //output logic [1:0]key_count,
    //output logic receive_ready,
    //output logic keyvalid,
    // output logic [127:0]msg_2
    );

    logic [7:0]keycode;
    logic keyvalid;
    logic receive_ready;
    logic [7:0]keycode_previous;
    logic upper;
    logic mode;
    logic [1:0]key_count;
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

// module buffer(
//   input logic [7:0]keycode,
//   input logic clk,
//   input logic rst,
//   input logic receive_ready,
//   output logic [7:0]keycode_previous;
//   );

//   logic [7:0]nextkeycode;

//   always_ff @(posedge clk, posedge reset) begin
//     if (rst)
//       keycode_previous <= 8'b0;
//     else 
//       keycode_previous <= nextkeycode;
//     end


//   always_comb begin
//   if (receive_ready)
//     nextkeycode = keycode;
//   else 
//     nextkeycode = previous_keycode;
//   end
// endmodule

// module controls(
//   input logic [7:0]keycode_previous,
//   input logic [7:0]keycode,
//   output logic upper,
//   output logic mode,
//   output logic [1:0]key_count
//   );

//   logic next_mode;
//   logic next_upper;
//   logic [1:0]next_key_code;

//   always_ff @ (posedge clk, posedge rst) begin
//     if (rst)
//       mode <= 0;
//     else
//       mode <= next_mode;
//     end
//   always_ff @ (posedge clk, posedge rst) begin
//     if (rst)
//       upper <= 0;
//     else
//       upper <= next_upper;
//     end
//   always_ff @ (posedge clk, posedge rst) begin
//     if (rst)
//       key_count <= 2'b0;
//     else
//       key_count <= next_key_count;
//     end
//   always_comb begin
//     if (keycode_previous == 8'b00101000) begin  //did B get pressed only once?
//       mode = 1;     //letter mode

//       //SHIFT	

//       if (keycode_previous == 8'b10000100 && mode ==1)    //if in letter mode and # is pressed
//         next_upper = 1;    //shift is pressed
//       else if (keycode_previous == 8'b10000100 && mode == 0)  //if in number mode and # is pressed
//         next_upper = 0;
//       else if (keycode_previous !=8'b10000100 && mode == 1)  //if in letter mode and # is not pressed
//         next_upper = 0;
//       else (keycode_previous != 8'b10000100 && mode == 0) //if in number mode and # is not pressed
//         next_upper =0;
//           end

//       //KEYCOUNT CONTROL

//       if (keycode_previous != keycode) next_key_count = 2'b00;  //if there's no repeat value, then the keycount is 0
      
//       else if (keycode_previous == keycode && key_count = 2'b00) next_key_count = 2'b01; //if there's one repeat value, make the key count 1
   
//       else if (keycode_previous == keycode && key_count = 2'b01) next_key_count = 2'b10;  //if there's two repeat values (3 of the same)
     
//       else if (keycode_previous == keycode && key_count = 2'b10) next_key_count = 2'b11;  //if there's 3 repeat values (4 of the same)
    
//       else if (keycode_previous == 8'b00101000 && mode == 1)  mode = 0;  //B has been pressed while already in letter mode

//       else if (key_count == 2'b11 && keycode == previous_keycode) next_key_count = 2'b01;
             
//       if (keycode == 8'b01001000) next_key_count = 2'b00; //if C is pressed reset keycount 	

           
//     else mode = 0;    //default mode is number mode
      
//     end
// endmodule

// module decoder(
//   input logic [7:0]keycode,
//   input logic [7:0]previous_keycode,
//   input logic [1:0]key_count,
//   input logic mode,
//   input logic upper,
//   input logic receive_ready,
//   output logic [127:0]data_received
//   );

//   logic [127:0]next_data_received;

//   always_ff @(posedge clk, posedge rst)  //shift register to make the values move to the left after each letter is confirmed or each number is pressed
//     if(rst)
//       data_received = 128'd20; //space
//     else  
//       data_received = next_data_received
  


//   always_comb begin
 
//     case(keycode)
//         8'b00000000 :begin //nobutton
//           next_data_received = data_received;
//     	 end  

   
//          8'b00010001: begin //button1
//           if(mode == 0)	data_received =  16'b0011 0001  //1
//           else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0100 0000};  //@
//           else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0101 1111};  //_
//           else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0010 0110};  //&
//           else if (mode == 1&& upper ==0 && key_count == 2'b11) next_data_received = {data_received[120:0],8'b0011 1010};  //:

//           else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0100 0000}; // @
//           else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0101 1111}; // _
//           else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0010 0110}; // &
//           else if (mode == 1&& upper ==1 && key_count == 2'b11) next_data_received = {data_received[120:0],8'b0011 1010}; // :
//         end
    
//          8'b00010010: begin //button2
//           if(mode == 0) next_data_received =  {data_received[120:0],8'b0011 0010} ; //2
//           else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0110 0001}; //a
//           else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0110 0010}; //b
//           else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0110 0011}; //c
//           else if (mode == 1&& upper ==0 && key_count == 2'b11) key_count = 2'b00;

//           else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0100 0001}; // A
//           else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0100 0010}; // B
//           else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0100 0011}; // C
//           else if (mode == 1&& upper ==1 && key_count == 2'b11) key_count = 2'b00;
//         end
        
//          8'b00010100: begin //button3
//           if(mode == 0) next_data_received =  {data_received[120:0],8'b0011 0011} ;  //3
//           else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0110 0100}; //d
//           else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0110 0101} ; //e
//           else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0110 0110}  ;//f
//           else if (mode == 1&& upper ==0 && key_count == 2'b11) key_count = 2'b00;

//           else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received =  {data_received[120:0],8'b0100 0100} ;// D
//           else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0100 0101}; // E
//           else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0100 0110} ;//  F
//           else if (mode == 1&& upper ==1 && key_count == 2'b11) key_count = 2'b00;
//         end

//          8'b00100001: begin //button4
//           if(mode == 0) next_data_received  = {data_received[120:0],8'b0011 0100 } ;//4   
//           else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0110 0111} ;//g
//           else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received =  {data_received[120:0],8'b0110 1000} ; //h
//           else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received =  {data_received[120:0],8'b0110 1001} ; //i
//           else if (mode == 1&& upper ==0 && key_count == 2'b11) key_count = 2'b00;

//           else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0100 0111}; // G
//           else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0100 1000}; // H
//           else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0100 1001}; //  I
//           else if (mode == 1&& upper ==1 && key_count == 2'b11)key_count = 2'b00;
//         end

//          8'b00100010: begin //button5
//           if(mode == 0)  next_data_received  = {data_received[120:0],8'b0011 0101}; //5
//           else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0110 1010}  ; //j
//           else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0110 1011}; //k
//           else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0110 1100} ; //l
//           else if (mode == 1&& upper ==0 && key_count == 2'b11) key_count = 2'b00;

//           else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0100 1010} ;// J
//           else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0100 1011} ;// K
//           else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0100 1100} ; //  L
//           else if (mode == 1&& upper ==1 && key_count == 2'b11)key_count = 2'b00;
//         end

//          8'b00100100: begin //button6
//           if(mode == 0) next_data_received  = {data_received[120:0],8'b0011 0110}; //6
//           else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0110 1101} ;//m
//           else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0110 1110} ; //n
//           else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0110 1111} ; //o
//           else if (mode == 1&& upper ==0 && key_count == 2'b11) key_count = 2'b00;

//           else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0100 1101}; // M
//           else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0100 1110} ;// N
//           else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b 0100 1111}; //  O
//           else if (mode == 1&& upper ==1 && key_count == 2'b11)key_count = 2'b00;
//         end

//          8'b01000001: begin //button7
//           if(mode == 0)  next_data_received  = {data_received[120:0],8'b0011 0111}; //7  
//           else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0111 0000} ;//p
//           else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0111 0001} ; //q
//           else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0111 0010} ; //r
//           else if (mode == 1&& upper ==0 && key_count == 2'b11) next_data_received = {data_received[120:0],8'b0111 0011} ;//s

//           else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b 0101 0000} ; // P
//           else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0101 0001}; // Q
//           else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0101 0010} ;// R
//           else if (mode == 1&& upper ==1 && key_count == 2'b11) next_data_received = {data_received[120:0],8'b0101 0011}; // S
//         end
    
//         8'b01000010: begin //button8
//           if(mode == 0) next_data_received  = {data_received[120:0],8'b0011 1000}; //8
//           else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0111 0100}; //t
//           else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0111 0101};  //u
//           else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0111 0110};  //v
//           else if (mode == 1&& upper ==0 && key_count == 2'b11) key_count = 2'b00;

//           else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0101 0100};  //T
//           else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0101 0101}; //U
//               else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0101 0110}; // V
//           else if (mode == 1&& upper ==1 && key_count == 2'b11) key_count = 2'b00;
//         end

//         8'b01000100: begin //button0
//           if(mode == 0) data_received  = {data_received[120:0],8'b0011 1001}; //9
//           else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0111 0111}; //w
//           else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0111 1000};  //x
//           else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0111 1001};  //y
//           else if (mode == 1&& upper ==0 && key_count == 2'b11) next_data_received = {data_received[120:0],8'b0111 1010}; //z

//           else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0101 0111};  //W
//           else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0101 1000};  //X
//           else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0101 1001};  //Y 
//           else if (mode == 1&& upper ==1 && key_count == 2'b11) next_data_received = {data_received[120:0],8'b0101 1010};  //Z
//         end

//          8'b01001000: begin //button*
//           if(mode == 0)  data_received  = {data_received[120:0],8'b0010 1010};  //*
//           else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0010 1011}; // +
//           else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0010 1101};  //-
//           else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b00101111}; // /
//           else if (mode == 1&& upper ==0 && key_count == 2'b11) next_data_received = {data_received[120:0],8'b0011 1101}; // =

//           else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0010 1011};  // +
//           else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0010 1101};   // -
//           else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b00101111}; //  /
//           else if (mode == 1&& upper ==1 && key_count == 2'b11) next_data_received = {data_received[120:0],8'b0011 1101}; // =
//         end

//          8'b01001000: begin //Button0
//           if(mode == 0)  data_received  = {data_received[120:0],8'b00110000}; //0
//           else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0010 1100}; // ,
//           else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0010 1110};  // .
//           else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0011 1111};  // ?
//           else if (mode == 1&& upper ==0 && key_count == 2'b11) next_data_received = {data_received[120:0],8'b0010 0001}; // !

//           else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0010 1100}; // ,
//           else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0010 1110};  // .
//           else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0011 1111};  // ?
//           else if (mode == 1&& upper ==1 && key_count == 2'b11) next_data_received = {data_received[120:0],8'b0010 0001}; // !
//         end

//          8'b01001000: begin //button#
//           if(mode == 0)  data_received  = {data_received[120:0],8'b 0010 0011}; //#
//           else if (mode == 1&& upper ==0 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0}; // shift
//           else if (mode == 1&& upper ==0 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0}; // shift
//           else if (mode == 1&& upper ==0 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0}; // shift
//           else if (mode == 1&& upper ==0 && key_count == 2'b11) next_data_received = {data_received[120:0],8'b0}; // shift

//           else if (mode == 1&& upper ==1 && key_count == 2'b00) next_data_received = {data_received[120:0],8'b0}; // shift
//           else if (mode == 1&& upper ==1 && key_count == 2'b01) next_data_received = {data_received[120:0],8'b0}; // shift
//           else if (mode == 1&& upper ==1 && key_count == 2'b10) next_data_received = {data_received[120:0],8'b0}; // shift
//           else if (mode == 1&& upper ==1 && key_count == 2'b11) next_data_received = {data_received[120:0],8'b0}; // shift
//         end

//          8'b00011000: begin //buttonA
//           next_data_received = {8'b11111111,data_received[120:0]};//shift letters all to the right

//         end
//         8'b01001000:begin //buttonC
//           if(keycount == 0) next_data_received = {data_received[120:0],8'b00100000}; //space
//           else if(keycount !=0) keycode = keycode_previous; //confirm and go back to cases to see which button should be confirmed
//         end
//         8'b10001000: begin //buttonD
//           if(mode == 1 && previous_keycode == 8'b01001000) next_data_received {data_received[120:0], 8'b00011110}; //if in letter mode and C was confirmed, then send
        
//         end
//       endcase
//   end

//   else if(receive_ready == 0)  //if the button input is not valid
//     next_data_received = 8'b11111111
// endmodule

// module debouncer(
//   input clk,
//   input rst,
//   input logic keyvalid,
//   output logic receive_ready
//   );

//   always_ff @ (posedge clk posedge rst)
//     if(rst)
//       receive_ready <= 0;
//     else  
//       receive_ready <= 1;
// endmodule

    	
    	

	
	
	




