`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/17 18:44:23
// Design Name: 
// Module Name: db_posedge_detect
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


module db_posedge_detect(
	input clk,rst,
	input wire button,
	output reg tick
    );
	
	localparam [1:0] 
	st_zero=2'b00,
	st_wait=2'b01,
	st_tick=2'b10,
	st_one=2'b11;
	
	localparam [19:0] WAITCNT = 20'd10_000;
	
	reg [1:0] state_reg,state_next;
	reg [19:0] wait_reg,wait_next;
	
	always@(posedge clk)begin
		if(rst)begin
			state_reg<=st_zero;
			wait_reg<=0;
		end
		else begin
			state_reg<=state_next;
			wait_reg<=wait_next;
		end
	end
	
	always@(*)begin
		wait_next=wait_reg;
		state_next=state_reg;
		tick=1'b0;
		case(state_reg)
			st_zero:begin
				if(button)begin
					wait_next=0;
					state_next=st_wait;
				end
			end
			st_wait:begin
				if(wait_reg==WAITCNT)begin
					state_next=st_tick;
				end
				else begin
					if(button)begin
						wait_next=wait_reg+1;
					end
					else begin
						state_next=st_zero;
					end
				end
			end
			st_tick:begin
				tick=1'b1;
				state_next=st_one;
			end
			st_one:begin
				if(~button)begin
					state_next=st_zero;
				end
			end
		endcase
	end
	
endmodule
