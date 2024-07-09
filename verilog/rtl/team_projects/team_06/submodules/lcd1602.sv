
`default_nettype none
// Empty top module




typedef enum logic [7:0] {
   Reset_High = 8'd1,
   Reset_Low = 8'd0,
   Reset_Second_High = 8'd2,
   ColorConstrast = 8'b11000101, //0xC5
   Memory = 8'b00110110,  //0x36
   PixelFormat = 8'b00111010, //0x3A
   SleepOut = 8'b00010001, //0x11
   DisplayOn = 8'b00101000, //0x29
   MemoryWrite = 8'b00101100 //0x2C
   } MODE;


// module top (
// // I/O ports
// // input logic hwclk,
// input  logic hwclk, reset,
// input  logic [20:0] pb,
// output logic [7:0] left, right,
//       ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
// output logic red, green, blue,


// // UART ports
// output logic [7:0] txdata,
// input  logic [7:0] rxdata,
// output logic txclk, rxclk,
// input  logic txready, rxready


// );


// logic [4:0] tempOut;
// logic [4:0] out;
// logic strobe;
// logic [31:0] sequence_num;
// logic [127:0] row_top;


// display dis (.gameState(WAIT), .gameMode(WALL_SPAWN), .appleLuck(), .gameSpeed(), .score(8'd139), .row_top(row_top), .row_bot());
// //Game State(pixels 1-4), Score(pixel 8-10), 

// //row needs to have 16 characters
// lcd1602 L1 (.clk(hwclk), .rst(~reset), .row_1(row_top), .row_2("       SUS      "), .lcd_en(left[1]), .lcd_rw(left[0]), .lcd_rs(left[3]), .lcd_data(right));


// //print("Number: %d", number);


// endmodule

module display_wrapper(
input logic [7:0] score,
input logic clk, nreset,
input GAME_MODE game_mode,
input GAME_SPEED game_speed,
input GAME_STATE game_state,
input APPLE_LUCK apple_luck,
output logic out1, out2, out3, 
output logic [7:0] out4
);
logic [127:0] row_top, row_bot;

display dis (.gameState(game_state), .gameMode(game_mode), .appleLuck(apple_luck), .gameSpeed(game_speed), .score(score), .row_top(row_top), .row_bot(row_bot));
//Game State(pixels 1-4), Score(pixel 8-10), 

//row needs to have 16 characters
lcd1602 L1 (.clk(clk), .rst(nreset), .row_1(row_top), .row_2(row_bot), .lcd_en(out1), .lcd_rw(out2), .lcd_rs(out3), .lcd_data(out4));

endmodule

module display(
    input GAME_STATE gameState,
    input GAME_MODE gameMode,
    input APPLE_LUCK appleLuck,
    input GAME_SPEED gameSpeed,
    input logic [7:0] score,
    output logic [127:0] row_top,
    output logic [127:0] row_bot
);


//Score Digit Logic
logic [7:0] digit1;
logic [7:0] digit2;
logic [7:0] digit3;
logic [7:0] temp;
logic [7:0] temp2;

always_comb begin
    row_top = {16{8'h20}};
    row_bot = {16{8'h20}};
    case(gameState)
        WAIT: begin
            row_top[127:120] = 8'd87; //W, far left most digit
            row_top[119:112] = 8'd65; //A, secon from left digit
            row_top[111:104] = 8'd73; //I
            row_top[103:96] = 8'd84; //T
        end
        RUN: begin
            row_top[127:120] = 8'd82;
            row_top[119:112] = 8'd85; 
            row_top[111:104] = 8'd78; 
        end
        PAUSE: begin
            row_top[127:120] = 8'd80;
            row_top[119:112] = 8'd65; 
            row_top[111:104] = 8'd85; 
            row_top[103:96] = 8'd83; 
            row_top[95:88] = 8'd69;
        end
        END_GAME: begin
            row_top[127:120] = 8'd69;
            row_top[119:112] = 8'd78; 
            row_top[111:104] = 8'd68; 
        end

        default: begin
            row_top[127:120] = 8'd32;
            row_top[119:112] = 8'd32;
            row_top[111:104] = 8'd32;
            row_top[103:96] = 8'd32;
            row_top[95:88] = 8'd32;
            row_top[87:80] = 8'd32;
        end
    endcase

    case(gameMode)
        TWO_APPLE: begin //2APP
            row_top[31:24] = 8'd50;
            row_top[23:16] = 8'd65;
            row_top[15:8] = 8'd80;
            row_top[7:0] = 8'd80;
        end
        NORMAL_MODE: begin //NORM
            row_top[31:24] = 8'd78;
            row_top[23:16] = 8'd79;
            row_top[15:8] = 8'd82;
            row_top[7:0] = 8'd77;
        end

        WALL_SPAWN: begin //WALL
            row_top[31:24] = 8'd87;
            row_top[23:16] = 8'd65;
            row_top[15:8] = 8'd76;
            row_top[7:0] = 8'd76;
        end

        BORDER_CHANGE: begin //BORD
            row_top[31:24] = 8'd66;
            row_top[23:16] = 8'd79;
            row_top[15:8] = 8'd82;
            row_top[7:0] = 8'd68;
        end
        default: begin 
            row_top[31:24] = 8'd32;
            row_top[23:16] = 8'd32;
            row_top[15:8] = 8'd32;
            row_top[7:0] = 8'd32;
        end
    endcase

    row_bot[71:64] = 8'd83;
    row_bot[63:56] = 8'd80;
    row_bot[55:48] = 8'd68;
    row_bot[47:40] = 8'd58;
    row_bot[39:32] = 8'd32;
    case(gameSpeed)
        NORMAL_SPEED: begin //NORM
            row_bot[31:24] = 8'd78;
            row_bot[23:16] = 8'd79;
            row_bot[15:8] = 8'd82;
            row_bot[7:0] = 8'd77;
        end
        FAST_SPEED: begin //FAST
            row_bot[31:24] = 8'd70;
            row_bot[23:16] = 8'd65;
            row_bot[15:8] = 8'd83;
            row_bot[7:0] = 8'd84;
        end

        SLOW_SPEED: begin //SLOW
            row_bot[31:24] = 8'd83;
            row_bot[23:16] = 8'd76;
            row_bot[15:8] = 8'd79;
            row_bot[7:0] = 8'd87;
        end
        default: begin 
            row_top[31:24] = 8'd32;
            row_top[23:16] = 8'd32;
            row_top[15:8] = 8'd32;
            row_top[7:0] = 8'd32;
        end
    endcase

    case(appleLuck)
        APPLE_NORMAL: begin
            row_bot[127:120] = 8'd78; //W, far left most digit
            row_bot[119:112] = 8'd79; //A, secon from left digit
            row_bot[111:104] = 8'd82; //I
            row_bot[103:96] = 8'd77; //T
            row_bot[95:88] = 8'd65;
            row_bot[87:80] = 8'd76;
        end
          APPLE_LUCKY: begin
            row_bot[127:120] = 8'd76; //W, far left most digit
            row_bot[119:112] = 8'd85; //A, secon from left digit
            row_bot[111:104] = 8'd67; //I
            row_bot[103:96] = 8'd75; //T
            row_bot[95:88] = 8'd89;
          end
          APPLE_UNLUCKY: begin
            row_bot[127:120] = 8'd85; //W, far left most digit
            row_bot[119:112] = 8'd78; //A, secon from left digit
            row_bot[111:104] = 8'd76; //I
            row_bot[103:96] = 8'd85; //T
            row_bot[95:88] = 8'd67;
            row_bot[87:80] = 8'd75;
            row_bot[79:72] = 8'd89;

        end
        default: begin
            row_bot[127:120] = 8'd32;
            row_bot[119:112] = 8'd32;
            row_bot[111:104] = 8'd32;
            row_bot[103:96] = 8'd32;
            row_bot[95:88] = 8'd32;
            row_bot[87:80] = 8'd32;
        end
    endcase

    digit1 = 8'b0; //ones place
    digit2 = 8'b0; //tens place
    digit3 = 8'b0; // hundreds place
    temp = 8'b0;
    temp2 = 8'b0;

    if (score >= 100) begin
        digit3 = score % 10 + 48;
        temp = score / 10;
        digit2 = temp % 10 + 48; 
        temp2 = temp/ 10;
        digit1 = temp2 % 10 + 48;
    end
    else if (score >= 10) begin
        digit3 = score % 10 + 48;
        temp = score / 10;
        digit2 = temp % 10 + 48;
        digit1 = 32;
        
    end
    else begin
        digit3 = score + 48;
        digit2 = 32;
        digit1 = 32;
    end


    row_top [79:72] = digit1;
    row_top [71:64] = digit2;
    row_top [63:56] = digit3;
end

endmodule 
module lcd1602 #(parameter clk_div = 24_000)(
    input clk,
    input rst,
    // Data to be displayed
    input [127:0] row_1,
    input [127:0] row_2,
    
    // LCD control signal
    output lcd_en,
    output lcd_rw,
    output reg lcd_rs,
    output reg [7:0] lcd_data
    );

    logic lcd_ctrl;
    reg [7:0] currentState;
    reg [7:0] nextState;
    reg [17:0] cnt_20ms;
    reg [14:0] cnt_500hz;
    wire delay_done;
  
    localparam TIME_500HZ = clk_div; 
    // Wait for 20 ms before intializing.
    localparam TIME_20MS = TIME_500HZ * 10;
    
    // Set lcd_data accroding to datasheet
    localparam IDLE_LCD = 8'h00,                
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
            currentState <= IDLE_LCD;
        else if (lcd_ctrl)
            currentState <= nextState;
        else
            currentState <= currentState;
    end

    always  @(*) begin
        case (currentState)
            IDLE_LCD: nextState = SET_FUNCTION;
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
            ROW1_F: nextState = ROW2_ADDR;
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
            default: nextState = IDLE_LCD;
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
                IDLE_LCD: lcd_data <= 8'hxx;
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
                ROW1_E: lcd_data <= row_1 [ 15:  8];
                ROW1_F: lcd_data <= row_1 [  7:  0];

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
                ROW2_D: lcd_data <= row_2 [ 23: 
                
                
                
                16];
                ROW2_E: lcd_data <= row_2 [ 15:  8];
                ROW2_F: lcd_data <= row_2 [  7:  0];
                default: lcd_data <= 8'hxx;
            endcase                     
        end
        else
            lcd_data <= lcd_data ;
    end

endmodule
