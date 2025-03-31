`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/10 13:12:08
// Design Name: 
// Module Name: initial_test
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
//20230610进行第一次测试，主要测试能不能用IIC进行正常的初始化
//20230610 测试成功 V1


module initial_test(
	input wire clk,rst,
	output wire scl,sda,
	output reg initial_done
    );
	
 	localparam [5:0]
	st_0=6'd0,
	st_1=6'd1,
	st_2=6'd2,
	st_3=6'd3,
	st_4=6'd4;
	
	
	wire [7:0] rom_data;//初始化数据输出
	wire iic_done;//iic传输完成指示
	
	reg [5:0] state_reg,state_next;
	reg [7:0] din_reg,din_next;
	reg [5:0] rom_addr_reg,rom_addr_next;
	reg iic_start_reg,iic_start_next;
	
	always@(posedge clk)begin
		if(rst)begin
			state_reg<=st_0;
			din_reg<=0;
			rom_addr_reg<=0;
			iic_start_reg<=0;
		end
		else begin
			state_reg<=state_next;
			din_reg<=din_next;
			rom_addr_reg<=rom_addr_next;
			iic_start_reg<=iic_start_next;
		end
	end
	
	always@(*)begin
		state_next=state_reg;
		din_next=din_reg;
		rom_addr_next=rom_addr_reg;
		iic_start_next=1'b0;//start signal is automated to 0
		initial_done=1'b0;
		case(state_reg)
			st_0:begin
				state_next=st_1;
				rom_addr_next=0;
			end
			st_1:begin
				state_next=st_2;
			end
			st_2:begin
				din_next=rom_data;
				iic_start_next=1'b1;
				state_next=st_3;
			end
			st_3:begin
				if(iic_done)begin
					if(rom_addr_reg==30)begin
						state_next=st_4;
						rom_addr_next=0;
					end
					else begin
						rom_addr_next=rom_addr_reg+1;
						state_next=st_1;
					end
				end
			end
			st_4:begin
				initial_done=1'b1;
			end
			
		endcase
	end
	
	// module oled_initial_rom(
	// input wire clk,
	// input wire [5:0] addr,
	// output reg [7:0] data
    // );
	oled_initial_rom u_oled_initial_rom(
	.clk(clk),
	.addr(rom_addr_reg),
	.data(rom_data)
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
	.dc(1'b0),
	.din(din_reg),
	.iic_start(iic_start_reg),
	.iic_done(iic_done),
	.scl(scl),
	.sda(sda)
	);
	
	
endmodule
