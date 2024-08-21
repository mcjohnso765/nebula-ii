
module team_08_collision_detector (
  input logic clk,
  input logic reset,
  input logic [8:0] dinoY, 
  input logic [8:0] dinoX, //is a fixed value,
  input logic [8:0] dinoWidth, //fixed value
  input state_t state,
  input logic [8:0] cactusX1, cactusRandDist,
  input logic [8:0] cactusY, //different cactusY for different types of cactus
  input logic [8:0] cactusHeight1, cactusHeight2,
  input logic [8:0] cactusWidth,//fixed value
  output logic collision_detect //true or false 
);

logic [8:0] cactusX2;
logic collision_detect1, collision_detect2;
assign cactusX2 = cactusX1 + cactusRandDist;
  // //internal signals
  // logic [6:0] score;
  // //instantite the score counter to show the score for GameOver state
  // score_counter score_counter_inst (
  //   .clk(clk), .reset(reset), .score(score)
  //   );

always_comb begin
    collision_detect = 0;
    collision_detect1 = 0;
    collision_detect2 = 0;

  case(state)
  IDLE: begin
    collision_detect = 0;
  end

  RUN: begin
    if (dinoY <= cactusY + cactusHeight1) begin
      //check when the dino is at the left side of cactus
      if((cactusX1 < dinoWidth+dinoX) &  (dinoWidth + dinoX <= cactusX1 + cactusWidth)) begin
        //collision is detected
        //if we detect the collision, we need to end the game, move to GameOver state, clear the screen, show the score, the user can press the button to move to gameStart state
                                      //show the score in 7-seg display, call score_counter
        //GameOver state logic: 
        collision_detect1 = 1;

      end 
      //check when the dino is at the right side of cactus
      else if ( (cactusX1 < dinoX) & (dinoX <= cactusX1+cactusWidth)) begin
        //moves to GameOver state
        collision_detect1 = 1;
        
      end
      else begin
        //collision is NOT detected
        collision_detect1 = 0;
      end
    end

    else begin
      //collision is NOT detected
      collision_detect1 = 0;
    end

    if (dinoY <= cactusY + cactusHeight2) begin
      //check when the dino is at the left side of cactus
      if((cactusX2 < dinoWidth+dinoX) &  (dinoWidth + dinoX <= cactusX2 + cactusWidth)) begin
        //collision is detected
        //if we detect the collision, we need to end the game, move to GameOver state, clear the screen, show the score, the user can press the button to move to gameStart state
                                      //show the score in 7-seg display, call score_counter
        //GameOver state logic: 
        collision_detect2 = 1;

      end 
      //check when the dino is at the right side of cactus
      else if ( (cactusX2 < dinoX) & (dinoX <= cactusX2+cactusWidth)) begin
        //moves to GameOver state
        collision_detect2 = 1;
        
      end
      else begin
        //collision is NOT detected
        collision_detect2 = 0;
      end
    end

    else begin
      //collision is NOT detected
      collision_detect2 = 0;
    end
    collision_detect = collision_detect1 || collision_detect2;
  end

  OVER: begin
    collision_detect = 0;
  end

  WIN: begin
    collision_detect = 0;
  end

  default: collision_detect = 0;
endcase
end
endmodule

