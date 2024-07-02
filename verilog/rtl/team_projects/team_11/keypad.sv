`default_nettype none
module keypad(

  input clk,
  input nrst,
  input logic [3:0]readrow,
  output logic [3:0]scancol,
  output logic [7:0]keycode,
  output logic keyvalid
  );

logic [2:0]state, nextstate;
logic [7:0]next_keycode;
logic next_keyvalid;

always_ff @(posedge clk, negedge nrst) 
      if (!nrst) begin
       keycode <= 8'b0;
       state <= 3'b0;    
       keyvalid <= 1'b0;  end

    else begin
      keycode <= next_keycode;
      state <= nextstate;
      keyvalid <= next_keyvalid;    end


always_comb begin
    case(state)
    3'b000: begin
      nextstate = 3'b001;
      scancol = 4'b0000; end
    3'b001: begin 
      nextstate = 3'b010;
      scancol = 4'b0001; end //if state 1, check column 1
    3'b010: begin 
      nextstate = 3'b011;
      scancol = 4'b0010; end //if state 2, check column 2
    3'b011: begin
      nextstate = 3'b100;
      scancol = 4'b0100; end //if state 3, check column 3
    3'b100: begin 
      nextstate = 3'b001; 
      scancol = 4'b1000;end  //if state 4, check column 4

    default: begin
      scancol = 4'b0000;
      nextstate = 3'b0; end//default is IDLE state
    endcase
    end
always_comb begin
  //initialize
    
      case ({readrow, scancol})
        //row 1
        {4'b0001,4'b0001}: begin 
          next_keycode = 8'b00010001; 
          next_keyvalid = 1; end   //1   
        {4'b0001,4'b0010}: begin 
          next_keycode = 8'b00010010; 
          next_keyvalid = 1; end    //2
        {4'b0001,4'b0100}: begin 
          next_keycode = 8'b00010100; 
          next_keyvalid = 1; end    //3
        {4'b0001,4'b1000}: begin 
          next_keycode = 8'b00011000; 
          next_keyvalid = 1; end    //A
        
        //row 2
        {4'b0010,4'b0001}: begin 
          next_keycode = 8'b00100001; 
          next_keyvalid = 1; end    //4   
        {4'b0010,4'b0010}: begin 
          next_keycode = 8'b00100010; 
          next_keyvalid = 1; end    //5
        {4'b0010,4'b0100}: begin 
          next_keycode = 8'b00100100; 
          next_keyvalid = 1; end    //6
        {4'b0010,4'b1000}: begin 
          next_keycode = 8'b00101000; 
          next_keyvalid = 1; end    //B

        //row 3
        {4'b0100,4'b0001}: begin 
          next_keycode = 8'b01000001; 
          next_keyvalid = 1; end    //7   
        {4'b0100,4'b0010}: begin 
          next_keycode = 8'b01000010; 
          next_keyvalid = 1; end    //8
        {4'b0100,4'b0100}: begin 
          next_keycode = 8'b01000100; 
          next_keyvalid = 1; end    //9
        {4'b0100,4'b1000}: begin 
          next_keycode = 8'b01001000; 
          next_keyvalid = 1; end    //C

        //row 4
        {4'b1000,4'b0001}: begin 
          next_keycode = 8'b10000001; 
          next_keyvalid = 1; end    //*   
        {4'b1000,4'b0010}: begin 
          next_keycode = 8'b10000010; 
          next_keyvalid = 1; end    //0
        {4'b1000,4'b0100}: begin 
          next_keycode = 8'b10000100;
           next_keyvalid = 1; end    //#
        {4'b1000,4'b1000}: begin 
          next_keycode = 8'b10001000; 
          next_keyvalid = 1; end    //D

        default: begin
        next_keycode = 8'b0; 
        next_keyvalid = 1'b1;
        end
        endcase


  end
endmodule