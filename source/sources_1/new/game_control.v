module game_control(
	input clk,
	input rst_n,
	input hitwall,
    input hitbody,
	input key,
	input [15:0] point,	
	output reg die,
	output reg [1:0]status,
	output reg score_flag 	
); 
	localparam RESTART = 2'b00;
	localparam START = 2'b01;
	localparam PLAY = 2'b10;
	localparam DIE = 2'b11;
	
	reg restart ;  
	reg[31:0]cnt;	
	always@(posedge clk or negedge rst_n)
	begin
		if(~rst_n) begin
			status <= RESTART;
			cnt <= 0;
			die <= 1;
			restart <= 0;
		end
		else begin
			case(status)			
				RESTART:begin           
					if(cnt <= 20) begin
						cnt <= cnt + 1;
						restart <= 1;						
					end
					else begin
						status <= START;
						cnt <= 0;
						restart <= 0;
					end
				end
				START:begin
					if (key)
                        status <= PLAY;
					else 
					    status <= START;
				end
				PLAY:begin
					if(hitwall | hitbody)
					   status <= DIE;
					else if(point[11:8]>=1'd1)
					   status <= DIE;
					else
					   status <= PLAY;
				end					
				DIE:begin
					if(cnt <= 200000000) begin
						cnt <= cnt + 1'b1;
					   if(cnt == 25000000)
					       die <= 0;
					   else if(cnt == 50000000)
					       die <= 1'b1;
					   else if(cnt == 75000000)
					       die <= 1'b0;
					   else if(cnt == 100000000)
					       die <= 1'b1;
					   else if(cnt == 125000000)
					       die <= 1'b0;
					   else if(cnt == 150000000)
					       die <= 1'b1;
				    end 
					else if(key)
						begin
							die <= 1;
							cnt <= 0;
							status <= RESTART;
						end
					
					else
					      status <= DIE;
                    end
			endcase
			
		end
	end

    always@(posedge clk or negedge rst_n)
    begin
    	if(!rst_n) begin
			score_flag <= 1'd0;
    	end
		else if (status == DIE)
		    score_flag <= 1'd1;

	    else
		    score_flag <= 1'd0;
	end
endmodule