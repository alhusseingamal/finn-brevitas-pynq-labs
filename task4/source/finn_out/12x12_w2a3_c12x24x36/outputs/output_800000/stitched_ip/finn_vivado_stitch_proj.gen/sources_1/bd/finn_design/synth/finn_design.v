//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
//Date        : Fri Jul 31 10:31:45 2026
//Host        : i83labpc01 running 64-bit Ubuntu 24.04.4 LTS
//Command     : generate_target finn_design.bd
//Design      : finn_design
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module MVAU_hls_0_imp_7OH4JA
   (ap_clk,
    ap_rst_n,
    in0_V_tdata,
    in0_V_tready,
    in0_V_tvalid,
    out0_V_tdata,
    out0_V_tready,
    out0_V_tvalid);
  input ap_clk;
  input ap_rst_n;
  input [215:0]in0_V_tdata;
  output in0_V_tready;
  input in0_V_tvalid;
  output [39:0]out0_V_tdata;
  input out0_V_tready;
  output out0_V_tvalid;

  wire [39:0]MVAU_hls_0_out0_V_TDATA;
  wire MVAU_hls_0_out0_V_TREADY;
  wire MVAU_hls_0_out0_V_TVALID;
  wire [647:0]MVAU_hls_0_wstrm_m_axis_0_TDATA;
  wire MVAU_hls_0_wstrm_m_axis_0_TREADY;
  wire MVAU_hls_0_wstrm_m_axis_0_TVALID;
  wire ap_clk_1;
  wire ap_rst_n_1;
  wire [215:0]in0_V_1_TDATA;
  wire in0_V_1_TREADY;
  wire in0_V_1_TVALID;

  assign MVAU_hls_0_out0_V_TREADY = out0_V_tready;
  assign ap_clk_1 = ap_clk;
  assign ap_rst_n_1 = ap_rst_n;
  assign in0_V_1_TDATA = in0_V_tdata[215:0];
  assign in0_V_1_TVALID = in0_V_tvalid;
  assign in0_V_tready = in0_V_1_TREADY;
  assign out0_V_tdata[39:0] = MVAU_hls_0_out0_V_TDATA;
  assign out0_V_tvalid = MVAU_hls_0_out0_V_TVALID;
  finn_design_MVAU_hls_0_0 MVAU_hls_0
       (.ap_clk(ap_clk_1),
        .ap_rst_n(ap_rst_n_1),
        .in0_V_TDATA(in0_V_1_TDATA),
        .in0_V_TREADY(in0_V_1_TREADY),
        .in0_V_TVALID(in0_V_1_TVALID),
        .in1_V_TDATA(MVAU_hls_0_wstrm_m_axis_0_TDATA),
        .in1_V_TREADY(MVAU_hls_0_wstrm_m_axis_0_TREADY),
        .in1_V_TVALID(MVAU_hls_0_wstrm_m_axis_0_TVALID),
        .out0_V_TDATA(MVAU_hls_0_out0_V_TDATA),
        .out0_V_TREADY(MVAU_hls_0_out0_V_TREADY),
        .out0_V_TVALID(MVAU_hls_0_out0_V_TVALID));
  finn_design_MVAU_hls_0_wstrm_0 MVAU_hls_0_wstrm
       (.ap_clk(ap_clk_1),
        .ap_clk2x(ap_clk_1),
        .ap_rst_n(ap_rst_n_1),
        .m_axis_0_tdata(MVAU_hls_0_wstrm_m_axis_0_TDATA),
        .m_axis_0_tready(MVAU_hls_0_wstrm_m_axis_0_TREADY),
        .m_axis_0_tvalid(MVAU_hls_0_wstrm_m_axis_0_TVALID),
        .s_axilite_ARADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_ARPROT({1'b0,1'b0,1'b0}),
        .s_axilite_ARVALID(1'b0),
        .s_axilite_AWADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_AWPROT({1'b0,1'b0,1'b0}),
        .s_axilite_AWVALID(1'b0),
        .s_axilite_BREADY(1'b0),
        .s_axilite_RREADY(1'b0),
        .s_axilite_WDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_WSTRB({1'b1,1'b1,1'b1,1'b1}),
        .s_axilite_WVALID(1'b0),
        .s_axis_0_tdata(1'b0),
        .s_axis_0_tvalid(1'b0));
endmodule

module MVAU_hls_1_imp_ZIW0NT
   (ap_clk,
    ap_rst_n,
    in0_V_tdata,
    in0_V_tready,
    in0_V_tvalid,
    out0_V_tdata,
    out0_V_tready,
    out0_V_tvalid);
  input ap_clk;
  input ap_rst_n;
  input [55:0]in0_V_tdata;
  output in0_V_tready;
  input in0_V_tvalid;
  output [71:0]out0_V_tdata;
  input out0_V_tready;
  output out0_V_tvalid;

  wire [71:0]MVAU_hls_1_out0_V_TDATA;
  wire MVAU_hls_1_out0_V_TREADY;
  wire MVAU_hls_1_out0_V_TVALID;
  wire [863:0]MVAU_hls_1_wstrm_m_axis_0_TDATA;
  wire MVAU_hls_1_wstrm_m_axis_0_TREADY;
  wire MVAU_hls_1_wstrm_m_axis_0_TVALID;
  wire ap_clk_1;
  wire ap_rst_n_1;
  wire [55:0]in0_V_1_TDATA;
  wire in0_V_1_TREADY;
  wire in0_V_1_TVALID;

  assign MVAU_hls_1_out0_V_TREADY = out0_V_tready;
  assign ap_clk_1 = ap_clk;
  assign ap_rst_n_1 = ap_rst_n;
  assign in0_V_1_TDATA = in0_V_tdata[55:0];
  assign in0_V_1_TVALID = in0_V_tvalid;
  assign in0_V_tready = in0_V_1_TREADY;
  assign out0_V_tdata[71:0] = MVAU_hls_1_out0_V_TDATA;
  assign out0_V_tvalid = MVAU_hls_1_out0_V_TVALID;
  finn_design_MVAU_hls_1_0 MVAU_hls_1
       (.ap_clk(ap_clk_1),
        .ap_rst_n(ap_rst_n_1),
        .in0_V_TDATA(in0_V_1_TDATA),
        .in0_V_TREADY(in0_V_1_TREADY),
        .in0_V_TVALID(in0_V_1_TVALID),
        .in1_V_TDATA(MVAU_hls_1_wstrm_m_axis_0_TDATA),
        .in1_V_TREADY(MVAU_hls_1_wstrm_m_axis_0_TREADY),
        .in1_V_TVALID(MVAU_hls_1_wstrm_m_axis_0_TVALID),
        .out0_V_TDATA(MVAU_hls_1_out0_V_TDATA),
        .out0_V_TREADY(MVAU_hls_1_out0_V_TREADY),
        .out0_V_TVALID(MVAU_hls_1_out0_V_TVALID));
  finn_design_MVAU_hls_1_wstrm_0 MVAU_hls_1_wstrm
       (.ap_clk(ap_clk_1),
        .ap_clk2x(ap_clk_1),
        .ap_rst_n(ap_rst_n_1),
        .m_axis_0_tdata(MVAU_hls_1_wstrm_m_axis_0_TDATA),
        .m_axis_0_tready(MVAU_hls_1_wstrm_m_axis_0_TREADY),
        .m_axis_0_tvalid(MVAU_hls_1_wstrm_m_axis_0_TVALID),
        .s_axilite_ARADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_ARPROT({1'b0,1'b0,1'b0}),
        .s_axilite_ARVALID(1'b0),
        .s_axilite_AWADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_AWPROT({1'b0,1'b0,1'b0}),
        .s_axilite_AWVALID(1'b0),
        .s_axilite_BREADY(1'b0),
        .s_axilite_RREADY(1'b0),
        .s_axilite_WDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_WSTRB({1'b1,1'b1,1'b1,1'b1}),
        .s_axilite_WVALID(1'b0),
        .s_axis_0_tdata(1'b0),
        .s_axis_0_tvalid(1'b0));
endmodule

module MVAU_hls_2_imp_1WP2WTL
   (ap_clk,
    ap_rst_n,
    in0_V_tdata,
    in0_V_tready,
    in0_V_tvalid,
    out0_V_tdata,
    out0_V_tready,
    out0_V_tvalid);
  input ap_clk;
  input ap_rst_n;
  input [55:0]in0_V_tdata;
  output in0_V_tready;
  input in0_V_tvalid;
  output [55:0]out0_V_tdata;
  input out0_V_tready;
  output out0_V_tvalid;

  wire [55:0]MVAU_hls_2_out0_V_TDATA;
  wire MVAU_hls_2_out0_V_TREADY;
  wire MVAU_hls_2_out0_V_TVALID;
  wire [647:0]MVAU_hls_2_wstrm_m_axis_0_TDATA;
  wire MVAU_hls_2_wstrm_m_axis_0_TREADY;
  wire MVAU_hls_2_wstrm_m_axis_0_TVALID;
  wire ap_clk_1;
  wire ap_rst_n_1;
  wire [55:0]in0_V_1_TDATA;
  wire in0_V_1_TREADY;
  wire in0_V_1_TVALID;

  assign MVAU_hls_2_out0_V_TREADY = out0_V_tready;
  assign ap_clk_1 = ap_clk;
  assign ap_rst_n_1 = ap_rst_n;
  assign in0_V_1_TDATA = in0_V_tdata[55:0];
  assign in0_V_1_TVALID = in0_V_tvalid;
  assign in0_V_tready = in0_V_1_TREADY;
  assign out0_V_tdata[55:0] = MVAU_hls_2_out0_V_TDATA;
  assign out0_V_tvalid = MVAU_hls_2_out0_V_TVALID;
  finn_design_MVAU_hls_2_0 MVAU_hls_2
       (.ap_clk(ap_clk_1),
        .ap_rst_n(ap_rst_n_1),
        .in0_V_TDATA(in0_V_1_TDATA),
        .in0_V_TREADY(in0_V_1_TREADY),
        .in0_V_TVALID(in0_V_1_TVALID),
        .in1_V_TDATA(MVAU_hls_2_wstrm_m_axis_0_TDATA),
        .in1_V_TREADY(MVAU_hls_2_wstrm_m_axis_0_TREADY),
        .in1_V_TVALID(MVAU_hls_2_wstrm_m_axis_0_TVALID),
        .out0_V_TDATA(MVAU_hls_2_out0_V_TDATA),
        .out0_V_TREADY(MVAU_hls_2_out0_V_TREADY),
        .out0_V_TVALID(MVAU_hls_2_out0_V_TVALID));
  finn_design_MVAU_hls_2_wstrm_0 MVAU_hls_2_wstrm
       (.ap_clk(ap_clk_1),
        .ap_clk2x(ap_clk_1),
        .ap_rst_n(ap_rst_n_1),
        .m_axis_0_tdata(MVAU_hls_2_wstrm_m_axis_0_TDATA),
        .m_axis_0_tready(MVAU_hls_2_wstrm_m_axis_0_TREADY),
        .m_axis_0_tvalid(MVAU_hls_2_wstrm_m_axis_0_TVALID),
        .s_axilite_ARADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_ARPROT({1'b0,1'b0,1'b0}),
        .s_axilite_ARVALID(1'b0),
        .s_axilite_AWADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_AWPROT({1'b0,1'b0,1'b0}),
        .s_axilite_AWVALID(1'b0),
        .s_axilite_BREADY(1'b0),
        .s_axilite_RREADY(1'b0),
        .s_axilite_WDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_WSTRB({1'b1,1'b1,1'b1,1'b1}),
        .s_axilite_WVALID(1'b0),
        .s_axis_0_tdata(1'b0),
        .s_axis_0_tvalid(1'b0));
endmodule

module MVAU_hls_3_imp_U0RWZQ
   (ap_clk,
    ap_rst_n,
    in0_V_tdata,
    in0_V_tready,
    in0_V_tvalid,
    out0_V_tdata,
    out0_V_tready,
    out0_V_tvalid);
  input ap_clk;
  input ap_rst_n;
  input [55:0]in0_V_tdata;
  output in0_V_tready;
  input in0_V_tvalid;
  output [23:0]out0_V_tdata;
  input out0_V_tready;
  output out0_V_tvalid;

  wire [23:0]MVAU_hls_3_out0_V_TDATA;
  wire MVAU_hls_3_out0_V_TREADY;
  wire MVAU_hls_3_out0_V_TVALID;
  wire [287:0]MVAU_hls_3_wstrm_m_axis_0_TDATA;
  wire MVAU_hls_3_wstrm_m_axis_0_TREADY;
  wire MVAU_hls_3_wstrm_m_axis_0_TVALID;
  wire ap_clk_1;
  wire ap_rst_n_1;
  wire [55:0]in0_V_1_TDATA;
  wire in0_V_1_TREADY;
  wire in0_V_1_TVALID;

  assign MVAU_hls_3_out0_V_TREADY = out0_V_tready;
  assign ap_clk_1 = ap_clk;
  assign ap_rst_n_1 = ap_rst_n;
  assign in0_V_1_TDATA = in0_V_tdata[55:0];
  assign in0_V_1_TVALID = in0_V_tvalid;
  assign in0_V_tready = in0_V_1_TREADY;
  assign out0_V_tdata[23:0] = MVAU_hls_3_out0_V_TDATA;
  assign out0_V_tvalid = MVAU_hls_3_out0_V_TVALID;
  finn_design_MVAU_hls_3_0 MVAU_hls_3
       (.ap_clk(ap_clk_1),
        .ap_rst_n(ap_rst_n_1),
        .in0_V_TDATA(in0_V_1_TDATA),
        .in0_V_TREADY(in0_V_1_TREADY),
        .in0_V_TVALID(in0_V_1_TVALID),
        .in1_V_TDATA(MVAU_hls_3_wstrm_m_axis_0_TDATA),
        .in1_V_TREADY(MVAU_hls_3_wstrm_m_axis_0_TREADY),
        .in1_V_TVALID(MVAU_hls_3_wstrm_m_axis_0_TVALID),
        .out0_V_TDATA(MVAU_hls_3_out0_V_TDATA),
        .out0_V_TREADY(MVAU_hls_3_out0_V_TREADY),
        .out0_V_TVALID(MVAU_hls_3_out0_V_TVALID));
  finn_design_MVAU_hls_3_wstrm_0 MVAU_hls_3_wstrm
       (.ap_clk(ap_clk_1),
        .ap_clk2x(ap_clk_1),
        .ap_rst_n(ap_rst_n_1),
        .m_axis_0_tdata(MVAU_hls_3_wstrm_m_axis_0_TDATA),
        .m_axis_0_tready(MVAU_hls_3_wstrm_m_axis_0_TREADY),
        .m_axis_0_tvalid(MVAU_hls_3_wstrm_m_axis_0_TVALID),
        .s_axilite_ARADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_ARPROT({1'b0,1'b0,1'b0}),
        .s_axilite_ARVALID(1'b0),
        .s_axilite_AWADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_AWPROT({1'b0,1'b0,1'b0}),
        .s_axilite_AWVALID(1'b0),
        .s_axilite_BREADY(1'b0),
        .s_axilite_RREADY(1'b0),
        .s_axilite_WDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_WSTRB({1'b1,1'b1,1'b1,1'b1}),
        .s_axilite_WVALID(1'b0),
        .s_axis_0_tdata(1'b0),
        .s_axis_0_tvalid(1'b0));
endmodule

module MVAU_hls_4_imp_6UFUIX
   (ap_clk,
    ap_rst_n,
    in0_V_tdata,
    in0_V_tready,
    in0_V_tvalid,
    out0_V_tdata,
    out0_V_tready,
    out0_V_tvalid);
  input ap_clk;
  input ap_rst_n;
  input [47:0]in0_V_tdata;
  output in0_V_tready;
  input in0_V_tvalid;
  output [31:0]out0_V_tdata;
  input out0_V_tready;
  output out0_V_tvalid;

  wire [31:0]MVAU_hls_4_out0_V_TDATA;
  wire MVAU_hls_4_out0_V_TREADY;
  wire MVAU_hls_4_out0_V_TVALID;
  wire [31:0]MVAU_hls_4_wstrm_m_axis_0_TDATA;
  wire MVAU_hls_4_wstrm_m_axis_0_TREADY;
  wire MVAU_hls_4_wstrm_m_axis_0_TVALID;
  wire ap_clk_1;
  wire ap_rst_n_1;
  wire [47:0]in0_V_1_TDATA;
  wire in0_V_1_TREADY;
  wire in0_V_1_TVALID;

  assign MVAU_hls_4_out0_V_TREADY = out0_V_tready;
  assign ap_clk_1 = ap_clk;
  assign ap_rst_n_1 = ap_rst_n;
  assign in0_V_1_TDATA = in0_V_tdata[47:0];
  assign in0_V_1_TVALID = in0_V_tvalid;
  assign in0_V_tready = in0_V_1_TREADY;
  assign out0_V_tdata[31:0] = MVAU_hls_4_out0_V_TDATA;
  assign out0_V_tvalid = MVAU_hls_4_out0_V_TVALID;
  finn_design_MVAU_hls_4_0 MVAU_hls_4
       (.ap_clk(ap_clk_1),
        .ap_rst_n(ap_rst_n_1),
        .in0_V_TDATA(in0_V_1_TDATA),
        .in0_V_TREADY(in0_V_1_TREADY),
        .in0_V_TVALID(in0_V_1_TVALID),
        .in1_V_TDATA(MVAU_hls_4_wstrm_m_axis_0_TDATA),
        .in1_V_TREADY(MVAU_hls_4_wstrm_m_axis_0_TREADY),
        .in1_V_TVALID(MVAU_hls_4_wstrm_m_axis_0_TVALID),
        .out0_V_TDATA(MVAU_hls_4_out0_V_TDATA),
        .out0_V_TREADY(MVAU_hls_4_out0_V_TREADY),
        .out0_V_TVALID(MVAU_hls_4_out0_V_TVALID));
  finn_design_MVAU_hls_4_wstrm_0 MVAU_hls_4_wstrm
       (.ap_clk(ap_clk_1),
        .ap_clk2x(ap_clk_1),
        .ap_rst_n(ap_rst_n_1),
        .m_axis_0_tdata(MVAU_hls_4_wstrm_m_axis_0_TDATA),
        .m_axis_0_tready(MVAU_hls_4_wstrm_m_axis_0_TREADY),
        .m_axis_0_tvalid(MVAU_hls_4_wstrm_m_axis_0_TVALID),
        .s_axilite_ARADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_ARPROT({1'b0,1'b0,1'b0}),
        .s_axilite_ARVALID(1'b0),
        .s_axilite_AWADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_AWPROT({1'b0,1'b0,1'b0}),
        .s_axilite_AWVALID(1'b0),
        .s_axilite_BREADY(1'b0),
        .s_axilite_RREADY(1'b0),
        .s_axilite_WDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_WSTRB({1'b1,1'b1,1'b1,1'b1}),
        .s_axilite_WVALID(1'b0),
        .s_axis_0_tdata(1'b0),
        .s_axis_0_tvalid(1'b0));
endmodule

(* CORE_GENERATION_INFO = "finn_design,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=finn_design,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=55,numReposBlks=50,numNonXlnxBlks=0,numHierBlks=5,maxHierDepth=1,numSysgenBlks=0,numHlsBlks=9,numHdlrefBlks=41,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "finn_design.hwdef" *) 
module finn_design
   (ap_clk,
    ap_rst_n,
    m_axis_0_tdata,
    m_axis_0_tready,
    m_axis_0_tvalid,
    s_axis_0_tdata,
    s_axis_0_tready,
    s_axis_0_tvalid);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.AP_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.AP_CLK, ASSOCIATED_BUSIF s_axis_0:m_axis_0, ASSOCIATED_RESET ap_rst_n, CLK_DOMAIN finn_design_ap_clk_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input ap_clk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.AP_RST_N RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.AP_RST_N, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input ap_rst_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_0 " *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axis_0, CLK_DOMAIN finn_design_ap_clk_0, FREQ_HZ 100000000, HAS_TKEEP 0, HAS_TLAST 0, HAS_TREADY 1, HAS_TSTRB 0, INSERT_VIP 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0" *) output [7:0]m_axis_0_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_0 " *) input m_axis_0_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_0 " *) output m_axis_0_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_0 " *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axis_0, CLK_DOMAIN finn_design_ap_clk_0, FREQ_HZ 100000000, HAS_TKEEP 0, HAS_TLAST 0, HAS_TREADY 1, HAS_TSTRB 0, INSERT_VIP 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 3, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0" *) input [23:0]s_axis_0_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_0 " *) output s_axis_0_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_0 " *) input s_axis_0_tvalid;

  wire [215:0]ConvolutionInputGenerator_rtl_0_out0_V_TDATA;
  wire ConvolutionInputGenerator_rtl_0_out0_V_TREADY;
  wire ConvolutionInputGenerator_rtl_0_out0_V_TVALID;
  wire [39:0]ConvolutionInputGenerator_rtl_1_out0_V_TDATA;
  wire ConvolutionInputGenerator_rtl_1_out0_V_TREADY;
  wire ConvolutionInputGenerator_rtl_1_out0_V_TVALID;
  wire [327:0]ConvolutionInputGenerator_rtl_2_out0_V_TDATA;
  wire ConvolutionInputGenerator_rtl_2_out0_V_TREADY;
  wire ConvolutionInputGenerator_rtl_2_out0_V_TVALID;
  wire [39:0]ConvolutionInputGenerator_rtl_3_out0_V_TDATA;
  wire ConvolutionInputGenerator_rtl_3_out0_V_TREADY;
  wire ConvolutionInputGenerator_rtl_3_out0_V_TVALID;
  wire [71:0]ConvolutionInputGenerator_rtl_4_out0_V_TDATA;
  wire ConvolutionInputGenerator_rtl_4_out0_V_TREADY;
  wire ConvolutionInputGenerator_rtl_4_out0_V_TVALID;
  wire [23:0]FMPadding_rtl_0_out0_V_TDATA;
  wire FMPadding_rtl_0_out0_V_TREADY;
  wire FMPadding_rtl_0_out0_V_TVALID;
  wire [39:0]FMPadding_rtl_1_out0_V_TDATA;
  wire FMPadding_rtl_1_out0_V_TREADY;
  wire FMPadding_rtl_1_out0_V_TVALID;
  wire [39:0]FMPadding_rtl_2_out0_V_TDATA;
  wire FMPadding_rtl_2_out0_V_TREADY;
  wire FMPadding_rtl_2_out0_V_TVALID;
  wire [7:0]LabelSelect_hls_0_out0_V_TDATA;
  wire LabelSelect_hls_0_out0_V_TREADY;
  wire LabelSelect_hls_0_out0_V_TVALID;
  wire [39:0]MVAU_hls_0_out0_V_TDATA;
  wire MVAU_hls_0_out0_V_TREADY;
  wire MVAU_hls_0_out0_V_TVALID;
  wire [71:0]MVAU_hls_1_out0_V_TDATA;
  wire MVAU_hls_1_out0_V_TREADY;
  wire MVAU_hls_1_out0_V_TVALID;
  wire [55:0]MVAU_hls_2_out0_V_TDATA;
  wire MVAU_hls_2_out0_V_TREADY;
  wire MVAU_hls_2_out0_V_TVALID;
  wire [23:0]MVAU_hls_3_out0_V_TDATA;
  wire MVAU_hls_3_out0_V_TREADY;
  wire MVAU_hls_3_out0_V_TVALID;
  wire [31:0]MVAU_hls_4_out0_V_TDATA;
  wire MVAU_hls_4_out0_V_TREADY;
  wire MVAU_hls_4_out0_V_TVALID;
  wire [39:0]Pool_hls_0_out0_V_TDATA;
  wire Pool_hls_0_out0_V_TREADY;
  wire Pool_hls_0_out0_V_TVALID;
  wire [39:0]Pool_hls_1_out0_V_TDATA;
  wire Pool_hls_1_out0_V_TREADY;
  wire Pool_hls_1_out0_V_TVALID;
  wire [55:0]StreamingDataWidthConverter_hls_0_out0_V_TDATA;
  wire StreamingDataWidthConverter_hls_0_out0_V_TREADY;
  wire StreamingDataWidthConverter_hls_0_out0_V_TVALID;
  wire [55:0]StreamingDataWidthConverter_rtl_0_out0_V_TDATA;
  wire StreamingDataWidthConverter_rtl_0_out0_V_TREADY;
  wire StreamingDataWidthConverter_rtl_0_out0_V_TVALID;
  wire [39:0]StreamingDataWidthConverter_rtl_1_out0_V_TDATA;
  wire StreamingDataWidthConverter_rtl_1_out0_V_TREADY;
  wire StreamingDataWidthConverter_rtl_1_out0_V_TVALID;
  wire [71:0]StreamingDataWidthConverter_rtl_2_out0_V_TDATA;
  wire StreamingDataWidthConverter_rtl_2_out0_V_TREADY;
  wire StreamingDataWidthConverter_rtl_2_out0_V_TVALID;
  wire [47:0]StreamingDataWidthConverter_rtl_3_out0_V_TDATA;
  wire StreamingDataWidthConverter_rtl_3_out0_V_TREADY;
  wire StreamingDataWidthConverter_rtl_3_out0_V_TVALID;
  wire [23:0]StreamingFIFO_rtl_0_out0_V_TDATA;
  wire StreamingFIFO_rtl_0_out0_V_TREADY;
  wire StreamingFIFO_rtl_0_out0_V_TVALID;
  wire [71:0]StreamingFIFO_rtl_10_out0_V_TDATA;
  wire StreamingFIFO_rtl_10_out0_V_TREADY;
  wire StreamingFIFO_rtl_10_out0_V_TVALID;
  wire [39:0]StreamingFIFO_rtl_11_out0_V_TDATA;
  wire StreamingFIFO_rtl_11_out0_V_TREADY;
  wire StreamingFIFO_rtl_11_out0_V_TVALID;
  wire [39:0]StreamingFIFO_rtl_12_out0_V_TDATA;
  wire StreamingFIFO_rtl_12_out0_V_TREADY;
  wire StreamingFIFO_rtl_12_out0_V_TVALID;
  wire [39:0]StreamingFIFO_rtl_13_out0_V_TDATA;
  wire StreamingFIFO_rtl_13_out0_V_TREADY;
  wire StreamingFIFO_rtl_13_out0_V_TVALID;
  wire [39:0]StreamingFIFO_rtl_14_out0_V_TDATA;
  wire StreamingFIFO_rtl_14_out0_V_TREADY;
  wire StreamingFIFO_rtl_14_out0_V_TVALID;
  wire [71:0]StreamingFIFO_rtl_15_out0_V_TDATA;
  wire StreamingFIFO_rtl_15_out0_V_TREADY;
  wire StreamingFIFO_rtl_15_out0_V_TVALID;
  wire [71:0]StreamingFIFO_rtl_16_out0_V_TDATA;
  wire StreamingFIFO_rtl_16_out0_V_TREADY;
  wire StreamingFIFO_rtl_16_out0_V_TVALID;
  wire [55:0]StreamingFIFO_rtl_17_out0_V_TDATA;
  wire StreamingFIFO_rtl_17_out0_V_TREADY;
  wire StreamingFIFO_rtl_17_out0_V_TVALID;
  wire [55:0]StreamingFIFO_rtl_18_out0_V_TDATA;
  wire StreamingFIFO_rtl_18_out0_V_TREADY;
  wire StreamingFIFO_rtl_18_out0_V_TVALID;
  wire [23:0]StreamingFIFO_rtl_19_out0_V_TDATA;
  wire StreamingFIFO_rtl_19_out0_V_TREADY;
  wire StreamingFIFO_rtl_19_out0_V_TVALID;
  wire [23:0]StreamingFIFO_rtl_1_out0_V_TDATA;
  wire StreamingFIFO_rtl_1_out0_V_TREADY;
  wire StreamingFIFO_rtl_1_out0_V_TVALID;
  wire [47:0]StreamingFIFO_rtl_20_out0_V_TDATA;
  wire StreamingFIFO_rtl_20_out0_V_TREADY;
  wire StreamingFIFO_rtl_20_out0_V_TVALID;
  wire [31:0]StreamingFIFO_rtl_21_out0_V_TDATA;
  wire StreamingFIFO_rtl_21_out0_V_TREADY;
  wire StreamingFIFO_rtl_21_out0_V_TVALID;
  wire [7:0]StreamingFIFO_rtl_22_out0_V_TDATA;
  wire StreamingFIFO_rtl_22_out0_V_TREADY;
  wire StreamingFIFO_rtl_22_out0_V_TVALID;
  wire [23:0]StreamingFIFO_rtl_2_out0_V_TDATA;
  wire StreamingFIFO_rtl_2_out0_V_TREADY;
  wire StreamingFIFO_rtl_2_out0_V_TVALID;
  wire [215:0]StreamingFIFO_rtl_3_out0_V_TDATA;
  wire StreamingFIFO_rtl_3_out0_V_TREADY;
  wire StreamingFIFO_rtl_3_out0_V_TVALID;
  wire [39:0]StreamingFIFO_rtl_4_out0_V_TDATA;
  wire StreamingFIFO_rtl_4_out0_V_TREADY;
  wire StreamingFIFO_rtl_4_out0_V_TVALID;
  wire [39:0]StreamingFIFO_rtl_5_out0_V_TDATA;
  wire StreamingFIFO_rtl_5_out0_V_TREADY;
  wire StreamingFIFO_rtl_5_out0_V_TVALID;
  wire [39:0]StreamingFIFO_rtl_6_out0_V_TDATA;
  wire StreamingFIFO_rtl_6_out0_V_TREADY;
  wire StreamingFIFO_rtl_6_out0_V_TVALID;
  wire [39:0]StreamingFIFO_rtl_7_out0_V_TDATA;
  wire StreamingFIFO_rtl_7_out0_V_TREADY;
  wire StreamingFIFO_rtl_7_out0_V_TVALID;
  wire [327:0]StreamingFIFO_rtl_8_out0_V_TDATA;
  wire StreamingFIFO_rtl_8_out0_V_TREADY;
  wire StreamingFIFO_rtl_8_out0_V_TVALID;
  wire [55:0]StreamingFIFO_rtl_9_out0_V_TDATA;
  wire StreamingFIFO_rtl_9_out0_V_TREADY;
  wire StreamingFIFO_rtl_9_out0_V_TVALID;
  wire [23:0]Thresholding_rtl_0_out0_V_TDATA;
  wire Thresholding_rtl_0_out0_V_TREADY;
  wire Thresholding_rtl_0_out0_V_TVALID;
  wire ap_clk_0_1;
  wire ap_rst_n_0_1;
  wire [23:0]in0_V_0_1_TDATA;
  wire in0_V_0_1_TREADY;
  wire in0_V_0_1_TVALID;

  assign StreamingFIFO_rtl_22_out0_V_TREADY = m_axis_0_tready;
  assign ap_clk_0_1 = ap_clk;
  assign ap_rst_n_0_1 = ap_rst_n;
  assign in0_V_0_1_TDATA = s_axis_0_tdata[23:0];
  assign in0_V_0_1_TVALID = s_axis_0_tvalid;
  assign m_axis_0_tdata[7:0] = StreamingFIFO_rtl_22_out0_V_TDATA;
  assign m_axis_0_tvalid = StreamingFIFO_rtl_22_out0_V_TVALID;
  assign s_axis_0_tready = in0_V_0_1_TREADY;
  finn_design_ConvolutionInputGenerator_rtl_0_0 ConvolutionInputGenerator_rtl_0
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_2_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_2_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_2_out0_V_TVALID),
        .out0_V_TDATA(ConvolutionInputGenerator_rtl_0_out0_V_TDATA),
        .out0_V_TREADY(ConvolutionInputGenerator_rtl_0_out0_V_TREADY),
        .out0_V_TVALID(ConvolutionInputGenerator_rtl_0_out0_V_TVALID));
  finn_design_ConvolutionInputGenerator_rtl_1_0 ConvolutionInputGenerator_rtl_1
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_4_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_4_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_4_out0_V_TVALID),
        .out0_V_TDATA(ConvolutionInputGenerator_rtl_1_out0_V_TDATA),
        .out0_V_TREADY(ConvolutionInputGenerator_rtl_1_out0_V_TREADY),
        .out0_V_TVALID(ConvolutionInputGenerator_rtl_1_out0_V_TVALID));
  finn_design_ConvolutionInputGenerator_rtl_2_0 ConvolutionInputGenerator_rtl_2
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_7_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_7_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_7_out0_V_TVALID),
        .out0_V_TDATA(ConvolutionInputGenerator_rtl_2_out0_V_TDATA),
        .out0_V_TREADY(ConvolutionInputGenerator_rtl_2_out0_V_TREADY),
        .out0_V_TVALID(ConvolutionInputGenerator_rtl_2_out0_V_TVALID));
  finn_design_ConvolutionInputGenerator_rtl_3_0 ConvolutionInputGenerator_rtl_3
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_11_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_11_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_11_out0_V_TVALID),
        .out0_V_TDATA(ConvolutionInputGenerator_rtl_3_out0_V_TDATA),
        .out0_V_TREADY(ConvolutionInputGenerator_rtl_3_out0_V_TREADY),
        .out0_V_TVALID(ConvolutionInputGenerator_rtl_3_out0_V_TVALID));
  finn_design_ConvolutionInputGenerator_rtl_4_0 ConvolutionInputGenerator_rtl_4
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_15_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_15_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_15_out0_V_TVALID),
        .out0_V_TDATA(ConvolutionInputGenerator_rtl_4_out0_V_TDATA),
        .out0_V_TREADY(ConvolutionInputGenerator_rtl_4_out0_V_TREADY),
        .out0_V_TVALID(ConvolutionInputGenerator_rtl_4_out0_V_TVALID));
  finn_design_FMPadding_rtl_0_0 FMPadding_rtl_0
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_1_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_1_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_1_out0_V_TVALID),
        .out0_V_TDATA(FMPadding_rtl_0_out0_V_TDATA),
        .out0_V_TREADY(FMPadding_rtl_0_out0_V_TREADY),
        .out0_V_TVALID(FMPadding_rtl_0_out0_V_TVALID),
        .s_axilite_ARADDR({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_ARVALID(1'b0),
        .s_axilite_AWADDR({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_AWVALID(1'b0),
        .s_axilite_BREADY(1'b0),
        .s_axilite_RREADY(1'b0),
        .s_axilite_WDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_WSTRB({1'b1,1'b1,1'b1,1'b1}),
        .s_axilite_WVALID(1'b0));
  finn_design_FMPadding_rtl_1_0 FMPadding_rtl_1
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_6_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_6_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_6_out0_V_TVALID),
        .out0_V_TDATA(FMPadding_rtl_1_out0_V_TDATA),
        .out0_V_TREADY(FMPadding_rtl_1_out0_V_TREADY),
        .out0_V_TVALID(FMPadding_rtl_1_out0_V_TVALID),
        .s_axilite_ARADDR({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_ARVALID(1'b0),
        .s_axilite_AWADDR({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_AWVALID(1'b0),
        .s_axilite_BREADY(1'b0),
        .s_axilite_RREADY(1'b0),
        .s_axilite_WDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_WSTRB({1'b1,1'b1,1'b1,1'b1}),
        .s_axilite_WVALID(1'b0));
  finn_design_FMPadding_rtl_2_0 FMPadding_rtl_2
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_13_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_13_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_13_out0_V_TVALID),
        .out0_V_TDATA(FMPadding_rtl_2_out0_V_TDATA),
        .out0_V_TREADY(FMPadding_rtl_2_out0_V_TREADY),
        .out0_V_TVALID(FMPadding_rtl_2_out0_V_TVALID),
        .s_axilite_ARADDR({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_ARVALID(1'b0),
        .s_axilite_AWADDR({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_AWVALID(1'b0),
        .s_axilite_BREADY(1'b0),
        .s_axilite_RREADY(1'b0),
        .s_axilite_WDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_WSTRB({1'b1,1'b1,1'b1,1'b1}),
        .s_axilite_WVALID(1'b0));
  finn_design_LabelSelect_hls_0_0 LabelSelect_hls_0
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_21_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_21_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_21_out0_V_TVALID),
        .out0_V_TDATA(LabelSelect_hls_0_out0_V_TDATA),
        .out0_V_TREADY(LabelSelect_hls_0_out0_V_TREADY),
        .out0_V_TVALID(LabelSelect_hls_0_out0_V_TVALID));
  MVAU_hls_0_imp_7OH4JA MVAU_hls_0
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_tdata(StreamingFIFO_rtl_3_out0_V_TDATA),
        .in0_V_tready(StreamingFIFO_rtl_3_out0_V_TREADY),
        .in0_V_tvalid(StreamingFIFO_rtl_3_out0_V_TVALID),
        .out0_V_tdata(MVAU_hls_0_out0_V_TDATA),
        .out0_V_tready(MVAU_hls_0_out0_V_TREADY),
        .out0_V_tvalid(MVAU_hls_0_out0_V_TVALID));
  MVAU_hls_1_imp_ZIW0NT MVAU_hls_1
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_tdata(StreamingFIFO_rtl_9_out0_V_TDATA),
        .in0_V_tready(StreamingFIFO_rtl_9_out0_V_TREADY),
        .in0_V_tvalid(StreamingFIFO_rtl_9_out0_V_TVALID),
        .out0_V_tdata(MVAU_hls_1_out0_V_TDATA),
        .out0_V_tready(MVAU_hls_1_out0_V_TREADY),
        .out0_V_tvalid(MVAU_hls_1_out0_V_TVALID));
  MVAU_hls_2_imp_1WP2WTL MVAU_hls_2
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_tdata(StreamingFIFO_rtl_17_out0_V_TDATA),
        .in0_V_tready(StreamingFIFO_rtl_17_out0_V_TREADY),
        .in0_V_tvalid(StreamingFIFO_rtl_17_out0_V_TVALID),
        .out0_V_tdata(MVAU_hls_2_out0_V_TDATA),
        .out0_V_tready(MVAU_hls_2_out0_V_TREADY),
        .out0_V_tvalid(MVAU_hls_2_out0_V_TVALID));
  MVAU_hls_3_imp_U0RWZQ MVAU_hls_3
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_tdata(StreamingFIFO_rtl_18_out0_V_TDATA),
        .in0_V_tready(StreamingFIFO_rtl_18_out0_V_TREADY),
        .in0_V_tvalid(StreamingFIFO_rtl_18_out0_V_TVALID),
        .out0_V_tdata(MVAU_hls_3_out0_V_TDATA),
        .out0_V_tready(MVAU_hls_3_out0_V_TREADY),
        .out0_V_tvalid(MVAU_hls_3_out0_V_TVALID));
  MVAU_hls_4_imp_6UFUIX MVAU_hls_4
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_tdata(StreamingFIFO_rtl_20_out0_V_TDATA),
        .in0_V_tready(StreamingFIFO_rtl_20_out0_V_TREADY),
        .in0_V_tvalid(StreamingFIFO_rtl_20_out0_V_TVALID),
        .out0_V_tdata(MVAU_hls_4_out0_V_TDATA),
        .out0_V_tready(MVAU_hls_4_out0_V_TREADY),
        .out0_V_tvalid(MVAU_hls_4_out0_V_TVALID));
  finn_design_Pool_hls_0_0 Pool_hls_0
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_5_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_5_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_5_out0_V_TVALID),
        .out0_V_TDATA(Pool_hls_0_out0_V_TDATA),
        .out0_V_TREADY(Pool_hls_0_out0_V_TREADY),
        .out0_V_TVALID(Pool_hls_0_out0_V_TVALID));
  finn_design_Pool_hls_1_0 Pool_hls_1
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_12_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_12_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_12_out0_V_TVALID),
        .out0_V_TDATA(Pool_hls_1_out0_V_TDATA),
        .out0_V_TREADY(Pool_hls_1_out0_V_TREADY),
        .out0_V_TVALID(Pool_hls_1_out0_V_TVALID));
  finn_design_StreamingDataWidthConverter_hls_0_0 StreamingDataWidthConverter_hls_0
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_16_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_16_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_16_out0_V_TVALID),
        .out0_V_TDATA(StreamingDataWidthConverter_hls_0_out0_V_TDATA),
        .out0_V_TREADY(StreamingDataWidthConverter_hls_0_out0_V_TREADY),
        .out0_V_TVALID(StreamingDataWidthConverter_hls_0_out0_V_TVALID));
  finn_design_StreamingDataWidthConverter_rtl_0_0 StreamingDataWidthConverter_rtl_0
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_8_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_8_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_8_out0_V_TVALID),
        .out0_V_TDATA(StreamingDataWidthConverter_rtl_0_out0_V_TDATA),
        .out0_V_TREADY(StreamingDataWidthConverter_rtl_0_out0_V_TREADY),
        .out0_V_TVALID(StreamingDataWidthConverter_rtl_0_out0_V_TVALID));
  finn_design_StreamingDataWidthConverter_rtl_1_0 StreamingDataWidthConverter_rtl_1
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_10_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_10_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_10_out0_V_TVALID),
        .out0_V_TDATA(StreamingDataWidthConverter_rtl_1_out0_V_TDATA),
        .out0_V_TREADY(StreamingDataWidthConverter_rtl_1_out0_V_TREADY),
        .out0_V_TVALID(StreamingDataWidthConverter_rtl_1_out0_V_TVALID));
  finn_design_StreamingDataWidthConverter_rtl_2_0 StreamingDataWidthConverter_rtl_2
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_14_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_14_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_14_out0_V_TVALID),
        .out0_V_TDATA(StreamingDataWidthConverter_rtl_2_out0_V_TDATA),
        .out0_V_TREADY(StreamingDataWidthConverter_rtl_2_out0_V_TREADY),
        .out0_V_TVALID(StreamingDataWidthConverter_rtl_2_out0_V_TVALID));
  finn_design_StreamingDataWidthConverter_rtl_3_0 StreamingDataWidthConverter_rtl_3
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_19_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_19_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_19_out0_V_TVALID),
        .out0_V_TDATA(StreamingDataWidthConverter_rtl_3_out0_V_TDATA),
        .out0_V_TREADY(StreamingDataWidthConverter_rtl_3_out0_V_TREADY),
        .out0_V_TVALID(StreamingDataWidthConverter_rtl_3_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_0_0 StreamingFIFO_rtl_0
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(in0_V_0_1_TDATA),
        .in0_V_TREADY(in0_V_0_1_TREADY),
        .in0_V_TVALID(in0_V_0_1_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_0_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_0_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_0_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_1_0 StreamingFIFO_rtl_1
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(Thresholding_rtl_0_out0_V_TDATA),
        .in0_V_TREADY(Thresholding_rtl_0_out0_V_TREADY),
        .in0_V_TVALID(Thresholding_rtl_0_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_1_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_1_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_1_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_10_0 StreamingFIFO_rtl_10
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(MVAU_hls_1_out0_V_TDATA),
        .in0_V_TREADY(MVAU_hls_1_out0_V_TREADY),
        .in0_V_TVALID(MVAU_hls_1_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_10_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_10_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_10_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_11_0 StreamingFIFO_rtl_11
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingDataWidthConverter_rtl_1_out0_V_TDATA),
        .in0_V_TREADY(StreamingDataWidthConverter_rtl_1_out0_V_TREADY),
        .in0_V_TVALID(StreamingDataWidthConverter_rtl_1_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_11_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_11_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_11_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_12_0 StreamingFIFO_rtl_12
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(ConvolutionInputGenerator_rtl_3_out0_V_TDATA),
        .in0_V_TREADY(ConvolutionInputGenerator_rtl_3_out0_V_TREADY),
        .in0_V_TVALID(ConvolutionInputGenerator_rtl_3_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_12_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_12_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_12_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_13_0 StreamingFIFO_rtl_13
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(Pool_hls_1_out0_V_TDATA),
        .in0_V_TREADY(Pool_hls_1_out0_V_TREADY),
        .in0_V_TVALID(Pool_hls_1_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_13_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_13_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_13_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_14_0 StreamingFIFO_rtl_14
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(FMPadding_rtl_2_out0_V_TDATA),
        .in0_V_TREADY(FMPadding_rtl_2_out0_V_TREADY),
        .in0_V_TVALID(FMPadding_rtl_2_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_14_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_14_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_14_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_15_0 StreamingFIFO_rtl_15
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingDataWidthConverter_rtl_2_out0_V_TDATA),
        .in0_V_TREADY(StreamingDataWidthConverter_rtl_2_out0_V_TREADY),
        .in0_V_TVALID(StreamingDataWidthConverter_rtl_2_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_15_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_15_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_15_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_16_0 StreamingFIFO_rtl_16
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(ConvolutionInputGenerator_rtl_4_out0_V_TDATA),
        .in0_V_TREADY(ConvolutionInputGenerator_rtl_4_out0_V_TREADY),
        .in0_V_TVALID(ConvolutionInputGenerator_rtl_4_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_16_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_16_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_16_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_17_0 StreamingFIFO_rtl_17
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingDataWidthConverter_hls_0_out0_V_TDATA),
        .in0_V_TREADY(StreamingDataWidthConverter_hls_0_out0_V_TREADY),
        .in0_V_TVALID(StreamingDataWidthConverter_hls_0_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_17_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_17_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_17_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_18_0 StreamingFIFO_rtl_18
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(MVAU_hls_2_out0_V_TDATA),
        .in0_V_TREADY(MVAU_hls_2_out0_V_TREADY),
        .in0_V_TVALID(MVAU_hls_2_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_18_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_18_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_18_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_19_0 StreamingFIFO_rtl_19
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(MVAU_hls_3_out0_V_TDATA),
        .in0_V_TREADY(MVAU_hls_3_out0_V_TREADY),
        .in0_V_TVALID(MVAU_hls_3_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_19_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_19_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_19_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_2_0 StreamingFIFO_rtl_2
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(FMPadding_rtl_0_out0_V_TDATA),
        .in0_V_TREADY(FMPadding_rtl_0_out0_V_TREADY),
        .in0_V_TVALID(FMPadding_rtl_0_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_2_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_2_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_2_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_20_0 StreamingFIFO_rtl_20
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingDataWidthConverter_rtl_3_out0_V_TDATA),
        .in0_V_TREADY(StreamingDataWidthConverter_rtl_3_out0_V_TREADY),
        .in0_V_TVALID(StreamingDataWidthConverter_rtl_3_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_20_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_20_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_20_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_21_0 StreamingFIFO_rtl_21
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(MVAU_hls_4_out0_V_TDATA),
        .in0_V_TREADY(MVAU_hls_4_out0_V_TREADY),
        .in0_V_TVALID(MVAU_hls_4_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_21_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_21_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_21_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_22_0 StreamingFIFO_rtl_22
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(LabelSelect_hls_0_out0_V_TDATA),
        .in0_V_TREADY(LabelSelect_hls_0_out0_V_TREADY),
        .in0_V_TVALID(LabelSelect_hls_0_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_22_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_22_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_22_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_3_0 StreamingFIFO_rtl_3
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(ConvolutionInputGenerator_rtl_0_out0_V_TDATA),
        .in0_V_TREADY(ConvolutionInputGenerator_rtl_0_out0_V_TREADY),
        .in0_V_TVALID(ConvolutionInputGenerator_rtl_0_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_3_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_3_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_3_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_4_0 StreamingFIFO_rtl_4
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(MVAU_hls_0_out0_V_TDATA),
        .in0_V_TREADY(MVAU_hls_0_out0_V_TREADY),
        .in0_V_TVALID(MVAU_hls_0_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_4_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_4_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_4_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_5_0 StreamingFIFO_rtl_5
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(ConvolutionInputGenerator_rtl_1_out0_V_TDATA),
        .in0_V_TREADY(ConvolutionInputGenerator_rtl_1_out0_V_TREADY),
        .in0_V_TVALID(ConvolutionInputGenerator_rtl_1_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_5_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_5_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_5_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_6_0 StreamingFIFO_rtl_6
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(Pool_hls_0_out0_V_TDATA),
        .in0_V_TREADY(Pool_hls_0_out0_V_TREADY),
        .in0_V_TVALID(Pool_hls_0_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_6_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_6_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_6_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_7_0 StreamingFIFO_rtl_7
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(FMPadding_rtl_1_out0_V_TDATA),
        .in0_V_TREADY(FMPadding_rtl_1_out0_V_TREADY),
        .in0_V_TVALID(FMPadding_rtl_1_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_7_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_7_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_7_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_8_0 StreamingFIFO_rtl_8
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(ConvolutionInputGenerator_rtl_2_out0_V_TDATA),
        .in0_V_TREADY(ConvolutionInputGenerator_rtl_2_out0_V_TREADY),
        .in0_V_TVALID(ConvolutionInputGenerator_rtl_2_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_8_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_8_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_8_out0_V_TVALID));
  finn_design_StreamingFIFO_rtl_9_0 StreamingFIFO_rtl_9
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingDataWidthConverter_rtl_0_out0_V_TDATA),
        .in0_V_TREADY(StreamingDataWidthConverter_rtl_0_out0_V_TREADY),
        .in0_V_TVALID(StreamingDataWidthConverter_rtl_0_out0_V_TVALID),
        .out0_V_TDATA(StreamingFIFO_rtl_9_out0_V_TDATA),
        .out0_V_TREADY(StreamingFIFO_rtl_9_out0_V_TREADY),
        .out0_V_TVALID(StreamingFIFO_rtl_9_out0_V_TVALID));
  finn_design_Thresholding_rtl_0_0 Thresholding_rtl_0
       (.ap_clk(ap_clk_0_1),
        .ap_rst_n(ap_rst_n_0_1),
        .in0_V_TDATA(StreamingFIFO_rtl_0_out0_V_TDATA),
        .in0_V_TREADY(StreamingFIFO_rtl_0_out0_V_TREADY),
        .in0_V_TVALID(StreamingFIFO_rtl_0_out0_V_TVALID),
        .in1_V_TDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .in1_V_TVALID(1'b0),
        .out0_V_TDATA(Thresholding_rtl_0_out0_V_TDATA),
        .out0_V_TREADY(Thresholding_rtl_0_out0_V_TREADY),
        .out0_V_TVALID(Thresholding_rtl_0_out0_V_TVALID),
        .s_axilite_ARADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_ARVALID(1'b0),
        .s_axilite_AWADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_AWVALID(1'b0),
        .s_axilite_BREADY(1'b0),
        .s_axilite_RREADY(1'b0),
        .s_axilite_WDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axilite_WSTRB({1'b1,1'b1,1'b1,1'b1}),
        .s_axilite_WVALID(1'b0));
endmodule
