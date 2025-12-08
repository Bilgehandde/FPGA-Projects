# FPGA Projects (SystemVerilog)

This folder contains my digital logic design projects implemented on the **Digilent Basys 3** board (Artix-7 FPGA) using **SystemVerilog** and **Vivado**.

## Core Projects

* **[01-LED-Blinker](./01-LED-Blinker)**
  A basic timing project that implements a Clock Divider to convert the 100MHz system clock into a 1Hz signal for toggling an LED.

* **[02-Button-Debouncer](./02-Button-Debouncer)**
  An input processing module that filters noise from mechanical buttons and detects signal edges (rising/falling) for stable user input.

## Upcoming Projects (Roadmap)

* **PWM LED Dimmer:** Generating Pulse Width Modulation signals for brightness control.
* **VGA Display Controller:** Driving a standard VGA monitor (640x480) with custom patterns.
* **Mini ALU:** Designing a simple Arithmetic Logic Unit for basic math operations.
* **8-Bit RISC Processor:** Architecture design of a simple CPU with Fetch-Decode-Execute cycles.
