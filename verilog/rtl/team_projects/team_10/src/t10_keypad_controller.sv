module t10_keypad_controller (
  input logic clk, nRst, enable, mode,
  input logic [3:0] read_row,
  output logic [7:0] cur_key, // Input for keypad_fsm
  output logic strobe, // Input for keypad_fsm
  output logic [3:0] scan_col//, sel_col, sel_row
);
  logic [3:0] Q0, Q1, Q1_delay;
  logic [3:0] scan_col_next, sel_col_next;
  logic strobe_next;

  // Synchronizer and rising (positive) edge detector - 3 FFs
  always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
      // Note: Strobe goes high when letting go of reset while holding push button
      Q0 <= 4'd0;
      Q1 <= 4'd0;
      Q1_delay <= 4'd0;

      // Note: Deactivating the scanning of columns should prevent key input
      scan_col <= 4'b0000;
      strobe<= 1'b0;

    end else begin
      // Pass through FFs for stability and edge detection
      Q0 <= read_row;
      Q1 <= Q0;
      Q1_delay <= Q1;
      strobe <= strobe_next;

      // Active column changes every clock cycle
      scan_col <= scan_col_next;
    end
  end

  always_comb begin
    // Setting active column for button press
    // Rate of switching reflected by all indicator lights turned on
    scan_col_next = scan_col;
    strobe_next = strobe;
    
    if(mode) begin
      if ((|read_row)) begin 
        // Maintain selected column while input button being pressed (non-zero row)
        scan_col_next = scan_col;
        if(enable)
            strobe_next = 1'b1;

      end
      else if (enable) begin
        strobe_next = 1'b0;
        case (scan_col)
          4'b0000:
            scan_col_next = 4'b1000;
          4'b1000:
            scan_col_next = 4'b0100;
          4'b0100:
            scan_col_next = 4'b0010;
          4'b0010:
            scan_col_next = 4'b0001;
          4'b0001:
            scan_col_next = 4'b1000;
          default:
            scan_col_next = 4'b0000;
        endcase
      end
      else begin
        scan_col_next = scan_col;
      end
    end else begin
      scan_col_next = scan_col;
    end
  end

  assign cur_key = (|read_row & |scan_col) ? ({read_row, scan_col}) : (8'd0);
endmodule
