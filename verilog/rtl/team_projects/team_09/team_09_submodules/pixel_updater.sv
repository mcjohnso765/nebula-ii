typedef enum logic [2:0] { 
    IDLE = 0, SET_I = 1, SET = 2, SEND_I = 3, SEND = 4, DONE = 5, OVER_SET = 6, OVER_SEND = 7
} update_t;

module pixel_updater (
    input logic init_cycle, en_update, clk, nrst,
    input logic [3:0] x, y,
    input logic [2:0] obj_code,
    output logic cmd_done, wr, dcx,
    output logic [7:0] D
);

logic [2:0] mode;
logic cmd_finished, pause;
update_controller update(.init_cycle(init_cycle), .en_update(en_update), .clk(clk), .nrst(nrst), .cmd_finished(cmd_finished), .pause(pause),
                  .cmd_done(cmd_done), .wr(wr), .mode(mode));
command_lut2 commands(.mode(mode), .clk(clk), .nrst(nrst), .obj_code(obj_code), .X(x), .Y(y), 
                     .cmd_finished(cmd_finished), .D(D), .dcx(dcx), .pause(pause));



endmodule