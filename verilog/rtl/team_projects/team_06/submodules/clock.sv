
/* 
  Module Name:clock.sv
  Module Function/Purpose: Basic clock for all other modules, has 2 outputs
  Module Inputs:system_clk, reset, game_mode
  Module Outputs: clk , clk_display

  Best Commenting Practices (to make debugging easier):
    1) Explain what each block of logic does.
    2) Explain what each input and output represents and what its values represent.

  Best Coding Practices (to make debugging easier):
    1) Assign outputs using always_ff blocks whenever possible.
    2) Use enable variables for blocks that can be used to change game modes.

*/ 
// typedef enum logic [1:0] {
//         NORMAL_SPEED = 2'b00,
//         FAST_SPEED = 2'b01, 
//         SLOW_SPEED = 2'b10
//     } GAME_SPEED; 

// typedef enum logic [1:0] {
//         RUN = 2'b00,
//         WAIT = 2'b01, 
//         PAUSE = 2'b10,
//         END_GAME = 2'b11
//     } GAME_STATE; 

module clock (
  input logic system_clk, nreset, // system_clk is the max frequency clk on the chip, reset is the output of the reset button
  input GAME_STATE game_state, // game_state
  input GAME_SPEED game_speed, // game speed
  output logic clk, clk_main_display, clk_body // clk_display goes to the display, and clk goes to all other functions
);


logic next_clk_display, next_clk, next_body_clk;
logic [20:0] counter, next_counter, max_count;

// always_ff @(posedge system_clk, posedge reset) begin //// display clk
//         if (reset) begin
//             clk_display <= 0;
//         end else begin
//             clk_display <= next_clk_display; // update the clock when the system clock updates
//         end
//     end


always_ff @(posedge system_clk, negedge nreset) begin /// clk for most functions
        if (~nreset) begin
            clk <= 0;
        end 
        else if (game_state != RUN) begin
          clk <= 0;
        end
        else begin
            clk <= next_clk; // update the clock when the system clock updates
        end
    end



always_ff @(posedge system_clk, negedge nreset) begin /// clk for snake body (speed control)
        if (~nreset) begin
            clk_body <= 0;
            counter <= 0;
        end else begin
            clk_body <= next_body_clk; // update the clock when the system clock updates
            counter <= next_counter;
        end
    end

assign clk_main_display = system_clk;

// always_comb begin // display clk logic

// if (clk_display == 0) begin
//   next_clk_display = 1;// update the display clock 
//   end
// else begin
//   next_clk_display = 0;
//   end
// end

always_comb begin /// movement clk

case (game_speed) 
NORMAL_SPEED: max_count = 2000000; ///variables to change game speed////////////////!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
FAST_SPEED: max_count = 1000; // 10000
SLOW_SPEED: max_count = 1000;
default: max_count = 1000;
endcase
if ( (game_state == WAIT) || (game_state == PAUSE)) begin
  next_counter = 0;
  next_body_clk = 0;
end
else begin

if (counter != max_count) begin // did not work when next_counter

  next_counter = counter + 14'd1;
  next_body_clk = 0;
end 
else begin

  next_counter = 0;
  next_body_clk = 1;
end
end
end
always_comb begin /// clk to most functions

if ( (game_state == WAIT) || (game_state == PAUSE)) begin //update the normal clk if it needs to be updated
  next_clk = 0;
end

else begin
  next_clk = 1;
  //next_clk = system_clk; // setting clk equal to the system clk
end
end
endmodule