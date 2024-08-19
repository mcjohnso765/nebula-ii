`timescale 1ms/10ns
module tb_top;

    // Declare testbench variables
    logic clk, nrst, rx_din;
    logic success, receive_ready;
    logic [7:0] data_receive; 
    logic [127:0] msg;

    // Instantiate the top module
    top_RX uut_top (
        .clk(clk),
        .nrst(nrst),
        .rx_din(rx_din),
        .success(success),
        .receive_ready(receive_ready),
        .data_receive(data_receive),
        .msg(msg)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Task to apply reset
    task apply_reset;
        begin
            nrst = 0;
            @(posedge clk);
            nrst = 1;
        end
    endtask

    task shift_data(input logic [10:0] data);
        integer i;
        begin
            $display("Check data_receive: %b", data_receive);
            for (i = 0; i < 11; i = i + 1) begin
                rx_din = data[i];
                #250;
            end
        end
    endtask

    // Initial block for test sequence
    initial begin
        // Initialize inputs
        nrst = 1;
        rx_din = 1;
        apply_reset;
        #240;
        shift_data(11'b11111111111);
        @(posedge clk);
        shift_data(11'b01010001001);
        #250;
        shift_data(11'b01010101001);
        #250;
        shift_data(11'b01011001001);
        #250;
        shift_data(11'b01010001001);
        #250;
        shift_data(11'b01010101001);
        #250;
        shift_data(11'b01010001001);
        #250;
        shift_data(11'b01010001001);
        #250;
        shift_data(11'b01010101001);
        #250;
        shift_data(11'b01011001001);
        #250;
        shift_data(11'b01010001001);
        #250;
        shift_data(11'b01010101001);
        #250;
        shift_data(11'b01010001001);
        #250;
        shift_data(11'b01010001001);
        #250;
        shift_data(11'b01010101001);
        #250;
        shift_data(11'b01011001001);
        #250;
        shift_data(11'b01010001001);
        #250;
        shift_data(11'b01010101001);
        #250;
        shift_data(11'b01010001001);
        #250;
        shift_data(11'b01010001001);
        #250;
        shift_data(11'b01010101001);
        #250;
        shift_data(11'b01011001001);
        #250;
        shift_data(11'b01011001001);
        #250;
        shift_data(11'b01010001001);
        #250;
        shift_data(11'b11111111111);
        #250;
        shift_data(11'b11111111111);
        #250;
        shift_data(11'b11111111111);
        #250;
        shift_data(11'b11111111111);
        #250;
        
        $finish;
    end

endmodule
