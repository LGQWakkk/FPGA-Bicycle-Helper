`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/17 20:20:49
// Design Name: 
// Module Name: test_oled_top
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


module test_oled_top(
	input wire clk,rst,
	input wire gps_rx,
	input wire s1,s2,
	output wire scl,sda,
	output wire gps_valid
    );
	
	wire gps_valid;
	
	wire [3:0] jw_ram_addr;
	wire [7:0] jw_ram_data;
	wire jw_ram_we;
	wire [3:0] sh_ram_addr;
	wire [7:0] sh_ram_data;
	wire sh_ram_we;
	
	wire [2:0] page_mode;
	// module oled_top(
	// input wire clk,rst,
	// input wire [2:0] page_mode,
	
	// input wire sh_ram_we,
	// input wire [3:0] sh_ram_addr,
	// input wire [7:0] sh_ram_data,
	
	// input wire jw_ram_we,
	// input wire [3:0] jw_ram_addr,
	// input wire [7:0] jw_ram_data,
	
	// input wire [7:0] r,g,b,led
    // );
	oled_top u_oled_top(
	.clk(clk),
	.rst(rst),
	.page_mode(page_mode),
	
	.sh_ram_we(sh_ram_we),
	.sh_ram_addr(sh_ram_addr),
	.sh_ram_data(sh_ram_data),
	
	.jw_ram_we(jw_ram_we),
	.jw_ram_addr(jw_ram_addr),
	.jw_ram_data(jw_ram_data),
	
	.scl(scl),
	.sda(sda)
	);
	
	// module EC11(
	// input wire clk,rst,
	// input wire s1,s2,
	// output wire [2:0] value
    // );
	EC11 u_EC11(
	.clk(clk),
	.rst(rst),
	.s1(s1),
	.s2(s2),
	.value(page_mode)
	);
	
	// module gps_get(
	// input wire rx,
	// input wire clk,rst,
	// output wire [5:0] gps_ram_addr,
	// output wire [7:0] gps_ram_data,
	// output wire gps_ram_we,
	// output wire [3:0] jw_ram_addr,
	// output wire [7:0] jw_ram_data,
	// output wire jw_ram_we,
	// output wire [3:0] sh_ram_addr,
	// output wire [7:0] sh_ram_data,
	// output wire sh_ram_we,
	// output wire gps_valid
    // );
	gps_get u_gps_get(
	.rx(gps_rx),
	.clk(clk),
	.rst(rst),
	.jw_ram_addr(jw_ram_addr),
	.jw_ram_data(jw_ram_data),
	.jw_ram_we(jw_ram_we),
	.sh_ram_addr(sh_ram_addr),
	.sh_ram_data(sh_ram_data),
	.sh_ram_we(sh_ram_we),
	.gps_valid(gps_valid)
	);
	
	
endmodule
