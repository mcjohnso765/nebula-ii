/*
    Module: random_gen_wire_color
        random number generator of size parameter #N bits using XOR gates.
    Description:
    The random number is trigger when the button strobe is detected. 
    This module was so incredibly hard to implement and debug because of metastable asyncrhonous reset
*/
module random_gen_wire_color
(
    input logic clk,
    input logic nrst,
    input logic [17:0] random_seed,
    input logic [2:0] wire_num,
    output logic [2:0] wire_color_0,
    output logic [2:0] wire_color_1,
    output logic [2:0] wire_color_2,
    output logic [2:0] wire_color_3,
    output logic [2:0] wire_color_4,
    output logic [2:0] wire_color_5
);  
    logic [2:0] wire_color[5:0];
    initial begin
        wire_color_0= wire_color[0];
        wire_color_1 = wire_color[1];
        wire_color_2 = wire_color[2];
        wire_color_3 = wire_color[3];
        wire_color_4 = wire_color[4];
        wire_color_5 = wire_color[5];
    end
    // color: 0:red, 1:white, 2:blue, 3:yellow, 4:grey
    localparam NUM_BITS = 18;
    logic [NUM_BITS-1:0] r_LFSR;

    always_ff @(posedge clk, negedge nrst) begin
        if (~nrst) begin
            r_LFSR <= random_seed;
        end else begin
            r_LFSR <= {r_LFSR[NUM_BITS-2:0], r_LFSR[NUM_BITS-1] ^~ r_LFSR[6] ^~ r_LFSR[4] ^~ r_LFSR[1]};
        end
    end

    always @(posedge clk) begin
        for(integer i = 0; i < 6; i++) begin
            if (i >= wire_num) begin
                wire_color[i] <= 3'd5;
            end else if(r_LFSR[i * 3 +: 3] > 3'd4) begin
                wire_color[i] <= r_LFSR[i * 3 +: 3] - 3;
            end else begin
                wire_color[i] <= r_LFSR[i * 3 +: 3];
            end
        end
    end // Assign a default value to rand_y
        // Assign a default value to rand_x
endmodule