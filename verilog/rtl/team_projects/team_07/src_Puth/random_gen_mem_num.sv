/*
    Module: random_gen_mem_num.sv
    Description:
        Generate a random number (1-4), for display and button order 1-4, for stage 1-5
*/
module t07_random_gen_mem_num
(
    input logic nrst,
    input logic clk,
    input logic [11:0] random_seed,
    output logic [9:0] display_num_bus,    // display number for stage 1-5, 2-bit value vary from 1-4
    output logic [39:0] label_num_bus      // display number for 5 stages, 4 position, 2-bit value vary from 1-4
);
    logic [39:0] nxt_label_num_bus;
    logic [9:0] nxt_display_num_bus;
    localparam NUM_BITS = 12;
    logic [NUM_BITS-1:0] r_LFSR;

    always_ff @(posedge clk, negedge nrst) begin
        if (~nrst) begin
            r_LFSR <= random_seed;
            display_num_bus <= 10'd0;
            label_num_bus[0 * 8 +: 8] <= {2'd0, 2'd1, 2'd2, 2'd3};
            label_num_bus[1 * 8 +: 8] <= {2'd0, 2'd1, 2'd2, 2'd3};
            label_num_bus[2 * 8 +: 8] <= {2'd0, 2'd1, 2'd2, 2'd3};
            label_num_bus[3 * 8 +: 8] <= {2'd0, 2'd1, 2'd2, 2'd3};
            label_num_bus[4 * 8 +: 8] <= {2'd0, 2'd1, 2'd2, 2'd3};
        end else begin
            r_LFSR <= {r_LFSR[NUM_BITS-2:0] , r_LFSR[NUM_BITS-1] ^~ r_LFSR[6] ^~ r_LFSR[4] ^~ r_LFSR[1] };
            display_num_bus <= nxt_display_num_bus;
            label_num_bus[0 * 8 +: 8] <= nxt_label_num_bus[0 * 8 +: 8];
            label_num_bus[1 * 8 +: 8] <= nxt_label_num_bus[1 * 8 +: 8];
            label_num_bus[2 * 8 +: 8] <= nxt_label_num_bus[2 * 8 +: 8];
            label_num_bus[3 * 8 +: 8] <= nxt_label_num_bus[3 * 8 +: 8];
            label_num_bus[4 * 8 +: 8] <= nxt_label_num_bus[4 * 8 +: 8];
        end
    end

    always_comb begin
        nxt_display_num_bus = r_LFSR[9:0];
        for(integer i = 0; i < 5; i++) begin
            case (i)
                0: begin
                    case (r_LFSR[1:0])
                        2'd0: nxt_label_num_bus[0 * 8 +: 8] = {label_num_bus[0 * 8 + 1 * 2 +: 2], label_num_bus[0 * 8 + 2 * 2 +: 2], label_num_bus[0 * 8 + 3 * 2 +: 2], label_num_bus[0 * 8 + 0 * 2 +: 2]};
                        2'd1: nxt_label_num_bus[0 * 8 +: 8] = {label_num_bus[0 * 8 + 0 * 2 +: 2], label_num_bus[0 * 8 + 1 * 2 +: 2], label_num_bus[0 * 8 + 2 * 2 +: 2], label_num_bus[0 * 8 + 3 * 2 +: 2]};
                        2'd2: nxt_label_num_bus[0 * 8 +: 8] = {label_num_bus[0 * 8 + 1 * 2 +: 2], label_num_bus[0 * 8 + 0 * 2 +: 2], label_num_bus[0 * 8 + 3 * 2 +: 2], label_num_bus[0 * 8 + 2 * 2 +: 2]};
                        2'd3: nxt_label_num_bus[0 * 8 +: 8] = {label_num_bus[0 * 8 + 2 * 2 +: 2], label_num_bus[0 * 8 + 3 * 2 +: 2], label_num_bus[0 * 8 + 0 * 2 +: 2], label_num_bus[0 * 8 + 1 * 2 +: 2]};
                    endcase
                end
                1:begin
                    case (r_LFSR[1:0])
                        2'd0: nxt_label_num_bus[1 * 8 +: 8] = {label_num_bus[1 * 8 + 2 * 2 +: 2], label_num_bus[1 * 8 + 3 * 2 +: 2], label_num_bus[1 * 8 + 1 * 2 +: 2], label_num_bus[1 * 8 + 0 * 2 +: 2]};
                        2'd1: nxt_label_num_bus[1 * 8 +: 8] = {label_num_bus[1 * 8 + 1 * 2 +: 2], label_num_bus[1 * 8 + 2 * 2 +: 2], label_num_bus[1 * 8 + 0 * 2 +: 2], label_num_bus[1 * 8 + 3 * 2 +: 2]};
                        2'd2: nxt_label_num_bus[1 * 8 +: 8] = {label_num_bus[1 * 8 + 3 * 2 +: 2], label_num_bus[1 * 8 + 0 * 2 +: 2], label_num_bus[1 * 8 + 1 * 2 +: 2], label_num_bus[1 * 8 + 2 * 2 +: 2]};
                        2'd3: nxt_label_num_bus[1 * 8 +: 8] = {label_num_bus[1 * 8 + 2 * 2 +: 2], label_num_bus[1 * 8 + 0 * 2 +: 2], label_num_bus[1 * 8 + 3 * 2 +: 2], label_num_bus[1 * 8 + 1 * 2 +: 2]};
                    endcase
                end
                2:begin
                    case (r_LFSR[1:0])
                        2'd0: nxt_label_num_bus[2 * 8 +: 8] = {label_num_bus[2 * 8 + 3 * 2 +: 2], label_num_bus[2 * 8 + 2 * 2 +: 2], label_num_bus[2 * 8 + 1 * 2 +: 2], label_num_bus[2 * 8 + 0 * 2 +: 2]};
                        2'd1: nxt_label_num_bus[2 * 8 +: 8] = {label_num_bus[2 * 8 + 2 * 2 +: 2], label_num_bus[2 * 8 + 1 * 2 +: 2], label_num_bus[2 * 8 + 0 * 2 +: 2], label_num_bus[2 * 8 + 3 * 2 +: 2]};
                        2'd2: nxt_label_num_bus[2 * 8 +: 8] = {label_num_bus[2 * 8 + 1 * 2 +: 2], label_num_bus[2 * 8 + 2 * 2 +: 2], label_num_bus[2 * 8 + 3 * 2 +: 2], label_num_bus[2 * 8 + 0 * 2 +: 2]};
                        2'd3: nxt_label_num_bus[2 * 8 +: 8] = {label_num_bus[2 * 8 + 1 * 2 +: 2], label_num_bus[2 * 8 + 3 * 2 +: 2], label_num_bus[2 * 8 + 0 * 2 +: 2], label_num_bus[2 * 8 + 2 * 2 +: 2]};
                    endcase
                end
                3:begin
                    case (r_LFSR[1:0])
                        2'd0: nxt_label_num_bus[3 * 8 +: 8] = {label_num_bus[3 * 8 + 1 * 2 +: 2], label_num_bus[3 * 8 + 0 * 2 +: 2], label_num_bus[3 * 8 + 3 * 2 +: 2], label_num_bus[3 * 8 + 2 * 2 +: 2]};
                        2'd1: nxt_label_num_bus[3 * 8 +: 8] = {label_num_bus[3 * 8 + 2 * 2 +: 2], label_num_bus[3 * 8 + 0 * 2 +: 2], label_num_bus[3 * 8 + 1 * 2 +: 2], label_num_bus[3 * 8 + 3 * 2 +: 2]};
                        2'd2: nxt_label_num_bus[3 * 8 +: 8] = {label_num_bus[3 * 8 + 3 * 2 +: 2], label_num_bus[3 * 8 + 1 * 2 +: 2], label_num_bus[3 * 8 + 0 * 2 +: 2], label_num_bus[3 * 8 + 2 * 2 +: 2]};
                        2'd3: nxt_label_num_bus[3 * 8 +: 8] = {label_num_bus[3 * 8 + 0 * 2 +: 2], label_num_bus[3 * 8 + 3 * 2 +: 2], label_num_bus[3 * 8 + 2 * 2 +: 2], label_num_bus[3 * 8 + 1 * 2 +: 2]};
                    endcase
                end
                4:begin
                    case (r_LFSR[1:0])
                        2'd0: nxt_label_num_bus[4 * 8 +: 8] = {label_num_bus[4 * 8 + 0 * 2 +: 2], label_num_bus[4 * 8 + 2 * 2 +: 2], label_num_bus[4 * 8 + 3 * 2 +: 2], label_num_bus[4 * 8 + 1 * 2 +: 2]};
                        2'd1: nxt_label_num_bus[4 * 8 +: 8] = {label_num_bus[4 * 8 + 0 * 2 +: 2], label_num_bus[4 * 8 + 3 * 2 +: 2], label_num_bus[4 * 8 + 1 * 2 +: 2], label_num_bus[4 * 8 + 2 * 2 +: 2]};
                        2'd2: nxt_label_num_bus[4 * 8 +: 8] = {label_num_bus[4 * 8 + 1 * 2 +: 2], label_num_bus[4 * 8 + 2 * 2 +: 2], label_num_bus[4 * 8 + 3 * 2 +: 2], label_num_bus[4 * 8 + 0 * 2 +: 2]};
                        2'd3: nxt_label_num_bus[4 * 8 +: 8] = {label_num_bus[4 * 8 + 2 * 2 +: 2], label_num_bus[4 * 8 + 0 * 2 +: 2], label_num_bus[4 * 8 + 3 * 2 +: 2], label_num_bus[4 * 8 + 1 * 2 +: 2]};
                    endcase
                end
                default:;
            endcase
        end
    end // Assign a default value to rand_y
        // Assign a default value to rand_x
endmodule