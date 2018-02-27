`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:52:11 05/17/2015
// Design Name:   CPU_MIPS
// Module Name:   F:/ISE/work/cpu/cpu/cpu_test.v
// Project Name:  cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU_MIPS
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cpu_test;

	// Inputs
	reg clk;
	reg clk_click;
	reg rst;

	// Outputs
	wire [15:0] PC_out;
	wire [7:0] LED_out;
	wire [5:0] LED_ctrl;
	wire real_clk;
	wire [18:0] addr2sram;
	wire cs;
	wire we;
	wire oe;
	wire ub;
	wire lb;

	// Bidirs
	wire [15:0] data_sram;

	// Instantiate the Unit Under Test (UUT)
	CPU_MIPS uut (
		.PC_out(PC_out), 
		.LED_out(LED_out), 
		.LED_ctrl(LED_ctrl), 
		.clk(clk), 
		.clk_click(clk_click), 
		.rst(rst), 
		.real_clk(real_clk), 
		.data_sram(data_sram), 
		.addr2sram(addr2sram), 
		.cs(cs), 
		.we(we), 
		.oe(oe), 
		.ub(ub), 
		.lb(lb)
	);

	always begin
		clk = 1;
		#0.005;
		clk = 0;
		#0.005;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		clk_click = 0;
		rst = 0;
		#1;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

