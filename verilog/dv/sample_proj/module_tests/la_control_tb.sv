`timescale 1ns/10ps
module la_control_tb();
    parameter CLK_PERIOD = 100;
    logic tb_clk;
    logic tb_nrst;

    //inputs
    logic [3:0] tb_la_sel;
    logic [127:0] tb_la_dat [12:0];

    //output
    logic [127:0] tb_muxxed_la_dat;

//clock gen
always begin
    tb_clk = 1'b0;
    #(CLK_PERIOD/2);
    tb_clk = 1'b1;
    #(CLK_PERIOD/2);
end

// Signal Dump
initial begin
    $dumpfile ("la_control.vcd");
    $dumpvars;
end

la_control DUT (
    .clk(tb_clk),
    .nrst(tb_nrst),
    .la_sel(tb_la_sel),
    .la_dat(tb_la_dat),
    .muxxed_la_dat(tb_muxxed_la_dat)
);

integer zero_idx;
task zero_inputs();
begin
    @(negedge tb_clk)
    for(zero_idx = 0; zero_idx <= 12; zero_idx++) begin
        tb_la_dat[zero_idx] = '0;
    end
end
endtask

integer test_idx; // looping through the number of test cases for the task
integer team_idx;  // looping through the number of teams (12)

integer dat_p1; //every data input is 128 bits for the 13 teams
integer dat_p2; //therefore I need to generate and concatinate 4 32 bit numbers
integer dat_p3;
integer dat_p4;

integer random_sel; //sel is a 4 bit number so this is a placeholder for that tb signal
task random_test_case(
    input logic [5:0] num_tests
);

    for(test_idx = 0; test_idx < num_tests; test_idx++) begin
        
        random_sel = $random();
        if(random_sel[3:0] > 12) begin
            random_sel[3:0] = 12;
        end
        tb_la_sel = random_sel[3:0]; //you can see why I needed that place holder here


        //generating the random input of the teams
        for(team_idx = 0; team_idx <= 12; team_idx++) begin
            dat_p1 = $random();
            dat_p2 = $random();
            dat_p3 = $random();
            dat_p4 = $random();
            tb_la_dat[team_idx] = {dat_p1, dat_p2, dat_p3, dat_p4};
        end

        #(CLK_PERIOD/2); //wait for the signals to settle

        if(tb_muxxed_la_dat == tb_la_dat[tb_la_sel]) begin
            $info("the mux worked!!!");
        end
        else begin
            $error("HOW IS IT POSSIBLE YOU MESSED THIS UP");
        end

    end


endtask

initial begin
    tb_la_sel = '0;
    zero_inputs();

    random_test_case(6'd60);

    $finish;
end
endmodule