module freq_selector_12M(
    input logic goodColl_i, badColl_i,
    input logic [3:0] direction_i,
    output logic [7:0] freq
);

always_comb begin
    freq = 0;
    if (goodColl_i)
        freq = 8'd107; // 12M / ((1/440) / 256) - A
    if (badColl_i)
        freq = 8'd151; // 12M / ((1/311) / 256) - D Sharp
    if (|direction_i)
        freq = 8'd179; // 12M / ((1/262) / 256) - C
end

endmodule
