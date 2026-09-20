module tb_controller;
    logic clk, rst, start, count_max, busy, done, load, arithmetic_shift_right, count_enable;

    controller fsm_inst (.*);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
      $display("--- Starting Controller FSM Verification ---");
        
        // 1. Reset Phase
        rst = 0; start = 0; count_max = 0;
        #15 rst = 1;
        @(posedge clk);
        
        // Check IDLE state
        if (busy || done || load || count_enable) 
          $error("Failed IDLE initialization");
        
        // 2. Trigger LOAD State
        start = 1;
        @(posedge clk);
        start = 0; 
        if (!load || !busy) 
          $error("Failed LOAD state logic");
        
        // 3. Verify CALCULATE State
        @(posedge clk);
        if (load || !busy || !arithmetic_shift_right || !count_enable) 
          $error("Failed CALCULATE logic");
        
        // Simulate counting for 7 cycles
        repeat(7) @(posedge clk);
        
        // Trigger DONE State
        count_max = 1;
        @(posedge clk);
        count_max = 0;
        
        if (!done || busy) 
          $error("Failed DONE logic");
        
        // 4. Return to IDLE
        @(posedge clk);
        if (busy || done) 
          $error("Failed return to IDLE");

        $display("--- FSM Verification Passed ---");
        $finish;
    end
endmodule
