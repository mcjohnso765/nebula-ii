/*
    Module: simon_sequence_gen
    Description:
        random the simon_sequence and wire_color, when the game starts (activate_rand)
    and send the output to other wire modules.
*/
module t07_simon_sequence_gen (
    input logic nrst,
    input logic clk,
    input logic activate_rand,
    output logic [9:0] simon_sequence_bus  // 5 stages, 2-bit color code 1-4
);
    logic [9:0] nxt_simon_sequence_bus;
    logic [9:0] rand_simon_sequence_bus;

    t07_random_gen_simon random_gen_simon_0 ( 
        .nrst(nrst),
        .clk(clk),
        .random_seed(12'd1867),
        .simon_sequence_bus(rand_simon_sequence_bus)
    );

    always_ff @(posedge clk, negedge nrst) begin 
        if(!nrst) begin
            simon_sequence_bus <= 10'd0;
        end else begin
            simon_sequence_bus <= nxt_simon_sequence_bus;
        end
    end

    always_comb begin
        nxt_simon_sequence_bus = simon_sequence_bus;
        if(activate_rand) begin
            nxt_simon_sequence_bus = rand_simon_sequence_bus;
        end 
    end
endmodule