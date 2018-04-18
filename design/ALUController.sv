`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: ALUController
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


module ALUController(
    
    //Inputs
    input logic [1:0] ALUOp,  //2-bit opcode field from the instruction
    input logic [6:0] Funct7, // bits 25 to 31 of the instruction
    input logic [2:0] Funct3, // bits 12 to 14 of the instruction
    
    //Output
    output logic [3:0] Operation //operation selection for ALU
);
	always @(*) begin
		case(ALUOp)
			2'b00: Operation = 4'b0010;
			
			2'b10: case ({Funct7, Funct3}) // RTYPE
				//add
                {7'b0000000,3'b000}: Operation = 4'b0010;
                //sub
                {7'b0100000,3'b000}: Operation = 4'b0110;
                //sll
                {7'b0000000,3'b001}: Operation = 4'b0011;
                //slt
                {7'b0000000,3'b010}: Operation = 4'b1000;
				//sltu
                {7'b0000000,3'b011}: Operation = 4'b1001;
				//xor
                {7'b0000000,3'b100}: Operation = 4'b0111;
				//srl
                {7'b0000000,3'b101}: Operation = 4'b0101;
				//sra
                {7'b0100000,3'b101}: Operation = 4'b0100;
				//or
                {7'b0000000,3'b110}: Operation = 4'b0001;
                //and
                {7'b0000000,3'b111}: Operation = 4'b0;
                default: 			 Operation  = 4'b0;
			endcase
			
			// Immediate Type
			2'b11: case(Funct3)
                // addi
                3'b000: Operation = 4'b0010;
                // slti
                3'b010: Operation = 4'b1000;
				// sltiu
                3'b011: Operation = 4'b1001;
				// xori
                3'b100: Operation = 4'b0111;
				// ori
                3'b110: Operation = 4'b0001;
				// andi
                3'b111: Operation = 4'b0000;
                // slli
                3'b001: Operation = 4'b0011;
				// srli or srai
                3'b101: case (Funct7)
					7'b0000000: Operation = 4'b0101;
					7'b0100000: Operation = 4'b0100;
				endcase
                default:Operation = 4'b0;
			endcase
			
			2'b01: case(Funct3)
                // beq
                3'b000: Operation = 4'b0110;
                // bne
                3'b001: Operation = 4'b0110;
                // blt bgt
                3'b100: Operation = 4'b1000;
                // bge ble
                3'b101: Operation = 4'b1010;
                // bgeu bleu
                3'b111: Operation = 4'b1011;
                // bltu
                3'b110: Operation = 4'b1001;
                default:Operation = 4'b0110;

			endcase
			
			default: Operation = 4'b0;
		endcase
	end
 
 // assign Operation[0]= (ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b110);
 // assign Operation[1]= (ALUOp==2'b00) || ((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b000)) || ((ALUOp[1]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b000));                    
 // assign Operation[2]= (ALUOp[1]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b000);
 // assign Operation[3]= 0;

endmodule
