module random_num_gen_wall_mode(
    input logic enable, system_clk, nreset, //change enable whenever a new number is wanted
    output logic [7:0] number_out  // 8 bit number finrst 4 are x, last 4 are y
);

logic [7:0] number;
logic counter, counter_next;

always_ff @(posedge system_clk, negedge nreset) begin

if (~nreset) begin
    number = 8'd2;
    counter_next = 0;
end
else begin //"randomly cycles through numbers"
    number = {number[6:0], ~(number[6] ^ number[5])};
    counter_next = counter;
end
end

always_ff @(posedge enable) begin ///only update the random number when enable is switched on

counter <= counter_next;

if (counter) begin
    number_out <= number;
    counter <= 0;
  end


else begin
  number_out <= ({number[3:0], number[7:4]});
  counter <= 1;
  end
end
endmodule
