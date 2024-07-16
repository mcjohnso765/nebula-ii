module uart_rx_tb ();

typedef enum logic [2:0] {
IDLE = 3'b001, START = 3'b010, DATAIN = 3'b011, STOP = 3'b100, CLEAN = 3'b101, PARITY = 3'b110
} curr_state;

// Testbench ports
localparam CLK_PERIOD = 10; // 100 Hz clk
logic tb_clk, tb_nRst, tb_rx_ready, tb_rec_rdy, tb_rx_serial, parity_err;
logic [7:0] tb_rx_byte;
task reset_dut;
    #1;
    @(negedge tb_clk);
    tb_nRst = 1'b0; 
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nRst = 1'b1;
    @(posedge tb_clk);
    #1;
endtask

// Clock generation block
always begin
    tb_clk = 1'b0; 
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1; 
    #(CLK_PERIOD / 2.0); 
end

uart_rx #(.Clkperbaud(1250)) receive(.clk(tb_clk), .nRst(tb_nRst), .rx_ready(tb_rx_ready), .rx_serial(tb_rx_serial), .rx_byte(tb_rx_byte), .rec_ready(tb_rec_rdy), .error_led(parity_err));

initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    tb_nRst = 1'b1;
    tb_rec_rdy = 0; 
    tb_rx_serial = 1;

     #(0.1);
    // ***********************************
    // Test Case 0: Power-on-Reset 
    // ***********************************
    // Reset DUT Task
    #(CLK_PERIOD);
    @(negedge tb_clk);
    tb_nRst = 1'b0; 
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nRst = 1'b1;
    @(posedge tb_clk);
    #(CLK_PERIOD);

    // ***********************************
    // Test Case 1: Idle state of the transmitter + succesful start state transition 
    // ***********************************
    reset_dut();

    tb_nRst = 1'b1;
    tb_rec_rdy = 0;
    tb_rx_serial = 1;

    #(CLK_PERIOD * 1250);

    tb_rec_rdy = 1;
    tb_rx_serial = 0;

    #(CLK_PERIOD * 624);

    tb_rx_serial = 1;

    #(CLK_PERIOD * 1250);

    tb_rx_serial = 0;

    #(CLK_PERIOD * 627); 

    tb_rec_rdy = 0;
    tb_rx_serial = 1;
    #(CLK_PERIOD * 1249);

    tb_rx_serial = 1;
    #(CLK_PERIOD * 1250);

    tb_rx_serial = 0;
    #(CLK_PERIOD * 1250);

    tb_rx_serial = 1;
    #(CLK_PERIOD * 1250);
    
    tb_rx_serial = 0;
    #(CLK_PERIOD * 1250);

    tb_rx_serial = 1;
    #(CLK_PERIOD * 1250);

    tb_rx_serial = 0;
    #(CLK_PERIOD * 1250);

    tb_rx_serial = 1;
    #(CLK_PERIOD * 1250);

    tb_rx_serial = 1;
    #(CLK_PERIOD * 1250);

    tb_rx_serial = 0;
    #(CLK_PERIOD * 1250);

    tb_rx_serial = 0;
    #(CLK_PERIOD * 1250);




    // ***********************************
    // Test Case 2: succesful start state transition 
    // ***********************************

    // reset_dut();

    // tb_nRst = 1'b1;
    // tb_tx_ctrl = 1'b0;
    // tb_byte = 8'b10101011;
    // #(CLK_PERIOD * 1);
    // tb_tx_ctrl = 1'b1;
    // #(CLK_PERIOD *2);
    
    // tb_tx_ctrl = 1'b0;
    // #(CLK_PERIOD *1);

    // ***********************************
    // Test case 3: DATAIN STATE 
    // ***********************************

    reset_dut();


    




$finish;

end


endmodule
