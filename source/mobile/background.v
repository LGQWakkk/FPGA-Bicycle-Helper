`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/14 22:33:50
// Design Name: 
// Module Name: background
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
//20230614 22:56 V1

//0-15   Mobile Information
//16-31  UTC Time   00h00m00s
//32-47  Latitude   0000 00000
//48-63  Longitude 00000 00000
//64-79  Speed     000 00
//80-95  Heading   000 00

//96-111  Bicycle Information
//112-127 Latitude   0000 00000
//128-143 Longitude 00000 00000
//144-159 Speed     000 00
//160-175 Heading   000 00

//176-191 Bell
//192-207 LED
//208-223 RGB Mode
//224-239 Lock Safety


//blue: 00000 000000 11111 0x001f
//red； 11111 000000 00000 0xf800
//green:00000 111111 00000 0x07e0

//默认黑底白字

module background(
	input wire font_bit,
	input wire [8:0] pixel_x,
	input wire [8:0] pixel_y,
	input wire led,bell,safety,lock,rgb_on,
	input wire [2:0] rgb_mode,
	output reg [15:0] data
    );
	
	localparam [15:0] 
	WHITE = 16'hffff,
	BLACK = 16'h0000,
	RED   = 16'hf800,
	GREEN = 16'h07e0,
	BLUE  = 16'h001f;
	
	always@(*)begin
		if((pixel_y>=0)&&(pixel_y<=15))begin
			if(font_bit)begin
				data=BLACK;
			end
			else begin
				data=GREEN;
			end
		end
		else if((pixel_y>=96)&&(pixel_y<=111))begin
			if(font_bit)begin
				data=BLACK;
			end
			else begin
				data=GREEN;
			end
		end
		else if((pixel_y>=176)&&(pixel_y<=191))begin//Bell
			if(bell)begin
				if(font_bit)begin//响铃 白底黑字
					data=BLACK;
				end
				else begin
					data=WHITE;
				end
			end
			else begin
				if(font_bit)begin
					data=WHITE;
				end
				else begin
					data=BLACK;
				end
			end
		end
		else if((pixel_y>=192)&&(pixel_y<=207))begin//LED
			if(led)begin
				if(font_bit)begin//LED开启
					data=BLACK;
				end
				else begin
					data=WHITE;
				end
			end
			else begin
				if(font_bit)begin
					data=WHITE;
				end
				else begin
					data=BLACK;
				end
			end
		end
		else if((pixel_y>=208)&&(pixel_y<=223))begin//RGB MODE
			if(rgb_on)begin//RGB开启
				if(font_bit)begin
					data=BLACK;//黑字
				end
				else begin
					case(rgb_mode)
						3'd0:data=RED;
						3'd1:data=GREEN;
						3'd2:data=BLUE;
						default:data=WHITE;
					endcase
				end
			end
			else begin
				if(font_bit)begin
					data=WHITE;
				end
				else begin
					data=BLACK;
				end
			end
		end
		else if((pixel_y>=224)&&(pixel_y<=239))begin//lock safety
			if(lock)begin//锁定
				if(safety)begin//锁定且不安全
					if(font_bit)begin
						data=BLACK;
					end
					else begin
						data=RED;
					end
				end
				else begin//锁定但安全
					if(font_bit)begin
						data=BLACK;
					end
					else begin
						data=GREEN;
					end
				end
			end
			else begin
				if(font_bit)begin
					data=WHITE;
				end
				else begin
					data=BLACK;
				end
			end
		end
		else begin//默认黑底白字
			if(font_bit)begin
				data=WHITE;
			end
			else begin
				data=BLACK;
			end
		end
	end
	
endmodule
