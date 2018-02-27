`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:53:08 03/29/2016
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
module SRAM_loader(
    input [7 : 0] switch,
    output [7 : 0] LED_out,
    output [5 : 0] LED_ctrl,
    input write,
    input read,
	 input clk,
	 inout [15 : 0] data_sram,
    output [18 : 0] addr2sram,
    output cs,
    output we,
    output oe,
    output ub,
    output lb,
	 output psram_adv,
	 output psram_cre,
	 output psram_clk,
	 input rst,
	 input rxd,
	 output enable
    );

	reg [15 : 0] address;
	wire rst_rev = ~rst;
	//wire enable;
	wire [15 : 0] address2SRAM;
	wire [15 : 0] data_write;
	wire [15 : 0] data_out;
	
	//assign enable = write | read;
	//assign enable = fifo_read | read;
	//assign enable = rec_sig | read;
	assign enable = write_sig | read;
	assign psram_adv = 1'b0;
	assign psram_cre = 1'b0;
	assign psram_clk = 1'b0;
	
	//assign address2SRAM = write ? address : {8'h00, switch};
	//assign address2SRAM = fifo_read ? address : {8'h00, switch};
	//assign address2SRAM = rec_sig ? address : {8'h00, switch};
	//assign address2SRAM = write_sig ? address : {8'h00, switch};
	assign address2SRAM = address;
	
	//assign data_write = fifo_out;//{8'h00, data_received};
	//assign data_write = {8'h00, data_received};
	assign data_write = saver;
	
	wire [7 : 0] data_received;
	wire rec_sig;
	wire frame_err;
	wire real_clk;
//	wire [15 : 0] fifo_out;
//	reg fifo_read;
//	wire fifo_empty;
//	wire fifo_full;
//	wire fifo_read_clk;
	
	// generate read signal to read from fifo
	//assign fifo_read = (~fifo_empty)&fifo_read_clk;
	
	reg half_word;
	reg write_sig;
	reg [15 : 0] saver;
	wire write_done;
	always @(posedge rec_sig)
	begin
		if (write_sig == 0)
		begin
			if (half_word == 0)
			begin
				half_word <= 1;
				saver[15 : 8] <= data_received;
			end
			else
			begin
				half_word <= 0;
				saver[7 : 0] <= data_received;
			end
		end
	end
	
	always @(posedge rec_sig or posedge write_done)
	begin
		if (write_done)
		begin
			write_sig <= 0;
		end
		else
		begin
			write_sig <= half_word;
		end
	end
	
	always @(posedge write_done)
	begin
		address <= address+1;
	end
	
	initial
	begin
		address <= 1;
		half_word <= 0;
		write_sig <= 0;
//		fifo_read <= 0;
//		read_succ <= 0;
//		asd <= 0;
//		second_timer <= 0;
	end
	
	// control the reading of fifo
//	reg [26 : 0] second_timer;
//	reg read_succ;
//	reg [3 : 0] asd;
//	always @(posedge clk)
//	begin
//		if (second_timer == 0)
//		begin
//			if (fifo_empty == 0 && asd < 15)
//			begin
//				fifo_read = 1'b1;
//				read_succ = 1'b1;
//				asd = asd+1;
//			end
//		end
//		else if (second_timer == 5)
//		begin
//			fifo_read = 1'b0;
//		end
//		else if (second_timer == 50000000)
//		begin
//			if (read_succ == 1)
//			begin
//				address = address+1;
//				read_succ = 0;
//			end
//		end
//	
//		second_timer = second_timer+1;
//		if (second_timer >= 100000000)
//		begin
//			second_timer = 0;
//		end
//	end
	
//	wire [4 : 0] data_cnt;
	
	N4_DISP
		N4_7Segment(LED_out, LED_ctrl, clk, rst_rev, {switch, data_out});

//	Anvyl_DISP
//		Anvyl7Segment(LED_out, LED_ctrl, clk, rst_rev, {switch, data_out[7 : 0], address[7 : 0]});

//	Anvyl_DISP
//		Anvyl7Segment(LED_out, LED_ctrl, clk, rst_rev, {3'b0, fifo_full, 3'b0, fifo_empty, cnt[3 : 0], data_cnt[3 : 0], address[7 : 0]});
		
//	SRAM
//		SRAM_Unit(enable, write, address2SRAM, data_write, data_out, data_sram, addr2sram, cs, we, oe, ub, lb, clk, rst_rev);
	
//	SRAM
//		SRAM_Unit(enable, fifo_read, address2SRAM, data_write, data_out, data_sram, addr2sram, cs, we, oe, ub, lb, clk, rst_rev);
		
	SRAM
		SRAM_Unit(enable, write_sig, address2SRAM, data_write, data_out, data_sram, addr2sram, cs, we, oe, ub, lb, clk, rst_rev, write_done);

	BaudRate
		UART_Baud(clk, real_clk);

	Receiver
		UART_Receiver(real_clk, rxd, data_received, rec_sig, frame_err);
		
//	FIFO
//		FIFO_Unit(rst_rev, data_received, rec_sig, fifo_out, fifo_read, fifo_empty, fifo_full, data_cnt);
		
//	FIFO_Read_Timer
//		FIFO_Read_Timer_Unit(clk, fifo_read_clk);

endmodule
