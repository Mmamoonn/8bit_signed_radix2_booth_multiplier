module adder_subtractor (
  input  logic signed [7:0] a,       // From Accumulator (P[15:8])
  input  logic signed [7:0] m,       // From Multiplicand (M[7:0])
  input  logic add_en, sub_en,       // From Booth Encoder
  output logic signed [8:0] result   // To 2-to-1 Multiplexer
);
    always_comb begin
      //default_case: "If both add_en & sub_en signals are low (the 00 or 11 Booth condition), it defaults to outputting the unmodified Sign-extended Accumulator value a.
      result = {a[7],a};		 
      if (add_en) begin
        result = {a[7],a} + {m[7], m};
      end 
      else if (sub_en) begin
        result = {a[7],a} - {m[7], m};
      end
    end
endmodule
