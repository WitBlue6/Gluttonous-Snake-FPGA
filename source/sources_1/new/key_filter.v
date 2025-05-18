module key_filter(
	input  clk,
	input  rst_n,
	input  [4:0] BOTTOM,
	output b_up,
	output b_down,
	output b_left,
	output b_right,
	output b_center
);
	
//按键消抖
reg [4:0] bottom_scan;
reg [4:0] bottom_scan_d0;
reg [4:0] bottom;   //按键消抖结果
reg [24:0] b_cnt = 25'd0;


always @(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		b_cnt <= 25'd0;
		bottom_scan <= 5'b0;
	end
	else if(b_cnt == 25'd1999_999)begin  //20ms
		b_cnt <= 25'd0;
		bottom_scan <= BOTTOM;
	end
	else
		b_cnt <= b_cnt + 25'd1;
end

always @(posedge clk or negedge rst_n)begin
	if(~rst_n)begin
		bottom_scan_d0 <= 5'b0;
		bottom <= 5'b0;
	end
	else begin
		bottom_scan_d0 <= bottom_scan;
		bottom <= (~bottom_scan_d0) & bottom_scan;  //上升沿
	end
end

//按键
assign b_up = bottom[4];
assign b_down = bottom[3];
assign b_left = bottom[2];
assign b_right = bottom[1];
assign b_center = bottom[0];

endmodule