`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/25 10:48:08
// Design Name: 
// Module Name: mod_m_counter
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

//20230603 7:58最新版本
//注意在9600波特率下的计数值

module mod_m_counter
#(
	parameter N=10,//计数器比特数 应为大于log2M的整数
	M=651//模M
)
(
	input wire clk,reset,
	output wire max_tick,
	output wire [N-1:0] q //输出计数值，一般没有什么用
    );
	
	reg [N-1:0] r_reg;
	wire [N-1:0] r_next; //注意，这里面使用的wire!
	//我找到规律了：
	//当次态逻辑用always块来描述的时候使用reg作为次态量，但是不会综合出寄存器
	//当次态逻辑用assign来描述的时候使用wire作为次态量
	
	//寄存器
	always@(posedge clk or posedge reset)begin
		if(reset)begin
			r_reg<=0;//注意这里面，当多位的寄存器清零时，若不指出位数而清零，写一个0即可
		end
		else begin
			r_reg<=r_next;
		end
	end
	//次态逻辑 使用assign来描述
	assign r_next = (r_reg==(M-1))?0:r_reg+1; 
	
	//输出逻辑
	assign q = r_reg;
	assign max_tick= (r_reg==(M-1))?1'b1:1'b0;//对于一个bit的信号，就写出位宽吧，我也不知道为啥。
	
endmodule
