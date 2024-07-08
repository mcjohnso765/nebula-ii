`timescale 1ms/10ps

module tb;
    logic clock = 0;
    logic reset = 0;

    core cpu(.clock(clock), .reset(reset));
    
    initial begin
        // make sure to dump the signals so we can see them in the waveform
        $dumpfile("sim.vcd");
        $dumpvars(0, tb);
        #2 reset = 1;
        #2 reset = 0;
        // finish the simulation
        #1 $finish;
    end


endmodule

