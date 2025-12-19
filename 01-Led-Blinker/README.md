# LED Blinker & Clock Divider

## 📌 Project Overview
This project implements a fundamental **Clock Divider** circuit on the Digilent **Basys 3 (Artix-7)** FPGA board.

The objective is to convert the board's high-frequency master clock (**100 MHz**) into a human-perceptible low frequency (≈0.5 Hz) to create a blinking LED effect.  
This project serves as an introduction to **synchronous logic design**, **timing-aware RTL development**, **SystemVerilog parameterization**, and **self-checking verification methodology**.

## 📂 File Description

* **`led_blinker.sv` (RTL Design)**
  * Core SystemVerilog module implementing the clock divider.
  * Uses a 28-bit counter to divide the 100 MHz system clock.
  * Includes a configurable `CLK_LIMIT` **parameter**, enabling both real hardware operation and fast simulation.
  * Supports asynchronous active-high reset.

* **`tb_led_blinker.sv` (Self-Checking Testbench)**
  * SystemVerilog testbench used to verify functional correctness.
  * Overrides the `CLK_LIMIT` parameter to a small value (e.g., 10 cycles) to avoid long simulation times.
  * Automatically calculates the **expected LED toggle behavior** and compares it with the DUT output.
  * Reports **PASS / FAIL** results without manual waveform inspection.

* **`Basys3_Constraints.xdc` (Constraints)**
  * Maps the design ports to the physical Artix-7 FPGA pins:
    * `i_clk` ➝ **W5** (100 MHz Oscillator)
    * `i_rst` ➝ **V17** (Switch 0, Active-High Reset)
    * `o_led` ➝ **U16** (LED 0)

## ⚙️ Technical Implementation

### Clock Division Logic
The Basys 3 oscillator runs at **100 MHz** (10 ns period).  
To toggle an LED every **1 second**, the design must count **100,000,000 clock cycles**.

