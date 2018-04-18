`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:21:50 PM
// Design Name: 
// Module Name: WBController
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////////


module WBController
    #(parameter WIDTH = 32)
    (input logic [7-1:0] Opcode,
	 input logic [9-1:0] PCPlus4,
	 input logic [9-1:0] PCPlusImm,
	 input logic [WIDTH-1:0] data_mem,
	 input logic [WIDTH-1:0] aluResult,
	 input logic [WIDTH-1:0] imm_ext,
     output logic [WIDTH-1 :0] data
	);
	logic [6:0] R_TYPE, LW, SW, RTypeI, BR, JALR, JAL, LUI, AUIPC;
    
    assign  R_TYPE = 7'b0110011;
    assign  LW     = 7'b0000011;
    assign  SW     = 7'b0100011;
    assign  RTypeI = 7'b0010011;
	assign  BR     = 7'b1100011; 
	assign	JALR   = 7'b1100111;
	assign	JAL	   = 7'b1101111;
	assign  LUI	   = 7'b0110111;
	assign AUIPC   = 7'b0010111;
	
	always @(*) begin
		case(Opcode)
			JAL : data = { {23{PCPlus4[8]}}, PCPlus4};
			JALR: data = { {23{PCPlus4[8]}}, PCPlus4};
			LUI : data = imm_ext;
			AUIPC:data = aluResult;
			LW :  data = data_mem;
			
			
			
			default : data = aluResult;
		endcase
	end
endmodule
