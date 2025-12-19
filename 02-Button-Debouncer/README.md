# Button Debouncer & Edge Detector

## 📌 Project Overview
This project implements a **Button Debouncer** combined with a **Rising Edge Detector** on the Digilent **Basys 3 (Artix-7)** FPGA board.

Mechanical push-buttons generate noisy `1-0-1-0` transitions when pressed or released.  
This module filters that noise to produce a **stable button state** and a **single-cycle pulse** for each valid button press.

The project demonstrates **clock-domain synchronization**, **time-based debouncing**, **edge detection**, and **self-checking verification** using SystemVerilog.

## 📂 File Description

* **`button_debouncer.sv` (RTL Design)**
  * SystemVerilog utility module.
  * Uses a **2-flip-flop synchronizer** to prevent metastability.
  * Debounces the input by requiring stability for `DEBOUNCE_LIMIT` cycles
    (default: 1,000,000 cycles ≈ 10 ms at 100 MHz).
  * Generates a **single-clock pulse** on each valid rising edge.

* **`tb_button_debouncer.sv` (Self-Checking Testbench)**
  * Simulates worst-case noisy button press and release.
  * Overrides `DEBOUNCE_LIMIT` for fast simulation.
  * Automatically verifies:
    * Correct debounce behavior
    * Exactly **one pulse per valid button press**
  * Reports PASS / FAIL without waveform inspection.

* **`Basys3_Debouncer.xdc` (Constraints)**
  * `i_clk` ➝ W5 (100 MHz Oscillator)
  * `i_rst` ➝ V17 (Switch 0)
  * `i_btn` ➝ U18 (BTNC)
  * `o_debounced` ➝ U16 (LED 0)
  * `o_pulse` ➝ E19 (LED 1)

## ⚙️ Technical Implementation
1. Asynchronous button input is synchronized using a 2-flop chain.
2. A counter validates signal stability over a fixed debounce interval.
3. A rising edge detector generates a one-cycle event pulse.

## 🛠️ Hardware Setup
* **FPGA Board:** Digilent Basys 3
* **Toolchain:** Xilinx Vivado 2022.2
* **Language:** SystemVerilog
