module random (
  input logic clk,
  input logic nRst,
  output logic [3:0] randX, randY
);

logic [3:0] next_randX;
logic [3:0] next_randY;

always_ff @(posedge clk, negedge nRst) begin
	if(nRst == 0) begin
		randX <= 4'b0101;
		randY <= 4'b0001;
	end else begin
		randX <= next_randX;
		randY <= next_randY; 
	end
end

always_comb begin
    next_randX = randX;
    if(randX >= 14 && randY == 10) begin
	    next_randX = 1;
    end else if (randY == 10) begin
        next_randX = randX + 1;
    end

    next_randY = randY + 1;
    if(next_randY > 10) begin
	      next_randY = 1;
    end
end
endmodule
