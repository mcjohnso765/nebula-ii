`timescale 1ms/10ps

module tb_address_set;
    logic clk, nrst;
    logic [7:0] packet;
    logic [3:0] x, y, x2, y2;
    logic rs, wr, rst, address_set_ready;

    address_set test (.clk(clk), .reset_n(nrst), .enable(1'b1), .x_1(x), .x_2(x2), .y_1(y), .y_2(y2), .out(packet), .rs(rs), .wr(wr), .address_ready(address_set_ready));

    always begin
        clk = 1'b0; #10;
        clk = 1'b1; #10;
    end

    task toggle_reset;
        nrst = 1'b1; #10;
        nrst = 1'b0; #10;
        nrst = 1'b1;
    endtask

    initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_address_set);
    toggle_reset();
    x = 4'd5;
    y = 4'd2;
    x2 = 4'd9;
    y2 = 4'd6;
    //#500;
    wait(address_set_ready);

    $finish;
    end

endmodule
