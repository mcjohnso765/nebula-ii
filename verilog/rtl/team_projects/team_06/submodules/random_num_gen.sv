
module random_num_gen(
    input logic enable, system_clk, nreset, //change enable whenever a new number is wanted
    output logic [7:0] number_out  // 8 bit number first 4 are x, last 4 are y
);

logic [7:0] number;
logic counter, counter_next, counter_normal, counter_normal_next, counter_flip, counter_flip_next;

always_ff @(posedge system_clk, negedge nreset) begin

if (~ nreset) begin
    number = 8'd0;
    counter_next = 0;
    counter_flip_next = 0;
    counter_normal_next = 0;
end
else begin //"randomly cycles through numbers"
    number = {number[6:0], ~(number[6] ^ number[5])};
    counter_next = counter;
    counter_flip_next = counter_flip;
    counter_normal_next = counter_normal;
end
end

always_ff @(posedge enable) begin ///only update the random number when enable is switched on

counter <= counter_next;
counter_normal <= counter_normal_next;
counter_flip <= counter_flip_next;

if (counter) begin
  if (counter_normal) begin
    number_out <= number - 8'd1;
    counter <= 0;
    counter_normal <= 0;
    counter_flip <= counter_flip;
  end
  else begin
  number_out <= number; //do not change the number if it is not needed
  counter <= 0;
  counter_normal <= 1;
  counter_flip <= counter_flip;
  end
end

else begin
  if (counter_flip) begin
  number_out <= ({number[3:0], number[7:4]} - 8'd1);
  counter <= 1;
  counter_normal <= counter_normal;
  counter_flip <= 0;
  end
  else begin
  number_out <= ({number[3:0], number[7:4]});
  counter <= 1;
  counter_normal <= counter_normal;
  counter_flip <= 1;
end
end

end
endmodule