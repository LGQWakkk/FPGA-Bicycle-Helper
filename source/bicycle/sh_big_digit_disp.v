`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/15 21:55:19
// Design Name: 
// Module Name: sh_big_digit_disp
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

//20230615 22:08

module sh_big_digit_disp(
	input wire [10:0] col_all,
	input wire [2:0] row_all,
	input wire clk,
	input wire sh_ram_we,
	input wire [3:0] sh_ram_addr,
	input wire [7:0] sh_ram_data,
	output wire [7:0] sh_big_digit_data
    );
	
	wire [3:0] sh_ram_out_addr;
	wire [7:0] sh_ram_out_data;
	
	wire [14:0] big_digit_rom_addr;
	
	// module sh_ram
// #(
	// parameter ADDR_WIDTH=4,//10MAX
	// DATA_WIDTH=8
// )
// (
	// input wire clk,
	// input wire we,
	// input wire [ADDR_WIDTH-1:0] addr_a,addr_b,//a,b地址端口
	// input wire [DATA_WIDTH-1:0] din_a,//a端口写入数据
	// output wire [DATA_WIDTH-1:0] dout_a,dout_b
    // );
	sh_ram u_sh_ram(
	.clk(clk),
	.we(sh_ram_we),
	.addr_a(sh_ram_addr),
	.addr_b(sh_ram_out_addr),//读取地址输入
	.din_a(sh_ram_data),
	.dout_a(),
	.dout_b(sh_ram_out_data)
	);
	
	// module function1(
	// input wire [10:0] col_all,
	// input wire [2:0] row_all,
	// output reg [3:0] sh_ram_addr//0-9
    // );
	function1 u_function1(
	.col_all(col_all),
	.row_all(row_all),
	.sh_ram_addr(sh_ram_out_addr)//告知shRAM的读取地址
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
	.ascii(sh_ram_out_data[6:0]),
	.rom_addr(big_digit_rom_addr)
	);
	
	// module big_digit_rom(
	// input wire clk,
	// input wire [14:0] addr,//15bit addr
	// output reg [7:0] data
    // );
	big_digit_rom u_big_digit_rom(
	.clk(clk),
	.addr(big_digit_rom_addr),
	.data(sh_big_digit_data)
	);
endmodule
