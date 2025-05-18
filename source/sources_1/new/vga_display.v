module vga_display(
	input clk25,
	input rst_n,
	input [1:0] snake,
	input egg,
	input score_char,
	input [1:0] status,
	input [9:0] posx,
	input [9:0] posy,
	output reg [11:0] data
);

localparam RESTART = 2'b00;
localparam START = 2'b01;
localparam PLAY = 2'b10;
localparam DIE = 2'b11;

parameter C_BLACK    =   12'b000000000000;
parameter C_RED    =   12'b111100000000;
parameter C_GREEN    =   12'b000011110000;
parameter C_BLUE    =   12'b000000001111;
parameter C_YELLOW    =   12'b111111110000;
parameter C_WHITE    =   12'b111111111111;

localparam N = 2'b00;
localparam H = 2'b01;
localparam B = 2'b10;
localparam W = 2'b11;

wire [11:0] st_display;


//控制颜色输出
always @(*)begin
	if(status == RESTART || status == START)begin
	   data = st_display;
	end
	else begin
		if(egg || score_char)
			data = C_BLACK;
		else begin
			case(snake)
				N:data=C_WHITE;
				H:data=C_BLUE;
				B:data=C_GREEN;
				W:data=C_RED;
			endcase
		end
	end
end

start_display start_display(
	.clk(clk25),        // 系统时钟
    .rst_n(rst_n),      // 低电平复位信号  
    .posx(posx),       // 当前像素X坐标
    .posy(posy),       // 当前像素Y坐标
    .st_display(st_display)  // 像素显示使能信号
);

endmodule