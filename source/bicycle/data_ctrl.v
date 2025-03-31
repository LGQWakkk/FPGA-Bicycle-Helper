`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/11 09:25:04
// Design Name: 
// Module Name: data_ctrl
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

//20230611 9:56 V1
//20230615 13:27 V2

module data_ctrl(
	input wire clk,rst,
	input wire [7:0] rom_data,
	output wire [5:0] rom_addr,
	input wire [7:0] data_in,
	output wire [6:0] col,
	output wire [2:0] row,
	input wire iic_done,
	output wire [7:0] iic_data,
	output wire dc,
	output wire iic_start
    );
	
	localparam [5:0] 
	st_0=6'd0,
	st_1=6'd1,
	st_2=6'd2,
	st_3=6'd3,
	st_4=6'd4,
	st_5=6'd5,
	st_6=6'd6,
	st_7=6'd7,
	st_8=6'd8,
	st_9=6'd9,
	st_10=6'd10,
	st_11=6'd11,
	st_12=6'd12;
	
	localparam [23:0] WAIT_MAX = 24'd100;
	//localparam [23:0] WAIT_MAX = 24'd10_000_000;
	localparam [5:0] MAX1 = 6'h19;
	localparam [5:0] MAX2 = 6'h1f;
	localparam [6:0] COLMAX = 7'd127;
	localparam [2:0] ROWMAX = 3'd7;
	
	reg [5:0] state_reg,state_next;
	reg [6:0] col_reg,col_next;
	reg [2:0] row_reg,row_next;
	reg iic_start_reg,iic_start_next;
	reg [5:0] rom_addr_reg,rom_addr_next;
	reg [7:0] iic_data_reg,iic_data_next;
	reg dc_reg,dc_next;
	reg [23:0] wait_reg,wait_next;
	
	assign col = col_reg;
	assign row = row_reg;
	assign rom_addr = rom_addr_reg;
	assign iic_start=iic_start_reg;
	assign iic_data=iic_data_reg;
	assign dc = dc_reg;
	
	always@(posedge clk)begin
		if(rst)begin
			state_reg<=st_0;
			col_reg<=0;
			row_reg<=0;
			iic_start_reg<=0;
			rom_addr_reg<=0;
			iic_data_reg<=0;
			dc_reg<=1'b0;
			wait_reg<=0;
		end
		else begin
			state_reg<=state_next;
			col_reg<=col_next;
			row_reg<=row_next;
			iic_start_reg<=iic_start_next;
			rom_addr_reg<=rom_addr_next;
			iic_data_reg<=iic_data_next;
			dc_reg<=dc_next;
			wait_reg<=wait_next;
		end
	end
	
	always@(*)begin
		state_next=state_reg;
		col_next=col_reg;
		row_next=row_reg;
		iic_start_next=1'b0;
		rom_addr_next=rom_addr_reg;
		iic_data_next=iic_data_reg;
		dc_next=dc_reg;
		wait_next=wait_reg;
		case(state_reg)
			st_0:begin
				state_next=st_1;
			end
			st_1:begin
				if(wait_reg==WAIT_MAX)begin
					wait_next=0;
					state_next=st_2;
					dc_next=1'b0;
				end
				else begin
					wait_next=wait_reg+1;
				end
			end
			st_2:begin
				state_next=st_3;
			end
			st_3:begin
				iic_data_next=rom_data;
				iic_start_next=1'b1;
				state_next=st_4;
			end
			st_4:begin
				rom_addr_next=rom_addr_reg+1;
				state_next=st_5;
			end
			st_5:begin
				if(iic_done)begin
					if(rom_addr_reg==MAX1)begin
						state_next=st_6;
					end
					else begin
						state_next=st_2;
					end
				end
			end
			st_6:begin
				state_next=st_7;
			end
			st_7:begin
				iic_data_next=rom_data;
				iic_start_next=1'b1;
				state_next=st_8;
			end
			st_8:begin
				rom_addr_next=rom_addr_reg+1;
				state_next=st_9;
			end
			st_9:begin
				if(iic_done)begin
					if(rom_addr_reg==MAX2)begin
						dc_next=1'b1;
						iic_start_next=1'b1;
						iic_data_next=data_in;
						state_next=st_10;
					end
					else begin
						state_next=st_6;
					end
				end
			end
			st_10:begin
				if(col_reg==COLMAX)begin
					if(row_reg==ROWMAX)begin
						row_next=0;
						col_next=0;
					end
					else begin
						row_next=row_reg+1;
						col_next=0;
					end
				end
				else begin
					col_next=col_reg+1;
				end
				state_next=st_11;
			end
			st_11:begin
				if(iic_done)begin
					if((row_reg==0)&&(col_reg==0))begin
						rom_addr_next=MAX1;
						dc_next=1'b0;
						state_next=st_6;
					end
					else begin
						iic_data_next=data_in;
						iic_start_next=1'b1;
						dc_next=1'b1;
						state_next=st_10;
					end
				end
			end
		endcase
	end
	
	
	
	
endmodule
