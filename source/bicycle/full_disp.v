`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/15 16:15:38
// Design Name: 
// Module Name: full_disp
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

//20230618 15:50删除page_mode接口

module full_disp(
	input wire clk,rst,
	input wire sh_ram_we,
	input wire [3:0] sh_ram_addr,
	input wire [7:0] sh_ram_data,
	input wire jw_ram_we,
	input wire [3:0] jw_ram_addr,
	input wire [7:0] jw_ram_data,
	input wire [10:0] col_all,
	input wire [2:0] row_all,
	input wire [7:0] r,g,b,led,
	output reg [7:0] data
    );
	
	
	//Page Mode:0-7
	//0: PIC1 SPEED +SH DISP
	//1: PIC2 DIRE  +SH_DISP
	//2: PIC3 LOCAT +JW_DISP
	//3-6: PIC4 +LIGHT CTRL(3:R 4:G 5:B 6:LED)
	//7: PIC5 INFO  +Infomation (PIC6+INFO)
	
	
	
	
	
	//连接各子模块的数据输出
	wire [7:0] sh_big_digit_data,jw_lit_digit_data;
	wire [7:0] static_char_data;
	wire [7:0] light_ctrl_data;
	wire [7:0] pic_data;
	
	//ALL DISP MUX
	always@(*)begin
		//PIC
		if((col_all>=11'd0)&&(col_all<=11'd127))begin data=pic_data; end//PIC1 SPEED
		else if((col_all>=11'd256)&&(col_all<=11'd383))begin data=pic_data; end//PIC2 DIRE
		else if((col_all>=11'd512)&&(col_all<=11'd639))begin data=pic_data; end//PIC3 LOCAT
		else if((col_all>=11'd768)&&(col_all<=11'd895))begin data=pic_data; end//PIC4 LIGHT
		else if((col_all>=11'd1024)&&(col_all<=11'd1151))begin data=pic_data; end//PIC5 INFO
		
		//Big Digit
		
		//Speed
		else if((col_all>=11'd128)&&(col_all<=11'd255))begin 
			if((row_all>=2)&&(row_all<=7))begin
				data=sh_big_digit_data; 
			end
		end
		//Heading
		else if((col_all>=11'd384)&&(col_all<=11'd511))begin 
			if((row_all>=2)&&(row_all<=7))begin
				data=sh_big_digit_data; 
			end
		end
		
		//Little Digit
		//JingWei  //Locat
		else if((col_all>=11'd640)&&(col_all<=11'd679))begin 
			if((row_all>=2)&&(row_all<=3))begin
				data=jw_lit_digit_data; 
			end
			else if((row_all>=6)&&(row_all<=7))begin
				data=jw_lit_digit_data; 
			end
		end
		
		//Blank
		else begin data=8'h00; end
	end
	
	//BIG DIGIT DISP
	// module sh_big_digit_disp(
	// input wire [10:0] col_all,
	// input wire [2:0] row_all,
	// input wire clk,
	// input wire sh_ram_we,
	// input wire [3:0] sh_ram_addr,
	// input wire [7:0] sh_ram_data,
	// output wire [7:0] sh_big_digit_data
    // );
	sh_big_digit_disp u_sh_big_digit_disp(
	.col_all(col_all),
	.row_all(row_all),
	.clk(clk),
	.sh_ram_we(sh_ram_we),
	.sh_ram_addr(sh_ram_addr),
	.sh_ram_data(sh_ram_data),
	.sh_big_digit_data(sh_big_digit_data)
	);
	
	
	
	
	//PIC DISP
	wire [13:0] pic_rom_addr;
	
	assign pic_rom_addr = {row_all,col_all};//14bit
	// module pic_rom(
	// input wire clk,
	// input wire [13:0] addr,
	// output wire [7:0] data
    // );
	pic_rom u_pic_rom(
	.clk(clk),
	.addr(pic_rom_addr),
	.data(pic_data)
	);
	
	// module jw_little_digit_disp(
	// input wire [10:0] col_all,
	// input wire [2:0] row_all,
	// input wire clk,
	// input wire jw_ram_we,
	// input wire [3:0] jw_ram_addr,
	// input wire [7:0] jw_ram_data,
	// output wire [7:0] jw_little_digit_data
    // );
	jw_little_digit_disp u_jw_little_digit_disp(
	.col_all(col_all),
	.row_all(row_all),
	.clk(clk),
	.jw_ram_we(jw_ram_we),
	.jw_ram_addr(jw_ram_addr),
	.jw_ram_data(jw_ram_data),
	.jw_little_digit_data(jw_lit_digit_data)
	);

endmodule
