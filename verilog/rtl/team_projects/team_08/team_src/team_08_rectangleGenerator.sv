
module team_08_rectangleGenerator(
    input logic clk,
    input logic nRst,
    input logic [8:0] x,
    input logic [7:0] y,
    input logic [7:0] dinoY,
    input logic [7:0] cactusH1, cactusH2,
    input logic [8:0] x_dist,
    input logic [8:0] cactusX,
    input state_t state,
    output logic r_floor, r_dino, r_cactus, r_cloud, r_idle, r_over, r_win
  );

    logic floor, dino, cactus, cloud, idle, over, win;

    logic [7:0] dinoH = 40;
    logic [8:0] cactusW = 20;

always_ff @( posedge clk ) begin
    if(!nRst) begin 
        r_floor <= '0;
        r_cactus <='0;
        r_dino <= '0;
        r_cloud <= '0;
        r_idle <= '0;
        r_over <= '0;
        r_win <= '0;
    end
    else begin 
        r_floor <= floor;
        r_cactus <= cactus;
        r_dino <= dino;
        r_cloud <= cloud;
        r_idle <= idle;
        r_over <= over;
        r_win <= win;
    end
end
    
always_comb begin
  win = 0;
  over = 0;
  idle = 0;

  case(state)

  IDLE: begin
    if (y <= 100) begin
      floor = 1;
    end

    else begin
      floor = 0;
    end

    dino = 0;
    cactus = 0;
    cloud = 0;
    win = 0;
    over = 0;

    if ((x >= 8 && x <= 24 && y >= 162 && y <= 210) || //right ? 
        (x >= 24 && x <= 56 && y >= 194 && y <= 210) || //top ? 
        (x >= 40 && x <= 56 && y >= 186 && y <= 194) || //left  
        (x >= 24 && x <= 40 && y >= 146 && y <= 162) || //middle ? 
        (x >= 24 && x <= 40 && y >= 130 && y <= 138) || //bottom ? 
        (x >= 64 && x <= 112 && y >= 194 && y <= 210) || // top T 
        (x >= 80 && x <= 96 && y >= 130 && y <= 194) || // bottom T 
        (x >= 120 && x <= 168 && y >= 194 && y <= 210) || // top R 
        (x >= 120 && x <= 136 && y >= 170 && y <= 194) || // top right R 
        (x >= 128 && x <= 136 && y >= 162 && y <= 170) || // middle right R 
        (x >= 120 && x <= 136 && y >= 130 && y <= 162) || // bottom right R 
        (x >= 136 && x <= 152 && y >= 162 && y <= 178) || // middle R 
        (x >= 152 && x <= 168 && y >= 130 && y <= 194) || // left R 
        (x >= 176 && x <= 192 && y >= 130 && y <= 210) || // right A 
        (x >= 200 && x <= 216 && y >= 130 && y <= 210) || // left A 
        (x >= 192 && x <= 200 && y >= 194 && y <= 210) || // top A 
        (x >= 192 && x <= 200 && y >= 162 && y <= 178) || // middle A 
        (x >= 224 && x <= 272 && y >= 194 && y <= 210) || // top T 
        (x >= 240 && x <= 256 && y >= 130 && y <= 194) || // bottom T 
        (x >= 280 && x <= 312 && y >= 194 && y <= 210) || // top S 
        (x >= 296 && x <= 312 && y >= 178 && y <= 194) || // left S 
        (x >= 280 && x <= 312 && y >= 162 && y <= 178) || // middle S 
        (x >= 280 && x <= 296 && y >= 146 && y <= 162) || // right S 
        (x >= 280 && x <= 312 && y >= 130 && y <= 146)) begin // bottom S
          idle = 1; 
        end
    else begin
      idle = 0; 
    end
  end

  RUN: begin
    if (y <= 100) begin
      floor = 1;
    end

    else begin
      floor = 0;
    end

    if ((x >= cactusX && x <= cactusX + cactusW && y >= 101 && y <= 101 + cactusH1) ||
        (x >= cactusX + x_dist && x <= cactusX + x_dist + cactusW && y >= 101 && y <= 101 + cactusH2)) begin
      cactus = 1;
    end
    else begin
      cactus = 0;
    end

    if ((x >= 280 && x <= 288 && y >= dinoY + 32 && y <= dinoY + 38) || (x >= 284 && x <= 288 && y >= dinoY + 14 && y <= dinoY + 32) || //head
        (x >= 282 && x <= 296 && y >= dinoY + 6 && y <= dinoY + 14) || //body
        (x >= 284 && x <= 286 && y >= dinoY && y <= dinoY + 6) || //leg 1  
        (x >= 294 && x <= 296 && y >= dinoY && y <= dinoY + 6) || //leg 2 
        (x >= 296 && x <= 298 && y >= dinoY + 8 && y <= dinoY + 12) || //tail part 1 
        (x >= 298 && x <= 300 && y >= dinoY + 10 && y <= dinoY + 14)) begin //tail part 1 
          dino = 1;
        end
    else begin
      dino = 0;
    end


if(((x >= cactusX + 24 + 10 && x <= cactusX + 10 + 34 && y >= 220 && y <= 222) || 
    (x >= cactusX + 20 + 10 && x <= cactusX + 10 + 16 && y >= 222 && y <= 224) || 
    (x >= cactusX + 24 + 10 && x <= cactusX + 10 + 20 && y >= 224 && y <= 226) || 
    (x >= cactusX + 28 + 10 && x <= cactusX + 10 + 28 && y >= 226 && y <= 228) || 
    (x >= cactusX + 38 + 10 && x <= cactusX + 10 + 32 && y >= 224 && y <= 226) || 
    (x >= cactusX + 42 + 10 && x <= cactusX + 10 + 34 && y >= 224 && y <= 228)) || 
    ((x >= cactusX + x_dist + 10 + 24 && x <= cactusX + x_dist + 10 + 34 && y >= 220 && y <= 222) || 
    (x >= cactusX + x_dist + 10 + 20 && x <= cactusX + x_dist + 10 + 16 && y >= 222 && y <= 224) || 
    (x >= cactusX + x_dist + 10 + 24 && x <= cactusX + x_dist + 10 + 20 && y >= 224 && y <= 226) || 
    (x >= cactusX + x_dist + 10 + 28 && x <= cactusX + x_dist + 10 + 28 && y >= 226 && y <= 228) || 
    (x >= cactusX + x_dist + 10 + 38 && x <= cactusX + x_dist + 10 + 32 && y >= 224 && y <= 226) || 
    (x >= cactusX + x_dist + 10 + 42 && x <= cactusX + x_dist + 10 + 34 && y >= 224 && y <= 228))) begin 
      cloud = 1; 
    end

    else begin 
      cloud = 0; 
    end

    win = 0;
    over = 0;
    idle = 0;

  end

  OVER: begin
    if (y <= 100) begin
      floor = 1;
    end

    else begin
      floor = 0;
    end
    dino = 0;
    cactus = 0;
    cloud = 0;
    win = 0;
    idle = 0;

    if ((x >= 230 && x <= 300 && y >= 120 && y <= 140) || //bottom O
        (x >= 230 && x <= 300 && y >= 200 && y <= 220) || //top O 
        (x >= 280 && x <= 300 && y >= 120 && y <= 220) || //left O 
        (x >= 230 && x <= 250 && y >= 120 && y <= 220) || //right O   
        (x >= 200 && x <= 220 && y >= 150 && y <= 220) || //left v 
        (x >= 150 && x <= 170 && y >= 150 && y <= 220) || //right v 
        (x >= 190 && x <= 210 && y >= 140 && y <= 150) || //left dip v  
        (x >= 160 && x <= 180 && y >= 140 && y <= 150) || //right dip v 
        (x >= 170 && x <= 200 && y >= 120 && y <= 140) || //bottom v 
        (x >= 120 && x <= 140 && y >= 120 && y <= 220) || //left E  
        (x >= 90 && x <= 120 && y >= 200 && y <= 220) || //top E 
        (x >= 90 && x <= 120 && y >= 160 && y <= 180) || //middle E 
        (x >= 90 && x <= 120 && y >= 120 && y <= 140) || //bottom E 
        (x >= 20 && x <= 80 && y >= 200 && y <= 220) || // top R 
        (x >= 60 && x <= 80 && y >= 120 && y <= 200) || // left R 
        (x >= 30 && x <= 60 && y >= 160 && y <= 180) || // middle R 
        (x >= 30 && x <= 40 && y >= 180 && y <= 200) || // top right 1 R 
        (x >= 20 && x <= 30 && y >= 170 && y <= 200) || // top right 2 R 
        (x >= 20 && x <= 40 && y >= 120 && y <= 160)) begin // bottom right R
          over = 1; 
        end
    else begin
      over = 0; 
    end
  end

  WIN: begin
    if (y <= 100) begin
      floor = 1;
    end

    else begin
      floor = 0;
    end

    dino = 0;
    cactus = 0;
    cloud = 0;
    over = 0;
    idle = 0;

    if ((x >= 90 && x <= 110 && y >= 140 && y <= 220) || //top! 
        (x >= 90 && x <= 110 && y >= 120 && y <= 130) || //bottom! 
        (x >= 130 && x <= 150 && y >= 120 && y <= 220) || //right W  
        (x >= 150 && x <= 170 && y >= 120 && y <= 140) || //bottom right W 
        (x >= 170 && x <= 190 && y >= 120 && y <= 170) || //middle 
        (x >= 190 && x <= 210 && y >= 120 && y <= 140) || //bottom left W 
        (x >= 210 && x <= 230 && y >= 120 && y <= 220)) begin //left W 
          win = 1; 
        end
    else begin
      win = 0; 
    end
  end

  default: begin
    cactus = 0;
    dino = 0;
    floor = 0;
    cloud = 0;
    over = 0;
    win = 0;

    if ((x >= 8 && x <= 24 && y >= 162 && y <= 210) || //right ? 
        (x >= 24 && x <= 56 && y >= 194 && y <= 210) || //top ? 
        (x >= 40 && x <= 56 && y >= 186 && y <= 194) || //left  
        (x >= 24 && x <= 40 && y >= 146 && y <= 162) || //middle ? 
        (x >= 24 && x <= 40 && y >= 130 && y <= 138) || //bottom ? 
        (x >= 64 && x <= 112 && y >= 194 && y <= 210) || // top T 
        (x >= 80 && x <= 96 && y >= 130 && y <= 194) || // bottom T 
        (x >= 120 && x <= 168 && y >= 194 && y <= 210) || // top R 
        (x >= 120 && x <= 136 && y >= 170 && y <= 194) || // top right R 
        (x >= 128 && x <= 136 && y >= 162 && y <= 170) || // middle right R 
        (x >= 120 && x <= 136 && y >= 130 && y <= 162) || // bottom right R 
        (x >= 136 && x <= 152 && y >= 162 && y <= 178) || // middle R 
        (x >= 152 && x <= 168 && y >= 130 && y <= 194) || // left R 
        (x >= 176 && x <= 192 && y >= 130 && y <= 210) || // right A 
        (x >= 200 && x <= 216 && y >= 130 && y <= 210) || // left A 
        (x >= 192 && x <= 200 && y >= 194 && y <= 210) || // top A 
        (x >= 192 && x <= 200 && y >= 162 && y <= 178) || // middle A 
        (x >= 224 && x <= 272 && y >= 194 && y <= 210) || // top T 
        (x >= 240 && x <= 256 && y >= 130 && y <= 194) || // bottom T 
        (x >= 280 && x <= 312 && y >= 194 && y <= 210) || // top S 
        (x >= 296 && x <= 312 && y >= 178 && y <= 194) || // left S 
        (x >= 280 && x <= 312 && y >= 162 && y <= 178) || // middle S 
        (x >= 280 && x <= 296 && y >= 146 && y <= 162) || // right S 
        (x >= 280 && x <= 312 && y >= 130 && y <= 146)) begin // bottom S 
          idle = 1; 
        end
    else begin
      idle = 0; 
    end
  end
  endcase
end

endmodule
