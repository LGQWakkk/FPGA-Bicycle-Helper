`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/25 10:17:25
// Design Name: 
// Module Name: uart_test
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

//20230603 8:00最新串口接收模块

module uart_rx
#(
	parameter DBIT=8,
				SB_TICK=16
)
(
	input wire clk,reset,
	input wire rx,s_tick,
	output reg rx_done_tick,//组合电路中出现
	output wire [7:0] dout
    );
	
	localparam [1:0] 
	idle = 2'b00,
	start = 2'b01,
	data = 2'b10,
	stop = 2'b11;
	
	reg [1:0] state_reg,state_next;
	reg [3:0] s_reg,s_next;//对采样点进行计数
	reg [2:0] n_reg,n_next;//对数据位进行计数
	reg [7:0] b_reg,b_next;//接收数据缓冲器
	
	//FSMD
	always@(posedge clk or posedge reset)begin
		if(reset)begin
			state_reg<=idle;
			s_reg<=0;
			n_reg<=0;
			b_reg<=0;
		end
		else begin
			state_reg<=state_next;
			s_reg<=s_next;
			n_reg<=n_next;
			b_reg<=b_next;
		end
	end
	
	//FSMD组合逻辑
	always@(*)begin
	//默认状态不变
		state_next=state_reg;
		s_next=s_reg;
		n_next=n_reg;
		b_next=b_reg;
		rx_done_tick=1'b0;
		
		case(state_reg)
			idle:begin
				if(~rx)begin
					state_next=start;
					s_next=0;
				end
			end
			start:begin
				if(s_tick)begin
					if(s_reg==7)begin
						state_next=data;
						s_next=0;//保证在开始前清零，一处即可
						n_next=0;//保证在开始前清零，一处即可
					end
					else begin
						s_next=s_reg+1;
					end
				end
			end
			data:begin
				if(s_tick)begin
					if(s_reg==15)begin
						//这里面先接收的是最低位！
						b_next={rx,b_reg[7:1]};//注意顺序！！！
						s_next=0;
						if(n_reg==(DBIT-1))begin
							//n_next=0;
							state_next=stop;
						end
						else begin
							n_next=n_reg+1;
						end
					end
					else begin
						s_next=s_reg+1;
					end
				end
			end
			stop:begin
				if(s_tick)begin
					if(s_reg==(SB_TICK-1))begin
						state_next=idle;
						rx_done_tick=1'b1;
					end
					else begin
						s_next=s_reg+1;
					end
				end
			end
		endcase
	end
	
	assign dout = b_reg;
	
endmodule
