module score_display(
	input        clk,	
	input        rst_n,  		
	input  [6:0] score,	
	input  [9:0] posx,
    input  [9:0] posy,
	output reg   score_char	
);
localparam FREM_X_START = 	10'd608  ;	//X起始坐标
localparam FREM_Y_START = 	10'd16 ;	//Y起始坐标
localparam LENGTH		=	5'd2	;

localparam OSD_WIDTH   	=  	12'd8  ;	//设置OSD的宽度，可根据字符生成软件设�?
localparam OSD_HEGIHT  	=  	12'd16 ;	//设置OSD的高度，可根据字符生成软件设�?

reg	 [6:0]  		score_cnt [LENGTH-1:0] ;
reg	 [5:0]  		addr ;
wire [127:0]        char_data;
reg  [127:0]        rom_char_data[9:0]; 
reg  [LENGTH-1:0]   score_region_active;
	
wire [5:0]          score_data [LENGTH-1:0];

assign score_data[0 ] = score/10%10;
assign score_data[1 ] = score  %10;


//generate i生成2个显示区�?
genvar i ;
generate
	for (i = 0 ;i < LENGTH ; i = i + 1)
	begin : score_osd_region
		//OSD区域设置，起始坐标，区域大小根据生成的字符长宽设�?
		always@(posedge clk)
		begin
			if(posy >= FREM_Y_START && posy <= FREM_Y_START + OSD_HEGIHT - 10'd1 
				&& posx >= FREM_X_START + OSD_WIDTH*i  && posx  <= FREM_X_START + OSD_WIDTH*(i+1)-10'd1)begin			
                score_region_active[i] <= 1'b1;
            end
			else begin
				score_region_active[i] <= 1'b0;
            end
		end
	
		always@(posedge clk or negedge rst_n)
		begin
            if(~rst_n)
                score_cnt[i] <= 7'd0;
			else if(score_region_active[i] == 1'b1)
				score_cnt[i] <= score_cnt[i] + 7'd1;
		end		
	end		
endgenerate


always@(posedge clk)
begin
	case(score_region_active)
		'b01: score_char <= (char_data[127-score_cnt[0 ]] == 1'b1)? 1'b1: 1'b0;	   
		'b10: score_char <= (char_data[127-score_cnt[1 ]] == 1'b1)? 1'b1: 1'b0;
		default	: score_char <= 1'b0;
	endcase
end

always@(*)
begin
	case(score_region_active)
		'b01: addr = score_data[0 ];	   
		'b10: addr = score_data[1 ];
		default	: addr = 6'd0;
	endcase
end

initial begin
	rom_char_data[0] = 128'h00000018244242424242424224180000;
	rom_char_data[1] = 128'h000000083808080808080808083E0000;
	rom_char_data[2] = 128'h0000003C4242420204081020427E0000;
	rom_char_data[3] = 128'h0000003C4242020418040242423C0000;
	rom_char_data[4] = 128'h000000040C0C142424447F04041F0000;
	rom_char_data[5] = 128'h0000007E404040784402024244380000;
	rom_char_data[6] = 128'h000000182440405C62424242221C0000;
	rom_char_data[7] = 128'h0000007E420404080810101010100000;
	rom_char_data[8] = 128'h0000003C4242422418244242423C0000;
	rom_char_data[9] = 128'h0000003844424242463A020224180000;
end
assign char_data = rom_char_data[addr];

endmodule

