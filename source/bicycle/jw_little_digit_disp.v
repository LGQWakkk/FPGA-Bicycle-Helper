`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/17 19:25:46
// Design Name: 
// Module Name: jw_little_digit_disp
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

//20230617 19:33编写完毕

module jw_little_digit_disp(
	input wire [10:0] col_all,
	input wire [2:0] row_all,
	input wire clk,
	input wire jw_ram_we,
	input wire [3:0] jw_ram_addr,
	input wire [7:0] jw_ram_data,
	output wire [7:0] jw_little_digit_data
    );
	
	wire [3:0] jw_ram_out_addr;
	wire [7:0] jw_ram_out_data;
	
	wire [10:0] little_digit_rom_addr;
	
	jw_ram u_jw_ram(
	.clk(clk),
	.we(jw_ram_we),
	.addr_a(jw_ram_addr),
	.addr_b(jw_ram_out_addr),//读取地址输入
	.din_a(jw_ram_data),
	.dout_a(),
	.dout_b(jw_ram_out_data)
	);
	
	// module function3(
	// input wire [10:0] col_all,
	// input wire [2:0] row_all,
	// output wire [3:0] jw_ram_addr
    // );
	function3 u_function3(
	.col_all(col_all),
	.row_all(row_all),
	.jw_ram_addr(jw_ram_out_addr)
	);
	
	// module function4(
	// input wire [7:0] data,
	// input wire [10:0] col_all,
	// input wire [2:0] row_all,
	// output wire [10:0] little_digit_addr
    // );
	function4 u_function4(
	.data(jw_ram_out_data),
	.col_all(col_all),
	.row_all(row_all),
	.little_digit_addr(little_digit_rom_addr)
	);
	
	// module little_digit_rom(
	// input wire clk,
	// input wire [10:0] addr,//11bit addr
	// output reg [7:0] data
    // );
	little_digit_rom u_little_digit_rom(
	.clk(clk),
	.addr(little_digit_rom_addr),
	.data(jw_little_digit_data)
	);
endmodule
