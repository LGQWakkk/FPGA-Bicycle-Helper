`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/18 07:52:27
// Design Name: 
// Module Name: led_tick_blink
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


module led_tick_blink(
	input wire clk,rst,
	input wire tick,
	output reg blink
    );
	
	reg [23:0] wait_reg,wait_next;
	localparam [23:0] WAITMAX=24'd10_000_000;
	
	localparam [1:0] 
	st_idle = 2'b00,
	st_wait = 2'b01;
	reg[1:0] state_reg,state_next;
	
	always@(posedge clk)begin
		if(rst)begin
			state_reg<=st_idle;
			wait_reg<=0;
		end
		else begin
			state_reg<=state_next;
			wait_reg<=wait_next;
		end
	end
	
	always@(*)begin
		state_next=state_reg;
		wait_next=wait_reg;
		blink=1'b0;
		case(state_reg)
			st_idle:begin
				if(tick)begin
					wait_next=0;
					state_next=st_wait;
				end
			end
			st_wait:begin
				blink=1'b1;
				if(wait_reg==WAITMAX)begin
					state_next=st_idle;
				end
				else begin
					wait_next=wait_reg+1;
				end
			end
		endcase
	
	end
endmodule
