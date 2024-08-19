/*
    Module: random_gen_pos
        random number generator of size parameter #N bits using XOR gates.
    Description:
    The random number is trigger when the button strobe is detected.    
    The output is between parameter #min and #max.
    This module was so incredibly hard to implement and debug because of metastable asyncrhonous reset

*/
// For now make random_gen can be set to output set_x and set_y

module t07_random_gen_maze_pos
(
    input logic clk,
    input logic nrst,
    input logic [11:0] random_seed,
    output logic [2:0] rand_y,
    output logic [2:0] rand_x
);

    localparam NUM_BITS = 12;
    logic [NUM_BITS-1:0] r_LFSR;
    logic [2:0] nxt_rand_y;
    logic [2:0] nxt_rand_x;

    always_ff @(posedge clk, negedge nrst) begin
        if (~nrst) begin
            r_LFSR <= random_seed;
            rand_x <= 3'd0;
            rand_y <= 3'd0;
        end else begin
            r_LFSR <= {r_LFSR[NUM_BITS-2:0], r_LFSR[NUM_BITS-1] ^~ r_LFSR[6] ^~ r_LFSR[4] ^~ r_LFSR[1]};
            rand_x <= nxt_rand_x;
            rand_y <= nxt_rand_y;
        end
    end

    always_comb begin
        if(r_LFSR[2:0] > 5 && r_LFSR[11:9] <= 5) begin
            nxt_rand_y = r_LFSR[2:0] - 2;
            nxt_rand_x = r_LFSR[11:9];
        end
        else if(r_LFSR[2:0] <= 5 && r_LFSR[11:9] > 5)begin 
            nxt_rand_y = r_LFSR[2:0];
            nxt_rand_x = r_LFSR[11:9] - 2;
        end  
        else if(r_LFSR[2:0] > 5 && r_LFSR[11:9] > 5)begin 
            nxt_rand_y = r_LFSR[2:0] - 4;
            nxt_rand_x = r_LFSR[11:9] - 2;
        end 
        else begin
            nxt_rand_y = r_LFSR[2:0];
            nxt_rand_x = r_LFSR[11:9];
        end
    end // Assign a default value to rand_y
        // Assign a default value to rand_x
endmodule