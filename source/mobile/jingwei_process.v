`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/13 13:58:24
// Design Name: 
// Module Name: jingwei_process
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

//20230613 14:05 V1

module jingwei_process(
	input wire clk,rst,
	input wire jw_we,
	input wire [6:0] jw_data,
	output wire [8:0] m,
	output wire [8:0] n,
	output wire in_region
    );
	
	wire [16:0] wire_jing_num;
	wire [16:0] wire_wei_num;
	wire wire_data_en;
	wire [34:0] wire_jing_ch;
	wire [34:0] wire_wei_ch;
	
// module jingwei_ctrl(
	// input wire clk,rst,
	// input wire [16:0] jing_num,
	// input wire [16:0] wei_num,
	// input wire data_en,
	// output wire [8:0] wei_m_scaled,
	// output wire [8:0] jing_n_scaled,
	// output wire in_region
    // );
	jingwei_ctrl u_jingwei_ctrl(
	.clk(clk),
	.rst(rst),
	.jing_num(wire_jing_num),
	.wei_num(wire_wei_num),
	.data_en(wire_data_en),
	.wei_m_scaled(m),
	.jing_n_scaled(n),
	.in_region(in_region)
	);
	
	// module char2num(
    // input [34:0] a,
    // output [16:0] out
    // );
	char2num u1_char2num(
	.a(wire_jing_ch),
	.out(wire_jing_num)
	);
	char2num u2_char2num(
	.a(wire_wei_ch),
	.out(wire_wei_num)
	);
	
	// module ser2par(
	// input wire clk,rst,
	// input wire gps_we,
	// input wire [6:0] gps_data,
	// output wire data_en,//输出数据使能
	// output wire [34:0] jing_ch,
	// output wire [34:0] wei_ch
    // );
	ser2par u_ser2par(
	.clk(clk),
	.rst(rst),
	.gps_we(jw_we),
	.gps_data(jw_data),
	.data_en(wire_data_en),
	.jing_ch(wire_jing_ch),
	.wei_ch(wire_wei_ch)
	);
	
endmodule
