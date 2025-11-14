`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Bilgehan Dede
// Design Name:    Button Debouncer & Edge Detector
// Module Name:    button_debouncer
// Project Name:   FPGA Portfolio
// Target Device:  Digilent Basys 3 (Artix-7)
// Description:    
//    Filters "bounce" noise from a mechanical push-button.
//    1. Synchronizes the asynchronous input to the system clock.
//    2. Debounces the signal by waiting for it to be stable (10ms).
//    3. Generates a single-cycle pulse on the button's rising edge.
//////////////////////////////////////////////////////////////////////////////////

module button_debouncer( 
    input  logic i_clk,       // 100 MHz System Clock
    input  logic i_rst,       // Active-High Reset
    input  logic i_btn,       // Noisy, asynchronous button input
    output logic o_debounced, // Clean, stable button state (HIGH as long as pressed)
    output logic o_pulse      // Single-cycle pulse on rising edge (press event)
    );

    // --- Parameters ---
    // Debounce time: 10ms
    // Clock: 100MHz (10ns period)
    // Count = 10ms / 10ns = 1,000,000 cycles
    parameter DEBOUNCE_LIMIT = 20'd1000000;

    // --- Internal Signals (Registers) ---
    
    // 1. Synchronizer Chain (to prevent metastability)
    logic r_btn_sync_0;
    logic r_btn_sync_1;
    
    // 2. Debouncer Logic
    logic [19:0] r_counter;      // Timer to count stability (needs 20 bits for 1M)
    logic        r_stable_state; // The confirmed, stable state of the button
    
    // 3. Edge Detector
    logic r_stable_prev; // The stable state from the *previous* clock cycle

    
    // --- RTL Implementation ---

    // BLOCK 1: Synchronization Chain
    // Synchronizes the external, asynchronous button input to the internal system clock
    // using a 2-flip-flop chain. We will only use r_btn_sync_1 in the rest of the design.
    always_ff @(posedge i_clk or posedge i_rst)
    begin
        if (i_rst)
        begin
            r_btn_sync_0 <= 1'b0;  
            r_btn_sync_1 <= 1'b0;
        end
        else
        begin 
            r_btn_sync_0 <= i_btn;        // First flop
            r_btn_sync_1 <= r_btn_sync_0; // Second flop (now safe to use)
        end 
    end 
        
    // BLOCK 2: Debouncer Logic
    // Filters the (now synchronized) bouncy signal.
    always_ff @(posedge i_clk or posedge i_rst)
    begin
        if (i_rst)
        begin
            r_counter      <= 0;
            r_stable_state <= 1'b0;
        end
        else
        begin
            // If the input signal is different from our stable state (potential bounce)
            if(r_btn_sync_1 != r_stable_state)
            begin
                // Start/continue the timer
                if (r_counter < DEBOUNCE_LIMIT)
                begin
                    r_counter <= r_counter + 1; // Keep counting
                end   
                else
                begin
                    // Timer finished! The signal was stable for 10ms.
                    r_stable_state <= r_btn_sync_1; // Accept the new state
                    r_counter      <= 0;            // Reset the timer
                end 
            end
            else
            begin 
                // Input and stable state are the same (no bounce), so reset the timer.
                r_counter <= 0;
            end
        end     
    end

    // BLOCK 3: Rising Edge Detector
    // Stores the stable state from the previous clock cycle.
    always_ff @(posedge i_clk or posedge i_rst)
    begin
        if(i_rst)
        begin
            r_stable_prev <= 1'b0;
        end
        else
        begin 
            // r_stable_prev is now exactly 1 clock cycle behind r_stable_state
            r_stable_prev <= r_stable_state; 
        end 
    end       
    
    // BLOCK 4: Combinational Output Assignments
    
    // Output the clean, stable signal directly.
    // This line will be HIGH for as long as the button is held down.
    assign o_debounced = r_stable_state;
    
    // Output a pulse only if:
    // 1. The current state is HIGH (1)
    // 2. The previous state was LOW (0)
    assign o_pulse = (r_stable_state == 1) && (r_stable_prev == 0);
     
endmodule
