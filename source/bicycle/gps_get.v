`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/13 00:01:07
// Design Name: 
// Module Name: gps_get
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

//20230613 00:03 V1
//20230613 00:43 V1编写完毕
//20230613 01:02 V1测试成功
//20230613 09:29 V2编写完毕
//20230613 13:04 V2测试成功
//20230617 04:00 V3编写完毕


module gps_get(
	input wire rx,
	input wire clk,rst,
	output wire [5:0] gps_ram_addr,
	output wire [7:0] gps_ram_data,
	output wire gps_ram_we,
	output wire [3:0] jw_ram_addr,
	output wire [7:0] jw_ram_data,
	output wire jw_ram_we,
	output wire [3:0] sh_ram_addr,
	output wire [7:0] sh_ram_data,
	output wire sh_ram_we,
	output wire gps_valid
    );
	
	reg [5:0] ga_reg,ga;
	reg [7:0] gd_reg,gd;//注意这里面为了简略省去了next!!!!!
	reg ge_reg,ge;
	
	reg [3:0] ja_reg,ja;
	reg [7:0] jd_reg,jd;
	reg je_reg,je;
	
	reg [3:0] sa_reg,sa;
	reg [7:0] sd_reg,sd;
	reg se_reg,se;
	
	reg [8:0] state_reg,st;//注意这里使用st代表state_next!!!!!
	reg gps_valid_reg,gv;
	
	//未定位数寄存器
	reg [7:0] tmp0_reg,tmp0;
	reg [7:0] tmp1_reg,tmp1;
	reg [7:0] tmp2_reg,tmp2;
	reg [7:0] tmp3_reg,tmp3;
	reg [7:0] tmp4_reg,tmp4;
	reg [7:0] tmp5_reg,tmp5;
	//内外部连线
	assign gps_ram_addr=ga_reg;
	assign gps_ram_data=gd_reg;
	assign gps_ram_we=ge_reg;
	
	assign jw_ram_addr=ja_reg;
	assign jw_ram_data=jd_reg;
	assign jw_ram_we=je_reg;
	
	assign sh_ram_addr=sa_reg;
	assign sh_ram_data=sd_reg;
	assign sh_ram_we=se_reg;
	
	assign gps_valid=gps_valid_reg;
	
//状态定义
localparam [8:0]
st_idle=9'd0,
st_1=9'd1,st_2=9'd2,st_3=9'd3,st_4=9'd4,st_5=9'd5,st_6=9'd6,st_7=9'd7,st_8=9'd8,st_9=9'd9,
st_10=9'd10,st_11=9'd11,st_12=9'd12,st_13=9'd13,st_14=9'd14,st_15=9'd15,st_16=9'd16,st_17=9'd17,st_18=9'd18,st_19=9'd19,
st_20=9'd20,st_21=9'd21,st_22=9'd22,st_23=9'd23,st_24=9'd24,st_25=9'd25,st_26=9'd26,st_27=9'd27,st_28=9'd28,st_29=9'd29,
st_30=9'd30,st_31=9'd31,st_32=9'd32,st_33=9'd33,st_34=9'd34,st_35=9'd35,st_36=9'd36,st_37=9'd37,st_38=9'd38,st_39=9'd39,
st_40=9'd40,st_41=9'd41,st_42=9'd42,st_43=9'd43,st_44=9'd44,st_45=9'd45,st_46=9'd46,st_47=9'd47,st_48=9'd48,st_49=9'd49,
st_50=9'd50,st_51=9'd51,st_52=9'd52,st_53=9'd53,st_54=9'd54,st_55=9'd55,st_56=9'd56,st_57=9'd57,st_58=9'd58,st_59=9'd59,
st_60=9'd60,st_61=9'd61,st_62=9'd62,st_63=9'd63,st_64=9'd64,st_65=9'd65,st_66=9'd66,st_67=9'd67,st_68=9'd68,st_69=9'd69,
st_70=9'd70,st_71=9'd71,st_72=9'd72;
	
	localparam [7:0]
	ascii_dou = 8'h2c,
	ascii_qian = 8'h24,
	ascii_G = 8'h47,
	ascii_N = 8'h4e,
	ascii_V = 8'h56,
	ascii_T = 8'h54,
	ascii_R = 8'h52,
	ascii_A = 8'h41;
	
	wire s_tick;
	wire rt;
	wire [7:0] rd;

	uart_rx u_uart_rx(
	.clk(clk),
	.reset(rst),
	.rx(rx),
	.s_tick(s_tick),
	.rx_done_tick(rt),
	.dout(rd)
	);
	
	//不同的频率模块要区分开！！！
	// module mod_m_counter
// #(
	// parameter N=10,//计数器比特数 应为大于log2M的整数
	// M=651//模M
// )
	mod_m_counter 
	#(.N(10),.M(651))
	u_mod_m_counter_for_uart(
	.clk(clk),
	.reset(rst),
	.max_tick(s_tick),
	.q()
	);
	
	
	always@(posedge clk)begin
		if(rst)begin
			ga_reg<=0;
			gd_reg<=0;
			ge_reg<=0;
			
			ja_reg<=0;
			jd_reg<=0;
			je_reg<=0;
			
			sa_reg<=0;
			sd_reg<=0;
			se_reg<=0;
			
			state_reg<=st_idle;
			gps_valid_reg<=0;
			
			tmp0_reg<=0;
			tmp1_reg<=0;
			tmp2_reg<=0;
			tmp3_reg<=0;
			tmp4_reg<=0;
			tmp5_reg<=0;
		end
		else begin
			ga_reg<=ga;
			gd_reg<=gd;
			ge_reg<=ge;
			
			ja_reg<=ja;
			jd_reg<=jd;
			je_reg<=je;
			
			sa_reg<=sa;
			sd_reg<=sd;
			se_reg<=se;
			
			state_reg<=st;
			gps_valid_reg<=gv;
			
			tmp0_reg<=tmp0;
			tmp1_reg<=tmp1;
			tmp2_reg<=tmp2;
			tmp3_reg<=tmp3;
			tmp4_reg<=tmp4;
			tmp5_reg<=tmp5;
		end
	end
	
	
	always@(*)begin
		ga=ga_reg;
		gd=gd_reg;
		ge=0;
		ja=ja_reg;
		jd=jd_reg;
		je=0;
		sa=sa_reg;
		sd=sd_reg;
		se=0;
		st=state_reg;
		gv=gps_valid_reg;//gps_valid不自动清零！
		
		tmp0=tmp0_reg;
		tmp1=tmp1_reg;
		tmp2=tmp2_reg;
		tmp3=tmp3_reg;
		tmp4=tmp4_reg;
		tmp5=tmp5_reg;
		
		case(state_reg)
			st_idle:begin
				if(rt)begin
					if(rd==ascii_qian)begin
						st=st_1;
					end
				end
			end
			st_1:begin
				if(rt)begin
					if(rd==ascii_G)begin
						st=st_2;
					end
					else begin
						st=st_idle;
					end
				end
			end
			st_2:begin
				if(rt)begin
					if(rd==ascii_N)begin
						st=st_3;
					end
					else begin
						st=st_idle;
					end
				end
			end
			st_3:begin
				if(rt)begin
					if(rd==ascii_R)begin
						st=st_4;
					end
					else begin
						st=st_idle;
					end
				end
			end
			st_4:begin
				if(rt)begin
					if(rd==ascii_dou)begin
						st=st_5;
					end
				end
			end
			st_5:begin
				if(rt)begin
					ga=0;
					gd=rd;
					ge=1;
					st=st_6;
				end
			end
			st_6:begin
				if(rt)begin
					if(ga_reg==5)begin
						st=st_7;
					end
					else begin
						ga=ga_reg+1;
						gd=rd;
						ge=1;
					end
				end
			end
			st_7:begin
				if(rt)begin
					if(rd==ascii_dou)begin
						st=st_8;
					end
				end
			end
			st_8:begin
				if(rt)begin
					if(rd==ascii_A)begin
						gv=1;
						st=st_9;
					end
					else begin
						gv=0;
						st=st_idle;
					end
				end
			end
			st_9:begin
				if(rt)begin
					if(rd==ascii_dou)begin
						st=st_10;
					end
					else begin
						st=st_idle;
					end
				end
			end
			st_10:begin
				if(rt)begin
					ga=6;
					gd=rd;
					ge=1;
					st=st_11;
				end
			end
			st_11:begin
				if(rt)begin
					if(ga_reg==9)begin
						ga=ga_reg+1;
						gd=rd;
						ge=1;
						st=st_12;
					end
					else begin
						ga=ga_reg+1;
						gd=rd;
						ge=1;
					end
				end
			end
			st_12:begin
				if(rt)begin
					ga=11;
					gd=rd;
					ge=1;
					ja=0;
					jd=rd;
					je=1;
					st=st_13;
				end
			end
			st_13:begin
				if(rt)begin
					if(ga_reg==15)begin
						st=st_14;
					end
					else begin
						ga=ga_reg+1;
						gd=rd;
						ge=1;
						ja=ja_reg+1;
						jd=rd;
						je=1;
					end
				end
			end
			st_14:begin
				if(rt)begin
					if(rd==ascii_dou)begin
						st=st_15;
					end
				end
			end
			st_15:begin
				if(rt)begin
					ga=16;
					gd=rd;
					ge=1;
					st=st_16;
				end
			end
			st_16:begin
				if(rt)begin
					if(ga_reg==20)begin
						ga=ga_reg+1;
						gd=rd;
						ge=1;
						st=st_17;
					end
					else begin
						ga=ga_reg+1;
						gd=rd;
						ge=1;
					end
				end
			end
			st_17:begin
				if(rt)begin
					ga=22;
					gd=rd;
					ge=1;
					ja=5;
					jd=rd;
					je=1;
					st=st_18;
				end
			end
			st_18:begin
				if(rt)begin
					if(ga_reg==26)begin
						st=st_19;
					end
					else begin
						ga=ga_reg+1;
						gd=rd;
						ge=1;
						ja=ja_reg+1;
						jd=rd;
						je=1;
					end
				end
			end
			st_19:begin
				if(rt)begin
					if(rd==ascii_qian)begin
						st=st_20;
					end
				end
			end
			st_20:begin
				if(rt)begin
					if(rd==ascii_dou)begin
						st=st_21;
					end
				end
			end
			st_21:begin
				if(rt)begin
					tmp0=rd;
					st=st_22;
				end
			end
			st_22:begin
				if(rt)begin
					tmp1=rd;
					st=st_23;
				end
			end
			st_23:begin
				if(rt)begin
					tmp2=rd;
					st=st_24;
				end
			end
			st_24:begin
				if(rt)begin
					tmp3=rd;
					st=st_25;
				end
			end
			st_25:begin
				if(rt)begin
					if(rd==ascii_dou)begin
						ga=27;
						gd=8'h30;
						ge=1;
						sa=0;
						sd=8'h30;
						se=1;
						st=st_26;
					end
					else begin
						tmp4=rd;
						st=st_32;
					end
				end
			end
			st_26:begin
				ga=28;
				gd=8'h30;
				ge=1;
				sa=1;
				sd=8'h30;
				se=1;
				st=st_27;
			end
			st_27:begin
				ga=29;
				gd=tmp0_reg;
				ge=1;
				sa=2;
				sd=tmp0_reg;
				se=1;
				st=st_28;
			end
			st_28:begin
				ga=30;
				gd=tmp1_reg;
				ge=1;
				st=st_29;
			end
			st_29:begin
				ga=31;
				gd=tmp2_reg;
				ge=1;
				sa=3;
				sd=tmp2_reg;
				se=1;
				st=st_30;
			end
			st_30:begin
				ga=32;
				gd=tmp3_reg;
				ge=1;
				sa=4;
				sd=tmp3_reg;
				se=1;
				st=st_31;
			end
			st_31:begin
				st=st_46;
			end
			///////////////////////////////////
			st_32:begin
				if(rt)begin
					if(rd==ascii_dou)begin
						ga=27;
						gd=8'h30;
						ge=1;
						sa=0;
						sd=8'h30;
						se=1;
						st=st_33;
					end
					else begin
						tmp5=rd;
						st=st_39;
					end
				end
			end
			st_33:begin
				ga=28;
				gd=tmp0_reg;
				ge=1;
				sa=1;
				sd=tmp0_reg;
				se=1;
				st=st_34;
			end
			st_34:begin
				ga=29;
				gd=tmp1_reg;
				ge=1;
				sa=2;
				sd=tmp1_reg;
				se=1;
				st=st_35;
			end
			st_35:begin
				ga=30;
				gd=tmp2_reg;
				ge=1;
				st=st_36;
			end
			st_36:begin
				ga=31;
				gd=tmp3_reg;
				ge=1;
				sa=3;
				sd=tmp3_reg;
				se=1;
				st=st_37;
			end
			st_37:begin
				ga=32;
				gd=tmp4_reg;
				ge=1;
				sa=4;
				sd=tmp4_reg;
				se=1;
				st=st_38;
			end
			st_38:begin
				st=st_46;
			end
			///////////////////////////////
			st_39:begin
				if(rt)begin
					if(rd==ascii_dou)begin
						ga=27;
						gd=tmp0_reg;
						ge=1;
						sa=0;
						sd=tmp0_reg;
						se=1;
						st=st_40;
					end
					else begin
						st=st_idle;
					end
				end
			end
			st_40:begin
				ga=28;
				gd=tmp1_reg;
				ge=1;
				sa=1;
				sd=tmp1_reg;
				se=1;
				st=st_41;
			end
			st_41:begin
				ga=29;
				gd=tmp2_reg;
				ge=1;
				sa=2;
				sd=tmp2_reg;
				se=1;
				st=st_42;
			end
			st_42:begin
				ga=30;
				gd=tmp3_reg;
				ge=1;
				st=st_43;
			end
			st_43:begin
				ga=31;
				gd=tmp4_reg;
				ge=1;
				sa=3;
				sd=tmp4_reg;
				se=1;
				st=st_44;
			end
			st_44:begin
				ga=32;
				gd=tmp5_reg;
				ge=1;
				sa=4;
				sd=tmp5_reg;
				se=1;
				st=st_45;
			end
			st_45:begin
				st=st_46;
			end
			///////////////////////////////////////////////////
			st_46:begin
				if(rt)begin
					if(rd==ascii_N)begin
						st=st_47;
					end
				end
			end
			st_47:begin
				if(rt)begin
					if(rd==ascii_dou)begin
						st=st_48;
					end
					else begin
						st=st_idle;
					end
				end
			end
			st_48:begin
				if(rt)begin
					tmp0=rd;
					st=st_49;
				end
			end
			st_49:begin
				if(rt)begin
					tmp1=rd;
					st=st_50;
				end
			end
			st_50:begin
				if(rt)begin
					tmp2=rd;
					st=st_51;
				end
			end
			st_51:begin
				if(rt)begin
					tmp3=rd;
					st=st_52;
				end
			end
			st_52:begin//需要修改： ga sa st 
				if(rt)begin
					if(rd==ascii_dou)begin
						ga=33;
						gd=8'h30;
						ge=1;
						sa=5;
						sd=8'h30;
						se=1;
						st=st_53;
					end
					else begin
						tmp4=rd;
						st=st_59;
					end
				end
			end
			st_53:begin
				ga=34;
				gd=8'h30;
				ge=1;
				sa=6;
				sd=8'h30;
				se=1;
				st=st_54;
			end
			st_54:begin
				ga=35;
				gd=tmp0_reg;
				ge=1;
				sa=7;
				sd=tmp0_reg;
				se=1;
				st=st_55;
			end
			st_55:begin
				ga=36;
				gd=tmp1_reg;
				ge=1;
				st=st_56;
			end
			st_56:begin
				ga=37;
				gd=tmp2_reg;
				ge=1;
				sa=8;
				sd=tmp2_reg;
				se=1;
				st=st_57;
			end
			st_57:begin
				ga=38;
				gd=tmp3_reg;
				ge=1;
				sa=9;
				sd=tmp3_reg;
				se=1;
				st=st_58;
			end
			st_58:begin
				st=st_idle;
			end
			//////////////////////////////////////
			st_59:begin
				if(rt)begin
					if(rd==ascii_dou)begin
						ga=33;
						gd=8'h30;
						ge=1;
						sa=5;
						sd=8'h30;
						se=1;
						st=st_60;
					end
					else begin
						tmp5=rd;
						st=st_66;
					end
				end
			end
			st_60:begin
				ga=34;
				gd=tmp0_reg;
				ge=1;
				sa=6;
				sd=tmp0_reg;
				se=1;
				st=st_61;
			end
			st_61:begin
				ga=35;
				gd=tmp1_reg;
				ge=1;
				sa=7;
				sd=tmp1_reg;
				se=1;
				st=st_62;
			end
			st_62:begin
				ga=36;
				gd=tmp2_reg;
				ge=1;
				st=st_63;
			end
			st_63:begin
				ga=37;
				gd=tmp3_reg;
				ge=1;
				sa=8;
				sd=tmp3_reg;
				se=1;
				st=st_64;
			end
			st_64:begin
				ga=38;
				gd=tmp4_reg;
				ge=1;
				sa=9;
				sd=tmp4_reg;
				se=1;
				st=st_65;
			end
			st_65:begin
				st=st_idle;
			end
			//////////////////////////////////////////////////////////////
			st_66:begin
				if(rt)begin
					if(rd==ascii_dou)begin
						ga=33;
						gd=tmp0_reg;
						ge=1;
						sa=5;
						sd=tmp0_reg;
						se=1;
						st=st_67;
					end
					else begin
						st=st_idle;
					end
				end
			end
			st_67:begin
				ga=34;
				gd=tmp1_reg;
				ge=1;
				sa=6;
				sd=tmp1_reg;
				se=1;
				st=st_68;
			end
			st_68:begin
				ga=35;
				gd=tmp2_reg;
				ge=1;
				sa=7;
				sd=tmp2_reg;
				se=1;
				st=st_69;
			end
			st_69:begin
				ga=36;
				gd=tmp3_reg;
				ge=1;
				st=st_70;
			end
			st_70:begin
				ga=37;
				gd=tmp4_reg;
				ge=1;
				sa=8;
				sd=tmp4_reg;
				se=1;
				st=st_71;
			end
			st_71:begin
				ga=38;
				gd=tmp5_reg;
				ge=1;
				sa=9;
				sd=tmp5_reg;
				se=1;
				st=st_72;
			end
			st_72:begin
				st=st_idle;
			end
			
		endcase
	end
endmodule
