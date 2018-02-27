`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:18:58 04/16/2016
// Design Name: 
// Module Name:    SRAM 
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
module SRAM(
    input enable,
    input writenable,
    input [15 : 0] address,
    input [15 : 0] data_write,
    output reg [15 : 0] data_read,
    inout [15 : 0] data_sram,
    output reg [18 : 0] addr2sram,
    output reg cs,
    output reg we,
    output reg oe,
    output reg ub,
    output reg lb,
	 input clk,
    input rst,
	 output reg write_done
    );
	 
	reg real_clk;
	reg [26 : 0] second_timer;
	
	always @(posedge clk or negedge rst)
	begin
		if (rst == 0)
		begin
			second_timer <= 0;
		end
		else
		begin
			if (second_timer < 10)
			begin
				second_timer <= second_timer+1;
				real_clk <= 1'b1;
			end
			else if (second_timer < 20)
			begin
				second_timer <= second_timer+1;
				real_clk <= 1'b0;
			end
			else
			begin
				second_timer <= 0;
				real_clk <= 1'b1;
			end
		end
	end
	
	reg [2 : 0] state;
	reg [2 : 0] next_state;
	
	parameter
		_Idle = 0,
		_ReadPre = 1,
		_ReadRes = 2,
		_WritePre = 3,
		_WriteRes = 4;
	
	always @(posedge real_clk or negedge rst)
	begin
		if (rst == 0)
		begin
			state <= _Idle;
		end
		else
		begin
			state <= next_state;
		end
	end
	
	always @(state)
	begin
		case (state)
			_Idle:
				begin
					cs <= 1;
					we <= 1;
					oe <= 1;
					ub <= 1;
					lb <= 1;
					next_state <= enable ? (writenable ? _WritePre : _ReadPre) : _Idle;
					write_done <= 0;
				end
			_ReadPre:
				begin
					addr2sram <= {3'b000, address};
					cs <= 0;
					we <= 1;
					ub <= 0;
					lb <= 0;
					oe <= 0;
					next_state <= _ReadRes;
				end
			_ReadRes:
				begin
					data_read <= data_sram;
					next_state <= _Idle;
				end
			_WritePre:
				begin
					addr2sram <= {3'b000, address};
					cs <= 0;
					ub <= 0;
					lb <= 0;
					we <= 0;
					next_state <= _WriteRes;
				end
			_WriteRes:
				begin
					// nothing here, just to occupy a cycle
					next_state <= _Idle;
					write_done <= 1;
				end
		endcase
	end
	
	assign data_sram = writenable ? data_write : 16'hzzzz;

endmodule
