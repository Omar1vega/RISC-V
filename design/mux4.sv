`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:21:50 PM
// Design Name: 
// Module Name: mux2
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


module mux4
    #(parameter WIDTH = 32)
    (input logic [WIDTH-1:0] d0, d1, d2, d3,
     input logic [1:0] s,
     output logic [WIDTH-1:0] y);
	 
always_comb
	case(s)
		2'b00:
			y = d0;
		2'b01:
			y = d1;
		2'b10:
			y = d2;
		2'b11:
			y = d3;
	endcase
			

endmodule
