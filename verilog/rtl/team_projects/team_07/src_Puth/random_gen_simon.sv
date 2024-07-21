/*
    Module: random_gen_simon.sv
    Description:
        Generate a random number (1-4), for stage 1-5 for simon game
    no consecutive sequences are the same
*/
module t07_random_gen_simon
(
    input logic nrst,
    input logic clk,
    input logic [11:0] random_seed,
    output logic [9:0] simon_sequence_bus    // color number for stage 1-5, value vary from 1-4
);
    logic [9:0] nxt_simon_sequence_bus;
    localparam NUM_BITS = 12;
    logic [NUM_BITS-1:0] r_LFSR;

    always_ff @(posedge clk, negedge nrst) begin
        if (~nrst) begin
            r_LFSR <= random_seed;
            simon_sequence_bus <= 10'd0;
        end else begin
            r_LFSR <= {r_LFSR[NUM_BITS-2:0], r_LFSR[NUM_BITS-1] ^~ r_LFSR[6] ^~ r_LFSR[4] ^~ r_LFSR[1]};
            simon_sequence_bus <= nxt_simon_sequence_bus;
        end
    end

    always_comb begin
        nxt_simon_sequence_bus = r_LFSR[9:0];
        for(integer i = 1; i < 5; i++) begin
            if (nxt_simon_sequence_bus[i * 2 +: 2] == nxt_simon_sequence_bus[(i - 1) * 2 +: 2]) begin
                if(nxt_simon_sequence_bus[i * 2 +: 2] == 2'd3) nxt_simon_sequence_bus[i * 2 +: 2] = 2'd0;
                else nxt_simon_sequence_bus[i * 2 +: 2] = nxt_simon_sequence_bus[i * 2 +: 2] + 1;
            end
        end
    end // Assign a default value to rand_y
        // Assign a default value to rand_x
endmodule