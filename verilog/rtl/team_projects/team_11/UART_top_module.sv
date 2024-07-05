module top (
  input logic clk, nrst, rx_din,
  output logic success, receive_ready,
  output logic [7:0]data_receive, 
  output logic [8:0]show_internal,
  output [127:0] msg
);

    logic Reg_Start, Count_Start, new_clk;
    logic falling_edge;
    logic Ready;
    logic no_count;
    logic send;

    second_counter secondcount(.clk(clk), .nrst(nrst), .falling_edge(falling_edge), .max(4'b1001),  .no_count(no_count), .countout());

    shift_register shifting_in(.clk(clk), .nrst(nrst), .Reg_Start(Reg_Start), .receive_ready(send), .Din(rx_din), .data_receive(data_receive), .show_internal(show_internal));

    counter count(.clk(clk), .nrst(nrst), .count_start(Count_Start), .max(4'b1001), .atmax(receive_ready));
    
    FSM test(.clk(clk), .nrst(nrst), .receive_ready(receive_ready), .falling_edge(falling_edge),
    .state_check(), .Success(success), .Reg_Start(Reg_Start), .Count_Start(Count_Start), .no_count(no_count), .send(send));

    clock_divider baud(.clk(clk), .nrst(nrst), .new_clk(new_clk));

    edge_detect detect(.clk(clk), .nrst(nrst), .signal_in(rx_din), .falling_edge(falling_edge));

    sr_rx rx_register(.clk(clk), .nrst(nrst), .receive_ready(send), .data_receive(data_receive), .msg(msg));

endmodule