`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/16 01:03:49
// Design Name: 
// Module Name: gps_ram
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


module gps_ram
#(
	parameter ADDR_WIDTH=6,//39MAX  [5:0] addr
	DATA_WIDTH=8
)
(
	input wire clk,
	input wire we,
	input wire [ADDR_WIDTH-1:0] addr_a,addr_b,//a,b地址端口
	input wire [DATA_WIDTH-1:0] din_a,//a端口写入数据
	output wire [DATA_WIDTH-1:0] dout_a,dout_b
    );
	
	reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];
	
	reg [ADDR_WIDTH-1:0] addr_a_reg,addr_b_reg;//端口地址缓存
	
	//写功能
	always@(posedge clk)begin
		if(we)begin
			ram[addr_a]<=din_a;
		end
		addr_a_reg<=addr_a;
		addr_b_reg<=addr_b;
	end
	
	//读功能
	assign dout_a=ram[addr_a_reg];
	assign dout_b=ram[addr_b_reg];
	
endmodule
