module project #(parameter clkfreq = 50000000)( // made count a wire & xnew1 and ynew1
	clk, 
	reset,
	left,
	up,
	right,
	down,
	ox,
	oy,
	oc,
	oPlot
	);
							
	input	clk, reset, left, up, right, down;
	output [7:0] ox;
	output [6:0] oy;
   output [2:0] oc;
   output oPlot;
	
	wire mLeft, mUp, mRight, mDown, startCount, set, increment;
	wire [25:0] enable;

	ratediv #(.clkfreq(clkfreq)) rd0(.clk(clk), .reset(reset), .startCount(startCount), .enable(enable));
	datapath d0(
		.clk(clk), 
		.reset(reset), 
		.mLeft(mLeft), 
		.mUp(mUp), 
		.mRight(mRight), 
		.mDown(mDown), 
		.ox(ox), 
		.oy(oy), 
		.oc(oc), 
		.enable(enable),
		.set(set),
		.increment(increment)
		);
	
	control c0(
		.clk(clk), 
		.reset(reset),
		.move_left(left), 
		.move_up(up), 
		.move_right(right), 
		.move_down(down),
		.increment(increment), 
		.startCount(startCount), 
		.mLeft(mLeft), 
		.mUp(mUp), 
		.mRight(mRight), 
		.mDown(mDown), 
		.set(set), 
		//.audio, 
		.enable(enable),
		.oPlot(oPlot)
		);
	

endmodule

//control updated module 
module control(clk, reset, move_left, move_up, move_right, move_down, increment, startCount, mLeft, mUp, mRight, mDown, set, /*audio,*/ enable, oPlot); //here
	
	input clk, reset, move_left, move_up, move_right, move_down;
	input [25:0] enable;

	/*output reg [1:0]incx;
	output reg [1:0]incy;*/
	//output reg increment, /*audio*/;
	output reg startCount, mLeft, mUp, mRight, mDown, set, increment, oPlot;//signal stuff
	
	reg [6:0] current, next, prev, count;
	//reg two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen, seventeen, eighteen, nineteen;
	
	localparam S1	=	7'd1,
				  S2	=	7'd2,
				  S3	=	7'd3,
				  S4	=	7'd4,
				  S5	=	7'd5,
				  S6	=	7'd6,
				  S7	=	7'd7,
				  S8	=	7'd8,
				  S9	=	7'd9,
				  S10	=	7'd10,
				  S11	=	7'd11,
				  S12	=	7'd12,
				  S13	=	7'd13,
				  S14	=	7'd14,
				  S15	=	7'd15,
				  S16	=	7'd16,
				  S17	=	7'd17,
				  S18	=	7'd18,
				  S19	=	7'd19,
				  S20	=	7'd20,
				  LEFT	=	7'd21,
				  UP		=	7'd22,
				  DOWN	=	7'd23,
				  RIGHT	=	7'd24,
				  WAIT_LEFT	=	7'd25,
				  WAIT_UP	=	7'd26,
				  WAIT_DOWN	=	7'd27,
				  WAIT_RIGHT	=	7'd28,
				  WAIT	=	7'd29,
				  WAITING	=	7'd30;
				  /*CLEFT	=	7'd31,
				  CUP	=	7'd32,
				  CRIGHT	=	7'd33,
				  CDOWN	=	7'd34;*/
				  
	always @(*)
		begin
			//loadState = 1;
			case (current)
				WAIT: begin
				//loadState = 0;
					if(count == 7'd5) begin
						next = S1;
					end
					else begin
						next = WAIT;
					end
				end
				WAIT_LEFT: begin
					//loadState = 0;
					next = move_left ? WAIT_LEFT : LEFT;
				end
				WAIT_UP: begin
					//loadState = 0;
					next = move_up ? WAIT_UP : UP;
				end
				WAIT_RIGHT: begin
					//loadState = 0;
					next = move_right ? WAIT_RIGHT : RIGHT;
				end
				WAIT_DOWN: begin
					//loadState = 0;
					next = move_down ? WAIT_DOWN : DOWN;
				end
				/*WAITING: begin
					//ldprev = move_right ? S1 : 7'b0;
					if(count == 7'd6) begin
						next = S1;
					end
					else begin
						next = WAITING;
					end
				end*/
				S1: next = move_right ? WAIT_RIGHT : S1;
				S2: begin
					if (move_down) begin
						next = WAIT_DOWN;
						//ldprev = S2;
					end
					else if (move_left) begin
						next = WAIT_LEFT;
						//ldprev = S2;
					end
					else begin
						next = S2;
					end
				end
				S3: begin
					if (move_right) begin
						next = WAIT_RIGHT;
						//ldprev = S3;
					end
					else if (move_up) begin
						next = WAIT_UP;
						//ldprev = S3;
					end
					else begin
						next = S3;
					end
				end
				S4: begin
					if(move_up) begin
						next = WAIT_UP;
						//ldprev = S4;
					end
					else if(move_left) begin
						next = WAIT_LEFT;
						//ldprev = S4;
					end
					else begin
						next = S4;
					end
				end
				S5: begin 
					if(move_left) begin
						next = WAIT_LEFT;
						//ldprev = S5;
					end
					else if(move_down)begin
						next = WAIT_DOWN;
						//ldprev = S5;
					end
					else begin
						next = S5;
					end
				end
				S6: begin
					if(move_up) begin
						next = WAIT_UP;
						//ldprev = S6;
					end
					else if(move_right) begin
						next = WAIT_RIGHT;
						//ldprev = S6;
					end
					else begin
						next = S6;
					end
				end
				S7: begin
					if(move_right) begin
						next = WAIT_RIGHT;
						//ldprev = S7;
					end
					else if(move_down) begin
						next = WAIT_DOWN;
						//ldprev = S7;
					end 
					else begin
						next = S7;
					end
				end
				S8: begin 
					if(move_down) begin
						next = WAIT_DOWN;
						//ldprev = S8;
					end
					else if(move_left) begin
						next = WAIT_LEFT;
						//ldprev = S8;
						end
					else begin
						next = S8;
					end
				end
				S9: begin
					if(move_right) begin
						next = WAIT_RIGHT;
						//ldprev = S9;
					end
					else if(move_up) begin
						next = WAIT_UP;
						//ldprev = S9;
					end
					else begin
						next = S9;
					end
				end
				S10: begin
					if(move_down) begin
						next = WAIT_DOWN;
						//ldprev = S10;
					end
					else if(move_left) begin
						next = WAIT_LEFT;
						//ldprev = S10;
					end
					else begin
						next = S10;
					end
				end
				S11: begin
					if(move_left) begin
						next = WAIT_LEFT;
						//ldprev = S11;
					end
					else if(move_up) begin
						next = WAIT_UP;
						//ldprev = S11;
					end
					else begin
						next = S11;
					end
				end
				S12 : begin
					if(move_down) begin
						next = WAIT_DOWN;
						//ldprev = S12;
					end
					else if (move_right) begin
						next = WAIT_RIGHT;
						//ldprev = S12;
					end
					else begin
						next = S12;
					end
				end
				S13: begin
					if(move_right) begin
						next = WAIT_RIGHT;
						//ldprev = S13;
					end
					else if (move_up) begin
						next = WAIT_UP;
						//ldprev = S13;
					end
					else if (move_left) begin
						next = WAIT_LEFT;
						//ldprev = S13;
					end
					else begin
						next = S13;
					end
				end
				S14: begin
						next = move_right ? WAIT_RIGHT : S14;
						//ldprev = S14;
					  end
				S15: begin
					if(move_up) begin
						next = WAIT_UP;
						//ldprev = S15;
					end
					else if(move_left) begin
						next = WAIT_LEFT;
						//ldprev = S15;
					end
					else begin
						next = S15;
					end
				end
				S16: begin
					if(move_right) begin
						next = WAIT_RIGHT;
						//ldprev = S16;
					end
					else if(move_up) begin
						next = WAIT_LEFT;
						//ldprev = S16;
					end
					else if(move_down) begin
						next = WAIT_DOWN;
						//ldprev = S16;
					end
					else begin
						next = S16;
					end
				end
				S17: begin 
					if(move_down) begin
						next = WAIT_DOWN;
						//ldprev = S17;
					end
					else if(move_left) begin
						next = WAIT_LEFT;
						//ldprev = S17;
						end
					else begin
						next = S17;
					end
				end
				S18: begin 
					if(move_right) begin
						next = WAIT_RIGHT;
						//ldprev = S18;
					end
					else if(move_down) begin
						next = WAIT_DOWN;
						//ldprev = S18;
					end
					else begin
						next = S18;
					end
				end
				S19: begin
					next = move_up ? WAIT_UP : S19;
					//ldprev = S19;
				end
				
				//done state?
				S20: begin
					//audio = 1;
					end //fill in later;
				
				//Movement States
				// use if statements for each state that can move in this direction ie S2, S4, S5, S8, etc
				LEFT: begin
					//loadState = 0;
					if (prev == S2) begin
						//need to wait certain number of clock cycles for counter
						if (count == 7'd24) begin 				// n is arbitrary number undecided so far can use random number to test compileation
							next = S1;							// Since prev state is known and direction is known you know where the next state is
						end
					end
					else if(prev == S4) begin
						if(count == 7'd22) begin
							next = S3;
						end
					end
					else if(prev == S5) begin
						if(count == 7'd22) begin
							next = S6;
						end
					end
				   else if(prev == S8) begin
						if(count == 7'd44) begin
							next = S7;
						end
					end
					else if(prev == S10) begin
						if(count == 7'd22) begin
							next = S9;
						end
					end
					else if(prev == S11) begin
						if(count == 7'd22) begin
							next = S12;
						end
					end
					else if(prev == S13) begin
						if(count == 7'd46) begin
							next = S14;
						end
					end
					else if(prev == S15) begin
						if(count == 7'd44) begin
							next = S13;
						end
					end
					else if( prev == S17) begin
						if(count == 7'd20) begin
							next = S18;
						end
					end
					else begin
						next = LEFT;
					end	
				end
				
				UP: begin 
					//loadState = 0;
					if(prev == S3) begin
						if(count == 7'd14) begin
							next = S2;
						end
					end
					else if(prev == S4) begin
						if(count == 7'd26) begin
							next = S5;
						end
					end
					else if(prev == S6) begin
						if(count == 7'd14) begin
							next = S7;
						end
					end
					else if(prev == S9) begin
						if(count == 7'd28) begin
							next = S8;
						end
					end
					else if(prev == S11) begin
						if(count == 7'd13) begin
							next = S10;
						end
					end
					else if(prev == S13) begin
						if(count == 7'd14) begin
							next = S12;
						end
					end
					else if(prev == S15) begin
						if(count == 7'd28) begin
							next = S16;
						end
					end
					else if(prev == S16) begin
						if(count == 7'd28) begin
							next = S17;
						end
					end
					else if(prev == S19) begin
						if(count == 7'd10) begin
							next = S18;
						end
					end
					else begin
						next = UP;
					end
				end
				
				RIGHT: begin
					//loadState = 0;
					if(prev == S1) begin
						if(count == 7'd24) begin
							next = S2;
						end
					end
					else if(prev == S3) begin
						if(count == 7'd22) begin
							next = S4;
						end
					end
					else if(prev == S6) begin
						if(count == 7'd22) begin
							next = S5;
						end
					end
					else if(prev == S7) begin
						if(count == 7'd44) begin
							next = S8;
						end
					end
					else if(prev == S9) begin
						if(count == 7'd22) begin
							next = S10;
						end
					end
					else if(prev == S12) begin
						if(count == 7'd22) begin
							next = S11;
						end
					end
					else if(prev == S13) begin
						if(count == 7'd44) begin
							next = S15;
						end
					end
					else if(prev == S14) begin
						if(count == 7'd46) begin
							next = S13;
						end
					end
					else if(prev == S16) begin
						if(count == 7'd30) begin
							next = S20;
						end
					 end
					else if(prev == S18) begin
						if(count == 7'd20) begin
							next = S17;
						end
					end
					else begin
						next = RIGHT;
					end
					/*case (prev)
						S1: begin
							if (count == 7'd8) begin
								next = S2;
							end
						end
					default: next = RIGHT;
					endcase*/
				end
						 
				DOWN: begin
					//loadState = 0;
					if(prev == S2) begin
						if(count == 7'd14) begin
							next = S3;
						end
					end
					else if(prev == S5) begin
						if(count == 7'd26) begin
							next = S4;
						end
					end
					else if(prev == S7) begin
						if(count == 7'd14) begin
							next = S6;
						end
					end
					else if(prev == S8) begin
						if(count == 7'd28) begin
							next = S9;
						end
					end
					else if(prev == S10) begin
						if(count == 7'd13) begin
							next = S11;
						end
					end
					else if(prev == S12) begin
						if(count == 7'd14) begin
							next = S13;
						end
					end
					else if(prev == S16) begin
						if(count == 7'd28) begin
							next = S15;
						end
					end
					else if(prev == S17) begin
						if(count == 7'd28) begin
							next = S16;
						end
					end
					else if(prev == S18) begin
						if(count == 7'd10) begin
							next = S19;
						end
					end
					else begin
						next = DOWN;
					end
				end
				
				/*CLEFT: begin
					if (prev == S2) begin	
							next = S1;							
						end
					else if(prev == S4) begin
							next = S3;
					end
					else if(prev == S5) begin
							next = S6;
					end
				   else if(prev == S8) begin
							next = S7;
					end
					else if(prev == S10) begin
							next = S9;
					end
					else if(prev == S11) begin
							next = S12;
					end
					else if(prev == S13) begin
							next = S14;
					end
					else if(prev == S15) begin
							next = S13;
					end
					else if( prev == S17) begin
							next = S18;
					end
					else begin
						next = CLEFT;
					end	
				end
				
				CUP: begin
					if(prev == S3) begin
							next = S2;
					end
					else if(prev == S4) begin
							next = S5;
					end
					else if(prev == S6) begin
							next = S7;
					end
					else if(prev == S9) begin
							next = S8;
					end
					else if(prev == S11) begin
							next = S10;
					end
					else if(prev == S13) begin
							next = S12;
					end
					else if(prev == S15) begin
							next = S16;
					end
					else if(prev == S16) begin
							next = S17;
					end
					else if(prev == S19) begin
							next = S18;
					end
					else begin
						next = CUP;
					end
				end
				
				CRIGHT: begin
					if(prev == S1) begin
							next = S2;
					end
					else if(prev == S3) begin
							next = S4;
					end
					else if(prev == S6) begin
							next = S5;
					end
					else if(prev == S7) begin
							next = S8;
					end
					else if(prev == S9) begin
							next = S10;
					end
					else if(prev == S12) begin
							next = S11;
					end
					else if(prev == S13) begin
							next = S15;
					end
					else if(prev == S14) begin
							next = S13;
					end
					else if(prev == S16) begin
							next = S20;
					 end
					else if(prev == S18) begin
							next = S17;
					end
					else begin
						next = CRIGHT;
					end
				end
				
				CDOWN: begin
					if(prev == S2) begin
							next = S3;
					end
					else if(prev == S5) begin
							next = S4;
					end
					else if(prev == S7) begin
							next = S6;
					end
					else if(prev == S8) begin
							next = S9;
					end
					else if(prev == S10) begin
							next = S11;
					end
					else if(prev == S12) begin
							next = S13;
					end
					else if(prev == S16) begin
							next = S15;
					end
					else if(prev == S17) begin
							next = S16;
					end
					else if(prev == S18) begin
							next = S19;
					end
					else begin
						next = CDOWN;
					end
				end*/
			default: next = WAIT;
			endcase
		end

	always @(posedge clk) // need to change increment position, figure out where to put oPlot
		begin
			
			startCount = 0;
			set = 0;
			mLeft = 0;
			mUp = 0;
			mRight = 0;
			mDown = 0;
			increment = 0;
			oPlot = 0;
			
			case (current)
				
				WAIT: begin
					startCount = 1;
					/*two = 1;
					three = 1;
					four = 1;
					five = 1;
					six = 1;
					seven = 1;
					eight = 1;
					nine = 1;
					ten = 1;
					eleven = 1;
					twelve = 1;
					thirteen = 1;
					fourteen = 1;
					fiveteen = 1;
					sixteen = 1;
					seventeen = 1;
					eighteen = 1;
					nineteen = 1;*/
					
					if (enable == 26'd0) begin
						count = count + 1;
					end
				end
				S1: begin
					set = 1;
					oPlot = 1;
					startCount = 1;
				end
				/*WAITING: begin
					startCount = 1;
					set = 1;
					oPlot = 1;
					
					if (enable == 26'd0) begin
						count = count + 1;
					end
				end*/
				WAIT_LEFT: begin
					count = 0;
				end
				WAIT_UP: begin
					count = 0;
				end
				WAIT_RIGHT: begin
					count = 0;
				end
				WAIT_DOWN: begin
					count = 0;
				end
				LEFT: begin
					startCount = 1;
					mLeft = 1;
					
					if (enable == 26'd6) begin
						increment = 1;
					end
					else if (enable <= 26'd5) begin
						oPlot = 1;
						if (enable == 26'd0) begin
							count = count + 1;
						end
					end
					
				end
				UP: begin
					startCount = 1;
					mUp = 1;
					
					if (enable == 26'd6) begin
						increment = 1;
					end
					else if (enable <= 26'd5) begin
						oPlot = 1;
						if (enable == 26'd0) begin
							count = count + 1;
						end
					end
					
				end
				RIGHT: begin
					startCount = 1;
					mRight = 1;
					
					if (enable == 26'd6) begin
						increment = 1;
					end
					else if (enable <= 26'd5) begin
						oPlot = 1;
						if (enable == 26'd0) begin
							count = count + 1;
						end
					end
					
				end
				DOWN: begin
					startCount = 1;
					mDown = 1;
					
					if (enable == 26'd6) begin
						increment = 1;
					end
					else if (enable <= 26'd5) begin
						oPlot = 1;
						if (enable == 26'd0) begin
							count = count + 1;
						end
					end
					
				end
				/*CLEFT: begin
					increment = 1;
					mRight = 1;
				end
				CUP: begin
					increment = 1;
					mDown = 1;
				end
				CRIGHT: begin
					increment = 1;
					mLeft = 1;
				end
				CDOWN: begin
					increment = 1;
					mUp = 1;
				end*/
				
				/*S2: begin
					count = 0;
					if ((move_down || move_left)) begin
						increment = 1;
						mLeft = 1;
						two = 0;
					end
				end
				S3: begin
					count = 0;
					if ((move_right || move_up)) begin
						increment = 1;
						mUp = 1;
						three = 0;
					end
				end
				S4: begin
					count = 0;
					if (move_up || move_left) begin
						increment = 1;
						mLeft = 1;
					end
				end
				S5: begin
					count = 0;
					if (move_left || move_down) begin
						increment = 1;
						mDown = 1;
					end
				end
				S6: begin
					count = 0;
					if (move_up || move_right) begin
						increment = 1;
						mRight = 1;
					end
				end
				S7: begin
					count = 0;
					if (move_right || move_down) begin
						increment = 1;
						mDown = 1;
					end
				end
				S8: begin
					count = 0;
					if (move_down || move_left) begin
						increment = 1;
						mLeft = 1;
					end
				end
				S9: begin
					count = 0;
					if (move_right || move_up) begin
						increment = 1;
						mUp = 1;
					end
				end
				S10: begin
					count = 0;
					if (move_down || move_left) begin
						increment = 1;
						mLeft = 1;
					end
				end
				S11: begin
					count = 0;
					if (move_left || move_up) begin
						increment = 1;
						mUp = 1;
					end
				end
				S12: begin
					count = 0;
					if (move_down || move_right) begin
						increment = 1;
						mRight = 1;
					end
				end
				S13: begin
					count = 0;
					if (move_right || move_left || move_up) begin
						increment = 1;
						mUp = 1;
					end
				end
				S14: begin
					count = 0;
					if (move_right) begin
						increment = 1;
						mRight = 1;
					end
				end
				S15: begin
					count = 0;
					if (move_up || move_left) begin
						increment = 1;
						mLeft = 1;
					end
				end
				S16: begin
					count = 0;
					if (move_right || move_up || move_down) begin
						increment = 1;
						mDown = 1;
					end
				end
				S17: begin
					count = 0;
					if (move_left || move_down) begin
						increment = 1;
						mDown = 1;
					end
				end
				S18: begin
					count = 0;
					if (move_down || move_right) begin
						increment = 1;
						mRight = 1;
					end
				end
				S19: begin
					count = 0;
					if (move_up) begin
						increment = 1;
						mUp = 1;
					end
				end*/
				
			default: count = 0;	
			endcase
		
		end
		
	always @(posedge clk)
		begin
		
			if (reset) begin
				current <= S1;
				prev <= S1;
			end
			else begin
				current <= next;
				//prev <= ldprev;
				if (current == S1 || current == S2 || current == S3 || current == S4 || current == S5 || current == S6 || current == S7 || current == S8 || current == S9 || current == S10 || current == S11 || current == S12 || current == S13 || current == S14 || current == S15 || current == S16 || current == S17 || current == S18 || current == S19 || current == S20) begin
					prev <= current;
				end
			end
		end

endmodule



module datapath (clk, reset, mLeft, mUp, mRight, mDown, ox, oy, oc, enable, set, increment); //here
	input clk, reset;
	input mLeft, mUp, mRight, mDown, set, increment;
	input [25:0] enable;
	
	output reg [7:0] ox;
	output reg [6:0] oy;
	output reg [2:0] oc;
	
	reg [7:0] xn1, xn2, xleft, xright;
	reg [6:0] yn1, yn2, yup, ydown; //here

	always @(posedge clk)
		begin
		
			if (reset) begin //Change to starting positions
				xn1 = 8'd8;
				xn2 = 8'd9;
				xleft = 8'd7;
				xright = 8'd10;
				yn1 = 7'd76;
				yn2 = 7'd77;
				yup = 7'd75;
				ydown = 7'd78;
			end
			/*else if (switch) begin
			
				if (left) begin
					xnew1 = xnew1 -1;
					xold1 = xold1 -1;
				end
				else if (up) begin
					ynew1 = ynew1 + 1;
					yold1 = yold1 + 1;
				end
				else if (right) begin
					xnew1 = xnew1 + 1;
					xold1 = xold1 + 1;
				end
				else if (down) begin
					ynew1 = ynew1 - 1;
					yold1 = yold1 - 1;
				end
				
			end*/
			else if (set) begin //Set to starting positions
				xn1 = 8'd8;
				xn2 = 8'd9;
				xleft = 8'd7;
				xright = 8'd10;
				yn1 = 7'd76;
				yn2 = 7'd77;
				yup = 7'd75;
				ydown = 7'd78;
			end
			else if (increment) begin
			
				if (mLeft) begin
					xn1 = xn1 - 1;
					xn2 = xn2 - 1;
					xleft = xleft - 1;
					xright = xright - 1;
				end
				else if (mUp) begin
					yn1 = yn1 - 1;
					yn2 = yn2 - 1;
					yup = yup - 1;
					ydown = ydown - 1;
				end
				else if (mRight) begin
					xn1 = xn1 + 1;
					xn2 = xn2 + 1;
					xleft = xleft + 1;
					xright = xright + 1;
				end
				else if (mDown) begin
					yn1 = yn1 + 1;
					yn2 = yn2 + 1;
					yup = yup + 1;
					ydown = ydown + 1;
				end
				
			end
			
		end
	
	always @(posedge clk)
		begin
			
			if (set) begin
				oc = 3'b100;
				if (enable == 26'd4) begin
					ox = xn1;
					oy = yn1;
				end
				else if (enable == 26'd3) begin
					ox = xn2;
					oy = yn1;
				end
				else if (enable == 26'd2) begin
					ox = xn1;
					oy = yn2;
				end
				else if (enable == 26'd1) begin
					ox = xn2;
					oy = yn2;
				end
			end

			else if (enable == 26'd4) begin
				if (mLeft) begin
					ox = xn1;
					oy = yn1;
				end
				else if (mUp) begin
					ox = xn1;
					oy = yn1;
				end
				else if (mRight) begin
					ox = xn2;
					oy = yn1;
				end
				else if (mDown) begin
					ox = xn1;
					oy = yn2;
				end
				oc = 3'b100;
			end
			else if (enable == 26'd3) begin
				if (mLeft) begin
					ox = xn1;
					oy = yn2;
				end
				else if (mUp) begin
					ox = xn2;
					oy = yn1;
				end
				else if (mRight) begin
					ox = xn2;
					oy = yn2;
				end
				else if (mDown) begin
					ox = xn2;
					oy = yn2;
				end
				oc = 3'b100;
			end
			else if (enable == 26'd2) begin
				if (mLeft) begin
					ox = xright;
					oy = yn1;
				end
				else if (mUp) begin
					ox = xn1;
					oy = ydown;
				end
				else if (mRight) begin
					ox = xleft;
					oy = yn1;
				end
				else if (mDown) begin
					ox = xn1;
					oy = yup;
				end
				oc = 3'b111;
			end
			else if (enable == 26'd1) begin
				if (mLeft) begin
					ox = xright;
					oy = yn2;
				end
				else if (mUp) begin
					ox = xn2;
					oy = ydown;
				end
				else if (mRight) begin
					ox = xleft;
					oy = yn2;
				end
				else if (mDown) begin
					ox = xn2;
					oy = yup;
				end
				oc = 3'b111;
			end
			
		end
		
endmodule 


module ratediv #(parameter clkfreq = 50000000)(clk, reset, startCount, enable);

	input clk, reset, startCount;
	output reg [25:0] enable;
	
	always @(posedge clk)
		begin
			
			if (reset || !startCount || enable == 26'd0) begin
				enable <= clkfreq/50;
			end
			else begin
				enable <= enable - 1;
			end
		end
			
endmodule
