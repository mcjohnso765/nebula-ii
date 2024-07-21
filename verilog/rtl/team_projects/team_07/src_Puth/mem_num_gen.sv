/*
    Module: mem_num_gen
    Description:
        random the memory game displayNum and labelNum for each stage and position , when the game starts (activate_rand)
    and send the output to other mem_game modules.
*/
module t07_mem_num_gen (
    input logic nrst,
    input logic clk,
    input logic activate_rand,
    output logic [9:0] display_num_bus,    // display number for stage 1-5, 2-bit value vary from 1-4
    output logic [39:0] label_num_bus      // display number for 5 stages, 4 position, 2-bit value vary from 1-4
);
    logic [9:0] rand_display_num_bus;
    logic [39:0] rand_label_num_bus;
    logic [9:0] nxt_display_num_bus;
    logic [39:0] nxt_label_num_bus;

    t07_random_gen_mem_num mem_num_gen ( 
        .nrst(nrst),
        .clk(clk),
        .random_seed(12'd2239),
        .display_num_bus(rand_display_num_bus),
        .label_num_bus(rand_label_num_bus)
    );

    always_ff @(posedge clk, negedge nrst) begin 
        if(!nrst) begin
            display_num_bus <= 10'd0;
            label_num_bus <= 40'd0;
        end else begin
            display_num_bus <= nxt_display_num_bus;
            label_num_bus <= nxt_label_num_bus;
        end
    end

    always_comb begin
        nxt_display_num_bus = display_num_bus;
        nxt_label_num_bus = label_num_bus;
        if(activate_rand) begin
            nxt_display_num_bus = rand_display_num_bus;
            nxt_label_num_bus = rand_label_num_bus;
        end
    end
endmodule