`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/08 10:51:35
// Design Name: 
// Module Name: charmap_disp_top
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
//用于显示字符和地图的顶层模块
//20230616 15:01 添加background模块

module charmap_disp_top(
	input wire clk,rst,
	
	input wire ram_we,
	input wire [9:0] ram_addr,
	input wire [6:0] ram_data,
	
	input wire [1:0] rate,
	input wire [8:0] a,b,m,n,
	
	output wire [8:0] data_out,
	output wire rst_out,cs,rd,wr,
	
	input wire led,bell,safety,lock,rgb,
	input wire [2:0] rgb_mode
	
    );

//连接到lcd_driver的输出
wire [8:0] wire_pixel_x,wire_pixel_y;

//字符渲染模块输出
//wire [15:0] pixel_map_out;
wire pixel_value;//
wire [15:0] background_data;//背景渲染模块输出至顶层LCD驱动


//地图渲染模块输出
wire [15:0] map_top_out;

//渲染模块选择后像素输出
wire [15:0] char_map_out;

//适配pixel_map [7:0] pixel_y

// module pixel_map(
	// input wire [8:0] pixel_x,
	// input wire [7:0] pixel_y,//由于字符只显示在屏幕的上半部分，所以模块外连线的时候只连接低8位
	// input wire clk,
	// input wire we,
	// input wire [9:0] addr,
	// input wire [6:0] din,
	// output wire pixel_value,
	// output wire [15:0] pixel_data//增加黑底白字输出
    // );
	pixel_map u_pixel_map(
	.pixel_x(wire_pixel_x),
	.pixel_y(wire_pixel_y[7:0]),//Important!
	.clk(clk),
	.we(ram_we),
	.addr(ram_addr),
	.din(ram_data),
	.pixel_value(pixel_value),
	.pixel_data()//断开连接 pixel_map_out
	);

// module map_top(
	// input wire clk,rst,
	// input wire [1:0] rate,
	// input wire [8:0] pixel_x_in,//以屏幕为原点
	// input wire [8:0] pixel_y_in,
	// input wire [8:0] b_map_x,b_map_y,
	// input wire [8:0] a_map_x,a_map_y,
	// output wire [15:0] disp_data//直接输出到LCD驱动
    // );
	map_top u_map_top(
	.clk(clk),
	.rst(rst),
	.rate(rate),
	.pixel_x_in(wire_pixel_x),
	.pixel_y_in(wire_pixel_y),
	.b_map_x(a),
	.b_map_y(b),
	.a_map_x(m),
	.a_map_y(n),
	.disp_data(map_top_out)
	);
	
	//像素数据来源控制
	assign char_map_out = ((wire_pixel_y>=0)&&(wire_pixel_y<=239))?background_data:map_top_out;
	
	// module lcd_driver(
	// input wire clk,rst,
	// input wire [15:0] data_in,//输入宽度为16！
	// output wire [8:0] data_out,
	// output wire rst_out,cs,rd,wr,
	// output wire [8:0] pixel_x,
	// output wire [8:0] pixel_y
    // );
	lcd_driver u_lcd_driver(
	.clk(clk),
	.rst(rst),
	.data_in(char_map_out),
	.data_out(data_out),
	.rst_out(rst_out),
	.cs(cs),
	.rd(rd),
	.wr(wr),
	.pixel_x(wire_pixel_x),
	.pixel_y(wire_pixel_y)
	);
	
	// module background(
	// input wire font_bit,
	// input wire [8:0] pixel_x,
	// input wire [8:0] pixel_y,
	// input wire led,bell,safety,lock,rgb_on,
	// input wire [2:0] rgb_mode,
	// output wire [15:0] data
    // );
	background u_background(
	.font_bit(pixel_value),
	.pixel_x(wire_pixel_x),
	.pixel_y(wire_pixel_y),
	.led(led),
	.safety(safety),
	.bell(bell),
	.lock(lock),
	.rgb_on(rgb),
	.rgb_mode(rgb_mode),
	.data(background_data)
	);
endmodule
