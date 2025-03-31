`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/06 18:27:58
// Design Name: 
// Module Name: char2num
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

//20230606 By YuYuanHao
//20230613 14:05 V1

// module char2num(
	// input wire [34:0] jing_ch,
	// input wire [34:0] wei_ch,
	// output wire [] jing_num,
	// output wire [] wei_num
    // );
	
//20230613 14:24 这里添加了减去0的ASCII码

module char2num(
    input [34:0] a,
    output [16:0] out
    );
   
    reg [6:0] data1,data2,data3,data4,data17;
    reg [19:0] data18;
    reg [17:0] data19;
    reg [14:0] data20;
    reg [10:0] data21;
    reg [16:0] data5;
    reg [10:0] data6;
    reg [9:0] data7;
    reg [12:0] data8;
    reg [11:0] data9;
    reg [8:0] data10;
    reg [9:0] data11;
    reg [7:0] data12;
    reg [19:0] data13,data14,data15,data16,data22;
    
    always@(*)
    begin   
    data17=a[34:28]-7'h30; 
    data1=a[27:21]-7'h30;
    data2=a[20:14]-7'h30;
    data3=a[13:7]-7'h30;
    data4=a[6:0]-7'h30;
	
    data18={data17,13'b0000000000000};
    data19={data17,11'b00000000000};
    data20={data17,8'b00000000};
    data21={data17,4'b0000};
    data5={data1,10'b0000000000};
    data6={data1,4'b0000};
    data7={data1,3'b000};
    data8={data2,6'b000000};
    data9={data2,5'b00000};
    data10={data2,2'b00};
    data11={data3,3'b000};
    data12={data3,1'b0};
    data13=data5-data6-data7;
    data14=data8+data9+data10;
    data15=data11+data12;
    data16=data18+data19-data20+data21;
    data22=data13+data14+data15+data16+data4;
    end 
    
    assign  out=data22[16:0];
	
endmodule
