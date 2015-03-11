`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:28:34 03/11/2015
// Design Name:   LVDS_Controller
// Module Name:   C:/Verilog/LVDS_Implementation_v2/LVDS_Controller_test.v
// Project Name:  LVDS_Implementation_v2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: LVDS_Controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module LVDS_Controller_test;

	// Inputs
	reg clk_in;
	reg red_switch;
	reg blue_switch;
	reg green_switch;
	reg reset;

	// Outputs
	wire CK1in_p;
	wire CK1in_n;
	wire Rxin0_n;
	wire Rxin0_p;
	wire Rxin1_n;
	wire Rxin1_p;
	wire Rxin2_n;
	wire Rxin2_p;
	wire Rxin3_n;
	wire Rxin3_p;

	// Instantiate the Unit Under Test (UUT)
	LVDS_Controller uut (
		.clk_in(clk_in), 
		.red_switch(red_switch), 
		.blue_switch(blue_switch), 
		.green_switch(green_switch), 
		.reset(reset), 
		.CK1in_p(CK1in_p), 
		.CK1in_n(CK1in_n), 
		.Rxin0_n(Rxin0_n), 
		.Rxin0_p(Rxin0_p), 
		.Rxin1_n(Rxin1_n), 
		.Rxin1_p(Rxin1_p), 
		.Rxin2_n(Rxin2_n), 
		.Rxin2_p(Rxin2_p), 
		.Rxin3_n(Rxin3_n), 
		.Rxin3_p(Rxin3_p)
	);

	initial begin
		// Initialize Inputs
		clk_in = 0;
		red_switch = 0;
		blue_switch = 0;
		green_switch = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#10;
       red_switch = 1;
		// Add stimulus here

	end
      always begin
			#5 clk_in = ~clk_in;
		end
endmodule

