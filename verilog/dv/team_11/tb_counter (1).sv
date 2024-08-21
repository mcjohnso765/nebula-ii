`timescale 1ms/10ns

module tb_sr_tx;

    logic clk;
    logic nrst;
    logic [17:0]max;
    logic transmit_ready;
    logic [17:0] count;
    logic STOP;

    tx_counter uut(
        .clk(clk),
        .nrst(nrst),
        .transmit_ready(transmit_ready),
        .count(count),
        .STOP(STOP)
    );

    initial begin   
        clk = 1;
        forever #5 clk = ~clk;
    end

    initial begin
        nrst = 1'b0;
        #20;
        nrst = 1'b1;
    end

    initial begin   
        transmit_ready = 1'b0;
        @(posedge nrst);
        #10;
        transmit_ready = 1'b1;

        #1440;
        transmit_ready = 1'b0;
        #100;
        
        
        $finish;
    end
endmodule