`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/16 14:15:26
// Design Name: 
// Module Name: test_button
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

//20230616 14:27 用来测试新的按钮消抖电路
module test_button(
	input wire clk,rst,
	input wire button,
	output wire [3:0] led
    );
	
	wire tick;
	
	// module button_h(
	// input clk,rst,
	// input wire button,
	// output reg tick
    // );
	button_l u_button_l(
	.clk(clk),
	.rst(rst),
	.button(button),
	.tick(tick)
	);
	
	reg [3:0] cnt_reg,cnt_next;
	assign led = cnt_reg;
	
	always@(posedge clk)begin
		if(rst)begin
			cnt_reg<=0;
		end
		else begin
			cnt_reg<=cnt_next;
		end
	end
	
	always@(*)begin
		cnt_next=cnt_reg;
		if(tick)begin
			cnt_next=cnt_reg+1;
		end
	end
	
endmodule
