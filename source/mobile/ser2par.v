`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/07 13:59:55
// Design Name: 
// Module Name: ser2par
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

//20230607 17:33-17:53 V1
//20230613 14:05 V1

//用来将串行GPS经纬度数据转换成并行数据以给char2num转换
//存储格式 经纬度小数点后5位数值ASCII码
//首先是纬度 然后是经度
// _ _ _ _ _   _ _ _ _ _



module ser2par(
	input wire clk,rst,
	input wire gps_we,
	input wire [6:0] gps_data,
	output wire data_en,
	output wire [34:0] jing_ch,
	output wire [34:0] wei_ch
    );
	
	localparam [4:0] 
	st_0=5'd0,
	st_1=5'd1,
	st_2=5'd2,
	st_3=5'd3,
	st_4=5'd4,
	st_5=5'd5,
	st_6=5'd6,
	st_7=5'd7,
	st_8=5'd8,
	st_9=5'd9,
	st_10=5'd10,
	st_11=5'd11;
	
	reg data_en_reg,data_en_next;
	reg [4:0] state_reg,state_next;
	reg [6:0] jing1,jing2,jing3,jing4,jing5;
	reg [6:0] jing1_next,jing2_next,jing3_next,jing4_next,jing5_next;
	reg [6:0] wei1,wei2,wei3,wei4,wei5;
	reg [6:0] wei1_next,wei2_next,wei3_next,wei4_next,wei5_next;
	
	assign jing_ch = {jing1,jing2,jing3,jing4,jing5};
	assign wei_ch = {wei1,wei2,wei3,wei4,wei5};
	assign data_en = data_en_reg;
	
	always@(posedge clk)begin
		if(rst)begin
			data_en_reg<=1'b0;
			state_reg<=st_0;
			jing1<=0;jing2<=0;jing3<=0;jing4<=0;jing5<=0;
			wei1<=0;wei2<=0;wei3<=0;wei4<=0;wei5<=0;
		end
		else begin
			jing1<=jing1_next;
			jing2<=jing2_next;
			jing3<=jing3_next;
			jing4<=jing4_next;
			jing5<=jing5_next;
			
			wei1<=wei1_next;
			wei2<=wei2_next;
			wei3<=wei3_next;
			wei4<=wei4_next;
			wei5<=wei5_next;
			
			state_reg<=state_next;
			data_en_reg<=data_en_next;
		end
	end
	
	always@(*)begin
		data_en_next=1'b0;//data_en默认0！
		
		jing1_next=jing1;
		jing2_next=jing2;
		jing3_next=jing3;
		jing4_next=jing4;
		jing5_next=jing5;
		
		wei1_next=wei1;
		wei2_next=wei2;
		wei3_next=wei3;
		wei4_next=wei4;
		wei5_next=wei5;
		
		state_next=state_reg;
		case(state_reg)
		/////////////////////////////////////////////////////////////////////////////////////////////
			st_0:begin
				if(gps_we)begin
					wei1_next=gps_data;
					state_next=st_1;
				end
			end
			st_1:begin
				if(gps_we)begin
					wei2_next=gps_data;
					state_next=st_2;
				end
			end
			st_2:begin
				if(gps_we)begin
					wei3_next=gps_data;
					state_next=st_3;
				end
			end
			st_3:begin
				if(gps_we)begin
					wei4_next=gps_data;
					state_next=st_4;
				end
			end
			st_4:begin
				if(gps_we)begin
					wei5_next=gps_data;
					state_next=st_6;
				end
			end
			//////////////////////////////////////////////////////////////////////////
			st_6:begin
				if(gps_we)begin
					jing1_next=gps_data;
					state_next=st_7;
				end
			end
			
			st_7:begin
				if(gps_we)begin
					jing2_next=gps_data;
					state_next=st_8;
				end
			end
			
			st_8:begin
				if(gps_we)begin
					jing3_next=gps_data;
					state_next=st_9;
				end
			end
			st_9:begin
				if(gps_we)begin
					jing4_next=gps_data;
					state_next=st_10;
				end
			end
			st_10:begin
				if(gps_we)begin
					jing5_next=gps_data;
					state_next=st_11;
					data_en_next=1'b1;
				end
			end
			st_11:begin//缓冲状态
				state_next=st_0;//循环读入
			end
		endcase
	end
	
endmodule
