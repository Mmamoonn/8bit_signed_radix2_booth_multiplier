module datapath (
    input  logic clk, rst,
    input  logic signed [7:0]  multiplicand_in, multiplier_in,
    // Control signals from FSM
    input  logic load, arithmetic_shift_right, count_enable,
    // Status signals to FSM
    output logic count_max,
    // Final output
    output logic signed [15:0] product
);

    // Internal Registers for Instantiating 
    logic signed [7:0]  M;
    logic signed [15:0] P;
    logic booth_bit;
    logic [2:0] count;

    // Combinational Wires
    logic add_en, sub_en;
    logic signed [8:0]  alu_out, mux_out;
    
    // Instantiate Booth Encoder
    booth_encoder encoder (.p_0(P[0]),.booth_bit(booth_bit),.add_en(add_en),.sub_en(sub_en));

    // Instantiate Adder/Subtractor
    adder_subtractor alu (.a(P[15:8]),.m(M),.add_en(add_en),.sub_en(sub_en),.result(alu_out));

    // 2-to-1 Multiplexer
    assign mux_out = (add_en | sub_en) ? alu_out : {P[15], P[15:8]};

    // Status & Product Assignment
    assign product   = P;
    assign count_max = (count == 3'd7);

    // Synchronous Logic
    always_ff @(posedge clk) begin
      if (!rst) begin
        M <= 8'b0;
        P <= 16'b0;
        booth_bit <= 1'b0;
        count <= 3'b0;
      end 
      else if (load) begin
        M <= multiplicand_in;
        P <= {8'b0, multiplier_in}; // Declaring and Initializing Product P[15:8]: Upper bits = 0 P[15:8] & Lower Bits = Multipler Input P[7;0]
        booth_bit <= 1'b0;                 // Initially Booth bit = 0
        count <= 3'b0;		           // Reset iteration counter
      end 
      else begin
        // Shift Right Arithmetic
        if (arithmetic_shift_right) begin
          P <= {mux_out[8:0], P[7:1]}; 
          booth_bit <= P[0];
        end
        if (count_enable) begin
          count <= count + 1'b1;
        end
      end
    end
endmodule
