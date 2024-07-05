module obstacleMode (
    input logic sync_reset, obstacle_pb, clk, nrst,
    output logic obstacleFlag
);
    logic nextObstacleFlag, obstacle_pb_o;

    obstacle_sync_edge sOBSMODE (.clk(clk), .nRst_i(nrst), .button_i(obstacle_pb), .pb_o(obstacle_pb_o));

    // always_ff @(posedge clk, negedge nrst) begin
    //     if(~nrst) begin
    //         obstacleFlag <= 0;
    //     end else begin
    //         obstacleFlag <= nextObstacleFlag;
    //     end
    // end

    always_comb begin
        nextObstacleFlag = 0;
        if(sync_reset == 1) begin
            if (obstacle_pb_o == 1) begin
                nextObstacleFlag = 1;
            end
        end 
    end
    
    assign obstacleFlag = nextObstacleFlag;
endmodule
