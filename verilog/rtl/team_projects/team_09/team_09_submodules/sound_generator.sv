
module sound_generator
#(
    parameter N = 8
)
(
    input logic clk, rst, goodColl_i, badColl_i, button_i,
    output logic [N - 1:0] soundOut
);

    logic goodColl, badColl, toggleMode;
    logic [3:0] newDirection;

    logic [7:0] freq;
    logic playSound;
    logic at_max;

    sound_posedge_detector posDetector1 (.clk(clk), .nRst(~rst), .button_i(button_i), .goodColl_i(goodColl_i), .badColl_i(badColl_i),  .goodColl(goodColl), .badColl(badColl));
    
    oscillator osc1 (.at_max(at_max), .clk(clk), .nRst(~rst), .goodColl(goodColl), .badColl(badColl));
    dac_counter dac1 (.dacCount(soundOut), .clk(clk), .nRst(~rst), .at_max(at_max));
endmodule
