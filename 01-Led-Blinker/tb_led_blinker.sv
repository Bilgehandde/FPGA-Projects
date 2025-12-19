`timescale 1ns / 1ps

module tb_led_blinker;

    // -------------------------------------------------
    // Clock parameters (Basys 3 compatible)
    // -------------------------------------------------
    localparam time CLK_PERIOD = 10ns; // 100 MHz → 10ns

    // Override for fast simulation
    localparam int TB_CLK_LIMIT = 9;

    // -------------------------------------------------
    // Signals
    // -------------------------------------------------
    logic tb_clk;
    logic tb_rst;
    logic tb_led;

    // -------------------------------------------------
    // DUT Instantiation
    // -------------------------------------------------
    led_blinker #(
        .CLK_LIMIT(TB_CLK_LIMIT)
    ) dut (
        .i_clk(tb_clk),
        .i_rst(tb_rst),
        .o_led(tb_led)
    );

    // -------------------------------------------------
    // Clock Generation (100 MHz)
    // -------------------------------------------------
    always #(CLK_PERIOD/2) tb_clk = ~tb_clk;

    // -------------------------------------------------
    // Self-checking variables
    // -------------------------------------------------
    int cycle_count = 0;
    int error_count = 0;
    logic expected_led;

    // -------------------------------------------------
    // Reset & Stimulus
    // -------------------------------------------------
    initial begin
        $display("=======================================");
        $display(" LED BLINKER SELF-CHECKING TEST STARTED ");
        $display("=======================================");

        tb_clk = 0;
        tb_rst = 1;
        expected_led = 0;

        // Hold reset for 2 clock cycles
        #(2 * CLK_PERIOD);
        tb_rst = 0;

        // Run simulation for multiple toggles
        repeat (50) begin
            @(posedge tb_clk);
            cycle_count++;

            // Check if LED SHOULD toggle
            if (cycle_count == (TB_CLK_LIMIT + 1)) begin
                expected_led = ~expected_led;
                cycle_count = 0;
            end

            // SELF-CHECK
            if (tb_led !== expected_led) begin
                $error("FAIL @ %0t ns | Expected LED=%0b, Got=%0b",
                        $time, expected_led, tb_led);
                error_count++;
            end
        end

        // -------------------------------------------------
        // Final Report
        // -------------------------------------------------
        if (error_count == 0)
            $display("✅ TEST PASSED: No errors detected");
        else
            $display("❌ TEST FAILED: %0d errors detected", error_count);

        $finish;
    end

endmodule
