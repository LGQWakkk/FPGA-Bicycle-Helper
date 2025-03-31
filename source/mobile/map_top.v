`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/07 22:48:32
// Design Name: 
// Module Name: map_top
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

//20230608 地图渲染模块OK 仿真通过

//map size: 240*320
//x: 0-319   [8:0]
//y: 240-479 [8:0]

//此模块只适用于屏幕下半部分！
module map_top(
	input wire clk,rst,
	input wire [1:0] rate,
	input wire [8:0] pixel_x_in,//以屏幕为原点
	input wire [8:0] pixel_y_in,
	//input wire [8:0] b_map_x_in,//自行车坐标（以地图为原点）
	//input wire [8:0] b_map_y_in,
	//input wire [8:0] a_map_x_in,//移动端坐标（以地图为原点）
	//input wire [8:0] a_map_y_in,
	input wire [8:0] b_map_x,b_map_y,
	input wire [8:0] a_map_x,a_map_y,
	
	output wire [15:0] disp_data//直接输出到LCD驱动
    );
	
	//转换成地图坐标
	// wire [8:0] b_map_x,b_map_y,a_map_x,a_map_y;
	// assign b_map_x=b_map_x_in;
	// assign b_map_y=b_map_y_in-240;
	// assign a_map_x=a_map_x_in;
	// assign a_map_y=a_map_y_in-240;
	//转换成地图坐标
	wire [8:0] pixel_x,pixel_y;
	assign pixel_x=pixel_x_in;
	assign pixel_y=pixel_y_in-240;
	
	wire [8:0] map_x_o,map_y_o;//pixel2map坐标输出
	// module pixel2map(
	// input wire [8:0] pixel_x,pixel_y,
	// input wire [8:0] m,n,//移动端地图坐标
	// input wire [1:0] rate,//地图放大倍数选择 00:1 01:2 10:4 11:8
	// output reg [8:0] map_x,map_y
    // );
	pixel2map u_pixel2map(
	.pixel_x(pixel_x),
	.pixel_y(pixel_y),
	.m(a_map_x),
	.n(a_map_y),
	.rate(rate),
	.map_x(map_x_o),
	.map_y(map_y_o)
	);
	
	// module map2bit(
	// input wire clk,rst,
	// input wire [8:0] map_x,map_y,//可能越界！
	// input wire [8:0] a,b,m,n,//可能越界！
	// output reg [15:0] data
    // );
	map2bit u_map2bit(
	.clk(clk),
	.rst(rst),
	.map_x(map_x_o),
	.map_y(map_y_o),
	.a(b_map_x),
	.b(b_map_y),
	.m(a_map_x),
	.n(a_map_y),
	.data(disp_data)
	);
	
endmodule
