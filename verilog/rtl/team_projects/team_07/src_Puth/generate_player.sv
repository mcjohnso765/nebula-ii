module t07_generate_player (
  // This module intakes coordinates of the blocks containing the player and outputs the pixel the player is on
  input logic nrst,
  input logic clk,
  input logic [8:0] x,
  input logic [7:0] y, 
  input logic [2:0] pos_x, pos_y,
  output logic playerPixel
);

  // borders are still not implemented, when it is, there will be a 12 pixel shift

  // internal variables
// assign playerPixel = '0;
// endmodule

    // must be given randomly by RNG of game logic
    `define JUMP_PLAYER 36
    `define CUBE_PLAYER 12
    
    logic [8:0] SCo = `CUBE_PLAYER + `JUMP_PLAYER* pos_x; // beginning x
    logic [7:0] SPo = `CUBE_PLAYER + `JUMP_PLAYER* pos_y; // beginning y
    logic playerDetect;                     // 1 bit since boolean 0 or 1
    logic [3:0] blockSize = `CUBE_PLAYER;

    // clk is needed for each of the coordinates to specify the range update is cycling through

    always_comb begin

      playerDetect = playerPixel;

      if ((x > (SCo + 9'(blockSize))) && (x < (SCo + (2 * 9'(blockSize)))) 
      && (y > (SPo + 8'(blockSize))) && (y < (SPo + (2 * 8'(blockSize))))) begin 
        playerDetect = 1;
      end else begin
        playerDetect = 0;
      end
    end

  // assign output
  always_ff @(negedge nrst, posedge clk) begin
    if(!nrst) begin
      playerPixel <= 1'd0;
    end else begin
      playerPixel <= playerDetect;
    end
  end

endmodule
