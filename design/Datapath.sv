`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: Datapath
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
//////////////////////////////////////////////////////////////////////////////////

module Datapath #(
    parameter PC_W = 9, // Program Counter
    parameter INS_W = 32, // Instruction Width
    parameter RF_ADDRESS = 5, // Register File Address
    parameter DATA_W = 32, // Data WriteData
    parameter DM_ADDRESS = 9, // Data Memory Address
    parameter ALU_CC_W = 4 // ALU Control Code Width
    )(
    input logic clk , reset , // global clock
                              // reset , sets the PC to zero
    RegWrite , MemtoReg ,     // Register file writing enable   // Memory or ALU MUX
    ALUsrc , MemWrite ,       // Register file or Immediate MUX // Memroy Writing Enable
    MemRead , Branch, Jump, Jalr,               // Memroy Reading Enable
    input logic [ ALU_CC_W -1:0] ALU_CC, // ALU Control Code ( input of the ALU )
    output logic [6:0] opcode,
    output logic [6:0] Funct7,
    output logic [2:0] Funct3,
    output logic [DATA_W-1:0] WB_Data //ALU_Result
    );

logic [PC_W-1:0] PC, PCPlus4, PCPlusImm, PCSource;
logic [INS_W-1:0] Instr;
logic [DATA_W-1:0] Result;
logic [DATA_W-1:0] Reg1, Reg2;
logic [DATA_W-1:0] ReadData;
logic [DATA_W-1:0] SrcB, ALUResult;
logic [DATA_W-1:0] ExtImm;
logic [DATA_W-1:0] wbData;
logic BranchTaken;

//WB
	WBController wbc (opcode, PCPlus4, PCPlusImm, ReadData, ALUResult,ExtImm, Result);
	
// next PC
	adder #(9) pcadd (PC, 9'b100, PCPlus4);
	adder #(9) pcImm (PC, ExtImm[8:0], PCPlusImm);
	
	brController#(32) branchT(Funct3, Branch, Jump, ALUResult, BranchTaken);
	//mux2 #(9) pcChooser(PCPlus4, PCPlusImm, BranchTaken, PCSource);
	mux4 #(9) pcChooser(PCPlus4, PCPlusImm, ALUResult[8:0], 9'b0, {Jalr, BranchTaken}, PCSource);
	flopr #(9) pcreg(clk, reset, PCSource, PC);

//Instruction memory
	instructionmemory instr_mem (PC, Instr);
	
	assign opcode = Instr[6:0];
	assign Funct7 = Instr[31:25];
	assign Funct3 = Instr[14:12]; 
//Register File
    RegFile rf(clk, reset, RegWrite, Instr[11:7], Instr[19:15], Instr[24:20],Result, Reg1, Reg2);
    //mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, Result);
  
//// sign extend
    imm_Gen Ext_Imm (Instr,ExtImm);

// ALU
    mux2 #(32) srcbmux(Reg2, ExtImm, ALUsrc, SrcB);
    alu alu_module(Reg1, SrcB, ALU_CC, ALUResult);
    
    assign WB_Data = Result;
    
////// Data memory 
	datamemory data_mem (clk, MemRead, MemWrite, Funct3, ALUResult[DM_ADDRESS-1:0], Reg2, ReadData);
     
endmodule