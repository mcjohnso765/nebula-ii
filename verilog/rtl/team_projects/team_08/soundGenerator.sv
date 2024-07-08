
`include "dac.sv"

module soundGenerator(
    input clk,
    input appleEaten,
    input gameOver,
    //input goodCollision,
    input rst,
    output dac_sdi,
    output dac_cs,
    output dac_sck,
    output [2:0] leds, output test
);
    wire [9:0] data_in;
    reg [9:0] dataSound;
    wire playSound;

    assign test = freqClk;
    dac dac(.clk(clk), .dac_data(data_in), .start_transmit(playSound), .dac_mosi(dac_sdi), .dac_cs(dac_cs), .dac_sclk(dac_sck));

    assign data_in = dataSound;
    soundGame game(clk, rst, appleEaten, gameOver, dataSound, playSound, leds, freqClk);


endmodule

module soundGame(
    input clk,
    input rst,
    input appleEaten,
    input gameOver,
    output [9:0] data,
    output play,
    output [2:0] leds, 
    output freqClk
);
    assign leds = {countFreq[2:1], play};

    // Create registers for the slower clock signals and counters
    reg [2:0] note;
    reg playApple;
    reg playOver;
    reg [31:0] countFreq;
    wire freqClk;
    wire durationClk;

    reg [9:0] dataNote;

    assign data = dataNote;//playOver ? dataOver : dataApple;

    assign play = playApple | playOver;

    // Create slower clocks for the duration and frequency of the notes
    clk_div new_clk(clk, countFreq, freqClk);
    //clk_div apple_clk(clk, countApple, appleClk);
    clk_div duration_clk(clk, 32'd1500000, durationClk);

    // Update the note once the duration is done
    always @(posedge durationClk) begin
        if (playOver | playApple)
            note <= note + 1;
        else note <= 0;
    end

    // A table of note frequencies to use
    always @(note) begin
        case (note)
            // 0: countFreq <= playWin ? 32'd30 : 30;//(playOver ? 32'd30 : 32'd20);
            // 1: countFreq <= playWin ? 32'd20 : 20;//(playOver ? 32'd20 : 32'd20);
            // 2: countFreq <= playWin ? 32'd10 : 30;//(playOver ? 32'd30 : 32'd10);
            // 3: countFreq <= playWin ? 32'd20 : 40;//(playOver ? 32'd40 : 32'd10);
            // 4: countFreq <= playWin ? 32'd10 : 50;//(playOver ? 32'd50 : 32'd0);
            // 5: countFreq <= playWin ? 32'd10 : 50;//(playOver ? 32'd50 : 32'd0);
            // 6: countFreq <= playWin ? 32'd10 : 50;//(playOver ? 32'd50 : 32'd0);
            // 7: countFreq <= playWin ? 32'd10 : 50;//(playOver ? 32'd50 : 32'd0);
            0: begin
                //countOver <= 30;
                countFreq <= 20;
            end
            1: begin
                //countOver <= 20;
                countFreq <= 10;
            end
            2: begin
                //countOver <= 30;
                countFreq <= playApple ? 1500000 : 30;
            end
            3: begin
                //countOver <= 40;
                countFreq <= playApple ? 1500000 : 40;
            end
            4: begin
                //countOver <= 50;
                countFreq <= playApple ? 1500000 : 50;
            end
            5: begin
                //countOver <= 50;
                countFreq <= playApple ? 1500000 : 50;
            end
            6: begin
                //countOver <= 50;
                countFreq <= playApple ? 1500000 : 50;
            end
            7: begin
                //countOver <= 50;
                countFreq <= playApple ? 1500000 : 50;
            end
        endcase
    end

    // Wave shaper (creates a saw tooth wave)
    // always@(posedge overClk) begin
    //     dataOver <= (dataOver + 1);
    // end

    // Wave shaper (creates a saw tooth wave)
    always@(posedge freqClk) begin
        dataNote <= (dataNote + 1);
    end

    // Update regiter to indicate whether all notes have been outputted
    always @(posedge clk) begin
        if (!rst) begin 
            playApple <= 0;
            playOver <= 0;
        end
        else if (appleEaten) begin
            playApple <= 1;
            playOver <= 0;
        end
        else if (gameOver) begin
            playOver <= 1;
            playApple <= 0;
        end
        else if ((note == 2) & (playApple)) begin
            playApple <= 0;
        end
        else if ((note == 7) & (playOver)) begin
            playOver <= 0;
        end
    end

endmodule


module soundGameOver(
    input clk,
    input rst,
    input enable,
    output reg [9:0] data,
    output playOver
);
    assign playOver = play;

    // Create registers for the slower clock signals and counters
    reg [2:0] note;
    reg play;
    reg [31:0] countFreq;
    wire freqClk;
    wire durationClk;

    // Create slower clocks for the duration and frequency of the notes
    clk_div new_clk(clk, countFreq, freqClk);
    clk_div duration_clk(clk, 32'd1500000, durationClk);

    // Update the note once the duration is done
    always @(posedge durationClk) begin
        if (play)
            note <= note + 1;
        else note <= 0;
    end

    // A table of note frequencies to use
    always @(note) begin
        case (note)
            0: countFreq <= 30;
            1: countFreq <= 20;
            2: countFreq <= 30;
            3: countFreq <= 40;
            4: countFreq <= 50;
            5: countFreq <= 50;
            6: countFreq <= 50;
            7: countFreq <= 50;
        endcase
    end

    // Wave shaper (creates a saw tooth wave)
    always@(posedge freqClk) begin
        data <= (data + 1);
    end

    // Update regiter to indicate whether all notes have been outputted
    always @(posedge clk) begin
        if (!rst) play <= 0;
        else if (enable) begin
            play <= 1;
        end
        else if (note == 7) play <= 0;
    end

endmodule

module clk_div(clk, count, slowClk);

    input clk; //system clock
    input [31:0] count; // what to count up to
    output reg slowClk; //slow clock

    reg[31:0] counter;

    initial begin
        counter = 0;
        slowClk = 0;
    end

    always @ (posedge clk)
        begin
        if(counter == count) 
        begin
            counter <= 1;
            slowClk <= ~slowClk;
        end
        else 
        begin
            counter <= counter + 1;
        end
    end

endmodule


// module Button(
// 	input         clk,     // clock input from FPGA (12MHz)
// 	input         noisy,   // noisy button input
// 	output        debounce // debounced button output, 
//   );     
//   parameter LIMIT = 120000; // set the bouncing threshold to 10ms, 10ms / (1/12MHz) = 120000 clock cycles
  
//   reg    [16:0] r_counter;  // size need to be larger or equal to LIMIT
//   reg           r_debounce;
  
//   assign debounce = r_debounce;

//   always @ (posedge clk) begin
//     if (noisy !== r_debounce && r_counter < LIMIT)
//       r_counter <= r_counter + 1;
//     else if (r_counter == LIMIT) begin
//       r_debounce <= noisy;
//       r_counter <= 17'b0;
//     end
//     else  
//       r_counter <= 17'b0;
//   end
  
// endmodule