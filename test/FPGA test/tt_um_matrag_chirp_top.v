/*
 * Copyright (c) 2024 matrag
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_matrag_chirp_top (
    input  wire [7:0] ui_in,    // Dedicated inputs - ui_in[0] UART RX
    output wire [7:0] uo_out,   // Dedicated outputs - Out 8 bit data: uo_out[7:0]
    input  wire [7:0] uio_in,   // IOs: Input path - unused
    output wire [7:0] uio_out,  // IOs: Output path - Done signal from chirp generator: uio_out[0]
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled, always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

//----------------------------------------------------------------------
//------Wires to connect Ports to design instantiation------------------
//----------------------------------------------------------------------
wire        w_i_rx     = ui_in[0];       //UART RX input line: ui_in[0] port
wire        w_o_done;
assign      uio_out[0] = w_o_done;     //Done signal from chirp generator: uio_out[0]
wire [7:0]  w_o_data;   
assign      uo_out = w_o_data;         //Out 8 bit data: uo_out[7:0]

//-------------------Design instantiation-------------------------------
chirpmod #(
    .PHASE_WIDTH        (32),
    .MAX_SF_WIDTH       (8),
    .BW_BITWIDTH        (2),
    .ADDR_WIDTH         (6),
    .DATA_WIDTH         (8),
    .DIVIDER_BITWIDTH   (7)
  ) 
  chirp_module 
  (
    .i_clk   (clk),   //!Input clock: 10 MHz
    .i_rst_n (rst_n),   //!Input reset active Low
    .i_rx    (w_i_rx),   //!Input UART rx (9600 bps)
    .o_done_n(w_o_done),   //!Output done active Low
    .o_data  (w_o_data)    //!Output bus data (8 bit)
  );

//-------------------Unused Out Ports assigned to '0'-------------------
//-----All output pins must be assigned. If not used, assign to '1'-----
assign uio_out  [7:1]   = 7'b1;
//-------------------IO Ports assigned to Output ('1')------------------
assign uio_oe   [7:0]   = 8'b1;

// List all unused inputs to prevent warnings
 wire _unused = &{ena, ui_in[7:1], uio_in[7:0], 1'b1};

endmodule