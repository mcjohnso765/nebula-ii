
module image_generator (
    input logic snakeBody, snakeHead, apple, border, KeyEnc, GameOver, clk, nrst,
    output logic sync, dcx, wr, 
    output logic [7:0] D,
    output logic [3:0] x, y
);


logic cmd_done, enable_loop, init_cycle, en_update, diff;
logic [2:0] obj_code;

fsm_control control(.GameOver(GameOver), .cmd_done(cmd_done), .diff(diff), .clk(clk), .nrst(nrst), .mode_pb(KeyEnc),
                    .enable_loop(enable_loop), .init_cycle(init_cycle), .en_update(en_update), .sync_reset(sync));
frame_tracker tracker(.body(snakeBody), .head(snakeHead), .apple(apple), .border(border), .enable(enable_loop), .clk(clk), .nrst(nrst), .sync(sync), 
                      .obj_code(obj_code), .x(x), .y(y), .diff(diff));
pixel_updater updater(.init_cycle(init_cycle), .en_update(en_update), .clk(clk), .nrst(nrst), .x(x), .y(y), .obj_code(obj_code), 
                      .cmd_done(cmd_done), .wr(wr), .dcx(dcx), .D(D));

endmodule