`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/16 14:37:54
// Design Name: 
// Module Name: btn_ctrl
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

//20230616 14:56 V1

module btn_ctrl(
	input wire clk,rst,
	input wire up_btn,down_btn,
	input wire bell_btn,led_btn,rgb_btn,lock_btn,
	input wire s1,s2,
	output wire [1:0] rate,
	output wire bell,led,rgb,lock,
	output wire [2:0] rgb_mode
    );
	reg [1:0] rate_reg,rate_next;
	assign rate=rate_reg;
	
	wire up_btn_tick,down_btn_tick;
	wire bell_btn_tick,led_btn_tick,rgb_btn_tick,lock_btn_tick;
	
	reg bell_reg,bell_next;
	reg led_reg,led_next;
	reg rgb_reg,rgb_next;
	reg lock_reg,lock_next;
	
	assign bell = bell_reg;
	assign led = led_reg;
	assign rgb = rgb_reg;
	assign lock = lock_reg;
	
	button_h u_up_btn(
	.clk(clk),
	.rst(rst),
	.button(up_btn),
	.tick(up_btn_tick)
	);
	
	button_h u_down_btn(
	.clk(clk),
	.rst(rst),
	.button(down_btn),
	.tick(down_btn_tick)
	);
	
	button_h u_bell_btn(//控制方式有所不同！
	.clk(clk),
	.rst(rst),
	.button(bell_btn),
	.tick(bell_btn_tick)
	);
	
	button_h u_led_btn(
	.clk(clk),
	.rst(rst),
	.button(led_btn),
	.tick(led_btn_tick)
	);
	
	button_l u_rgb_btn(//低电平按钮！
	.clk(clk),
	.rst(rst),
	.button(rgb_btn),
	.tick(rgb_btn_tick)
	);
	
	button_h u_lock_btn(
	.clk(clk),
	.rst(rst),
	.button(lock_btn),
	.tick(lock_btn_tick)
	);
	
	// module anjian_2(
    // input clk,
    // input rst,
    // input s1,
    // input s2,
    // input key,
    // output key_in,
    // output [2:0] shu
    // );
	//旋转编码器
	anjian_2 u_anjian_2(
	.clk(clk),
	.rst(rst),
	.s1(s1),
	.s2(s2),
	.key(),
	.key_in(),
	.shu(rgb_mode)
	);
	
	
	always@(posedge clk)begin
		if(rst)begin
			rate_reg<=0;
		end
		else begin
			rate_reg<=rate_next;
		end
	end
	always@(*)begin
		rate_next=rate_reg;
		if(up_btn_tick)begin
			if(rate_reg==3)begin
				rate_next=rate_reg;
			end
			else begin
				rate_next=rate_reg+1;
			end
		end
		else if(down_btn_tick)begin
			if(rate_reg==0)begin
				rate_next=rate_reg;
			end
			else begin
				rate_next=rate_reg-1;
			end
		end
	end
	
	always@(posedge clk)begin
		if(rst)begin
			bell_reg<=1'b0;
			led_reg<=1'b0;
			rgb_reg<=1'b0;
			lock_reg<=1'b0;
		end
		else begin
			bell_reg<=bell_next;
			led_reg<=led_next;
			rgb_reg<=rgb_next;
			lock_reg<=lock_next;
		end
	end
	always@(*)begin
		bell_next=bell_reg;
		led_next=led_reg;
		rgb_next=rgb_reg;
		lock_next=lock_reg;
		if(bell_btn_tick)begin
			bell_next=~bell_reg;
		end
		else if(led_btn_tick)begin
			led_next=~led_reg;
		end
		else if(rgb_btn_tick)begin
			rgb_next=~rgb_reg;
		end
		else if(lock_btn_tick)begin
			lock_next=~lock_reg;
		end
	end
	
	
endmodule
