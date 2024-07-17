module t07_generate_rectangle(
    input logic clk,
    input logic nrst,
    input logic [8:0] x,
    input logic [7:0] y,
    output logic r_floor, r_dino, r_cactus
    );

    //x start 270 
    //x ends 310 

    //y start 140
    // y ends 200

    // always_comb begin
    //     if ((x >= 270 && x <= 272) && (y >= 142 && y <= 144))
    //     unsycnh_rectangle_pixel = 1;
    //     else 
    //     unsycnh_rectangle_pixel = 0;
    // end
    logic floor, dino, cactus;
    logic [8:0] cactusX = 250;
    logic [7:0] dinoY = 151;
    logic [8:0] x_dist = 60;
    logic [7:0] cactusH1 = 20;
    logic [7:0] cactusH2 = 40;
    logic [7:0] dinoH = 40;
    logic [8:0] cactusW = 20;
always_comb begin
  if (y <= 150) begin
    floor = 1;
  end

  else begin
    floor = 0;
  end

  if ((x >= cactusX && x <= cactusX + cactusW && y >= 151 && y <= 151 + cactusH1) ||
  (x >= cactusX - x_dist && x <= cactusX - x_dist + cactusW && y >= 151 && y <= 151 + cactusH2)) begin
    cactus = 1;
  end
  else
    cactus = 0;

  if (x >= 20 && x <= 40 && y >= dinoY && y <= dinoY + dinoH)
    dino = 1;
  else
    dino = 0;
end


always_ff @( posedge clk ) begin
    if(!nrst) begin 
        r_floor <= '0;
        r_cactus <='0;
        r_dino <= '0;
    end
    else begin 
        r_floor <= floor;
        r_cactus <= cactus;
        r_dino <= dino;
    end
end

endmodule