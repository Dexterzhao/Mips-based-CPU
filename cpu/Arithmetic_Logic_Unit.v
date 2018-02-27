`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:39:59 03/10/2016
// Design Name: 
// Module Name:    Arithmetic_Logic_Unit 
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
module Arithmetic_Logic_Unit(
    output reg [31 : 0] data_out,
    input [3 : 0] ctrl,
    input [31 : 0] data_in_A,
    input [31 : 0] data_in_B
    );

	wire [1 : 0] sign_union;

	assign sign_union = {data_in_A[31], data_in_B[31]};

	always @(*)
	begin
		case (ctrl)
			0:			data_out <= (data_in_A+data_in_B);
			1:			data_out <= (data_in_A-data_in_B);
			2:			data_out <= (data_in_A&data_in_B);
			3:			data_out <= (data_in_A|data_in_B);
			4:			data_out <= (~(data_in_A|data_in_B));
			5:			data_out <= (data_in_A < data_in_B);
			6:			data_out <= (sign_union == 2'b01 ? 0 : (sign_union == 2'b10 ? 1 : ((data_in_A < data_in_B)^sign_union[1])));
			7:			data_out <= (data_in_A<<data_in_B);
			8:			data_out <= (data_in_A>>data_in_B);
			9:			data_out <= ($signed(data_in_A)>>>data_in_B);
			default:	data_out <= ((data_in_A&32'hfc000000)|data_in_B);
		endcase
	end

endmodule
