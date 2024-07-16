`timescale 1ms/10ps

module tb_lcd_init;
    logic clk, nrst;
    logic [7:0] packet;
    logic rs, wr, rst, init_done;

    lcd_init setup (.clk(clk), .reset_n(nrst), .out(packet), .rs(rs), .wr(wr), .rst(rst), .init_done(init_done));

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
    $dumpvars(0, tb_lcd_init);
    toggle_reset();
    wait(init_done == 1'b1);
    #100;

    $finish;
    end

endmodule
