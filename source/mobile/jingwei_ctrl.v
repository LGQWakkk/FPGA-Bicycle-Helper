`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/13 13:31:59
// Design Name: 
// Module Name: jingwei_ctrl
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

//20230613 13:56 V1

//注意：纬度对应m,经度对应n!

module jingwei_ctrl(
	input wire clk,rst,
	input wire [16:0] jing_num,
	input wire [16:0] wei_num,
	input wire data_en,
	output wire [8:0] wei_m_scaled,
	output wire [8:0] jing_n_scaled,
	output wire in_region
    );
	
	localparam [16:0] m_offset = 17'd18000;//纬度偏移(m_offset)
	localparam [16:0] n_offset = 17'd7000;//经度偏移(n_offset)
	
	reg [16:0] jing_num_reg,jing_num_next;
	reg [16:0] wei_num_reg,wei_num_next;
	reg in_region_reg,in_region_next;
	
	wire wei_m_valid;
	wire jing_n_valid;
	wire [8:0] wei_m_scaled;
	wire [8:0] jing_n_scaled;
	wire [16:0] wei_offset;
	wire [16:0] jing_offset;
	
	//计算偏移
	assign wei_offset=wei_num_reg-m_offset;
	assign jing_offset=jing_num_reg-n_offset;
	
	//计算缩放并适配位数 /32  [5+8:5]
	//理论上：wei_m_scaled(0-319)  jing_n_scaled(0-239)
	assign wei_m_scaled=wei_offset[13:5];
	assign jing_n_scaled=jing_offset[13:5];//0-7648
	
	//判断位置有效性
	assign wei_m_valid = ((wei_m_scaled>=0)&&(wei_m_scaled<=319))?1'b1:1'b0;
	assign jing_n_valid = ((jing_n_scaled>=0)&&(jing_n_scaled<=239))?1'b1:1'b0;
	assign in_region = (wei_m_valid&&jing_n_valid)?1'b1:1'b0;
	
	//经度对应n坐标 经度增加n增加
	//纬度对应m坐标 纬度增加m增加
	//经纬度换算到地图坐标的比例：除以32
	//之前采集的经纬度范围：经度:07679-12950 纬度：18762-30110
	//简化之后：06000-13000 (07000)   18000-30000 (12000)
	//除以32:   218.75 333 
	
	
	
	
	
	//大概包括了320*240  这个到时候再微调也行

	always@(posedge clk)begin
		if(rst)begin
			jing_num_reg<=0;
			wei_num_reg<=0;
			in_region_reg<=0;
		end
		else begin
			jing_num_reg<=jing_num_next;
			wei_num_reg<=wei_num_next;
			in_region_reg<=in_region_next;
		end
	end
	
	always@(*)begin
		jing_num_next=jing_num_reg;
		wei_num_next=wei_num_reg;
		in_region_next=in_region_reg;
		if(data_en)begin
			jing_num_next=jing_num;
			wei_num_next=wei_num;
		end
	end
	
	
endmodule
