`timescale 1ms/10ns

module tb_sr_rx;

    logic clk;
    logic nrst;
    logic receive_ready;
    logic [7:0] data_receive;
    logic [127:0] msg;
    logic rx_start;

    sr_rx uut (
        .clk(clk),
        .nrst(nrst),
        .receive_ready(receive_ready),
        .data_receive(data_receive),
        .msg(msg),
        .rx_start(rx_start)    
    );

    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end

    initial begin
        nrst = 0;
        receive_ready = 0;
        data_receive = 0;

        #100 nrst = 1;
        

        #80 receive_ready = 1;
        data_receive = 8'hAB;
        #10 receive_ready = 0;
        #80 receive_ready = 1;
        data_receive = 8'hCD;
        #10 receive_ready = 0;
        #80 receive_ready = 1;
        data_receive = 8'hEF;
        #10 receive_ready = 0;
        #80 receive_ready = 1;
        data_receive = 8'h01;
        #10 receive_ready = 0;
        #80 receive_ready = 1;
        data_receive = 8'h23;
        #10 receive_ready = 0;
        #80 receive_ready = 1;
        data_receive = 8'h45;
        

        #100;
        $finish;
    end
endmodule