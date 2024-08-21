/*
    Module: random_gen_wire_color
        random number generator of size parameter #N bits using XOR gates.
    Description:
    The random number is trigger when the button strobe is detected. 
    This module was so incredibly hard to implement and debug because of metastable asyncrhonous reset
*/
module t07_random_gen_wire_color
(
    input logic clk,
    input logic nrst,
    input logic [17:0] random_seed,
    input logic [2:0] wire_num,
    output logic [17:0] wire_color_bus  // 6 wires, 3 bits color code
);
    // color: 0:red, 1:white, 2:blue, 3:yellow, 4:grey
    localparam NUM_BITS = 18;
    logic [NUM_BITS-1:0] r_LFSR;
    logic [17:0] nxt_wire_color_bus;

    always_ff @(posedge clk, negedge nrst) begin
        if (~nrst) begin
            r_LFSR <= random_seed;
            wire_color_bus <= 18'd0;
        end else begin
            r_LFSR <= {r_LFSR[NUM_BITS-2:0], r_LFSR[NUM_BITS-1] ^~ r_LFSR[6] ^~ r_LFSR[4] ^~ r_LFSR[1]};
            wire_color_bus <= nxt_wire_color_bus;
        end
    end

    always_comb begin
        for(integer i = 0; i < 6; i++) begin
            if (i >= wire_num) begin
                nxt_wire_color_bus[i * 3 +: 3] = 3'd5;
            end else if(r_LFSR[i * 3 +: 3] > 3'd4) begin
                nxt_wire_color_bus[i * 3 +: 3] = r_LFSR[i * 3 +: 3] - 3;
            end else begin
                nxt_wire_color_bus[i* 3 +: 3] = r_LFSR[i * 3 +: 3];
            end
        end
    end // Assign a default value to rand_y
        // Assign a default value to rand_x
endmodule