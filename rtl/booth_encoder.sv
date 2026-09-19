module booth_encoder (
    input  logic p_0,        // Multiplier LSB (P[0])
    input  logic booth_bit,  // Trailing Booth Bit (P[-1])
    output logic add_en,     // Signal to trigger Addition (A = A + M)
    output logic sub_en      // Signal to trigger Subtraction (A = A - M)
);
  always_comb begin
    add_en = 1'b0;
    sub_en = 1'b0;
    
    case ({p_0, booth_bit})
      2'b01: add_en = 1'b1; //Addition  
      2'b10: sub_en = 1'b1; //Subtraction
      // 2'b00 and 2'b11 (No Operation) are handled by the defaults
      default: begin
        add_en = 1'b0;
        sub_en = 1'b0;
      end
    endcase
  end
endmodule
