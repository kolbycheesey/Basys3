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
// Revision 0.02 - Code is updated so that it correctly displays the right number 
//  and will reset as needed
//  seg0 = switchs0-3
//  seg1 = switchs4-7
//  seg2 = switchs8-11
//  seg3 = switchs12-15
// Additional Comments: On reset it extends all values in the ssd to all other ssds
//      changed BHD to be 0 on reset as well should take care of this issue
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
    //wire [3:0] hssd[3:0];
    genvar i;
    reg [6:0]ssd;
    reg [1:0]dis;
    reg [3:0]anTemp = 0;
    reg [18:0]counter;
    reg [3:0]BHD;
    
    //assign each sw to led
    assign led = sw & ~btnC;
    /*generate
    for (i=0; i<4; i=i+1) begin
        assign hssd[i] = {sw[(i*4)+3], sw[(i*4)+2], sw[(i*4)+1], sw[(i*4)]};
    end
    endgenerate*/
    
    
    always @(posedge clk) begin
        if(btnC == 1) begin
            counter <= 18'd1;
            BHD = 4'd0;
        end else begin
            counter <= counter + 1;
        end
        
        //Only operat when 0 so instead of 100Mhz for clock is 381Hz. 
        //This allows the displays to hold different values instead of moving so fast they all have the same value
        if(counter == 18'd0) begin
            case(dis)
                2'b01     : begin   
                    anTemp = 4'b1101;
                    BHD = {sw[7], sw[6], sw[5], sw[4]};     //hssd[1];
                end
                2'b10     : begin   
                    anTemp = 4'b1011;
                    BHD = {sw[11], sw[10], sw[9], sw[8]};   //hssd[2]; 
                end
                2'b11     : begin   
                    anTemp = 4'b0111; 
                    BHD = {sw[15], sw[14], sw[13], sw[12]}; //hssd[3];
                end
                default   : begin   
                    anTemp = 4'b1110;
                    BHD = {sw[3], sw[2], sw[1], sw[0]};     //hssd[0]; 
                end
            endcase
            
            case(BHD)
                4'b0001   :   ssd = 7'b0000110;     //1         //7'b1000000 = 0
                4'b0010   :   ssd = 7'b1011011;     //2
                4'b0011   :   ssd = 7'b1001111;     //3
                4'b0100   :   ssd = 7'b1100110;     //4
                4'b0101   :   ssd = 7'b1101101;     //5
                4'b0110   :   ssd = 7'b1111101;     //6
                4'b0111   :   ssd = 7'b0000111;     //7
                4'b1000   :   ssd = 7'b1111111;     //8
                4'b1001   :   ssd = 7'b1100111;     //9
                4'b1010   :   ssd = 7'b1110111;     //A
                4'b1011   :   ssd = 7'b1111100;     //b
                4'b1100   :   ssd = 7'b0111001;     //C
                4'b1101   :   ssd = 7'b1011110;     //d
                4'b1110   :   ssd = 7'b1111001;     //E
                4'b1111   :   ssd = 7'b1110001;     //F
                default   :   ssd = 7'b0000000;     //All segments off
            endcase
            
            dis <= dis + 1;
        
        end
    end
    
    assign seg = ~ssd;
    assign an = anTemp;
    
    //Removed functions to double check the copied use of the ssd values and the output for anodes
    //EnableDigit     MyEnableDigit(dis, an);
    //DisplayDigit    MyDisplayDigit((hssd[dis] & ~btnC), seg);
           
endmodule

//  Seven segment display hook up
//      0
//     ---
//  5 |   | 1
//     --- <--6
//  4 |   | 2
//     ---
//      3

//This code is fine as of revision 1
//This is not correct
/*
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
*/

//With revision 1 this outputs any set of the 4 bits on the entire seven segment display
/* Revision one is removing this in facvor of something slightly nicer
module EnableDigit( digitSelectIn, digSelectOut);
	input [1:0] digitSelectIn;                                  //0 is right most digit, 1 is 2nd rightmost etc, 3 is leftmost
	output [3:0] digSelectOut;                                  //digit selections to turn individual digit (anodes) on or off	
	assign digSelectOut = (digitSelectIn == 2'b00) ? 4'b1110:   // right most digit
					      (digitSelectIn == 2'b01) ? 4'b1101:   // 2nd right most digit
						  (digitSelectIn == 2'b10) ? 4'b1011:   // 3rd right most digit
						  (digitSelectIn == 2'b11) ? 4'b0111:   // left most digit
						  4'b0000;                              //DEFAULT: enable all digits
      
			
endmodule
*/