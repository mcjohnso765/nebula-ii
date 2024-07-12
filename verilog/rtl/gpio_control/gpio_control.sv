//This is a module to give addresses to gpio configuration registers

//needs a wishbone wrapper
//needs to support alternate function for designs
//needs to support 8 pins per pad


module gpio_control #(
    parameter NUM_TEAMS = 12
)
(
    input logic clk,
    input logic nrst,
    input wire [38*(NUM_TEAMS+1)-1:0] designs_gpio_out_flat,  
    input wire [38*(NUM_TEAMS+1)-1:0] designs_gpio_oeb_flat,

    //select lines that are being sent from a set of registers
    //the wishbone bus can write to
    input logic [31:0] pin_0to7_sel,
    input logic [31:0] pin_8to15_sel,
    input logic [31:0] pin_16to23_sel, 
    input logic [31:0] pin_24to31_sel, 
    input logic [23:0] pin_32to37_sel, 

    //muxxed output to the gpio pins
    output logic [37:0] muxxed_io_oeb,
    output logic [37:0] muxxed_io_out
    
);

integer idx_0to7;
integer idx_8to15;
integer idx_16to23;
integer idx_24to31;
integer idx_32to37;

logic [37:0] io_oeb [NUM_TEAMS:0]; 
logic [37:0] io_out [NUM_TEAMS:0];

integer i;
always @* begin
    for (i = 0; i <= NUM_TEAMS; i = i + 1) begin
        io_out[i] = designs_gpio_out_flat[i*38 +: 38];
        io_oeb[i] = designs_gpio_oeb_flat[i*38 +: 38];
    end
end

always @(*) begin
    for(idx_0to7 = 0; idx_0to7 <= 7; idx_0to7++) begin
        muxxed_io_oeb[idx_0to7] = io_oeb[pin_0to7_sel[idx_0to7*4 +: 4]][idx_0to7[5:0]];
        muxxed_io_out[idx_0to7] = io_out[pin_0to7_sel[idx_0to7*4 +: 4]][idx_0to7[5:0]];
    end
    for(idx_8to15 = 0; idx_8to15 <= 7; idx_8to15++) begin
        muxxed_io_oeb[idx_8to15 + 8] = io_oeb[pin_8to15_sel[idx_8to15*4 +: 4]][idx_8to15[5:0] + 8];
        muxxed_io_out[idx_8to15 + 8] = io_out[pin_8to15_sel[idx_8to15*4 +: 4]][idx_8to15[5:0] + 8];
    end
    for(idx_16to23 = 0; idx_16to23 <= 7; idx_16to23++) begin
        muxxed_io_oeb[idx_16to23 + 16] = io_oeb[pin_16to23_sel[idx_16to23*4 +: 4]][idx_16to23[5:0] + 16];
        muxxed_io_out[idx_16to23 + 16] = io_out[pin_16to23_sel[idx_16to23*4 +: 4]][idx_16to23[5:0] + 16];
    end
    for(idx_24to31 = 0; idx_24to31 <= 7; idx_24to31++) begin
        muxxed_io_oeb[idx_24to31 + 24] = io_oeb[pin_24to31_sel[idx_24to31*4 +: 4]][idx_24to31[5:0] + 24];
        muxxed_io_out[idx_24to31 + 24] = io_out[pin_24to31_sel[idx_24to31*4 +: 4]][idx_24to31[5:0] + 24];
    end
    for(idx_32to37 = 0; idx_32to37 <= 5; idx_32to37++) begin
        muxxed_io_oeb[idx_32to37 + 32] = io_oeb[pin_32to37_sel[idx_32to37*4 +: 4]][idx_32to37[5:0] + 32];
        muxxed_io_out[idx_32to37 + 32] = io_out[pin_32to37_sel[idx_32to37*4 +: 4]][idx_32to37[5:0] + 32];
    end

end

endmodule