/* 
  Module: button_edge_detector
  Description:
    debounce the buttons input (UP, DOWN, LEFT, RIGHT, SELECT, BACK), 
  and output the debounced signal of each button and the OR strobe of all the buttons
*/
module button_edge_detector (
    input logic clk,
    input logic rst,
    input logic up, down, left, right, select, back,
    output logic reg_edge_up, reg_edge_down, reg_edge_left, reg_edge_right, reg_edge_select, reg_edge_back,
    output logic strobe
);

    logic next_up, next_down, next_left, next_right, next_select, next_back; // signal of button press on the current clock cycle
    logic edge_up, edge_down, edge_left, edge_right, edge_select, edge_back; // signal of button press on the current clock cycle
    logic debounce_up, debounce_down, debounce_left, debounce_right, debounce_select, debounce_back;
    
    Button buttonUp(clk, up, debounce_up);
    Button buttonDown(clk, down, debounce_down);
    Button buttonLeft(clk, left, debounce_left);
    Button buttonRight(clk, right, debounce_right);
    Button buttonSelect(clk, select, debounce_select);
    Button buttonBack(clk, back, debounce_back);

    always_ff @(posedge clk, negedge rst) begin
        if (~rst) begin
        
        end else begin
            next_up <= debounce_up;
            next_down <= debounce_down;
            next_left <= debounce_left;
            next_right <= debounce_right;
            next_select <= debounce_select;
            next_back <= debounce_back;
            reg_edge_up <= edge_up;
            reg_edge_down <= edge_down;
            reg_edge_left <= edge_left;
            reg_edge_right <= edge_right;
            reg_edge_select <= edge_select;
            reg_edge_back <= edge_back;
        end
    end

    always_comb begin
        // next_up = up;
        // next_left = left;
        // next_down = down;
        // next_right = right;
        edge_up = ~next_up & debounce_up;
        edge_down = ~next_down & debounce_down;
        edge_left = ~next_left & debounce_left;
        edge_right = ~next_right & debounce_right;
        edge_select = ~next_select & debounce_select;
        edge_back = ~next_back & debounce_back;
        strobe = reg_edge_up || reg_edge_down || reg_edge_left || reg_edge_right || reg_edge_select || reg_edge_back;

        // assign edgeDetected = (|button) & ~(|button_prev);    // detect the edge by AND and inverted previous
    end
endmodule


module Button (
	input         clk,     // clock input from FPGA (12MHz)
	input         noisy,   // noisy button input
	output        debounce // debounced button output, 
);     
  parameter LIMIT = 120000; // set the bouncing threshold to 10ms, 10ms / (1/12MHz) = 120000 clock cycles
  
  reg    [16:0] r_counter;  // size need to be larger or equal to LIMIT
  reg    r_debounce;
  
  assign debounce = r_debounce;

  always @ (posedge clk) begin
    if (noisy !== r_debounce && r_counter < LIMIT)
      r_counter <= r_counter + 1;
    else if (r_counter == LIMIT) begin
      r_debounce <= noisy;
      r_counter <= 17'b0;
    end
    else  
      r_counter <= 17'b0;
  end
  
endmodule