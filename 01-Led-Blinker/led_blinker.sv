`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:       Bilgehan Dede
// Design Name:    LED Blinker
// Module Name:    led_blinker
// Project Name:   FPGA Portfolio
// Target Device:  Digilent Basys 3 (Artix-7)
// Description:    
//    A basic clock divider and LED flasher module.
//    Takes the 100 MHz onboard clock and divides it down to create a visible
//    blinking effect on an LED.
//////////////////////////////////////////////////////////////////////////////////

module led_blinker(
    input  logic i_clk,      // 100 MHz System Clock
    input  logic i_rst,      // Active-High Reset Button
    output logic o_led       // LED Output Signal
    );

    // --- Constants & Parameters ---
    // We count to 100,000,000 (approx) to create a 1-second delay.
    // 100 MHz Clock = 10ns period.
    // 100,000,000 cycles * 10ns = 1.0 second.
    parameter CLK_LIMIT = 27'd99999999;

    // --- Internal Signals ---
    // Counter Register:
    // We need to store values up to 100 Million.
    // log2(100,000,000) approx 26.57. So we need at least 27 bits.
    logic [27:0] r_counter; 
    
    // LED State Register:
    // 1-bit register to hold the current state (ON/OFF) of the LED.
    logic r_led_state; 

    // --- Main Logic (Sequential) ---
    always_ff @(posedge i_clk or posedge i_rst)
        begin
            // Asynchronous Reset (High Priority)
            if (i_rst) 
                begin
                    r_counter   <= 0;
                    r_led_state <= 1'b0; // Reset LED to OFF
                end
            else 
                begin
                    // Check if counter reached the limit (1 Second)
                    if (r_counter == CLK_LIMIT)
                        begin
                            r_counter   <= 0;             // Reset counter
                            r_led_state <= ~r_led_state;  // Toggle LED state
                        end  
                    else
                        begin
                            r_counter   <= r_counter + 1; // Increment counter
                        end
                end
        end

    // --- Output Assignment ---
    // Connect the internal register to the physical output port
    assign o_led = r_led_state;

endmodule
