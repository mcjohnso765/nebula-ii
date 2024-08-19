`timescale 1ms/10ns

module tb_sr_tx;

    logic clk;
    logic rst;
    logic msg_sent_ctrl;
    logic transmit_ready;
    logic [127:0] msg;

    logic [7:0] data_send;
    logic tx_ctrl;
    logic STOP;

    sr_tx uut(
        .clk(clk),
        .rst(rst),
        .msg_sent_ctrl(msg_sent_ctrl),
        .transmit_ready(transmit_ready),
        .msg(msg),
        .data_send(data_send),
        .tx_ctrl(tx_ctrl),
        .STOP(STOP)
    );

    initial begin   
        clk = 1;
        forever #5 clk = ~clk;
    end


    initial begin   
        
        rst = 1;
        
        
        msg = 128'hAABBCCDDEEFF00112233445566778899;
        #10 rst = 0;

        transmit_ready = 1;
        msg_sent_ctrl = 0;
        #30;
        msg_sent_ctrl = 1;
        #10 msg_sent_ctrl = 0;
        transmit_ready = 0;
        STOP = 0;
        #10;
        repeat (18) begin
            @(posedge clk);

            transmit_ready = 0;
            //msg_sent_ctrl = 1;
            // tx_ctrl = 1;
            STOP = 0;
            repeat(7) @(posedge clk);
            transmit_ready = 1;
            //msg_sent_ctrl = 0;
            //tx_ctrl = 0;
            
        end
        @(posedge clk);
        STOP = 1;
        
        $finish;
    end
endmodule