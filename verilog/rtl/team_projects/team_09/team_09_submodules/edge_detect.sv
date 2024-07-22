module edge_detect (
    input logic signal, clk, nrst,
    output logic change_state
);

    logic [1:0] Q;
    always_ff @(posedge clk, negedge nrst)
    if(~nrst)
        Q <= 0;
    else
        Q <= {Q[0], signal};
    
    assign change_state = Q[0] & ~Q[1];
endmodule