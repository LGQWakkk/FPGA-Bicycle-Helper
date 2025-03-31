`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/17 18:42:51
// Design Name: 
// Module Name: EC11
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

//20230617 19:05 测试成功

module EC11(
	input wire clk,rst,
	input wire s1,s2,
	output wire [2:0] value,
	output reg r_tick,l_tick
    );
	
	reg [2:0] value_reg,value_next;
	wire s2_posedge;
	assign value = value_reg;
	// module db_posedge_detect(
	// input clk,rst,
	// input wire button,
	// output reg tick
    // );
	db_posedge_detect u_s2(
	.clk(clk),
	.rst(rst),
	.button(s2),
	.tick(s2_posedge)
	);
	
	always@(posedge clk)begin
		if(rst)begin
			value_reg<=0;
		end
		else begin
			value_reg<=value_next;
		end
	end
	
	always@(*)begin
		value_next=value_reg;
		r_tick=1'b0;
		l_tick=1'b0;
		if(s2_posedge)begin
			if(s1)begin
				value_next=value_reg-1;
				l_tick=1'b1;
			end
			else begin
				value_next=value_reg+1;
				r_tick=1'b1;
			end
		end
	end
	
	
endmodule
