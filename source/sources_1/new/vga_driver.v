`timescale 1ns / 1ps

module vga_driver(
	input  clk25,
	output [3:0] vga_red,
	output [3:0] vga_green,
	output [3:0] vga_blue,
	output reg vga_hsync,
	output reg vga_vsync,
	//要显示的数据的行列坐标和数据
	output [9:0] data_h,
	output [9:0] data_v,
	input [11:0] data
    );
//Timing constants
parameter hRez   = 640;
parameter hStartSync   = 640+16;
parameter hEndSync     = 640+16+96;
parameter hMaxCount    = 640+16+96+48;
    
parameter vRez         = 480;
parameter vStartSync   = 480+10;
parameter vEndSync     = 480+10+2;
parameter vMaxCount    = 480+10+2+33;
    
parameter hsync_active  = 0;
parameter vsync_active  = 0;
// color define
parameter C_BLACK    =   12'b000000000000;
parameter C_RED    =   12'b111100000000;
parameter C_GREEN    =   12'b000011110000;
parameter C_BLUE    =   12'b000000001111;
parameter C_WHITE    =   12'b111111111111;
//counter
reg [9:0] hCounter;
reg [9:0] vCounter;    
reg blank;
initial   hCounter = 10'b0;
initial   vCounter = 10'b0;  
//vaild flag active low
initial   blank = 1'b1;    


wire [11:0] colour;

assign colour = (~blank) ? data : 16'd0;
assign vga_red = colour[11:8];
assign vga_green = colour[7:4];
assign vga_blue = colour[3:0];

assign data_h = (~blank) ? hCounter : 10'd0;
assign data_v = (~blank) ? vCounter : 10'd0;

always@(posedge clk25)begin
    if( hCounter == hMaxCount-1 )begin
   		hCounter <=  10'b0;
   			if (vCounter == vMaxCount-1)
   				vCounter <=  10'b0;
   			else
   				vCounter <= vCounter+1;
   	end
   	else
   		hCounter <= hCounter+1;
     	
   	if(  vCounter  >= 480 || vCounter  < 0) begin    //场计数器
   		blank <= 1;
   	end
   	else begin
   		if ( hCounter  < 640 && hCounter  >= 0) begin  //行计数器
   			blank <= 0;
   			end
   		else
   			blank <= 1;
   	end;
   	

   	if( hCounter > hStartSync && hCounter <= hEndSync)
   		vga_hsync <= hsync_active;
   	else
   		vga_hsync <= ~ hsync_active; 			
   	if( vCounter >= vStartSync && vCounter < vEndSync )
   		vga_vsync <= vsync_active;
   	else
   		vga_vsync <= ~ vsync_active;
   end 

endmodule
