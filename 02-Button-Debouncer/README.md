# Button Debouncer & Edge Detector

## 📌 Project Overview
This project implements a crucial digital utility module: a **Button Debouncer** paired with a **Rising Edge Detector**.

Mechanical buttons, when pressed, do not produce a clean `0` to `1` signal. They "bounce," creating a rapid, noisy series of `1-0-1-0` transitions. 
This module filters that noise to produce a stable, reliable "button pressed" signal.

## 📂 File Description

* **`button_debouncer.sv` (RTL Design)**
  * The core SystemVerilog module.
  * **1. Synchronization Chain:** Takes the asynchronous `i_btn` input and passes it through two flip-flops to prevent metastability.
  * **2. Debouncer:** Uses a 20-bit counter to check if the signal remains stable for `DEBOUNCE_LIMIT` cycles (1,000,000 cycles ≈ 10ms) before accepting the new state.
  * **3. Edge Detector:** Compares the current stable state (`r_stable_state`) with the previous state (`r_stable_prev`) to generate a single-cycle pulse (`o_pulse`).

* **`tb_button_debouncer.sv` (Testbench)**
  * A verification module that simulates a "worst-case" noisy button press.
  * It generates a chaotic `1-0-1-0-1-0-1` signal, followed by a stable `1`, to verify that the debouncer correctly filters the noise and the edge detector fires only *once*.
  * Overrides the `DEBOUNCE_LIMIT` to 10 cycles for a fast simulation.

* **`Basys3_Debouncer.xdc` (Constraints)**
  * Maps the design ports to the physical Artix-7 FPGA pins:
    * `i_clk` ➝ **W5** (100 MHz Oscillator)
    * `i_rst` ➝ **V17** (Switch 0)
    * `i_btn` ➝ **U18** (Center Push-Button `BTNC`)
    * `o_debounced` ➝ **U16** (LED 0)
    * `o_pulse` ➝ **E19** (LED 1)

## ⚙️ Technical Implementation

1.  **Metastability:** The asynchronous `i_btn` is first synchronized to the `i_clk` domain using a 2-flop synchronizer (`r_btn_sync_0`, `r_btn_sync_1`).
2.  **Debounce Timer:** The synchronized signal `r_btn_sync_1` is monitored. If it differs from the last known stable state (`r_stable_state`), a counter (`r_counter`) starts. If the counter reaches `DEBOUNCE_LIMIT` (10ms) without the input changing again, the new state is accepted. If the input bounces, the counter resets.
3.  **Edge Detection:** The logic `assign o_pulse = (r_stable_state == 1) && (r_stable_prev == 0);` ensures that `o_pulse` is HIGH for only *one clock cycle*, precisely when the button state transitions from `0` to `1`.

## 🛠️ Hardware Setup
* **FPGA Board:** Digilent Basys 3
* **Toolchain:** Xilinx Vivado 2022.2
* **Language:** SystemVerilog
* **Test:** When `BTNC` is pressed, `LED 0` turns on and stays on. `LED 1` (the pulse) is too fast to see.
