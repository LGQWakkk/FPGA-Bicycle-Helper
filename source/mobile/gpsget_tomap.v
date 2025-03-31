`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/13 13:31:11
// Design Name: 
// Module Name: gpsget_tomap
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
//20230613 14:22 V1

module gpsget_tomap(
	input wire rx,clk,rst,
	output wire [8:0] data_out,
	output wire rst_out,cs,rd,wr,
	output wire in_region
    );
	
	wire [7:0] wire_jw_ram_data;
	wire wire_jw_ram_we;
	wire [8:0] wire_m,wire_n;
// module charmap_disp_top(
	// input wire clk,rst,
	
	// input wire ram_we,
	// input wire [9:0] ram_addr,
	// input wire [6:0] ram_data,
	
	// input wire [1:0] rate,
	// input wire [8:0] a,b,m,n,
	
	// output wire [8:0] data_out,
	// output wire rst_out,cs,rd,wr
	
    // );
	charmap_disp_top u_charmap_disp_top(
	.clk(clk),
	.rst(rst),
	.ram_we(),
	.ram_addr(),
	.ram_data(),
	.rate(2'b00),
	.a(9'd0),
	.b(9'd0),
	.m(wire_m),
	.n(wire_n),
	.data_out(data_out),
	.rst_out(rst_out),
	.cs(cs),
	.rd(rd),
	.wr(wr)
	);
	
	// module jingwei_process(
	// input wire clk,rst,
	// input wire jw_we,
	// input wire [6:0] jw_data,//注意输入位数是7位！
	// output wire [8:0] m,
	// output wire [8:0] n,
	// output wire in_region
    // );
	jingwei_process u_jingwei_process(
	.clk(clk),
	.rst(rst),
	.jw_we(wire_jw_ram_we),
	.jw_data(wire_jw_ram_data[6:0]),
	.m(wire_m),
	.n(wire_n),
	.in_region(in_region)
	);
	
	// module gps_get(
	// input wire rx,
	// input wire clk,rst,
	// output wire [5:0] gps_ram_addr,
	// output wire [7:0] gps_ram_data,
	// output wire gps_ram_we,
	// output wire [3:0] jw_ram_addr,
	// output wire [7:0] jw_ram_data,
	// output wire jw_ram_we,
	// output wire [3:0] sh_ram_addr,
	// output wire [7:0] sh_ram_data,
	// output wire sh_ram_we,
	// output wire gps_valid
    // );
	gps_get u_gps_get(
	.rx(rx),
	.clk(clk),
	.rst(rst),
	.jw_ram_we(wire_jw_ram_we),
	.jw_ram_data(wire_jw_ram_data)
	);
	
	
endmodule
