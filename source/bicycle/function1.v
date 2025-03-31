`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/15 21:46:09
// Design Name: 
// Module Name: function1
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

//map all to sh_ram (0-9)

module function1(
	input wire [10:0] col_all,
	input wire [2:0] row_all,
	output reg [3:0] sh_ram_addr//0-9
    );
	always@(*)begin
		if((col_all>=11'd128)&&(col_all<=11'd151))sh_ram_addr=4'd5;
		else if((col_all>=11'd152)&&(col_all<=11'd175))sh_ram_addr=4'd6;
		else if((col_all>=11'd176)&&(col_all<=11'd199))sh_ram_addr=4'd7;
		else if((col_all>=11'd208)&&(col_all<=11'd231))sh_ram_addr=4'd8;
		else if((col_all>=11'd232)&&(col_all<=11'd255))sh_ram_addr=4'd9;
		
		else if((col_all>=11'd384)&&(col_all<=11'd407))sh_ram_addr=4'd0;
		else if((col_all>=11'd408)&&(col_all<=11'd431))sh_ram_addr=4'd1;
		else if((col_all>=11'd432)&&(col_all<=11'd455))sh_ram_addr=4'd2;
		else if((col_all>=11'd464)&&(col_all<=11'd487))sh_ram_addr=4'd3;
		else if((col_all>=11'd488)&&(col_all<=11'd511))sh_ram_addr=4'd4;
		else sh_ram_addr=4'd0;
	end
	
endmodule
