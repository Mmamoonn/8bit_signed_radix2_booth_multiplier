module controller (
    input  logic clk, rst, start, count_max,
    output logic busy, done, load, arithmetic_shift_right, count_enable
);
  // State Encoding
  typedef enum logic [1:0] {
        IDLE      = 2'b00,
        LOAD      = 2'b01,
        CALCULATE = 2'b10,
        DONE      = 2'b11
    } state_t;

    state_t current, next;

    // Block 1: Synchronous State Register
    always_ff @(posedge clk) begin
      if (!rst) begin
        current <= IDLE;
      end 
      else begin
        current <= next;
      end
    end

   // Block 2 + 3: Combinational Next-State Logic & Output Logic (Moore FSM)
    always_comb begin
      busy = 1'b0;
      done = 1'b0;
      load = 1'b0;
      arithmetic_shift_right = 1'b0;
      count_enable = 1'b0;
      next = current;
      
      case (current)
        IDLE: begin
          if (start) begin
            next = LOAD;
          end
        end
        LOAD: begin
          busy = 1'b1;
          load = 1'b1;
          next = CALCULATE; // Unconditional transition
        end
        CALCULATE: begin
          busy = 1'b1;
          arithmetic_shift_right = 1'b1;
          count_enable = 1'b1;
          if (count_max) begin
            next = DONE;
          end
        end
        DONE: begin
          done = 1'b1;
          next = IDLE;      // Unconditional transition
        end
        default: begin
          next = IDLE;
        end
      endcase
    end
    // SystemVerilog Assertions (SVA)
    
    // 1. Mutual Exclusion: busy and done should never be high simultaneously
    property p_busy_done_mutex;
        @(posedge clk) disable iff (!rst)
        not (busy && done);
    endproperty
    assert property (p_busy_done_mutex) else $error("SVA Violation: busy and done are both HIGH.");

    // 2. Single Cycle Load: 'load' must only remain high for exactly one clock cycle
    property p_load_single_cycle;
        @(posedge clk) disable iff (!rst)
        load |=> !load;
    endproperty
    assert property (p_load_single_cycle) else $error("SVA Violation: load asserted for multiple cycles.");

    // 3. Calculation Integrity: shift and count enable must be active together
    property p_calc_enables;
        @(posedge clk) disable iff (!rst_n)
        (current_state == CALCULATE) |-> (arithmetic_shift_right && count_enable);
    endproperty
    assert property (p_calc_enables) else $error("SVA Violation: Shift or Count missing during CALCULATE.");
endmodule
