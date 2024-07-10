/*
    Module: random_gen_ms
        random number generator rand_num as map_select for maze game
    Description:
    The random number is trigger when the button strobe is detected.    
    The output is between parameter #min and #max.
    This module was so incredibly hard to implement and debug because of metastable asyncrhonous reset

*/
// For now make random_gen can be set to output set_x and set_y

module random_gen_maze_ms
(
    input logic clk,
    input logic nrst,
    input logic [11:0] random_seed,
    output logic [2:0] rand_num
);
    localparam NUM_BITS = 12;
    logic [NUM_BITS-1:0] r_LFSR;

    always_ff @(posedge clk, negedge nrst) begin
        if (~nrst) begin
            r_LFSR <= random_seed;
        end else begin
            r_LFSR <= {r_LFSR[NUM_BITS-2:0], r_LFSR[NUM_BITS-1] ^~ r_LFSR[6] ^~ r_LFSR[4] ^~ r_LFSR[1]};
        end
    end

    always @(posedge clk) begin
        if(r_LFSR[11:9] > 4) begin
            rand_num = r_LFSR[11:9] - 4;
        end else begin
            rand_num = r_LFSR[11:9];
        end
    end // Assign a default value to rand_num

endmodule