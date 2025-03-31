`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/16 19:11:17
// Design Name: 
// Module Name: safety_detect
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

//20230616 19:56 测试成功

module safety_detect(
	input wire clk,rst,
	input [8:0] a,b,
	input wire lock,
	output reg safety,//Safe:0  Unsafe:1
	output wire warning_bell
    );
	
	localparam [1:0] 
	st_unlock = 2'b00,
	st_lock = 2'b01,
	st_warning = 2'b10;
	
	localparam [8:0] 
	MAXA = 9'd20,
	MAXB = 9'd20;
	
	reg [1:0] state_reg,state_next;
	reg [8:0] a_reg,b_reg,a_next,b_next;
	
	wire [8:0] delta_a,delta_b;
	assign delta_a = (a>=a_reg)? a-a_reg : a_reg-a ;
	assign delta_b = (b>=b_reg)? b-b_reg : b_reg-b ;
	
	always@(posedge clk)begin
		if(rst)begin
			a_reg<=0;
			b_reg<=0;
			state_reg<=st_unlock;
			
		end
		else begin
			a_reg<=a_next;
			b_reg<=b_next;
			state_reg<=state_next;
		end
	end
	
	always@(*)begin
		a_next=a_reg;
		b_next=b_reg;
		state_next=state_reg;
		safety=1'b0;
		case(state_reg)
			st_unlock:begin
				if(lock)begin
					a_next=a;
					b_next=b;
					state_next=st_lock;
				end
			end
			st_lock:begin
				if((delta_a>=MAXA)||(delta_b>=MAXB))begin
					state_next=st_warning;
				end
			end
			st_warning:begin
				safety=1'b1;
				if(~lock)begin
					state_next=st_unlock;
				end
			end
		endcase
	end
	
	reg [25:0] wait_reg,wait_next;
	reg warning_bell_reg,warning_bell_next;
	localparam [25:0] WAITMAX = 26'd50_000_000;
	always@(posedge clk)begin
		if(rst)begin
			wait_reg<=0;
			warning_bell_reg<=1'b0;
		end
		else begin
			wait_reg<=wait_next;
			warning_bell_reg<=warning_bell_next;
		end
	end
	always@(*)begin
		wait_next=wait_reg;
		warning_bell_next=warning_bell_reg;
		if(wait_reg==WAITMAX)begin
			wait_next=0;
			warning_bell_next=~warning_bell_reg;
		end
		else begin
			wait_next=wait_reg+1;
		end
	end
	
	assign warning_bell = (safety)? warning_bell_reg:1'b1;//蜂鸣器为低电平触发
	
endmodule
