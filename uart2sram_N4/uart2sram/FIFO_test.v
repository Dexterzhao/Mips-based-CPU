`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:50:37 05/14/2015
// Design Name:   FIFO
// Module Name:   F:/ISE/work/uart2sram/uart2sram/FIFO_test.v
// Project Name:  uart2sram
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FIFO
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FIFO_test;

	// Inputs
	reg rst;
	reg [7:0] data_in;
	reg en_write;
	reg en_read;
	wire empty;
	wire full;
	wire [4:0] data_cnt;

	// Outputs
	wire [15:0] data_out;

	// Instantiate the Unit Under Test (UUT)
	FIFO uut (
		.rst(rst), 
		.data_in(data_in), 
		.en_write(en_write), 
		.data_out(data_out), 
		.en_read(en_read), 
		.empty(empty), 
		.full(full),
		.data_cnt(data_cnt)
	);

	initial begin
		// Initialize Inputs
		rst = 1;
		data_in = 0;
		en_write = 0;
		en_read = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst = 1;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 45;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 76;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 89;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 65;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		data_in = 21;
		en_write = 1;
		#50;
		en_write = 0;
		#50;
		
		en_read = 1;
		#50;
		en_read = 0;
		#50;
		en_read = 1;
		#50;
		en_read = 0;
		
		en_read = 1;
		#50;
		data_in = 255;
		en_write = 1;
        
		// Add stimulus here

	end
      
endmodule

