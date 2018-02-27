`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:18:58 04/16/2015 
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
    input [31 : 0] data_write,
    output reg [31 : 0] data_read,
    inout [15 : 0] data_sram,
    output reg [22 : 0] addr2sram,
    output reg cs,
    output reg we,
    output reg oe,
    output reg ub,
    output reg lb,
	 input clk,
    input rst,
	 output reg write_done,
	 output reg read_done
    );
	 
	reg real_clk;
	reg [10 : 0] second_timer;
	reg [15 : 0] data_write16;
	
	always @(posedge clk or negedge rst)
	begin
		if (rst == 0)
		begin
			second_timer <= 0;
		end
		else
		begin
			second_timer <= second_timer+1;
			if (second_timer >= 8)
			begin
				second_timer <= 0;
				real_clk <= 1'b1;
			end
			if (second_timer < 4)
			begin
				real_clk <= 1'b1;
			end
			else
			begin
				real_clk <= 1'b0;
			end
		end
	end
	
	reg [3 : 0] state;
	reg [3 : 0] next_state;
	
	parameter
		_Idle = 0,
		_IdleJmp = 1,	// the reason comes that state must be changed or @(state) will never be activated
		_Read0 = 2,
		_Read1 = 3,
		_Read2 = 4,
		_Read3 = 5,
		_Read4 = 6,
		_Write0 = 8,
		_Write1 = 9,
		_Write2 = 10,
		_Write3 = 11;
	
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
	
	always @(negedge real_clk or negedge rst)
	begin
		if (rst == 0)
		begin
			read_done <= 0;
			write_done <= 0;
		end
		else if (state == _Read4)
		begin
			read_done <= 1;
			write_done <= 0;
		end
		else if (state == _Write3)
		begin
			read_done <= 0;
			write_done <= 1;
		end
		else
		begin
			read_done <= 0;
			write_done <= 0;
		end
	end
	
	always @(state)
	begin
		case (state)
			_Idle:
				begin
					addr2sram <= {7'b0000001, 16'hffff};
					cs <= 1'b1;
					we <= 1'b1;
					oe <= 1'b1;
					ub <= 1'b1;
					lb <= 1'b1;
					if (enable == 1'b1)
					begin
						if (writenable == 1'b1)
						begin
							next_state <= _Write0;
						end
						else
						begin
							next_state <= _Read0;
						end
					end
					else
					begin
						next_state <= _IdleJmp;
					end
				end
			_IdleJmp:	// very important
				begin
					if (enable == 1'b1)
					begin
						if (writenable == 1'b1)
						begin
							next_state <= _Write0;
						end
						else
						begin
							next_state <= _Read0;
						end
					end
					else
					begin
						next_state <= _Idle;
					end
				end
			_Read0:
				begin
					addr2sram <= {7'b0000000, address};
					cs <= 1'b0;
					we <= 1'b1;
					ub <= 1'b0;
					lb <= 1'b0;
					oe <= 1'b0;
					next_state <= _Read1;
				end
			_Read1:
				begin
					data_read[31 : 16] <= data_sram;
					next_state <= _Read2;
				end
			_Read2:
				begin
					cs <= 1'b1;
					we <= 1'b1;
					oe <= 1'b1;
					ub <= 1'b1;
					lb <= 1'b1;
					next_state <= _Read3;
				end
			_Read3:
				begin
					addr2sram <= {7'b0000000, address+1'b1};
					cs <= 1'b0;
					we <= 1'b1;
					ub <= 1'b0;
					lb <= 1'b0;
					oe <= 1'b0;
					next_state <= _Read4;
				end
			_Read4:
				begin
					data_read[15 : 0] <= data_sram;
					next_state <= _Idle;
				end
			_Write0:
				begin
					addr2sram <= {7'b0000000, address};
					next_state <= _Write1;
				end
			_Write1:
				begin
					cs <= 1'b0;
					we <= 1'b0;
					ub <= 1'b0;
					lb <= 1'b0;
					oe <= 1'b1;
					data_write16 <= data_write[31 : 16];
					next_state <= _Write2;
				end
			_Write2:
				begin
					addr2sram <= {7'b0000000, address+1'b1};
					cs <= 1'b1;
					we <= 1'b1;
					oe <= 1'b1;
					ub <= 1'b1;
					lb <= 1'b1;
					next_state <= _Write3;
				end
			_Write3:
				begin
					cs <= 1'b0;
					we <= 1'b0;
					ub <= 1'b0;
					lb <= 1'b0;
					oe <= 1'b1;
					data_write16 <= data_write[15 : 0];
					next_state <= _Idle;
				end
		endcase
	end
	
	assign data_sram = oe ? data_write16 : 16'hzzzz;

endmodule
