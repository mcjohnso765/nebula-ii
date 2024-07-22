module rainbowRand(
    input logic clk,
    input logic reset,
    input logic enable,
    output logic [15:0] rainbowRNG
);

logic [15:0] next_rainbowRNG;

always_ff @(posedge clk, negedge reset) begin
	if(reset == 0) begin
		rainbowRNG <= 0;
	end else begin
		rainbowRNG <= next_rainbowRNG;
	end
end

always_comb begin
    if(enable == 1) begin
        next_rainbowRNG = rainbowRNG;
    end
    else begin
        if(rainbowRNG + 1 > 65535) begin
	        next_rainbowRNG = 1;
        end
        else begin
            next_rainbowRNG = rainbowRNG + 1;
        end
    end
end
endmodule

// module rainbowRand(
//     input logic clk,
//     input logic reset,
//     input logic enable,
//     output logic [15:0] rainbowRNG
// );

//     logic feedback; 
//     logic [15:0] next_rainbowRNG;

//     always_ff @(posedge clk, negedge reset) begin
//         if (~reset) begin
//             feedback = 0;
//             // Initialize LFSR with a non-zero value
//             rainbowRNG <= 16'h5a08;
//         end else begin
//             // Calculate feedback
//             feedback = rainbowRNG[15] ^ rainbowRNG[13] ^ rainbowRNG[12] ^ rainbowRNG[10];
//             // Shift left and insert the feedback bit
//             rainbowRNG <= next_rainbowRNG;
//         end
//     end

//     always_comb begin
//         if(enable == 1) begin
//             next_rainbowRNG = rainbowRNG;
//         end else begin
//             next_rainbowRNG = {rainbowRNG[14:0], feedback};
//         end


//     end

// endmodule
