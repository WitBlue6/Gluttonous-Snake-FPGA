module ex3_2025(
	input mclk,
	input rst_n,
	input [4:0] BOTTOM,
	input [1:0] SW,
	output [3:0] vga_red,
	output [3:0] vga_green,
	output [3:0] vga_blue,
	output vga_hsync,
	output vga_vsync
);

wire clk25;
wire [9:0] data_h;
wire [9:0] data_v;
wire [11:0] data;
//key
wire b_up,b_down,b_left,b_right,b_center;
//snake
wire [1:0]snake;
wire [5:0]headx;
wire [5:0]heady;
wire	hitbody;
wire	hitwall;
wire	die;
wire [1:0]status;
wire	score_flag;
wire [15:0] point ;
wire [6:0] score;
wire		score_char;
//egg
wire [9:0] egg_x;
wire [9:0] egg_y;
wire	   egg;
wire	add;
//start_display
wire st_display;


reg [1:0]  countera1 = 2'd0;
always @(posedge mclk)begin
    countera1 <= countera1 + 1;
end
assign clk25 = countera1[1]; 

vga_driver u_vga_driver(
	.clk25		(clk25),
	.vga_red	(vga_red),
	.vga_green	(vga_green),
	.vga_blue	(vga_blue),
	.vga_hsync	(vga_hsync),
	.vga_vsync	(vga_vsync),
	.data_h		(data_h),
	.data_v		(data_v),
	.data		(data)
);

vga_display(
	.clk25		(clk25),
	.rst_n		(rst_n),
	.snake		(snake),
	.egg		(egg),
	.data   	(data),
	.status		(status),
	.posx       (data_h),
	.posy       (data_v),
	.score_char	(score_char)
);

key_filter u_key_filter(
	.clk		(mclk),
	.rst_n		(rst_n),
	.BOTTOM		(BOTTOM),
	.b_up		(b_up),
	.b_down		(b_down),
	.b_left		(b_left),
	.b_right	(b_right),
	.b_center	(b_center)
);

game_control u_game_control(
    .clk		(mclk),
	.rst_n		(rst_n),
	.hitwall	(hitwall),
    .hitbody	(hitbody),
	.key		(b_center),
	.die		(die),
    .status		(status),
	.score_flag	(score_flag),
	.point		(point) 
);

snake_control u_snake_control (
    .clk		(mclk),
    .rst_n		(rst_n),    
    .b_left		(b_left),
    .b_right	(b_right),
    .b_up		(b_up),
    .b_down		(b_down),
	.b_center	(b_center), 
	.SW			(SW),
    .posx		(data_h),
    .posy		(data_v),
    .add		(add),
    .status		(status),
    .die		(die),     
    .snake		(snake),
	.score		(score),
    .headx		(headx),    
    .heady		(heady),
    .hitbody	(hitbody),   
    .hitwall    (hitwall)
);

egg_fresh u_egg_fresh(
	.clk		(mclk),
	.rst_n		(rst_n),
	.snake_x	(headx),
	.snake_y	(heady),
	.posx		(data_h),
    .posy		(data_v),
	.egg_x		(egg_x),
	.egg_y		(egg_y),
	.egg		(egg),
	.add        (add)
);

score_display u_score_display(
	.clk		(clk25),	
	.rst_n		(rst_n),  		
	.score		(score),	
	.posx		(data_h),
    .posy		(data_v),
	.score_char	(score_char)	
);

endmodule
	