# --- Basys 3 Constraints for Button Debouncer Project ---

# --- System Clock (100MHz) ---
set_property PACKAGE_PIN W5 [get_ports i_clk]
set_property IOSTANDARD LVCMOS33 [get_ports i_clk]
create_clock -period 10.00 [get_ports i_clk]

# --- Reset Signal (Using Switch 0) ---
# We map our i_rst port to the right-most slide switch (SW0).
set_property PACKAGE_PIN V17 [get_ports i_rst]
set_property IOSTANDARD LVCMOS33 [get_ports i_rst]

# --- Noisy Input (Using Center Push-Button) ---
# We map our i_btn port to the center push-button (BTNC) to test the debounce logic.
set_property PACKAGE_PIN U18 [get_ports i_btn]
set_property IOSTANDARD LVCMOS33 [get_ports i_btn]

# --- OUTPUT 1: Clean/Debounced Signal (LED 0) ---
# We map the stable o_debounced output to LED 0.
set_property PACKAGE_PIN U16 [get_ports o_debounced]
set_property IOSTANDARD LVCMOS33 [get_ports o_debounced]

# --- OUTPUT 2: Single-Cycle Pulse (LED 1) ---
# We map the o_pulse output to LED 1 (this will be invisible to the eye).
set_property PACKAGE_PIN E19 [get_ports o_pulse]
set_property IOSTANDARD LVCMOS33 [get_ports o_pulse]