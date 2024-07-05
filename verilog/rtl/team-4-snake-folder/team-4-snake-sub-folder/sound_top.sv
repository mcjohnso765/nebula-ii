`default_nettype none
typedef enum logic {
    OFF = 1'b0,
    ON = 1'b1
} MODE_TYPES;
module top (
    // I/O ports
    input logic hz100, reset,
    input logic [20:0] pb,
    output logic [7:0] left, right,
           ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
    output logic red, green, blue,

    // UART ports
    output logic [7:0] txdata,
    input logic [7:0] rxdata,
    output logic txclk, rxclk,
    input logic txready, rxready
);
    logic clk, rst;
    logic goodColl_i, badColl_i, toggleMode_i;
    logic goodColl, badColl, toggleMode;

    logic [3:0] direction_i;
    logic [3:0] newDirection;

    logic [7:0] freq;
    logic playSound;
    MODE_TYPES mode_o;
    logic at_max;
    logic [7:0] soundOut;
    logic [1:0] junk;

    assign clk = hz100;
    assign rst = reset;
    assign direction_i = {pb[13], pb[5], pb[8], pb[10]};
    assign goodColl_i = pb[0];
    assign badColl_i = pb[1];
    assign toggleMode_i = pb[2];
    assign soundOut = {left[7], left[6], left[5], left[4], left[3], left[2], junk};

    posedge_detector posDetector1 (.clk(clk), .nRst(~rst), .button_i(toggleMode_i), .button(toggleMode), .goodColl_i(goodColl_i), .badColl_i(badColl_i), .direction_i(direction_i), .goodColl(goodColl), .badColl(badColl), .direction(newDirection));
    freq_selector_12M freq_12 (.freq(freq), .goodColl_i(goodColl_i), .badColl_i(badColl_i), .direction_i(direction_i));
    sound_fsm fsm1 (.playSound(playSound), .mode_o(mode_o), .clk(clk), .nRst(~rst), .goodColl(goodColl), .badColl(badColl), .button(toggleMode), .direction(newDirection));
    oscillator osc1 (.at_max(at_max), .clk(clk), .nRst(~rst), .freq(freq), .state(mode_o), .playSound(playSound));
    dac_counter dac1 (.dacCount(soundOut), .clk(clk), .nRst(~rst), .at_max(at_max));

endmodule

module dac_counter 
#(
    parameter N = 8
)
(
    input logic clk, nRst, at_max,
    output logic [N - 1:0] dacCount
);

logic [N - 1:0] dacCount_nxt;
always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
        dacCount <= 0;
    end else begin
        dacCount <= dacCount_nxt;
    end
end

always_comb begin
    if (at_max)
        dacCount_nxt = dacCount + 1;
    else
        dacCount_nxt = dacCount;
end

endmodule

module posedge_detector (
    input logic clk, nRst, goodColl_i, badColl_i, button_i,
    input logic [3:0] direction_i,
    output logic goodColl, badColl, button,
    output logic [3:0] direction
);

logic [6:0] N;
logic [6:0] sig_out;
logic [6:0] posEdge;

always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
        N <= 7'b0;
        sig_out <= 7'b0;
    end else begin
        N <= {goodColl_i, badColl_i, button_i, direction_i};
        sig_out <= N;
    end
end
assign posEdge = N & ~sig_out | (N & sig_out);

assign goodColl = N[6] & ~sig_out[6] | (N[6] & sig_out[6]);
assign badColl = N[5] & ~sig_out[5] | (N[5] & sig_out[5]);
assign button = N[4] & ~sig_out[4];
assign direction = N[3:0] & ~sig_out[3:0] | (N[3:0] & sig_out[3:0]);

endmodule

// 10M is for final chip
module freq_selector_10M(
    input logic goodColl_i, badColl_i,
    input logic [3:0] direction_i,
    output logic [7:0] freq
);

always_comb begin
    freq = 0;
    if (goodColl_i)
        freq = 8'd89; // 10M / ((1/440) / 256) - A
    if (badColl_i)
        freq = 8'd126; // 10M / ((1/311) / 256) - D Sharp
    if (|direction_i)
        freq = 8'd149; // 10M / ((1/262) / 256) - C
end

endmodule

// 12M is for FPGA
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

module sound_fsm(
    input logic clk, nRst, goodColl, badColl, button,
    input logic [3:0] direction,
    output logic playSound,
    output MODE_TYPES mode_o // current state
);
MODE_TYPES next_state;
logic next_playSound;
always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
        mode_o <= ON;
        playSound <= 0;
    end else begin
        mode_o <= next_state;
        playSound <= next_playSound;
    end
end

always_comb begin
    next_playSound = playSound;
    next_state = mode_o;
    if (mode_o == ON) begin
        if (button) begin
            next_state = OFF;
        end
        next_playSound = (goodColl || badColl || |direction) ? 1'b1 : 1'b0;
    end else begin
        if (button) begin
            next_state = ON;
        end
        next_playSound = 1'b0;
    end
end
   
endmodule

module oscillator
#(
    parameter N = 8
)
(
    input logic clk, nRst,
    input logic [7:0] freq,
    input MODE_TYPES state,
    input logic playSound,
    output logic at_max
);
logic [N - 1:0] count, count_nxt;
logic at_max_nxt;
always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
        count <= 0;
        at_max <= 0;
    end else begin
        count <= count_nxt;
        at_max <= at_max_nxt;
    end
end
always_comb begin
    at_max_nxt = at_max;
    count_nxt = count;
    if (at_max == 1'b1) begin
        at_max_nxt = 1'b0;
    end
    if (state == ON && playSound) begin
        if (count < freq) begin
            count_nxt = count + 1;
        end else if (count >= freq) begin 
            at_max_nxt = 1'b1;
            count_nxt = 0;
        end
    end else if (state == OFF || ~playSound) begin
        count_nxt = 0;
        at_max_nxt = 1'b0;
    end
end

endmodule
