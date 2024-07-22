// module obstacle_random (
//   input logic clk, nRst, obstacleFlag,
//   output logic [3:0] randX, randY, randX2, randY2
// );

// logic [3:0] next_randX, next_randX2;
// logic [3:0] next_randY, next_randY2;

// always_ff @(posedge clk, negedge nRst) begin
// 	if(nRst == 0) begin
// 		randX <= 4'b0101;
// 		randY <= 4'b0001;
//         randX2 <= 4'b0100;
//         randY2 <= 4'b0001;
// 	end else begin
// 		randX <= next_randX;
// 		randY <= next_randY; 
//         randX2 <= next_randX2;
// 		randY2 <= next_randY2; 
// 	end
// end

// always_comb begin
//     next_randY = randY + 1;
//     if(next_randY > 10) begin
// 	      next_randY = 1;
//     end

//     next_randX2 = randX2;
//     next_randY2 = randY2;
//     if(obstacleFlag == 1) begin
//         next_randX = randX + 1;
//         if(next_randX > 14) begin
// 	        next_randX = 1;
//         end

//         next_randX2 = randX2 + 1;
//         if(next_randX2 > 14) begin
// 	        next_randX2 = 1;
//         end

//         next_randY2 = randY2 + 1;
//         if(next_randY2 > 10) begin
// 	      next_randY2 = 1;
//         end
//     end else begin
//         next_randX = randX;
//         if(randX >= 14 && randY == 10) begin
// 	        next_randX = 1;
//         end else if (randY == 10) begin
//             next_randX = randX + 1;
//         end
//     end
// end
// endmodule

module obstacle_random (
  input logic clk, nRst, obstacleFlag,
  output logic [3:0] randX, randY, randX2, randY2
);

logic [3:0] next_randX, next_randX2;
logic [3:0] next_randY, next_randY2;

always_ff @(posedge clk, negedge nRst) begin
	if(nRst == 0) begin
		randX <= 4'b1000;
		randY <= 4'b0010;
        randX2 <= 4'b0011;
        randY2 <= 4'b0100; //0101
	end else begin
		randX <= next_randX;
		randY <= next_randY; 
        randX2 <= next_randX2;
		randY2 <= next_randY2; 
	end
end

always_comb begin
    next_randY = randY + 1;
    if(next_randY > 10) begin
	      next_randY = 1;
    end

    next_randX2 = randX2;
    next_randY2 = randY2;
    if(obstacleFlag == 1) begin
        next_randX = randX + 1;
        if(next_randX > 14) begin
	        next_randX = 1;
        end

        next_randX2 = randX2 + 1;
        if(next_randX2 > 14) begin
	        next_randX2 = 1;
        end

        next_randY2 = randY2 + 1;
        if(next_randY2 > 10) begin
	      next_randY2 = 1;
        end
    // if(obstacleFlag == 1) begin
    //     next_randX = randX + 1;
    //     if(next_randX > 14) begin
	//         next_randX = 1;
    //     end

    //     next_randX2 = randX2 + 1;
    //     if(next_randX2 > 12) begin
	//         next_randX2 = 3;
    //     end

    //     next_randY2 = randY2 + 1;
    //     if(next_randY2 > 8) begin
	//       next_randY2 = 3;
    //     end
    end else begin
        next_randX = randX;
        if(randX >= 14 && randY == 10) begin
	        next_randX = 1;
        end else if (randY == 10) begin
            next_randX = randX + 1;
        end
    end
end
endmodule
