module obstacleMode (
    input logic sync_reset, obstacle_pb, clk, nrst,
    output logic obstacleFlag
);
    logic osbtacle_pb_i, obstacle_pb_o, nextObstacleFlag;

    obstacle_sync_edge sOBSMODE (.clk(clk), .nRst_i(nrst), .button_i(obstacle_pb), .pb_o(obstacle_pb_o));

    //synchronizer obsS(.button(obstacle_pb), .clk(clk), .nrst(nrst), .signal(osbtacle_pb_i));
    //edge_detect obsED(.signal(osbtacle_pb_i), .clk(clk), .nrst(nrst), .change_state(osbtacle_pb_o));

    always_ff @(posedge clk, negedge nrst) begin
        if(~nrst) begin
            obstacleFlag <= 0;
        end else begin
            obstacleFlag <= nextObstacleFlag;
        end
    end

    // always_comb begin
    //     obstacleFlag = 0;
    //     if(sync_reset == 0) begin
    //         if (obstacle_pb_o == 1) begin
    //             obstacleFlag = 1;
    //         end
    //     end 
    // end

    always_comb begin
        nextObstacleFlag = obstacleFlag;
        if (obstacle_pb_o == 1) begin
            if(obstacleFlag == 1) begin
                nextObstacleFlag = 0;
            end else begin
                nextObstacleFlag = 1;
            end
        end 
    end
endmodule
