module body_wrapper( 
input logic system_clk, body_clk, pause_clk, nreset, good_collision, bad_collision, enable, ///what does enable do????????????
input DIRECTION Direction,
input logic [3:0] x,y,
output logic body, head,
output logic [3:0] head_x, head_y,
output logic [MAX_LENGTH - 1 :0] [3:0] body_x, body_y,
output logic [7:0] score
);

parameter MAX_LENGTH = 30;

logic collision;

body_control main(.main_clk(system_clk), .body_clk(body_clk), .pause_clk(pause_clk), .nrst(nreset), .goodCollision(good_collision), .badCollision(bad_collision),
.enable(enable), .Direction(Direction), .head_x(head_x), .head_y(head_y), .body_x(body_x), .body_y(body_y), .score(score));

collisionLogic col(.next_head({y,x}), .body_x(body_x), .body_y(body_y), .collision(collision));

assign body = (collision);

assign head = ({x,y} == {head_x, head_y});


endmodule