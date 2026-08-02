create_project finn_vivado_stitch_proj /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/vivado_stitch_proj_4ryffzb7 -part xc7z020clg400-1
set_msg_config -id {[BD 41-1753]} -suppress
set_property ip_repo_paths [list $::env(FINN_RTLLIB)/memstream /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_0_78aklowy /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_Thresholding_rtl_0_8c9r41en /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_1_2sg4tol0 /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_MVAU_hls_0_a0grgun0/project_MVAU_hls_0/sol1/impl/ip /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_2_9ilxv7wp /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_MVAU_hls_1_g730sl22/project_MVAU_hls_1/sol1/impl/ip /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_3_elgmbb3q /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_MVAU_hls_2_bcksx18m/project_MVAU_hls_2/sol1/impl/ip /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_4_4h301ipw /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_MVAU_hls_3__jxyt2wf/project_MVAU_hls_3/sol1/impl/ip /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_5_16gn9_wl /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_0_edvdwdar /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_6_e1mim1k1 /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_LabelSelect_hls_0_1d9g_bw2/project_LabelSelect_hls_0/sol1/impl/ip /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_7_a8ockdyh] [current_project]
update_ip_catalog
create_bd_design "finn_design"
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_0_78aklowy/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_0_78aklowy/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_0_78aklowy/StreamingFIFO_rtl_0.v
create_bd_cell -type module -reference StreamingFIFO_rtl_0 StreamingFIFO_rtl_0
file mkdir ./ip/verilog/rtl_ops/Thresholding_rtl_0
add_files -copy_to ./ip/verilog/rtl_ops/Thresholding_rtl_0 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_Thresholding_rtl_0_8c9r41en/axilite.sv
add_files -copy_to ./ip/verilog/rtl_ops/Thresholding_rtl_0 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_Thresholding_rtl_0_8c9r41en/thresholding.sv
add_files -copy_to ./ip/verilog/rtl_ops/Thresholding_rtl_0 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_Thresholding_rtl_0_8c9r41en/thresholding_axi.sv
add_files -copy_to ./ip/verilog/rtl_ops/Thresholding_rtl_0 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_Thresholding_rtl_0_8c9r41en/Thresholding_rtl_0.v
create_bd_cell -type module -reference Thresholding_rtl_0 Thresholding_rtl_0
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_1_2sg4tol0/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_1_2sg4tol0/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_1_2sg4tol0/StreamingFIFO_rtl_1.v
create_bd_cell -type module -reference StreamingFIFO_rtl_1 StreamingFIFO_rtl_1
file mkdir ./ip/verilog/rtl_ops/MVAU_hls_0
create_bd_cell -type hier MVAU_hls_0
create_bd_pin -dir I -type clk /MVAU_hls_0/ap_clk
create_bd_pin -dir I -type rst /MVAU_hls_0/ap_rst_n
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 /MVAU_hls_0/out0_V
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 /MVAU_hls_0/in0_V
create_bd_cell -type ip -vlnv xilinx.com:hls:MVAU_hls_0:1.0 /MVAU_hls_0/MVAU_hls_0
connect_bd_net [get_bd_pins MVAU_hls_0/ap_rst_n] [get_bd_pins MVAU_hls_0/MVAU_hls_0/ap_rst_n]
connect_bd_net [get_bd_pins MVAU_hls_0/ap_clk] [get_bd_pins MVAU_hls_0/MVAU_hls_0/ap_clk]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_0/in0_V] [get_bd_intf_pins MVAU_hls_0/MVAU_hls_0/in0_V]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_0/out0_V] [get_bd_intf_pins MVAU_hls_0/MVAU_hls_0/out0_V]
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_0 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_MVAU_hls_0_a0grgun0/MVAU_hls_0_memstream_wrapper.v
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_0 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/axi/hdl/axilite.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_0 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream_axi.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_0 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream.sv
create_bd_cell -type hier -reference MVAU_hls_0_memstream_wrapper /MVAU_hls_0/MVAU_hls_0_wstrm
connect_bd_net [get_bd_pins MVAU_hls_0/ap_clk] [get_bd_pins MVAU_hls_0/MVAU_hls_0_wstrm/ap_clk]
connect_bd_net [get_bd_pins MVAU_hls_0/ap_rst_n] [get_bd_pins MVAU_hls_0/MVAU_hls_0_wstrm/ap_rst_n]
connect_bd_net [get_bd_pins MVAU_hls_0/ap_clk] [get_bd_pins MVAU_hls_0/MVAU_hls_0_wstrm/ap_clk2x]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_0/MVAU_hls_0_wstrm/m_axis_0] [get_bd_intf_pins MVAU_hls_0/MVAU_hls_0/in1_V]
save_bd_design
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_2_9ilxv7wp/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_2_9ilxv7wp/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_2_9ilxv7wp/StreamingFIFO_rtl_2.v
create_bd_cell -type module -reference StreamingFIFO_rtl_2 StreamingFIFO_rtl_2
file mkdir ./ip/verilog/rtl_ops/MVAU_hls_1
create_bd_cell -type hier MVAU_hls_1
create_bd_pin -dir I -type clk /MVAU_hls_1/ap_clk
create_bd_pin -dir I -type rst /MVAU_hls_1/ap_rst_n
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 /MVAU_hls_1/out0_V
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 /MVAU_hls_1/in0_V
create_bd_cell -type ip -vlnv xilinx.com:hls:MVAU_hls_1:1.0 /MVAU_hls_1/MVAU_hls_1
connect_bd_net [get_bd_pins MVAU_hls_1/ap_rst_n] [get_bd_pins MVAU_hls_1/MVAU_hls_1/ap_rst_n]
connect_bd_net [get_bd_pins MVAU_hls_1/ap_clk] [get_bd_pins MVAU_hls_1/MVAU_hls_1/ap_clk]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_1/in0_V] [get_bd_intf_pins MVAU_hls_1/MVAU_hls_1/in0_V]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_1/out0_V] [get_bd_intf_pins MVAU_hls_1/MVAU_hls_1/out0_V]
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_1 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_MVAU_hls_1_g730sl22/MVAU_hls_1_memstream_wrapper.v
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_1 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/axi/hdl/axilite.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_1 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream_axi.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_1 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream.sv
create_bd_cell -type hier -reference MVAU_hls_1_memstream_wrapper /MVAU_hls_1/MVAU_hls_1_wstrm
connect_bd_net [get_bd_pins MVAU_hls_1/ap_clk] [get_bd_pins MVAU_hls_1/MVAU_hls_1_wstrm/ap_clk]
connect_bd_net [get_bd_pins MVAU_hls_1/ap_rst_n] [get_bd_pins MVAU_hls_1/MVAU_hls_1_wstrm/ap_rst_n]
connect_bd_net [get_bd_pins MVAU_hls_1/ap_clk] [get_bd_pins MVAU_hls_1/MVAU_hls_1_wstrm/ap_clk2x]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_1/MVAU_hls_1_wstrm/m_axis_0] [get_bd_intf_pins MVAU_hls_1/MVAU_hls_1/in1_V]
save_bd_design
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_3_elgmbb3q/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_3_elgmbb3q/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_3_elgmbb3q/StreamingFIFO_rtl_3.v
create_bd_cell -type module -reference StreamingFIFO_rtl_3 StreamingFIFO_rtl_3
file mkdir ./ip/verilog/rtl_ops/MVAU_hls_2
create_bd_cell -type hier MVAU_hls_2
create_bd_pin -dir I -type clk /MVAU_hls_2/ap_clk
create_bd_pin -dir I -type rst /MVAU_hls_2/ap_rst_n
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 /MVAU_hls_2/out0_V
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 /MVAU_hls_2/in0_V
create_bd_cell -type ip -vlnv xilinx.com:hls:MVAU_hls_2:1.0 /MVAU_hls_2/MVAU_hls_2
connect_bd_net [get_bd_pins MVAU_hls_2/ap_rst_n] [get_bd_pins MVAU_hls_2/MVAU_hls_2/ap_rst_n]
connect_bd_net [get_bd_pins MVAU_hls_2/ap_clk] [get_bd_pins MVAU_hls_2/MVAU_hls_2/ap_clk]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_2/in0_V] [get_bd_intf_pins MVAU_hls_2/MVAU_hls_2/in0_V]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_2/out0_V] [get_bd_intf_pins MVAU_hls_2/MVAU_hls_2/out0_V]
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_2 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_MVAU_hls_2_bcksx18m/MVAU_hls_2_memstream_wrapper.v
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_2 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/axi/hdl/axilite.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_2 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream_axi.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_2 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream.sv
create_bd_cell -type hier -reference MVAU_hls_2_memstream_wrapper /MVAU_hls_2/MVAU_hls_2_wstrm
connect_bd_net [get_bd_pins MVAU_hls_2/ap_clk] [get_bd_pins MVAU_hls_2/MVAU_hls_2_wstrm/ap_clk]
connect_bd_net [get_bd_pins MVAU_hls_2/ap_rst_n] [get_bd_pins MVAU_hls_2/MVAU_hls_2_wstrm/ap_rst_n]
connect_bd_net [get_bd_pins MVAU_hls_2/ap_clk] [get_bd_pins MVAU_hls_2/MVAU_hls_2_wstrm/ap_clk2x]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_2/MVAU_hls_2_wstrm/m_axis_0] [get_bd_intf_pins MVAU_hls_2/MVAU_hls_2/in1_V]
save_bd_design
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_4_4h301ipw/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_4_4h301ipw/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_4_4h301ipw/StreamingFIFO_rtl_4.v
create_bd_cell -type module -reference StreamingFIFO_rtl_4 StreamingFIFO_rtl_4
file mkdir ./ip/verilog/rtl_ops/MVAU_hls_3
create_bd_cell -type hier MVAU_hls_3
create_bd_pin -dir I -type clk /MVAU_hls_3/ap_clk
create_bd_pin -dir I -type rst /MVAU_hls_3/ap_rst_n
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 /MVAU_hls_3/out0_V
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 /MVAU_hls_3/in0_V
create_bd_cell -type ip -vlnv xilinx.com:hls:MVAU_hls_3:1.0 /MVAU_hls_3/MVAU_hls_3
connect_bd_net [get_bd_pins MVAU_hls_3/ap_rst_n] [get_bd_pins MVAU_hls_3/MVAU_hls_3/ap_rst_n]
connect_bd_net [get_bd_pins MVAU_hls_3/ap_clk] [get_bd_pins MVAU_hls_3/MVAU_hls_3/ap_clk]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_3/in0_V] [get_bd_intf_pins MVAU_hls_3/MVAU_hls_3/in0_V]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_3/out0_V] [get_bd_intf_pins MVAU_hls_3/MVAU_hls_3/out0_V]
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_3 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_MVAU_hls_3__jxyt2wf/MVAU_hls_3_memstream_wrapper.v
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_3 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/axi/hdl/axilite.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_3 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream_axi.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_3 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream.sv
create_bd_cell -type hier -reference MVAU_hls_3_memstream_wrapper /MVAU_hls_3/MVAU_hls_3_wstrm
connect_bd_net [get_bd_pins MVAU_hls_3/ap_clk] [get_bd_pins MVAU_hls_3/MVAU_hls_3_wstrm/ap_clk]
connect_bd_net [get_bd_pins MVAU_hls_3/ap_rst_n] [get_bd_pins MVAU_hls_3/MVAU_hls_3_wstrm/ap_rst_n]
connect_bd_net [get_bd_pins MVAU_hls_3/ap_clk] [get_bd_pins MVAU_hls_3/MVAU_hls_3_wstrm/ap_clk2x]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_3/MVAU_hls_3_wstrm/m_axis_0] [get_bd_intf_pins MVAU_hls_3/MVAU_hls_3/in1_V]
save_bd_design
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_5_16gn9_wl/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_5_16gn9_wl/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_5_16gn9_wl/StreamingFIFO_rtl_5.v
create_bd_cell -type module -reference StreamingFIFO_rtl_5 StreamingFIFO_rtl_5
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_0_edvdwdar/dwc_axi.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_0_edvdwdar/dwc.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_0_edvdwdar/StreamingDataWidthConverter_rtl_0.v
create_bd_cell -type module -reference StreamingDataWidthConverter_rtl_0 StreamingDataWidthConverter_rtl_0
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_6_e1mim1k1/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_6_e1mim1k1/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_6_e1mim1k1/StreamingFIFO_rtl_6.v
create_bd_cell -type module -reference StreamingFIFO_rtl_6 StreamingFIFO_rtl_6
create_bd_cell -type ip -vlnv xilinx.com:hls:LabelSelect_hls_0:1.0 LabelSelect_hls_0
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_7_a8ockdyh/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_7_a8ockdyh/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_7_a8ockdyh/StreamingFIFO_rtl_7.v
create_bd_cell -type module -reference StreamingFIFO_rtl_7 StreamingFIFO_rtl_7
make_bd_pins_external [get_bd_pins StreamingFIFO_rtl_0/ap_clk]
set_property name ap_clk [get_bd_ports ap_clk_0]
make_bd_pins_external [get_bd_pins StreamingFIFO_rtl_0/ap_rst_n]
set_property name ap_rst_n [get_bd_ports ap_rst_n_0]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins Thresholding_rtl_0/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins Thresholding_rtl_0/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_0/out0_V] [get_bd_intf_pins Thresholding_rtl_0/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_1/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_1/ap_clk]
connect_bd_intf_net [get_bd_intf_pins Thresholding_rtl_0/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_1/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins MVAU_hls_0/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins MVAU_hls_0/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_1/out0_V] [get_bd_intf_pins MVAU_hls_0/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_2/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_2/ap_clk]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_0/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_2/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins MVAU_hls_1/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins MVAU_hls_1/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_2/out0_V] [get_bd_intf_pins MVAU_hls_1/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_3/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_3/ap_clk]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_1/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_3/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins MVAU_hls_2/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins MVAU_hls_2/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_3/out0_V] [get_bd_intf_pins MVAU_hls_2/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_4/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_4/ap_clk]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_2/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_4/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins MVAU_hls_3/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins MVAU_hls_3/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_4/out0_V] [get_bd_intf_pins MVAU_hls_3/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_5/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_5/ap_clk]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_3/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_5/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingDataWidthConverter_rtl_0/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingDataWidthConverter_rtl_0/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_5/out0_V] [get_bd_intf_pins StreamingDataWidthConverter_rtl_0/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_6/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_6/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingDataWidthConverter_rtl_0/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_6/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins LabelSelect_hls_0/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins LabelSelect_hls_0/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_6/out0_V] [get_bd_intf_pins LabelSelect_hls_0/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_7/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_7/ap_clk]
connect_bd_intf_net [get_bd_intf_pins LabelSelect_hls_0/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_7/in0_V]
make_bd_intf_pins_external [get_bd_intf_pins StreamingFIFO_rtl_0/in0_V]
set_property name s_axis_0 [get_bd_intf_ports in0_V_0]
make_bd_intf_pins_external [get_bd_intf_pins StreamingFIFO_rtl_7/out0_V]
set_property name m_axis_0 [get_bd_intf_ports out0_V_0]
set_property CONFIG.FREQ_HZ 100000000 [get_bd_ports /ap_clk]
validate_bd_design
save_bd_design
make_wrapper -files [get_files /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/vivado_stitch_proj_4ryffzb7/finn_vivado_stitch_proj.srcs/sources_1/bd/finn_design/finn_design.bd] -top
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/vivado_stitch_proj_4ryffzb7/finn_vivado_stitch_proj.srcs/sources_1/bd/finn_design/hdl/finn_design_wrapper.v
set_property top finn_design_wrapper [current_fileset]
ipx::package_project -root_dir /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/vivado_stitch_proj_4ryffzb7/ip -vendor xilinx_finn -library finn -taxonomy /UserIP -module finn_design -import_files
set_property ipi_drc {ignore_freq_hz true} [ipx::current_core]
ipx::remove_segment -quiet m_axi_gmem0:APERTURE_0 [ipx::get_address_spaces m_axi_gmem0 -of_objects [ipx::current_core]]
set_property core_revision 2 [ipx::find_open_core xilinx_finn:finn:finn_design:1.0]
ipx::create_xgui_files [ipx::find_open_core xilinx_finn:finn:finn_design:1.0]
set_property value_resolve_type user [ipx::get_bus_parameters -of [ipx::get_bus_interfaces -of [ipx::current_core ]]]

set core [ipx::current_core]

# Add rudimentary driver
file copy -force data ip/
set file_group [ipx::add_file_group -type software_driver {} $core]
set_property type mdd       [ipx::add_file data/finn_design.mdd $file_group]
set_property type tclSource [ipx::add_file data/finn_design.tcl $file_group]

# Remove all XCI references to subcores
set impl_files [ipx::get_file_groups xilinx_implementation -of $core]
foreach xci [ipx::get_files -of $impl_files {*.xci}] {
    ipx::remove_file [get_property NAME $xci] $impl_files
}

# Construct a single flat memory map for each AXI-lite interface port
foreach port [get_bd_intf_ports -filter {CONFIG.PROTOCOL==AXI4LITE}] {
    set pin $port
    set awidth ""
    while { $awidth == "" } {
        set pins [get_bd_intf_pins -of [get_bd_intf_nets -boundary_type lower -of $pin]]
        set kill [lsearch $pins $pin]
        if { $kill >= 0 } { set pins [lreplace $pins $kill $kill] }
        if { [llength $pins] != 1 } { break }
        set pin [lindex $pins 0]
        set awidth [get_property CONFIG.ADDR_WIDTH $pin]
    }
    if { $awidth == "" } {
       puts "CRITICAL WARNING: Unable to construct address map for $port."
    } {
       set range [expr 2**$awidth]
       set range [expr $range < 4096 ? 4096 : $range]
       puts "INFO: Building address map for $port: 0+:$range"
       set name [get_property NAME $port]
       set addr_block [ipx::add_address_block Reg0 [ipx::add_memory_map $name $core]]
       set_property range $range $addr_block
       set_property slave_memory_map_ref $name [ipx::get_bus_interfaces $name -of $core]
    }
}

# Finalize and Save
ipx::update_checksums $core
ipx::save_core $core

# Remove stale subcore references from component.xml
file rename -force ip/component.xml ip/component.bak
set ifile [open ip/component.bak r]
set ofile [open ip/component.xml w]
set buf [list]
set kill 0
while { [eof $ifile] != 1 } {
    gets $ifile line
    if { [string match {*<spirit:fileSet>*} $line] == 1 } {
        foreach l $buf { puts $ofile $l }
        set buf [list $line]
    } elseif { [llength $buf] > 0 } {
        lappend buf $line

        if { [string match {*</spirit:fileSet>*} $line] == 1 } {
            if { $kill == 0 } { foreach l $buf { puts $ofile $l } }
            set buf [list]
            set kill 0
        } elseif { [string match {*<xilinx:subCoreRef>*} $line] == 1 } {
            set kill 1
        }
    } else {
        puts $ofile $line
    }
}
close $ifile
close $ofile

set all_v_files [get_files -filter {USED_IN_SYNTHESIS == 1 && (FILE_TYPE == Verilog || FILE_TYPE == SystemVerilog || FILE_TYPE =="Verilog Header")}]
set fp [open /home/neuralnetwork01/Schreibtisch/s7s/nn/task3/FINN_TMP/vivado_stitch_proj_4ryffzb7/all_verilog_srcs.txt w]
foreach vf $all_v_files {puts $fp $vf}
close $fp
