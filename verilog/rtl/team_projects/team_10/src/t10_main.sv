// Main

module top (
    // FPGA Ports
    input logic hz10M, reset, 
    input  logic [20:0] pb,
    output logic [7:0] left, right, ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
    output logic red, green, blue,

    // UART ports
    output logic [7:0] txdata,
    input  logic [7:0] rxdata,
    output logic txclk, rxclk,
    input  logic txready, rxready

);
// Local Variable Declarations for both player and host 
logic new_clk, useless; // Clock output signal from clock divider

// Local Variable Declarations - Player 
logic ready, transmit_ready, tx_ctrl, tx_serial, toggle_state, strobe_player, gameEnd_player;
logic [7:0] msg, tx_byte, cur_key_player;
logic [3:0] scan_col_player;

// Local Variable Declarations - Host 
logic strobe_host, gameEnd_host, key_ready, rec_ready_host, toggle_state_host, mistake, rx_ready, red_busy, game_rdy;
logic [3:0] scan_col_host;
logic [7:0] cur_key_host, setLetter, guess, letter, rx_byte;
logic [39:0] temp_word; 
logic [2:0] incorrect, correct;
logic [4:0] indexCorrect;

// LCD Outputs
logic [127:0] play_row1, play_row2, host_row1, host_row2, final_row1, final_row2;
logic [2:0] state1, state2;

// ***********
// Global 
// ***********
always_comb begin
    if (pb[19]) begin
        ss7 = lcd_data_player;
        left[4:1] = play_col;
        final_row1 = play_row1;
        final_row2 = play_row2;
        final_state = 8'b01010000;
    end else begin
        ss7 = lcd_data_host;
        left[4:1] = host_col;
        final_row1 = host_row1;
        final_row2 = host_row2;
        final_state = 8'b01001000;
    end
end

clock_divider clock_div (.clk (hz10M), .nRst (~reset), .clear (~reset), .max (30'd100000), .at_max (new_clk));

// ***********
// Player Side
// ***********
logic [7:0] final_state;
logic [7:0] lcd_data_player, lcd_data_host;
logic [3:0] play_col, host_col;

keypad_controller keypadplayer (.mode(pb[19]), .clk(hz10M), .nRst(~reset), .read_row(pb[7:4]), .cur_key(cur_key_player), .strobe(strobe_player), .scan_col(play_col), .enable(new_clk));
keypad_fsm keypadFSMPlayer (.clk(hz10M), .nRst(~reset), .strobe(strobe_player), .cur_key(cur_key_player), .ready(ready), .data(msg), .game_end(gameEnd_player), .toggle_state(useless));

disp_fsm dispFSM (.clk(hz10M), .nRst(~reset), .ready(ready), .msg(msg), .row1(play_row1), .row2(play_row2), .gameEnd(gameEnd_player));

msg_reg message_reg (.clk(hz10M), .nRst(~reset), .ready(ready), .transmit_ready(transmit_ready), .data(msg), .blue(blue), .tx_ctrl(tx_ctrl), .tx_byte(tx_byte));

uart_Tx uart_transmitter (.clk(hz10M), .nRst(~reset), .tx_ctrl(tx_ctrl), .tx_byte(tx_byte), .transmit_ready(transmit_ready), .tx_serial(left[0]));

lcd_controller lcdPlayer (.clk(hz10M), .rst(~reset), .row_1({final_row1[119:0], final_state}), .row_2(final_row2), .lcd_en(left[7]), .lcd_rw(left[6]), .lcd_rs(left[5]), .lcd_data(lcd_data_player), .strobe(strobe_player));


// *********
// Host Side
// *********

keypad_controller keypadHostt (.clk(hz10M), .mode(~pb[19]), .nRst(~reset), .read_row(pb[7:4]), .cur_key(cur_key_host), .strobe(strobe_host), .scan_col(host_col), .enable(new_clk));
keypad_fsm keypadFSMHost (.clk(hz10M), .nRst(~reset), .strobe(strobe_host), .cur_key(cur_key_host), .ready(key_ready), .data(setLetter), .game_end(gameEnd_host), .toggle_state(toggle_state_host));

host_msg_reg host_message_reg (.clk(hz10M), .nRst(~reset), .key_ready(key_ready), .toggle_state(toggle_state_host), .setLetter(setLetter), .rec_ready(rec_ready_host), .temp_word(temp_word), .gameEnd_host(gameEnd_host));

uart_Rx uart_receiver (.clk(hz10M), .nRst(~reset), .rx_serial(pb[18]), .rec_ready(rec_ready_host), .rx_ready(rx_ready), .rx_byte(rx_byte), 
.error_led(right[0]));

buffer buffer (.clk(hz10M), .nRst(~reset), .Rx_byte(rx_byte), .rx_ready(rx_ready), .game_rdy(game_rdy), .guess(guess));

game_logic gamelogic (.clk(hz10M), .nRst(~reset), .guess(guess), .setWord(temp_word), .toggle_state(toggle_state_host), .letter(letter), .red(red), .green(green),
.mistake(mistake), .red_busy(red_busy), .game_rdy(game_rdy), .incorrect(incorrect), .correct(correct), .indexCorrect(indexCorrect), .gameEnd(gameEnd_host));

host_disp hostdisp (.clk(hz10M), .nRst(~reset), .indexCorrect(indexCorrect), .letter(letter), .incorrect(incorrect), .correct(correct), .temp_word(temp_word), .setLetter(setLetter), .toggle_state(toggle_state_host), .gameEnd_host(gameEnd_host), .mistake(mistake), .top(host_row1), .bottom(host_row2));

endmodule

module clock_divider (
  input logic clk, nRst, clear,
  input logic [29:0] max,
  output logic at_max
);
  logic [29:0] next_count, count;
  
  always_ff @(posedge clk, negedge nRst) begin
    if (~nRst)
      count <= 0;
    else
      count <= next_count;
  end

  always_comb begin  
    at_max = (count == max);
    next_count = count;

    if (clear)
      next_count = 0;

    if (at_max)
      next_count = 0;
    else
      next_count = count + 1;
  end
endmodule

module keypad_controller (
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

module keypad_fsm (
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
  function logic[7:0] ascii_character ( input[3:0] row, input [3:0] col, input [2:0] state);
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
    
    if ((1 <= state) && (state <= 4)) begin // S0 through S3
      ascii_character += ({5'd0, state} - 8'd1);
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

module disp_fsm (
    input logic clk, nRst, ready, gameEnd,
    input logic [7:0] msg,
    output logic [127:0] row1, row2
);

logic [79:0] guesses, next_guess;

always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
        guesses <= {8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111}; // _ x10 in ASCII
    end else if (gameEnd) begin 
        guesses <= {8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111}; // _ x10 in ASCII
    end else begin
        guesses <= next_guess;
    end
end

always_comb begin
    if (ready) begin
        next_guess = {msg, guesses[79:8]};
        row1 = {8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, msg, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000};
        row2 = {8'b00100000, 8'b00100000, 8'b00100000, guesses, 8'b00100000, 8'b00100000, 8'b00100000};
    end
    else begin
        next_guess = guesses;
        row1 = {8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, msg, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000};
        row2 = {8'b00100000, 8'b00100000, 8'b00100000, guesses, 8'b00100000, 8'b00100000, 8'b00100000};
    end
end
endmodule

module msg_reg (
    input logic clk, nRst, ready, transmit_ready,
    input logic [7:0] data,
    output logic blue, tx_ctrl,
    output logic [7:0] tx_byte
);

typedef enum logic [1:0] {
IDLE = 2'b00, WAIT = 2'b01, TRANSMIT = 2'b11
} curr_state;


logic [7:0] msg, msg_rdy;
curr_state state, next_state;

always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin 
        msg <= 8'b0;
        state <= IDLE;
    end else begin 
        msg <= msg_rdy;
        state <= next_state;
    end
end

always_comb begin 
    next_state = state;

    case (state)
        IDLE: begin 
            tx_byte = msg;
            tx_ctrl = 0;
            blue = 0;
            if (ready) begin
                msg_rdy = data;
                next_state = WAIT;
            end else
                msg_rdy = msg;
        end
        WAIT: begin 
            tx_ctrl = 1;
            tx_byte = msg;
            blue = 0;
            msg_rdy = msg;
            if (transmit_ready)
                next_state = TRANSMIT;
            else  
                next_state = WAIT;
        end
        TRANSMIT: begin
            msg_rdy = msg;
            tx_byte = msg;
            tx_ctrl = 1;
            blue = 1;
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
            tx_byte = 8'b0;
            blue = 0;
            tx_ctrl = 0;
            msg_rdy = 0;
        end
    endcase
end
endmodule

module uart_Tx
#(
    parameter Clkperbaud = 1041
)

(
    input logic clk, nRst, tx_ctrl,
    input logic [7:0] tx_byte, 
    output logic transmit_ready, tx_serial
);

    typedef enum logic [2:0] {
    IDLE = 3'b001, START = 3'b010, DATAIN = 3'b011, STOP = 3'b100, CLEAN = 3'b101, PARITY = 3'b110
    } curr_state;

    logic [2:0] bit_index, next_bit_index;  
    logic [10:0] clk_count, next_clk_count;
    logic [3:0] pcount, count;
    curr_state state, next_state;

    always_ff @(posedge clk, negedge nRst) begin// flip flop to update states and counter
        if (~nRst) begin
            state <= IDLE;
            count <= 0;
            clk_count <= 0;
            bit_index <= 0;
        end else begin   
            state <= next_state;
            count <= pcount;
            clk_count <= next_clk_count;
            bit_index <= next_bit_index;
        end
    end
 
    always_comb begin
        case (state)
            IDLE: begin 
                tx_serial = 1; 
                transmit_ready = 1; 
                next_bit_index = 0; 
                pcount = 0;
                next_clk_count = 0;

                if (tx_ctrl == 1) begin //state transition logic
                    next_state = START;
                end else begin  
                    next_state = IDLE;
                end
            end
            START: begin 
                tx_serial = 0;
                transmit_ready = 0;
                next_bit_index = 0;
                pcount = 0;


                if(clk_count < Clkperbaud - 1) begin
                next_clk_count = clk_count + 1;
                next_state = START;
                end
                else begin
                next_clk_count = 0;
                next_state = DATAIN;
                end
            end
            DATAIN: begin   
                transmit_ready = 0;
                tx_serial = tx_byte[bit_index];
                
                if(clk_count < Clkperbaud - 1) begin
                next_clk_count = clk_count + 1;
                next_state = DATAIN;
                pcount = count;
                next_bit_index = bit_index;
                end
                else begin
                next_clk_count = 0; 
                if(tx_serial == 1) begin // parity counter counts 1s
                pcount = count + 1;
                end
                else begin
                pcount = count;
                end
                

                if (bit_index < 7) begin // state transition logic
                next_bit_index = bit_index + 1;
                next_state = DATAIN;
                end else  begin 
                next_bit_index = 0;
                next_state = STOP;
                end
                end
            end 
            // PARITY: begin
            //     next_bit_index = 0;
            //     transmit_ready = 0;
                
            //     if(pcount % 2 == 1) begin //Parity assignment 
            //     tx_serial = 1;
            //     pcount = count;
            //     end
            //     else begin
            //     tx_serial = 0;
            //     pcount = count;
            //     end
                
            //     if(clk_count < Clkperbaud - 1) begin
            //     next_clk_count = clk_count + 1;
            //     next_state = PARITY;
            //     end
            //     else begin
            //     next_clk_count = 0;
            //     next_state = STOP; // state transition logic
            //     end
            // end
            STOP: begin 
                pcount = 0;
                tx_serial = 1;
                next_bit_index = 0;
                transmit_ready = 1;

                if(clk_count < Clkperbaud - 1) begin
                next_clk_count = clk_count + 1;
                next_state = STOP;
                end
                else begin
                next_clk_count = 0;
                next_state = CLEAN; // state transition logic
                end

                next_state = CLEAN; // state transition logic
                end
            CLEAN: begin 
                next_bit_index = 0;
                transmit_ready = 0;
                tx_serial = 1;
                pcount = 0;
                next_clk_count =0;

                next_state = IDLE; // state transition logic
                end
            default: begin 
                next_state = IDLE;
                next_bit_index = 0;
                transmit_ready = 0;
                tx_serial = 1;
                pcount = 0;
                next_clk_count = 0;
                end
        endcase
    end
endmodule

module uart_Rx
#(
    parameter Clkperbaud = 1041
)

(
    input logic clk, nRst, rx_serial, rec_ready,
    output logic rx_ready,
    output logic [7:0] rx_byte,
    output logic error_led
);


typedef enum logic [2:0] {
IDLE = 3'b001, START = 3'b010, DATAIN = 3'b011, STOP = 3'b100, CLEAN = 3'b101, PARITY = 3'b110
} curr_state;

logic [7:0] temp_byte;
logic [2:0] bit_index, next_bit_index;  
curr_state state, next_state;
logic [10:0] clk_count, next_clk_count;
logic [3:0] pcount, count;
logic pbit;
logic next_err;


always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
        rx_byte <= 0;
        state <= IDLE;
        clk_count <= 0;
        bit_index <= 0;
        count <= 0;
        error_led <= 0;
    end else begin
        state <= next_state;
        rx_byte <= temp_byte;
        clk_count <= next_clk_count;
        bit_index <= next_bit_index;
        count <= pcount; 
        error_led <= next_err;
    end
end

always_comb begin
    temp_byte = rx_byte;

    pbit = 0;
    case (state)
        IDLE: begin
            next_err = error_led;
            rx_ready = 0;
            next_bit_index = 0;
            temp_byte = 0;
            next_clk_count = 0;
            pcount = 0;

            if (rx_serial == 0 && rec_ready)
                next_state = START;
            else
                next_state = IDLE;
        end
        START: begin
            rx_ready = 0;
            temp_byte = 0;
            next_bit_index = 0;
            pcount = 0;
            next_err = 0;
            if(clk_count == (Clkperbaud - 1)/2) begin
                if (rx_serial == 0 && rec_ready) begin
                    next_clk_count = 0;
                    next_state = DATAIN;
                end
                else begin
                    next_clk_count = clk_count +1;    
                    next_state = IDLE;
                end
            end
            else begin 
                next_clk_count = clk_count +1 ;
                next_state = START;
            end
        end
        DATAIN: begin
            temp_byte[bit_index] = rx_serial;
            rx_ready = 0;
            next_err = 0;
            if(clk_count < Clkperbaud - 1) begin
            next_clk_count = clk_count + 1;
            next_state = DATAIN;
            next_bit_index = bit_index;
            pcount = count;
            end
            else begin

            if(temp_byte[bit_index] == 1) begin // parity counter counts 1s
            pcount = count + 1;
            end
            else begin
            pcount = count;
            end
            
            next_clk_count = 0;
            
            if (bit_index < 7) begin
                next_bit_index = bit_index + 1;
                next_state = DATAIN;
            end else begin
                next_bit_index = 0;
                next_state = STOP;
            end
            end
        end
        // PARITY: begin 
        //     pbit =  rx_serial;
        //     pcount = count;
        //     rx_ready = 0;
        //     temp_byte = rx_byte;
        //     next_bit_index = 0;

        //     if(clk_count < Clkperbaud - 1) begin
        //     next_clk_count = clk_count + 1;
        //     next_state = PARITY;
        //     next_err = 0;
        //     end
        //     else begin 
        //     if ((pcount % 2 == 1) && (pbit == 0)) begin
        //     next_err = 1;
        //     next_clk_count = 0;
        //     next_state = CLEAN; // state transition logic
        //     end
        //     else if((pcount % 2 == 0) && (pbit == 1)) begin
        //     next_err = 1;
        //     next_clk_count = 0;
        //     next_state = CLEAN; // state transition logic
        //     end
        //     else 
        //     next_err = 0;
        //     next_clk_count = 0;
        //     next_state = STOP;
        //     end
        // end
        STOP: begin
            next_err = error_led;
            if(clk_count < Clkperbaud - 1) begin
            next_clk_count = clk_count + 1;
            next_state = STOP;
            end
            else begin
            next_clk_count = 0;
            next_state = CLEAN; // state transition logic
            end

            rx_ready = 1;
            temp_byte = 0;
            next_bit_index = 0; 
            pcount = 0;
        end
        CLEAN: begin 
            next_err = error_led;
            pcount = 0;
            next_clk_count = 0;
            rx_ready = 0;
            temp_byte = 0;
            next_bit_index = 0;
            next_state = IDLE;
        end
        default: begin
            next_clk_count = 0;
            rx_ready = 0;
            temp_byte = 0;
            next_bit_index = 0;
            next_state = IDLE;
            pcount = 0;
            next_err = 0;
        end
    endcase
end
endmodule

module host_msg_reg (
    input logic clk, nRst, toggle_state, key_ready, gameEnd_host,
    input logic [7:0] setLetter,
    output logic rec_ready,
    output logic [39:0] temp_word
);

    typedef enum logic { 
        SET = 1'b0, COMPARE = 1'b1
    } casestate;
    casestate Cstate, next_state;

logic [39:0] next_temp_word;

always_ff @(posedge clk, negedge nRst) begin
    if(~nRst) begin
        temp_word <= 40'b0101111101011111010111110101111101011111;
        Cstate <= SET;
    end
    else begin
        temp_word <= next_temp_word;
        Cstate <= next_state;
    end
end

always_comb begin
    case(Cstate)
        SET: begin 
            rec_ready = 0;
            if (key_ready)
                next_temp_word = {temp_word[31:0], setLetter};
            else
                next_temp_word = temp_word;

            if (toggle_state) begin
                next_state = COMPARE;
            end else 
                next_state = SET;
        end
        COMPARE: begin
            rec_ready = 1;
            next_temp_word = temp_word;
            next_state = COMPARE;
        end
    endcase
    if (gameEnd_host) begin
        next_state = SET;
        rec_ready = 0;
        next_temp_word = 40'b0101111101011111010111110101111101011111;
    end
end 
endmodule 

module buffer (
    input logic [7:0] Rx_byte,
    input logic rx_ready, game_rdy, clk, nRst,
    output logic [7:0] guess
);
    logic [7:0] temp_guess, next_byte;

    always_ff @(posedge clk, negedge nRst)
        if (~nRst)    
            temp_guess <= 0;
        else 
            temp_guess <= next_byte;

    always_comb begin
        if (rx_ready)
            next_byte = Rx_byte;
        else 
            next_byte = temp_guess;

        if (game_rdy)
            guess = temp_guess;
        else    
            guess = 0;
    end
endmodule

module game_logic (
    input logic clk, nRst, gameEnd,
    input logic [7:0] guess,
    input logic [39:0] setWord,
    input logic toggle_state,
    output logic [7:0] letter,
    output logic red, green, mistake, red_busy, game_rdy,
    output logic [2:0] incorrect, correct,
    output logic [4:0] indexCorrect
);
    typedef enum logic [3:0] { 
        SET = 0, L0 = 1, L1 = 2, L2 = 3, L3 = 4, L4 = 5, STOP = 6, IDLE = 7, FIRST = 8
    } state_t;

    logic [7:0] placehold;
    state_t nextState, state;
    logic [2:0] correctCount, mistakeCount;
    logic [4:0] nextIndexCorrect;
    logic [2:0] rights, nRight;
    logic tempRed, tempGreen;
    logic pulse;

    always_ff @(posedge clk, negedge nRst) begin
        if(~nRst) begin
            state <= SET;
            incorrect <= 0;
            correct <= 0;
            indexCorrect <= 0;
            letter <= 0;
            rights <= 0;
            red <= 0;
            green <= 0;
        end else begin
            state <= nextState;
            incorrect <= mistakeCount;
            correct <= correctCount;
            indexCorrect <= nextIndexCorrect;
            letter <= placehold;
            rights <= nRight;
            red <= tempRed;
            green <= tempGreen;
        end
    end

    always_comb begin
        nextState = state;
        correctCount = correct; //for latch
        mistakeCount = incorrect; //for latch
        nextIndexCorrect = indexCorrect; //for latch
        nRight = rights; //for latch
        tempRed = red;//for latch 
        tempGreen = green;//for latch
        placehold = letter;//for latch

        red_busy = 0;
        mistake = 0;
        game_rdy = 0;
        pulse = 0;

        case(state)
            SET: begin
                tempRed = 0;
                tempGreen = 0;
                nRight = 0;
                correctCount = 0;
                mistakeCount = 0;
                //flip flop will set the word using a shift register
                nextIndexCorrect = 0;
                if(toggle_state) begin
                    nextState = FIRST;
                end else
                    nextState = SET;
            end
            FIRST: begin
                game_rdy = 1;
                if(guess != 0)begin
                    placehold = guess;
                    nextState = L0;
                end else begin
                    nextState = FIRST;
                end               
            end
            L0: begin
                red_busy = 1;
                game_rdy = 0;
                if(letter == setWord[39:32] & indexCorrect[4] != 1)begin
                    nextIndexCorrect[4] = 1;
                    nRight = nRight + 1;
                end 

                nextState = L1;
            end
            L1: begin
                red_busy = 1;
                game_rdy = 0;
                if(letter == setWord[31:24] & indexCorrect[3] != 1)begin
                    nextIndexCorrect[3] = 1;
                    nRight = nRight + 1;
                end 

                nextState = L2;
            end
            L2: begin
                red_busy = 1;
                game_rdy = 0;
                if(letter == setWord[23:16] & indexCorrect[2] != 1)begin
                    nextIndexCorrect[2] = 1;
                    nRight = nRight + 1;
                end 

                nextState = L3;
            end
            L3: begin
                red_busy = 1;
                game_rdy = 0;
                if(letter == setWord[15:8] & indexCorrect[1] != 1)begin
                    nextIndexCorrect[1] = 1;
                    nRight = nRight + 1;
                end 

                nextState = L4;
            end
            L4: begin
                red_busy = 1;
                game_rdy = 0;
                if(letter == setWord[7:0] & indexCorrect[0] != 1)begin
                    nextIndexCorrect[0] = 1;
                    nRight = nRight + 1;
                end 

                nextState = STOP;
            end
            STOP: begin
                if(correct <= 4 & incorrect <= 5) begin
                if(rights > 0) begin
                    mistake = 0;
                    correctCount = correctCount + rights;
                end 
                else begin
                    mistake = 1;
                    mistakeCount = mistakeCount + 1;
                end
                end
                red_busy = 0;
                game_rdy = 1;
                nextState = IDLE;
            end
            IDLE: begin
                nRight = 0;
                game_rdy = 1;
                if(guess != 0)begin
                    placehold = guess;
                    pulse = 1;
                end else begin
                    placehold = letter;
                    pulse = 0;
                end
            if(correct == 5 | incorrect == 6) begin
                if(correct == 5) begin
                    tempGreen = 1;
                    tempRed = 0;
                    //LCD DISPLAY WIN
                end else if(incorrect == 6) begin
                    tempGreen = 0;
                    tempRed = 1;
                    //LCD DISPLAY FAIL
                end
            end
                if(gameEnd) begin
                    tempGreen = 0;
                    tempRed = 0;
                    correctCount = 0;
                    mistakeCount = 0;
                    nextIndexCorrect = 0;
                    placehold = 0;
                    nRight = 0;
                    nextState = SET;
                end
                else if((pulse) & !(correct == 5 | incorrect == 6)) begin
                    nextState = L0;
                end else begin
                    nextState = IDLE;
                end
            end
            default: begin
                game_rdy = 0;
                nextState = SET;
                correctCount = 0;
                mistakeCount = 0;
            end
        endcase
    end
endmodule

module host_disp (
    input logic clk, nRst,
    input logic [4:0] indexCorrect,
    input logic [7:0] letter, setLetter,
    input logic [2:0] incorrect, correct,
    input logic [39:0] temp_word,
    input logic toggle_state,
    input logic mistake,
    input logic gameEnd_host, 
    output logic [127:0] top, bottom
);
    logic [127:0] nextTop;
    logic [127:0] nextBottom;
    logic [47:0] next_curr_guesses;
    logic [23:0] win = {8'b01010111, 8'b01101001, 8'b01101110};  // Win in ASCII MAKE IT BINARY
    logic [31:0] lose = {8'b01001100, 8'b01101111, 8'b01110011, 8'b01100101}; // Lose in ASCII MAKE IT BINARY
    logic [39:0] curr_word, next_curr_word; // _ _ _ _ _ in ASCII
    logic [47:0] curr_guesses; // _ _ _ _ _ _ in ASCII
    logic [39:0] space5 = {8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000, 8'b00100000};
    logic [7:0] space1 = 8'b00100000;

    typedef enum logic { 
        SET = 1'b0, COMPARE = 1'b1
    } casestate;
    casestate Cstate, next_state;


always_ff @(posedge clk, negedge nRst) begin
    if(~nRst) begin
        top <= 0;
        bottom <= 0;
        Cstate <= SET;

        curr_guesses <= {8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111};
        curr_word <= {8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111};
    end else begin
        top <= nextTop;
        bottom <= nextBottom;
        curr_guesses <= next_curr_guesses;
        curr_word <= next_curr_word;
        Cstate <= next_state;
    end
end

always_comb begin
next_curr_guesses = curr_guesses;
next_curr_word = curr_word;
next_state = Cstate;
nextTop = top;
nextBottom = bottom;

if(gameEnd_host) begin
    next_curr_word = {8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111}; // _ _ _ _ _ in ASCII
    next_curr_guesses = {8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111}; // _ _ _ _ _ _ in ASCII
    nextTop = {space5, space1, space5, space5}; // split evenly by 8
    nextBottom = {space5, space5, space1, space5}; // split evenly by 8
    next_state = SET;
end

    case (Cstate)
        SET: begin
            nextTop = {space5, space1, space1, space1, setLetter, space5, space1, space1};
            nextBottom = {space5, temp_word, space1, space5};

            if (toggle_state)
                next_state = COMPARE;
        end
        COMPARE: begin
        case(mistake)
            0: begin
                    if(correct == 5) begin
                        nextTop = {space5, space1, space1, win, space5, space1}; // split evenly by 8
                        nextBottom = {space5, space1, temp_word, space5}; // split evenly by 8
                    end else begin
                        if(indexCorrect[4] & next_curr_word[39:32] == 8'b01011111) begin
                        next_curr_word[39:32] = letter;
                        end               
                        if(indexCorrect[3] & next_curr_word[31:24] == 8'b01011111) begin
                        next_curr_word[31:24] = letter;
                        end
                        if(indexCorrect[2] & next_curr_word[23:16] == 8'b01011111) begin
                        next_curr_word[23:16] = letter;
                        end
                        if(indexCorrect[1] & next_curr_word[15:8] == 8'b01011111) begin
                        next_curr_word[15:8] = letter;
                        end
                        if(indexCorrect[0] & next_curr_word[7:0] == 8'b01011111) begin
                        next_curr_word[7:0] = letter;
                        end

                        nextTop = {space5, space1, curr_word, space5}; // split evenly by 8
                        nextBottom = {space5, curr_guesses, space5};
                    end
                if(incorrect == 6) begin
                    nextTop = {space5, space1, lose, space5, space1}; // split evenly by 8
                    nextBottom = {space5, space1, temp_word, space5}; // split evenly by 8
                end
            end 
            1: begin
                if(incorrect == 6) begin
                    nextTop = {space5, space1, lose, space5, space1}; // split evenly by 8
                    nextBottom = {space5, space1, temp_word, space5}; // split evenly by 8
                end else begin
                    next_curr_guesses = {letter, curr_guesses[47:8]};//bottom row in position bit index becomes the guess letter
                    nextBottom = {space5, curr_guesses, space5}; // split evenly by 8
                end
            end
            default: begin
                next_curr_word = {8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111}; // _ _ _ _ _ in ASCII
                next_curr_guesses = {8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111, 8'b01011111}; // _ _ _ _ _ _ in ASCII
                nextTop = {space5, space1, curr_word, space5}; // split evenly by 8
                nextBottom = {space5, curr_guesses, space5}; // split evenly by 8
            end 
        endcase
        end
    endcase
end
endmodule

module lcd_controller #(parameter clk_div = 20_000)( //100,000 -< 24k
    input clk,
    input rst,
    // Data to be displayed
    input [127:0] row_1,
    input [127:0] row_2,
    input strobe,
   
    // LCD control signal
    output lcd_en,
    output lcd_rw,
    output reg lcd_rs,
    output reg [7:0] lcd_data
    );

    logic lcd_ctrl;

    reg [7:0] currentState;
    reg [7:0] nextState;
    reg [20:0] cnt_20ms;
    reg [20:0] cnt_500hz;
    wire delay_done;

    logic [15:0] lcd_data1;
    logic [7:0] lcd_data2;
 
    localparam TIME_500HZ = clk_div;
    // Wait for 20 ms before intializing.
    localparam TIME_20MS = TIME_500HZ * 10;
   
    // Set lcd_data accroding to datasheet
    localparam IDLE = 8'h00,                
               SET_FUNCTION = 8'h01,      
               DISP_OFF = 8'h03,
               DISP_CLEAR = 8'h02,
               ENTRY_MODE = 8'h06,
               DISP_ON = 8'h07,
               ROW1_ADDR = 8'h05,      
               ROW1_0 = 8'h04,
               ROW1_1 = 8'h0C,
               ROW1_2 = 8'h0D,
               ROW1_3 = 8'h0F,
               ROW1_4 = 8'h0E,
               ROW1_5 = 8'h0A,
               ROW1_6 = 8'h0B,
               ROW1_7 = 8'h09,
               ROW1_8 = 8'h08,
               ROW1_9 = 8'h18,
               ROW1_A = 8'h19,
               ROW1_B = 8'h1B,
               ROW1_C = 8'h1A,
               ROW1_D = 8'h1E,
               ROW1_E = 8'h1F,
               ROW1_F = 8'h1D,
               ROW2_ADDR = 8'h1C,
               ROW2_0 = 8'h14,
               ROW2_1 = 8'h15,
               ROW2_2 = 8'h17,
               ROW2_3 = 8'h16,
               ROW2_4 = 8'h12,
               ROW2_5 = 8'h13,
               ROW2_6 = 8'h11,
               ROW2_7 = 8'h10,
               ROW2_8 = 8'h30,
               ROW2_9 = 8'h31,
               ROW2_A = 8'h33,
               ROW2_B = 8'h32,
               ROW2_C = 8'h36,
               ROW2_D = 8'h37,
               ROW2_E = 8'h35,
               ROW2_F = 8'h34;

    assign delay_done = (cnt_20ms==TIME_20MS-1) ? 1'b1 : 1'b0;
    always @(posedge clk) begin
        if (!rst) begin
            cnt_20ms <= 0;
        end
        else if (cnt_20ms == TIME_20MS-1) begin
            cnt_20ms <= cnt_20ms;
        end
        else
            cnt_20ms <= cnt_20ms + 1;
    end

    //500HZ for lcd
    always  @(posedge clk) begin
        if(!rst)begin
            cnt_500hz <= 0;
        end
        else if(delay_done)begin
            if(cnt_500hz == TIME_500HZ - 1)
                cnt_500hz <= 0;
            else
                cnt_500hz<=cnt_500hz + 1 ;
        end
        else
            cnt_500hz <= 0;
    end

    assign lcd_en = (cnt_500hz > (TIME_500HZ-1)/2)? 1'b0 : 1'b1;
    assign lcd_ctrl = (cnt_500hz == TIME_500HZ - 1) ? 1'b1 : 1'b0;

    always  @(posedge clk) begin
        if(!rst)
            currentState <= IDLE;
        else if (lcd_ctrl)
            currentState <= nextState;
        else
            currentState <= currentState;
    end

    always  @(*) begin
        case (currentState)
            IDLE: nextState = SET_FUNCTION;
            SET_FUNCTION: nextState = DISP_OFF;
            DISP_OFF: nextState = DISP_CLEAR;
            DISP_CLEAR: nextState = ENTRY_MODE;
            ENTRY_MODE: nextState = DISP_ON;
            DISP_ON: nextState = ROW1_ADDR;
            ROW1_ADDR: nextState = ROW1_0;
            ROW1_0: nextState = ROW1_1;
            ROW1_1: nextState = ROW1_2;
            ROW1_2: nextState = ROW1_3;
            ROW1_3: nextState = ROW1_4;
            ROW1_4: nextState = ROW1_5;
            ROW1_5: nextState = ROW1_6;
            ROW1_6: nextState = ROW1_7;
            ROW1_7: nextState = ROW1_8;
            ROW1_8: nextState = ROW1_9;
            ROW1_9: nextState = ROW1_A;
            ROW1_A: nextState = ROW1_B;
            ROW1_B: nextState = ROW1_C;
            ROW1_C: nextState = ROW1_D;
            ROW1_D: nextState = ROW1_E;
            ROW1_E: nextState = ROW1_F;
            ROW1_F: nextState = ROW2_ADDR    ;
            ROW2_ADDR: nextState = ROW2_0;
            ROW2_0: nextState = ROW2_1;
            ROW2_1: nextState = ROW2_2;
            ROW2_2: nextState = ROW2_3;
            ROW2_3: nextState = ROW2_4;
            ROW2_4: nextState = ROW2_5;
            ROW2_5: nextState = ROW2_6;
            ROW2_6: nextState = ROW2_7;
            ROW2_7: nextState = ROW2_8;
            ROW2_8: nextState = ROW2_9;
            ROW2_9: nextState = ROW2_A;
            ROW2_A: nextState = ROW2_B;
            ROW2_B: nextState = ROW2_C;
            ROW2_C: nextState = ROW2_D;
            ROW2_D: nextState = ROW2_E;
            ROW2_E: nextState = ROW2_F;
            ROW2_F: nextState = ROW1_ADDR;
            default: nextState = IDLE;
        endcase
    end  

    // LCD control sigal
    assign lcd_rw = 1'b0;
    always  @(posedge clk) begin
        if(!rst) begin
            lcd_rs <= 1'b0;   //order or data  0: order 1:data
        end
        else if (lcd_ctrl) begin
            if((nextState==SET_FUNCTION) || (nextState==DISP_OFF) || (nextState==DISP_CLEAR) || (nextState==ENTRY_MODE)||
                (nextState==DISP_ON ) || (nextState==ROW1_ADDR)|| (nextState==ROW2_ADDR))
                lcd_rs <= 1'b0;
            else
                lcd_rs <= 1'b1;
        end
        else begin
            lcd_rs <= lcd_rs;
        end    
    end                  

    always  @(posedge clk) begin
        if (!rst) begin
            lcd_data <= 8'h00;
        end
        else if(lcd_ctrl) begin
            case(nextState)
                IDLE: lcd_data <= 8'hxx;
                SET_FUNCTION: lcd_data <= 8'h38; //2 lines and 5×7 matrix
                DISP_OFF: lcd_data <= 8'h08;
                DISP_CLEAR: lcd_data <= 8'h01;
                ENTRY_MODE: lcd_data <= 8'h06;
                DISP_ON: lcd_data <= 8'h0C;  //Display ON, cursor OFF
                ROW1_ADDR: lcd_data <= 8'h80; //Force cursor to beginning of first line
                ROW1_0: lcd_data <= row_1 [127:120];
                ROW1_1: lcd_data <= row_1 [119:112];
                ROW1_2: lcd_data <= row_1 [111:104];
                ROW1_3: lcd_data <= row_1 [103: 96];
                ROW1_4: lcd_data <= row_1 [ 95: 88];
                ROW1_5: lcd_data <= row_1 [ 87: 80];
                ROW1_6: lcd_data <= row_1 [ 79: 72];
                ROW1_7: lcd_data <= row_1 [ 71: 64];
                ROW1_8: lcd_data <= row_1 [ 63: 56];
                ROW1_9: lcd_data <= row_1 [ 55: 48];
                ROW1_A: lcd_data <= row_1 [ 47: 40];
                ROW1_B: lcd_data <= row_1 [ 39: 32];
                ROW1_C: lcd_data <= row_1 [ 31: 24];
                ROW1_D: lcd_data <= row_1 [ 23: 16];
                ROW1_E: lcd_data <= row_1 [ 15: 8];
                ROW1_F: lcd_data <= row_1 [ 7: 0];

                ROW2_ADDR: lcd_data <= 8'hC0;      //Force cursor to beginning of second line
                ROW2_0: lcd_data <= row_2 [127:120];
                ROW2_1: lcd_data <= row_2 [119:112];
                ROW2_2: lcd_data <= row_2 [111:104];
                ROW2_3: lcd_data <= row_2 [103: 96];
                ROW2_4: lcd_data <= row_2 [ 95: 88];
                ROW2_5: lcd_data <= row_2 [ 87: 80];
                ROW2_6: lcd_data <= row_2 [ 79: 72];
                ROW2_7: lcd_data <= row_2 [ 71: 64];
                ROW2_8: lcd_data <= row_2 [ 63: 56];
                ROW2_9: lcd_data <= row_2 [ 55: 48];
                ROW2_A: lcd_data <= row_2 [ 47: 40];
                ROW2_B: lcd_data <= row_2 [ 39: 32];
                ROW2_C: lcd_data <= row_2 [ 31: 24];
                ROW2_D: lcd_data <= row_2 [ 23: 16];
                ROW2_E: lcd_data <= row_2 [ 15:  8];
                ROW2_F: lcd_data <= row_2 [  7:  0];
                default: lcd_data <= 8'hxx;
            endcase                    
        end
        else
            lcd_data <= lcd_data ;
    end

endmodule
