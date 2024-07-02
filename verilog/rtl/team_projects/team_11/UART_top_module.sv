module top (
  input logic clk, rst, rx_din, rx_start,
  output logic success, receive_ready,
  output logic [7:0]data_receive
);

    logic Reg_Start, Count_Start, new_clk;
    logic [7:0]din, show_internal, falling_edge;
    logic Ready;


    shift_register shifting_in(.clk(clk), .rst(rst), .Reg_Start(Reg_Start), .Ready(receive_ready), .falling_edge(falling_edge), .Din(rx_din), .data_receive(data_receive), .show_internal(show_internal));

    counter count(.clk(clk), .rst(rst), .count_start(Count_Start), .falling_edge(falling_edge), .max(4'b1010), .atmax(receive_ready));
    
    FSM test(.clk(clk), .rst(rst), .Start(rx_start && new_clk), .Ready_Sig(receive_ready), .falling_edge(falling_edge),
    .state_check(), .Success(success), .Reg_Start(Reg_Start), .Count_Start(Count_Start));

    //FSM_regi inst(.clk(clk), .rst(rst), .Ready(receive_ready), .Din(din), .data_receive(data_receive), .key_status(key_status), .ready_signal(rx_start));

    clock_divider baud(.clk(clk), .rst(rst), .new_clk(new_clk));

    edge_detect detect(.clk(clk), .rst(rst), .signal_in(rx_din), .Ready(receive_ready), .falling_edge(falling_edge));

endmodule

