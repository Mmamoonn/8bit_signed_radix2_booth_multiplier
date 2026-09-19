module booth_multiplier (
  //Input Ports
  input logic clk, rst, start,
  input logic signed [7:0] multiplicand, multiplier,
  //Output Ports
  output logic signed [15:0] product,
  output logic busy, done
);
  // Internal interconnect wires between Controller and Datapath
  logic load, arithmetic_shift_right, count_enable, count_max;

  // Instantiate the Controller FSM
  controller fsm (.clk(clk),.rst(rst),.start(start),.count_max(count_max),.busy(busy),.done(done),.load(load),.arithmetic_shift_right(arithmetic_shift_right),.count_enable(count_enable));

    // Instantiate the Datapath
    datapath data_path (.clk(clk),.rst(rst),.multiplicand_in(multiplicand),.multiplier_in(multiplier),.load(load),.arithmetic_shift_right(arithmetic_shift_right),.count_enable(count_enable),.count_max(count_max),.product(product));

endmodule
