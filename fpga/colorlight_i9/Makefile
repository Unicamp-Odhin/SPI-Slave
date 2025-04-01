
all: ./build/out.bit

./build/out.bit: ./build/out.config
	ecppack --compress --input ./build/out.config  --bit ./build/out.bit

./build/out.config: ./build/out.json
	nextpnr-ecp5 --json ./build/out.json --write ./build/out_pnr.json --45k \
		--lpf pinout.lpf --textcfg ./build/out.config --package CABGA381 \
		--speed 6 --lpf-allow-unconstrained --report ./build/report_timing.json \
		--detailed-timing-report 

./build/out.json: main.sv pinout.lpf buildFolder
	yosys -p " \
		read_verilog -sv main.sv; \
		read_verilog -sv ../../debug/reset.sv; \
		read_verilog -sv ../../rtl/spi_slave.sv; \
		synth_ecp5 -json ./build/out.json -abc9 \
	"

buildFolder:
	mkdir -p build

clean:
	rm -rf build

flash:
	openFPGALoader -b colorlight-i9 ./build/out.bit

run_all: ./build/out.bit flash