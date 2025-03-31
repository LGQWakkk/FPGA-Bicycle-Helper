`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/07 22:47:49
// Design Name: 
// Module Name: pixel2map
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
//20230608 10:25 V1 仿真通过

//注意：此模块输入的是地图坐标！！！

module pixel2map(
	input wire [8:0] pixel_x,pixel_y,
	input wire [8:0] m,n,//移动端地图坐标
	input wire [1:0] rate,//地图放大倍数选择 00:1 01:2 10:4 11:8
	output reg [8:0] map_x,map_y
    );
	
	always@(*)begin
		case(rate)
			2'd0:begin//1
				map_x=pixel_x[8:0]+m-160;
				map_y=pixel_y[8:0]+n-120;
			end
			2'd1:begin//2
				map_x=pixel_x[8:1]+m-80;
				map_y=pixel_y[8:1]+n-60;
			end
			2'd2:begin//4
				map_x=pixel_x[8:2]+m-40;
				map_y=pixel_y[8:2]+n-30;
			end
			2'd3:begin//8
				map_x=pixel_x[8:3]+m-20;
				map_y=pixel_y[8:3]+n-15;
			end
		endcase
	end
	
endmodule
