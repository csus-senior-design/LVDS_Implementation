`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Team Honey Badger
// Engineer: Sean Kennedy
// 
// Create Date:    18:03:03 03/09/2015 
// Design Name: 
// Module Name:    LVDS_Output 
// Project Name:   LVDS_Implementation_v2
// Target Devices: Atyls - Spartan6
// Tool versions:  ISE Project Navigator 
// Description: 
//				LVDS_Ouput module will take RGB888 input from a frame buffer and output
//	to a LVDS LCD.
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module LVDS_Output( 
			input clk_in,
			input [7:0] red,
			input [7:0] blue,
			input [7:0] green,
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

wire clk_bit; //fast clock, 100MHz x 5 = 500 Mhz


//Bit Slot
// This will determine what bit column is being sent in one pixel frame
reg [2:0] bitSlot;

//Control Signals
reg hsync;
reg vsync;
reg dataenable;

//display parameters
parameter htotal = 1440;
parameter hfront = 0;		//Horizontal Front Porch
parameter hactive = 1280;	//Horizontal active region
reg [10:0] hcurrent = 0; //bit width is calculated 2^htotal

parameter vtotal = 823;
parameter vfront = 0;		//Vertical Front Porch
parameter vactive = 800;	//Vertical active region
reg [9:0] vcurrent = 0;		//bit width is calculated 2^vtotal 

//the signals hold data to be sent to the lcd on each slot
reg [6:0] Rx0_data;
reg [6:0] Rx1_data;
reg [6:0] Rx2_data;
reg [6:0] Rx3_data;
parameter [6:0] CK1_data = 7'b1100011;

//internal LVDS signal inputs
reg CK1in;
reg Rxin0;
reg Rxin1;
reg Rxin2;
reg Rxin3;

//Digital Clock Manager
//	Spartan-6 Libaries Guide for HDL Designs pg. 91
DCM_SP #(
	.CLKFX_DIVIDE(1),		//clock divide
	.CLKFX_MULTIPLY(5)	//clock multiply
)
DCM_SP_inst (
	.CLKFX(clk_bit),				//clock output
	.CLKIN(clk_in),				//clock input
	.RST(1'b0)					//reset, active high
);

//Differential Signaling Output Buffer 
//		Spartan-6 Libaries Guide for HDL Designs pg. 198
OBUFDS #(
	.IOSTANDARD("LVDS_33") //specify the output IO standard
)
OBUFDS_CK1in_inst(
	.O(CK1in_p),			//Diff_p output
	.OB(CK1in_n),		//Diff_n output
	.I(CK1in)			//Buffer input
);

OBUFDS #(
	.IOSTANDARD("LVDS_33") //specify the output IO standard
)
OBUFDS_Rxin0_inst(
	.O(Rxin0_p),			//Diff_p output
	.OB(Rxin0_n),		//Diff_n output
	.I(Rxin0)			//Buffer input
);

OBUFDS #(
	.IOSTANDARD("LVDS_33") //specify the output IO standard
)
OBUFDS_Rxin1_inst(
	.O(Rxin1_p),			//Diff_p output
	.OB(Rxin1_n),		//Diff_n output
	.I(Rxin1)			//Buffer input
);

OBUFDS #(
	.IOSTANDARD("LVDS_33") //specify the output IO standard
)
OBUFDS_Rxin2_inst(
	.O(Rxin2_p),			//Diff_p output
	.OB(Rxin2_n),		//Diff_n output
	.I(Rxin2)			//Buffer input
);

OBUFDS #(
	.IOSTANDARD("LVDS_33") //specify the output IO standard
)
OBUFDS_Rxin3_inst(
	.O(Rxin3_p),			//Diff_p output
	.OB(Rxin3_n),		//Diff_n output
	.I(Rxin3)			//Buffer input
);

//Initial Values
initial 
	begin
	//This is for the initial breadboard needs to change later
		
		hsync = 1'b0;
		vsync = 1'b0;
		dataenable = 1'b0;
		bitSlot = 3'b000;
		
		Rx0_data = 7'b0000000;
		Rx1_data = 7'b0000000;
		Rx2_data	= 7'b0000000;
		Rx3_data = 7'b0000000;
		
	end

always @ (*)
	begin
	
			//data enbalbe: should be high when the data is valid for display
			dataenable <= vsync & hsync;
		
			//Rx3_data { Red6, Red7, Green6, Green7, Blue6, Blue7, x}			
			Rx3_data <= { red[6], red[7], green[6], green[7], blue[6], blue[7], 1'b1};
		
			//Rx2_data {Blue2, Blue3, Blue4, Blue5, hsync, vsync, dataenable}		
			Rx2_data <= { blue[2], blue[3], blue[4], blue[5], hsync, vsync, dataenable};
		
			//Rx1_data {Green1, Green2, Green3, Green4, Green5, Blue0, Blue1}		
			Rx1_data <= { green[1], green[2], green[3], green[4], green[5], blue[0], blue[1]};
		
			//Rx0_data { Red0, Red1, Red2, Red3, Red4, Red5, Green0}		  
			Rx0_data <= { red[0], red[1], red[2], red[3], red[4], red[5], green[0]};
		
			Rxin3 <= Rx3_data[bitSlot];
			Rxin2 <= Rx2_data[bitSlot];
			Rxin1 <= Rx1_data[bitSlot];
			Rxin0 <= Rx0_data[bitSlot];
			CK1in <= CK1_data[bitSlot];
		
	end
	
always @ (posedge clk_bit)
	begin
			
				if( hcurrent < hfront || (hcurrent >= (hfront+hactive)))
				begin
					hsync <= 1'b0;
				end
				else
				begin
					hsync <= 1'b1;
				end
			
				if( vcurrent < vfront || (vcurrent >= (vfront + vactive)))
				begin
					vsync <= 1'b0;
				end
				else
				begin
					vsync <= 1'b1;
				end
			
				if (bitSlot == 6)
				begin
					//The last slot, wrap around
					bitSlot <= 0;
				
					//If this is the last pixel in the line, wrap around
					if (hcurrent == htotal)
					begin
						hcurrent <= 0;
						/*
						if (blue == 8'b00000000) begin
							blue <= 8'b11110000;
						
						
							if (green == 8'b00000000) 	begin							
								green <= 8'b11110000;
							
								if (red == 8'b00000000) begin
									red <= 8'b11110000;
								end
								else
									begin
									red <= red - 8;
									end
								end
							else 
								begin
								green <= green - 8;
								end
							end
						else 
							begin
							blue <= blue - 8;
							end
				*/
						if( vcurrent == vtotal)
						begin
							vcurrent <=0;
							/*
							// new screen, reset the colors
							red <= 11110000;
							green <= 11110000;
							blue <= 11110000;
							*/
						end
						else
						begin
							vcurrent <= vcurrent + 1;
						end
					end
					else
					begin
						hcurrent <= hcurrent + 1;
					end
				end
				else
				begin
					bitSlot <= bitSlot + 1;
				end
			
	end
endmodule
