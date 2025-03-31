`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/16 01:01:43
// Design Name: 
// Module Name: char_display
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


module char_display(
	input wire clk,rst,
	output wire [5:0] gps_ram_addr,
	input wire [7:0] gps_ram_data,
	output wire [5:0] lora_ram_addr,
	input wire [7:0] lora_ram_data,
	//连接地图字符顶层显示模块 数据位数不同！！！
	output wire [9:0] ram_addr,//{row[3:0],col[5:0]}10bit  {pixel_y[7:4],pixel_x[8:3]}
	output wire [6:0] ram_data,
	output wire ram_we
    );
	
	//用到的ASCII字符定义
	localparam [7:0]
	ascii_dou = 8'h2c,
	ascii_qian = 8'h24,
	ascii_G = 8'h47,
	ascii_N = 8'h4e,
	ascii_V = 8'h56,
	ascii_T = 8'h54,
	ascii_R = 8'h52,
	ascii_A = 8'h41,
	ascii_M=8'h4d,
	ascii_o=8'h6f,
	ascii_b=8'h62,
	ascii_i=8'h69,
	ascii_l=8'h6c,
	ascii_e=8'h65,
	ascii_I=8'h49,
	ascii_n=8'h6e,
	ascii_f=8'h66,
	ascii_r=8'h72,
	ascii_m=8'h6d,
	ascii_a=8'h61,
	ascii_t=8'h74,
	ascii_U=8'h55,
	ascii_C=8'h43,
	ascii_L=8'h4c,
	ascii_u=8'h75,
	ascii_d=8'h64,
	ascii_g=8'h67,
	ascii_S=8'h53,
	ascii_p=8'h70,
	ascii_H=8'h48,
	ascii_B=8'h42,
	ascii_c=8'h63,
	ascii_y=8'h79,
	ascii_E=8'h45,
	ascii_D=8'h44,
	ascii_k=8'h6b;
	
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
st_70=9'd70,st_71=9'd71,st_72=9'd72,st_73=9'd73,st_74=9'd74,st_75=9'd75,st_76=9'd76,st_77=9'd77,st_78=9'd78,st_79=9'd79,
st_80=9'd80,st_81=9'd81,st_82=9'd82,st_83=9'd83,st_84=9'd84,st_85=9'd85,st_86=9'd86,st_87=9'd87,st_88=9'd88,st_89=9'd89,
st_90=9'd90,st_91=9'd91,st_92=9'd92,st_93=9'd93,st_94=9'd94,st_95=9'd95,st_96=9'd96,st_97=9'd97,st_98=9'd98,st_99=9'd99,
st_100=9'd100,st_101=9'd101,st_102=9'd102,st_103=9'd103,st_104=9'd104,st_105=9'd105,st_106=9'd106,st_107=9'd107,st_108=9'd108,st_109=9'd109,
st_110=9'd110,st_111=9'd111,st_112=9'd112,st_113=9'd113,st_114=9'd114,st_115=9'd115,st_116=9'd116,st_117=9'd117,st_118=9'd118,st_119=9'd119,
st_120=9'd120,st_121=9'd121,st_122=9'd122,st_123=9'd123,st_124=9'd124,st_125=9'd125,st_126=9'd126,st_127=9'd127,st_128=9'd128,st_129=9'd129,
st_130=9'd130,st_131=9'd131,st_132=9'd132,st_133=9'd133,st_134=9'd134,st_135=9'd135,st_136=9'd136,st_137=9'd137,st_138=9'd138,st_139=9'd139,
st_140=9'd140,st_141=9'd141,st_142=9'd142,st_143=9'd143,st_144=9'd144,st_145=9'd145,st_146=9'd146,st_147=9'd147,st_148=9'd148,st_149=9'd149,
st_150=9'd150,st_151=9'd151,st_152=9'd152,st_153=9'd153,st_154=9'd154,st_155=9'd155,st_156=9'd156,st_157=9'd157,st_158=9'd158,st_159=9'd159,
st_160=9'd160,st_161=9'd161,st_162=9'd162,st_163=9'd163,st_164=9'd164,st_165=9'd165,st_166=9'd166,st_167=9'd167,st_168=9'd168,st_169=9'd169,
st_170=9'd170,st_171=9'd171,st_172=9'd172,st_173=9'd173,st_174=9'd174,st_175=9'd175,st_176=9'd176,st_177=9'd177,st_178=9'd178,st_179=9'd179,
st_180=9'd180,st_181=9'd181,st_182=9'd182,st_183=9'd183,st_184=9'd184,st_185=9'd185,st_186=9'd186,st_187=9'd187,st_188=9'd188,st_189=9'd189,
st_190=9'd190,st_191=9'd191,st_192=9'd192,st_193=9'd193,st_194=9'd194,st_195=9'd195,st_196=9'd196,st_197=9'd197,st_198=9'd198,st_199=9'd199,
st_200=9'd200,st_201=9'd201,st_202=9'd202,st_203=9'd203,st_204=9'd204,st_205=9'd205,st_206=9'd206,st_207=9'd207,st_208=9'd208,st_209=9'd209;

	reg [9:0] state_reg,state_next;
	
	reg [5:0] gps_ram_addr_reg,gps_ram_addr_next;
	reg [5:0] lora_ram_addr_reg,lora_ram_addr_next;
	
	reg ram_we_reg,ram_we_next;
	reg [3:0] row_reg,row_next;//0-14
	reg [5:0] col_reg,col_next;//0-39
	assign ram_addr = {row_reg,col_reg};
	assign ram_we = ram_we_reg;
	
	reg [7:0] data_reg,data_next;
	assign ram_data = data_reg[6:0];//位数适配
	
	assign gps_ram_addr = gps_ram_addr_reg;
	assign lora_ram_addr = lora_ram_addr_reg;
	
	always@(posedge clk)begin
		if(rst)begin
			state_reg<=st_idle;
			gps_ram_addr_reg<=0;
			lora_ram_addr_reg<=0;
			row_reg<=0;
			col_reg<=0;
			data_reg<=0;
			ram_we_reg<=0;
		end
		else begin
			state_reg<=state_next;
			gps_ram_addr_reg<=gps_ram_addr_next;
			lora_ram_addr_reg<=lora_ram_addr_next;
			row_reg<=row_next;
			col_reg<=col_next;
			data_reg<=data_next;
			ram_we_reg<=ram_we_next;
		end
	end
	
	always@(*)begin
		state_next=state_reg;
		gps_ram_addr_next=gps_ram_addr_reg;
		lora_ram_addr_next=lora_ram_addr_reg;
		row_next=row_reg;
		col_next=col_reg;
		data_next=data_reg;
		ram_we_next=1'b0;//默认为0
		//输入数据接口：
		//gps_ram_data
		//lora_ram_data
		//地址控制接口
		//gps_ram_addr_next=;
		//lora_ram_addr_next=;
		
		case(state_reg)
			st_idle:begin
				state_next=st_1;
			end
			st_1:begin
				state_next=st_2;
				row_next=0;
				col_next=0;
				data_next=ascii_M;
				ram_we_next=1'b1;
			end
			st_2:begin
				state_next=st_3;
				row_next=0;
				col_next=1;
				data_next=ascii_o;
				ram_we_next=1'b1;
			end
			st_3:begin
				state_next=st_4;
				row_next=0;
				col_next=2;
				data_next=ascii_b;
				ram_we_next=1'b1;
			end
			st_4:begin
				state_next=st_5;
				row_next=0;
				col_next=3;
				data_next=ascii_i;
				ram_we_next=1'b1;
			end
			st_5:begin
				state_next=st_6;
				row_next=0;
				col_next=4;
				data_next=ascii_l;
				ram_we_next=1'b1;
			end
			st_6:begin
				state_next=st_7;
				row_next=0;
				col_next=5;
				data_next=ascii_e;
				ram_we_next=1'b1;
			end
			st_7:begin
				state_next=st_8;
				row_next=0;
				col_next=6;
				data_next=8'h00;
				ram_we_next=1'b1;
			end
			st_8:begin
				state_next=st_9;
				row_next=0;
				col_next=7;
				data_next=ascii_I;
				ram_we_next=1'b1;
			end
			st_9:begin
				state_next=st_10;
				row_next=0;
				col_next=8;
				data_next=ascii_n;
				ram_we_next=1'b1;
			end
			st_10:begin
				state_next=st_11;
				row_next=0;
				col_next=9;
				data_next=ascii_f;
				ram_we_next=1'b1;
			end
			st_11:begin
				state_next=st_12;
				row_next=0;
				col_next=10;
				data_next=ascii_o;
				ram_we_next=1'b1;
			end
			st_12:begin
				state_next=st_13;
				row_next=0;
				col_next=11;
				data_next=ascii_r;
				ram_we_next=1'b1;
			end
			st_13:begin
				state_next=st_14;
				row_next=0;
				col_next=12;
				data_next=ascii_m;
				ram_we_next=1'b1;
			end
			st_14:begin
				state_next=st_15;
				row_next=0;
				col_next=13;
				data_next=ascii_a;
				ram_we_next=1'b1;
			end
			st_15:begin
				state_next=st_16;
				row_next=0;
				col_next=14;
				data_next=ascii_t;
				ram_we_next=1'b1;
			end
			st_16:begin
				state_next=st_17;
				row_next=0;
				col_next=15;
				data_next=ascii_i;
				ram_we_next=1'b1;
			end
			st_17:begin
				state_next=st_18;
				row_next=0;
				col_next=16;
				data_next=ascii_o;
				ram_we_next=1'b1;
			end
			st_18:begin
				state_next=st_19;
				row_next=0;
				col_next=17;
				data_next=ascii_n;
				ram_we_next=1'b1;
			end
			//UTC Time
			st_19:begin state_next=st_20; row_next=1;col_next=0;data_next=ascii_U;ram_we_next=1'b1; end
			st_20:begin state_next=st_21; row_next=1;col_next=1;data_next=ascii_T;ram_we_next=1'b1; end
			st_21:begin state_next=st_22; row_next=1;col_next=2;data_next=ascii_C;ram_we_next=1'b1; end
			st_22:begin state_next=st_23; row_next=1;col_next=3;data_next=8'h00;ram_we_next=1'b1; end
			st_23:begin state_next=st_24; row_next=1;col_next=4;data_next=ascii_T;ram_we_next=1'b1; end
			st_24:begin state_next=st_25; row_next=1;col_next=5;data_next=ascii_i;ram_we_next=1'b1; end
			st_25:begin state_next=st_26; row_next=1;col_next=6;data_next=ascii_m;ram_we_next=1'b1; end
			st_26:begin state_next=st_27; row_next=1;col_next=7;data_next=ascii_e;ram_we_next=1'b1; end
			//Latitude
			st_27:begin state_next=st_28; row_next=2;col_next=0;data_next=ascii_L;ram_we_next=1'b1; end
			st_28:begin state_next=st_29; row_next=2;col_next=1;data_next=ascii_a;ram_we_next=1'b1; end
			st_29:begin state_next=st_30; row_next=2;col_next=2;data_next=ascii_t;ram_we_next=1'b1; end
			st_30:begin state_next=st_31; row_next=2;col_next=3;data_next=ascii_i;ram_we_next=1'b1; end
			st_31:begin state_next=st_32; row_next=2;col_next=4;data_next=ascii_t;ram_we_next=1'b1; end
			st_32:begin state_next=st_33; row_next=2;col_next=5;data_next=ascii_u;ram_we_next=1'b1; end
			st_33:begin state_next=st_34; row_next=2;col_next=6;data_next=ascii_d;ram_we_next=1'b1; end
			st_34:begin state_next=st_35; row_next=2;col_next=7;data_next=ascii_e;ram_we_next=1'b1; end
			//Longitude
			st_35:begin state_next=st_36; row_next=3;col_next=0;data_next=ascii_L;ram_we_next=1'b1; end
			st_36:begin state_next=st_37; row_next=3;col_next=1;data_next=ascii_o;ram_we_next=1'b1; end
			st_37:begin state_next=st_38; row_next=3;col_next=2;data_next=ascii_n;ram_we_next=1'b1; end
			st_38:begin state_next=st_39; row_next=3;col_next=3;data_next=ascii_g;ram_we_next=1'b1; end
			st_39:begin state_next=st_40; row_next=3;col_next=4;data_next=ascii_i;ram_we_next=1'b1; end
			st_40:begin state_next=st_41; row_next=3;col_next=5;data_next=ascii_t;ram_we_next=1'b1; end
			st_41:begin state_next=st_42; row_next=3;col_next=6;data_next=ascii_u;ram_we_next=1'b1; end
			st_42:begin state_next=st_43; row_next=3;col_next=7;data_next=ascii_d;ram_we_next=1'b1; end
			st_43:begin state_next=st_44; row_next=3;col_next=8;data_next=ascii_e;ram_we_next=1'b1; end
			//Speed
			st_44:begin state_next=st_45; row_next=4;col_next=0;data_next=ascii_S;ram_we_next=1'b1; end
			st_45:begin state_next=st_46; row_next=4;col_next=1;data_next=ascii_p;ram_we_next=1'b1; end
			st_46:begin state_next=st_47; row_next=4;col_next=2;data_next=ascii_e;ram_we_next=1'b1; end
			st_47:begin state_next=st_48; row_next=4;col_next=3;data_next=ascii_e;ram_we_next=1'b1; end
			st_48:begin state_next=st_49; row_next=4;col_next=4;data_next=ascii_d;ram_we_next=1'b1; end
			//Heading
			st_49:begin state_next=st_50; row_next=5;col_next=0;data_next=ascii_H;ram_we_next=1'b1; end
			st_50:begin state_next=st_51; row_next=5;col_next=1;data_next=ascii_e;ram_we_next=1'b1; end
			st_51:begin state_next=st_52; row_next=5;col_next=2;data_next=ascii_a;ram_we_next=1'b1; end
			st_52:begin state_next=st_53; row_next=5;col_next=3;data_next=ascii_d;ram_we_next=1'b1; end
			st_53:begin state_next=st_54; row_next=5;col_next=4;data_next=ascii_i;ram_we_next=1'b1; end
			st_54:begin state_next=st_55; row_next=5;col_next=5;data_next=ascii_n;ram_we_next=1'b1; end
			st_55:begin state_next=st_56; row_next=5;col_next=6;data_next=ascii_g;ram_we_next=1'b1; end
			//Bicycle Information
			st_56:begin state_next=st_57; row_next=6;col_next=0;data_next=ascii_B;ram_we_next=1'b1; end
			st_57:begin state_next=st_58; row_next=6;col_next=1;data_next=ascii_i;ram_we_next=1'b1; end
			st_58:begin state_next=st_59; row_next=6;col_next=2;data_next=ascii_c;ram_we_next=1'b1; end
			st_59:begin state_next=st_60; row_next=6;col_next=3;data_next=ascii_y;ram_we_next=1'b1; end
			st_60:begin state_next=st_61; row_next=6;col_next=4;data_next=ascii_c;ram_we_next=1'b1; end
			st_61:begin state_next=st_62; row_next=6;col_next=5;data_next=ascii_l;ram_we_next=1'b1; end
			st_62:begin state_next=st_63; row_next=6;col_next=6;data_next=ascii_e;ram_we_next=1'b1; end
			st_63:begin state_next=st_64; row_next=6;col_next=7;data_next=8'h00;ram_we_next=1'b1; end
			st_64:begin state_next=st_65; row_next=6;col_next=8;data_next=ascii_I;ram_we_next=1'b1; end
			st_65:begin state_next=st_66; row_next=6;col_next=9;data_next=ascii_n;ram_we_next=1'b1; end
			st_66:begin state_next=st_67; row_next=6;col_next=10;data_next=ascii_f;ram_we_next=1'b1; end
			st_67:begin state_next=st_68; row_next=6;col_next=11;data_next=ascii_o;ram_we_next=1'b1; end
			st_68:begin state_next=st_69; row_next=6;col_next=12;data_next=ascii_r;ram_we_next=1'b1; end
			st_69:begin state_next=st_70; row_next=6;col_next=13;data_next=ascii_m;ram_we_next=1'b1; end
			st_70:begin state_next=st_71; row_next=6;col_next=14;data_next=ascii_a;ram_we_next=1'b1; end
			st_71:begin state_next=st_72; row_next=6;col_next=15;data_next=ascii_t;ram_we_next=1'b1; end
			st_72:begin state_next=st_73; row_next=6;col_next=16;data_next=ascii_i;ram_we_next=1'b1; end
			st_73:begin state_next=st_74; row_next=6;col_next=17;data_next=ascii_o;ram_we_next=1'b1; end
			st_74:begin state_next=st_75; row_next=6;col_next=18;data_next=ascii_n;ram_we_next=1'b1; end
			
			//Latitude
			st_75:begin state_next=st_76; row_next=7;col_next=0;data_next=ascii_L;ram_we_next=1'b1; end
			st_76:begin state_next=st_77; row_next=7;col_next=1;data_next=ascii_a;ram_we_next=1'b1; end
			st_77:begin state_next=st_78; row_next=7;col_next=2;data_next=ascii_t;ram_we_next=1'b1; end
			st_78:begin state_next=st_79; row_next=7;col_next=3;data_next=ascii_i;ram_we_next=1'b1; end
			st_79:begin state_next=st_80; row_next=7;col_next=4;data_next=ascii_t;ram_we_next=1'b1; end
			st_80:begin state_next=st_81; row_next=7;col_next=5;data_next=ascii_u;ram_we_next=1'b1; end
			st_81:begin state_next=st_82; row_next=7;col_next=6;data_next=ascii_d;ram_we_next=1'b1; end
			st_82:begin state_next=st_83; row_next=7;col_next=7;data_next=ascii_e;ram_we_next=1'b1; end
			//Longitude
			st_83:begin state_next=st_84; row_next=8;col_next=0;data_next=ascii_L;ram_we_next=1'b1; end
			st_84:begin state_next=st_85; row_next=8;col_next=1;data_next=ascii_o;ram_we_next=1'b1; end
			st_85:begin state_next=st_86; row_next=8;col_next=2;data_next=ascii_n;ram_we_next=1'b1; end
			st_86:begin state_next=st_87; row_next=8;col_next=3;data_next=ascii_g;ram_we_next=1'b1; end
			st_87:begin state_next=st_88; row_next=8;col_next=4;data_next=ascii_i;ram_we_next=1'b1; end
			st_88:begin state_next=st_89; row_next=8;col_next=5;data_next=ascii_t;ram_we_next=1'b1; end
			st_89:begin state_next=st_90; row_next=8;col_next=6;data_next=ascii_u;ram_we_next=1'b1; end
			st_90:begin state_next=st_91; row_next=8;col_next=7;data_next=ascii_d;ram_we_next=1'b1; end
			st_91:begin state_next=st_92; row_next=8;col_next=8;data_next=ascii_e;ram_we_next=1'b1; end
			//Speed
			st_92:begin state_next=st_93; row_next=9;col_next=0;data_next=ascii_S;ram_we_next=1'b1; end
			st_93:begin state_next=st_94; row_next=9;col_next=1;data_next=ascii_p;ram_we_next=1'b1; end
			st_94:begin state_next=st_95; row_next=9;col_next=2;data_next=ascii_e;ram_we_next=1'b1; end
			st_95:begin state_next=st_96; row_next=9;col_next=3;data_next=ascii_e;ram_we_next=1'b1; end
			st_96:begin state_next=st_97; row_next=9;col_next=4;data_next=ascii_d;ram_we_next=1'b1; end
			//Heading
			st_97:begin state_next=st_98; row_next=10;col_next=0;data_next=ascii_H;ram_we_next=1'b1; end
			st_98:begin state_next=st_99; row_next=10;col_next=1;data_next=ascii_e;ram_we_next=1'b1; end
			st_99:begin state_next=st_100; row_next=10;col_next=2;data_next=ascii_a;ram_we_next=1'b1; end
			st_100:begin state_next=st_101; row_next=10;col_next=3;data_next=ascii_d;ram_we_next=1'b1; end
			st_101:begin state_next=st_102; row_next=10;col_next=4;data_next=ascii_i;ram_we_next=1'b1; end
			st_102:begin state_next=st_103; row_next=10;col_next=5;data_next=ascii_n;ram_we_next=1'b1; end
			st_103:begin state_next=st_104; row_next=10;col_next=6;data_next=ascii_g;ram_we_next=1'b1; end
			//Bell
			st_104:begin state_next=st_105; row_next=11;col_next=0;data_next=ascii_B;ram_we_next=1'b1; end
			st_105:begin state_next=st_106; row_next=11;col_next=1;data_next=ascii_e;ram_we_next=1'b1; end
			st_106:begin state_next=st_107; row_next=11;col_next=2;data_next=ascii_l;ram_we_next=1'b1; end
			st_107:begin state_next=st_108; row_next=11;col_next=3;data_next=ascii_l;ram_we_next=1'b1; end
			//LED
			st_108:begin state_next=st_109; row_next=12;col_next=0;data_next=ascii_L;ram_we_next=1'b1; end
			st_109:begin state_next=st_110; row_next=12;col_next=1;data_next=ascii_E;ram_we_next=1'b1; end
			st_110:begin state_next=st_111; row_next=12;col_next=2;data_next=ascii_D;ram_we_next=1'b1; end
			//RGB Mode
			st_111:begin state_next=st_112; row_next=13;col_next=0;data_next=ascii_R;ram_we_next=1'b1; end
			st_112:begin state_next=st_113; row_next=13;col_next=1;data_next=ascii_G;ram_we_next=1'b1; end
			st_113:begin state_next=st_114; row_next=13;col_next=2;data_next=ascii_B;ram_we_next=1'b1; end
			st_114:begin state_next=st_115; row_next=13;col_next=3;data_next=8'h00;ram_we_next=1'b1; end
			st_115:begin state_next=st_116; row_next=13;col_next=4;data_next=ascii_M;ram_we_next=1'b1; end
			st_116:begin state_next=st_117; row_next=13;col_next=5;data_next=ascii_o;ram_we_next=1'b1; end
			st_117:begin state_next=st_118; row_next=13;col_next=6;data_next=ascii_d;ram_we_next=1'b1; end
			st_118:begin state_next=st_119; row_next=13;col_next=7;data_next=ascii_e;ram_we_next=1'b1; end
			//Lock Safety
			st_119:begin state_next=st_120; row_next=14;col_next=0;data_next=ascii_L;ram_we_next=1'b1; end
			st_120:begin state_next=st_121; row_next=14;col_next=1;data_next=ascii_o;ram_we_next=1'b1; end
			st_121:begin state_next=st_122; row_next=14;col_next=2;data_next=ascii_c;ram_we_next=1'b1; end
			st_122:begin state_next=st_123; row_next=14;col_next=3;data_next=ascii_k;ram_we_next=1'b1; end
			st_123:begin state_next=st_124; row_next=14;col_next=4;data_next=8'h00;ram_we_next=1'b1; end
			st_124:begin state_next=st_125; row_next=14;col_next=5;data_next=ascii_S;ram_we_next=1'b1; end
			st_125:begin state_next=st_126; row_next=14;col_next=6;data_next=ascii_a;ram_we_next=1'b1; end
			st_126:begin state_next=st_127; row_next=14;col_next=7;data_next=ascii_f;ram_we_next=1'b1; end
			st_127:begin state_next=st_128; row_next=14;col_next=8;data_next=ascii_e;ram_we_next=1'b1; end
			st_128:begin state_next=st_129; row_next=14;col_next=9;data_next=ascii_t;ram_we_next=1'b1; end
			st_129:begin state_next=st_130; row_next=14;col_next=10;data_next=ascii_y;ram_we_next=1'b1; end
			
			/////////////////////////////////////////////下面开始持续刷新//////////////////////////////////////
		//输入数据接口：
		//gps_ram_data
		//lora_ram_data
		//地址控制接口
		//gps_ram_addr_next=;
		//lora_ram_addr_next=;
		
	// reg ram_we_reg,ram_we_next;
	// reg [3:0] row_reg,row_next;//0-14
	// reg [5:0] col_reg,col_next;//0-39
	// assign ram_addr = {row_reg,col_reg};
	// assign ram_we = ram_we_reg;
	
	// reg [7:0] data_reg,data_next;
	
			//数据流准备阶段
			st_130:begin state_next=st_131;gps_ram_addr_next=0;end
			st_131:begin state_next=st_132;gps_ram_addr_next=1;end
			st_132:begin state_next=st_133;gps_ram_addr_next=2;ram_we_next=1'b1;
			////////////////////////////////////////////////////////////////////////UTC Time
				row_next=1;col_next=11;//0
				data_next=gps_ram_data;end
			//数据流循环开始
			st_133:begin state_next=st_134;gps_ram_addr_next=3;ram_we_next=1'b1;
				row_next=1;col_next=12;//1
				data_next=gps_ram_data;end
			st_134:begin state_next=st_135;gps_ram_addr_next=4;ram_we_next=1'b1;
				row_next=1;col_next=14;//2
				data_next=gps_ram_data;end
			st_135:begin state_next=st_136;gps_ram_addr_next=5;ram_we_next=1'b1;
				row_next=1;col_next=15;//3
				data_next=gps_ram_data;end
			st_136:begin state_next=st_137;gps_ram_addr_next=6;ram_we_next=1'b1;
				row_next=1;col_next=17;//4
				data_next=gps_ram_data;end
			st_137:begin state_next=st_138;gps_ram_addr_next=7;ram_we_next=1'b1;
				row_next=1;col_next=18;//5
				data_next=gps_ram_data;end
				////////////////////////////////////////////////////////////////////////Latitude
			st_138:begin state_next=st_139;gps_ram_addr_next=8;ram_we_next=1'b1;
				row_next=2;col_next=11;//6
				data_next=gps_ram_data;end
			st_139:begin state_next=st_140;gps_ram_addr_next=9;ram_we_next=1'b1;
				row_next=2;col_next=12;//7
				data_next=gps_ram_data;end
			st_140:begin state_next=st_141;gps_ram_addr_next=10;ram_we_next=1'b1;
				row_next=2;col_next=13;//8
				data_next=gps_ram_data;end
			st_141:begin state_next=st_142;gps_ram_addr_next=11;ram_we_next=1'b1;
				row_next=2;col_next=14;//9
				data_next=gps_ram_data;end
			st_142:begin state_next=st_143;gps_ram_addr_next=12;ram_we_next=1'b1;
				row_next=2;col_next=15;//10
				data_next=gps_ram_data;end
			st_143:begin state_next=st_144;gps_ram_addr_next=13;ram_we_next=1'b1;
				row_next=2;col_next=16;//11
				data_next=gps_ram_data;end
			st_144:begin state_next=st_145;gps_ram_addr_next=14;ram_we_next=1'b1;
				row_next=2;col_next=17;//12
				data_next=gps_ram_data;end
			st_145:begin state_next=st_146;gps_ram_addr_next=15;ram_we_next=1'b1;
				row_next=2;col_next=18;//13
				data_next=gps_ram_data;end
			st_146:begin state_next=st_147;gps_ram_addr_next=16;ram_we_next=1'b1;
				row_next=2;col_next=19;//14
				data_next=gps_ram_data;end
			st_147:begin state_next=st_148;gps_ram_addr_next=17;ram_we_next=1'b1;
				row_next=2;col_next=20;//15
				data_next=gps_ram_data;end
				////////////////////////////////////////////////////////////////////////Longitude
			st_148:begin state_next=st_149;gps_ram_addr_next=18;ram_we_next=1'b1;
				row_next=3;col_next=10;//16
				data_next=gps_ram_data;end
			st_149:begin state_next=st_150;gps_ram_addr_next=19;ram_we_next=1'b1;
				row_next=3;col_next=11;//17
				data_next=gps_ram_data;end
			st_150:begin state_next=st_151;gps_ram_addr_next=20;ram_we_next=1'b1;
				row_next=3;col_next=12;//18
				data_next=gps_ram_data;end
			st_151:begin state_next=st_152;gps_ram_addr_next=21;ram_we_next=1'b1;
				row_next=3;col_next=13;//19
				data_next=gps_ram_data;end
			st_152:begin state_next=st_153;gps_ram_addr_next=22;ram_we_next=1'b1;
				row_next=3;col_next=14;//20
				data_next=gps_ram_data;end
			st_153:begin state_next=st_154;gps_ram_addr_next=23;ram_we_next=1'b1;
				row_next=3;col_next=15;//21
				data_next=gps_ram_data;end
			st_154:begin state_next=st_155;gps_ram_addr_next=24;ram_we_next=1'b1;
				row_next=3;col_next=16;//22
				data_next=gps_ram_data;end
			st_155:begin state_next=st_156;gps_ram_addr_next=25;ram_we_next=1'b1;
				row_next=3;col_next=17;//23
				data_next=gps_ram_data;end
			st_156:begin state_next=st_157;gps_ram_addr_next=26;ram_we_next=1'b1;
				row_next=3;col_next=18;//24
				data_next=gps_ram_data;end
			st_157:begin state_next=st_158;gps_ram_addr_next=27;ram_we_next=1'b1;
				row_next=3;col_next=19;//25
				data_next=gps_ram_data;end
			st_158:begin state_next=st_159;gps_ram_addr_next=28;ram_we_next=1'b1;
				row_next=3;col_next=20;//26
				data_next=gps_ram_data;end
			////////////////////////////////////////////////////////////////////////Heading
			st_159:begin state_next=st_160;gps_ram_addr_next=29;ram_we_next=1'b1;
				row_next=5;col_next=10;//27
				data_next=gps_ram_data;end
			st_160:begin state_next=st_161;gps_ram_addr_next=30;ram_we_next=1'b1;
				row_next=5;col_next=11;//28
				data_next=gps_ram_data;end
			st_161:begin state_next=st_162;gps_ram_addr_next=31;ram_we_next=1'b1;
				row_next=5;col_next=12;//29
				data_next=gps_ram_data;end
			st_162:begin state_next=st_163;gps_ram_addr_next=32;ram_we_next=1'b1;
				row_next=5;col_next=13;//30
				data_next=gps_ram_data;end
			st_163:begin state_next=st_164;gps_ram_addr_next=33;ram_we_next=1'b1;
				row_next=5;col_next=14;//31
				data_next=gps_ram_data;end
			st_164:begin state_next=st_165;gps_ram_addr_next=34;ram_we_next=1'b1;
				row_next=5;col_next=15;//32
				data_next=gps_ram_data;end
			////////////////////////////////////////////////////////////////////////Speed
			st_165:begin state_next=st_166;gps_ram_addr_next=35;ram_we_next=1'b1;
				row_next=4;col_next=10;//33
				data_next=gps_ram_data;end
			st_166:begin state_next=st_167;gps_ram_addr_next=36;ram_we_next=1'b1;
				row_next=4;col_next=11;//34
				data_next=gps_ram_data;end
			st_167:begin state_next=st_168;gps_ram_addr_next=37;ram_we_next=1'b1;
				row_next=4;col_next=12;//35
				data_next=gps_ram_data;end
			st_168:begin state_next=st_169;gps_ram_addr_next=38;ram_we_next=1'b1;
				row_next=4;col_next=13;//36
				data_next=gps_ram_data;end
			////////////////////////////////////////////////////////////////////
			st_169:begin state_next=st_170;lora_ram_addr_next=6;ram_we_next=1'b1;
				row_next=4;col_next=14;//37
				data_next=gps_ram_data;end
			st_170:begin state_next=st_171;lora_ram_addr_next=7;ram_we_next=1'b1;
				row_next=4;col_next=15;//38
				data_next=gps_ram_data;end
				//////////////////////////////////////////////Bicycle Information
			////////////////////////////////////////////////////////////////////Latitude
			st_171:begin state_next=st_172;lora_ram_addr_next=8;ram_we_next=1'b1;
				row_next=7;col_next=11;//6
				data_next=lora_ram_data;end
			st_172:begin state_next=st_173;lora_ram_addr_next=9;ram_we_next=1'b1;
				row_next=7;col_next=12;//7
				data_next=lora_ram_data;end
			st_173:begin state_next=st_174;lora_ram_addr_next=10;ram_we_next=1'b1;
				row_next=7;col_next=13;//8
				data_next=lora_ram_data;end
			st_174:begin state_next=st_175;lora_ram_addr_next=11;ram_we_next=1'b1;
				row_next=7;col_next=14;//9
				data_next=lora_ram_data;end
			st_175:begin state_next=st_176;lora_ram_addr_next=12;ram_we_next=1'b1;
				row_next=7;col_next=15;//10
				data_next=lora_ram_data;end
			st_176:begin state_next=st_177;lora_ram_addr_next=13;ram_we_next=1'b1;
				row_next=7;col_next=16;//11
				data_next=lora_ram_data;end
			st_177:begin state_next=st_178;lora_ram_addr_next=14;ram_we_next=1'b1;
				row_next=7;col_next=17;//12
				data_next=lora_ram_data;end
			st_178:begin state_next=st_179;lora_ram_addr_next=15;ram_we_next=1'b1;
				row_next=7;col_next=18;//13
				data_next=lora_ram_data;end
			st_179:begin state_next=st_180;lora_ram_addr_next=16;ram_we_next=1'b1;
				row_next=7;col_next=19;//14
				data_next=lora_ram_data;end
			st_180:begin state_next=st_181;lora_ram_addr_next=17;ram_we_next=1'b1;
				row_next=7;col_next=20;//15
				data_next=lora_ram_data;end
				/////////////////////////////////////////////////////////Longitude
			st_181:begin state_next=st_182;lora_ram_addr_next=18;ram_we_next=1'b1;
				row_next=8;col_next=10;//16
				data_next=lora_ram_data;end
			st_182:begin state_next=st_183;lora_ram_addr_next=19;ram_we_next=1'b1;
				row_next=8;col_next=11;//17
				data_next=lora_ram_data;end
			st_183:begin state_next=st_184;lora_ram_addr_next=20;ram_we_next=1'b1;
				row_next=8;col_next=12;//18
				data_next=lora_ram_data;end
			st_184:begin state_next=st_185;lora_ram_addr_next=21;ram_we_next=1'b1;
				row_next=8;col_next=13;//19
				data_next=lora_ram_data;end
			st_185:begin state_next=st_186;lora_ram_addr_next=22;ram_we_next=1'b1;
				row_next=8;col_next=14;//20
				data_next=lora_ram_data;end
			st_186:begin state_next=st_187;lora_ram_addr_next=23;ram_we_next=1'b1;
				row_next=8;col_next=15;//21
				data_next=lora_ram_data;end
			st_187:begin state_next=st_188;lora_ram_addr_next=24;ram_we_next=1'b1;
				row_next=8;col_next=16;//22
				data_next=lora_ram_data;end
			st_188:begin state_next=st_189;lora_ram_addr_next=25;ram_we_next=1'b1;
				row_next=8;col_next=17;//23
				data_next=lora_ram_data;end
			st_189:begin state_next=st_190;lora_ram_addr_next=26;ram_we_next=1'b1;
				row_next=8;col_next=18;//24
				data_next=lora_ram_data;end
			st_190:begin state_next=st_191;lora_ram_addr_next=27;ram_we_next=1'b1;
				row_next=8;col_next=19;//25
				data_next=lora_ram_data;end
			st_191:begin state_next=st_192;lora_ram_addr_next=28;ram_we_next=1'b1;
				row_next=8;col_next=20;//26
				data_next=lora_ram_data;end
				///////////////////////////////////////////////////////////////////////Heading
			st_192:begin state_next=st_193;lora_ram_addr_next=29;ram_we_next=1'b1;
				row_next=10;col_next=10;//27
				data_next=lora_ram_data;end
			st_193:begin state_next=st_194;lora_ram_addr_next=30;ram_we_next=1'b1;
				row_next=10;col_next=11;//28
				data_next=lora_ram_data;end
			st_194:begin state_next=st_195;lora_ram_addr_next=31;ram_we_next=1'b1;
				row_next=10;col_next=12;//29
				data_next=lora_ram_data;end
			st_195:begin state_next=st_196;lora_ram_addr_next=32;ram_we_next=1'b1;
				row_next=10;col_next=13;//30
				data_next=lora_ram_data;end
			st_196:begin state_next=st_197;lora_ram_addr_next=33;ram_we_next=1'b1;
				row_next=10;col_next=14;//31
				data_next=lora_ram_data;end
			st_197:begin state_next=st_198;lora_ram_addr_next=34;ram_we_next=1'b1;
				row_next=10;col_next=15;//32
				data_next=lora_ram_data;end
				///////////////////////////////////////////////////////////////////////////Speed
			st_198:begin state_next=st_199;lora_ram_addr_next=35;ram_we_next=1'b1;
				row_next=9;col_next=10;//33
				data_next=lora_ram_data;end
			st_199:begin state_next=st_200;lora_ram_addr_next=36;ram_we_next=1'b1;
				row_next=9;col_next=11;//34
				data_next=lora_ram_data;end
			st_200:begin state_next=st_201;lora_ram_addr_next=37;ram_we_next=1'b1;
				row_next=9;col_next=12;//35
				data_next=lora_ram_data;end
			st_201:begin state_next=st_202;lora_ram_addr_next=38;ram_we_next=1'b1;
				row_next=9;col_next=13;//36
				data_next=lora_ram_data;end
			st_202:begin state_next=st_203;gps_ram_addr_next=0;ram_we_next=1'b1;
				row_next=9;col_next=14;//37
				data_next=lora_ram_data;end
			st_203:begin state_next=st_204;gps_ram_addr_next=1;ram_we_next=1'b1;
				row_next=9;col_next=15;//38
				data_next=lora_ram_data;end
				//////////////////////////////////////////////////////////////////////
				//下一轮流水线
			st_204:begin state_next=st_133;gps_ram_addr_next=2;ram_we_next=1'b1;
				row_next=1;col_next=11;//0
				data_next=gps_ram_data;end
		endcase
	end
	
	
	

endmodule
