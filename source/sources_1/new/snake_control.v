`timescale 1ns / 1ps
module snake_control
(
    input clk,
    input rst_n,    
    input b_left,
    input b_right,
    input b_up,
    input b_down,
	input b_center, 
	input [1:0]SW,
    input [9:0]posx,
    input [9:0]posy,
    input add,
    input [1:0]status,
    input die,     
    output reg [1:0]snake,
	output [6:0] score,
    output [5:0]headx,    
    output [5:0]heady,
    output reg hitbody,   
    output reg hitwall 
);	
	reg [31:0] CNT_MAX;
	
    localparam UP 	= 2'd0;
    localparam DOWN = 2'd1;
    localparam LEFT = 2'd2;
    localparam RIGHT= 2'd3; 
	
    localparam N = 2'b00;   //�?
    localparam H = 2'b01;   //�?
    localparam B = 2'b10;   //�?
    localparam W = 2'b11;   //�?
	
    localparam RESTART = 2'b00;
    localparam PLAY = 2'b10;
	
	reg [6:0]length;
    reg[31:0]cnt;    
    reg[1:0]c_state_snake;
    reg[1:0]n_state_snake;     
	reg	stop;
   
    reg [5:0]cubex[99:0];
	reg [5:0]cubey[99:0];  // 同一数组的x/y合并为一�?
    reg [99:0]exist;  
    reg addstate;   
    reg[3:0]lox;
    reg[3:0]loy;
	
    assign headx = cubex[0];
    assign heady = cubey[0]; 
	assign score = length-7'd3;

	always @(SW)
		case(SW)
			2'b00:CNT_MAX=32'd35_000_000;
			2'b01:CNT_MAX=32'd25_000_000;
			2'b10:CNT_MAX=32'd15_000_000;
			2'b11:CNT_MAX=32'd5_000_000;	
		endcase

	always @(posedge clk or negedge rst_n) begin        
        if(~rst_n)
            stop <= 1'b0; 
        else if(b_center) 
            stop <= ~stop;
    end

    always @(posedge clk or negedge rst_n) begin        
        if(~rst_n)
            c_state_snake <= RIGHT; 
        else if(status == RESTART) 
            c_state_snake <= RIGHT;
        else if(status == PLAY)
            c_state_snake <= n_state_snake;
    end
	
	
    always @(*) begin    
		case ({b_up,b_down,b_left,b_right})
			4'b1000: n_state_snake = (c_state_snake != DOWN	)? UP    : c_state_snake;
			4'b0100: n_state_snake = (c_state_snake != UP	)? DOWN  : c_state_snake;
			4'b0010: n_state_snake = (c_state_snake != RIGHT)? LEFT  : c_state_snake;
			4'b0001: n_state_snake = (c_state_snake != LEFT	)? RIGHT : c_state_snake;
			default: n_state_snake = c_state_snake;
		endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            cnt <= 0;                             
            hitwall <= 0;
            hitbody <= 0;
        end        
        else if(status == RESTART) begin
            cnt <= 0;
			hitwall <= 0;
            hitbody <= 0;  
            cubex[0]  <= 10; cubey[0]  <= 5 ;                                    
            cubex[1]  <= 9 ; cubey[1]  <= 5 ;                                       
            cubex[2]  <= 8 ; cubey[2]  <= 5 ;                
            cubex[3]  <= 0 ; cubey[3]  <= 0 ;                                   
            cubex[4]  <= 0 ; cubey[4]  <= 0 ;                                        
            cubex[5]  <= 0 ; cubey[5]  <= 0 ;                                      
            cubex[6]  <= 0 ; cubey[6]  <= 0 ;                                      
            cubex[7]  <= 0 ; cubey[7]  <= 0 ;                                       
            cubex[8]  <= 0 ; cubey[8]  <= 0 ;                                     
            cubex[9]  <= 0 ; cubey[9]  <= 0 ;                                      
            cubex[10] <= 0 ; cubey[10] <= 0 ;                                      
            cubex[11] <= 0 ; cubey[11] <= 0 ;                                     
            cubex[12] <= 0 ; cubey[12] <= 0 ;                                    
            cubex[13] <= 0 ; cubey[13] <= 0 ;                                     
            cubex[14] <= 0 ; cubey[14] <= 0 ;                                      
            cubex[15] <= 0 ; cubey[15] <= 0 ;
            cubex[16] <= 0 ; cubey[16] <= 0 ;
            cubex[17] <= 0 ; cubey[17] <= 0 ;
            cubex[18] <= 0 ; cubey[18] <= 0 ;
            cubex[19] <= 0 ; cubey[19] <= 0 ;
            cubex[20] <= 0 ; cubey[20] <= 0 ;
            cubex[21] <= 0 ; cubey[21] <= 0 ;
            cubex[22] <= 0 ; cubey[22] <= 0 ;
            cubex[23] <= 0 ; cubey[23] <= 0 ;
            cubex[24] <= 0 ; cubey[24] <= 0 ;
            cubex[25] <= 0 ; cubey[25] <= 0 ;
            cubex[26] <= 0 ; cubey[26] <= 0 ;
            cubex[27] <= 0 ; cubey[27] <= 0 ;
            cubex[28] <= 0 ; cubey[28] <= 0 ;
            cubex[29] <= 0 ; cubey[29] <= 0 ;
            cubex[30] <= 0 ; cubey[30] <= 0 ;
            cubex[31] <= 0 ; cubey[31] <= 0 ;
            cubex[32] <= 0 ; cubey[32] <= 0 ;
            cubex[33] <= 0 ; cubey[33] <= 0 ;
            cubex[34] <= 0 ; cubey[34] <= 0 ;
            cubex[35] <= 0 ; cubey[35] <= 0 ;
            cubex[36] <= 0 ; cubey[36] <= 0 ;
            cubex[37] <= 0 ; cubey[37] <= 0 ;
            cubex[38] <= 0 ; cubey[38] <= 0 ;
            cubex[39] <= 0 ; cubey[39] <= 0 ;
            cubex[40] <= 0 ; cubey[40] <= 0 ;
            cubex[41] <= 0 ; cubey[41] <= 0 ;
            cubex[42] <= 0 ; cubey[42] <= 0 ;
            cubex[43] <= 0 ; cubey[43] <= 0 ;
            cubex[44] <= 0 ; cubey[44] <= 0 ;
            cubex[45] <= 0 ; cubey[45] <= 0 ;
            cubex[46] <= 0 ; cubey[46] <= 0 ;
            cubex[47] <= 0 ; cubey[47] <= 0 ;
            cubex[48] <= 0 ; cubey[48] <= 0 ;
            cubex[49] <= 0 ; cubey[49] <= 0 ;
            cubex[50] <= 0 ; cubey[50] <= 0 ;
            cubex[51] <= 0 ; cubey[51] <= 0 ;
            cubex[52] <= 0 ; cubey[52] <= 0 ;
            cubex[53] <= 0 ; cubey[53] <= 0 ;
            cubex[54] <= 0 ; cubey[54] <= 0 ;
            cubex[55] <= 0 ; cubey[55] <= 0 ;
            cubex[56] <= 0 ; cubey[56] <= 0 ;
            cubex[57] <= 0 ; cubey[57] <= 0 ;
            cubex[58] <= 0 ; cubey[58] <= 0 ;
            cubex[59] <= 0 ; cubey[59] <= 0 ;
			cubex[60] <= 0 ; cubey[60] <= 0 ;
            cubex[61] <= 0 ; cubey[61] <= 0 ;
            cubex[62] <= 0 ; cubey[62] <= 0 ;
            cubex[63] <= 0 ; cubey[63] <= 0 ;
            cubex[64] <= 0 ; cubey[64] <= 0 ;
            cubex[65] <= 0 ; cubey[65] <= 0 ;
            cubex[66] <= 0 ; cubey[66] <= 0 ;
            cubex[67] <= 0 ; cubey[67] <= 0 ;
            cubex[68] <= 0 ; cubey[68] <= 0 ;
            cubex[69] <= 0 ; cubey[69] <= 0 ;
            cubex[70] <= 0 ; cubey[70] <= 0 ;
            cubex[71] <= 0 ; cubey[71] <= 0 ;
            cubex[72] <= 0 ; cubey[72] <= 0 ;
            cubex[73] <= 0 ; cubey[73] <= 0 ;
            cubex[74] <= 0 ; cubey[74] <= 0 ;
            cubex[75] <= 0 ; cubey[75] <= 0 ;
            cubex[76] <= 0 ; cubey[76] <= 0 ;
            cubex[77] <= 0 ; cubey[77] <= 0 ;
            cubex[78] <= 0 ; cubey[78] <= 0 ;
            cubex[79] <= 0 ; cubey[79] <= 0 ;
            cubex[80] <= 0 ; cubey[80] <= 0 ;
            cubex[81] <= 0 ; cubey[81] <= 0 ;
            cubex[82] <= 0 ; cubey[82] <= 0 ;
            cubex[83] <= 0 ; cubey[83] <= 0 ;
            cubex[84] <= 0 ; cubey[84] <= 0 ;
            cubex[85] <= 0 ; cubey[85] <= 0 ;
            cubex[86] <= 0 ; cubey[86] <= 0 ;
            cubex[87] <= 0 ; cubey[87] <= 0 ;
            cubex[88] <= 0 ; cubey[88] <= 0 ;
            cubex[89] <= 0 ; cubey[89] <= 0 ;
            cubex[90] <= 0 ; cubey[90] <= 0 ;
            cubex[91] <= 0 ; cubey[91] <= 0 ;
            cubex[92] <= 0 ; cubey[92] <= 0 ;
            cubex[93] <= 0 ; cubey[93] <= 0 ;
            cubex[94] <= 0 ; cubey[94] <= 0 ;
            cubex[95] <= 0 ; cubey[95] <= 0 ;
            cubex[96] <= 0 ; cubey[96] <= 0 ;
            cubex[97] <= 0 ; cubey[97] <= 0 ;
            cubex[98] <= 0 ; cubey[98] <= 0 ;
            cubex[99] <= 0 ; cubey[99] <= 0 ;                           
        end
        else if(status == PLAY) begin
            cnt <= cnt + 1;
            if(cnt > CNT_MAX) begin  
                cnt <= 0;
				if(~stop)begin
					if((c_state_snake == UP && cubey[0] == 1)|(c_state_snake == DOWN && cubey[0] == 28)|(c_state_snake == LEFT && cubex[0] == 1)|(c_state_snake == RIGHT && cubex[0] == 35))
						hitwall <= 1; 
					else if((cubey[0] == cubey[1]  && cubex[0] == cubex[1]  && exist[1]  == 1)|
							(cubey[0] == cubey[2]  && cubex[0] == cubex[2]  && exist[2]  == 1)|
							(cubey[0] == cubey[3]  && cubex[0] == cubex[3]  && exist[3]  == 1)|
							(cubey[0] == cubey[4]  && cubex[0] == cubex[4]  && exist[4]  == 1)|
							(cubey[0] == cubey[5]  && cubex[0] == cubex[5]  && exist[5]  == 1)|
							(cubey[0] == cubey[6]  && cubex[0] == cubex[6]  && exist[6]  == 1)|
							(cubey[0] == cubey[7]  && cubex[0] == cubex[7]  && exist[7]  == 1)|
							(cubey[0] == cubey[8]  && cubex[0] == cubex[8]  && exist[8]  == 1)|
							(cubey[0] == cubey[9]  && cubex[0] == cubex[9]  && exist[9]  == 1)|
							(cubey[0] == cubey[10] && cubex[0] == cubex[10] && exist[10] == 1)|
							(cubey[0] == cubey[11] && cubex[0] == cubex[11] && exist[11] == 1)|
							(cubey[0] == cubey[12] && cubex[0] == cubex[12] && exist[12] == 1)|
							(cubey[0] == cubey[13] && cubex[0] == cubex[13] && exist[13] == 1)|
							(cubey[0] == cubey[14] && cubex[0] == cubex[14] && exist[14] == 1)|
							(cubey[0] == cubey[15] && cubex[0] == cubex[15] && exist[15] == 1)|
							(cubey[0] == cubey[16] && cubex[0] == cubex[16] && exist[16] == 1)|
							(cubey[0] == cubey[17] && cubex[0] == cubex[17] && exist[17] == 1)|
							(cubey[0] == cubey[18] && cubex[0] == cubex[18] && exist[18] == 1)|
							(cubey[0] == cubey[19] && cubex[0] == cubex[19] && exist[19] == 1)|
							(cubey[0] == cubey[20] && cubex[0] == cubex[20] && exist[20] == 1)|
							(cubey[0] == cubey[21] && cubex[0] == cubex[21] && exist[21] == 1)|
							(cubey[0] == cubey[22] && cubex[0] == cubex[22] && exist[22] == 1)|
							(cubey[0] == cubey[23] && cubex[0] == cubex[23] && exist[23] == 1)|
							(cubey[0] == cubey[24] && cubex[0] == cubex[24] && exist[24] == 1)|
							(cubey[0] == cubey[25] && cubex[0] == cubex[25] && exist[25] == 1)|
							(cubey[0] == cubey[26] && cubex[0] == cubex[26] && exist[26] == 1)|
							(cubey[0] == cubey[27] && cubex[0] == cubex[27] && exist[27] == 1)|
							(cubey[0] == cubey[28] && cubex[0] == cubex[28] && exist[28] == 1)|
							(cubey[0] == cubey[29] && cubex[0] == cubex[29] && exist[29] == 1)|
							(cubey[0] == cubey[30] && cubex[0] == cubex[30] && exist[30] == 1)|
							(cubey[0] == cubey[31] && cubex[0] == cubex[31] && exist[31] == 1)|
							(cubey[0] == cubey[32] && cubex[0] == cubex[32] && exist[32] == 1)|
							(cubey[0] == cubey[33] && cubex[0] == cubex[33] && exist[33] == 1)|
							(cubey[0] == cubey[34] && cubex[0] == cubex[34] && exist[34] == 1)|
							(cubey[0] == cubey[35] && cubex[0] == cubex[35] && exist[35] == 1)|
							(cubey[0] == cubey[36] && cubex[0] == cubex[36] && exist[36] == 1)|
							(cubey[0] == cubey[37] && cubex[0] == cubex[37] && exist[37] == 1)|
							(cubey[0] == cubey[38] && cubex[0] == cubex[38] && exist[38] == 1)|
							(cubey[0] == cubey[39] && cubex[0] == cubex[39] && exist[39] == 1)|
							(cubey[0] == cubey[40] && cubex[0] == cubex[40] && exist[40] == 1)|
							(cubey[0] == cubey[41] && cubex[0] == cubex[41] && exist[41] == 1)|
							(cubey[0] == cubey[42] && cubex[0] == cubex[42] && exist[42] == 1)|
							(cubey[0] == cubey[43] && cubex[0] == cubex[43] && exist[43] == 1)|
							(cubey[0] == cubey[44] && cubex[0] == cubex[44] && exist[44] == 1)|
							(cubey[0] == cubey[45] && cubex[0] == cubex[45] && exist[45] == 1)|
							(cubey[0] == cubey[46] && cubex[0] == cubex[46] && exist[46] == 1)|
							(cubey[0] == cubey[47] && cubex[0] == cubex[47] && exist[47] == 1)|
							(cubey[0] == cubey[48] && cubex[0] == cubex[48] && exist[48] == 1)|
							(cubey[0] == cubey[49] && cubex[0] == cubex[49] && exist[49] == 1)|
							(cubey[0] == cubey[50] && cubex[0] == cubex[50] && exist[50] == 1)|
							(cubey[0] == cubey[51] && cubex[0] == cubex[51] && exist[51] == 1)|
							(cubey[0] == cubey[52] && cubex[0] == cubex[52] && exist[52] == 1)|
							(cubey[0] == cubey[53] && cubex[0] == cubex[53] && exist[53] == 1)|
							(cubey[0] == cubey[54] && cubex[0] == cubex[54] && exist[54] == 1)|
							(cubey[0] == cubey[55] && cubex[0] == cubex[55] && exist[55] == 1)|
							(cubey[0] == cubey[56] && cubex[0] == cubex[56] && exist[56] == 1)|
							(cubey[0] == cubey[57] && cubex[0] == cubex[57] && exist[57] == 1)|
							(cubey[0] == cubey[58] && cubex[0] == cubex[58] && exist[58] == 1)|
							(cubey[0] == cubey[59] && cubex[0] == cubex[59] && exist[59] == 1)|
							(cubey[0] == cubey[60] && cubex[0] == cubex[60] && exist[60] == 1)|
							(cubey[0] == cubey[61] && cubex[0] == cubex[61] && exist[61] == 1)|
							(cubey[0] == cubey[62] && cubex[0] == cubex[62] && exist[62] == 1)|
							(cubey[0] == cubey[63] && cubex[0] == cubex[63] && exist[63] == 1)|
							(cubey[0] == cubey[64] && cubex[0] == cubex[64] && exist[64] == 1)|
							(cubey[0] == cubey[65] && cubex[0] == cubex[65] && exist[65] == 1)|
							(cubey[0] == cubey[66] && cubex[0] == cubex[66] && exist[66] == 1)|
							(cubey[0] == cubey[67] && cubex[0] == cubex[67] && exist[67] == 1)|
							(cubey[0] == cubey[68] && cubex[0] == cubex[68] && exist[68] == 1)|
							(cubey[0] == cubey[69] && cubex[0] == cubex[69] && exist[69] == 1)|
							(cubey[0] == cubey[70] && cubex[0] == cubex[70] && exist[70] == 1)|
							(cubey[0] == cubey[71] && cubex[0] == cubex[71] && exist[71] == 1)|
							(cubey[0] == cubey[72] && cubex[0] == cubex[72] && exist[72] == 1)|
							(cubey[0] == cubey[73] && cubex[0] == cubex[73] && exist[73] == 1)|
							(cubey[0] == cubey[74] && cubex[0] == cubex[74] && exist[74] == 1)|
							(cubey[0] == cubey[75] && cubex[0] == cubex[75] && exist[75] == 1)|
							(cubey[0] == cubey[76] && cubex[0] == cubex[76] && exist[76] == 1)|
							(cubey[0] == cubey[77] && cubex[0] == cubex[77] && exist[77] == 1)|
							(cubey[0] == cubey[78] && cubex[0] == cubex[78] && exist[78] == 1)|
							(cubey[0] == cubey[79] && cubex[0] == cubex[79] && exist[79] == 1)|
							(cubey[0] == cubey[80] && cubex[0] == cubex[80] && exist[80] == 1)|
							(cubey[0] == cubey[81] && cubex[0] == cubex[81] && exist[81] == 1)|
							(cubey[0] == cubey[82] && cubex[0] == cubex[82] && exist[82] == 1)|
							(cubey[0] == cubey[83] && cubex[0] == cubex[83] && exist[83] == 1)|
							(cubey[0] == cubey[84] && cubex[0] == cubex[84] && exist[84] == 1)|
							(cubey[0] == cubey[85] && cubex[0] == cubex[85] && exist[85] == 1)|
							(cubey[0] == cubey[86] && cubex[0] == cubex[86] && exist[86] == 1)|
							(cubey[0] == cubey[87] && cubex[0] == cubex[87] && exist[87] == 1)|
							(cubey[0] == cubey[88] && cubex[0] == cubex[88] && exist[88] == 1)|
							(cubey[0] == cubey[89] && cubex[0] == cubex[89] && exist[89] == 1)|
							(cubey[0] == cubey[90] && cubex[0] == cubex[90] && exist[90] == 1)|
							(cubey[0] == cubey[91] && cubex[0] == cubex[91] && exist[91] == 1)|
							(cubey[0] == cubey[92] && cubex[0] == cubex[92] && exist[92] == 1)|
							(cubey[0] == cubey[93] && cubex[0] == cubex[93] && exist[93] == 1)|
							(cubey[0] == cubey[94] && cubex[0] == cubex[94] && exist[94] == 1)|
							(cubey[0] == cubey[95] && cubex[0] == cubex[95] && exist[95] == 1)|
							(cubey[0] == cubey[96] && cubex[0] == cubex[96] && exist[96] == 1)|
							(cubey[0] == cubey[97] && cubex[0] == cubex[97] && exist[97] == 1)|
							(cubey[0] == cubey[98] && cubex[0] == cubex[98] && exist[98] == 1)|
							(cubey[0] == cubey[99] && cubex[0] == cubex[99] && exist[99] == 1))
						hitbody <= 1;
					else begin
						// 身体节点移动
						cubex[99] <= cubex[98]; cubey[99] <= cubey[98];
						cubex[98] <= cubex[97]; cubey[98] <= cubey[97];
						cubex[97] <= cubex[96]; cubey[97] <= cubey[96];
						cubex[96] <= cubex[95]; cubey[96] <= cubey[95];
						cubex[95] <= cubex[94]; cubey[95] <= cubey[94];
						cubex[94] <= cubex[93]; cubey[94] <= cubey[93];
						cubex[93] <= cubex[92]; cubey[93] <= cubey[92];
						cubex[92] <= cubex[91]; cubey[92] <= cubey[91];
						cubex[91] <= cubex[90]; cubey[91] <= cubey[90];
						cubex[90] <= cubex[89]; cubey[90] <= cubey[89];
						cubex[89] <= cubex[88]; cubey[89] <= cubey[88];
						cubex[88] <= cubex[87]; cubey[88] <= cubey[87];
						cubex[87] <= cubex[86]; cubey[87] <= cubey[86];
						cubex[86] <= cubex[85]; cubey[86] <= cubey[85];
						cubex[85] <= cubex[84]; cubey[85] <= cubey[84];
						cubex[84] <= cubex[83]; cubey[84] <= cubey[83];
						cubex[83] <= cubex[82]; cubey[83] <= cubey[82];
						cubex[82] <= cubex[81]; cubey[82] <= cubey[81];
						cubex[81] <= cubex[80]; cubey[81] <= cubey[80];
						cubex[80] <= cubex[79]; cubey[80] <= cubey[79];
						cubex[79] <= cubex[78]; cubey[79] <= cubey[78];
						cubex[78] <= cubex[77]; cubey[78] <= cubey[77];
						cubex[77] <= cubex[76]; cubey[77] <= cubey[76];
						cubex[76] <= cubex[75]; cubey[76] <= cubey[75];
						cubex[75] <= cubex[74]; cubey[75] <= cubey[74];
						cubex[74] <= cubex[73]; cubey[74] <= cubey[73];
						cubex[73] <= cubex[72]; cubey[73] <= cubey[72];
						cubex[72] <= cubex[71]; cubey[72] <= cubey[71];
						cubex[71] <= cubex[70]; cubey[71] <= cubey[70];
						cubex[70] <= cubex[69]; cubey[70] <= cubey[69];
						cubex[69] <= cubex[68]; cubey[69] <= cubey[68];
						cubex[68] <= cubex[67]; cubey[68] <= cubey[67];
						cubex[67] <= cubex[66]; cubey[67] <= cubey[66];
						cubex[66] <= cubex[65]; cubey[66] <= cubey[65];
						cubex[65] <= cubex[64]; cubey[65] <= cubey[64];
						cubex[64] <= cubex[63]; cubey[64] <= cubey[63];
						cubex[63] <= cubex[62]; cubey[63] <= cubey[62];
						cubex[62] <= cubex[61]; cubey[62] <= cubey[61];
						cubex[61] <= cubex[60]; cubey[61] <= cubey[60];
						cubex[60] <= cubex[59]; cubey[60] <= cubey[59];
						cubex[59] <= cubex[58]; cubey[59] <= cubey[58];
						cubex[58] <= cubex[57]; cubey[58] <= cubey[57];
						cubex[57] <= cubex[56]; cubey[57] <= cubey[56];
						cubex[56] <= cubex[55]; cubey[56] <= cubey[55];
						cubex[55] <= cubex[54]; cubey[55] <= cubey[54];
						cubex[54] <= cubex[53]; cubey[54] <= cubey[53];
						cubex[53] <= cubex[52]; cubey[53] <= cubey[52];
						cubex[52] <= cubex[51]; cubey[52] <= cubey[51];
						cubex[51] <= cubex[50]; cubey[51] <= cubey[50];
						cubex[50] <= cubex[49]; cubey[50] <= cubey[49];
						cubex[49] <= cubex[48]; cubey[49] <= cubey[48];
						cubex[48] <= cubex[47]; cubey[48] <= cubey[47];
						cubex[47] <= cubex[46]; cubey[47] <= cubey[46];
						cubex[46] <= cubex[45]; cubey[46] <= cubey[45];
						cubex[45] <= cubex[44]; cubey[45] <= cubey[44];
						cubex[44] <= cubex[43]; cubey[44] <= cubey[43];
						cubex[43] <= cubex[42]; cubey[43] <= cubey[42];
						cubex[42] <= cubex[41]; cubey[42] <= cubey[41];
						cubex[41] <= cubex[40]; cubey[41] <= cubey[40];
						cubex[40] <= cubex[39]; cubey[40] <= cubey[39];
						cubex[39] <= cubex[38]; cubey[39] <= cubey[38];
						cubex[38] <= cubex[37]; cubey[38] <= cubey[37];
						cubex[37] <= cubex[36]; cubey[37] <= cubey[36];
						cubex[36] <= cubex[35]; cubey[36] <= cubey[35];
						cubex[35] <= cubex[34]; cubey[35] <= cubey[34];
						cubex[34] <= cubex[33]; cubey[34] <= cubey[33];
						cubex[33] <= cubex[32]; cubey[33] <= cubey[32];
						cubex[32] <= cubex[31]; cubey[32] <= cubey[31];
						cubex[31] <= cubex[30]; cubey[31] <= cubey[30];
						cubex[30] <= cubex[29]; cubey[30] <= cubey[29];
						cubex[29] <= cubex[28]; cubey[29] <= cubey[28];
						cubex[28] <= cubex[27]; cubey[28] <= cubey[27];
						cubex[27] <= cubex[26]; cubey[27] <= cubey[26];
						cubex[26] <= cubex[25]; cubey[26] <= cubey[25];
						cubex[25] <= cubex[24]; cubey[25] <= cubey[24];
						cubex[24] <= cubex[23]; cubey[24] <= cubey[23];
						cubex[23] <= cubex[22]; cubey[23] <= cubey[22];
						cubex[22] <= cubex[21]; cubey[22] <= cubey[21];
						cubex[21] <= cubex[20]; cubey[21] <= cubey[20];
						cubex[20] <= cubex[19]; cubey[20] <= cubey[19];
						cubex[19] <= cubex[18]; cubey[19] <= cubey[18];
						cubex[18] <= cubex[17]; cubey[18] <= cubey[17];
						cubex[17] <= cubex[16]; cubey[17] <= cubey[16];
						cubex[16] <= cubex[15]; cubey[16] <= cubey[15];
						cubex[15] <= cubex[14]; cubey[15] <= cubey[14];
						cubex[14] <= cubex[13]; cubey[14] <= cubey[13];
						cubex[13] <= cubex[12]; cubey[13] <= cubey[12];
						cubex[12] <= cubex[11]; cubey[12] <= cubey[11];
						cubex[11] <= cubex[10]; cubey[11] <= cubey[10];
						cubex[10] <= cubex[9];  cubey[10] <= cubey[9];
						cubex[9]  <= cubex[8];  cubey[9]  <= cubey[8];
						cubex[8]  <= cubex[7];  cubey[8]  <= cubey[7];
						cubex[7]  <= cubex[6];  cubey[7]  <= cubey[6];
						cubex[6]  <= cubex[5];  cubey[6]  <= cubey[5];
						cubex[5]  <= cubex[4];  cubey[5]  <= cubey[4];
						cubex[4]  <= cubex[3];  cubey[4]  <= cubey[3];
						cubex[3]  <= cubex[2];  cubey[3]  <= cubey[2];
						cubex[2]  <= cubex[1];  cubey[2]  <= cubey[1];
						cubex[1]  <= cubex[0];  cubey[1]  <= cubey[0];      
						case(c_state_snake)                             
								UP: begin
									cubey[0] <= cubey[0] - 1;
								end
								DOWN: begin
									cubey[0] <= cubey[0] + 1;
								end
								LEFT: begin
									cubex[0] <= cubex[0] - 1;                                          
								end
								RIGHT: begin
									cubex[0] <= cubex[0] + 1;
								end
						endcase                
					end
				end
            end
        end
    end

	always @(posedge clk or negedge rst_n) begin    
        if(~rst_n) begin
            exist <= 50'd7;//'b111
            length <= 3;
            addstate <= 0;
        end  
        else if (status == RESTART) begin
            exist <= 50'd7;
            length <= 3;
            addstate <= 0;
        end
        else begin            
            case(addstate)
                0:begin
                    if(add) begin
                        length <= length + 1;
                        exist[length] <= 1;
                        addstate <= 1;
                    end                        
                end
                1:begin
                    if(~add)
                        addstate <= 0;                
                end
            endcase
        end
    end

    always @(posx or posy ) begin                
        if(posx >= 0 && posx < 640 && posy >= 0 && posy < 480) begin
            if(posx[9:4] == 0 | (posy[9:4] == 0&&posx[9:4] <= 36) | posx[9:4] == 36 | (posy[9:4] == 29&&posx[9:4] <= 36))
                snake = W;
            else if(posx[9:4] == cubex[0] && posy[9:4] == cubey[0] && exist[0] == 1) 
                snake = (die == 1) ? H : N;
            else if((posx[9:4] == cubex[1]  && posy[9:4] == cubey[1]  && exist[1] == 1)|
					(posx[9:4] == cubex[2]  && posy[9:4] == cubey[2]  && exist[2] == 1)|
					(posx[9:4] == cubex[3]  && posy[9:4] == cubey[3]  && exist[3] == 1)|
					(posx[9:4] == cubex[4]  && posy[9:4] == cubey[4]  && exist[4] == 1)|
					(posx[9:4] == cubex[5]  && posy[9:4] == cubey[5]  && exist[5] == 1)|
					(posx[9:4] == cubex[6]  && posy[9:4] == cubey[6]  && exist[6] == 1)|
					(posx[9:4] == cubex[7]  && posy[9:4] == cubey[7]  && exist[7] == 1)|
					(posx[9:4] == cubex[8]  && posy[9:4] == cubey[8]  && exist[8] == 1)|
					(posx[9:4] == cubex[9]  && posy[9:4] == cubey[9]  && exist[9] == 1)|
					(posx[9:4] == cubex[10] && posy[9:4] == cubey[10] && exist[10] == 1)|
					(posx[9:4] == cubex[11] && posy[9:4] == cubey[11] && exist[11] == 1)|
					(posx[9:4] == cubex[12] && posy[9:4] == cubey[12] && exist[12] == 1)|
					(posx[9:4] == cubex[13] && posy[9:4] == cubey[13] && exist[13] == 1)|
					(posx[9:4] == cubex[14] && posy[9:4] == cubey[14] && exist[14] == 1)|
					(posx[9:4] == cubex[15] && posy[9:4] == cubey[15] && exist[15] == 1)|
					(posx[9:4] == cubex[16] && posy[9:4] == cubey[16] && exist[16] == 1)|
					(posx[9:4] == cubex[17] && posy[9:4] == cubey[17] && exist[17] == 1)|
					(posx[9:4] == cubex[18] && posy[9:4] == cubey[18] && exist[18] == 1)|
					(posx[9:4] == cubex[19] && posy[9:4] == cubey[19] && exist[19] == 1)|
					(posx[9:4] == cubex[20] && posy[9:4] == cubey[20] && exist[20] == 1)|
					(posx[9:4] == cubex[21] && posy[9:4] == cubey[21] && exist[21] == 1)|
					(posx[9:4] == cubex[22] && posy[9:4] == cubey[22] && exist[22] == 1)|
					(posx[9:4] == cubex[23] && posy[9:4] == cubey[23] && exist[23] == 1)|
					(posx[9:4] == cubex[24] && posy[9:4] == cubey[24] && exist[24] == 1)|
					(posx[9:4] == cubex[25] && posy[9:4] == cubey[25] && exist[25] == 1)|
					(posx[9:4] == cubex[26] && posy[9:4] == cubey[26] && exist[26] == 1)|
					(posx[9:4] == cubex[27] && posy[9:4] == cubey[27] && exist[27] == 1)|
					(posx[9:4] == cubex[28] && posy[9:4] == cubey[28] && exist[28] == 1)|
					(posx[9:4] == cubex[29] && posy[9:4] == cubey[29] && exist[29] == 1)|
					(posx[9:4] == cubex[30] && posy[9:4] == cubey[30] && exist[30] == 1)|
					(posx[9:4] == cubex[31] && posy[9:4] == cubey[31] && exist[31] == 1)|
					(posx[9:4] == cubex[32] && posy[9:4] == cubey[32] && exist[32] == 1)|
					(posx[9:4] == cubex[33] && posy[9:4] == cubey[33] && exist[33] == 1)|
					(posx[9:4] == cubex[34] && posy[9:4] == cubey[34] && exist[34] == 1)|
					(posx[9:4] == cubex[35] && posy[9:4] == cubey[35] && exist[35] == 1)|
					(posx[9:4] == cubex[36] && posy[9:4] == cubey[36] && exist[36] == 1)|
					(posx[9:4] == cubex[37] && posy[9:4] == cubey[37] && exist[37] == 1)|
					(posx[9:4] == cubex[38] && posy[9:4] == cubey[38] && exist[38] == 1)|
					(posx[9:4] == cubex[39] && posy[9:4] == cubey[39] && exist[39] == 1)|
					(posx[9:4] == cubex[40] && posy[9:4] == cubey[40] && exist[40] == 1)|
					(posx[9:4] == cubex[41] && posy[9:4] == cubey[41] && exist[41] == 1)|
					(posx[9:4] == cubex[42] && posy[9:4] == cubey[42] && exist[42] == 1)|
					(posx[9:4] == cubex[43] && posy[9:4] == cubey[43] && exist[43] == 1)|
					(posx[9:4] == cubex[44] && posy[9:4] == cubey[44] && exist[44] == 1)|
					(posx[9:4] == cubex[45] && posy[9:4] == cubey[45] && exist[45] == 1)|
					(posx[9:4] == cubex[46] && posy[9:4] == cubey[46] && exist[46] == 1)|
					(posx[9:4] == cubex[47] && posy[9:4] == cubey[47] && exist[47] == 1)|
					(posx[9:4] == cubex[48] && posy[9:4] == cubey[48] && exist[48] == 1)|
					(posx[9:4] == cubex[49] && posy[9:4] == cubey[49] && exist[49] == 1)|
					(posx[9:4] == cubex[50] && posy[9:4] == cubey[50] && exist[50] == 1)|
					(posx[9:4] == cubex[51] && posy[9:4] == cubey[51] && exist[51] == 1)|
					(posx[9:4] == cubex[52] && posy[9:4] == cubey[52] && exist[52] == 1)|
					(posx[9:4] == cubex[53] && posy[9:4] == cubey[53] && exist[53] == 1)|
					(posx[9:4] == cubex[54] && posy[9:4] == cubey[54] && exist[54] == 1)|
					(posx[9:4] == cubex[55] && posy[9:4] == cubey[55] && exist[55] == 1)|
					(posx[9:4] == cubex[56] && posy[9:4] == cubey[56] && exist[56] == 1)|
					(posx[9:4] == cubex[57] && posy[9:4] == cubey[57] && exist[57] == 1)|
					(posx[9:4] == cubex[58] && posy[9:4] == cubey[58] && exist[58] == 1)|
					(posx[9:4] == cubex[59] && posy[9:4] == cubey[59] && exist[59] == 1)|
					(posx[9:4] == cubex[60] && posy[9:4] == cubey[60] && exist[60] == 1)|
					(posx[9:4] == cubex[61] && posy[9:4] == cubey[61] && exist[61] == 1)|
					(posx[9:4] == cubex[62] && posy[9:4] == cubey[62] && exist[62] == 1)|
					(posx[9:4] == cubex[63] && posy[9:4] == cubey[63] && exist[63] == 1)|
					(posx[9:4] == cubex[64] && posy[9:4] == cubey[64] && exist[64] == 1)|
					(posx[9:4] == cubex[65] && posy[9:4] == cubey[65] && exist[65] == 1)|
					(posx[9:4] == cubex[66] && posy[9:4] == cubey[66] && exist[66] == 1)|
					(posx[9:4] == cubex[67] && posy[9:4] == cubey[67] && exist[67] == 1)|
					(posx[9:4] == cubex[68] && posy[9:4] == cubey[68] && exist[68] == 1)|
					(posx[9:4] == cubex[69] && posy[9:4] == cubey[69] && exist[69] == 1)|
					(posx[9:4] == cubex[70] && posy[9:4] == cubey[70] && exist[70] == 1)|
					(posx[9:4] == cubex[71] && posy[9:4] == cubey[71] && exist[71] == 1)|
					(posx[9:4] == cubex[72] && posy[9:4] == cubey[72] && exist[72] == 1)|
					(posx[9:4] == cubex[73] && posy[9:4] == cubey[73] && exist[73] == 1)|
					(posx[9:4] == cubex[74] && posy[9:4] == cubey[74] && exist[74] == 1)|
					(posx[9:4] == cubex[75] && posy[9:4] == cubey[75] && exist[75] == 1)|
					(posx[9:4] == cubex[76] && posy[9:4] == cubey[76] && exist[76] == 1)|
					(posx[9:4] == cubex[77] && posy[9:4] == cubey[77] && exist[77] == 1)|
					(posx[9:4] == cubex[78] && posy[9:4] == cubey[78] && exist[78] == 1)|
					(posx[9:4] == cubex[79] && posy[9:4] == cubey[79] && exist[79] == 1)|
					(posx[9:4] == cubex[80] && posy[9:4] == cubey[80] && exist[80] == 1)|
					(posx[9:4] == cubex[81] && posy[9:4] == cubey[81] && exist[81] == 1)|
					(posx[9:4] == cubex[82] && posy[9:4] == cubey[82] && exist[82] == 1)|
					(posx[9:4] == cubex[83] && posy[9:4] == cubey[83] && exist[83] == 1)|
					(posx[9:4] == cubex[84] && posy[9:4] == cubey[84] && exist[84] == 1)|
					(posx[9:4] == cubex[85] && posy[9:4] == cubey[85] && exist[85] == 1)|
					(posx[9:4] == cubex[86] && posy[9:4] == cubey[86] && exist[86] == 1)|
					(posx[9:4] == cubex[87] && posy[9:4] == cubey[87] && exist[87] == 1)|
					(posx[9:4] == cubex[88] && posy[9:4] == cubey[88] && exist[88] == 1)|
					(posx[9:4] == cubex[89] && posy[9:4] == cubey[89] && exist[89] == 1)|
					(posx[9:4] == cubex[90] && posy[9:4] == cubey[90] && exist[90] == 1)|
					(posx[9:4] == cubex[91] && posy[9:4] == cubey[91] && exist[91] == 1)|
					(posx[9:4] == cubex[92] && posy[9:4] == cubey[92] && exist[92] == 1)|
					(posx[9:4] == cubex[93] && posy[9:4] == cubey[93] && exist[93] == 1)|
					(posx[9:4] == cubex[94] && posy[9:4] == cubey[94] && exist[94] == 1)|
					(posx[9:4] == cubex[95] && posy[9:4] == cubey[95] && exist[95] == 1)|
					(posx[9:4] == cubex[96] && posy[9:4] == cubey[96] && exist[96] == 1)|
					(posx[9:4] == cubex[97] && posy[9:4] == cubey[97] && exist[97] == 1)|
					(posx[9:4] == cubex[98] && posy[9:4] == cubey[98] && exist[98] == 1)|
					(posx[9:4] == cubex[99] && posy[9:4] == cubey[99] && exist[99] == 1))
                snake = (die == 1) ? B : N;
            else snake = N;
        end
    end

endmodule