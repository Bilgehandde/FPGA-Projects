# LED Blinker & Clock Divider

## 📌 Project Overview
This project implements a fundamental **Clock Divider** circuit on the Digilent Basys 3 FPGA board.

The objective is to convert the board's high-frequency master clock (100 MHz) into a human-perceptible low frequency (approx. 0.5 Hz) to create a blinking LED effect. This project serves as an introduction to synchronous logic design, timing constraints, and SystemVerilog parameterization.

## 📂 File Description

* **`led_blinker.sv` (RTL Design)**
  * The core SystemVerilog module.
  * Implements a 28-bit counter to divide the 100 MHz clock.
  * Utilizes a `CLK_LIMIT` **parameter**, allowing the blink speed to be adjusted easily (crucial for efficient simulation).

* **`tb_led_blinker.sv` (Testbench)**
  * A verification module that simulates the design behavior.
  * It overrides the `CLK_LIMIT` parameter to a small value (e.g., 10 cycles) to verify the logic without waiting for millions of clock cycles in the simulator.
  * Generates a virtual clock signal to drive the simulation.

* **`Basys3_Constraints.xdc` (Constraints)**
  * Maps the design ports to the physical Artix-7 FPGA pins:
    * `i_clk` ➝ **W5** (100 MHz Oscillator)
    * `i_rst` ➝ **V17** (Switch 0)
    * `o_led` ➝ **U16** (LED 0)

## ⚙️ Technical Implementation

### Clock Division Logic
The Basys 3 oscillator runs at **100 MHz** ($10ns$ period). To toggle an LED every 1 second, we need to count $100,000,000$ cycles.

$$T_{target} = 1s \quad | \quad f_{clk} = 100 \text{ MHz}$$
$$\text{Count Limit} = \frac{1s}{10ns} = 100,000,000$$

The logic uses a counter that increments on every rising edge of the clock. When the counter reaches `CLK_LIMIT`, it resets to 0 and inverts the LED state.

## 🛠️ Hardware Setup
* **FPGA Board:** Digilent Basys 3 (Xilinx Artix-7 XC7A35T)
* **Toolchain:** Xilinx Vivado 2022.2
* **Language:** SystemVerilog
