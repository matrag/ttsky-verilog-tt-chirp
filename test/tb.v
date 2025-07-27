`default_nettype none
`timescale 1ns / 1ps

module tb;

  // Dump VCD for waveform viewing
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Inputs to DUT
  reg rst_n = 0;
  reg ena   = 1;
  reg [7:0] ui_in  = 8'b0;
  reg [7:0] uio_in = 8'b0;

  // Outputs from DUT
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // DUT instantiation
  tt_um_matrag_chirp_top uut (
      .ui_in    (ui_in),
      .uo_out   (uo_out),
      .uio_in   (uio_in),
      .uio_out  (uio_out),
      .uio_oe   (uio_oe),
      .ena      (ena),
      .clk      (clk),
      .rst_n    (rst_n)
  );

endmodule
