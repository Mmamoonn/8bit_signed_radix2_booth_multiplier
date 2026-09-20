`timescale 1ns/1ps
module tb_top;
  logic clk, rst, start, busy, done;
  logic signed [7:0]  multiplicand, multiplier;
  logic signed [15:0] product;
  // Expected Result for Self-Checking
  logic signed [15:0] expected_product;
  
  initial clk = 0;
  always #5 clk = ~clk;

  booth_multiplier dut (.clk(clk),.rst(rst),.start(start),.multiplicand(multiplicand),.multiplier(multiplier),.product(product),.busy(busy),.done(done));
  
  task automatic check(input logic signed [7:0] a, input logic signed [7:0] b);
    begin
      @(negedge clk);
      multiplicand = a;
      multiplier = b;
      start = 1'b1;
      
      @(negedge clk);
      start = 1'b0; 
      // Wait for the FSM to assert the done flag
      wait(done == 1'b1);
      expected_product = signed(a) * signed(b);
            
      // Self-Checking Verification
      if (product !== expected_product) begin
        $display("[FAIL] Multiplicand: %0d & Multiplier: %0d | Expected: %0d, Actual: %0d", a, b, expected_product, product);
      end 
      else begin
        $display("[PASS] Multiplicand: %0d & Multiplier: %0d | Value: %0d", a, b, product);
      end
      // Waiting few cycles before the next test
      repeat(3) @(posedge clk);
    end
  endtask
  
  initial begin
    $dumpfile("sim/waves.vcd");
    $dumpvars(0, tb_top);
    rst = 1'b1;
    start = 1'b0;
    multiplicand = 8'd0;
    multiplier = 8'd0;
    
    $display("--- Applying Active-Low Synchronous Reset ---\n");
    #15 rst = 1'b0;
    #15 rst = 1'b1;
    repeat(2) @(posedge clk);
    $display("Starting 8-Bit Signed Radix-2 Booth Multiplier Testing\n");
    $display("Testing - Phase 1: Verification Scenarios\n");
    // 1. Positive x Positive
    check(8'sd12, 8'sd5);
    // 2. Positive x Negative
    check(8'sd7, -8'sd6);
    // 3. Negative x Positive
    check(-8'sd9, 8'sd4);
    // 4. Negative x Negative
    check(-8'sd8, -8'sd3);
    // 5. Zero Multiplication
    check(8'sd0, 8'sd15);
    check(-8'sd22, 8'sd0);
    // 6. Maximum Positive Value (127)
    check(8'sd127,8'sd127);
    // 7. Minimum Negative Value (-128)
    check(-8'sd128,-8'sd128);
    $display("Testing - Phase 2: Corner Cases\n");
    // 1. 0 x 0
    check(8'sd0, 8'sd0);
    // 2. 0 x X
    check(8'sd0, -8'sd10);
    // 3. X x 0
    check(-8'sd10, 8'sd0);
    // 4. 127 x 127
    check(8'sd127, 8'sd127);
    // 5. -128 x -1
    check(-8'sd128, -8'sd1);
    // 6. -128 x 127
    check(-8'sd128,8'sd127);
    // 7. -1 x -1
    check(-8'sd1,-8'sd1);
    // 8. 1 x -128
    check(8'sd1,-8'sd128);
    $display("Testing - Phase 3: Randomized Testing (200 - Random Tests)\n");
    for(int i = 0; i < 200; i++) begin
      logic [7:0] random_a, random_b;
      random_a = $urandom;
      random_b = $urandom;
      check(random_a.random_b);
    end
    $display("Verification & Testing Completed");
    $finish;
  end
endmodule
