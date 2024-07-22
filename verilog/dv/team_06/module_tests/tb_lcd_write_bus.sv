`timescale 1ms/10ps

module tb_lcd_write_bus;
    logic clk, nrst;
    logic [7:0] packet_in, packet;
    logic wr, ready;

    lcd_write_bus write_bus (clk, nrst, packet_in, packet, wr, ready);

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
    $dumpvars(0, tb_lcd_write_bus);
    toggle_reset();
    packet_in = 8'haa;
    #800;
    //wait(init_done == 1'b1);

    $finish;
    end

endmodule
