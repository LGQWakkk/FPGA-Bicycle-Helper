`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/11 09:59:29
// Design Name: 
// Module Name: pixel_ctrl
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
//20230611 10:08 V1
//20230611 10:20 存在坐标控制问题
//20230615 解决所有问题


module pixel_ctrl(
	input wire clk,rst,
	input wire [7:0] data_in,
	output wire [6:0] col,
	output wire [2:0] row,
	output wire scl,sda
    );
	
	
	wire [7:0] wire_rom_data;
	wire [5:0] wire_rom_addr;
	wire wire_dc;
	wire [7:0] wire_iic_data;
	wire wire_iic_start;
	wire wire_iic_done;
	
// module data_ctrl(
	// input wire clk,rst,
	// input wire [7:0] rom_data,
	// output wire [5:0] rom_addr,
	// input wire [7:0] data_in,
	// output wire [6:0] col,
	// output wire [2:0] row,
	// input wire iic_done,
	// output wire [7:0] iic_data,
	// output wire dc,
	// output wire iic_start
    // );
	data_ctrl u_data_ctrl(
	.clk(clk),
	.rst(rst),
	.rom_data(wire_rom_data),
	.rom_addr(wire_rom_addr),
	.data_in(data_in),
	.col(col),
	.row(row),
	.iic_done(wire_iic_done),
	.iic_data(wire_iic_data),
	.dc(wire_dc),
	.iic_start(wire_iic_start)
	);
	
	
	// module oled_initial_rom(
	// input wire clk,
	// input wire [5:0] addr,
	// output reg [7:0] data
    // );
	oled_initial_rom u_oled_initial_rom(
	.clk(clk),
	.addr(wire_rom_addr),
	.data(wire_rom_data)
	);
	
	// module iic_driver
// #(parameter SLAVE_ADDR=8'h78)
// (
	// input wire clk,rst,
	// input wire dc,
	// input wire [7:0] din,
	// input wire iic_start,
	// output reg iic_done,
	// output wire scl,sda
    // );
	iic_driver u_iic_driver(
	.clk(clk),
	.rst(rst),
	.dc(wire_dc),
	.din(wire_iic_data),
	.iic_start(wire_iic_start),
	.iic_done(wire_iic_done),
	.scl(scl),
	.sda(sda)
	);
	
endmodule
