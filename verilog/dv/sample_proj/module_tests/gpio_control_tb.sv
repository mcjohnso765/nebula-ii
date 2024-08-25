

`timescale 1ns/10ps
module gpio_control_tb();
    parameter CLK_PERIOD = 100;
    logic tb_clk;
    logic tb_nrst;

    //emulating project team input
    logic [37:0] tb_io_oeb [12:0];
    logic [37:0] tb_io_out [12:0];

    //select line input
    logic [3:0] tb_pin_0to7_sel [7:0];
    logic [3:0] tb_pin_8to15_sel [7:0];
    logic [3:0] tb_pin_16to23_sel [7:0]; 
    logic [3:0] tb_pin_24to31_sel [7:0]; 
    logic [3:0] tb_pin_32to37_sel [5:0]; 

    //output
    logic [37:0] tb_muxxed_io_oeb;
    logic [37:0] tb_muxxed_io_out;

gpio_control DUT (
    .clk(tb_clk),
    .nrst(tb_nrst),
    .io_oeb(tb_io_oeb),
    .io_out(tb_io_out),

    .pin_0to7_sel(tb_pin_0to7_sel),
    .pin_8to15_sel(tb_pin_8to15_sel),
    .pin_16to23_sel(tb_pin_16to23_sel),
    .pin_24to31_sel(tb_pin_24to31_sel),
    .pin_32to37_sel(tb_pin_32to37_sel),    

    .muxxed_io_oeb(tb_muxxed_io_oeb),
    .muxxed_io_out(tb_muxxed_io_out)
    );

// Signal Dump
initial begin
    $dumpfile ("gpio_control.vcd");
    $dumpvars;
end

//clock gen
always begin
    tb_clk = 1'b0;
    #(CLK_PERIOD/2);
    tb_clk = 1'b1;
    #(CLK_PERIOD/2);
end

integer random_pin_p1; //random only returns 32 bits but we need 38 for the pins
integer random_pin_p2; //so i generate two random 32's and then smash them together to get 38

integer breakout; //integer being used to generate random values for the select lines
integer test_idx; //number of test cases
integer proj_idx; //number of projects
integer pin_idx;  //iterating throught the pins
integer val_1;    //these val variables are for iterating through all the pins as well
integer val_2;    //in 8 pin chunks
integer val_3;
integer val_4;
integer val_5;
task test_random(
    input logic [5:0] num_tests
);
begin
    for(test_idx = 0; test_idx < num_tests; test_idx++) begin
        @(negedge tb_clk)
        
        $info("test case #:%d", test_idx);

        //generating random pin inputs and random select lines 
        for(proj_idx = 0; proj_idx <= 12; proj_idx++) begin
            random_pin_p1 = $random();
            random_pin_p2 = $random();
            tb_io_out[proj_idx] = {random_pin_p2[5:0], random_pin_p1};
            tb_io_oeb[proj_idx] = {random_pin_p1[5:0], random_pin_p2};

            //$info("project %d inputs:", proj_idx);
            //$info("input out: %b", tb_io_out[proj_idx]);
            //$info("input oeb: %b", tb_io_oeb[proj_idx]);
        end
        
        for(pin_idx = 0; pin_idx <= 7; pin_idx++) begin
            breakout = $random();
            if(breakout[3:0] > 12) begin
                breakout[3:0] = 12;
            end
            if(breakout[7:4] > 12) begin
                breakout[7:4] = 12;
            end
            if(breakout[11:8] > 12) begin
                breakout[11:8] = 12;
            end
            if(breakout[15:12] > 12) begin
                breakout[15:12] = 12;
            end
            if(breakout[19:16] > 6) begin
                breakout[19:16] = 6;
            end
            tb_pin_0to7_sel[pin_idx] = breakout[3:0];
            tb_pin_8to15_sel[pin_idx] = breakout[7:4];
            tb_pin_16to23_sel[pin_idx] = breakout[11:8];
            tb_pin_24to31_sel[pin_idx] = breakout[15:12];
            tb_pin_32to37_sel[pin_idx] = breakout[19:16];        
        end


        #(CLK_PERIOD/2); //wait for the design to process the inputs

        for(val_1 = 0; val_1 <= 7; val_1++) begin
            if(tb_muxxed_io_oeb[val_1] == tb_io_oeb[tb_pin_0to7_sel[val_1]][val_1]) begin
                //$info("success");
            end
            else begin  
                $error("failure %d", val_1);
            end
        end
        for(val_2 = 8; val_2 <= 15; val_2++) begin
            if(tb_muxxed_io_oeb[val_2] == tb_io_oeb[tb_pin_8to15_sel[val_2 - 8]][val_2]) begin
                //$info("success");
            end
            else begin  
                $error("failure %d", val_2);
            end
        end
        for(val_3 = 16; val_3 <= 23; val_3++) begin
            if(tb_muxxed_io_oeb[val_3] == tb_io_oeb[tb_pin_16to23_sel[val_3 - 16]][val_3]) begin
                //$info("success");
            end
            else begin  
                $error("failure %d", val_3);
            end
        end
        for(val_4 = 24; val_4 <= 31; val_4++) begin
            if(tb_muxxed_io_oeb[val_4] == tb_io_oeb[tb_pin_24to31_sel[val_4 - 24]][val_4]) begin
                //$info("success");
            end
            else begin  
                $error("failure %d", val_4);
            end
        end
        for(val_5 = 32; val_5 <= 37; val_5++) begin
            if(tb_muxxed_io_oeb[val_5] == tb_io_oeb[tb_pin_32to37_sel[val_5 - 32]][val_5]) begin
                //$info("success");
            end
            else begin  
                $error("failure %d", val_5);
            end
        end

    end

end
endtask


integer zero_idx;
task zero_inputs();
begin
    @(negedge tb_clk)
    for(zero_idx = 0; zero_idx <= 12; zero_idx++) begin
        tb_io_oeb[zero_idx] = '0;
        tb_io_out[zero_idx] = '0;
    end
    for(zero_idx = 0; zero_idx <= 7; zero_idx++) begin
        tb_pin_0to7_sel[zero_idx] = '0;
        tb_pin_8to15_sel[zero_idx] = '0;
        tb_pin_16to23_sel[zero_idx] = '0;
        tb_pin_24to31_sel[zero_idx] = '0;
        tb_pin_32to37_sel[zero_idx] = '0;
    end
end
endtask

task power_on_reset();
begin
    tb_nrst = 1'b1;
    @(posedge tb_clk)
    @(posedge tb_clk)
    tb_nrst = 1'b0;
    @(posedge tb_clk)
    @(posedge tb_clk)
    tb_nrst = 1'b1;
end
endtask


initial begin
    tb_clk  = 1'b0;
    tb_nrst = 1'b1;

    zero_inputs();

    //test cases:
    @(negedge tb_clk)
    power_on_reset();
    $info("anything");
    test_random(6'd60);
    #(CLK_PERIOD * 2);

    $finish;
end


endmodule

