`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:50:48 03/10/2016 
// Design Name: 
// Module Name:    Control_Unit 
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
module Control_Unit(
    output reg Load_NPC,
    output reg Load_PC,
    output reg Load_IR,
    output reg Load_RegA,
    output reg Load_RegB,
    output reg Load_Imm,
    output reg WT_Reg,
	 output reg [4 : 0] Addr_Reg,
    output reg [1 : 0] Extend,
    output reg [9 : 0] Send_Reg,
    output reg Load_LMD,
    output reg Cond_Kind,
	 output reg [1 : 0] Jump_Kind,
    output reg Sel_Mux1,
    output reg Sel_Mux2,
    output reg [1 : 0] Sel_Mux4,
    output reg [3 : 0] Cal_ALU,
    output reg Write,
    output reg Load_ALU,
	 output reg Print_a0,
    input real_clk,
    input [31 : 0] IR_in,
	 input [31 : 0] syscall_v0,
    input rst,
	 output reg [2 : 0] state,
	 output reg [4 : 0] cur_ins
    );
	 
	//reg [2 : 0] state, next_state;
	//reg [4 : 0] cur_ins;
	reg [2 : 0] next_state;

	parameter
		ADD = 1,
		ADDI = 2,
		ADDIU = 3,
		ADDU = 4,
		AND = 5,
		ANDI = 6,
		BEQ = 7,
		BNE = 8,
		JAL = 9,
		JR = 10,
		J = 11,
		LW = 12,
		NOR = 13,
		OR = 14,
		ORI = 15,
		SLL = 16,
		SLT = 17,
		SLTI = 18,
		SLTU = 19,
		SRA = 20,
		SRL = 21,
		SUB = 22,
		SW = 23,
		SYS1 = 24,
		SYS10 = 25;

	parameter
		_Idle = 0,
		_IFetch = 1,
		_IDec = 2,
		_Exec = 3,
		_Mem = 4,
		_WB = 5,
		_Halt = 6;
		
	// Decoder
	always @(IR_in or rst)		// May cause a problem when IR_in == 32'b0 ?
	begin
		if (rst == 0)
		begin
			cur_ins <= 0;
		end
		else
		begin
			case (IR_in[31 : 26])
				6'b001000:	cur_ins <= ADDI;
				6'b001001:	cur_ins <= ADDIU;
				6'b001100:	cur_ins <= ANDI;
				6'b000100:	cur_ins <= BEQ;
				6'b000101:	cur_ins <= BNE;
				6'b000011:	cur_ins <= JAL;
				6'b000010:	cur_ins <= J;
				6'b100011:	cur_ins <= LW;
				6'b001101:	cur_ins <= ORI;
				6'b001010:	cur_ins <= SLTI;
				6'b101011:	cur_ins <= SW;
				6'b000000:	case (IR_in[5 : 0])
									6'b100000:	cur_ins <= ADD;
									6'b100001:	cur_ins <= ADDU;
									6'b100100:	cur_ins <= AND;
									6'b001000:	cur_ins <= JR;
									6'b100111:	cur_ins <= NOR;
									6'b100101:	cur_ins <= OR;
									6'b000000:	cur_ins <= SLL;
									6'b101010:	cur_ins <= SLT;
									6'b101011:	cur_ins <= SLTU;
									6'b000011:	cur_ins <= SRA;
									6'b000010:	cur_ins <= SRL;
									6'b100010:	cur_ins <= SUB;
									6'b001100:	case (syscall_v0)
														10:		cur_ins <= SYS10;
														default:	cur_ins <= SYS1;
													endcase
								endcase
				default:		cur_ins <= SYS10;	// in case
			endcase
		end
	end

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
			Load_RegA <= 0;
			Load_RegB <= 0;
			Load_Imm <= 0;
		end
		else if (state == _IDec)
		begin
			Load_RegA <= 1;
			Load_RegB <= 1;
			Load_Imm <= 1;
		end
		else
		begin
			Load_RegA <= 0;
			Load_RegB <= 0;
			Load_Imm <= 0;
		end
	end

	always @(state)
	begin
		case (state)
			_Idle:
				begin
					Load_NPC <= 0;
					Load_PC <= 0;
					Load_IR <= 0;
					WT_Reg <= 0;
					Addr_Reg <= 5'b0;
					Extend <= 2'b0;
					Send_Reg <= 10'b0;
					Load_LMD <= 0;
					Cond_Kind <= 0;
					Jump_Kind <= 2'b0;
					Sel_Mux1 <= 0;
					Sel_Mux2 <= 0;
					Sel_Mux4 <= 2'b0;
					Cal_ALU <= 4'b0;
					Write <= 0;
					Load_ALU <= 0;
					Print_a0 <= 0;
					next_state <= _IFetch;
				end
				
			_IFetch:
				begin
					Write <= 0;
					Load_LMD <= 0;
					WT_Reg <= 0;
					Load_PC <= 0;
					Print_a0 <= 0;
					
					next_state <= _IDec;
					Load_IR <= 1;
					Load_NPC <= 1;
				end
			
			_IDec:
				begin
					Load_IR <= 0;
					Load_NPC <= 0;
					
					if (cur_ins == SYS10)
					begin
						next_state <= _Halt;
					end
					else
					begin
						next_state <= _Exec;
					end
					
					// Print_a0
					case (cur_ins)
						SYS1:		Print_a0 <= 1;
						
						default:	Print_a0 <= 0;
					endcase
					
					// Send_Reg
					case (cur_ins)
						// rs rt
						ADD,
						ADDU,
						AND,
						BEQ,
						BNE,
						NOR,
						OR,
						SLT,
						SLTU,
						SUB,
						SW:		Send_Reg <= IR_in[25 : 16];
						
						// rs -
						ADDI,
						ADDIU,
						ANDI,
						LW,
						ORI,
						SLTI:		Send_Reg <= {IR_in[25 : 21], 5'b00000};
						
						// rt -
						SLL,
						SRA,
						SRL:		Send_Reg	<= {IR_in[20 : 16], 5'b00000};
						
						// rs - but PC via RegA, thus rs via RegB
						JR:		Send_Reg <= {5'b00000, IR_in[25 : 21]};
						
						// - -
						JAL,
						J,
						SYS1,
						SYS10:	Send_Reg <= 10'b0000000000;
						
						// - -
						default:	Send_Reg <= 10'b0000000000;
					endcase
					
					// Extend
					case (cur_ins)
						ANDI,
						ORI:		Extend <= 1;
						
						JAL,
						J:			Extend <= 2;
						
						JR,
						SLL,
						SRA,
						SRL:		Extend <= 3;
						
						default:	Extend <= 0;
					endcase
					
					// Sel_Mux1
					case (cur_ins)
						BEQ,
						BNE,
						JAL,
						JR,
						J:			Sel_Mux1 <= 1;
						
						default:	Sel_Mux1 <= 0;
					endcase
				
					// Sel_Mux2
					case (cur_ins)
						ADD,
						ADDU,
						AND,
						JR,
						NOR,
						OR,
						SLT,
						SLTU,
						SUB:		Sel_Mux2 <= 0;
						
						default:	Sel_Mux2 <= 1;
					endcase
					
					// Cal_ALU
					case (cur_ins)
						SUB:		Cal_ALU <= 1;
						
						AND,
						ANDI:		Cal_ALU <= 2;
						
						OR,
						ORI:		Cal_ALU <= 3;

						NOR:		Cal_ALU <= 4;

						SLTU:		Cal_ALU <= 5;

						SLT,
						SLTI:		Cal_ALU <= 6;

						SLL:		Cal_ALU <= 7;

						SRL:		Cal_ALU <= 8;

						SRA:		Cal_ALU <= 9;

						JAL,
						JR,
						J:			Cal_ALU <= 10;
						
						default:	Cal_ALU <= 0;
					endcase
				
					// Cond_Kind
					case (cur_ins)
						BNE:		Cond_Kind <= 1;
						
						default:	Cond_Kind <= 0;
					endcase
					
					// Jump_Kind
					case (cur_ins)
						BEQ,
						BNE:		Jump_Kind <= 2'b10;
						
						JAL,
						JR,
						J:			Jump_Kind <= 2'b11;
						
						default:	Jump_Kind <= 2'b00;
					endcase
				end
			
			_Exec:
				begin
					next_state <= _Mem;
					
					// always load
					Load_ALU <= 1;
				end
			
			_Mem:
				begin
					Load_ALU <= 0;
					Load_PC <= 1;
					
					// next_state
					case (cur_ins)
						BEQ,
						BNE,
						JR,
						J,
						SW,
						SYS1:		next_state <= _IFetch;
						
						default:	next_state <= _WB;
					endcase
					
					// Write
					case (cur_ins)
						SW:		Write <= 1;
						
						default:	Write <= 0;
					endcase
					
					// Load_LMD 
					case (cur_ins)
						LW:		Load_LMD <= 1;
						
						default: Load_LMD <= 0;
					endcase
					
					// Sel_Mux4
					case (cur_ins)
						LW:		Sel_Mux4 <= 1;
						
						JAL:		Sel_Mux4 <= 2;
						
						default:	Sel_Mux4 <= 0;
					endcase
					
					// Addr_Reg
					case (cur_ins)
						// rd
						ADD,
						ADDU,
						AND,
						NOR,
						OR,
						SLL,
						SLT,
						SLTU,
						SRA,
						SRL,
						SUB:		Addr_Reg <= IR_in[15 : 11];

						// rt
						ADDI,
						ADDIU,
						ANDI,
						LW,
						ORI,
						SLTI:		Addr_Reg <= IR_in[20 : 16];

						// RA
						JAL:		Addr_Reg <= 5'b11111;
						
						default:	Addr_Reg <= 5'b00000;
					endcase
				end
			
			_WB:		// B-kind and SW and JR and J ins won`t get there
				begin
					Write <= 0;
					Load_LMD <= 0;
					Load_PC <= 0;
					
					next_state <= _IFetch;
					
					// WT_Reg
					WT_Reg <= 1;
				end
				
			_Halt:
				begin
					next_state <= _Halt;
				end
		endcase
	end

endmodule
