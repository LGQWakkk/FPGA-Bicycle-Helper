`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/16 20:16:56
// Design Name: 
// Module Name: lora_get
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

//20230616 21:07 编写完毕
//20230616 21:26 放弃编写 没有必要
//Lora Get 接收自行车发过来的数据
//Data Type: A133245B3018.58806C12004.58639D060.85E002.62F

module lora_get(
	input wire lora_rx,
	output wire [5:0] gps_ram_addr,
	output wire [7:0] gps_ram_data,
	output wire gps_ram_we,
	output wire [3:0] jw_ram_addr,
	output wire [7:0] jw_ram_data,
	output wire jw_ram_we,
	output reg lora_rx_get_tick,//连接到lora发送模块
	output wire gps_valid
    );
	
	wire s_tick;
	wire rt;
	wire [7:0] rd;

	uart_rx u_lora_rx(
	.clk(clk),
	.reset(rst),
	.rx(rx),
	.s_tick(s_tick),
	.rx_done_tick(rt),
	.dout(rd)
	);
	
	mod_m_counter u_lora_mod_m_counter(
	.clk(clk),
	.reset(rst),
	.max_tick(s_tick),
	.q()
	);
	
	//状态定义
	localparam [5:0]
	st_idle=6'd0,
	st_1=6'd1,st_2=6'd2,st_3=6'd3,st_4=6'd4,st_5=6'd5,
	st_6=6'd6,st_7=6'd7,st_8=6'd8,st_9=6'd9,st_10=6'd10;
	
	reg [5:0] state_reg,st;//注意这里使用st代表state_next!!!!!
	reg gps_valid_reg,gv;
	
	reg [5:0] ga_reg,ga;
	reg [7:0] gd_reg,gd;//注意这里面为了简略省去了next!!!!!
	reg ge_reg,ge;
	
	reg [3:0] ja_reg,ja;
	reg [7:0] jd_reg,jd;
	reg je_reg,je;
	
	assign gps_ram_addr=ga_reg;
	assign gps_ram_data=gd_reg;
	assign gps_ram_we=ge_reg;
	
	assign jw_ram_addr=ja_reg;
	assign jw_ram_data=jd_reg;
	assign jw_ram_we=je_reg;
	
	assign gps_valid=gps_valid_reg;
	
	localparam [7:0]
	ascii_dou = 8'h2c,
	ascii_qian = 8'h24,
	ascii_G = 8'h47,
	ascii_N = 8'h4e,
	ascii_V = 8'h56,
	ascii_T = 8'h54,
	ascii_R = 8'h52,
	ascii_A = 8'h41;
	
	always@(posedge clk)begin
		if(rst)begin
			state_reg<=st_idle;
			ga_reg<=0;
			gd_reg<=0;
			ge_reg<=0;
			ja_reg<=0;
			jd_reg<=0;
			je_reg<=0;
			gps_valid_reg<=0;
		end
		else begin
			state_reg<=st;
			ga_reg<=ga;
			gd_reg<=gd;
			ge_reg<=ge;
			ja_reg<=ja;
			jd_reg<=jd;
			je_reg<=je;
			gps_valid_reg<=gv;
		end
	end

	always@(*)begin
		st=state_reg;
		ga=ga_reg;
		gd=gd_reg;
		ge=0;
		ja=ja_reg;
		jd=jd_reg;
		je=0;
		gv=gps_valid_reg;
		lora_rx_get_tick=1'b0;
		case(state_reg)
			st_idle:begin
				if(rt)begin
					if(rd==ascii_A)begin
						lora_rx_get_tick=1'b1;
						st=st_1;
					end
					else begin
						if(rd==ascii_V)begin
							gv=1'b0;
							st=st_idle;
						end
						else begin
							lora_rx_get_tick=1'b1;
							st=st_idle;
						end
					end
				end
			end
			st_1:begin
				if(rt)begin
					ga=0;gd=rd;ge=1'b1;st=st_2;
				end
			end
			st_2:begin
				if(rt)begin
					if(ga_reg==5)begin
						if(rd==ascii_B)begin/////////////
							st=st_3;
						end
						else begin
							st=st_idle;
						end
					end
					else begin
						ga=ga_reg+1;
						gd=rd;
						ge=1'b1;
					end
				end
			end
			st_3:begin
				if(rt)begin
					ga=6;gd=rd;ge=1'b1;st=st_4;
				end
			end
			st_4:begin
				if(rt)begin
					if(ga_reg==15)begin
						if(rd==ascii_C)begin/////////////
							st=st_5;
						end
						else begin
							st=st_idle;
						end
					end
					else begin
						ga=ga_reg+1;
						gd=rd;
						ge=1'b1;
					end
				end
			end
			st_5:begin
				if(rt)begin
					ga=16;gd=rd;ge=1'b1;st=st_6;
				end
			end
			st_6:begin
				if(rt)begin
					if(ga_reg==26)begin
						if(rd==ascii_D)begin/////////////
							st=st_7;
						end
						else begin
							st=st_idle;
						end
					end
					else begin
						ga=ga_reg+1;
						gd=rd;
						ge=1'b1;
					end
				end
			end
			st_7:begin
				if(rt)begin
					ga=27;gd=rd;ge=1'b1;st=st_8;
				end
			end
			st_8:begin
				if(rt)begin
					if(ga_reg==32)begin
						if(rd==ascii_E)begin/////////////
							st=st_9;
						end
						else begin
							st=st_idle;
						end
					end
					else begin
						ga=ga_reg+1;
						gd=rd;
						ge=1'b1;
					end
				end
			end
			st_9:begin
				if(rt)begin
					ga=33;gd=rd;ge=1'b1;st=st_10;
				end
			end
			st_10:begin
				if(rt)begin
					if(ga_reg==38)begin
						if(rd==ascii_F)begin/////////////
							st=st_idle;
							gv=1'b1;
						end
						else begin
							st=st_idle;
						end
					end
					else begin
						ga=ga_reg+1;
						gd=rd;
						ge=1'b1;
					end
				end
			end
		endcase
	end
	
endmodule
