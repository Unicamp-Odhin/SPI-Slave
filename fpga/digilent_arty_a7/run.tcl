read_verilog -sv main.sv
read_verilog -sv ../../debug/reset.sv
read_verilog -sv ../../rtl/spi_slave.sv

read_xdc "digilent_arty.xdc"

# synth
synth_design -top "top" -part "xc7a100tcsg324-1"

# place and route
opt_design
place_design
route_design

# write bitstream
write_bitstream -force "./build/out.bit"