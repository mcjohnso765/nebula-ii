`timescale 1ms/100us

module tb_location_check();

    logic [7:0] coordinate;
    logic [49: 0][7:0] body;
    logic [6:0] curr_length;
    logic snakeBody, snakeHead;

    location_check check(.coordinate(coordinate), .body(body), .curr_length(curr_length), .snakeBody(snakeBody), .snakeHead(snakeHead));

    initial begin
    coordinate = 8'h00;
    body = {50{8'b0}};
    curr_length = 7'b0;
    end

    initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    coordinate = 8'h44;
    body = {{49{8'b0}}, 8'h44};

    #100;
    
    curr_length = 7'b1;
    coordinate = 8'h44;
    body = {{48{8'b0}}, 8'h44, 8'h54};
    #100;
    coordinate = 8'h54;
    #100;

    body = {{48{8'b0}}, 8'h44, 8'h44};
    #100;
    coordinate = 8'h44;
    #100;
    $finish;
    
    end

endmodule

