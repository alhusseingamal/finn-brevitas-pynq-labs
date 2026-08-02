ghdl -a --std=08 types.vhdl neuron.vhdl layer.vhdl neuralnetwork.vhdl iris_bnn.vhdl
ghdl -e --std=08 iris_bnn
ghdl -r --std=08 iris_bnn --vcd=wave.vcd