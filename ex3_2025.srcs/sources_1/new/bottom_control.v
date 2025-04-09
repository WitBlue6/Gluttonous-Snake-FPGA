`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/09 15:28:27
// Design Name: 
// Module Name: bottom_control
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


module bottom_control(
	input  clk,
	input  [4:0] BOTTOM,
	output reg [9:0] snake_h,
	output reg [9:0] snake_v,
	output  [9:0] egg_h,
	output  [9:0] egg_v
);
	
//按键消抖
reg [4:0] bottom_scan;
reg [4:0] bottom_scan_d0;
reg [4:0] bottom;   //按键消抖结果
reg [24:0] b_cnt = 25'd0;

//按键结果
wire b_up, b_down, b_left, b_right, b_center;

always @(posedge clk)begin
	if(b_cnt == 25'd1999_999)begin  //每20ms扫描一次
		b_cnt <= 25'd0;
		bottom_scan <= BOTTOM;
	end
	else
		b_cnt <= b_cnt + 25'd1;
end

always @(posedge clk)begin
	bottom_scan_d0 <= bottom_scan;
	bottom <= (~bottom_scan_d0) & bottom_scan;  //上升沿判断
end

//按键赋值
assign b_up = bottom[4];
assign b_down = bottom[3];
assign b_left = bottom[2];
assign b_right = bottom[1];
assign b_center = bottom[0];

//蛇运行方向状态机
reg [2:0] c_state;
reg [2:0] n_state;

parameter state_right = 3'd0;
parameter state_left = 3'd1;
parameter state_down = 3'd2;
parameter state_up = 3'd3;


initial begin
	snake_h = 10'd200;
	snake_v = 10'd200;
	c_state = 3'd0;
end

//需要显示左上角行列坐标
parameter HPOS = 10'd0;
parameter VPOS = 10'd0;
//最大宽度高度
parameter WIDTH = 10'd640;
parameter HEIGHT = 10'd480;

//蛇的宽高
parameter SNAKE_WIDTH = 32;
parameter SNAKE_HEIGHT = 32;

//蛇刷新速度
parameter fresh_time = 32'd4;  //ms

reg [31:0] f_cnt = 32'd0;

//状态机控制蛇
always @(posedge clk)begin
	if(f_cnt == (fresh_time * 100000 - 1))begin
		f_cnt <= 32'd0;
		if(c_state == state_up)begin
			if(snake_v > VPOS)
				snake_v <= snake_v - 10'd1;
		end
		else if(c_state == state_down)begin
			if(snake_v + SNAKE_HEIGHT < VPOS + HEIGHT)
				snake_v <= snake_v + 10'd1;
		end
		else if(c_state == state_right)begin
			if(snake_h + SNAKE_WIDTH < HPOS + WIDTH)
				snake_h <= snake_h + 10'd1;
		end
		else if(c_state == state_left)begin
			if(snake_h > HPOS)
			snake_h <= snake_h - 10'd1;
		end
	end
	else begin
		f_cnt <= f_cnt + 32'd1;
	end
end

//状态转化
always @(posedge clk)begin
	c_state <= n_state;
end

always @(*)begin
	if(b_up)
		n_state <= state_up;
	else if(b_down)
		n_state <= state_down;
	else if(b_left)
		n_state <= state_left;
	else if(b_right)
		n_state <= state_right;
	else
		n_state <= c_state;
end

//刷新豆子
egg_fresh u_egg_fresh(
	.clk(clk)
);

endmodule
