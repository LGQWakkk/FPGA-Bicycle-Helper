`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/16 10:32:12
// Design Name: 
// Module Name: Mobile
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


module Mobile(
	input wire clk,rst,
	input wire gps_rx,lora_rx,
	output wire [8:0] data_out,
	output wire rst_out,cs,rd,wr,
	//按键输入
	input wire up_btn,down_btn,
	input wire bell_btn,led_btn,rgb_btn,lock_btn,
	input wire s1,s2,
	output wire warning_bell,
	//状态显示输出
	output wire A_in_region,B_in_region,gps_valid,lora_gps_valid,
	output wire gps_rx_led,lora_rx_led,
	
	input wire must_tx,
	output wire lora_tx,
	output wire lora_tx_led
    );
	
	assign gps_rx_led = gps_rx;
	assign lora_rx_led = lora_rx;
	
	//按键模块输出
	wire [1:0] rate;
	wire bell,led,rgb,lock;
	wire [2:0] rgb_mode;
	
	
	wire [5:0] gps_ram_addr;
	wire [7:0] gps_ram_data;
	
	wire [5:0] lora_gps_ram_addr;
	wire [7:0] lora_gps_ram_data;
	
	//用于连接char_display 与 disp_top
	wire [9:0] disp_ram_addr;
	wire [6:0] disp_ram_data;
	wire disp_ram_we;
	
	//用于连接 rx_top 与 disp_top
	wire [8:0] a,b,m,n;
	
	wire safety;
	wire lora_tx_tick;
	
	charmap_disp_top u_charmap_disp_top(
	.clk(clk),
	.rst(rst),
	.ram_we(disp_ram_we),
	.ram_addr(disp_ram_addr),
	.ram_data(disp_ram_data),
	.rate(rate),
	.a(a),
	.b(b),
	.m(m),
	.n(n),
	.data_out(data_out),
	.rst_out(rst_out),
	.cs(cs),
	.rd(rd),
	.wr(wr),
	.led(led),//连接到按键模块的输出
	.bell(bell),
	.safety(safety),
	.lock(lock),
	.rgb(rgb),
	.rgb_mode(rgb_mode)
	);
	
	////////////////////////////////V1
	// module rx_top(
	// input wire clk,rst,
	// input wire gps_rx,lora_rx,
	// output wire [5:0] gps_ram_addr_rd,
	// output wire [7:0] gps_ram_data_rd,
	// output wire gps_valid,
	// output wire [8:0] m,n,a,b,
	// output wire A_in_region,B_in_region,
	// output wire gps_rx_get,lora_rx_get
    // );
	////////////////////////////////V2
	// module rx_top(
	// input wire clk,rst,
	// input wire gps_rx,lora_rx,
	
	// input wire [5:0] gps_ram_addr_rd,//注意这个端口是读取的是input!!!
	// output wire [7:0] gps_ram_data_rd,
	// input wire [5:0] lora_gps_ram_addr_rd,
	// output wire [7:0] lora_gps_ram_data_rd,
	
	// output wire gps_valid,
	// output wire lora_gps_valid,
	
	// output wire [8:0] m,n,a,b,
	// output wire A_in_region,B_in_region,
	// output wire gps_rx_get,lora_rx_get//目前还没有引出
    // );
	rx_top u_rx_top(
	.clk(clk),
	.rst(rst),
	.gps_rx(gps_rx),
	.lora_rx(lora_rx),
	.gps_ram_addr_rd(gps_ram_addr),
	.gps_ram_data_rd(gps_ram_data),
	.lora_gps_ram_addr_rd(lora_gps_ram_addr),
	.lora_gps_ram_data_rd(lora_gps_ram_data),
	.lora_gps_valid(lora_gps_valid),
	.gps_valid(gps_valid),
	.m(m),
	.n(n),
	.a(a),
	.b(b),
	.A_in_region(A_in_region),
	.B_in_region(B_in_region),
	.gps_rx_get(),
	.lora_rx_get()
	);
	
	char_display u_char_display(
	.clk(clk),
	.rst(rst),
	.gps_ram_addr(gps_ram_addr),
	.gps_ram_data(gps_ram_data),
	.lora_ram_addr(lora_gps_ram_addr),
	.lora_ram_data(lora_gps_ram_data),
	.ram_addr(disp_ram_addr),
	.ram_data(disp_ram_data),
	.ram_we(disp_ram_we)
	);
	
	btn_ctrl u_btn_ctrl(
	.clk(clk),
	.rst(rst),
	.up_btn(up_btn),
	.down_btn(down_btn),
	.bell_btn(bell_btn),
	.led_btn(led_btn),
	.rgb_btn(rgb_btn),
	.lock_btn(lock_btn),
	.s1(s1),
	.s2(s2),
	.rate(rate),
	.bell(bell),
	.led(led),
	.rgb(rgb),
	.lock(lock),
	.rgb_mode(rgb_mode)
	);
	
	safety_detect u_safety_detect(
	.clk(clk),
	.rst(rst),
	.a(a),
	.b(b),
	.lock(lock),
	.safety(safety),
	.warning_bell(warning_bell)
	);
	
	// module lora_tx_ctrl(
	// input wire lora_rx_tick,//lora_rx接收到信号的提示
	// input wire bell,led,rgb,
	// input wire [2:0] rgb_mode,
	// input wire must_tx,//强制发送使能
	// output wire lora_tx
    // );
	lora_tx_ctrl u_lora_tx_ctrl(
	.clk(clk),
	.rst(rst),
	.lora_rx_tick(),
	.bell(bell),
	.led(led),
	.rgb(rgb),
	.rgb_mode(rgb_mode),
	.must_tx(must_tx),
	.lora_tx(lora_tx),
	.lora_tx_tick(lora_tx_tick)
	);
	
	// module led_tick_blink(
	// input wire clk,rst,
	// input wire tick,
	// output reg blink
    // );
	led_tick_blink u_lora_tx_led(
	.clk(clk),
	.rst(rst),
	.tick(led_tick_blink),
	.blink(lora_tx_led)
	);
endmodule
