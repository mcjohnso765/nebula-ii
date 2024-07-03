module top (
  input logic clk, rst, rx_din, rx_start,
  output logic success, receive_ready,
  output logic [7:0]data_receive, show_internal
);

    //INCOMING DATA PACKET IS 1'b1,1'b0,data8bits,1'b0;
    logic Reg_Start, Count_Start, new_clk;
    logic [7:0]din, falling_edge;
    logic Ready;
    logic no_count;

    second_counter secondcount(.clk(clk), .rst(rst), .falling_edge(falling_edge), .max(4'b0111),  .no_count(no_count), .countout());

    shift_register shifting_in(.clk(clk), .rst(rst), .Reg_Start(Reg_Start), .Ready(receive_ready), .Din(rx_din), .no_count(no_count), .data_receive(data_receive), .show_internal(show_internal));

    counter count(.clk(clk), .rst(rst), .count_start(Count_Start), .falling_edge(falling_edge), .max(4'b0111), .atmax(receive_ready), .no_count(no_count));
    
    FSM test(.clk(clk), .rst(rst), .Start(rx_start), .Ready_Sig(receive_ready),
    .state_check(), .Success(success), .Reg_Start(Reg_Start), .Count_Start(Count_Start), .no_count(no_count));

    clock_divider baud(.clk(clk), .rst(rst), .new_clk(new_clk));

    edge_detect detect(.clk(clk), .rst(rst), .signal_in(rx_din), .Ready(receive_ready), .falling_edge(falling_edge));

endmodule

