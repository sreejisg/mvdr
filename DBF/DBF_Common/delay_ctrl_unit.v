`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:12:00 01/30/2018 
// Design Name: 
// Module Name:    delay_ctrl_unit 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module delay_ctrl_unit #(`include "param.h"
)(
		input clk,
        input rst_n,
        input tx_en,
//        input flag,
//        input dbg_flag,
        output reg dbf_start,
        output reg [ADDR_WD - 1 : 0] lut_addr,
        output reg [7:0] p_scan_line_cnt,
        output reg frame_start_flag,
        output reg frame_end_flag
    );
	 

 
  //STATE binary Encoding						
    parameter INIT_STATE = 3'd0;
    parameter SCAN_COUNT = 3'd1;                        
    parameter FRAME_START = 3'd2;
    parameter LUT_GEN_STATE = 3'd3;
    parameter FRAME_END = 3'd4;
    parameter WAIT = 3'd5;
    //Wires
    reg [2:0] state;
    reg [2:0] next_state;
    reg [SAMPLE_COUNT-1:0] present_sample_count,next_sample_count;
    //reg [5:0] p_scan_line_cnt;
    reg [ADDR_WD -1 : 0] n_lut_addr;
    reg n_dbf_start;
    reg [7:0] nxt_scan_line_cnt;
    reg [5:0]  nxt_dyn_range_cnt,p_dyn_range_cnt;
    reg n_frame_start;
    reg n_frame_end;
    
    reg tx_en_start;
    reg tx_en_Q;
    wire rx_start = ~tx_en & tx_en_Q;
    always @(posedge clk or negedge rst_n)
    begin
     if (!rst_n)
       tx_en_Q <= 1'b0;
     else
       tx_en_Q <= tx_en;
    end
//Combinatorial state design of fsm
always@(*)
begin
	case(state)
		INIT_STATE:begin
						if(rx_start == 1'b1)
							next_state = SCAN_COUNT;
						else
							next_state = INIT_STATE;
					end
		SCAN_COUNT:begin
						next_state = FRAME_START;
					end
		FRAME_START: begin 
						next_state = LUT_GEN_STATE;
					end
		LUT_GEN_STATE:begin
						if(tx_en == 1'b1)
							next_state = FRAME_END;
						else
							next_state = LUT_GEN_STATE;
					end
		FRAME_END:begin
						next_state = WAIT;
					end
				WAIT:begin
						if(tx_en == 1'b0)
							next_state = SCAN_COUNT;
						else
							next_state = WAIT;
					end
		default: next_state = INIT_STATE;
	endcase
end	 
 //combinatorial output design of fsm
  always@(*)
  begin
      case(state)
          INIT_STATE:begin
                          next_sample_count = 20'd0;
                          nxt_dyn_range_cnt = 6'd0;
                          nxt_scan_line_cnt = 6'd0;
                          n_dbf_start = 0;
                          n_frame_start = 0;
                          n_frame_end = 0;
                          n_lut_addr = 12'd4095;
                      end
          SCAN_COUNT:begin
                          n_frame_start = 0;
                          n_frame_end = 0;
                          n_dbf_start = 1;
                          next_sample_count = present_sample_count + 20'd1;
                          n_lut_addr = 0;
                          nxt_dyn_range_cnt = 0;
                          if(p_scan_line_cnt <= 6'd60)
                              nxt_scan_line_cnt = p_scan_line_cnt + 6'd1;
                          else
                              nxt_scan_line_cnt = 1;                                
                      end
          FRAME_START:begin        
                          next_sample_count = present_sample_count + 20'd1;                        
                          nxt_scan_line_cnt = p_scan_line_cnt;
                          n_frame_end = 0;
                          n_dbf_start = 1;
                          nxt_dyn_range_cnt = 0;
                          n_lut_addr = 0;
                          if(p_scan_line_cnt == 6'd1)
                              n_frame_start = 1;
                          else
                              n_frame_start = 0;
                      end
       LUT_GEN_STATE:begin
                          n_frame_end = 0;
                          n_frame_start = 0;
                          n_dbf_start = 1;
                          next_sample_count = present_sample_count + 20'd1;
                         
                          if(present_sample_count <= SAMPLES_NF)
                          begin
                              nxt_dyn_range_cnt = present_sample_count[M_SAMPLE_COUNT:N_SAMPLE_COUNT];
                              nxt_scan_line_cnt = p_scan_line_cnt;
                              n_lut_addr =  p_dyn_range_cnt+((p_scan_line_cnt - 1) << 6);
                          end
                          else if(present_sample_count > SAMPLES_NF)
                          begin
                              nxt_dyn_range_cnt = p_dyn_range_cnt;
                              nxt_scan_line_cnt = p_scan_line_cnt; 
                              n_lut_addr = lut_addr;                           
                          end
                          else
                          begin
                              nxt_scan_line_cnt = p_scan_line_cnt;
                              nxt_dyn_range_cnt=6'd0;
                              n_lut_addr = lut_addr;       
                          end
                      end
          FRAME_END:begin
                          n_dbf_start = 0;
                          n_frame_start = 0;
                          next_sample_count = 20'd0;
                          nxt_dyn_range_cnt = 6'd0;
                          nxt_scan_line_cnt = p_scan_line_cnt;
                          n_lut_addr = 0;    
                          if(p_scan_line_cnt == 6'd61)
                              n_frame_end = 1;
                          else
                              n_frame_end = 0;                             
                      end
              WAIT:begin
                      n_dbf_start = 0;
                      n_lut_addr = 0;
                      next_sample_count = 20'd0;
                      nxt_dyn_range_cnt = 6'd0;
                      nxt_scan_line_cnt = p_scan_line_cnt;
                      n_frame_end = 0;
                      n_frame_start = 0;
                  end
              default:begin
                          next_sample_count=20'd0;
                          nxt_dyn_range_cnt=6'd0;
                          nxt_scan_line_cnt=6'd0;
                          n_frame_end = 0;
                          n_frame_start = 0;
                          n_dbf_start=1'b0;
                          n_lut_addr = 0;
                      end
      endcase
  end

//Sequential logic of fsm
always@(negedge clk or negedge rst_n)
begin
	if(rst_n == 0)
	begin
		state <= INIT_STATE;
		present_sample_count <= 20'd0;
		p_dyn_range_cnt <= 0;
		p_scan_line_cnt <= 6'd0;
		frame_start_flag <= 0;
		frame_end_flag <= 0;
		lut_addr <= 12'd4095;
		dbf_start <= 0;
	end
	else
	begin
		state <= next_state;
		present_sample_count <= next_sample_count;
		p_scan_line_cnt <= nxt_scan_line_cnt;
		p_dyn_range_cnt <= nxt_dyn_range_cnt;
		frame_start_flag <= n_frame_start;
		frame_end_flag <= n_frame_end;
		lut_addr <= n_lut_addr;
		dbf_start <= n_dbf_start;		
	end
end
endmodule