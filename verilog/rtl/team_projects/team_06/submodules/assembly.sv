module assembly (
    input logic clk, nrst, enable,
    input logic keyenc, button_right_in, button_left_in, button_up_in, button_down_in, button_start_pause_in,
    output logic [7:0] d,
    output logic wr, dcx, rert);

    logic [3:0] x, y;
    logic head, body, apple, wall, gameover;
    logic button_reset_in, sync;

    image_generator writer (.clk(clk), .nrst(~nrst), .snakeBody(body), .snakeHead(head), .apple(apple), .border(wall), .KeyEnc(keyenc), .GameOver(gameover), 
                          .sync(button_reset_in), .wr(wr), .dcx(dcx), .D(d), .x(x), .y(y));
    main_file CPU (.clk(clk), .nrst(nrst), .button_right_in(button_right_in), .button_left_in(button_left_in), .button_up_in(button_up_in), .button_down_in(button_down_in),
                   .button_reset_in(button_reset_in), .button_start_pause_in(button_start_pause_in), .enable_total(enable), .x(x), .y(y),
                   .apple(apple), .wall(wall), .body(body), .head(head), .gameover(gameover), .rert(rert));
endmodule

module image_generator (
    input logic snakeBody, snakeHead, apple, border, KeyEnc, GameOver, clk, nrst,
    output logic sync, dcx, wr, 
    output logic [7:0] D,
    output logic [3:0] x, y );


    logic cmd_done, enable_loop, init_cycle, en_update, diff;
    logic [2:0] obj_code;

    fsm_control control(.GameOver(GameOver), .cmd_done(cmd_done), .diff(diff), .clk(clk), .nrst(nrst | sync), .mode_pb(KeyEnc),
                        .enable_loop(enable_loop), .init_cycle(init_cycle), .en_update(en_update), .sync_reset(sync));
    frame_tracker tracker(.body(snakeBody), .head(snakeHead), .apple(apple), .border(border), .enable(enable_loop), .clk(clk), .nrst(sync | nrst), .sync(sync), 
                        .obj_code(obj_code), .x(x), .y(y), .diff(diff));
    pixel_updater updater(.init_cycle(init_cycle), .en_update(en_update), .clk(clk), .nrst(nrst), .x(x), .y(y), .obj_code(obj_code), 
                        .cmd_done(cmd_done), .wr(wr), .dcx(dcx), .D(D));
endmodule

typedef enum logic [1:0] { 
    INIT = 0, LOOP = 1, UPDATE = 2, OVER = 3
} control_state_t;

module fsm_control (
    input logic GameOver, cmd_done, diff, clk, nrst, mode_pb,
    output logic enable_loop, init_cycle, en_update, sync_reset
);

control_state_t current, next;
logic sync, detect;

synchronizer button5(.button(mode_pb), .clk(clk), .nrst(nrst), .signal(sync));
edge_detect detect4(.signal(sync), .clk(clk), .nrst(nrst), .change_state(detect));

always_ff @(posedge clk, negedge nrst) begin
    if (~nrst) begin
        current <= INIT;
    end else begin
        current <= next;
    end
end

always_comb begin
    init_cycle = 1'b0;
    en_update = 1'b0;
    enable_loop = 1'b0;
    sync_reset = 1'b0;
    case (current)
        INIT: begin
            next = (cmd_done) ? LOOP : INIT;
            init_cycle = ~cmd_done;
        end
        LOOP: begin
            enable_loop = ~(diff | GameOver);
            next = (diff) ? UPDATE : (GameOver) ? OVER : LOOP;
        end
        UPDATE: begin
            en_update = ~(cmd_done | GameOver);
            next = (cmd_done) ? LOOP : (GameOver) ? OVER : UPDATE;
        end
        OVER: begin
            next = (detect) ? INIT : OVER;
            sync_reset = ~detect;
        end
    endcase
end
endmodule

module synchronizer (
    input logic button, clk, nrst,
    output logic signal
);

logic [1:0] Q;

always_ff @(posedge clk, negedge nrst)
    if(~nrst)
        Q <= 0;
    else
        Q <= {Q[0], button};

assign signal = Q[1];

endmodule

module edge_detect (
    input logic signal, clk, nrst,
    output logic change_state
);

    logic [1:0] Q;
    always_ff @(posedge clk, negedge nrst)
    if(~nrst)
        Q <= 0;
    else
        Q <= {Q[0], signal};
    
    assign change_state = Q[0] & ~Q[1];
endmodule

module frame_tracker (
    input logic body, head, apple, border, enable, clk, nrst, sync,
    output logic [2:0] obj_code,
    output logic [3:0] x, y,
    output logic diff
);

logic [15:0][11:0][2:0] frame, next_frame;
logic [3:0] current_X, next_X, current_Y, next_Y;
logic next_d;
logic [2:0] temp_obj_code;

always_ff @(posedge clk, negedge nrst) begin
    if(~nrst) begin
        frame <= {16*12{3'b000}};
        {current_X, current_Y} <= {4'b0, 4'b0};
    end
    else begin
        frame <= next_frame;
        {current_X, current_Y} <= {next_X, next_Y};
    end
end

always_comb begin
    {next_X, next_Y} = {current_X, current_Y};
    next_frame = frame;
    if (enable) begin
        if ((current_X == 4'd15) && (current_Y == 4'd11)) begin
            {next_X, next_Y} = {4'b0, 4'b0};
        end else if (current_X == 4'd15) begin
            {next_X, next_Y} = {4'b0, current_Y + 4'd1};
        end else begin
            {next_X, next_Y} = {current_X + 4'd1, current_Y};
        end
    end

    temp_obj_code = frame[current_X][current_Y];

    next_frame = (sync) ? {16*12{3'b000}} : frame;

    next_frame[current_X][current_Y] = (border) ? 3'b100 : (head) ? 3'b001 : (body) ? 3'b010 : (apple) ? 3'b011 : 3'b000;
    obj_code = (border) ? 3'b100 : (head) ? 3'b001 : (body) ? 3'b010 : (apple) ? 3'b011 : 3'b000;
    next_d = (temp_obj_code == 3'b000) ? ~(~border & ~head & ~body & ~apple) : 
             (temp_obj_code == 3'b001) ? ~(~border & head) : 
             (temp_obj_code == 3'b010) ? ~(~border & ~head & body) :
             (temp_obj_code == 3'b011) ? ~(~border & ~head & ~body & apple) :
             (temp_obj_code == 3'b100) ? ~(border) : 1'b0;

    if (temp_obj_code > 4) begin
        {next_frame[current_X][current_Y], obj_code} = {3'b000, 3'b000};
    end

    {x, y, diff} = {current_X, current_Y, next_d};
end
endmodule

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

update_t mode;
logic cmd_finished, pause;
update_controller update(.init_cycle(init_cycle), .en_update(en_update), .clk(clk), .nrst(nrst), .cmd_finished(cmd_finished), .pause(pause),
                  .cmd_done(cmd_done), .wr(wr), .mode(mode));
command_lut2 commands(.mode(mode), .clk(clk), .nrst(nrst), .obj_code(obj_code), .X(x), .Y(y), 
                     .cmd_finished(cmd_finished), .D(D), .dcx(dcx), .pause(pause));
endmodule

module update_controller(
    input logic init_cycle, en_update, clk, nrst, cmd_finished, pause,
    output logic cmd_done, wr,
    output update_t mode );

update_t current, next;

always_comb begin
    wr = 1'b0;
    cmd_done = 1'b0;
    case(current)
        IDLE: next = (init_cycle) ? SET_I : (en_update) ? SET : IDLE;
        SET_I: next = (pause) ? SET_I : SEND_I;
        SET: next = (pause) ? SET : SEND;
        SEND_I: {next, wr} = {(cmd_finished) ? DONE : SET_I, 1'b1};
        SEND: {next, wr} = {(cmd_finished) ? DONE : SET, 1'b1};
        DONE: {next, cmd_done} = {IDLE, 1'b1};
        default: next = IDLE;
    endcase
end

always_ff @(posedge clk, negedge nrst) begin
    if(~nrst) begin
        current <= IDLE;
    end else begin
        current <= next;
    end
end

assign mode = current;
endmodule

module command_lut2(
    input update_t mode,
    input logic clk, nrst, 
    input logic [2:0] obj_code,
    input logic [3:0] X, Y,
    output logic cmd_finished,
    output logic [7:0] D,
    output logic dcx, pause
);

logic [16:0] count, next_count, SC, EC, SP, EP, color;
logic [4:0] cmd_num, next_cmd_num;
logic [15:0] rainbowRNG;

rainbowRand rR1 (.clk(clk), .reset(nrst), .rainbowRNG(rainbowRNG));

always_ff @(posedge clk, negedge nrst) begin
    if(~nrst) begin
        count <= 0;
        cmd_num <= 0;
    end
    else begin
        count <= next_count;
        cmd_num <= next_cmd_num;
    end
end

always_comb begin
    next_count = count;
    pause = 1'b0;
    next_cmd_num = cmd_num;
    color = 16'h0;
    SC = 16'b0;
    EC = 16'b0;
    SP = 16'b0;
    EP = 16'b0;
    D = 8'b0;
    dcx = 1'b0;
    cmd_finished = 1'b0;
    if((mode == SET_I) || (mode == SEND_I)) begin
        if(mode == SET_I) begin
            if(cmd_num == 5'd1 || cmd_num == 5'd5) begin
                if(count > 17'd60000) begin
                    next_count = 0;
                    next_cmd_num = cmd_num + 5'd1;
                    pause = 1'b0;
                end
                else begin
                    next_count = count + 17'b1;
                    next_cmd_num = cmd_num;
                    pause = 1'b1;
                end
            end
            else if (count > 17'd76900) begin
                next_count = 17'd0;
                next_cmd_num = 5'd20;
            end
            else if(cmd_num == 5'd17) begin
                next_cmd_num = 5'd19;
            end
            else if(cmd_num == 5'd18) begin
                next_cmd_num = 5'd19;
                next_count = count + 17'b1;
            end
            else if(cmd_num == 5'd19) begin
                next_cmd_num = 5'd18;
            end
            else begin
                next_cmd_num = cmd_num + 5'd1;
            end

            if(count < 17'd4320) begin
                color = 16'h0814;
            end
            else begin
                color = 16'h1408;
            end
        end
        else begin
            next_cmd_num = cmd_num;
            pause = 1'b0;
            next_count = count;
        end
        cmd_finished = 1'b0;
        case(next_cmd_num)
            5'd1  : {D, dcx} = {8'b00000001, 1'b0};
            5'd2  : {D, dcx} = {8'b00101000, 1'b0};
            5'd3  : {D, dcx} = {8'b00111010, 1'b0};
            5'd4  : {D, dcx} = {8'b01010101, 1'b1};
            5'd5  : {D, dcx} = {8'b00010001, 1'b0};
            5'd6  : {D, dcx} = {8'b00101001, 1'b0};
            5'd7  : {D, dcx} = {8'b00101010, 1'b0};
            5'd8  : {D, dcx} = {8'b00000000, 1'b1};
            5'd9  : {D, dcx} = {8'b00000000, 1'b1};
            5'd10 : {D, dcx} = {8'b00000000, 1'b1};
            5'd11 : {D, dcx} = {8'hF0      , 1'b1};
            5'd12 : {D, dcx} = {8'b00101011, 1'b0};
            5'd13 : {D, dcx} = {8'b00000000, 1'b1};
            5'd14 : {D, dcx} = {8'b00000000, 1'b1};
            5'd15 : {D, dcx} = {8'b00000001, 1'b1};
            5'd16 : {D, dcx} = {8'b01000000, 1'b1};
            5'd17 : {D, dcx} = {8'b00101100, 1'b0};
            5'd18 : {D, dcx} = {color[7:0] , 1'b1};
            5'd19 : {D, dcx} = {color[15:8], 1'b1};
            5'd20: begin    
                D = 8'b00000000;
                dcx = 1'b0;
                cmd_finished = 1'b1;
                if(mode == SEND_I) begin
                    next_cmd_num = 5'b0;
                end
            end
            default: begin
                D = 8'b00000000;
                dcx = 1'b0;
            end
        endcase
        
    end
    else if((mode == SET) || (mode == SEND)) begin
        if(mode == SET) begin
            if(cmd_num == 5'd11) begin
                next_cmd_num = 5'd13;
                next_count = count;
            end
            else if(count >= 17'd900) begin
                next_count = 0;
                next_cmd_num = 5'd14;
            end
            else if(cmd_num == 5'd12) begin
                next_cmd_num = 5'd13;
                next_count = count + 17'b1;
            end
            else if(cmd_num == 5'd13) begin
                next_cmd_num = 5'd12;
                next_count = count + 17'b1;
            end
            else
                next_cmd_num = cmd_num + 5'd1;
        end
        else begin
            next_count = count;
            next_cmd_num = cmd_num;
        end
        SP = X * 20;
        EP = (X + 1) * 20;
        SC = Y * 20;
        EC = (Y + 1) * 20;
        case(obj_code)
            3'b001  : color = 16'h901E;   //head
            3'b010  : color = rainbowRNG; //body
            3'b011  : color = 16'hf800;   //apple
            3'b100  : color = 16'h0814;   //border
            default : color = 16'h1408;
        endcase

        cmd_finished = 1'b0;
        case(next_cmd_num)
            5'd1  : {D, dcx} = {8'h2a, 1'b0};
            5'd2  : {D, dcx} = {SC[15:8], 1'b1};
            5'd3  : {D, dcx} = {SC[7:0], 1'b1};
            5'd4  : {D, dcx} = {EC[15:8], 1'b1};
            5'd5  : {D, dcx} = {EC[7:0], 1'b1};
            5'd6  : {D, dcx} = {8'h2b, 1'b0};
            5'd7  : {D, dcx} = {SP[15:8], 1'b1};
            5'd8  : {D, dcx} = {SP[7:0], 1'b1};
            5'd9  : {D, dcx} = {EP[15:8], 1'b1};
            5'd10 : {D, dcx} = {EP[7:0], 1'b1};
            5'd11 : {D, dcx} = {8'h2c, 1'b0};
            5'd12 : {D, dcx} = {color[7:0], 1'b1};
            5'd13 : {D, dcx} = {color[15:8], 1'b1};
            5'd14 : begin
                {D, dcx} = {8'h00, 1'b0};
                cmd_finished = 1'b1;
                if(mode == SEND) begin
                    next_cmd_num = 5'b0;
                end
            end
            default: {D, dcx} = {8'h00, 1'b0};
        endcase
    end
end

endmodule

module rainbowRand(
    input logic clk,
    input logic reset,
    output logic [15:0] rainbowRNG
);

    logic feedback;

    always_ff @(posedge clk, negedge reset) begin
        if (~reset) begin
            // Initialize LFSR with a non-zero value
            rainbowRNG <= 16'h5a08;
        end else begin
            // Calculate feedback
            feedback = rainbowRNG[15] ^ rainbowRNG[13] ^ rainbowRNG[12] ^ rainbowRNG[10];
            // Shift left and insert the feedback bit
            rainbowRNG <= {rainbowRNG[14:0], feedback};
        end
    end

endmodule