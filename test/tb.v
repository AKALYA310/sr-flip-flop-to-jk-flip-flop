`default_nettype none
`timescale 1ns / 1ps

module tb ();

  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);

    // simulation run time
    #200 $finish;
  end

  // Inputs
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;

  // Outputs
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // DUT (Device Under Test) -> JK Flip-Flop module
  tt_um_jk_flipflop user_project (

`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),
      .uo_out (uo_out),
      .uio_in (uio_in),
      .uio_out(uio_out),
      .uio_oe (uio_oe),
      .ena    (ena),
      .clk    (clk),
      .rst_n  (rst_n)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Test stimulus
  initial begin
    // init
    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;

    // reset release
    #15 rst_n = 1;

    // Test cases for JK flip-flop
    #10 ui_in = 8'b00000000; // J=0 K=0 (hold)
    #20 ui_in = 8'b00000010; // J=1 K=0 (set)
    #20 ui_in = 8'b00000001; // J=0 K=1 (reset)
    #20 ui_in = 8'b00000011; // J=1 K=1 (toggle)
    #20 ui_in = 8'b00000011; // toggle again

    #50 $finish;
  end

endmodule
