module t03_clock_controller(
    input logic halt,
    output logic cpu_clock,
    input logic clock,
    input logic reset
);

reg enable_clock;

always_ff @(negedge clock, posedge reset) begin
    if(reset)
      enable_clock = 0;
    else 
      enable_clock = ~halt;
end

assign cpu_clock = clock && enable_clock;

endmodule