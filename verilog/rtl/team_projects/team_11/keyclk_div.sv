
module keyclk_div(
    input logic clk,
    input logic nrst,
    input logic [29:0]max,
    output logic at_max
    );

    // parameter OG_CLK = 100; /// 2.4 GHz signal ie 2400000000
    // parameter BAUD_RATE = 0.000001; // a higher baud rate means a higher rate of transmission, it's essentially a unit of measurement that represents the number of signal changes
    // parameter DIV_FACTOR = 1200000; // so input signal divided by the rate of transmission 

    logic next_clk;
    logic [29:0]count;
    logic [29:0]next_count;


    // always_ff @(posedge clk, negedge nrst) begin
    //     if(!nrst) begin
    //         count <= 0;
    //         new_clk <= 1; // it's one not 0 because when it resets the clk starts on the posedge of the clk we're not starting on negedge of clock
    //     end
    //     else begin
    //         count <= next_count; 
    //         new_clk <= next_clk;
    //     end
    // end

    always_ff @(posedge clk, negedge nrst) begin
        if (!nrst) 
           
            count <= 30'b0;
        else
            count <= next_count;
            end

    // always_comb begin
    //     next_clk = new_clk;
    //     next_count = count + 1; 

    //     if(count == DIV_FACTOR -1) begin   
    //         next_count = 0; 
    //         next_clk = ~new_clk; 
    //     end 
    // end
    assign at_max = (count == max);
        always_comb begin
            if(at_max)
                next_count = 30'b0;
            else
                next_count = count + 1;


    end
endmodule