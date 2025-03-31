`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/16 10:19:52
// Design Name: 
// Module Name: rx_top
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

//20230616 10:31 V1
//20230616 21:36 V2

module rx_top(
	input wire clk,rst,
	input wire gps_rx,lora_rx,
	
	input wire [5:0] gps_ram_addr_rd,//注意这个端口是读取的是input!!!
	output wire [7:0] gps_ram_data_rd,
	input wire [5:0] lora_gps_ram_addr_rd,
	output wire [7:0] lora_gps_ram_data_rd,
	
	output wire gps_valid,
	output wire lora_gps_valid,
	
	output wire [8:0] m,n,a,b,
	output wire A_in_region,B_in_region,
	output wire gps_rx_get,lora_rx_get//目前还没有引出
    );
	
	
	
	
	wire [5:0] gps_ram_addr;
	wire [7:0] gps_ram_data;
	wire gps_ram_we;
	
	wire jw_we;
	wire [7:0] jw_data;
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
	.rx(gps_rx),
	.clk(clk),
	.rst(rst),
	.gps_ram_addr(gps_ram_addr),
	.gps_ram_data(gps_ram_data),
	.gps_ram_we(gps_ram_we),
	.jw_ram_addr(),
	.jw_ram_data(jw_data),
	.jw_ram_we(jw_we),
	.sh_ram_addr(),
	.sh_ram_data(),
	.sh_ram_we(),
	.gps_valid(gps_valid)
	);
	
	// module gps_ram
// #(
	// parameter ADDR_WIDTH=6,//39MAX  [5:0] addr
	// DATA_WIDTH=8
// )
// (
	// input wire clk,
	// input wire we,
	// input wire [ADDR_WIDTH-1:0] addr_a,addr_b,//a,b地址端口
	// input wire [DATA_WIDTH-1:0] din_a,//a端口写入数据
	// output wire [DATA_WIDTH-1:0] dout_a,dout_b
    // );
	gps_ram u_gps_ram_inrxtop(
	.clk(clk),
	.we(gps_ram_we),
	.addr_a(gps_ram_addr),
	.addr_b(gps_ram_addr_rd),//外界读取
	.din_a(gps_ram_data),
	.dout_a(),
	.dout_b(gps_ram_data_rd)//外界读取
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
	.jw_we(jw_we),
	.jw_data(jw_data[6:0]),
	.m(m),
	.n(n),
	.in_region(A_in_region)
	);
	
	wire [5:0] lora_gps_ram_addr;
	wire [7:0] lora_gps_ram_data;
	wire lora_gps_ram_we;
	wire lora_jw_we;
	wire [7:0] lora_jw_data;
	
	/////////////////////////////////////////////下面是LORA接收处理部分
	// module lora_get(
	// input wire lora_rx,
	// output wire [5:0] gps_ram_addr,
	// output wire [7:0] gps_ram_data,
	// output wire gps_ram_we,
	// output reg lora_rx_get_tick,//连接到lora发送模块
	// output wire gps_valid
    // );
	// lora_get u_lora_get(//放弃编写 不使用此模块
	// .lora_rx(lora_rx),
	// .gps_ram_addr(),
	// .gps_ram_data(),
	// .gps_ram_we(),
	// .lora_rx_get_tick(),
	// .gps_valid()
	// );
	///////////////////////////////////////////////////使用GPSGET
	gps_get u_lora_get(
	.rx(lora_rx),
	.clk(clk),
	.rst(rst),
	.gps_ram_addr(lora_gps_ram_addr),
	.gps_ram_data(lora_gps_ram_data),
	.gps_ram_we(lora_gps_ram_we),
	.jw_ram_addr(),
	.jw_ram_data(lora_jw_data),
	.jw_ram_we(lora_jw_we),
	.sh_ram_addr(),
	.sh_ram_data(),
	.sh_ram_we(),
	.gps_valid(lora_gps_valid)
	);
	
	
	// module lora_gps_ram
// #(
	// parameter ADDR_WIDTH=6,//39MAX  [5:0] addr
	// DATA_WIDTH=8
// )
// (
	// input wire clk,
	// input wire we,
	// input wire [ADDR_WIDTH-1:0] addr_a,addr_b,//a,b地址端口
	// input wire [DATA_WIDTH-1:0] din_a,//a端口写入数据
	// output wire [DATA_WIDTH-1:0] dout_a,dout_b
    // );
	lora_gps_ram u_lora_gps_ram(
	.clk(clk),
	.we(lora_gps_ram_we),
	.addr_a(lora_gps_ram_addr),
	.addr_b(lora_gps_ram_addr_rd),
	.din_a(lora_gps_ram_data),
	.dout_a(),
	.dout_b(lora_gps_ram_data_rd)
	);
	
	// module jingwei_process(
	// input wire clk,rst,
	// input wire jw_we,
	// input wire [6:0] jw_data,//注意输入位数是7位！
	// output wire [8:0] m,
	// output wire [8:0] n,
	// output wire in_region
    // );
	jingwei_process u_jingwei_process_for_lora(
	.clk(clk),
	.rst(rst),
	.jw_we(lora_jw_we),
	.jw_data(lora_jw_data[6:0]),
	.m(a),
	.n(b),
	.in_region(B_in_region)
	);
endmodule
