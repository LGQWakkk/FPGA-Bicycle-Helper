`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/16 13:14:53
// Design Name: 
// Module Name: edge_detect
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

//上升沿检测器 V1

module edge_detect(
	input wire clk,rst,
	input wire level,
	output reg tick
    );
	
	localparam[1:0] 
	zero = 2'b00,
	edg = 2'b01,
	one = 2'b10;
	
	reg [1:0] state_reg,state_next;
	
	always@(posedge clk)begin
		if(rst)begin
			state_reg<=zero;
		end
		else begin
			state_reg<=state_next;
		end
	end
	
	always@(*)begin
		state_next=state_reg;
		tick=1'b0;
		case(state_reg)
			zero:begin
				if(level)begin
					state_next=edg;
				end
			end
			edg:begin
				tick=1'b1;
				if(level)begin
					state_next=one;
				end
				else begin
					state_next=zero;
				end
			end
			one:begin
				if(~level)begin
					state_next=zero;
				end
			end
			default:begin
				state_next=zero;
			end
		endcase
	end
endmodule
