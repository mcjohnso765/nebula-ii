module curr_length_increment (
    input logic button, clk, nrst, sync,
    output logic [6:0] curr_length
);

    logic button_i, button_a;
    logic [6:0] count, next_count;
    synchronizer synch(.button(button), .clk(clk), .nrst(nrst), .signal(button_i));
    edge_detect detect(.signal(button_i), .clk(clk), .nrst(nrst), .change_state(button_a));

    always_ff @(posedge clk, negedge nrst)
    if(~nrst)
        count <= 0;
    else
        count <= next_count;
    
    always_comb begin
        if(button_a) 
            next_count = count + 7'b1;
        else if (sync)
            next_count = 0;
        else
            next_count = count;
    end

endmodule