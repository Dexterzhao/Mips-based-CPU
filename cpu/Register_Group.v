`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:59:52 03/09/2016
// Design Name: 
// Module Name:    Register_Group 
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
module Register_Group(
    output [31 : 0] data_out_A,
    output [31 : 0] data_out_B,
	 output [31 : 0] syscall_v0,
	 output reg [31 : 0] syscall_a0,
	 input write,
    input [4 : 0] address,
    input [9 : 0] output_AB,
    input [31 : 0] data_in,
	 input print_a0
    );

	reg [31 : 0] register [31 : 0];
	// $0			: $zero
	// $1			: $at/assembler temporary register
	// $2~$3		: $v0~$v1
	// $4~$7		: $a0~$a3
	// $8~$15	: $t0~$t7
	// $16~$23	: $s0~$s7
	// $24~$25	: $t8~$t9
	// $26~$27	: $k0~$k1/reserved for os
	// $28		: $gp
	// $29		: $sp
	// $30		: $fp
	// $31		: $ra
	
	initial
	begin
		register[0] <= 32'b0;
	end
	
	assign data_out_A = register[output_AB[9 : 5]];
	assign data_out_B = register[output_AB[4 : 0]];
	
	assign syscall_v0 = register[2];
	
	always @(posedge print_a0)
	begin
		syscall_a0 <= register[4];
	end
	
	always @(posedge write)	// R0 for zero, so write != 0 means pipeline needs to WB
	begin
		if (address != 0)
		begin
			register[address] <= data_in;
		end
	end

endmodule
