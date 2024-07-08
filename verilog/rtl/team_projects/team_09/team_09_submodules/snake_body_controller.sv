typedef enum logic[2:0] { 
    LEFT = 0, RIGHT = 1, UP = 2, DOWN = 3, STOP = 4 
} direction_t;

module snake_body_controller #(parameter MAX_LENGTH = 50) (
    input logic [3:0] direction_pb, x, y,
    input logic clk, pb_mode, nrst, sync,
    input logic [7:0] curr_length, 
    output logic [MAX_LENGTH - 1 : 0][7:0] body,
    output logic snakeHead, snakeBody
);

logic [MAX_LENGTH - 1: 0][7:0] temp_body;
logic pulse, snake_head, snake_body;
logic [2:0] direction;
logic [3:0] direction_i, direction_a;
logic [7:0] head;

variable_clock_divider divider(.clk(clk), .nrst(nrst), .button(pb_mode), .adjusted_clk(pulse));
synchronizer button1(.button(direction_pb[0]), .clk(clk), .nrst(nrst), .signal(direction_i[0]));
synchronizer button2(.button(direction_pb[1]), .clk(clk), .nrst(nrst), .signal(direction_i[1]));
synchronizer button3(.button(direction_pb[2]), .clk(clk), .nrst(nrst), .signal(direction_i[2]));
synchronizer button4(.button(direction_pb[3]), .clk(clk), .nrst(nrst), .signal(direction_i[3]));
edge_detect detect1(.signal(direction_i[0]), .clk(clk), .nrst(nrst), .change_state(direction_a[0]));
edge_detect detect2(.signal(direction_i[1]), .clk(clk), .nrst(nrst), .change_state(direction_a[1]));
edge_detect detect3(.signal(direction_i[2]), .clk(clk), .nrst(nrst), .change_state(direction_a[2]));
edge_detect detect4(.signal(direction_i[3]), .clk(clk), .nrst(nrst), .change_state(direction_a[3]));


fsm_direction fsm(.direction_a(direction_a), .clk(clk), .nrst(nrst), .pulse(pulse), .sync(sync), .direction(direction));
update_body #(MAX_LENGTH) body_update(.clk(clk), .nrst(nrst), .pulse(pulse), .sync(sync), .direction(direction), .curr_length(curr_length), .body(temp_body), .head(head));
location_check #(MAX_LENGTH) check(.coordinate({x, y}), .body(temp_body), .curr_length(curr_length), .clk(clk), .nrst(nrst), .snakeBody(snakeBody), .snakeHead(snakeHead));
//hello world
assign body = temp_body;







endmodule