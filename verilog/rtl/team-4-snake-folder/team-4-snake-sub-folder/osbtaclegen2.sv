module obstaclegen2 #(parameter MAX_LENGTH = 50) (
    input logic [MAX_LENGTH - 1:0][7:0] body,
    input logic clk, nRst, goodColl, obstacleFlag,
    input logic [3:0] randX, randY, x, y,
    output logic obstacle
);

    logic [7:0] cornerNE, cornerNW, cornerSE, cornerSW, randCord, cord, randCordCombo, cordCombo;
    logic [139:0] obstacleArray, nextObstacleArray;
    logic obsNeeded, isObsNeeded, arraySet, isArraySet, isObstacle, randError;
    logic [4:0] obstacleCount, nextObstacleCount; 

    always_ff @(posedge clk, negedge nRst) begin
        if (nRst == 0 || obstacleFlag == 0) begin
            obstacleCount <= 5'b0;
            obstacleArray <= 140'b0;
            obsNeeded     <= 1'b0;
            arraySet      <= 1'b0;
            obstacle      <= 1'b0;
        end else begin
            obstacleCount <= nextObstacleCount;
            obstacleArray <= nextObstacleArray;
            obsNeeded     <= isObsNeeded;
            arraySet      <= isArraySet;
            obstacle      <= isObstacle;
        end
    end

    always_comb begin
        isObsNeeded = obsNeeded;
        randCord = {randX, randY};
        cord = {x, y};
        randCordCombo = {4'b0, randX} + ({4'b0, randY} - 1) * 14;
        cordCombo = {4'b0, x} + ({4'b0, y} - 1) * 14;
        randError = 0;
        nextObstacleCount = obstacleCount;
        nextObstacleArray = obstacleArray;
        isArraySet = arraySet;
        cornerNE = 0;
        cornerNW = 0;
        cornerSE = 0;
        cornerSW = 0;
        isObstacle = 0;
        if(obstacleFlag == 1)begin
            if (obstacleCount < 25) begin
                if (goodColl == 1) begin
                    if (obsNeeded == 0) begin
                        isObsNeeded = 1;
                        isArraySet = 0;
                    end else begin
                        isObsNeeded = 0;
                    end
                end

                if (obsNeeded == 1 || arraySet == 0) begin
                    for (int i = 0; i < MAX_LENGTH; i++) begin
                        if (randCord == body[i]) begin
                            randError = 1;
                        end
                    end
                    if (randCord == body[0] + 1 || 
                        randCord == body[0] - 1 || 
                        randCord == body[0] + 32 || 
                        randCord == body[0] - 32) begin
                        randError = 1;
                    end

                    if (randX == 1 || randY == 1) begin
                        cornerNW = randCordCombo;
                    end else begin
                        cornerNW = randCordCombo - 15;
                    end
                    if (randX == 14 || randY == 1) begin
                        cornerNE = randCordCombo;
                    end else begin
                        cornerNE = randCordCombo - 13;
                    end
                    if (randX == 1 || randY == 10) begin
                        cornerSW = randCordCombo;
                    end else begin
                        cornerSW = randCordCombo + 13;
                    end
                    if (randX == 14 || randY == 10) begin
                        cornerSE = randCordCombo;
                    end else begin
                        cornerSE = randCordCombo + 15;
                    end

                    if (obstacleArray[cornerNW] || 
                        obstacleArray[cornerNE] || 
                        obstacleArray[cornerSW] || 
                        obstacleArray[cornerSE] || 
                        obstacleArray[randCordCombo]) begin
                        randError = 1;
                    end

                    if (randError == 0) begin
                        nextObstacleArray[randCordCombo] = 1;
                        nextObstacleCount = obstacleCount + 1;
                        isArraySet = 1;
                    end else begin
                        isArraySet = 0;
                    end
                end
            end

            if (obstacleArray[cordCombo]) begin
                isObstacle = 1;
            end
        end
    end

endmodule
