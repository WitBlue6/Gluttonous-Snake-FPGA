module egg_fresh(
	input   clk,
	input	rst_n,
	input  [5:0] snake_x,
	input  [5:0] snake_y,
	input  [9:0] posx,
    input  [9:0] posy,
	output [5:0] egg_x,
	output [5:0] egg_y,
	output reg   egg,
	output reg 	 add
);

//需要显示左上角行列坐标
parameter HPOS = 10'd1;
parameter VPOS = 10'd1;
//最大宽度高度
parameter WIDTH = 10'd34;
parameter HEIGHT = 10'd26;

//游戏相关
reg [9:0] random_cnt = 10'd0;
reg [9:0] rand_h ;
reg [9:0] rand_v ;


//随机数不断增加
always @(posedge clk)begin
	random_cnt <= random_cnt + 10'd1;
end

//判断蛇与蛋的碰撞
always @(posedge clk or negedge rst_n)begin
	if(~rst_n)
		add <= 1'b0;
	else if(snake_x==egg_x && snake_y==egg_y)
		add <= 1'b1;
	else
		add <= 1'b0;
end

// 蛋的刷新
always @(posedge clk)begin
	if(~rst_n)begin
		rand_h = WIDTH / 2 + HPOS;
		rand_v = HEIGHT / 2 + VPOS;
	end
	else if(add == 1'b1)begin
		rand_h <= random_cnt[9:1] % (WIDTH) + HPOS;
		rand_v <= random_cnt[9:1] % (HEIGHT) + VPOS;
	end
end

always @(posx or posy) begin                
    if(posx >= 0 && posx < 640 && posy >= 0 && posy < 480)
		if(posx[9:4] == egg_x && posy[9:4] == egg_y)
			egg <= 1'b1;		
end		


assign egg_x = rand_h;
assign egg_y = rand_v;



endmodule
