module command_lut2(
    input logic[2:0] mode,
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
logic enable;
logic apple_rgb;

// rainbowRand rR1 (.clk(clk), .reset(nrst), .rainbowRNG(rainbowRNG));

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
    if(obj_code == 4'b010) begin
        enable = 1;
    end else begin
        enable = 0;
    end
end

//apple_sprite as1 (.count(count[9:0]), .apple_rgb(apple_rgb));
rainbowRand rR1 (.clk(clk), .reset(nrst), .rainbowRNG(rainbowRNG), .enable(enable));

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
                color = 16'h0000;
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
        5'd1: begin
            D = 8'b00000001;
            dcx = 1'b0;
        end
        5'd2: begin
            D = 8'b00101000;
            dcx = 1'b0;
        end
        5'd3: begin
            D = 8'b00111010;
            dcx = 1'b0;
        end
        5'd4: begin
            D = 8'b01010101;
            dcx = 1'b1;
        end
        5'd5: begin
            D = 8'b00010001;
            dcx = 1'b0;
        end
        5'd6: begin
            D = 8'b00101001;
            dcx = 1'b0;
        end
        5'd7: begin
            D = 8'b00101010;
            dcx = 1'b0;
        end
        5'd8: begin
            D = 8'h00;
            dcx = 1'b1;
        end
        5'd9: begin
            D = 8'h00;
            dcx = 1'b1;
        end
        5'd10: begin
            D = 8'h00;
            dcx = 1'b1;
        end
        5'd11: begin
            D = 8'hF0;
            dcx = 1'b1;
        end
        5'd12: begin
            D = 8'b00101011;
            dcx = 1'b0;
        end
        5'd13: begin
            D = 8'h00;
            dcx = 1'b1;
        end
        5'd14: begin
            D = 8'h00;
            dcx = 1'b1;
        end
        5'd15: begin
            D = 8'h01;
            dcx = 1'b1;
        end
        5'd16: begin
            D = 8'h40;
            dcx = 1'b1;
        end
        5'd17: begin
            D = 8'b00101100;
            dcx = 1'b0;
        end
        5'd18: begin
            D = color[7:0];
            dcx = 1'b1;
        end
        5'd19: begin
            D = color[15:8];
            dcx = 1'b1;
        end
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
        3'b000: begin //blank
            color = 16'h1408;
        end
        3'b001: begin //head
            color = 16'h901E;
        end
        3'b010: begin //body
            color = rainbowRNG;
        end
        3'b011: begin //apple
            // if(apple_rgb == 1) begin 
            //     color = 16'h00f8;
            // end else begin
            //     color = 16'h1408;
            // end
            color = 16'h00f8;
        end
        3'b100: begin //border
            color = 16'h0000;
        end
        default: begin
            color = 16'h1408;
        end
        endcase

        cmd_finished = 1'b0;
        case(next_cmd_num)
        5'd1: begin
            D = 8'b00101010;
            dcx = 1'b0;
        end
        5'd2: begin
            D = SC[15:8];
            dcx = 1'b1;
        end
        5'd3: begin
            D = SC[7:0];
            dcx = 1'b1;
        end
        5'd4: begin
            D = EC[15:8];
            dcx = 1'b1;
        end
        5'd5: begin
            D = EC[7:0];
            dcx = 1'b1;
        end
        5'd6: begin
            D = 8'b00101011;
            dcx = 1'b0;
        end
        5'd7: begin
            D = SP[15:8];
            dcx = 1'b1;
        end
        5'd8: begin
            D = SP[7:0];
            dcx = 1'b1;
        end
        5'd9: begin
            D = EP[15:8];
            dcx = 1'b1;
        end
        5'd10: begin
            D = EP[7:0];
            dcx = 1'b1;
        end
        5'd11: begin
            D = 8'b00101100;
            dcx = 1'b0;
        end
        5'd12: begin
            D = color[7:0];
            dcx = 1'b1;
        end
        5'd13: begin
            D = color[15:8];
            dcx = 1'b1;
        end
        5'd14: begin    
            D = 8'b00000000;
            dcx = 1'b0;
            cmd_finished = 1'b1;
            if(mode == SEND) begin
                next_cmd_num = 5'b0;
            end
        end
        default: begin
            D = 8'b0;
            dcx = 1'b0;
        end
        endcase
    end
end

endmodule