
module team_08_cactusMove(
input logic clk, nRst, enable, 
input logic [1:0] rng_input,
input logic [1:0] type1, type2,
input logic drawDoneCactus,
input state_t state,
output logic [8:0] x_dist, //distance between pixels
output logic [8:0] pixel, //cactus1_pos, cactus2_pos,
output logic [8:0] height1, height2, //heights of two cactus
output logic cactusMovement
// //col1, col2,row1,row2, 
// output logic cactus_out, cactus1_active, cactus2_active
);
logic [8:0] x_distance;
logic [8:0] n_pixel, n_h1, n_h2;
logic [1:0]  x;
logic [31:0]n_count, count, max_i;
logic atmax;

logic n_cactusMovement;

always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
      cactusMovement <= 0;
    end

    else begin
      cactusMovement <= n_cactusMovement;
    end
  end

  always_comb begin
    if(n_pixel != pixel) begin
        n_cactusMovement = 1;
    end
    else if(drawDoneCactus) begin
        n_cactusMovement = 0;
    end
    else begin
        n_cactusMovement = cactusMovement;
    end
  end

// assign enable = 1;
assign max_i = 240000;

always_ff @(posedge clk, negedge nRst) begin
  if(!nRst)
    count <= 0;
  else
    count <= n_count;
end

always_comb begin
  n_count = count;
  atmax = 0;

  case(state)

  IDLE: begin
    n_count = 0;
  end

  RUN: begin
    n_count = count + 1;
    if (count == max_i)
        n_count = 0;
    if (count == max_i) begin
      atmax = 1;
    end else begin
      atmax = 0;
    end
  end

  WIN: begin
    n_count = 0;
  end

  OVER: begin
    n_count = 0;
  end

  default: n_count = 0;

  endcase

end
// tracking second cactus 
always_ff @(posedge clk, negedge nRst) begin
  if (!nRst) begin
    pixel <= 328;
end else begin
    pixel <= n_pixel;
end
end

always_comb begin
  n_pixel = pixel;

case(state) 
  IDLE: begin
    n_pixel = pixel;
  end

RUN: begin
  if (atmax)
    n_pixel = pixel + 4;
end

OVER: begin
end

WIN: begin
end

default: begin end
endcase
  
end

// Way to generate the two cacti with random pixel distance between them
// Takes input from game clock so that the speed increments accordingly
// Will give direct call to the draw_box function
//Takes RNG input (0,1,2 or 3) and assigns incriments of distance 10 pixels for each (if 0, distance = 10 pixels, if 1 pixel distance = 20 pixels , etc)

//logic [7:0] x_distance; //distance between pixels

always_comb begin
  x_distance = x_dist;
  n_h1 = height1;
  n_h2 = height2;

case(state)

IDLE: begin
end

RUN: begin
  if (pixel == 320 && drawDoneCactus) begin
        case (rng_input)
            2'b00: x_distance = 100;  // 10 pixels
            2'b01: x_distance = 130; // 20 pixels
            2'b10: x_distance = 160; // 30 pixels
            2'b11: x_distance = 180; // 40 pixels
            default: x_distance = 100; // Default to 10 pixels 
        endcase
  end
  else begin
    x_distance = x_dist;
  end

  if (pixel == 320 && drawDoneCactus) begin
        case (type1)
            2'b00: n_h1 = 15;  // 15 pixels
            2'b01: n_h1 = 20; // 20 pixels
            2'b10: n_h1 = 30; // 30 pixels
            2'b11: n_h1 = 40; // 40 pixels
            default: n_h1 = 40; // Default to 10 pixels 
        endcase

  end
  else begin
    n_h1 = height1;
  end
  
  if (pixel == 320 && drawDoneCactus) begin
        case (type2)
            2'b00: n_h2 = 15;  // 15 pixels
            2'b01: n_h2 = 20; // 20 pixels
            2'b10: n_h2 = 30; // 30 pixels
            2'b11: n_h2 = 40; // 40 pixels
            default: n_h2 = 40; // Default to 10 pixels 
        endcase

  end
  else begin
    n_h2 = height2;
  end
end

WIN: begin

end

OVER: begin
end

default: begin end

endcase
end

always_ff @(posedge clk, negedge nRst) begin
        if (!nRst) begin
          x_dist <= 180;
          height1 <= 40;
          height2 <= 40;
        end

        else begin
          x_dist <= x_distance;
          height1 <= n_h1;
          height2 <= n_h2;
        end
    end


endmodule