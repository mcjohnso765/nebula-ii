module BorderGen(
    input logic clk, nrst, enable_in, //game_mode == WALL_INCREASE
    input logic [7:0] score,
    output logic [3:0] XMAX, XMIN, YMAX, YMIN
);

logic [3:0] xmax_n, xmin_n, ymax_n, ymin_n;


always_ff @ (posedge clk, negedge nrst) begin
    if (~nrst) begin
        XMAX = 4'd15;
        XMIN = 4'd0;
        YMAX = 4'd11;
        YMIN = 4'd0;
    end else if (enable_in) begin
        XMAX = xmax_n;
        XMIN = xmin_n;
        YMAX = ymax_n;
        YMIN = ymin_n;
    end else begin
        XMAX = 4'd15;
        XMIN = 4'd0;
        YMAX = 4'd11;
        YMIN = 4'd0;
    end 
end

always_comb begin
    if (score > 100) begin
        xmax_n = 4'd15;
        xmin_n = 4'd0;
        ymax_n = 4'd11;
        ymin_n = 4'd0;
    end
    else if (score > 80) begin 
        xmax_n = 4'd14;
        xmin_n = 4'd0;
        ymax_n = 4'd10;
        ymin_n = 4'd0;
    end
    else if (score > 60) begin 
        xmax_n = 4'd13;
        xmin_n = 4'd0;
        ymax_n = 4'd9;
        ymin_n = 4'd0;
    end
    else if (score > 40) begin 
        xmax_n = 4'd12;
        xmin_n = 4'd0;
        ymax_n = 4'd8;
        ymin_n = 4'd0;
    end
    else if (score > 20) begin 
        xmax_n = 4'd10;
        xmin_n = 4'd0;
        ymax_n = 4'd7;
        ymin_n = 4'd0;
    end
    else if (score > 10) begin 
        xmax_n = 4'd9;
        xmin_n = 4'd0;
        ymax_n = 4'd7;
        ymin_n = 4'd0;
    end
    else begin 
        xmax_n = 4'd8;
        xmin_n = 4'd0;
        ymax_n = 4'd6;
        ymin_n = 4'd0;
    end
end

endmodule 