create_project finn_vivado_stitch_proj /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/vivado_stitch_proj_ymcwak5l -part xc7z020clg400-1
set_msg_config -id {[BD 41-1753]} -suppress
set_property ip_repo_paths [list $::env(FINN_RTLLIB)/memstream /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_0_uen4asfk /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_Thresholding_rtl_0_avsjanfu /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_1_0laaxf48 /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_FMPadding_rtl_0_2s4g3vyj /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_2_d8bi16a6 /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_0_ufm02qyq /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_3_hey9v0n4 /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_MVAU_hls_0_xzngz8bl/project_MVAU_hls_0/sol1/impl/ip /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_4_pdeejws4 /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_1_d79hozio /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_5_ccr6b_15 /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_Pool_hls_0_4pqrp239/project_Pool_hls_0/sol1/impl/ip /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_6_ps7oo1st /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_FMPadding_rtl_1_vsprdlwa /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_7_fgpn_bhp /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_2_xeh5e4hg /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_8_v00r85i7 /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_0_w8fo7xcf /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_9_37b_80b8 /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_MVAU_hls_1_dfsd34e_/project_MVAU_hls_1/sol1/impl/ip /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_10_adbf5x85 /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_1_nu6ch4g_ /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_11_wbo3jcpa /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_3_xu9la4av /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_12_8y84gey0 /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_Pool_hls_1_4r92l18w/project_Pool_hls_1/sol1/impl/ip /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_13_hlne3g2g /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_FMPadding_rtl_2_mng6_dzo /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_14_q8cjzqre /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_2_ttq9leg5 /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_15__wpyt5te /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_4_qcvzwqax /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_16_2_84ko7i /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_hls_0_bnkz47sx/project_StreamingDataWidthConverter_hls_0/sol1/impl/ip /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_17_mkwo1d5c /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_MVAU_hls_2_ob_gy9wj/project_MVAU_hls_2/sol1/impl/ip /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_18_dwzsfgsz /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_MVAU_hls_3_ak9swqgw/project_MVAU_hls_3/sol1/impl/ip /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_19_u162qniq /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_3_yiu65p5b /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_20_o2zi6wcd /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_MVAU_hls_4_8z4ge1f8/project_MVAU_hls_4/sol1/impl/ip /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_21_c3hdeu9l /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_LabelSelect_hls_0_1b2s199p/project_LabelSelect_hls_0/sol1/impl/ip /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_22_j2l_0vok] [current_project]
update_ip_catalog
create_bd_design "finn_design"
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_0_uen4asfk/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_0_uen4asfk/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_0_uen4asfk/StreamingFIFO_rtl_0.v
create_bd_cell -type module -reference StreamingFIFO_rtl_0 StreamingFIFO_rtl_0
file mkdir ./ip/verilog/rtl_ops/Thresholding_rtl_0
add_files -copy_to ./ip/verilog/rtl_ops/Thresholding_rtl_0 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_Thresholding_rtl_0_avsjanfu/axilite.sv
add_files -copy_to ./ip/verilog/rtl_ops/Thresholding_rtl_0 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_Thresholding_rtl_0_avsjanfu/thresholding.sv
add_files -copy_to ./ip/verilog/rtl_ops/Thresholding_rtl_0 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_Thresholding_rtl_0_avsjanfu/thresholding_axi.sv
add_files -copy_to ./ip/verilog/rtl_ops/Thresholding_rtl_0 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_Thresholding_rtl_0_avsjanfu/Thresholding_rtl_0.v
create_bd_cell -type module -reference Thresholding_rtl_0 Thresholding_rtl_0
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_1_0laaxf48/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_1_0laaxf48/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_1_0laaxf48/StreamingFIFO_rtl_1.v
create_bd_cell -type module -reference StreamingFIFO_rtl_1 StreamingFIFO_rtl_1
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_FMPadding_rtl_0_2s4g3vyj/fmpadding_axi.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_FMPadding_rtl_0_2s4g3vyj/fmpadding.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_FMPadding_rtl_0_2s4g3vyj/axi2we.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_FMPadding_rtl_0_2s4g3vyj/FMPadding_rtl_0.v
create_bd_cell -type module -reference FMPadding_rtl_0 FMPadding_rtl_0
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_2_d8bi16a6/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_2_d8bi16a6/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_2_d8bi16a6/StreamingFIFO_rtl_2.v
create_bd_cell -type module -reference StreamingFIFO_rtl_2 StreamingFIFO_rtl_2
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_0_ufm02qyq/swg_pkg.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_0_ufm02qyq/ConvolutionInputGenerator_rtl_0_wrapper.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_0_ufm02qyq/ConvolutionInputGenerator_rtl_0_impl.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_0_ufm02qyq/swg_common.sv
create_bd_cell -type module -reference ConvolutionInputGenerator_rtl_0 ConvolutionInputGenerator_rtl_0
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_3_hey9v0n4/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_3_hey9v0n4/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_3_hey9v0n4/StreamingFIFO_rtl_3.v
create_bd_cell -type module -reference StreamingFIFO_rtl_3 StreamingFIFO_rtl_3
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
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_0 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_MVAU_hls_0_xzngz8bl/MVAU_hls_0_memstream_wrapper.v
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_0 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/axi/hdl/axilite.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_0 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream_axi.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_0 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream.sv
create_bd_cell -type hier -reference MVAU_hls_0_memstream_wrapper /MVAU_hls_0/MVAU_hls_0_wstrm
connect_bd_net [get_bd_pins MVAU_hls_0/ap_clk] [get_bd_pins MVAU_hls_0/MVAU_hls_0_wstrm/ap_clk]
connect_bd_net [get_bd_pins MVAU_hls_0/ap_rst_n] [get_bd_pins MVAU_hls_0/MVAU_hls_0_wstrm/ap_rst_n]
connect_bd_net [get_bd_pins MVAU_hls_0/ap_clk] [get_bd_pins MVAU_hls_0/MVAU_hls_0_wstrm/ap_clk2x]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_0/MVAU_hls_0_wstrm/m_axis_0] [get_bd_intf_pins MVAU_hls_0/MVAU_hls_0/in1_V]
save_bd_design
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_4_pdeejws4/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_4_pdeejws4/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_4_pdeejws4/StreamingFIFO_rtl_4.v
create_bd_cell -type module -reference StreamingFIFO_rtl_4 StreamingFIFO_rtl_4
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_1_d79hozio/swg_pkg.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_1_d79hozio/ConvolutionInputGenerator_rtl_1_wrapper.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_1_d79hozio/ConvolutionInputGenerator_rtl_1_impl.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_1_d79hozio/swg_common.sv
create_bd_cell -type module -reference ConvolutionInputGenerator_rtl_1 ConvolutionInputGenerator_rtl_1
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_5_ccr6b_15/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_5_ccr6b_15/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_5_ccr6b_15/StreamingFIFO_rtl_5.v
create_bd_cell -type module -reference StreamingFIFO_rtl_5 StreamingFIFO_rtl_5
create_bd_cell -type ip -vlnv xilinx.com:hls:Pool_hls_0:1.0 Pool_hls_0
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_6_ps7oo1st/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_6_ps7oo1st/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_6_ps7oo1st/StreamingFIFO_rtl_6.v
create_bd_cell -type module -reference StreamingFIFO_rtl_6 StreamingFIFO_rtl_6
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_FMPadding_rtl_1_vsprdlwa/fmpadding_axi.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_FMPadding_rtl_1_vsprdlwa/fmpadding.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_FMPadding_rtl_1_vsprdlwa/axi2we.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_FMPadding_rtl_1_vsprdlwa/FMPadding_rtl_1.v
create_bd_cell -type module -reference FMPadding_rtl_1 FMPadding_rtl_1
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_7_fgpn_bhp/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_7_fgpn_bhp/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_7_fgpn_bhp/StreamingFIFO_rtl_7.v
create_bd_cell -type module -reference StreamingFIFO_rtl_7 StreamingFIFO_rtl_7
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_2_xeh5e4hg/swg_pkg.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_2_xeh5e4hg/ConvolutionInputGenerator_rtl_2_wrapper.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_2_xeh5e4hg/ConvolutionInputGenerator_rtl_2_impl.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_2_xeh5e4hg/swg_common.sv
create_bd_cell -type module -reference ConvolutionInputGenerator_rtl_2 ConvolutionInputGenerator_rtl_2
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_8_v00r85i7/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_8_v00r85i7/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_8_v00r85i7/StreamingFIFO_rtl_8.v
create_bd_cell -type module -reference StreamingFIFO_rtl_8 StreamingFIFO_rtl_8
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_0_w8fo7xcf/dwc_axi.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_0_w8fo7xcf/dwc.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_0_w8fo7xcf/StreamingDataWidthConverter_rtl_0.v
create_bd_cell -type module -reference StreamingDataWidthConverter_rtl_0 StreamingDataWidthConverter_rtl_0
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_9_37b_80b8/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_9_37b_80b8/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_9_37b_80b8/StreamingFIFO_rtl_9.v
create_bd_cell -type module -reference StreamingFIFO_rtl_9 StreamingFIFO_rtl_9
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
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_1 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_MVAU_hls_1_dfsd34e_/MVAU_hls_1_memstream_wrapper.v
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_1 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/axi/hdl/axilite.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_1 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream_axi.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_1 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream.sv
create_bd_cell -type hier -reference MVAU_hls_1_memstream_wrapper /MVAU_hls_1/MVAU_hls_1_wstrm
connect_bd_net [get_bd_pins MVAU_hls_1/ap_clk] [get_bd_pins MVAU_hls_1/MVAU_hls_1_wstrm/ap_clk]
connect_bd_net [get_bd_pins MVAU_hls_1/ap_rst_n] [get_bd_pins MVAU_hls_1/MVAU_hls_1_wstrm/ap_rst_n]
connect_bd_net [get_bd_pins MVAU_hls_1/ap_clk] [get_bd_pins MVAU_hls_1/MVAU_hls_1_wstrm/ap_clk2x]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_1/MVAU_hls_1_wstrm/m_axis_0] [get_bd_intf_pins MVAU_hls_1/MVAU_hls_1/in1_V]
save_bd_design
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_10_adbf5x85/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_10_adbf5x85/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_10_adbf5x85/StreamingFIFO_rtl_10.v
create_bd_cell -type module -reference StreamingFIFO_rtl_10 StreamingFIFO_rtl_10
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_1_nu6ch4g_/dwc_axi.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_1_nu6ch4g_/dwc.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_1_nu6ch4g_/StreamingDataWidthConverter_rtl_1.v
create_bd_cell -type module -reference StreamingDataWidthConverter_rtl_1 StreamingDataWidthConverter_rtl_1
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_11_wbo3jcpa/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_11_wbo3jcpa/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_11_wbo3jcpa/StreamingFIFO_rtl_11.v
create_bd_cell -type module -reference StreamingFIFO_rtl_11 StreamingFIFO_rtl_11
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_3_xu9la4av/swg_pkg.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_3_xu9la4av/ConvolutionInputGenerator_rtl_3_wrapper.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_3_xu9la4av/ConvolutionInputGenerator_rtl_3_impl.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_3_xu9la4av/swg_common.sv
create_bd_cell -type module -reference ConvolutionInputGenerator_rtl_3 ConvolutionInputGenerator_rtl_3
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_12_8y84gey0/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_12_8y84gey0/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_12_8y84gey0/StreamingFIFO_rtl_12.v
create_bd_cell -type module -reference StreamingFIFO_rtl_12 StreamingFIFO_rtl_12
create_bd_cell -type ip -vlnv xilinx.com:hls:Pool_hls_1:1.0 Pool_hls_1
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_13_hlne3g2g/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_13_hlne3g2g/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_13_hlne3g2g/StreamingFIFO_rtl_13.v
create_bd_cell -type module -reference StreamingFIFO_rtl_13 StreamingFIFO_rtl_13
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_FMPadding_rtl_2_mng6_dzo/fmpadding_axi.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_FMPadding_rtl_2_mng6_dzo/fmpadding.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_FMPadding_rtl_2_mng6_dzo/axi2we.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_FMPadding_rtl_2_mng6_dzo/FMPadding_rtl_2.v
create_bd_cell -type module -reference FMPadding_rtl_2 FMPadding_rtl_2
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_14_q8cjzqre/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_14_q8cjzqre/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_14_q8cjzqre/StreamingFIFO_rtl_14.v
create_bd_cell -type module -reference StreamingFIFO_rtl_14 StreamingFIFO_rtl_14
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_2_ttq9leg5/dwc_axi.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_2_ttq9leg5/dwc.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_2_ttq9leg5/StreamingDataWidthConverter_rtl_2.v
create_bd_cell -type module -reference StreamingDataWidthConverter_rtl_2 StreamingDataWidthConverter_rtl_2
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_15__wpyt5te/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_15__wpyt5te/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_15__wpyt5te/StreamingFIFO_rtl_15.v
create_bd_cell -type module -reference StreamingFIFO_rtl_15 StreamingFIFO_rtl_15
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_4_qcvzwqax/swg_pkg.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_4_qcvzwqax/ConvolutionInputGenerator_rtl_4_wrapper.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_4_qcvzwqax/ConvolutionInputGenerator_rtl_4_impl.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_ConvolutionInputGenerator_rtl_4_qcvzwqax/swg_common.sv
create_bd_cell -type module -reference ConvolutionInputGenerator_rtl_4 ConvolutionInputGenerator_rtl_4
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_16_2_84ko7i/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_16_2_84ko7i/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_16_2_84ko7i/StreamingFIFO_rtl_16.v
create_bd_cell -type module -reference StreamingFIFO_rtl_16 StreamingFIFO_rtl_16
create_bd_cell -type ip -vlnv xilinx.com:hls:StreamingDataWidthConverter_hls_0:1.0 StreamingDataWidthConverter_hls_0
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_17_mkwo1d5c/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_17_mkwo1d5c/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_17_mkwo1d5c/StreamingFIFO_rtl_17.v
create_bd_cell -type module -reference StreamingFIFO_rtl_17 StreamingFIFO_rtl_17
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
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_2 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_MVAU_hls_2_ob_gy9wj/MVAU_hls_2_memstream_wrapper.v
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_2 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/axi/hdl/axilite.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_2 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream_axi.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_2 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream.sv
create_bd_cell -type hier -reference MVAU_hls_2_memstream_wrapper /MVAU_hls_2/MVAU_hls_2_wstrm
connect_bd_net [get_bd_pins MVAU_hls_2/ap_clk] [get_bd_pins MVAU_hls_2/MVAU_hls_2_wstrm/ap_clk]
connect_bd_net [get_bd_pins MVAU_hls_2/ap_rst_n] [get_bd_pins MVAU_hls_2/MVAU_hls_2_wstrm/ap_rst_n]
connect_bd_net [get_bd_pins MVAU_hls_2/ap_clk] [get_bd_pins MVAU_hls_2/MVAU_hls_2_wstrm/ap_clk2x]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_2/MVAU_hls_2_wstrm/m_axis_0] [get_bd_intf_pins MVAU_hls_2/MVAU_hls_2/in1_V]
save_bd_design
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_18_dwzsfgsz/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_18_dwzsfgsz/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_18_dwzsfgsz/StreamingFIFO_rtl_18.v
create_bd_cell -type module -reference StreamingFIFO_rtl_18 StreamingFIFO_rtl_18
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
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_3 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_MVAU_hls_3_ak9swqgw/MVAU_hls_3_memstream_wrapper.v
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_3 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/axi/hdl/axilite.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_3 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream_axi.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_3 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream.sv
create_bd_cell -type hier -reference MVAU_hls_3_memstream_wrapper /MVAU_hls_3/MVAU_hls_3_wstrm
connect_bd_net [get_bd_pins MVAU_hls_3/ap_clk] [get_bd_pins MVAU_hls_3/MVAU_hls_3_wstrm/ap_clk]
connect_bd_net [get_bd_pins MVAU_hls_3/ap_rst_n] [get_bd_pins MVAU_hls_3/MVAU_hls_3_wstrm/ap_rst_n]
connect_bd_net [get_bd_pins MVAU_hls_3/ap_clk] [get_bd_pins MVAU_hls_3/MVAU_hls_3_wstrm/ap_clk2x]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_3/MVAU_hls_3_wstrm/m_axis_0] [get_bd_intf_pins MVAU_hls_3/MVAU_hls_3/in1_V]
save_bd_design
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_19_u162qniq/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_19_u162qniq/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_19_u162qniq/StreamingFIFO_rtl_19.v
create_bd_cell -type module -reference StreamingFIFO_rtl_19 StreamingFIFO_rtl_19
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_3_yiu65p5b/dwc_axi.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_3_yiu65p5b/dwc.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingDataWidthConverter_rtl_3_yiu65p5b/StreamingDataWidthConverter_rtl_3.v
create_bd_cell -type module -reference StreamingDataWidthConverter_rtl_3 StreamingDataWidthConverter_rtl_3
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_20_o2zi6wcd/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_20_o2zi6wcd/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_20_o2zi6wcd/StreamingFIFO_rtl_20.v
create_bd_cell -type module -reference StreamingFIFO_rtl_20 StreamingFIFO_rtl_20
file mkdir ./ip/verilog/rtl_ops/MVAU_hls_4
create_bd_cell -type hier MVAU_hls_4
create_bd_pin -dir I -type clk /MVAU_hls_4/ap_clk
create_bd_pin -dir I -type rst /MVAU_hls_4/ap_rst_n
create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 /MVAU_hls_4/out0_V
create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 /MVAU_hls_4/in0_V
create_bd_cell -type ip -vlnv xilinx.com:hls:MVAU_hls_4:1.0 /MVAU_hls_4/MVAU_hls_4
connect_bd_net [get_bd_pins MVAU_hls_4/ap_rst_n] [get_bd_pins MVAU_hls_4/MVAU_hls_4/ap_rst_n]
connect_bd_net [get_bd_pins MVAU_hls_4/ap_clk] [get_bd_pins MVAU_hls_4/MVAU_hls_4/ap_clk]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_4/in0_V] [get_bd_intf_pins MVAU_hls_4/MVAU_hls_4/in0_V]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_4/out0_V] [get_bd_intf_pins MVAU_hls_4/MVAU_hls_4/out0_V]
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_4 -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_MVAU_hls_4_8z4ge1f8/MVAU_hls_4_memstream_wrapper.v
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_4 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/axi/hdl/axilite.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_4 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream_axi.sv
add_files -copy_to ./ip/verilog/rtl_ops/MVAU_hls_4 -norecurse /home/neuralnetwork01/miniconda3/envs/nnlab/lib/python3.11/site-packages/finn/finn-rtllib/memstream/hdl/memstream.sv
create_bd_cell -type hier -reference MVAU_hls_4_memstream_wrapper /MVAU_hls_4/MVAU_hls_4_wstrm
connect_bd_net [get_bd_pins MVAU_hls_4/ap_clk] [get_bd_pins MVAU_hls_4/MVAU_hls_4_wstrm/ap_clk]
connect_bd_net [get_bd_pins MVAU_hls_4/ap_rst_n] [get_bd_pins MVAU_hls_4/MVAU_hls_4_wstrm/ap_rst_n]
connect_bd_net [get_bd_pins MVAU_hls_4/ap_clk] [get_bd_pins MVAU_hls_4/MVAU_hls_4_wstrm/ap_clk2x]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_4/MVAU_hls_4_wstrm/m_axis_0] [get_bd_intf_pins MVAU_hls_4/MVAU_hls_4/in1_V]
save_bd_design
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_21_c3hdeu9l/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_21_c3hdeu9l/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_21_c3hdeu9l/StreamingFIFO_rtl_21.v
create_bd_cell -type module -reference StreamingFIFO_rtl_21 StreamingFIFO_rtl_21
create_bd_cell -type ip -vlnv xilinx.com:hls:LabelSelect_hls_0:1.0 LabelSelect_hls_0
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_22_j2l_0vok/fifo_gauge.sv
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_22_j2l_0vok/Q_srl.v
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/code_gen_ipgen_StreamingFIFO_rtl_22_j2l_0vok/StreamingFIFO_rtl_22.v
create_bd_cell -type module -reference StreamingFIFO_rtl_22 StreamingFIFO_rtl_22
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
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins FMPadding_rtl_0/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins FMPadding_rtl_0/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_1/out0_V] [get_bd_intf_pins FMPadding_rtl_0/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_2/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_2/ap_clk]
connect_bd_intf_net [get_bd_intf_pins FMPadding_rtl_0/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_2/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins ConvolutionInputGenerator_rtl_0/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins ConvolutionInputGenerator_rtl_0/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_2/out0_V] [get_bd_intf_pins ConvolutionInputGenerator_rtl_0/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_3/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_3/ap_clk]
connect_bd_intf_net [get_bd_intf_pins ConvolutionInputGenerator_rtl_0/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_3/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins MVAU_hls_0/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins MVAU_hls_0/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_3/out0_V] [get_bd_intf_pins MVAU_hls_0/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_4/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_4/ap_clk]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_0/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_4/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins ConvolutionInputGenerator_rtl_1/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins ConvolutionInputGenerator_rtl_1/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_4/out0_V] [get_bd_intf_pins ConvolutionInputGenerator_rtl_1/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_5/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_5/ap_clk]
connect_bd_intf_net [get_bd_intf_pins ConvolutionInputGenerator_rtl_1/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_5/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins Pool_hls_0/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins Pool_hls_0/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_5/out0_V] [get_bd_intf_pins Pool_hls_0/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_6/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_6/ap_clk]
connect_bd_intf_net [get_bd_intf_pins Pool_hls_0/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_6/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins FMPadding_rtl_1/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins FMPadding_rtl_1/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_6/out0_V] [get_bd_intf_pins FMPadding_rtl_1/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_7/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_7/ap_clk]
connect_bd_intf_net [get_bd_intf_pins FMPadding_rtl_1/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_7/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins ConvolutionInputGenerator_rtl_2/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins ConvolutionInputGenerator_rtl_2/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_7/out0_V] [get_bd_intf_pins ConvolutionInputGenerator_rtl_2/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_8/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_8/ap_clk]
connect_bd_intf_net [get_bd_intf_pins ConvolutionInputGenerator_rtl_2/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_8/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingDataWidthConverter_rtl_0/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingDataWidthConverter_rtl_0/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_8/out0_V] [get_bd_intf_pins StreamingDataWidthConverter_rtl_0/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_9/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_9/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingDataWidthConverter_rtl_0/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_9/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins MVAU_hls_1/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins MVAU_hls_1/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_9/out0_V] [get_bd_intf_pins MVAU_hls_1/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_10/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_10/ap_clk]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_1/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_10/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingDataWidthConverter_rtl_1/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingDataWidthConverter_rtl_1/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_10/out0_V] [get_bd_intf_pins StreamingDataWidthConverter_rtl_1/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_11/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_11/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingDataWidthConverter_rtl_1/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_11/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins ConvolutionInputGenerator_rtl_3/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins ConvolutionInputGenerator_rtl_3/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_11/out0_V] [get_bd_intf_pins ConvolutionInputGenerator_rtl_3/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_12/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_12/ap_clk]
connect_bd_intf_net [get_bd_intf_pins ConvolutionInputGenerator_rtl_3/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_12/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins Pool_hls_1/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins Pool_hls_1/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_12/out0_V] [get_bd_intf_pins Pool_hls_1/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_13/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_13/ap_clk]
connect_bd_intf_net [get_bd_intf_pins Pool_hls_1/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_13/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins FMPadding_rtl_2/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins FMPadding_rtl_2/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_13/out0_V] [get_bd_intf_pins FMPadding_rtl_2/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_14/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_14/ap_clk]
connect_bd_intf_net [get_bd_intf_pins FMPadding_rtl_2/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_14/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingDataWidthConverter_rtl_2/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingDataWidthConverter_rtl_2/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_14/out0_V] [get_bd_intf_pins StreamingDataWidthConverter_rtl_2/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_15/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_15/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingDataWidthConverter_rtl_2/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_15/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins ConvolutionInputGenerator_rtl_4/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins ConvolutionInputGenerator_rtl_4/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_15/out0_V] [get_bd_intf_pins ConvolutionInputGenerator_rtl_4/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_16/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_16/ap_clk]
connect_bd_intf_net [get_bd_intf_pins ConvolutionInputGenerator_rtl_4/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_16/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingDataWidthConverter_hls_0/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingDataWidthConverter_hls_0/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_16/out0_V] [get_bd_intf_pins StreamingDataWidthConverter_hls_0/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_17/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_17/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingDataWidthConverter_hls_0/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_17/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins MVAU_hls_2/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins MVAU_hls_2/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_17/out0_V] [get_bd_intf_pins MVAU_hls_2/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_18/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_18/ap_clk]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_2/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_18/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins MVAU_hls_3/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins MVAU_hls_3/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_18/out0_V] [get_bd_intf_pins MVAU_hls_3/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_19/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_19/ap_clk]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_3/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_19/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingDataWidthConverter_rtl_3/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingDataWidthConverter_rtl_3/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_19/out0_V] [get_bd_intf_pins StreamingDataWidthConverter_rtl_3/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_20/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_20/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingDataWidthConverter_rtl_3/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_20/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins MVAU_hls_4/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins MVAU_hls_4/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_20/out0_V] [get_bd_intf_pins MVAU_hls_4/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_21/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_21/ap_clk]
connect_bd_intf_net [get_bd_intf_pins MVAU_hls_4/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_21/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins LabelSelect_hls_0/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins LabelSelect_hls_0/ap_clk]
connect_bd_intf_net [get_bd_intf_pins StreamingFIFO_rtl_21/out0_V] [get_bd_intf_pins LabelSelect_hls_0/in0_V]
connect_bd_net [get_bd_ports ap_rst_n] [get_bd_pins StreamingFIFO_rtl_22/ap_rst_n]
connect_bd_net [get_bd_ports ap_clk] [get_bd_pins StreamingFIFO_rtl_22/ap_clk]
connect_bd_intf_net [get_bd_intf_pins LabelSelect_hls_0/out0_V] [get_bd_intf_pins StreamingFIFO_rtl_22/in0_V]
make_bd_intf_pins_external [get_bd_intf_pins StreamingFIFO_rtl_0/in0_V]
set_property name s_axis_0 [get_bd_intf_ports in0_V_0]
make_bd_intf_pins_external [get_bd_intf_pins StreamingFIFO_rtl_22/out0_V]
set_property name m_axis_0 [get_bd_intf_ports out0_V_0]
set_property CONFIG.FREQ_HZ 100000000 [get_bd_ports /ap_clk]
validate_bd_design
save_bd_design
make_wrapper -files [get_files /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/vivado_stitch_proj_ymcwak5l/finn_vivado_stitch_proj.srcs/sources_1/bd/finn_design/finn_design.bd] -top
add_files -norecurse /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/vivado_stitch_proj_ymcwak5l/finn_vivado_stitch_proj.srcs/sources_1/bd/finn_design/hdl/finn_design_wrapper.v
set_property top finn_design_wrapper [current_fileset]
ipx::package_project -root_dir /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/vivado_stitch_proj_ymcwak5l/ip -vendor xilinx_finn -library finn -taxonomy /UserIP -module finn_design -import_files
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
set fp [open /home/neuralnetwork01/Schreibtisch/s7s/nn/task4/FINN_TMP/vivado_stitch_proj_ymcwak5l/all_verilog_srcs.txt w]
foreach vf $all_v_files {puts $fp $vf}
close $fp
