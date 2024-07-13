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