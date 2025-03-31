`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/15 21:11:10
// Design Name: 
// Module Name: test2_pic_disp
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


module test2_pic_disp(
	input wire clk,rst,
	output wire scl,sda
    );
	
	wire [6:0] disp_col_o;
	wire [2:0] disp_row_o;
	
	wire [7:0] rom_data;
	wire [13:0] rom_addr;
	
	assign rom_addr = {disp_row_o,4'b0000,disp_col_o};//14bit
	
	pixel_ctrl u_pixel_ctrl(
	.clk(clk),
	.rst(rst),
	.data_in(rom_data),
	.col(disp_col_o),
	.row(disp_row_o),
	.scl(scl),
	.sda(sda)
	);
	
	// module pic_rom(
	// input wire clk,
	// input wire [13:0] addr,
	// output wire [7:0] data
    // );
	pic_rom u_pic_rom(
	.clk(clk),
	.addr(rom_addr),
	.data(rom_data)
	);
	
endmodule
