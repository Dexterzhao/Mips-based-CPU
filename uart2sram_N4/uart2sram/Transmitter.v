`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:24:41 04/16/2015 
// Design Name: 
// Module Name:    Transmitter 
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
module Transmitter(
    input clk,
	 input [7 : 0] data_in,
	 input send_sig,
	 output reg idle,
	 output reg txd
    );

	reg send, send_sig_buf, send_sig_rise, result;
	reg [7 : 0] cnt;
	
	//reg [7 : 0] data_in = 0;
	
	parameter parity_mode = 1'b0;

	always @(posedge clk)	// posedge of send_sig
	begin
		send_sig_buf <= send_sig;
		send_sig_rise <= (~send_sig_buf) & send_sig;	// to get a posedge
	end
	
	always @(posedge clk)
	begin
		if (send_sig_rise &&  (~idle))  // when send_sig is posedge and txd is idle, send data
		begin
			send <= 1'b1;
		end
		else if(cnt == 8'd160)      // transmition over of a frame
		begin
			send <= 1'b0;
		end
	end
	
	always @(posedge clk)
	begin
		if(send == 1'b1)
		begin
			case(cnt)       					// start bit
				8'd0:
					begin
						txd <= 1'b0;
						idle <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd16:
					begin
						txd <= data_in[0];   // 0 bit
						result <= data_in[0]^parity_mode;
						idle <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd32:
					begin
						txd <= data_in[1];   // 1 bit
						result <= data_in[1]^result;
						idle <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd48:
					begin
						txd <= data_in[2];   // 2 bit
						result <= data_in[2]^result;
						idle <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd64:
					begin
						txd <= data_in[3];   // 3 bit
						result <= data_in[3]^result;
						idle <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd80:
					begin
						txd <= data_in[4];   // 4 bit
						result <= data_in[4]^result;
						idle <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd96:
					begin
						txd <= data_in[5];   // 5 bit
						result <= data_in[5]^result;
						idle <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd112:
					begin
						txd <= data_in[6];   // 6 bit
						result <= data_in[6]^result;
						idle <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd128:
					begin
						txd <= data_in[7];   // 7 bit
						result <= data_in[7]^result;
						idle <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd144:
					begin
						txd <= 1'b1;     		// stop bit         
						idle <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd160:
					begin
						txd <= 1'b1;             
						idle <= 1'b0;   		// a frame over
						cnt <= cnt + 8'd1;
						//data_in <= data_in+1;
					end
				default:
					begin
						cnt <= cnt + 8'd1;
					end
			endcase
		end
		else
		begin
			txd <= 1'b1;
			cnt <= 8'd0;
			idle <= 1'b0;
		end
	end

endmodule
