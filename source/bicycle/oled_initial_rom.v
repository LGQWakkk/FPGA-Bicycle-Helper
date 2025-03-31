`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/10 13:00:40
// Design Name: 
// Module Name: oled_initial_rom
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
//OLED初始化指令
//一共有31Bytes
//使用6位地址 最多可以提供64个初始化数据
//20230610 测试成功 V1

module oled_initial_rom(
	input wire clk,
	input wire [5:0] addr,
	output reg [7:0] data
    );
	
	reg [5:0] addr_reg;
	
	always@(posedge clk)begin
		addr_reg<=addr;
	end
	
	always@(*)begin
		data=8'd0;
		case(addr_reg)
			6'h00:data=8'hAE;
			6'h01:data=8'hD5;
			6'h02:data=8'hF0;
			6'h03:data=8'hA8;
			6'h04:data=8'h3F;
			6'h05:data=8'hD3;
			6'h06:data=8'h00;
			6'h07:data=8'h40;
			6'h08:data=8'hA1;
			6'h09:data=8'hC8;
			6'h0a:data=8'hDA;
			6'h0b:data=8'h12;
			6'h0c:data=8'h81;
			6'h0d:data=8'hCF;
			6'h0e:data=8'hD9;
			6'h0f:data=8'hF1;
			6'h10:data=8'hDB;
			6'h11:data=8'h30;
			6'h12:data=8'hA4;
			6'h13:data=8'hA6;
			6'h14:data=8'h8D;
			6'h15:data=8'h14;
			6'h16:data=8'h20;
			6'h17:data=8'h00;
			6'h18:data=8'hAF;//开启显示
			
			6'h19:data=8'h21;//setwindows
			6'h1a:data=8'h00;
			6'h1b:data=8'h7f;
			
			6'h1c:data=8'h22;
			6'h1d:data=8'h00;
			6'h1e:data=8'h07;
		endcase
	end
	

endmodule
