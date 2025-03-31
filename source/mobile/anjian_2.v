`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/12 08:38:50
// Design Name: 
// Module Name: anjian_2
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


module anjian_2(
    input clk,
    input rst,
    input s1,
    input s2,
    input key,
    output key_in,
    output [2:0] shu
    );
    
    localparam [1:0] 
             idle=2'b00,
             start=2'b01,
             data=2'b10,
             stop=2'b11;
             
    reg [1:0] state_reg,state_next;
    reg [2:0] cnt_reg,cnt_next;
    
    assign key_in=key;
    assign shu=cnt_reg;
    
    always@(posedge clk or posedge rst) begin
    if(rst) begin
    state_reg<=0;
    cnt_reg<=0;
    end
    else begin
    state_reg<=state_next;
    cnt_reg<=cnt_next;
    end
    end
    
    always@(*) begin
    state_next=state_reg;
    cnt_next=cnt_reg;
    case(state_reg)
        idle: state_next=start;
        start:begin
              if(s2==1'b0)
              state_next=data;
              else
              state_next=start;
              end
       data:begin
				if(s1==1'b0) begin
					if(s2==1'b1) begin
					cnt_next=cnt_reg+1;//顺时针
					state_next=stop;
					end
				end
				else begin
					if(s2==1'b1) begin
					cnt_next=cnt_reg-1;//逆时针
					state_next=stop;
					end
				end
            end
      stop:begin
           if(s1==1'b1)
           state_next=idle;
           end
     default:state_next=idle;
     endcase
     end
endmodule