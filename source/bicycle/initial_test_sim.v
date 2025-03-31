`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/10 13:38:04
// Design Name: 
// Module Name: initial_test_sim
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
//20230610 IIC oled_initial仿真通过
//20230610 测试成功 V1

module initial_test_sim();



	reg clk,rst;
	wire scl,sda,initial_done;
	// module initial_test(
	// input wire clk,rst,
	// output wire scl,sda,
	// output reg initial_done
    // );
	initial_test u_initial_test(
	.clk(clk),
	.rst(rst),
	.scl(scl),
	.sda(sda),
	.initial_done(initial_done)
	);

	initial begin
	clk=1'b1;
	rst=1'b1;
	#10;
	rst=1'b0;
	end
	
	always #5 clk=~clk;
	
endmodule
