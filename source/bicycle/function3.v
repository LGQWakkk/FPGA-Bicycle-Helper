`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/15 21:46:18
// Design Name: 
// Module Name: function3
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

//map for jw_ram
module function3(
	input wire [10:0] col_all,
	input wire [2:0] row_all,
	output reg [3:0] jw_ram_addr
    );
	
	always@(*)begin
		if((row_all>=3'd2)&&(row_all<=3'd3))begin
			if((col_all>=11'd640)&&(col_all<=11'd647))jw_ram_addr=4'd0;
			else if((col_all>=11'd648)&&(col_all<=11'd655))jw_ram_addr=4'd1;
			else if((col_all>=11'd656)&&(col_all<=11'd663))jw_ram_addr=4'd2;
			else if((col_all>=11'd664)&&(col_all<=11'd671))jw_ram_addr=4'd3;
			else if((col_all>=11'd672)&&(col_all<=11'd679))jw_ram_addr=4'd4;
		end
		else if((row_all>=3'd6)&&(row_all<=3'd7))begin
			if((col_all>=11'd640)&&(col_all<=11'd647))jw_ram_addr=4'd5;
			else if((col_all>=11'd648)&&(col_all<=11'd655))jw_ram_addr=4'd6;
			else if((col_all>=11'd656)&&(col_all<=11'd663))jw_ram_addr=4'd7;
			else if((col_all>=11'd664)&&(col_all<=11'd671))jw_ram_addr=4'd8;
			else if((col_all>=11'd672)&&(col_all<=11'd679))jw_ram_addr=4'd9;
		end
		else begin
			jw_ram_addr=4'd0;
		end
	end
	
	
endmodule
