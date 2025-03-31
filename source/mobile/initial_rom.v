`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/31 00:14:37
// Design Name: 
// Module Name: initial_rom
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
//20230608 适应全屏 修改参数


//LCD初始化数据存储ROM
//约有100个初始化数据 采用7bit进行寻址 [6:0]
//数据格式： [8:0] DCX+DATA
module initial_rom(
	input wire clk,
	input wire [6:0] addr,//0-92
	output reg [8:0] data
    );

	reg [6:0] addr_reg;
	
	always@(posedge clk)begin
		addr_reg<=addr;
	end
	
	//目前有93个数据（0-92）
	always@(*)begin
	data=0;
		case(addr_reg)	
			7'd0:data={1'b0,8'hF9};
			7'd1:data={1'b1,8'h00};
			7'd2:data={1'b1,8'h08};
			
			7'd3:data={1'b0,8'hC0};
			7'd4:data={1'b1,8'h19};
			7'd5:data={1'b1,8'h1A};
			
			7'd6:data={1'b0,8'hC1};
			7'd7:data={1'b1,8'h45};
			7'd8:data={1'b1,8'h00};
			
			7'd9:data={1'b0,8'hC2};
			7'd10:data={1'b1,8'h33};
			
			7'd11:data={1'b0,8'hC5};
			7'd12:data={1'b1,8'h00};
			7'd13:data={1'b1,8'h28};
			
			7'd14:data={1'b0,8'hB1};
			7'd15:data={1'b1,8'hB0};
			7'd16:data={1'b1,8'h11};
			
			7'd17:data={1'b0,8'hB4};
			7'd18:data={1'b1,8'h02};
			
			7'd19:data={1'b0,8'hB6};
			7'd20:data={1'b1,8'h00};
			7'd21:data={1'b1,8'h42};
			7'd22:data={1'b1,8'h3B};
			
			7'd23:data={1'b0,8'hB7};
			7'd24:data={1'b1,8'h07};
			
			7'd25:data={1'b0,8'hE0};
			7'd26:data={1'b1,8'h1F};
			7'd27:data={1'b1,8'h25};
			7'd28:data={1'b1,8'h22};
			7'd29:data={1'b1,8'h0B};
			7'd30:data={1'b1,8'h06};
			7'd31:data={1'b1,8'h0A};
			7'd32:data={1'b1,8'h4E};
			7'd33:data={1'b1,8'hC6};
			7'd34:data={1'b1,8'h39};
			7'd35:data={1'b1,8'h00};
			7'd36:data={1'b1,8'h00};
			7'd37:data={1'b1,8'h00};
			7'd38:data={1'b1,8'h00};
			7'd39:data={1'b1,8'h00};
			7'd40:data={1'b1,8'h00};
			
			7'd41:data={1'b0,8'hE1};
			7'd42:data={1'b1,8'h1F};
			7'd43:data={1'b1,8'h3F};
			7'd44:data={1'b1,8'h3F};
			7'd45:data={1'b1,8'h0F};
			7'd46:data={1'b1,8'h1F};
			7'd47:data={1'b1,8'h0F};
			7'd48:data={1'b1,8'h46};
			7'd49:data={1'b1,8'h49};
			7'd50:data={1'b1,8'h31};
			7'd51:data={1'b1,8'h05};
			7'd52:data={1'b1,8'h09};
			7'd53:data={1'b1,8'h03};
			7'd54:data={1'b1,8'h1C};
			7'd55:data={1'b1,8'h1A};
			7'd56:data={1'b1,8'h00};
			
			7'd57:data={1'b0,8'hF1};
			7'd58:data={1'b1,8'h36};
			7'd59:data={1'b1,8'h04};
			7'd60:data={1'b1,8'h00};
			7'd61:data={1'b1,8'h3C};
			7'd62:data={1'b1,8'h0F};
			7'd63:data={1'b1,8'h0F};
			7'd64:data={1'b1,8'hA4};
			7'd65:data={1'b1,8'h02};
			
			7'd66:data={1'b0,8'hF2};
			7'd67:data={1'b1,8'h18};
			7'd68:data={1'b1,8'hA3};
			7'd69:data={1'b1,8'h12};
			7'd70:data={1'b1,8'h02};
			7'd71:data={1'b1,8'h32};
			7'd72:data={1'b1,8'h12};
			7'd73:data={1'b1,8'hFF};
			7'd74:data={1'b1,8'h32};
			7'd75:data={1'b1,8'h00};
			
			7'd76:data={1'b0,8'hF4};
			7'd77:data={1'b1,8'h40};
			7'd78:data={1'b1,8'h00};
			7'd79:data={1'b1,8'h08};
			7'd80:data={1'b1,8'h91};
			7'd81:data={1'b1,8'h04};
			
			7'd82:data={1'b0,8'hF8};
			7'd83:data={1'b1,8'h21};
			7'd84:data={1'b1,8'h04};
			
			7'd85:data={1'b0,8'h36};
			7'd86:data={1'b1,8'h48};
			
			7'd87:data={1'b0,8'h3A};
			7'd88:data={1'b1,8'h55};
			
			7'd89:data={1'b0,8'h11};
			
			//set param
			7'd90:data={1'b0,8'h29};
			7'd91:data={1'b0,8'h36};
			7'd92:data={1'b1,8'h08};
			
			//set windows
			//set x
			7'd93:data={1'b0,8'h2A};
			7'd94:data={1'b1,8'h00};//xstart h8
			7'd95:data={1'b1,8'h00};//xstart l8
			7'd96:data={1'b1,8'h01};//xend h8 
			7'd97:data={1'b1,8'h3f};//xend l8
			//set y
			7'd98:data={1'b0,8'h2B};
			7'd99:data={1'b1,8'h00};//ystart h8
			7'd100:data={1'b1,8'h00};//ystart l8
			7'd101:data={1'b1,8'h01};//yend h8  479 01df
			7'd102:data={1'b1,8'hdf};//yend l8
			//write dram
			7'd103:data={1'b0,8'h2C};
		endcase
	end
endmodule
