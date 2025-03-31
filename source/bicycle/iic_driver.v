`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/09 14:43:08
// Design Name: 
// Module Name: iic_driver
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
//2023.6.9 15:53仿真通过 但是只能传输一个字节，不符合要求  V1
//2023.6.9 16:53仿真通过 这回添加了完整的一次传输，理论上符合要求 V2
//20230610 测试成功 V1

module iic_driver
#(parameter SLAVE_ADDR=8'h78)
(
	input wire clk,rst,
	input wire dc,
	input wire [7:0] din,
	input wire iic_start,
	output reg iic_done,
	output wire scl,sda
    );
	
	wire s_tick;
	mod_m_counter u_mod_m_counter(
	.clk(clk),
	.reset(rst),
	.max_tick(s_tick),
	.q()
	);
	
	localparam [5:0] 
	st_idle = 6'd0,
	st_start1=6'd1,st_start2=6'd2,st_start3=6'd3,st_start4=6'd4,
	st_data1=6'd5,st_data2=6'd6,st_data3=6'd7,st_data4=6'd8,st_data5=6'd9,
	st_ack1=6'd10,st_ack2=6'd11,st_ack3=6'd12,st_ack4=6'd13,
	st_stop1=6'd14,st_stop2=6'd15,st_stop3=6'd16,st_stop4=6'd17;
	
	reg scl_reg,scl_next;
	reg sda_reg,sda_next;
	reg [7:0] data_reg,data_next;//数据移位寄存器
	reg [7:0] sladdr_reg,sladdr_next;//从机地址移位寄存器
	reg [7:0] ctrlbyte_reg,ctrlbyte_next;//控制字节移位寄存器
	reg [3:0] byte_reg,byte_next;//字节传输数量寄存器
	reg [3:0] d_reg,d_next;//数据位数计数器
	reg [5:0] state_reg,state_next;
	
	assign scl=scl_reg;
	assign sda=sda_reg;
	
	always@(posedge clk)begin
		if(rst)begin
			scl_reg<=1'b1;
			sda_reg<=1'b1;
			data_reg<=0;
			sladdr_reg<=0;
			ctrlbyte_reg<=0;
			byte_reg<=0;
			d_reg<=0;
			state_reg<=st_idle;
		end
		else begin
			scl_reg<=scl_next;
			sda_reg<=sda_next;
			data_reg<=data_next;
			sladdr_reg<=sladdr_next;
			ctrlbyte_reg<=ctrlbyte_next;
			byte_reg<=byte_next;
			d_reg<=d_next;
			state_reg<=state_next;
		end
	end
	
	always@(*)begin
		scl_next=scl_reg;
		sda_next=sda_reg;
		data_next=data_reg;
		sladdr_next=sladdr_reg;
		ctrlbyte_next=ctrlbyte_reg;
		byte_next=byte_reg;
		d_next=d_reg;
		state_next=state_reg;
		iic_done=1'b0;
		case(state_reg)
			st_idle:begin
				scl_next=1'b1;
				sda_next=1'b1;
				if(iic_start)begin
					data_next=din;
					sladdr_next=SLAVE_ADDR;
					if(dc)begin
						ctrlbyte_next=8'h40;
					end
					else begin
						ctrlbyte_next=8'h00;
					end
					d_next=0;
					state_next=st_start1;
				end
			end
			st_start1:begin
				if(s_tick)begin
					state_next=st_start2;
					sda_next=1'b0;
				end
			end
			st_start2:begin
				if(s_tick)begin
					state_next=st_start3;
				end
			end
			st_start3:begin
				if(s_tick)begin
					state_next=st_start4;
					scl_next=1'b0;
				end
			end
			st_start4:begin
				if(s_tick)begin
					sda_next=SLAVE_ADDR[7];
					byte_next=0;
					d_next=0;
					state_next=st_data1;
				end
			end
			///////////////////////////////////////////////////////////////////////////////////
			st_data1:begin
				if(byte_reg==0)begin
					sladdr_next=sladdr_reg<<1;
				end
				else if(byte_reg==1)begin
					ctrlbyte_next=ctrlbyte_reg<<1;
				end
				else if(byte_reg==2)begin
					data_next=data_reg<<1;
				end
				scl_next=1'b0;
				d_next=d_reg+1;
				state_next=st_data2;
			end
			st_data2:begin
				scl_next=1'b0;
				if(s_tick)begin
					scl_next=1'b1;
					state_next=st_data3;
				end
			end
			st_data3:begin
				scl_next=1'b1;
				if(s_tick)begin
					state_next=st_data4;
				end
			end
			st_data4:begin
				scl_next=1'b1;
				if(s_tick)begin
					scl_next=1'b0;
					state_next=st_data5;
				end
			end
			st_data5:begin
				scl_next=1'b0;
				if(s_tick)begin
					if(d_reg==8)begin//条件不要写反！
						d_next=0;
						sda_next=1'bz;
						state_next=st_ack1;
					end
					else begin
						if(byte_reg==0)begin
							sda_next=sladdr_reg[7];
						end
						else if(byte_reg==1)begin
							sda_next=ctrlbyte_reg[7];
						end
						else if(byte_next==2)begin
							sda_next=data_reg[7];
						end
						state_next=st_data1;//这里的状态跳转不要忘！
					end
				end
			end
			/////////////////////////////////////////////////////////////////////////
			st_ack1:begin//a
				if(s_tick)begin
					state_next=st_ack2;
					scl_next=1'b1;
				end
			end
			st_ack2:begin//b
				if(s_tick)begin
					state_next=st_ack3;
				end
			end
			st_ack3:begin//c
				if(s_tick)begin
					state_next=st_ack4;
					scl_next=1'b0;
				end
			end
			st_ack4:begin//d
				if(s_tick)begin
					if(byte_reg==2)begin
						state_next=st_stop1;
						sda_next=1'b0;
						byte_next=0;
					end
					else if(byte_reg==0)begin
						state_next=st_data1;
						sda_next=ctrlbyte_reg[7];
						byte_next=byte_reg+1;
					end
					else if (byte_reg==1)begin
						state_next=st_data1;
						sda_next=data_reg[7];
						byte_next=byte_reg+1;
					end
					
				end
			end
			/////////////////////////////////////////////////////////////////////////////////
			st_stop1:begin//e
				if(s_tick)begin
					state_next=st_stop2;
					scl_next=1'b1;
				end
			end
			st_stop2:begin
				if(s_tick)begin
					state_next=st_stop3;
				end
			end
			st_stop3:begin
				if(s_tick)begin
					state_next=st_stop4;
					sda_next=1'b1;
				end
			end
			st_stop4:begin
				if(s_tick)begin
					state_next=st_idle;
					iic_done=1'b1;
				end
			end
			
		endcase
	end
	
	
	
endmodule
