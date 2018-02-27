`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:55:08 05/16/2015
// Design Name:   SRAM_loader
// Module Name:   F:/ISE/work/uart2sram/uart2sram/loader_test.v
// Project Name:  uart2sram
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SRAM_loader
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module loader_test;

	// Inputs
	reg [7:0] switch;
	reg write;
	reg read;
	reg clk;
	reg rst;
	reg rxd;

	// Outputs
	wire [7:0] LED_out;
	wire [5:0] LED_ctrl;
	wire [18:0] addr2sram;
	wire cs;
	wire we;
	wire oe;
	wire ub;
	wire lb;
	wire enable;

	// Bidirs
	wire [15:0] data_sram;

	// Instantiate the Unit Under Test (UUT)
	SRAM_loader uut (
		.switch(switch), 
		.LED_out(LED_out), 
		.LED_ctrl(LED_ctrl), 
		.write(write), 
		.read(read), 
		.clk(clk), 
		.data_sram(data_sram), 
		.addr2sram(addr2sram), 
		.cs(cs), 
		.we(we), 
		.oe(oe), 
		.ub(ub), 
		.lb(lb), 
		.rst(rst), 
		.rxd(rxd), 
		.enable(enable)
	);
	
	always begin
		clk = 1;
		#0.5;
		clk = 0;
		#0.5;
	end

	initial begin
		// Initialize Inputs
		switch = 0;
		write = 0;
		read = 0;
		clk = 0;
		rst = 0;
		rxd = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

