module frame_tracker (
    input logic body, head, apple, border, enable, clk, nrst, sync,
    output logic [2:0] obj_code,
    output logic [3:0] x, y,
    output logic diff
);

logic [15:0][11:0][2:0] frame, next_frame;
logic [3:0] current_X, next_X, current_Y, next_Y;
logic next_d, d, pulse;
logic [2:0] temp_obj_code;
logic [2:0] count, next_count;
/* generate 
    for(genvar i = 0; i < 16; i = i + 1) begin
        for(genvar j = 0; j < 12; j = j + 1) begin
            always_ff @(posedge clk, negedge nrst) begin
                if(~nrst) begin
                    frame[i][j] <= 3'b000;
                end
                else begin
                    frame[i][j] <= next_frame;
                end
            end
        end
    end
endgenerate */

always_ff @(posedge clk, negedge nrst) begin
    if(~nrst) begin
        {frame[0], frame[1], frame[2], frame[3], frame[4], frame[5], frame[6], frame[7],
        frame[8], frame[9], frame[10], frame[11], frame[12], frame[13], frame[14], frame[15]} <= 
        {16*12{3'b000}};
    end
    else begin
        frame <= next_frame;
    end
end


always_ff @(posedge clk, negedge nrst) begin
    if(~nrst) begin
        current_X <= 4'b0;
        current_Y <= 4'b0;
        //d <= 3'b0;
    end
    else begin
        current_X <= next_X;
        current_Y <= next_Y;
        //d <= next_d;
    end

end

always_ff @(posedge clk, negedge nrst) begin
    if(~nrst) begin
        count <= 0;
    end
    else
        count <= next_count;
end

always_comb begin
    if(count == 2) begin
        pulse = 1'b1;
        next_count= 3'b0;
    end
    else begin
        next_count = count + 3'b1;
        pulse = 1'b0;
    end
end

always_comb begin
    next_X = current_X;
    next_Y = current_Y;
    next_d = 1'b0;
    next_frame = frame;
    if(enable) begin
        if((current_X == 4'd15) && (current_Y == 4'd11)) begin
            next_X = 4'b0;
            next_Y = 4'b0;
        end
        else if(current_X == 4'd15) begin
            next_X = 4'b0;
            next_Y = current_Y + 4'd1;
        end
        else begin
            next_X = current_X + 4'd1;
            next_Y = current_Y;
        end
    end
    else if(sync) begin
        next_X = 0;
        next_Y = 0;
    end
    else begin
        next_X = current_X;
        next_Y = current_Y;
    end
    temp_obj_code = frame[current_X][current_Y];
    if(sync) begin
        {next_frame[0], next_frame[1], next_frame[2], next_frame[3], next_frame[4], next_frame[5], next_frame[6], next_frame[7],
        next_frame[8], next_frame[9], next_frame[10], next_frame[11], next_frame[12], next_frame[13], next_frame[14], next_frame[15]} = 
        {16*12{3'b000}};
    end
    else begin
        next_frame = frame;
    end
    case(temp_obj_code)
    3'b000: begin
        if(border) begin
            next_frame[current_X][current_Y] = 3'b100;
            obj_code = 3'b100;
            next_d = 1'b1;
        end
        else if(head) begin
            next_frame[current_X][current_Y] = 3'b001;
            obj_code = 3'b001;
            next_d = 1'b1;
        end
        else if(body) begin
            next_frame[current_X][current_Y] = 3'b010;
            obj_code = 3'b010;
            next_d = 1'b1;
        end
        else if(apple) begin
            next_frame[current_X][current_Y] = 3'b011;
            obj_code = 3'b011;
            next_d = 1'b1;
        end
        else begin
            next_frame[current_X][current_Y] = 3'b000;
            obj_code = 3'b000;
            next_d = 1'b0;
        end
    end
    3'b001: begin
        if(border) begin
            next_frame[current_X][current_Y] = 3'b100;
            obj_code = 3'b100;
            next_d = 1'b1;
        end
        else if(head) begin
            next_frame[current_X][current_Y] = 3'b001;
            obj_code = 3'b001;
            next_d = 1'b0;
        end
        else if(body) begin
            next_frame[current_X][current_Y] = 3'b010;
            obj_code = 3'b010;
            next_d = 1'b1;
        end
        else if(apple) begin
            next_frame[current_X][current_Y] = 3'b011;
            obj_code = 3'b011;
            next_d = 1'b1;
        end
        else begin
            next_frame[current_X][current_Y] = 3'b000;
            obj_code = 3'b000;
            next_d = 1'b1;
        end
    end
    3'b010: begin
        if(border) begin
            next_frame[current_X][current_Y] = 3'b100;
            obj_code = 3'b100;
            next_d = 1'b1;
        end
        else if(head) begin
            next_frame[current_X][current_Y] = 3'b001;
            obj_code = 3'b001;
            next_d = 1'b1;
        end
        else if(body) begin
            next_frame[current_X][current_Y] = 3'b010;
            obj_code = 3'b010;
            next_d = 1'b0;
        end
        else if(apple) begin
            next_frame[current_X][current_Y] = 3'b011;
            obj_code = 3'b011;
            next_d = 1'b1;
        end
        else begin
            next_frame[current_X][current_Y] = 3'b000;
            obj_code = 3'b000;
            next_d = 1'b1;
        end
    end
    3'b011: begin
        if(border) begin
            next_frame[current_X][current_Y] = 3'b100;
            obj_code = 3'b100;
            next_d = 1'b1;
        end
        else if(head) begin
            next_frame[current_X][current_Y] = 3'b001;
            obj_code = 3'b001;
            next_d = 1'b1;
        end
        else if(body) begin
            next_frame[current_X][current_Y] = 3'b010;
            obj_code = 3'b010;
            next_d = 1'b1;
        end
        else if(apple) begin
            next_frame[current_X][current_Y] = 3'b011;
            obj_code = 3'b011;
            next_d = 1'b0;
        end
        else begin
            next_frame[current_X][current_Y] = 3'b000;
            obj_code = 3'b000;
            next_d = 1'b1;
        end
    end        
    3'b100: begin
        if(border) begin
            next_frame[current_X][current_Y] = 3'b100;
            obj_code = 3'b100;
            next_d = 1'b0;
        end
        else if(head) begin
            next_frame[current_X][current_Y] = 3'b001;
            obj_code = 3'b001;
            next_d = 1'b1;
        end
        else if(body) begin
            next_frame[current_X][current_Y] = 3'b010;
            obj_code = 3'b010;
            next_d = 1'b1;
        end
        else if(apple) begin
            next_frame[current_X][current_Y] = 3'b011;
            obj_code = 3'b011;
            next_d = 1'b1;
        end
        else begin
            next_frame[current_X][current_Y] = 3'b000;
            obj_code = 3'b000;
            next_d = 1'b1;
        end
    end
    default: begin
        next_frame[current_X][current_Y] = 3'b000;
        obj_code = 3'b000;
        next_d = 1'b0;  
    end
    endcase

/* 
    if((current_X == 4'd0) || (current_X == 4'd15) || (current_Y == 4'd0) || (current_Y == 4'd11)) begin
        if((frame[current_X][current_Y] != 3'b100) && (border)) begin
            next_d = 1'b1;
            next_frame[current_X][current_Y] = 3'b100;
            obj_code = 3'b100;
        end
        else begin
            next_d = 1'b0;
            next_frame[current_X][current_Y] = frame[current_X][current_Y];
            obj_code = frame[current_X][current_Y];
        end
    end
    else if((body) && (frame[current_X][current_Y] != 3'b010)) begin
        next_d = 1'b1;
        next_frame[current_X][current_Y] = 3'b010;
        obj_code = 3'b010;
    end
    else if((head) && (frame[current_X][current_Y] != 3'b001)) begin
        next_d = 1'b1;
        next_frame[current_X][current_Y] = 3'b001;
        obj_code = 3'b001;
    end
    else if((apple) && (frame[current_X][current_Y] != 3'b011)) begin
        next_d = 1'b1;
        next_frame[current_X][current_Y] = 3'b011;
        obj_code = 3'b011;
    end
    else if(~(apple || head || body || border) && (frame[current_X][current_Y] != 3'b000)) begin
        next_d = 1'b1;
        next_frame[current_X][current_Y] = 3'b000;
        obj_code = 3'b000;
    end
    else begin
        next_d = 1'b0;
        next_frame[current_X][current_Y] = frame[current_X][current_Y];
        obj_code = frame[current_X][current_Y];
    end */
end

assign x = current_X;
assign y = current_Y;
assign diff = next_d;
endmodule