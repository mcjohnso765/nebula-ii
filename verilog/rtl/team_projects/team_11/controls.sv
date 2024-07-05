
module controls(
  input logic [7:0]keycode_previous,
  input logic [7:0]keycode,
  input clk,
  input nrst,
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
      next_msg_tx_ctrl <= 0; end
    else begin
      mode <= next_mode;
      upper <= next_upper;
      previous_key_count <= key_count;
      next_msg_tx_ctrl <= msg_tx_ctrl; end
  end


  always_comb begin        //MODE CONTROL
    next_mode = mode;

    if (keycode == 8'b00101000 && mode == 0) next_mode = 1;  //if B is pressed while in number mode, change to letter mode
            //letter mode
    else if (keycode == 8'b00101000 && mode == 1) next_mode = 0;
    else next_mode = mode;    //default mode is number mode
  end   
    
  always_comb begin        //SHIFT	
   next_upper = upper;

    if (keycode == 8'b10000100)  begin  //if in letter mode and # is pressed
      next_upper = ~upper; //flip upper's previous state.

      end   //shift is pressed

    if (keycode == 8'b01001000 && upper == 1)
        next_upper = 0;

    // else if (keycode == 8'b10000100 && mode == 0) begin  //if in number mode and # is pressed then lowercase
    //   next_upper = 0; end  
    // else if (keycode != 8'b10000100 && mode == 1) begin  //if in letter mode and # is not pressed then lowercase
    //   next_upper = 0; end  
    // else begin //if in number mode and # is not pressed
    //   next_upper = upper; end  
  end

  always_comb begin      //KEYCOUNT CONTROL
    key_count = previous_key_count;
 
    if (keycode_previous == keycode && key_count == 2'b00) 
    key_count = 2'b01; //if there's one repeat value, make the key count 1
    else if (keycode_previous == keycode && key_count == 2'b01) 
    key_count = 2'b10;  //if there's two repeat values (3 of the same)
    else if (keycode_previous == keycode && key_count == 2'b10) 
    key_count = 2'b11;  //if there's 3 repeat values (4 of the same)
    else if (key_count == 2'b11 && keycode == keycode_previous) 
    key_count = 2'b01;
    else if (keycode == 8'b01001000) key_count = 2'b00;  //if C is pressed reset keycount 	
    else key_count = 2'b0; end


  always_comb begin    //MSG Control
    
    msg_tx_ctrl = next_msg_tx_ctrl;

    if (keycode == 8'b10001000) begin
      msg_tx_ctrl = 1;
    end
    else begin
      msg_tx_ctrl = 0;
    end
  end
    
  


  

endmodule