`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Team Honey Badger
// Engineer: Sean Kennedy
// 
// Create Date:    12:00:41 03/11/2015 
// Design Name: 
// Module Name:    LVDS_Controller 
// Project Name: 	 LVDS_Implementation_v2
// Target Devices: Atyls - Spartan6
// Tool versions: ISE Project Navigator
// Description: 
//		Builds on the LVDS_Implementation project but now incorporates a top level controller module that will drive RGB values
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module LVDS_Controller(
			input clk_in,
			input red_switch,
			input blue_switch,
			input green_switch,
			input reset,
			output CK1in_p,
			output CK1in_n,
			output Rxin0_n,
			output Rxin0_p,
			output Rxin1_n,
			output Rxin1_p,
			output Rxin2_n,
			output Rxin2_p,
			output Rxin3_n,
			output Rxin3_p
    );
	
//Internal Registers	
	reg [7:0] red;
	reg [7:0] blue;
	reg [7:0] green;

//Instatiate Modules
LVDS_Output u1( 
			.clk_in(clk_in),
			.red(red),
			.blue(blue),
			.green(green),
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


//Initialize registers	
	initial begin
		red = 8'b0000_0000;
		blue = 8'b0000_0000;
		green = 8'b0000_0000;
	end
	
	always @ (posedge clk_in or posedge reset)
	begin
		if(reset) begin
			red <= 8'b0000_0000;
			blue <= 8'b0000_0000;
			green <= 8'b0000_0000;
		end
		else begin
			//checks switch levels and drives red, green, and blue independently
			if(red_switch) begin
				red <= 8'b1111_1111;
			end
			else begin
				red <= 8'b0000_0000;
			end
			
			if(blue_switch) begin
				blue <= 8'b1111_1111;
			end
			else begin
				blue <= 8'b0000_0000;
			end
			
			if(green_switch) begin
				green <= 8'b1111_1111;
			end
			else begin
				green <= 8'b0000_0000;
			end
		end
	end
endmodule
