`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/30 23:00:29
// Design Name: 
// Module Name: char_ram
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


//同步读双端口RAM
//A端口可读写
//B端口只读

//2023.5.30通过RTL原理图发现好像并没有被综合出块RAM
module char_ram
#(
	parameter ADDR_WIDTH=10,//
	DATA_WIDTH=7
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
