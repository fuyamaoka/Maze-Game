module hexdecoder #(parameter CLOCK_FREQUENCY = 50000000)(
  input clk,
  input [3:0] reset,
  output [6:0] hex0,
  output [6:0] hex1,
  output [6:0] hex2

/*input				AUD_ADCDAT,

// Bidirectionals
inout				AUD_BCLK,
inout				AUD_ADCLRCK,
inout				AUD_DACLRCK,

inout				FPGA_I2C_SDAT,

// Outputs
output				AUD_XCK,
output				AUD_DACDAT,

output				FPGA_I2C_SCLK*/
 
);

  wire [3:0] Counter1, Counter10, Counter100;
	wire enablingwire;
  wire Audio;
  
  

  RateDivider #(.CLOCK_FREQUENCY(50000000)) u0(
    .ClockIn(clk),
    .Reset(!reset),
    .Speed(2'b01),  // Assuming 1-second interval
    .Enable(enablingwire)
  );

  DisplayCounter u3(
    .Clock(clk),
    .Reset(!reset),
    .EnableDC(enablingwire),
    .Counter1(Counter1), .Counter10(Counter10), .Counter99(Counter100),
	 .Audio(Audio)
  );

  
   /*audio u4(
	// Inputs
	CLOCK_50,
	KEY,

	AUD_ADCDAT,

	// Bidirectionals
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,

	FPGA_I2C_SDAT,

	// Outputs
	AUD_XCK,
	AUD_DACDAT,

	FPGA_I2C_SCLK,
	Audio
);*/

  hex_decoder u6(.c(Counter1), .display(hex0));
  hex_decoder u7(.c(Counter10), .display(hex1));
  hex_decoder u8(.c(Counter100), .display(hex2));

endmodule

module RateDivider #(parameter CLOCK_FREQUENCY = 50000000)
                   (ClockIn, Reset, Speed, Enable);

  input ClockIn, Reset;
  input [1:0] Speed;
  output Enable;
  reg [99:0] timer; // Adjust the bit width for 100 seconds

  always @(posedge ClockIn) begin
    if (Reset || !timer) begin
      case (Speed)
        2'b00: timer = 0; // Set to 0 with proper bit width
        2'b01: timer = (CLOCK_FREQUENCY); //timer = 10 -> every 10 clock tick u get 1 high
        2'b10: timer = (0.1* CLOCK_FREQUENCY); //timer = 1;
        2'b11: timer = (0.01* CLOCK_FREQUENCY); // ==0
      endcase
    end
  else begin
	timer = timer - 1;
	end
 end

//first clock tick -> nothing
assign Enable = (!timer);

endmodule



module DisplayCounter(Clock, Reset, EnableDC,Audio, Counter1, Counter10, Counter99);
  input Clock, Reset, EnableDC;
  output reg [3:0] Counter1, Counter10, Counter99;
  output reg Audio;
  reg stop;

  always @(posedge Clock or posedge Reset) begin
    if (Reset) begin
      Counter1 <= 0;
      Counter10 <= 0;
      Counter99 <= 0;
		stop <= 0;
    end
	 else if (EnableDC && !stop) begin
     		Counter1 <= Counter1 + 1;
      if (Counter1 == 9) begin
        Counter1 <= 0;
        Counter10 <= Counter10 + 1;
        if (Counter10 == 9) begin
          Counter10 <= 0;
          Counter99 <= Counter99 + 1;
        end
      end
		else if (Counter1 == 0 && Counter10 == 0 && Counter99 == 1) begin
            Counter99 <= 0;
				Counter10 <= 0;
				stop <=1;
      end
    end
	 else if (stop)begin
		Counter99 <= 0;
		Counter10 <= 0;
		Counter1 <= 0;
		end
  end

  always @(*) begin
    if (Counter99 == 1 && Counter10 == 0 && Counter1 == 0) begin
	   Audio = 1;	// Display "1" on the third digit
    end
	else Audio = 0;
	end
	
	
endmodule

module hex_decoder(c, display);

	input [3:0] c;
	output reg[6:0] display;
	
	always @(*)
	begin
		case(c)
			4'b0000 : display = 7'b1000000;
			4'b0001 : display = 7'b1111001;
			4'b0010 : display = 7'b0100100;
			4'b0011 : display = 7'b0110000;
			4'b0100 : display = 7'b0011001;
			4'b0101 : display = 7'b0010010;
			4'b0110 : display = 7'b0000010;
			4'b0111 : display = 7'b1111000;
			4'b1000 : display = 7'b0000000;
			4'b1001 : display = 7'b0010000;
			default : display = 7'b1111111
;
		endcase
	end

endmodule