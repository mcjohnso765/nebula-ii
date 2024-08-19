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
