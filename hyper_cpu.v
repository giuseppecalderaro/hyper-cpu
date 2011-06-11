`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:54:08 06/11/2011 
// Design Name: 
// Module Name:    hyper_cpu 
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
module hyper_cpu
	#(
		parameter DATA_WIDTH = 16
	)
	(
		/* System clock and reset.  */
		input wire clk,
		input wire rst,
		/* Program counter.  */
		output wire[DATA_WIDTH - 1:0] pc_out
    );

`include "functions.v"

localparam PIPELINE_STATES	= 4;
localparam OPCODE_SIZE		= 4;
localparam REG_SIZE			= 4;
localparam IMM_SIZE			= 8;

/* CPU Regs.  */
localparam r0					= 0;
localparam r1					= 1;
localparam sp					= 13;
localparam lr					= 14;
localparam pc					= 15;

/* CPU states.  */
localparam[log2(PIPELINE_STATES) - 1:0]	
						fetch 	= 2'b00,
						decode	= 2'b01,
						execute	= 2'b10,
						store		= 2'b11;	 

/* Mnemonic op codes.  */
localparam[OPCODE_SIZE - 1:0]
						LRI	= 4'b0001,
						ADD	= 4'b0100,
						OR		= 4'b0110,
						XOR	= 4'b0111,
						HALT	= 4'b0000;
						
/* States reg.  */
reg[log2(PIPELINE_STATES) - 1:0] state_reg;

/* CPU regs.  */
reg[DATA_WIDTH - 1:0] regfile[0:(2 ** REG_SIZE) - 1];

/* Internal CPU regs.  */
reg[DATA_WIDTH - 1:0] ir;
reg[OPCODE_SIZE - 1:0] opcode;
reg[REG_SIZE - 1:0] ra, rb, rd;

/* Temp reg.  */
reg[DATA_WIDTH - 1:0] w;

/* Memory (waiting for SDRAM/SRAM controller).  */
/* It should be memory[0:(2 ** DATA_WIDTH) - 1];  */
reg[DATA_WIDTH - 1:0] memory[0:15];

always @(posedge clk, posedge rst) begin
	if (rst) begin
		/* CPU start fetching from zero.  */
		state_reg <= fetch;
		regfile[pc] <= 0;
	end else begin
		case (state_reg)
			fetch:
				begin
					ir <= memory[regfile[pc]];
					state_reg <= decode;
				end
			decode:
				begin
					/* Instruction decoding.  */
					opcode <= ir[OPCODE_SIZE + (REG_SIZE * 3) - 1 : (REG_SIZE * 3)];
					ra <= ir[(REG_SIZE * 3) - 1 : (2 * REG_SIZE)];
					rb <= ir[(REG_SIZE * 2) - 1 : REG_SIZE];
					rd <= ir[REG_SIZE - 1 : 0];
					/* Next state logic.  */
					regfile[pc] <= regfile[pc] + 1;
					state_reg <= execute;
				end
			execute:
				begin
					case (opcode)
						LRI:
							begin
								w <= { ra, rb };
								state_reg <= store;
							end
						ADD:
							begin
								w <= regfile[ra] + regfile[rb];
								state_reg <= store;
							end
						OR:
							begin
								w <= regfile[ra] | regfile[rb];
								state_reg <= store;
							end
						XOR:
							begin
								w <= regfile[ra] ^ regfile[rb];
								state_reg <= store;
							end
						HALT:
							begin
								/* Halt execution, loop indefinitely.  */
								state_reg <= execute;
							end
						default:
							begin
								/* No-op.  */
							end
					endcase
				end
			store:
				begin
					regfile[rd] <= w;
					state_reg <= fetch;
				end
			default:
				begin
					/* Invalid state.  */
				end
		endcase
	end
end

assign pc_out = regfile[pc];

initial begin
	memory[0] = { LRI, 4'd00, 4'd00, 4'd00 };
	memory[1] = { LRI, 4'd00, 4'd00, 4'd01 };
	memory[2] = { LRI, 4'd00, 4'd00, 4'd02 };
	memory[3] = { LRI, 4'd00, 4'd00, 4'd03 };
	memory[4] = { LRI, 4'd02, 4'd04, 4'd01 };
	memory[5] = { LRI, 4'd01, 4'd11, 4'd02 };
	memory[6] = { ADD, 4'd01, 4'd02, 4'd03 };
	memory[7] = { HALT, 12'd0 };
end

endmodule
