module t10_disp_fsm (
    input logic clk, nRst, ready, gameEnd,
    input logic [7:0] msg,
    output logic [127:0] row1, row2
);

logic [79:0] guesses, next_guess;

always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
        guesses <= {8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111}; // _ x10 in ASCII
    end else if (gameEnd) begin 
        guesses <= {8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111}; // _ x10 in ASCII
    end else begin
        guesses <= next_guess;
    end
end

always_comb begin
    if (ready) begin
        next_guess = {msg, guesses[79:8]};
        row1 = {8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, msg, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000};
        row2 = {8'b00100000, 8'b00100000, 8'b00100000, guesses, 8'b00100000, 8'b00100000, 8'b00100000};
    end
    else begin
        next_guess = guesses;
        row1 = {8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, msg, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000};
        row2 = {8'b00100000, 8'b00100000, 8'b00100000, guesses, 8'b00100000, 8'b00100000, 8'b00100000};
    end
end
endmodule
