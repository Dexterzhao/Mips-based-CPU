`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:24:30 04/16/2016 
// Design Name: 
// Module Name:    Receiver 
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
module Receiver(
    input clk,
	 input rxd,
	 output reg [7 : 0] data_out,
	 output reg rec_sig,
	 output reg frame_err
    );

	reg [7 : 0] cnt;
	reg rec, rec_sig_buf, rec_sig_fall, result, idle;
	
	parameter parity_mode = 1'b0;

	always @(posedge clk)   // negedge of rxd wire
	begin
		rec_sig_buf <= rxd;
		rec_sig_fall <= rec_sig_buf & (~rxd);
	end
	
	always @(posedge clk)
	begin
		if (rec_sig_fall && (~idle))  	// when rxd is negedge and rxd is idle, receive data
		begin
			rec <= 1'b1;
		end
		else if(cnt == 8'd160)  			// receive done
		begin
			rec <= 1'b0;
		end
	end
	
	always @(posedge clk)
	begin
		if(rec == 1'b1)
		begin
			case (cnt)
				8'd0:								// start bit
					begin
						idle <= 1'b1;
						cnt <= cnt + 8'd1;
						rec_sig <= 1'b0;
					end
				8'd24:  							// 0 bit
					begin
						idle <= 1'b1;
						data_out[0] <= rxd;
						result <= parity_mode^rxd;
						cnt <= cnt + 8'd1;
						rec_sig <= 1'b0;
					end
				8'd40: 							// 1 bit
					begin
						idle <= 1'b1;
						data_out[1] <= rxd;
						result <= result^rxd;
						cnt <= cnt + 8'd1;
						rec_sig <= 1'b0;
					end
				8'd56: 							// 2 bit
					begin
						idle <= 1'b1;
						data_out[2] <= rxd;
						result <= result^rxd;
						cnt <= cnt + 8'd1;
						rec_sig <= 1'b0;
					end
				8'd72: 							// 3 bit
					begin
						idle <= 1'b1;
						data_out[3] <= rxd;
						result <= result^rxd;
						cnt <= cnt + 8'd1;
						rec_sig <= 1'b0;
					end
				8'd88: 							// 4 bit
					begin
						idle <= 1'b1;
						data_out[4] <= rxd;
						result <= result^rxd;
						cnt <= cnt + 8'd1;
						rec_sig <= 1'b0;
					end
				8'd104: 							// 5 bit
					begin
						idle <= 1'b1;
						data_out[5] <= rxd;
						result <= result^rxd;
						cnt <= cnt + 8'd1;
						rec_sig <= 1'b0;
					end
				8'd120:     					// 6 bit
					begin
						idle <= 1'b1;
						data_out[6] <= rxd;
						result <= result^rxd;
						cnt <= cnt + 8'd1;
						rec_sig <= 1'b0;
					end
				8'd136:     					// 7 bit
					begin
						idle <= 1'b1;
						data_out[7] <= rxd;
						result <= result^rxd;
						cnt <= cnt + 8'd1;
						rec_sig <= 1'b0;
					end
				8'd152:
					begin
						idle <= 1'b1;
						if(1'b1 == rxd)
						begin
							frame_err <= 1'b0;
						end
						else
						begin
							frame_err <= 1'b1;     // error is stop bit cannot be received
						end
						cnt <= cnt + 8'd1;
						rec_sig <= 1'b1;
					end
				default:
					begin
						cnt <= cnt + 8'd1;
					end
			endcase
		end
		else
		begin
			cnt <= 8'd0;
			idle <= 1'b0;
			rec_sig <= 1'b0;
		end
	end

endmodule
