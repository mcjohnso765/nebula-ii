/*
    Module: random_gen_wire_num
        random number generator of size parameter #N bits using XOR gates.
    Description:
    The random number is trigger when the button strobe is detected. 

    This module was so incredibly hard to implement and debug because of metastable asyncrhonous reset

*/
module t07_random_gen_wire_num
(
    input logic clk,
    input logic nrst,
    input logic [11:0] random_seed,
    output logic [2:0] wire_num
);
    localparam NUM_BITS = 12;
    logic [NUM_BITS-1:0] r_LFSR;
    logic [2:0] nxt_wire_num;

    always_ff @(posedge clk, negedge nrst) begin
        if (~nrst) begin
            r_LFSR <= random_seed;
            wire_num <= 3'd0;
        end else begin
            r_LFSR <= {r_LFSR[NUM_BITS-2:0], r_LFSR[NUM_BITS-1] ^~ r_LFSR[6] ^~ r_LFSR[4] ^~ r_LFSR[1]};
            wire_num <= nxt_wire_num;
        end
    end

    always_comb begin
        nxt_wire_num = 3'd3 + r_LFSR[1:0];
    end // Assign a default value to rand_y
        // Assign a default value to rand_x
endmodule