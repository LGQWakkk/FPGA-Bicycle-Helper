`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/15 18:32:37
// Design Name: 
// Module Name: div24
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

//一个勉强能用的简易除法器
//20230615 18:50

module div24(
	input wire [10:0] col_all,//范围内：128-255  384-511
	output reg [4:0] col_24
    );
	
	always@(*)begin
		//Speed
		if((col_all>=11'd128)&&(col_all<=11'd151))col_24=col_all-11'd128;
		else if((col_all>=11'd152)&&(col_all<=11'd175))col_24=col_all-11'd152;
		else if((col_all>=11'd176)&&(col_all<=11'd199))col_24=col_all-11'd176;
		else if((col_all>=11'd208)&&(col_all<=11'd231))col_24=col_all-11'd208;
		else if((col_all>=11'd232)&&(col_all<=11'd255))col_24=col_all-11'd232;
		//Heading
		else if((col_all>=11'd384)&&(col_all<=11'd407))col_24=col_all-11'd384;
		else if((col_all>=11'd408)&&(col_all<=11'd431))col_24=col_all-11'd408;
		else if((col_all>=11'd432)&&(col_all<=11'd455))col_24=col_all-11'd432;
		else if((col_all>=11'd464)&&(col_all<=11'd487))col_24=col_all-11'd464;
		else if((col_all>=11'd488)&&(col_all<=11'd511))col_24=col_all-11'd488;
		
		else col_24=11'd0;
	end
	
	
	
endmodule
