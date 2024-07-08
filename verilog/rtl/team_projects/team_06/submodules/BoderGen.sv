module BorderGen(
    input logic clk, nrst, enable_in, //game_mode == WALL_INCREASE
    input logic [7:0] score,
    output logic [3:0] XMAX, XMIN, YMAX, YMIN
);

logic [3:0] xmax_n, xmin_n, ymax_n, ymin_n;


always_ff @ (posedge clk, negedge nrst) begin
    if (~nrst) begin
        XMAX = 4'd14;
        XMIN = 4'd0;
        YMAX = 4'd10;
        YMIN = 4'd0;
    end else begin
        XMAX = xmax_n
        XMIN = xmin_n;
        YMAX = ymax_n;
        YMIN = ymin_n;
    end
end



always_comb begin
    if (enable_in) begin
        if (score > 100) begin
            XMAX = 4'd14;
            XMIN = 4'd0;
            YMAX = 4'd10;
            YMIN = 4'd0;
        end
        else if (score > 80) begin 
            XMAX = 4'd13;
            XMIN = 4'd0;
            YMAX = 4'd9;
            YMIN = 4'd0;
        end
        else if (score > 60) begin 
            XMAX = 4'd12;
            XMIN = 4'd0;
            YMAX = 4'd8;
            YMIN = 4'd0;
        end
        else if (score > 40) begin 
            XMAX = 4'd11;
            XMIN = 4'd0;
            YMAX = 4'd7;
            YMIN = 4'd0;
        end
        else if (score > 20) begin 
            XMAX = 4'd10;
            XMIN = 4'd0;
            YMAX = 4'd6;
            YMIN = 4'd0;
        end
        else if (score > 10) begin 
            XMAX = 4'd9;
            XMIN = 4'd0;
            YMAX = 4'd5;
            YMIN = 4'd0;
        end
        else begin 
            XMAX = 4'd8;
            XMIN = 4'd0;
            YMAX = 4'd4;
            YMIN = 4'd0;
        end
    end


    else begin //default locations
        XMAX = 4'd14;
        XMIN = 4'd0;
        YMAX = 4'd10;
        YMIN = 4'd0;

    end
end
endmodule 
