
module team_08_random_generator(
    input logic clk,
    input logic rst_n,
    input logic [3:0] MCNT1, MCNT2,
    input logic button_pressed,
    input state_t state,
    output logic [1:0] rnd // 2-bit random number generator output
);

    //slow clock
    logic slow_clk1, slow_clk2;
    logic [3:0] MCNT;
    //instantiate clock_div0 and clock_div1 to generate different clock for two LFSRs
    clock_div0 clock_div_inst0 (.clk(clk), .reset(rst_n), .button_pressed(button_pressed), .MCNT(MCNT1), .clk1(slow_clk1)); // for 1st LFSR. toggle every 700ns
    clock_div0 clock_div_inst1 (.clk(clk), .reset(rst_n), .button_pressed(button_pressed),  .MCNT(MCNT2), .clk1(slow_clk2)); // for 2nd LFSR. toggle every 200ns
    //clock_div1 clock_div_inst1 (.clk(clk), .reset(rst_n), .button_pressed(button_pressed), .clk2(slow_clk2)); //for 2nd LFSR, toggle every 300ns

    // LFSR1: 2-bit
    logic [1:0] lfsr1, n_lfsr1;
    logic feedback1;

    // LFSR2: 2-bit
    logic [1:0] lfsr2, n_lfsr2;
    logic feedback2;

    // LFSR1: 2-bit with polynomial x^2 + x + 1
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            lfsr1 <= 2'b11; // Seed value to avoid all-0 state
        else begin
            lfsr1 <= n_lfsr1;
        end
    end

    // LFSR2: 2-bit with polynomial x^2 + x + 1
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            lfsr2 <= 2'b10; // eed value to avoid all-0 state
        else begin
            lfsr2 <= n_lfsr2;
        end
    end

    // Combine outputs to form the final random number
    always_comb begin
        feedback1 = lfsr1[1] ^ lfsr1[0];
        feedback2 = lfsr2[1] ^ lfsr2[0];
        n_lfsr1 = lfsr1;
        n_lfsr2 = lfsr2;
        rnd = lfsr1 ^ lfsr2;

        case(state)

            IDLE: begin
                n_lfsr1 = 2'b11;
                n_lfsr2 = 2'b10;
                rnd = lfsr1 ^ lfsr2;
            end
            
            RUN: begin
                if(slow_clk1) begin
                    feedback1 = lfsr1[1] ^ lfsr1[0];
                    n_lfsr1 = {lfsr1[0], feedback1};
                end
                else begin
                    feedback1 = feedback1;
                    n_lfsr1 = lfsr1;
                end

                if(slow_clk2) begin
                    feedback2 = lfsr2[1] ^ lfsr2[0];
                    n_lfsr2 = {lfsr2[0], feedback2};
                end
                else begin
                    feedback2 = feedback2;
                    n_lfsr2 = lfsr2;
                end
                
                rnd = lfsr1 ^ lfsr2; // XOR the outputs of the two LFSRs to combine them
            end

            OVER: begin
                n_lfsr1 = 2'b11;
                n_lfsr2 = 2'b10;
            end

            WIN: begin
                n_lfsr1 = 2'b11;
                n_lfsr2 = 2'b10;
            end

            default: begin
                n_lfsr1 = 0;
                n_lfsr2 = 0;
            end

        endcase
    end

endmodule

module clock_div0 (
    input logic clk,
    input logic reset,
    input logic button_pressed,
    input logic [3:0] MCNT,
    output logic clk1
    // output logic clk2
);
    //generate clock1
   //10 MHz -- frequency: 0.0000001s = 100 ns
   //clock 1: toggle once every 200ns --> 200 ns / 100 ns = 2 (-1 for counter)
   //clock 2: toggle once every 300ns --> 300 ns / 100 ns = 3 (-1 for counter)
   logic [13:0] counter;
   //parameter MCNT = 7;

   always_ff @(posedge clk, negedge reset) begin
    if(!reset) begin 
        counter <= 0;
    end
    else if(button_pressed) begin
        counter <= 0;
    end
    else if(counter == MCNT - 1) begin
        counter <= 0;
        clk1 = 1;
    end 
    else begin counter <= counter + 1;
        clk1 = 0;
    end
   end
endmodule
