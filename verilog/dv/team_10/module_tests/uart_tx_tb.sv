/* UART Transmitter File
Descriuption: x
*/


module uart_tx_tb ();

typedef enum logic [2:0] {
IDLE = 3'b001, START = 3'b010, DATAIN = 3'b011, STOP = 3'b100, CLEAN = 3'b101, PARITY = 3'b110
} curr_state;

// Testbench ports
localparam CLK_PERIOD = 10; // 100 Hz clk
logic tb_clk, tb_nRst, tb_tx_ctrl, tb_transmit_rdy, tb_tx_serial;
logic [7:0] tb_byte;
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

uart_tx #(.Clkperbaud(1250)) transmit(.clk(tb_clk), .nRst(tb_nRst), .tx_ctrl(tb_tx_ctrl), .tx_serial(tb_tx_serial), .tx_byte(tb_byte), .transmit_ready(tb_transmit_rdy));

initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    tb_nRst = 1'b1;
    tb_tx_ctrl = 1'b0;
    tb_byte = 8'b10011101;

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
    // Test Case 1: Idle state of the transmitter 
    // ***********************************
    reset_dut();

    tb_nRst = 1'b1;
    tb_tx_ctrl = 1'b0;
    #(0.1);

    #(CLK_PERIOD * 10);

    // ***********************************
    // Test Case 2: succesful start state transition 
    // ***********************************

    reset_dut();

    tb_nRst = 1'b1;
    tb_tx_ctrl = 1'b0;
    tb_byte = 8'b10101011;
    #(CLK_PERIOD * 1);
    tb_tx_ctrl = 1'b1;
    #(CLK_PERIOD *2);
    
    tb_tx_ctrl = 1'b0;
    #(CLK_PERIOD *1);

    // ***********************************
    // Test Case 3: succesful data transmission 
    // ***********************************
    #(CLK_PERIOD * 15000);

    reset_dut();


    




$finish;

end


endmodule
