
module PS2_Demo (
	// Inputs
	clk,
	key,

	// Bidirectionals
	ps2clk,
	ps2dat,
	
	// Outputs
	hex0,
	hex1,
	/*hex2,
	hex3,
	hex4,
	hex5,
	hex6,
	hex7,*/
	l,
	u,
	r,
	d
	);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// Inputs
input				clk;
input		   	key;

// Bidirectionals
inout				ps2clk;
inout				ps2dat;

// Outputs
output		[6:0]	hex0;
output		[6:0]	hex1;
/*output		[6:0]	hex2;
output		[6:0]	hex3;
output		[6:0]	hex4;
output		[6:0]	hex5;
output		[6:0]	hex6;
output		[6:0]	hex7;*/


/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire		[7:0]	ps2_key_data;
wire				ps2_key_pressed;

// Internal Registers
reg			[7:0]	last_data_received;

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/
localparam LEFT = 8'h6B,
			  UP = 8'h75,
			  RIGHT = 8'h74,
			  DOWN = 8'h72,
			  BREAK = 8'hF0;

output reg l, u, r, d; 
reg tl, tu, tr, td, eh, w8, clean;
reg [3:0] current, next;


localparam  EH = 4'd0,
				CLEANUP = 4'd10,
				CLEANING = 4'd11,
				//CLEANUPL = 4'd11,
				//CLEANUPU = 4'd12,
				//CLEANUPR = 4'd13,
				//CLEANUPD = 4'd14,
				WAIT = 4'd9,
				//WAIT_LEFT = 4'd1,
				//WAIT_UP = 4'd2,
				//WAIT_RIGHT = 4'd3,
				//WAIT_DOWN = 4'd4,
				SLEFT = 4'd5,
				SUP = 4'd6,
				SRIGHT = 4'd7,
				SDOWN = 4'd8;

/*assign LEDR[0] = l;
assign LEDR[1] = u;
assign LEDR[2] = r;
assign LEDR[3] = d;
assign LEDR[9] = eh;*/

	always @(*)
		begin
	
		case (current)
			EH: next = ps2_key_pressed ? WAIT : EH;
			WAIT: begin
				if (last_data_received == LEFT) begin
					next = SLEFT;
				end
				else if (last_data_received == UP) begin
					next = SUP;
				end
				else if (last_data_received == RIGHT) begin
					next = SRIGHT;
				end
				else if (last_data_received == DOWN) begin
					next = SDOWN;
				end
				else begin
					next = WAIT;
				end
			end
			SLEFT: begin
				if (last_data_received == BREAK) begin
					next = CLEANUP;
				end
				else begin
					next = SLEFT;
				end
			end
			SUP: begin
				if (last_data_received == BREAK) begin
					next = CLEANUP;
				end
				else begin
					next = SUP;
				end
			end
			SRIGHT: begin
				if (last_data_received == BREAK) begin
					next = CLEANUP;
				end
				else begin
					next = SRIGHT;
				end
			end
			SDOWN: begin
				if (last_data_received == BREAK) begin
					next = CLEANUP;
				end
				else begin
				 next = SDOWN;
				end
			end
			CLEANUP: begin
				if (last_data_received == LEFT) begin
					next = CLEANING;
				end
				else if (last_data_received == UP) begin
					next = CLEANING;
				end
				else if (last_data_received == RIGHT) begin
					next = CLEANING;
				end
				else if (last_data_received == DOWN) begin
					next = CLEANING;
				end
				else begin
					next = CLEANUP;
				end
			end
			/*CLEANUPL: next = ps2_key_pressed ? CLEANUPL : EH;
			CLEANUPU: next = ps2_key_pressed ? CLEANUPU : EH;
			CLEANUPR: next = ps2_key_pressed ? CLEANUPR : EH;
			CLEANUPD: next = ps2_key_pressed ? CLEANUPD : EH;*/
			CLEANING: next = ps2_key_pressed ? CLEANING : EH;
		default: next = EH;
		endcase
		
	end
	
	always @(posedge clk)
		begin
			l = 0;
			u = 0;
			r = 0;
			d = 0;
			eh = 0;
			w8 = 0;
			clean = 0;
			case (current)
				EH: eh = 1;
				WAIT: begin
					w8 = 1;
				end
				SLEFT: l = 1;
				SUP: u = 1;
				SRIGHT: r = 1;
				SDOWN: d = 1;
				CLEANUP: begin
					clean = 1;
					/*if (tl) begin
						l = 1;
					end
					else if (tu) begin
						u = 1;
					end
					else if (tr) begin
						r = 1;
					end
					else if (td) begin
						d = 1;
					end*/
				end
				/*CLEANUPL: tl = 1;
				CLEANUPU: tu = 1;
				CLEANUPR: tr = 1;
				CLEANUPD: td = 1;*/
				/*CLEANING: begin
					tl = 0;
					tu = 0;
					tr = 0;
					td = 0;
				end*/
			endcase
		end
				

	always @(posedge clk)
		begin
		
			if (key == 1'b0) begin
				last_data_received <= 8'h00;
			end
			else if (ps2_key_pressed == 1'b1) begin
				last_data_received <= ps2_key_data;
			end
		
			/*if (reset) begin
				current <= EH;
			end
			else begin
				current <= next;
			end */
			current <= next;
		end

/*always @(posedge ps2_key_pressed)
begin
    if (key == 1'b0)
        last_data_received = 8'h00;
    else if (ps2_key_pressed == 1'b1)
        last_data_received = ps2_key_data;
    
   // if (break == 0 ) begin
		
		if (last_data_received == UP || last_data_received == DOWN || last_data_received == LEFT || last_data_received == RIGHT) begin
		
			l = (last_data_received == LEFT);
			u = (last_data_received == UP);
			r = (last_data_received == RIGHT);
			d = (last_data_received == DOWN); 
			
		end
    
    //end
    
    
    break = 1;
	 
	 if (last_data_received == BREAK) begin
		break = 0;
	 end
    
    if (last_data_received == BREAK) begin
	   l = 0;
		u = 0;
		r = 0;
		d = 0;
    end
    
end*/

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
/*assign hex2 = 7'h7F;
assign hex3 = 7'h7F;
assign hex4 = 7'h7F;
assign hex5 = 7'h7F;
assign hex6 = 7'h7F;
assign hex7 = 7'h7F;*/

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

PS2_Controller PS2 (
	// Inputs
	.CLOCK_50				(clk),
	.reset				(~key),

	// Bidirectionals
	.PS2_CLK			(ps2clk),
 	.PS2_DAT			(ps2dat),

	// Outputs
	.received_data		(ps2_key_data),
	.received_data_en	(ps2_key_pressed)
);

Hexadecimal_To_Seven_Segment Segment0 (
	// Inputs
	.hex_number			(last_data_received[3:0]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(hex0)
);

Hexadecimal_To_Seven_Segment Segment1 (
	// Inputs
	.hex_number			(last_data_received[7:4]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(hex1)
);


endmodule
