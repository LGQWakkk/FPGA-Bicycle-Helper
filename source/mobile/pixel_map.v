`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/30 23:03:37
// Design Name: 
// Module Name: pixel_map
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

//20230608 10:47
//适用于屏幕上半部分显示的字符驱动器

module pixel_map(
	input wire [8:0] pixel_x,
	input wire [7:0] pixel_y,//由于字符只显示在屏幕的上半部分，所以模块外连线的时候只连接低8位
	input wire clk,
	input wire we,
	input wire [9:0] addr,
	input wire [6:0] din,
	output wire pixel_value,
	output wire [15:0] pixel_data//增加黑底白字输出
    );
	
	
	
	
	
	//连线建立
	wire [9:0] ram_addr;
	wire [6:0] char_addr;
	wire [3:0] row_addr;
	wire [10:0] rom_addr;
	wire [7:0] font_word;
	wire [2:0] bit_addr;
	wire font_bit;
	//布线
	assign ram_addr = {pixel_y[7:4],pixel_x[8:3]};
	assign bit_addr = pixel_x[2:0];
	assign row_addr = pixel_y[3:0];
	assign rom_addr = {char_addr,row_addr};
	assign font_bit = font_word[~bit_addr];
	assign pixel_value = font_bit;
	assign pixel_data = (pixel_value)?16'hffff:16'h0000;
	
	//模块实例化
	
	// module char_ram
// #(
	// parameter ADDR_WIDTH=12,//
	// DATA_WIDTH=7
// )
// (
	// input wire clk,
	// input wire we,
	// input wire [ADDR_WIDTH-1:0] addr_a,addr_b,//a,b地址端口
	// input wire [DATA_WIDTH-1:0] din_a,//a端口写入数据
	// output wire [DATA_WIDTH-1:0] dout_a,dout_b
    // );
	char_ram u_char_ram(
	.clk(clk),
	.we(we),
	.addr_a(addr),
	.addr_b(ram_addr),
	.din_a(din),
	.dout_a(),
	.dout_b(char_addr)
	);
	
	// module font_rom(
	// input wire clk,
	// input wire [10:0] addr,//字符地址  其中[10:4]为ASCII  [3:0]为每个字符的行数
	// output reg [7:0] data//输出字符点阵的行
    // );
	font_rom u_font_rom(
	.clk(clk),
	.addr(rom_addr),
	.data(font_word)
	);
	
endmodule
