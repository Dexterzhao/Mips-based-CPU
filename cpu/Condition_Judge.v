`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:24:42 03/09/2016
// Design Name: 
// Module Name:    Condition_Judge 
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
module Condition_Judge(
    output data_out,
	 input kind,
    input [31 : 0] data_in_A,
	 input [31 : 0] data_in_B
    );

	assign data_out = (data_in_A == data_in_B)^kind;

endmodule
