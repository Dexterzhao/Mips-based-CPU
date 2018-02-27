`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:23:29 04/16/2016
// Design Name: 
// Module Name:    UART 
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
module UART(
    input clk,
	 input rxd,
	 output txd,
	 output rec_sig,
    output frame_err
    );
	 
	reg [19 : 0] second_timer;
	reg test_clk;
	
	initial
	begin
		second_timer = 0;
	end

	always @(posedge clk)
	begin
		second_timer = second_timer+1;
		if (second_timer >= 1000000)
		begin
			second_timer = 0;
		end
		if (second_timer < 500000)
		begin
			test_clk = 1'b1;
		end
		else
		begin
			test_clk = 1'b0;
		end
	end

	wire [7 : 0] data_received;
	wire real_clk, idle;
	
	BaudRate
		Baud_Unit(clk, real_clk);
		
	Receiver
		Receiver_Unit(real_clk, rxd, data_received, rec_sig, frame_err);
		
	Transmitter
		Transmitter_Unit(real_clk, data_received, test_clk, idle, txd);

endmodule
