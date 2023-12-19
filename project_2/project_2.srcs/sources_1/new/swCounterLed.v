`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/17/2023 12:41:07 AM
// Design Name: 
// Module Name: swCounterLed
// Project Name: practice switch counter 
// Target Devices: basys3
// Tool Versions: 
// Description: This program is supposed to allow the 16 switches on the board to
//  be read as a 16 bit number where each corresponding 4 bits are output as hex on
//  the seven segment display, and each led is lit up with the corresponding switch
// 
// Dependencies: 
// 
// Revision: 0
// Revision 0.01 - File Created
// Additional Comments: At this time, it will only light up the whole seven segment
//  display so each (all 4) will show the total for any set of 4 bits in the 16 bit
//  number.
// 
//////////////////////////////////////////////////////////////////////////////////


module swCounterLed(
    //Board variables based on xdc
    input   clk,
    input   btnC,           //reset button
    input   [15:0]sw,
    output  [15:0]led, 
    output  [6:0]seg,
    output  [3:0]an
    );
    
    //Variables
    wire [3:0] hssd[3:0];
    genvar i;
    //reg [6:0]ssd;
    reg [2:0]dis = 0;
    
    //assign each sw to led
    assign led = sw & ~btnC;
    generate
    for (i=0; i<4; i=i+1) begin
        assign hssd[i] = {sw[(i*4)+3], sw[(i*4)+2], sw[(i*4)+1], sw[(i*4)]};
    end
    endgenerate
    
    
    always @(posedge clk) begin;
        if(btnC == 1) begin
            dis <= 0;
        end else begin        
            dis <= dis + 1;
        end
    end
    
    
    EnableDigit     MyEnableDigit(dis, an);
    DisplayDigit    MyDisplayDigit((hssd[dis] & ~btnC), seg);
    
        
endmodule


module DisplayDigit( valueIn, sevenSegOut);
	input [3:0] valueIn;	                                  //4 bit input value
	output [6:0] sevenSegOut;                                 //seven segment settings: sets each of the 7 segments to on or off

	assign sevenSegOut = (valueIn == 4'b0000) ? 7'b1000000:   // 1
                         (valueIn == 4'b0001) ? 7'b1111001:   // 1
                         (valueIn == 4'b0010) ? 7'b0100100:   // 2
                         (valueIn == 4'b0011) ? 7'b0110000:   // 3
                         (valueIn == 4'b0100) ? 7'b0011001:   // 4
                         (valueIn == 4'b0101) ? 7'b0010010:   // 5
                         (valueIn == 4'b0110) ? 7'b0000010:   // 6
                         (valueIn == 4'b0111) ? 7'b1111000:   // 7
                         (valueIn == 4'b1000) ? 7'b0000000:   // 8
                         (valueIn == 4'b1001) ? 7'b0010000:   // 9
                         (valueIn == 4'b1010) ? 7'b0001000:   // A
                         (valueIn == 4'b1011) ? 7'b0000011:   // b
                         (valueIn == 4'b1100) ? 7'b1000110:   // C
                         (valueIn == 4'b1101) ? 7'b0100001:   // d
                         (valueIn == 4'b1110) ? 7'b0000110:   // E
                         (valueIn == 4'b1111) ? 7'b0001110:   // F
                                                7'b1111111;   // default i.e. all segments off!
								 

endmodule


module EnableDigit( digitSelectIn, digSelectOut);
	input [1:0] digitSelectIn;                                  //0 is right most digit, 1 is 2nd rightmost etc, 3 is leftmost
	output [3:0] digSelectOut;                                  //digit selections to turn individual digit (anodes) on or off	
	assign digSelectOut = (digitSelectIn == 2'b00) ? 4'b1110:   // right most digit
					      (digitSelectIn == 2'b01) ? 4'b1101:   // 2nd right most digit
						  (digitSelectIn == 2'b10) ? 4'b1011:   // 3rd right most digit
						  (digitSelectIn == 2'b11) ? 4'b0111:   // left most digit
						  4'b0000;                              //DEFAULT: enable all digits
      
			
endmodule