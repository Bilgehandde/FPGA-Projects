`timescale 1ns / 1ps

module tb_led_blinker();

    // --- Signal Declarations ---
    logic tb_clk;
    logic tb_rst;
    logic tb_led;

    // --- DUT Instantiation (Device Under Test) ---
    // We override the CLK_LIMIT parameter to '9'.
    // This means the counter counts 0 to 9 (10 cycles).
    // The LED will toggle every 10 clock cycles instead of 50 million.
    // This allows us to see the blinking in a short simulation window.
    led_blinker #(
        .CLK_LIMIT(9) 
    )
    dut (
        .i_clk(tb_clk), // Connect testbench clock to module input
        .i_rst(tb_rst), // Connect testbench reset to module input
        .o_led(tb_led)  // Connect module output to testbench signal
    );

    // --- Clock Generation ---
    // Generate a clock with a period of 20ns (50 MHz).
    // Toggle every 10ns.
    always #10 tb_clk = ~tb_clk;

    // --- Stimulus Process ---
    initial begin
        // 1. Initialize Signals
        tb_clk = 0; // Initialize clock to 0
        tb_rst = 1; // Assert Reset (Active High) at start
        
        // 2. Hold Reset
        // Hold reset for 20ns (one full clock cycle) to ensure
        // the system is properly reset before counting starts.
        #20;
        
        // 3. Release Reset
        tb_rst = 0; // System starts counting now
        
        // 4. Run Simulation
        // Wait for 600ns to observe multiple LED toggles.
        // (With CLK_LIMIT=9 and Period=20ns, LED toggles every 200ns)
        #600;
        
        // 5. Stop Simulation
        $stop;
    end

endmodule
