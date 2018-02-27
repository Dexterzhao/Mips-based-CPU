`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:44:24 03/10/2016 
// Design Name: 
// Module Name:    Immediate_Extend 
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
// load :
// 0. 15:0 s
// 1. 15:0 z
// 2. 25:0 z
// 3. 10:6 z
//////////////////////////////////////////////////////////////////////////////////
module Immediate_Extend(
    output [31 : 0] data_out,
    input [1 : 0] load,
    input [31 : 0] data_in
    );

	assign data_out =
		(load == 0) ? {{16{data_in[15]}}, data_in[15 : 0]} :
		(load == 1) ? {16'b0, data_in[15 : 0]} :
		(load == 2) ? {6'b0, data_in[25 : 0]} :
		{27'b0, data_in[10 : 6]};
		
endmodule
