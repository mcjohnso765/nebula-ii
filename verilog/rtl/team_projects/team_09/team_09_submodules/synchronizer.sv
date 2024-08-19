module synchronizer (
    input logic button, clk, nrst,
    output logic signal
);

logic [1:0] Q;

always_ff @(posedge clk, negedge nrst)
    if(~nrst)
        Q <= 0;
    else
        Q <= {Q[0], button};

assign signal = Q[1];

endmodule