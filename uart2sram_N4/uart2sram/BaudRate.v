`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:25:35 04/16/2016 
// Design Name: 
// Module Name:    BaudRate 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
// Baud Rate:
// 100000000/(16*115200) = 54.25 -> 54 -> 27/27 0.25*4=1
// 100000000/(16*9600) = 651
//////////////////////////////////////////////////////////////////////////////////
module BaudRate(
    input clk,
	 output reg real_clk
    );

	reg [15 : 0] timer;
	reg [7 : 0] fixer;
	
	initial
	begin
		fixer = 0;
	end
	
	always @(posedge clk)   
	begin
		if (timer == 26)
		begin
			real_clk <= 1'b1;
			timer <= timer+1;
		end
		else if (timer == 53)
		begin
			real_clk <= 1'b0;
			timer <= 0;
			fixer <= fixer+1;
		end
		else
		begin
			timer <= timer+1;
		end
		if (fixer >= 4)
		begin
			timer <= timer+1;
			fixer <= 0;
		end
	end

endmodule
