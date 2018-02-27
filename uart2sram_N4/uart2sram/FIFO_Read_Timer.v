`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:02:23 05/14/2015 
// Design Name: 
// Module Name:    FIFO_Read_Timer 
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
//////////////////////////////////////////////////////////////////////////////////
module FIFO_Read_Timer(
    input clk,
    output reg real_clk
    );

	reg [26 : 0] second_timer;
	
	always @(posedge clk)
	begin
		second_timer = second_timer+1;
		if (second_timer >= 10000)
		begin
			second_timer = 0;
		end
		if (second_timer < 5000)
		begin
			real_clk = 1'b1;
		end
		else
		begin
			real_clk = 1'b0;
		end
	end

endmodule
