`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:51:33 05/14/2015 
// Design Name: 
// Module Name:    FIFO 
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
module FIFO(
	 input rst,
    input [7 : 0] data_in,
    input en_write,
    output reg [15 : 0] data_out,
    input en_read,
    output empty,
    output full,
	 output data_cnt
    );
	 
	reg [3 : 0] head;
	reg [3 : 0] tail;
	reg tail_halfword;
	reg [15 : 0] fifo[15 : 0];
	reg [4 : 0] data_cnt;
	
	assign empty = (data_cnt == 0) ? 1 : 0;
	assign full = (data_cnt == 16) ? 1 : 0;
	
	initial
	begin
		head = 0;
		tail = 1;
		data_cnt = 1;
		fifo[0] = 16'h21ff;
	end

	always @(posedge en_read or negedge rst)
	begin
		if (rst == 0)
		begin
			head = 0;
		end
		else
		begin
			data_out = fifo[head];
			head = head+1;
			if (head == 16)
			begin
				head = 0;
			end
		end
	end
	
	always @(posedge en_write or negedge rst)
	begin
		if (rst == 0)
		begin
			tail = 0;
			tail_halfword = 0;
		end
		else
		begin
			if (tail_halfword == 1)
			begin
				fifo[tail][7 : 0] = data_in;
				tail = tail+1;
				if (tail == 16)
				begin
					tail = 0;
				end
				tail_halfword = 0;
			end
			else
			begin
				fifo[tail][15 : 8] = data_in;
				tail_halfword = 1;
			end
		end
	end

	// fuck, en_read always be 1
	always @(posedge en_read or posedge en_write or negedge rst)
	begin
		if (rst == 0)
		begin
			data_cnt = 0;
		end
		else if (en_read == 1)
		begin
			data_cnt = data_cnt-1;
		end
		else
		begin
			if (tail_halfword == 1)
			begin
				data_cnt = data_cnt+1;
			end
		end
	end
endmodule
