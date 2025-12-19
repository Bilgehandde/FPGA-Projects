`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Bilgehan Dede
// Design Name:    Button Debouncer Self-Checking Testbench
// Module Name:    tb_button_debouncer
// Project Name:   FPGA Portfolio
// Description:
//    Self-checking testbench that verifies debounce behavior and
//    ensures a single-cycle pulse is generated per valid button press.
//////////////////////////////////////////////////////////////////////////////////

module tb_button_debouncer;

    // --- Signals ---
    logic tb_clk;
    logic tb_rst;
    logic tb_btn;
    logic tb_debounced;
    logic tb_pulse;

    // --- Parameters ---
    localparam int TB_DEBOUNCE_LIMIT = 10; // fast simulation
    localparam time CLK_PERIOD = 10ns;     // 100 MHz

    // --- DUT ---
    button_debouncer #(
        .DEBOUNCE_LIMIT(TB_DEBOUNCE_LIMIT)
    ) dut (
        .i_clk(tb_clk),
        .i_rst(tb_rst),
        .i_btn(tb_btn),
        .o_debounced(tb_debounced),
        .o_pulse(tb_pulse)
    );

    // --- Clock ---
    always #(CLK_PERIOD/2) tb_clk = ~tb_clk;

    // --- Self-checking variables ---
    int pulse_count = 0;
    int error_count = 0;

    // --- Monitor pulse ---
    always @(posedge tb_clk) begin
        if (tb_pulse)
            pulse_count++;
    end

    // --- Stimulus ---
    initial begin
        $display("=== BUTTON DEBOUNCER SELF-CHECK TEST START ===");

        tb_clk = 0;
        tb_rst = 1;
        tb_btn = 0;

        // Reset
        #(2 * CLK_PERIOD);
        tb_rst = 0;

        // --- Noisy press ---
        tb_btn = 1; #20ns;
        tb_btn = 0; #20ns;
        tb_btn = 1; #20ns;
        tb_btn = 0; #20ns;

        // --- Stable press ---
        tb_btn = 1;
        #(TB_DEBOUNCE_LIMIT * CLK_PERIOD * 2);

        // --- Check debounced output ---
        if (tb_debounced !== 1) begin
            $error("FAIL: Debounced output did not go HIGH");
            error_count++;
        end

        // --- Noisy release ---
        tb_btn = 0; #20ns;
        tb_btn = 1; #20ns;
        tb_btn = 0;

        #(TB_DEBOUNCE_LIMIT * CLK_PERIOD * 2);

        // --- Check pulse count ---
        if (pulse_count != 1) begin
            $error("FAIL: Expected 1 pulse, got %0d", pulse_count);
            error_count++;
        end

        // --- Final result ---
        if (error_count == 0)
            $display("✅ TEST PASSED");
        else
            $display("❌ TEST FAILED: %0d errors", error_count);

        $finish;
    end

endmodule
