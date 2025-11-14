`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Bilgehan Dede
// Design Name:    Button Debouncer Testbench
// Module Name:    tb_button_debouncer
// Project Name:   FPGA Portfolio
// Description:    
//    Verifies the button_debouncer module by simulating a "real world"
//    noisy button press and release.
//////////////////////////////////////////////////////////////////////////////////

module tb_button_debouncer();

    // --- Testbench Signals ---
    logic tb_clk;
    logic tb_rst;
    logic tb_btn;       // Stimulus: The noisy button signal we generate
    logic tb_debounced; // Output: The stable signal from the DUT
    logic tb_pulse;     // Output: The single-cycle pulse from the DUT

    // --- DUT Instantiation ---
    // Override limit to 10 cycles (100ns) for a fast simulation
    button_debouncer #(
        .DEBOUNCE_LIMIT(10) 
    )
    dut(
        .i_clk(tb_clk),
        .i_rst(tb_rst),
        .i_btn(tb_btn),
        .o_debounced(tb_debounced),
        .o_pulse(tb_pulse)
    );

    // --- Clock Generation ---
    // Generate a 100MHz clock (10ns period)
    always #5 tb_clk = ~tb_clk;

    // --- Stimulus (Test Vector) ---
    initial begin 
        // 1. Initialize and Reset
        tb_clk = 0;
        tb_rst = 1; // Start in reset
        tb_btn = 0; // Button not pressed
        #20ns;      // Hold reset for 2 clock cycles
        
        tb_rst = 0; // Release reset
        #80ns;      // Wait for 8 cycles (system stable)

        // 2. Simulate Noisy Press (Bouncing)
        tb_btn = 1; #20ns;
        tb_btn = 0; #20ns;
        tb_btn = 1; #20ns;
        tb_btn = 0; #20ns;
        
        // 3. Simulate Stable Press (Held Down)
        tb_btn = 1; 
        
        // Wait 200ns (Debounce limit is 100ns)
        #200ns; 

        // 4. Simulate Noisy Release (Bouncing)
        tb_btn = 0; #20ns;
        tb_btn = 1; #20ns;
        tb_btn = 0; #20ns;

        // 5. Simulate Stable Release
        tb_btn = 0;
        
        #200ns; // Wait to observe the stable low output
        
        $stop;
    end

endmodule
