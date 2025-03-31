`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/16 16:48:20
// Design Name: 
// Module Name: lora_tx_ctrl
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

//20230616 17:51测试成功
//好像有个bug就是锁存的数据好像不是最新的

module lora_tx_ctrl(
	input wire clk,rst,
	input wire lora_rx_tick,//lora_rx接收到信号的提示
	input wire bell,led,rgb,
	input wire [2:0] rgb_mode,
	input wire must_tx,//强制发送使能
	output wire lora_tx,
	output reg lora_tx_tick//发送指示
    );
	
	
	//串口发送部分及其计数器
	wire s_tick;
	reg tx_start_reg,tx_start_next;
	wire tx_done;
	reg [7:0] tx_data_reg,tx_data_next;
	
	// module mod_m_counter
// #(
	// parameter N=10,//计数器比特数 应为大于log2M的整数
	// M=651//模M
// )
// (
	// input wire clk,reset,
	// output wire max_tick,
	// output wire [N-1:0] q //输出计数值，一般没有什么用
    // );
	mod_m_counter u_lora_module_m_counter(
	.clk(clk),
	.reset(rst),
	.max_tick(s_tick),
	.q()
	);
	// module uart_tx
// #(parameter DBIT= 8,
// SB_TICK = 16
// )
// (
	// input wire clk,rst,
	// input tx_start,s_tick,
	// input wire [7:0] din,
	// output reg tx_done_tick,
	// output wire tx
    // );
	uart_tx u_lora_tx(
	.clk(clk),
	.rst(rst),
	.tx_start(tx_start_reg),
	.s_tick(s_tick),
	.din(tx_data_reg),
	.tx_done_tick(tx_done),
	.tx(lora_tx)
	);
	
	reg [5:0] state_reg,state_next;
	
	localparam [26:0] 
	WAIT1000MS = 27'd100_000_000,
	WAIT500MS = 27'd50_000_000,
	WAIT100MS = 27'd10_000_000;
	
	reg [27:0] wait_reg,wait_next;
	
	
	//发送状态机控制
	//状态定义
	localparam [5:0]
	st_idle=6'd0,
	st_1=6'd1,st_2=6'd2,st_3=6'd3,st_4=6'd4,st_5=6'd5,
	st_6=6'd6,st_7=6'd7,st_8=6'd8,st_9=6'd9,st_10=6'd10;
	
	always@(posedge clk)begin
		if(rst)begin
			state_reg<=st_idle;
			tx_start_reg<=1'b0;
			tx_data_reg<=0;
			wait_reg<=0;
		end
		else begin
			state_reg<=state_next;
			tx_start_reg<=tx_start_next;
			tx_data_reg<=tx_data_next;
			wait_reg<=wait_next;
		end
	end
	
	
	always@(*)begin
		state_next=state_reg;
		tx_start_next=1'b0;//默认为0！
		tx_data_next=tx_data_reg;
		wait_next=wait_reg;
		lora_tx_tick=1'b0;
		//输入信号：
		//tx_done    lora_rx_tick    must_tx
		case(state_reg)
			st_idle:begin
				if(must_tx||lora_rx_tick)begin
					state_next=st_1;
				end
			end
			st_1:begin
				if(wait_reg==WAIT500MS)begin
					wait_next=0;
					state_next=st_2;
				end
				else begin
					wait_next=wait_reg+1;
				end
			end
			st_2:begin
				tx_data_next=8'haa;
				tx_start_next=1'b1;
				state_next=st_3;
				lora_tx_tick=1'b1;
			end
			st_3:begin
				if(tx_done)begin
					tx_data_next={led,rgb,bell,rgb_mode,2'b00};
					tx_start_next=1'b1;
					state_next=st_4;
				end
			end
			st_4:begin
				if(tx_done)begin
					tx_data_next=8'haa;
					tx_start_next=1'b1;
					state_next=st_5;
				end
			end
			st_5:begin
				if(tx_done)begin
					state_next=st_idle;
				end
			end
		endcase
	end
endmodule
