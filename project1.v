// Part 2 skeleton

module project1#(parameter clkfreq = 50000000)
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		KEY,							// On Board Keys
		PS2_CLK,
		PS2_DAT,
		HEX0,
		HEX1,
		HEX2,
		/*HEX3,
		HEX4,
		HEX5,*/
		HEX6,
		HEX7,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;
	inout PS2_CLK, PS2_DAT;
	output		[6:0]	HEX0;
	output		[6:0]	HEX1;
	output		[6:0]	HEX2;
	/*output		[6:0]	HEX3;
	output		[6:0]	HEX4;
	output		[6:0]	HEX5;*/
	output		[6:0]	HEX6;
	output		[6:0]	HEX7;
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "MAZE.mif";
		
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	
	wire left, up, right, down;
	wire [6:0] eh0, eh1, eh2;
	
	PS2_Demo k0(
	.clk(CLOCK_50),
	.key(KEY[0]),
	.ps2clk(PS2_CLK),
	.ps2dat(PS2_DAT),
	.hex0(HEX6),
	.hex1(HEX7),
	/*.hex2(HEX2),
	.hex3(HEX3),
	.hex4(HEX4),
	.hex5(HEX5),
	.hex6(HEX6),
	.hex7(HEX7),*/
	.l(left),
	.u(up),
	.r(right),
	.d(down)
	);
	
	project #(.clkfreq(clkfreq)) p0(
	.clk(CLOCK_50), 
	.reset(~KEY[0]),
	.left(left),
	.up(up),
	.right(right),
	.down(down),
	.ox(x),
	.oy(y),
	.oc(colour),
	.oPlot(writeEn)
	);
	
	hexdecoder #(.CLOCK_FREQUENCY(clkfreq))(
	.clk(CLOCK_50),
	.reset(KEY[0]),
   .hex0(HEX0),
	.hex1(HEX1),
   .hex2(HEX2)
	);
	
endmodule
