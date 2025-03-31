`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/17 19:41:21
// Design Name: 
// Module Name: offset_ctrl
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

//20230617 20:10 编写完毕
//20230618 15:18 V2编写完毕

module offset_ctrl(
	input wire clk,rst,
	input wire l_tick,r_tick,
	output wire [10:0] col_offset
    );
	//page_mode:
	//0:0-128
	//1:128-384
	//2:384-640
	//3:640-896
	//4:-
	//5:-
	wire tick;
	
	 reg [5:0] state_reg,state_next;
	 reg [10:0] col_offset_reg,col_offset_next;
	 localparam [5:0]
	 st_idle=6'd0,st_1=6'd1,st_2=6'd2,st_3=6'd3,st_4=6'd4,st_5=6'd5,
	 st_6=6'd6,st_7=6'd7,st_8=6'd8,st_9=6'd9,st_10=6'd10,st_11=6'd11,
	 st_12=6'd12,st_13=6'd13,st_14=6'd14,st_15=6'd15,st_16=6'd16;
	 
	assign col_offset = col_offset_reg;
	
	always@(posedge clk)begin
		if(rst)begin
			state_reg<=0;
			col_offset_reg<=0;
		end
		else begin
			state_reg<=state_next;
			col_offset_reg<=col_offset_next;
		end
	end
	
	always@(*)begin
		state_next=state_reg;
		col_offset_next=col_offset_reg;
		case(state_reg)
			st_idle:begin
				if(r_tick)begin
					state_next=st_1;
					
				end
				else if(l_tick)begin
					state_next=st_10;
					col_offset_next=640;
				end
			end
			st_1:begin
				if(tick)begin
					if(col_offset_reg==128)begin
						state_next=st_2;
					end
					else begin
						col_offset_next=col_offset_reg+2;
					end
				end
			end
			st_2:begin
				if(r_tick)begin
					state_next=st_3;
				end
				else if(l_tick)begin
					state_next=st_12;
				end
			end
			st_3:begin
				if(tick)begin
					if(col_offset_reg==256)begin
						state_next=st_4;
					end
					else begin
						col_offset_next=col_offset_reg+2;
					end
				end
			end
			st_4:begin
				if(r_tick)begin
					state_next=st_5;
				end
				else if(l_tick)begin
					state_next=st_13;
				end
			end
			st_5:begin
				if(tick)begin
					if(col_offset_reg==384)begin
						state_next=st_6;
					end
					else begin
						col_offset_next=col_offset_reg+2;
					end
				end
			end
			st_6:begin
				if(r_tick)begin
					state_next=st_7;
				end
				else if(l_tick)begin
					state_next=st_14;
				end
			end
			st_7:begin
				if(tick)begin
					if(col_offset_reg==512)begin
						state_next=st_8;
					end
					else begin
						col_offset_next=col_offset_reg+2;
					end
				end
			end
			st_8:begin
				if(r_tick)begin
					state_next=st_9;
				end
				else if(l_tick)begin
					state_next=st_15;
				end
			end
			st_9:begin
				if(tick)begin
					if(col_offset_reg==640)begin
						state_next=st_10;
					end
					else begin
						col_offset_next=col_offset_reg+2;
					end
				end
			end
			st_10:begin
				if(r_tick)begin
					state_next=st_idle;
					col_offset_next=0;
				end
				else if(l_tick)begin
					state_next=st_16;
				end
			end
			//缺少st_11
			st_12:begin
				if(tick)begin
					if(col_offset_reg==0)begin
						state_next=st_idle;
					end
					else begin
						col_offset_next=col_offset_reg-2;
					end
				end
			end
			st_13:begin
				if(tick)begin
					if(col_offset_reg==128)begin
						state_next=st_2;
					end
					else begin
						col_offset_next=col_offset_reg-2;
					end
				end
			end
			st_14:begin
				if(tick)begin
					if(col_offset_reg==256)begin
						state_next=st_4;
					end
					else begin
						col_offset_next=col_offset_reg-2;
					end
				end
			end
			st_15:begin
				if(tick)begin
					if(col_offset_reg==384)begin
						state_next=st_6;
					end
					else begin
						col_offset_next=col_offset_reg-2;
					end
				end
			end
			st_16:begin
				if(tick)begin
					if(col_offset_reg==512)begin
						state_next=st_8;
					end
					else begin
						col_offset_next=col_offset_reg-2;
					end
				end
			end

		endcase
	end
	
	mod_m_counter #(.N(24),.M(400_000))
	u2_mod_m_counter(
		.clk(clk),
		.reset(rst),
		.max_tick(tick),
		.q()
	);
endmodule
