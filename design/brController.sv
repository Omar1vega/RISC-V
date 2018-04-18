`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:21:50 PM
// Design Name: 
// Module Name: brController
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


module brController
    #(parameter WIDTH = 32)
    (input logic [2:0] Funct3,
	 input logic branch, jump,
	 input logic [WIDTH-1:0] aluResult,
     output logic y
	);
	
	always @(*) begin
		case(Funct3)
			3'b0: y = jump || (branch && (aluResult == 32'b0));
			3'b1: y = jump || (branch && (aluResult != 32'b0));
			default : y = branch && aluResult;
		endcase
	end
endmodule
