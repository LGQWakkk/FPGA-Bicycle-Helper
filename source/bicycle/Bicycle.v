`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/17 10:29:55
// Design Name: 
// Module Name: Bicycle
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


module Bicycle(
	input wire clk,rst,
	input wire gps_rx,lora_rx,
	input wire s1,s2,
	output wire scl,sda,
	output wire gps_valid,
	output wire lora_ok_led,
	output wire led_out,bell_out
    );
	
	wire gps_valid;
	wire lora_ok;//tick
	
	
	wire [3:0] jw_ram_addr;
	wire [7:0] jw_ram_data;
	wire jw_ram_we;
	wire [3:0] sh_ram_addr;
	wire [7:0] sh_ram_data;
	wire sh_ram_we;
	
	wire [2:0] page_mode;
	
	wire r_tick,l_tick;
	// module oled_top(
	// input wire clk,rst,
	// input wire [2:0] page_mode,
	
	// input wire sh_ram_we,
	// input wire [3:0] sh_ram_addr,
	// input wire [7:0] sh_ram_data,
	
	// input wire jw_ram_we,
	// input wire [3:0] jw_ram_addr,
	// input wire [7:0] jw_ram_data,
	
	// input wire [7:0] r,g,b,led
    // );
	oled_top u_oled_top(
	.clk(clk),
	.rst(rst),
	.r_tick(r_tick),
	.l_tick(l_tick),
	
	.sh_ram_we(sh_ram_we),
	.sh_ram_addr(sh_ram_addr),
	.sh_ram_data(sh_ram_data),
	
	.jw_ram_we(jw_ram_we),
	.jw_ram_addr(jw_ram_addr),
	.jw_ram_data(jw_ram_data),
	
	.scl(scl),
	.sda(sda)
	);
	
	EC11 u_EC11(
	.clk(clk),
	.rst(rst),
	.s1(s1),
	.s2(s2),
	.value(page_mode),
	.r_tick(r_tick),
	.l_tick(l_tick)
	);
	
	gps_get u_gps_get(
	.rx(gps_rx),
	.clk(clk),
	.rst(rst),
	.jw_ram_addr(jw_ram_addr),
	.jw_ram_data(jw_ram_data),
	.jw_ram_we(jw_ram_we),
	.sh_ram_addr(sh_ram_addr),
	.sh_ram_data(sh_ram_data),
	.sh_ram_we(sh_ram_we),
	.gps_valid(gps_valid)
	);
	
/* 	module lora_rx(
	input wire clk,rst,
	input wire lora_rx,
	output reg lora_ok,
	output wire led,rgb,bell,
	output wire [2:0] rgb_mode
    ); */
	lora_rx u_lora_rx(
	.clk(clk),
	.rst(rst),
	.lora_rx(lora_rx),
	.lora_ok(lora_ok),
	.led(led_out),
	.rgb(),
	.bell(bell_out),
	.rgb_mode()
	);

	led_tick_blink u_led_tick_blink(
	.clk(clk),
	.rst(rst),
	.tick(lora_ok),
	.blink(lora_ok_led)
	);
	
endmodule
