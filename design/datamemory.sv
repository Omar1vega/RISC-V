`timescale 1ns / 1ps

module datamemory#(
    parameter DM_ADDRESS = 9 ,
    parameter DATA_W = 32
    )(
    input logic clk,
	input logic MemRead , // comes from control unit
    input logic MemWrite , // Comes from control unit
	input logic [2:0] funct3,
    input logic [ DM_ADDRESS -1:0] a , // Read / Write address - 9 LSB bits of the ALU output
    input logic [ DATA_W -1:0] wd , // Write Data
    output logic [ DATA_W -1:0] rd // Read Data
    );
    
    logic [DATA_W-1:0] mem [(2**DM_ADDRESS)-1:0];

    
    always_comb 
    begin
		if(MemRead) begin
			case(funct3)
				3'b000://LB
					rd = { {24{mem[a][7]}}, mem[a][7:0]};
				3'b100://LBU
					rd = { 24'b0, mem[a][7:0]};
				3'b001://LH
					rd = { {16{mem[a][15]}}, mem[a][15:0]};
				3'b101://LHU
					rd = { 16'b0, mem[a][15:0]};
				3'b010://LW
					rd = mem[a];
			endcase
		end
	end
    
    always @(posedge clk) begin
		if (MemWrite) begin
			case(funct3)
				3'b000:
					mem[a] = wd[7:0];
				3'b001:
					mem[a] = wd[15:0];
				3'b010:
					mem[a] = wd;
			endcase
		end
    end
    
endmodule

