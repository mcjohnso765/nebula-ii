// Empty top module

// make another always_ff block: feed good collision through synchronizer,
// make positive edge detector,
// set next_apple_set to zero if there is a rising edge on good collision

module applegenerator2 #(parameter MAX_LENGTH = 50) (
    input logic [3:0] x, y, randX, randY,
    input logic goodColl, clk, reset, s_reset, // s_reset: like n_reset, synchronizer reset for apple
    input logic [MAX_LENGTH - 1:0][7:0] body,
    output logic apple
);

    logic [7:0] apple_cord, next_apple_cord, randCord;
    logic appleSet, next_apple_set, randError;

    always_comb begin
        next_apple_set = appleSet;
        next_apple_cord = apple_cord;
        randError = 0;
        randCord = {randX, randY};

        // if (goodColl == 1) begin
        // next_apple_set = 0;
        // end

        if (goodColl == 1 || appleSet == 0) begin
            for (int i = 0; i < MAX_LENGTH; i++) begin
                if (randCord == body[i]) begin
                    randError = 1;
                end
            end
            if (randError == 0) begin
                next_apple_set = 1;
                next_apple_cord = {randX, randY};
            end
            else begin
                next_apple_set = 0;
            end
        end

        if (apple_cord == {x,y}) begin
            apple = 1;
        end
        else begin
            apple = 0;
        end

        if (s_reset) begin
            next_apple_cord = 8'b11000101; // default location
        end

    end

    always_ff @(posedge clk, negedge reset) begin
        if (~reset) begin
            apple_cord <= 8'b11000101;
            appleSet <= 1;
        end else begin
            apple_cord <= next_apple_cord;
            appleSet <= next_apple_set;
        end
    end

endmodule
