`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/15 19:21:40
// Design Name: 
// Module Name: test1_big_digit
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

//20230615 20:30测试成功

module test1_big_digit(
	input wire clk,rst,
	output wire scl,sda
    );
	
	wire [6:0] disp_col_o;
	wire [2:0] disp_row_o;
	
	wire [10:0] col_all;
	wire [2:0] row_all;
	
	assign col_all=disp_col_o+11'd128;
	assign row_all=disp_row_o;
	
	
	wire [14:0] rom_addr;
	wire [7:0] rom_data;
	// module big_digit_rom(
	// input wire clk,
	// input wire [14:0] addr,//15bit addr
	// output reg [7:0] data
    // );
	big_digit_rom u_big_digit_rom(
	.clk(clk),
	.addr(rom_addr),
	.data(rom_data)
	);
	
	// module function2(
	// input wire [10:0] col_all,
	// input wire [2:0] row_all,
	// input wire [6:0] ascii,
	// output wire [14:0] rom_addr//big_digit_rom
    // );
	function2 u_function2(
	.col_all(col_all),
	.row_all(row_all),
	.ascii(8'h30),
	.rom_addr(rom_addr)
	);
	
	// module pixel_ctrl(
	// input wire clk,rst,
	// input wire [7:0] data_in,
	// output wire [6:0] col,
	// output wire [2:0] row,
	// output wire scl,sda
    // );
	pixel_ctrl u_pixel_ctrl(
	.clk(clk),
	.rst(rst),
	.data_in(rom_data),
	.col(disp_col_o),
	.row(disp_row_o),
	.scl(scl),
	.sda(sda)
	);
	
endmodule
