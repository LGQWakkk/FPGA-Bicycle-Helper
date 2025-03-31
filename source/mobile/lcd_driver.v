`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/31 00:02:22
// Design Name: 
// Module Name: lcd_driver
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

//2023.6.1完整版 test1 22:29
//2023.6.1 22:31 第一次上板测试
//2023.6.2 10:24 改正输出位数的错误 验证成功
//2023.6.3 8:04 增加持续刷新
//2023.6.3 8:19 持续刷新仿真验证成功

//2023.6.8 10:32 需要适配全屏
//修改：
//37: output wire [7:0] pixel_y ->  output wire [8:0] pixel_y
//50: reg [7:0] pixel_y_reg,pixel_y_next ->  reg [8:0] pixel_y_reg,pixel_y_next
//115: localparam [7:0] YMAX = 8'd239; -> localparam [8:0] YMAX = 9'd479;


module lcd_driver(
	input wire clk,rst,
	input wire [15:0] data_in,
	output wire [8:0] data_out,
	output wire rst_out,cs,rd,wr,
	output wire [8:0] pixel_x,
	output wire [8:0] pixel_y
    );
	
	reg [4:0] state_reg,state_next;//状态数修改之后这里别忘修改！！！
	reg [5:0] clk_reg,clk_next;
	reg cs_reg,cs_next;
	reg rst_reg,rst_next;
	reg [6:0] initial_data_reg,initial_data_next;
	reg [8:0] data_out_reg,data_out_next;
	reg wr_reg,wr_next;
	reg [23:0] wait_reg,wait_next;
	
	reg [8:0] pixel_x_reg,pixel_x_next;
	reg [8:0] pixel_y_reg,pixel_y_next;
	reg [15:0] data_in_reg,data_in_next;//16位数据输入缓存
	
	wire [8:0] initial_data;
	wire [6:0] initial_data_cnt;
	
	
	// module initial_rom(
	// input wire clk,
	// input wire [6:0] addr,//0-92
	// output reg [8:0] data
    // );
	initial_rom u_initial_rom(
	.clk(clk),
	.addr(initial_data_cnt),
	.data(initial_data)
	);
	
	assign initial_data_cnt=initial_data_reg;

	assign rst_out=rst_reg;
	assign cs = cs_reg;
	assign rd = 1'b1;
	assign wr = wr_reg;
	assign data_out=data_out_reg;
	
	assign pixel_x=pixel_x_reg;
	assign pixel_y=pixel_y_reg;
	
	localparam [4:0]
	st_0 = 5'd0,
	st_1 = 5'd1,
	st_2 = 5'd2,
	st_3 = 5'd3,
	st_4 = 5'd4,
	st_5 = 5'd5,
	st_6 = 5'd6,
	st_7 = 5'd7,
	st_8 = 5'd8,
	st_9 = 5'd9,
	st_10= 5'd10,
	st_11= 5'd11,
	st_12= 5'd12,
	st_13= 5'd13,
	st_14= 5'd14,
	st_15= 5'd15,
	st_16= 5'd16,
	st_17= 5'd17,
	st_18= 5'd18,
	st_19= 5'd19,
	st_20= 5'd20,
	st_21= 5'd21,
	st_22= 5'd22;

	
	//localparam [23:0] WAIT_CNT=24'd10_000_000;//0.1s上电复位延时
	localparam [23:0] WAIT_CNT=24'd20;//仿真用延时
	
	//localparam [5:0] CLK_DIV=6'd30;//wrx驱动时钟 
	localparam [5:0] CLK_DIV=6'd15;//wrx驱动时钟 仿真用  经过测试，这个频率也可以实际使用
	
	localparam [6:0] INITIAL_DATA_CNT= 7'd93;//初始化数据个数(要比实际的个数+1)
	localparam [6:0] SETWINDOWS_CNT= 7'd104;//设置窗口数据个数(要比实际的个数+1)
	localparam [8:0] XMAX = 9'd319;
	localparam [8:0] YMAX = 9'd479;
	
	always@(posedge clk)begin
		if(rst)begin
			state_reg<=st_0;
			clk_reg<=0;
			initial_data_reg<=0;
			data_out_reg<=9'b111111111;
			wr_reg<=1'b1;
			cs_reg<=1'b1;
			rst_reg<=1'b1;
			wait_reg<=0;
			pixel_x_reg<=0;
			pixel_y_reg<=0;
			data_in_reg<=0;
		end
		else begin
			state_reg<=state_next;
			clk_reg<=clk_next;
			initial_data_reg<=initial_data_next;
			data_out_reg<=data_out_next;
			wr_reg<=wr_next;
			cs_reg<=cs_next;
			rst_reg<=rst_next;
			wait_reg<=wait_next;
			pixel_x_reg<=pixel_x_next;
			pixel_y_reg<=pixel_y_next;
			data_in_reg<=data_in_next;
		end
	end
	
	always@(*)begin
		state_next=state_reg;
		clk_next=clk_reg;
		initial_data_next=initial_data_reg;
		data_out_next=data_out_reg;
		wr_next=1'b1;//wr默认高电平
		cs_next=cs_reg;//注意对cs的控制
		rst_next=1'b1;//rst默认高电平
		wait_next=wait_reg;
		pixel_x_next=pixel_x_reg;
		pixel_y_next=pixel_y_reg;
		data_in_next=data_in_reg;
		case(state_reg)
			st_0:begin
				if(wait_reg==WAIT_CNT)begin
					wait_next=0;
					state_next=st_1;
				end
				else begin
					wait_next=wait_reg+1;
					rst_next=1'b0;
				end
			end
			st_1:begin
				initial_data_next=0;
				clk_next=0;
				state_next=st_2;
				cs_next=1'b0;//在持续刷新的情况下，cs在复位之后一直保持低电平
			end
			st_2:begin
				state_next=st_3;
			end
			st_3:begin
				data_out_next=initial_data;
				state_next=st_4;
			end
			st_4:begin
				if(clk_reg==CLK_DIV)begin
					clk_next=0;
					wr_next=1'b0;
					state_next=st_5;
				end
				else begin
					clk_next=clk_reg+1;
				end
			end
			st_5:begin
				if(clk_reg==CLK_DIV)begin
					clk_next=0;
					initial_data_next=initial_data_cnt+1;
					state_next=st_6;
				end
				else begin
					wr_next=1'b0;
					clk_next=clk_reg+1;
				end
			end
			st_6:begin
				if(clk_reg==CLK_DIV)begin
					clk_next=0;
					if(initial_data_cnt==INITIAL_DATA_CNT)begin
					//此时initial_data_cnt等于93,也是setwindows第一个数据的地址，可以直接使用，不要再加1.
						state_next=st_7;
					end
					else begin
						state_next=st_2;
					end
				end
				else begin
					clk_next=clk_reg+1;
				end
			end
			st_7:begin//相当于st_2
				state_next=st_8;
			end
			st_8:begin//相当于st_3
				data_out_next=initial_data;
				state_next=st_9;
			end
			st_9:begin//相当于st_4
				if(clk_reg==CLK_DIV)begin
					clk_next=0;
					wr_next=1'b0;
					state_next=st_10;
				end
				else begin
					clk_next=clk_reg+1;
				end
			end
			st_10:begin//相当于st_5
				if(clk_reg==CLK_DIV)begin
					clk_next=0;
					initial_data_next=initial_data_cnt+1;
					state_next=st_11;
				end
				else begin
					wr_next=1'b0;
					clk_next=clk_reg+1;
				end
			end
			st_11:begin//相当于st_6
				if(clk_reg==CLK_DIV)begin
					clk_next=0;
					if(initial_data_cnt==SETWINDOWS_CNT)begin
					//此时initial_data_cnt等于104
						state_next=st_12;//准备进入WRITE DRAM
						//初始化坐标
						pixel_x_next=0;
						pixel_y_next=0;
					end
					else begin
						state_next=st_7;
					end
				end
				else begin
					clk_next=clk_reg+1;
				end
			end
			st_12:begin//此时pixel_x,y输出稳定
				state_next=st_13;
			end
			st_13:begin//缓冲状态
				state_next=st_14;
			end
			st_14:begin
				data_out_next={1'b1,data_in[15:8]};//下一周期data被锁存
				data_in_next=data_in;
				state_next=st_15;
			end
			st_15:begin//此时data稳定输出高八位
				if(clk_reg==CLK_DIV)begin
					clk_next=0;
					wr_next=1'b0;//wr提前降为低电平
					state_next=st_16;
				end
				else begin
					clk_next=clk_reg+1;
				end
			end
			st_16:begin
				if(clk_reg==CLK_DIV)begin
					clk_next=0;
					state_next=st_17;
				end
				else begin
					clk_next=clk_reg+1;
					wr_next=1'b0;//wr保持低电平
				end
			end
			st_17:begin//wr==1
				if(clk_reg==CLK_DIV)begin
					clk_next=0;
					state_next=st_18;
					data_out_next={1'b1,data_in_reg[7:0]};//下一周期输出数据低八位
				end
				else begin
					clk_next=clk_reg+1;
				end
			end
			st_18:begin//wr==1
				if(clk_reg==CLK_DIV)begin
					clk_next=0;
					wr_next=1'b0;//wr提前降为低电平
					state_next=st_19;
				end
				else begin
					clk_next=clk_reg+1;
				end
			end
			st_19:begin//wr==0
				if(clk_reg==CLK_DIV)begin
					clk_next=0;
					state_next=st_20;
				end
				else begin
					clk_next=clk_reg+1;
					wr_next=1'b0;//wr保持低电平
				end
			end
			st_20:begin
				if(pixel_x_reg==XMAX)begin
					if(pixel_y_reg==YMAX)begin
						pixel_x_next=0;
						pixel_y_next=0;
						state_next=st_22;
						clk_next=0;
					end
					else begin
						pixel_x_next=0;
						pixel_y_next=pixel_y_reg+1;
						state_next=st_21;
					end
				end
				else begin
					pixel_x_next=pixel_x_reg+1;
					state_next=st_21;
				end
			end
			st_21:begin
				if(clk_reg==CLK_DIV)begin
					clk_next=0;
					state_next=st_14;
				end
				else begin
					clk_next=clk_reg+1;
				end
			end
			st_22:begin//wr=1
				if(clk_reg==CLK_DIV)begin//跳转到setwindows
					clk_next=0;
					state_next=st_7;
					initial_data_next=7'd93;
				end
				else begin
					clk_next=clk_reg+1;
				end
			end
			
		endcase
	end
endmodule
