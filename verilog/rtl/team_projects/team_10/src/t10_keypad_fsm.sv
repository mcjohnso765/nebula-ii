module t10_keypad_fsm (
  input logic clk, nRst, strobe,
  input logic [7:0] cur_key, // Concatenation of row and column
  output logic ready, // Notification of letter submission after selection
  output logic game_end, // End-of-game signal
  output logic [7:0] data, // ASCII character from current key and number of consecutive presses
  output logic toggle_state // Notification of word submission
);
  logic [2:0] state;
  logic [2:0] next_state;
  logic [7:0] prev_key;
  logic [7:0] next_data;
  logic unlocked, next_unlocked;
  logic strobe_edge;
  logic strobe_edge1;
  logic edge1;

  typedef enum logic [2:0] {
      INIT = 0, S0 = 1, S1 = 2, S2 = 3, S3 = 4, DONE = 5
  } keypad_state_t;

  // 4-letter sets
  localparam key_7 = 8'b00101000; // R2 C0
  localparam key_9 = 8'b00100010; // R2 C2

  // Valid non-letter sets
  localparam submit_letter_key = 8'b00011000; // R3 C0
  localparam clear_key = 8'b00010100; // R3 C1
  localparam submit_word_key = 8'b00010010; // R3 C2
  localparam game_end_key = 8'b00100001; // R2 C3
  
  // Invalid non-letter sets
  localparam key_1 = 8'b10001000; // R0 C0
  localparam key_A = 8'b10000001; // R0 C3
  localparam key_B = 8'b01000001; // R1 C3
  localparam key_D = 8'b00010001; // R3 C3

  // Handle ASCII character conversion
  function logic[7:0] ascii_character (input[3:0] row, input [3:0] col, input [2:0] cur_state);
    ascii_character = 8'd0;

    if (row[3]) begin // "0" - 1000
      if (col[2]) // "1" - 0100
        ascii_character = 8'd65;
      else if (col[1]) // "2" - 0010
        ascii_character = 8'd68;

    end else if (row[2]) begin // "1" - 0100
      if (col[3]) // "0" - 1000
        ascii_character = 8'd71;
      else if (col[2]) // "1" - 0100
        ascii_character = 8'd74;
      else if (col[1]) // "2" - 0010
        ascii_character = 8'd77;

    end else if (row[1]) begin // "2" - 0010
      if (col[3]) // "0" - 1000
        ascii_character = 8'd80;
      else if (col[2]) // "1" - 0100
        ascii_character = 8'd84;
      else if (col[1]) // "2" - 0010
        ascii_character = 8'd87;
    end
    
    if ((1 <= cur_state) && (cur_state <= 4)) begin // S0 through S3
      ascii_character += ({5'd0, cur_state} - 8'd1);
    end
  endfunction

  always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
      state <= INIT;
      data <= 8'b01011111;
      
      unlocked <= 1'b0;
      prev_key <= 8'd0;
      strobe_edge <= 1'b0;
      strobe_edge1 <= 1'b0;

    end else begin
      state <= next_state;      
      data <= next_data;

      strobe_edge <= strobe;
      strobe_edge1 <= strobe_edge;

      unlocked <= next_unlocked;
      // Prevent loading too early
      if (unlocked & |cur_key)
        prev_key <= cur_key;
    end
  end

  assign edge1 = ((~strobe_edge1) & (strobe_edge));

  always_comb begin
    // 0-1. By default
    next_state = state;
    next_data = data;
    next_unlocked = unlocked; // 1'b0
    ready = 1'b0;
    game_end = 1'b0;
    toggle_state = 1'b0;

    if (state == DONE) begin
      next_state = INIT;
    
    end else if (state == INIT) begin
      if ((cur_key == submit_letter_key) || (cur_key == clear_key)) begin
        next_data = 8'b01011111;
      end
    end

    // Positive edge of pressing push button
    if (edge1) begin //changed curkey to specify row bits
      // Invalid keys
      if ((cur_key == key_1) ||
        (cur_key == key_A) ||
        (cur_key == key_B) ||
        (cur_key == key_D)) begin
        next_state = state;
        next_data =data;

      end else if (cur_key == submit_letter_key) begin
        if ((state == INIT) || (state == DONE)) begin
          next_state = INIT;
        end else begin
          next_state = DONE;
          ready = 1'b1;
          // Note: ASCII character (data) has already been assigned
        end

      end else if (cur_key == clear_key) begin
        next_state = INIT;

      end else if (cur_key == submit_word_key) begin
        next_state = INIT;
        next_data = 8'd0;
        toggle_state = 1'b1;

      end else if (cur_key == game_end_key) begin
        next_state = INIT;
        next_data = 8'h2d;
        game_end = 1'b1;

      // Letter sets 2-9
      end else begin 
        if (prev_key == cur_key) begin

          if (state == INIT) begin
            next_state = S0;
          end 
          else if (state == S0) begin
            next_state = S1;
          end else if (state == S1) begin
            next_state = S2;
          end else if (state == S2) begin
            next_state = ((cur_key == key_7) || (cur_key == key_9)) ? (S3) : (S0);
          end else if (state == S3) begin
            next_state = S0;
          end

        end else begin
          next_state = S0;
        end

        next_unlocked = 1'b1;
        next_data = ascii_character(cur_key[7:4], cur_key[3:0], next_state); //changed to state from next_state
    end
    
    // Strobe is low
    end else begin
      next_unlocked = 1'b0;
    end
  end
endmodule
