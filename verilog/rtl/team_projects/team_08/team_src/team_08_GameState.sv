/**
* Module Name: GameState
* Function: this module takes input from other modules and then moves to other states
*           for example, it takes the input from collision detector, 
                        if collision_detect == 1, move to Over state
*/


module team_08_GameState (
  input logic clk,
  input logic reset,
  input logic collision_detect, // comes from collision_detector module
  input logic button_pressed, //comes from dinoJump
  input logic [6:0] score, // comes from score_counter module
  output state_t state
);

  //internal signals
  state_t next_state;

//state transition logic
always_ff @(posedge clk, negedge reset) begin
  if(!reset) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

//next state logic
always_comb begin
  //initialize 
  next_state = state;

  case(state)
    IDLE: begin
      if(button_pressed) begin
        next_state = RUN;
      end
    end

    RUN: begin
      if (score > 101) begin
        next_state = OVER;
      end
    else if (score == 99) begin
      next_state = WIN;
    end


    end
    
    WIN: begin
      //show WIN!!!!
      //sends to LCD and ssdec

      //go back to IDLE state
      if(button_pressed) begin
        next_state = IDLE;
      end
    end
    
    OVER: begin
      //keep showing the score on 7-seg display until user pressed the button
      //sends to LCD
      
      //go back to IDLE state
      if(button_pressed) begin
        next_state = IDLE;
      end
    end

    default: next_state = IDLE;
  endcase
end
endmodule
