`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/02 15:56:42
// Design Name: 
// Module Name: ex3_2025
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


module ex3_2025(
	input mclk,
	input [4:0] BOTTOM,
	output [3:0] vga_red,
	output [3:0] vga_green,
	output [3:0] vga_blue,
	output vga_hsync,
	output vga_vsync
);

//参考
//https://blog.csdn.net/qq_37899920/article/details/123594833  显示图片
//http://blog.chinaaet.com/weiqi7777/p/44378   数字钟

wire clk25;
wire [9:0] data_h;
wire [9:0] data_v;

//snake
wire [9:0] snake_h;
wire [9:0] snake_v;

//egg
wire [9:0] egg_h;
wire [9:0] egg_v;

//score
wire [9:0] score;

wire [11:0] data;

reg [1:0]  countera1 = 2'd0;

always @(posedge mclk)begin
    countera1 <= countera1 + 1;
end
  
assign clk25 = countera1[1];  //4分频到25MHz

vga_driver u_vga_driver(
	.clk25(clk25),
	.vga_red(vga_red),
	.vga_green(vga_green),
	.vga_blue(vga_blue),
	.vga_hsync(vga_hsync),
	.vga_vsync(vga_vsync),
	.data_h(data_h),
	.data_v(data_v),
	.data(data)
);

vga_display u_vga_display(
	.clk25(clk25),
	.data_h(data_h),
	.data_v(data_v),
	.snake_h(snake_h),
	.snake_v(snake_v),
	.egg_h(egg_h),
	.egg_v(egg_v),
	.data(data)
);

bottom_control u_bottom_control(
	.clk(mclk),
	.BOTTOM(BOTTOM),
	.snake_h(snake_h),
	.snake_v(snake_v),
	.egg_h(egg_h),
	.egg_v(egg_v),
	.score(score)
);

endmodule
	