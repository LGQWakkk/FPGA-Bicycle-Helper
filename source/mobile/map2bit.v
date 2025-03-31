`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/07 22:48:06
// Design Name: 
// Module Name: map2bit
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
//20230608 仿真通过 10:26
//所有坐标都以地图为原点！
//20230612 00:19改正地图反色的bug 并且修改了颜色

module map2bit(
	input wire clk,rst,
	input wire [8:0] map_x,map_y,//可能越界！
	input wire [8:0] a,b,m,n,//可能越界！
	output reg [15:0] data
    );
	//用于连接map_rom
	wire [13:0] map_addr;
	wire [7:0] map_rom_data;
	assign map_addr = {map_y[7:0],map_x[8:3]};
	
	// module map_rom(
    // input wire clk,
	// input wire [13:0] addr,//map_y[7:0]  map_x[8:3]
	// output reg [7:0] data  //输出的一行像素
    // );
	map_rom u_map_rom(
	.clk(clk),
	.addr(map_addr),
	.data(map_rom_data)
	);
	wire map_bit;
	//由于地图中没有物体的地方是白色会被识别为1，这里应该取反 错了
	//我看反了，在取模的时候黑色的地方是1，所以这里就正常弄就可以了
	//assign map_bit = map_rom_data[~map_x[2:0]];//map_bit为map_rom的最终定位输出，注意有一个时钟周期的延迟！
	
	//20230614 21:29 此处增加地图防溢出
	assign map_bit = (((map_x>=9'd0)&&(map_x<=9'd319))&&((map_y>=9'd0)&&(map_y<=9'd239)))? map_rom_data[~map_x[2:0]] : 1'b0;
	
	//对于A B坐标的控制
	//同样需要一个时钟周期获得数据
	reg A_bit_reg,B_bit_reg;
	reg A_bit_next,B_bit_next;
	
	always@(posedge clk)begin
		if(rst)begin
			A_bit_reg<=0;
			B_bit_reg<=0;
		end
		else begin
			A_bit_reg<=A_bit_next;
			B_bit_reg<=B_bit_next;
		end
	end
	
	always@(*)begin//没有越界控制
		if(((map_x>=a)&&(map_x<=(a+1)))&&((map_y>=b)&&(map_y<=(b+1))))
		begin
			B_bit_next=1'b1;
		end
		else begin
			B_bit_next=1'b0;
		end
	end
	
	always@(*)begin//没有越界控制
		if(((map_x>=m)&&(map_x<=(m+1)))&&((map_y>=n)&&(map_y<=(n+1))))
		begin
			A_bit_next=1'b1;
		end
		else begin
			A_bit_next=1'b0;
		end
	end
	
	//另一种写法
	// assign B_bit_next = (((map_x>=a)&&(map_x<=(a+1)))&&((map_y>=b)&&(map_y<=(b+1))))?1'b1:1'b0;
	// assign A_bit_next = (((map_x>=m)&&(map_x<=(m+1)))&&((map_y>=n)&&(map_y<=(n+1))))?1'b1:1'b0;
	
	//输出颜色映射
	always@(*)begin
		if(A_bit_reg)begin
			data=16'hf800;//red
		end
		else if(B_bit_reg)begin
			data=16'h07e0;//green
		end
		else if(map_bit)begin
			data=16'h0000;//black
		end
		else begin
			data=16'hffff;//white
		end
	end
	
endmodule
