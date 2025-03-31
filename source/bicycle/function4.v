`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/17 18:55:50
// Design Name: 
// Module Name: function4
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

//map for little digit
module function4(
	input wire [7:0] data,
	input wire [10:0] col_all,
	input wire [2:0] row_all,
	output wire [10:0] little_digit_addr
    );
	
	assign little_digit_addr = {data[6:0],row_all[0],col_all[2:0]};
	
endmodule
