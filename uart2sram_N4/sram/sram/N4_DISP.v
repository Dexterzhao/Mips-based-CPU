`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:00:17 03/18/2015 
// Design Name: 
// Module Name:    Anvyl_DISP 
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
module N4_DISP(
    output [7 : 0] LED_out_rev,
    output [7 : 0] LED_ctrl_rev,
    input clk,
    input rst,
    input [31 : 0] data_in
    );

	reg [7 : 0] LED_out;
	reg [7 : 0] LED_ctrl;
	reg [3 : 0] LED_content;
	reg [19 : 0] timer;
	
	assign LED_out_rev = LED_out;
	assign LED_ctrl_rev = LED_ctrl;

	// 7-segment
	always @(posedge clk or negedge rst)
	begin
		if (rst == 0)
		begin
			timer <= 0;
		end
		else
		begin
			if (timer < 12500)
			begin
				LED_ctrl <= 8'b01111111;
				LED_content <= data_in[31 : 28];
				timer <= timer+1;
			end
			else if (timer < 25000)
			begin
				LED_ctrl <= 8'b10111111;
				LED_content <= data_in[27 : 24];
				timer <= timer+1;
			end
			else if (timer < 37500)
			begin
				LED_ctrl <= 8'b11011111;
				LED_content <= data_in[23 : 20];
				timer <= timer+1;
			end
			else if (timer < 50000)
			begin
				LED_ctrl <= 8'b11101111;
				LED_content <= data_in[19 : 16];
				timer <= timer+1;
			end
			else if (timer < 62500)
			begin
				LED_ctrl <= 8'b11110111;
				LED_content <= data_in[15 : 12];
				timer <= timer+1;
			end
			else if (timer < 75000)
			begin
				LED_ctrl <= 8'b11111011;
				LED_content <= data_in[11 : 8];
				timer <= timer+1;
			end
			else if (timer < 87500)
			begin
				LED_ctrl <= 8'b11111101;
				LED_content <= data_in[7 : 4];
				timer <= timer+1;
			end
			else if (timer < 100000)
			begin
				LED_ctrl <= 8'b11111110;
				LED_content <= data_in[3 : 0];
				timer <= timer+1;
			end
			else if (timer == 100000)
			begin
				LED_ctrl <= 8'b11111110;
				LED_content <= data_in[3 : 0];
				timer <= 0;
			end
		end
	end
	
	always @(LED_content)
	begin
		// encode
		case (LED_content)
			4'b0000:	LED_out <= 8'b00000011;
			4'b0001:	LED_out <= 8'b10011111;
			4'b0010:	LED_out <= 8'b00100101;
			4'b0011:	LED_out <= 8'b00001101;
			4'b0100:	LED_out <= 8'b10011001;
			4'b0101:	LED_out <= 8'b01001001;
			4'b0110:	LED_out <= 8'b01000001;
			4'b0111:	LED_out <= 8'b00011111;
			4'b1000:	LED_out <= 8'b00000001;
			4'b1001:	LED_out <= 8'b00001001;
			4'b1010:	LED_out <= 8'b00010001;
			4'b1011:	LED_out <= 8'b11000001;
			4'b1100:	LED_out <= 8'b01100011;
			4'b1101:	LED_out <= 8'b10000101;
			4'b1110:	LED_out <= 8'b01100001;
			4'b1111:	LED_out <= 8'b01110001;
		endcase
	end

endmodule
