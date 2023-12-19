//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
//Date        : Sat Dec 16 23:55:23 2023
//Host        : DESKTOP-S7KVEL9 running 64-bit major release  (build 9200)
//Command     : generate_target swLEDcounter_wrapper.bd
//Design      : swLEDcounter_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module swLEDcounter_wrapper
   (dip_switches_16bits_tri_i,
    led_16bits_tri_o,
    reset,
    seven_seg_led_an_tri_o,
    seven_seg_led_disp_tri_o,
    sys_clock);
  input [15:0]dip_switches_16bits_tri_i;
  output [15:0]led_16bits_tri_o;
  input reset;
  output [3:0]seven_seg_led_an_tri_o;
  output [7:0]seven_seg_led_disp_tri_o;
  input sys_clock;

  wire [15:0]dip_switches_16bits_tri_i;
  wire [15:0]led_16bits_tri_o;
  wire reset;
  wire [3:0]seven_seg_led_an_tri_o;
  wire [7:0]seven_seg_led_disp_tri_o;
  wire sys_clock;

  swLEDcounter swLEDcounter_i
       (.dip_switches_16bits_tri_i(dip_switches_16bits_tri_i),
        .led_16bits_tri_o(led_16bits_tri_o),
        .reset(reset),
        .seven_seg_led_an_tri_o(seven_seg_led_an_tri_o),
        .seven_seg_led_disp_tri_o(seven_seg_led_disp_tri_o),
        .sys_clock(sys_clock));
endmodule
