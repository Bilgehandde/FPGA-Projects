# --------------------------------------------------------------------------
# Proje 1: LED Blinker Kýsýtlamalarý
# --------------------------------------------------------------------------

# --- 1. Ana Saat Sinyali (100MHz) ---
# Bizim koddaki 'i_clk' portumuzu, karttaki W5 pinine baðlýyoruz.
set_property PACKAGE_PIN W5 [get_ports i_clk]
set_property IOSTANDARD LVCMOS33 [get_ports i_clk]
# VIVADO'YA ÖNEMLÝ NOT: 'i_clk' portundan 10ns periyotlu (100MHz) bir saat sinyali geliyor.
create_clock -period 10.00 [get_ports i_clk]


# --- 2. Reset Sinyali (Switch 0) ---
# Bizim koddaki 'i_rst' portumuzu, karttaki V17 pinine (SW0) baðlýyoruz.
set_property PACKAGE_PIN V17 [get_ports i_rst]
set_property IOSTANDARD LVCMOS33 [get_ports i_rst]


# --- 3. LED Çýkýþý (LED 0) ---
# Bizim koddaki 'o_led' portumuzu, karttaki U16 pinine (LD0) baðlýyoruz.
set_property PACKAGE_PIN U16 [get_ports o_led]
set_property IOSTANDARD LVCMOS33 [get_ports o_led]