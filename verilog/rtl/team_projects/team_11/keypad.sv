`default_nettype none

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
