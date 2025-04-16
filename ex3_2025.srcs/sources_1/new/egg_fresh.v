`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/16 15:25:10
// Design Name: 
// Module Name: egg_fresh
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


module egg_fresh(
	input   clk,
	input  [9:0] snake_h,
	input  [9:0] snake_v,
	output [9:0] egg_h,
	output [9:0] egg_v,
	output [9:0] score
);

//需要显示左上角行列坐标
parameter HPOS = 10'd0;
parameter VPOS = 10'd0;
//最大宽度高度
parameter WIDTH = 10'd640;
parameter HEIGHT = 10'd480;

//蛇的宽高
parameter SNAKE_WIDTH = 32;
parameter SNAKE_HEIGHT = 32;

//蛋的宽高
parameter EGG_WIDTH = 16;
parameter EGG_HEIGHT = 16;

//游戏相关
reg [9:0] score_r = 10'd0;
reg [9:0] random_cnt = 10'd0;
reg [9:0] rand_h = WIDTH / 2;
reg [9:0] rand_v = HEIGHT / 2;
reg eat_flag = 1'b0;

//随机数不断增加
always @(posedge clk)begin
	random_cnt <= random_cnt + 10'd1;
end

//判断蛇与蛋的碰撞
always @(posedge clk)begin
	//从左往右吃  与  从上往下吃 与 从小往上吃
	if(((snake_h + SNAKE_WIDTH >= egg_h + EGG_WIDTH) && (snake_h <= egg_h)) && ((snake_v + SNAKE_HEIGHT >= egg_v + EGG_HEIGHT) && (snake_v <= egg_v)))
		eat_flag <= 1'b1;
	//从右往左吃
	else if(((snake_h + SNAKE_WIDTH <= egg_h + EGG_WIDTH) && (snake_h >= egg_h)) && ((snake_v + SNAKE_HEIGHT >= egg_v + EGG_HEIGHT) && (snake_v <= egg_v)))
		eat_flag <= 1'b1;
	else
		eat_flag <= 1'b0;
end


// 蛋的刷新
always @(posedge clk)begin
	if(eat_flag == 1'b1)begin
		rand_h <= random_cnt % WIDTH;
		rand_v <= random_cnt % HEIGHT;
	end
end

//得分刷新
always @(posedge clk)begin
	if(eat_flag == 1'b1)begin
		score_r <= score_r + 10'd1;
	end
end

assign egg_h = rand_h;
assign egg_v = rand_v;
assign score = score_r;

endmodule
