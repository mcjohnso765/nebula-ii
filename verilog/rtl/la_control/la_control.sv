//this
//is
//just
//a
//mux
module la_control #(
    parameter NUM_TEAMS = 12
)
(
    input logic clk,
    input logic nrst,

    //sel lines and lines to be selected between
    input logic [3:0] la_sel,
    input wire [32*(NUM_TEAMS+1)-1:0] designs_la_data_out_flat,

    //muxxed output
    output logic [31:0] muxxed_la_dat
);

logic [31:0] la_dat [NUM_TEAMS:0];

integer i;
always @* begin : just_some_wizardry
    for (i = 0; i <= NUM_TEAMS; i = i + 1) begin
        la_dat[i] = designs_la_data_out_flat[i*32 +: 32];
    end
end

always_comb begin : just_a_mux
    muxxed_la_dat = la_dat[la_sel];
end

endmodule