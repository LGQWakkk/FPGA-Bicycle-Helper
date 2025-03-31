`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/15 22:44:56
// Design Name: 
// Module Name: test_scroll
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



module test_scroll(
	input wire clk,rst,
	output wire scl,sda
    );
	
	wire [6:0] disp_col_o;
	wire [2:0] disp_row_o;
	
	wire [10:0] col_all;
	wire [2:0] row_all;
	
	wire tick;
	
	reg [10:0] offset_reg,offset_next;
	always@(posedge clk)begin
		if(rst)begin
			offset_reg<=0;
		end
		else begin
			offset_reg<=offset_next;
		end
	end
	
	always@(*)begin
		offset_next = offset_reg;
		if(tick)begin
			if(offset_reg==11'd1152)begin
				offset_next=0;
			end
			else begin
				offset_next=offset_reg+1;
			end
		end
	end
	
	assign col_all = disp_col_o+offset_reg;
	assign row_all = disp_row_o;
	// module mod_m_counter
// #(
	// parameter N=20,//计数器比特数 应为大于log2M的整数
	// M=10_000_000//模M  1_000_000  [19:0] 20bit  0.01s
// )
// (
	// input wire clk,reset,
	// output wire max_tick,
	// output wire [N-1:0] q
    // );
	mod_m_counter #(.N(24),.M(400_000))
	u1_mod_m_counter(
		.clk(clk),
		.reset(rst),
		.max_tick(tick),
		.q()
	);
	
	
	wire [7:0] data;
	pixel_ctrl u_pixel_ctrl(
	.clk(clk),
	.rst(rst),
	.data_in(data),
	.col(disp_col_o),
	.row(disp_row_o),
	.scl(scl),
	.sda(sda)
	);
	
	// module full_disp(
	// input wire clk,rst,
	// input wire sh_ram_we,
	// input wire [3:0] sh_ram_addr,
	// input wire [7:0] sh_ram_data,
	
	// input wire jw_ram_we,
	// input wire [3:0] jw_ram_addr,
	// input wire [7:0] jw_ram_data,
	
	// input wire [10:0] col_all,
	// input wire [2:0] row_all,
	
	// input wire [7:0] r,g,b,led,
	
	// input wire [2:0] page_mode,
	// output wire [7:0] data
    // );
	full_disp u_full_disp(
	.clk(clk),
	.rst(rst),
	.sh_ram_we(1'b1),
	.sh_ram_addr(4'd0),
	.sh_ram_data(8'h32),
	.col_all(col_all),
	.row_all(row_all),
	.data(data)
	);
endmodule
