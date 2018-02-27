`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:32:54 03/12/2016
// Design Name: 
// Module Name:    CPU_MIPS 
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
module CPU_MIPS(
	 output [7 : 0] LED_out,
	 output [7 : 0] LED_ctrl,
	 input clk,
	 input rst,
	 output reg real_clk,
	 inout [15 : 0] data_sram,
	 output [22 : 0] addr2sram,
	 output cs,
    output we,
    output oe,
    output ub,
    output lb,
	 output psram_adv,
	 output psram_cre,
	 output psram_clk,
	 input led_switch
    );
	
	assign psram_adv = 0;
	assign psram_cre = 0;
	assign psram_clk = 0;
	
	wire [2 : 0] state;
	wire [4 : 0] cur_ins;
	
	reg [31 : 0] second_timer;
	
	always @(posedge clk or negedge rst)
	begin
		if (rst == 0)
		begin
			second_timer <= 0;
		end
		else
		begin
			second_timer <= second_timer+1;
			if (second_timer >= 1200000)
			begin
				second_timer <= 0;
				real_clk <= 1'b1;
			end
			if (second_timer < 600000)
			begin
				real_clk <= 1'b1;
			end
			else
			begin
				real_clk <= 1'b0;
			end
		end
	end

	wire Cond;
	wire Judge;
	wire [31 : 0] PC;
	wire [31 : 0] NPC;
	wire [31 : 0] IR;
	wire [31 : 0] RegA;
	wire [31 : 0] RegB;
	wire [31 : 0] Imm;
	wire [31 : 0] ALUOut;
	wire [31 : 0] LMD;
	wire [31 : 0] Mux1Out;
	wire [31 : 0] Mux2Out;
	wire [31 : 0] Mux3Out;
	wire [31 : 0] Mux4Out;
	wire [31 : 0] ALUReg;
	wire [31 : 0] AdderOut;
	wire [31 : 0] RegOutA;
	wire [31 : 0] RegOutB;
	wire [31 : 0] ImmExt;
	
	wire Load_NPC;
	wire Load_PC;
	wire Load_IR;
	wire Load_RegA;
	wire Load_RegB;
	wire Load_Imm;
	wire WT_Reg;
	wire [4 : 0] Addr_Reg;
	wire [1 : 0] Extend;
	wire [9 : 0] Send_Reg;
	wire Load_LMD;
	wire Cond_Kind;
	wire [1 : 0] Jump_Kind;
	wire Sel_Mux1;
	wire Sel_Mux2;
	wire [1 : 0] Sel_Mux4;
	wire [3 : 0] Cal_ALU;
	wire Write;
	wire Load_ALU;
	
	wire enable_sram;
	reg read_sram;
	reg write_sram;
	wire [31 : 0] address2SRAM;
	wire [31 : 0] sram_data_write;
	wire [31 : 0] sram_data_out;
	wire sram_write_done;
	wire sram_read_done;
	wire real_Load_IR;
	wire real_Load_LMD;
	
	wire [31 : 0] dat_address;
	wire [31 : 0] syscall_v0;
	wire [31 : 0] syscall_a0;
	wire Print_a0;
	
	assign enable_sram = read_sram | write_sram;
	assign real_Load_IR = Load_IR & sram_read_done;
	assign real_Load_LMD = Load_LMD & sram_read_done;
	assign address2SRAM = Load_IR ? ((PC<<1)+32'h00000001) : ((ALUReg<<1)+32'h00400001);
	assign sram_data_write = RegB;
	
	always @(posedge Load_IR or posedge Load_LMD or posedge sram_read_done)
	begin
		if (sram_read_done)
		begin
			read_sram <= 0;
		end
		else if (Load_IR)
		begin
			read_sram <= 1;
		end
		else
		begin
			read_sram <= 1;
		end
	end
	
	always @(posedge Write or posedge sram_write_done)
	begin
		if (sram_write_done)
		begin
			write_sram <= 0;
		end
		else
		begin
			write_sram <= 1;
		end
	end
	
	wire [31 : 0] led_content;
	assign led_content = led_switch ? {PC[7 : 0], 5'b0, state, Mux4Out[7 : 0], ALUOut[7 : 0]} : syscall_a0;
	
	N4_DISP
		N4_7Segment(LED_out, LED_ctrl, clk, rst, led_content);
	
	Load_Rst_Module
		PC_Unit(PC,	Load_PC, Mux3Out, rst),
		IR_Unit(IR, real_Load_IR, sram_data_out, rst),
		NPC_Unit(NPC, Load_NPC, AdderOut, rst),
		RegA_Unit(RegA, Load_RegA, RegOutA, rst),
		RegB_Unit(RegB, Load_RegB, RegOutB, rst),
		Imm_Unit(Imm, Load_Imm, ImmExt, rst),
		ALUOut_Unit(ALUReg, Load_ALU, ALUOut, rst),
		LMD_Unit(LMD, real_Load_LMD, sram_data_out, rst);
		
	PC_Adder
		Adder_Unit(AdderOut, PC);
	
	Register_Group
		Reg_Gp_Unit(RegOutA, RegOutB, syscall_v0, syscall_a0, WT_Reg, Addr_Reg, Send_Reg, Mux4Out, Print_a0);
		
	Immediate_Extend
		ImmExt_Unit(ImmExt, Extend, IR);
		
	Mux_Sel
		Mux1(Mux1Out, RegA, NPC, Sel_Mux1),
		Mux2(Mux2Out, RegB, Imm, Sel_Mux2),
		Mux3(Mux3Out, NPC, ALUReg, Cond);
		
	Arithmetic_Logic_Unit
		ALU_Unit(ALUOut, Cal_ALU, Mux1Out, Mux2Out);
		
	Condition_Judge
		Jdg_Unit(Judge, Cond_Kind, RegA, RegB);
		
	Condition
		Cond_Unit(Cond, Jump_Kind, Judge);
		
	Mux_Sel3
		Mux4(Mux4Out, ALUReg, LMD, NPC, Sel_Mux4);
		
	Control_Unit
		Ctrl_Unit(Load_NPC, Load_PC, Load_IR, Load_RegA, Load_RegB, Load_Imm, WT_Reg, Addr_Reg, Extend, Send_Reg, Load_LMD, Cond_Kind, Jump_Kind,
						Sel_Mux1, Sel_Mux2, Sel_Mux4, Cal_ALU, Write, Load_ALU, Print_a0, real_clk, IR, syscall_v0, rst, state, cur_ins);
	
	SRAM
		SRAM_Unit(enable_sram, write_sram, address2SRAM, sram_data_write, sram_data_out, data_sram, addr2sram, cs, we, oe, ub, lb, clk, rst, sram_write_done, sram_read_done);

endmodule
