`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/17 19:41:09
// Design Name: 
// Module Name: oled_top
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

//20230617 20:19 编写完毕
//20230617 21:09 测试没有问题

module oled_top(
	input wire clk,rst,
	input wire sh_ram_we,
	input wire [3:0] sh_ram_addr,
	input wire [7:0] sh_ram_data,
	input wire l_tick,r_tick,
	input wire jw_ram_we,
	input wire [3:0] jw_ram_addr,
	input wire [7:0] jw_ram_data,
	input wire [7:0] r,g,b,led,
	output wire scl,sda
    );
	
	wire [7:0] data;//full_disp输出  pixel_ctrl输入
	wire [6:0] disp_col_o;
	wire [2:0] disp_row_o;
	
	wire [10:0] col_offset;
	wire [10:0] col_all;
	wire [2:0] row_all;
	assign col_all = col_offset+disp_col_o;
	assign row_all = disp_row_o;
	
	// module full_diso;p(
	// input wire clk,rst,
	// input wire sh_ram_we,
	// input wire [3:0] sh_ram_addr,
	// input wire [7:0] sh_ram_data,
	
	// input wire jw_ram_we,
	// input wire [3:0] jw_ram_addr,
	// input wire [7:0] jw_ram_data,
	
	// input wire [10:0] col_all,
	// input wire [2:0] row_all,
	
	// input wire [7:0] r,g,b,led,
	
	// output reg [7:0] data
    // );
	full_disp u_full_disp(
	.clk(clk),
	.rst(rst),
	.sh_ram_we(sh_ram_we),
	.sh_ram_addr(sh_ram_addr),
	.sh_ram_data(sh_ram_data),
	.jw_ram_we(jw_ram_we),
	.jw_ram_addr(jw_ram_addr),
	.jw_ram_data(jw_ram_data),
	
	.col_all(col_all),
	.row_all(row_all),
	.r(r),
	.g(g),
	.b(b),
	.led(led),
	.data(data)
	);
	
	pixel_ctrl u_pixel_ctrl(
	.clk(clk),
	.rst(rst),
	.data_in(data),
	.col(disp_col_o),//屏幕内坐标
	.row(disp_row_o),//屏幕内坐标
	.scl(scl),
	.sda(sda)
	);
	
	// module offset_ctrl(
	// input wire clk,rst,
	// input wire [2:0] page_mode,
	// output wire [10:0] col_offset
    // );
	offset_ctrl u_offset_ctrl(
	.clk(clk),
	.rst(rst),
	.col_offset(col_offset),
	.l_tick(l_tick),
	.r_tick(r_tick)
	);
	// module offset_ctrl(
	// input wire clk,rst,
	// input wire l_tick,r_tick,
	// output wire [10:0] col_offset
    // );
	
endmodule
