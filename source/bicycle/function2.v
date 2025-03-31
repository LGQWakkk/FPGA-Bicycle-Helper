`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/15 18:51:22
// Design Name: 
// Module Name: function2
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

//20230615 18:54 V1
//map for big_digit_rom
//20230615 19:16 V2
//20230615 20:31 测试成功
module function2(
	input wire [10:0] col_all,
	input wire [2:0] row_all,
	input wire [6:0] ascii,
	output wire [14:0] rom_addr//big_digit_rom
    );
	
	wire [4:0] col_24;
	// module div24(
	// input wire [10:0] col_all,//范围内：128-255  384-511
	// output reg [4:0] col_24
    // );
	div24 u_div24(
	.col_all(col_all),
	.col_24(col_24)
	);
	
	//row_all: 2-7
	wire [2:0] row_d2;//row_all-2
	
	assign row_d2=((row_all>=3'd2)&&(row_all<=3'd7))?row_all-3'd2:3'd0;
	
	assign rom_addr ={ascii,row_d2,col_24};
	
endmodule
