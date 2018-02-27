`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:53:08 04/16/2015 
// Design Name: 
// Module Name:    SRAM_realmodetest 
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
module SRAM_realmodetest(
    input [7 : 0] switch,
    output [7 : 0] LED_out,
    output [7 : 0] LED_ctrl,
    input write,
    input read,
	 input clk,
	 inout [15 : 0] data_sram,
    output [22 : 0] addr2sram,
    output cs,
    output we,
    output oe,
    output ub,
    output lb,
	 input rst
    );
	
//	always @(posedge write_done)
//	begin
//		write_led <= 1;
//	end

	reg write_sig;
	wire rst_rev = ~rst;
	wire enable = write | read;
//	wire [15 : 0] address2SRAM = write_sig ? address : {8'h00, switch};
//	wire [15 : 0] data_write = {8'h00, switch};
	wire [15 : 0] address2SRAM;
	wire [31 : 0] data_write;
	wire [31 : 0] data_out;
	wire write_done;
	wire read_done;
	
	wire [15 : 0] temp_switch;
	assign address2SRAM = (temp_switch<<1)+1'b1;
	assign data_write = 32'hff2211ff;
	assign temp_switch = {8'h00, switch};
	
	initial
	begin
		write_sig <= 0;
//		write_led <= 0;
	end
	
	always @(posedge write or posedge write_done)
	begin
		if (write_done)
		begin
			write_sig <= 0;
		end
		else
		begin
			write_sig <= 1;
		end
	end
	
	N4_DISP
		N4_7Segment(LED_out, LED_ctrl, clk, rst_rev, data_out);
		
	SRAM
		SRAM_Unit(enable, write, address2SRAM, data_write, data_out, data_sram, addr2sram, cs, we, oe, ub, lb, clk, rst_rev, write_done, read_done);

endmodule
