/*
    Module: wire_wire_gen
    Description:
        random the wire_num and wire_color, when the game starts (activate_rand)
    and send the output to other wire modules.
*/
module wire_wire_gen (
    input logic nrst,
    input logic clk,
    input logic activate_rand,
    output logic [2:0] wire_num,
    output logic [5:0][2:0] wire_color
);
    logic [2:0] rand_wire_num;
    logic [5:0][2:0] rand_wire_color;
    logic activate_rand_delay_1;
    logic activate_rand_delay_2;
    
    random_gen_wire_num wire_num_gen ( 
        .nrst(nrst),
        .clk(clk),
        .random_seed(12'd2239),
        .wire_num(rand_wire_num)
    );
    random_gen_wire_color wire_color_gen (
        .nrst(nrst), 
        .clk(clk), 
        .random_seed(18'd5869),
        .wire_num(wire_num),
        .wire_color(rand_wire_color)
    );

    logic [2:0] nxt_wire_num;
    logic [5:0][2:0] nxt_wire_color;

    always_ff @(posedge clk, negedge nrst) begin 
        if(!nrst) begin
            wire_num <= 3'd0;
            wire_color <= 18'd0;
            activate_rand_delay_1 <= 1'b0;
            activate_rand_delay_2 <= 1'b0;
        end else begin
            wire_num <= nxt_wire_num;
            wire_color <= nxt_wire_color;
            activate_rand_delay_1 <= activate_rand;
            activate_rand_delay_2 <= activate_rand_delay_1;
        end
    end

    always_comb begin
        nxt_wire_num = wire_num;
        nxt_wire_color = wire_color;
        if(activate_rand) begin
            nxt_wire_num = rand_wire_num;
        end 
        if (activate_rand_delay_2) begin
            nxt_wire_color = rand_wire_color;
        end
    end
endmodule