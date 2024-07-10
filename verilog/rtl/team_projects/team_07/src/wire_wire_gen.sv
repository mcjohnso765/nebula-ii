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
    output logic [2:0] wire_color_0,
    output logic [2:0] wire_color_1,
    output logic [2:0] wire_color_2,
    output logic [2:0] wire_color_3,
    output logic [2:0] wire_color_4,
    output logic [2:0] wire_color_5
);
    logic [2:0]wire_color[5:0];
    
    assign    wire_color_0= wire_color[0];
    assign    wire_color_1 = wire_color[1];
    assign    wire_color_2 = wire_color[2];
    assign    wire_color_3 = wire_color[3];
    assign    wire_color_4 = wire_color[4];
    assign    wire_color_5 = wire_color[5];
    
    //initilize wire_color
    logic [2:0] rand_wire_num;
    logic [2:0] rand_wire_color[5:0];
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
        .wire_color_0(rand_wire_color[0]),
        .wire_color_1(rand_wire_color[1]),
        .wire_color_2(rand_wire_color[2]),
        .wire_color_3(rand_wire_color[3]),
        .wire_color_4(rand_wire_color[4]),
        .wire_color_5(rand_wire_color[5])
    );

    logic [2:0] nxt_wire_num;
    logic [2:0] nxt_wire_color[5:0];

    always_ff @(posedge clk, negedge nrst) begin 
        if(!nrst) begin
            wire_num <= 3'd0;
            for (int i = 0; i < 6; i++) begin
              wire_color[i] <= 3'd0;
            end
            activate_rand_delay_1 <= 1'b0;
            activate_rand_delay_2 <= 1'b0;
        end else begin
            wire_num <= nxt_wire_num;
            for (int i = 0; i < 6; i++) begin
              wire_color[i] <= nxt_wire_color[i];
            end
            activate_rand_delay_1 <= activate_rand;
            activate_rand_delay_2 <= activate_rand_delay_1;
        end
    end

    always_comb begin
        nxt_wire_num = wire_num;
            for (int i = 0; i < 6; i++) begin
              nxt_wire_color[i] = wire_color[i];
            end
        if(activate_rand) begin
            nxt_wire_num = rand_wire_num;
        end 
        if (activate_rand_delay_2) begin
            for (int i = 0; i < 6; i++) begin
              nxt_wire_color[i] = rand_wire_color[i];
            end
        end
    end
endmodule