`timescale 1ms/10ps

module tb_lcd_fill_rect;
    logic clk, nrst;
    logic [7:0] packet;
    logic [15:0] color_data;
    logic [3:0] x, y;
    logic cs, rs, wr, rst, fill_rect_ready;

    lcd_fill_rect test (.clk(clk), .nrst(nrst), .module_enable(1'b1), .x(x), .y(y), .color(color_data), .out(packet), .cs(cs), .rs(rs), .wr(wr), .rst(rst), .fill_rect_ready(fill_rect_ready));

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
    $dumpvars(0, tb_lcd_fill_rect);
    y = 0;
    color_data = 16'hf800;
    x = 0;
    // for(integer i = 0; i<= 15; i++) begin
    //     toggle_reset();
    //     x = i[3:0];
    //     wait(fill_rect_ready);
    //     #1000;
    // end

    $finish;
    end

endmodule