module vga_display(
	input clk25,
	input [9:0] data_h,
	input [9:0] data_v,
	input [9:0] snake_h,
	input [9:0] snake_v,
	input [9:0] egg_h,
	input [9:0] egg_v,
	output reg [11:0] data
);

parameter C_BLACK    =   12'b000000000000;
parameter C_RED    =   12'b111100000000;
parameter C_GREEN    =   12'b000011110000;
parameter C_BLUE    =   12'b000000001111;
parameter C_WHITE    =   12'b111111111111;

//需要显示左上角行列坐标
parameter HPOS = 10'd0;
parameter VPOS = 10'd0;
//最大宽度高度
parameter WIDTH = 10'd640;
parameter HEIGHT = 10'd480;

//蛇的宽高
parameter SNAKE_WIDTH = 32;
parameter SNAKE_HEIGHT = 32;



reg pic_show = 1'b0;  //当前位置是否需要显示图片
reg is_snake = 1'b0;  //画蛇头

always @(*)begin
	if((data_h >= HPOS) && (data_h < HPOS + WIDTH) && (data_v >= VPOS) && (data_v < VPOS + HEIGHT))
		pic_show <= 1'b1;
	else
		pic_show <= 1'b0;
end

//display snake
always @(*)begin
	//蛇方块都在屏幕内
	if((data_h >= snake_h) && (data_h < snake_h + SNAKE_WIDTH) && (data_v >= snake_v) && (data_v < snake_v + SNAKE_HEIGHT))begin
		if(pic_show)
			data <= C_RED;
	end
	else
		data <= C_WHITE;
	end

endmodule