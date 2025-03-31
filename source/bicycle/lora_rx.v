`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/17 10:17:23
// Design Name: 
// Module Name: lora_rx
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

//20230617  10:28 V1

module lora_rx(
	input wire clk,rst,
	input wire lora_rx,
	output reg lora_ok,
	output wire led,rgb,bell,
	output wire [2:0] rgb_mode
    );
	//(led)(rgb)(bell)(rgbmode[2:0])(00)
	
	wire s_tick;
	wire rt;
	wire [7:0] rd;

	uart_rx u_lora_rx(
	.clk(clk),
	.reset(rst),
	.rx(rx),
	.s_tick(s_tick),
	.rx_done_tick(rt),
	.dout(rd)
	);
	
	mod_m_counter u_lora_mod_m_counter(
	.clk(clk),
	.reset(rst),
	.max_tick(s_tick),
	.q()
	);
	
	reg [7:0] ctrlbyte_reg,ctrlbyte_next;
	assign led = ctrlbyte_reg[7];
	assign rgb = ctrlbyte_reg[6];
	assign bell = ctrlbyte_reg[5];
	assign rgb_mode = ctrlbyte_reg[4:2];
	
	reg [1:0] state_reg,state_next;
	localparam [1:0] 
	st_idle = 2'b00,
	st_1 = 2'b01,
	st_2 = 2'b10;
	
	always@(posedge clk)begin
		if(rst)begin
			state_reg<=st_idle;
			ctrlbyte_reg<=0;
		end
		else begin
			state_reg<=state_next;
			ctrlbyte_reg<=ctrlbyte_next;
		end
	end
	
	
	always@(*)begin
		state_next=state_reg;
		ctrlbyte_next=ctrlbyte_reg;
		lora_ok=1'b0;
		case(state_reg)
			st_idle:begin
				if(rt)begin
					if(rd==8'haa)begin
						state_next=st_1;
					end
				end
			end
			st_1:begin
				if(rt)begin
					ctrlbyte_next=rd;
					state_next=st_2;
				end
			end
			st_2:begin
				if(rt)begin
					if(rd==8'haa)begin
						lora_ok=1'b1;
					end
				end
				state_next=st_idle;
			end
		endcase
	end
endmodule
