`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:18:31 03/09/2016 
// Design Name: 
// Module Name:    dbf_ch6 
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

module dbf_ch6 #(`include "param.h"
)(
 input clk,
 input rst_n,
 input tx_en,
 input start,
 input signed [APO_WD-1:0] apo_din,             //window function value for apodisation 
 input [INPUT_WD-1:0] ch_in,               //input sample
 input [ADDR_WD-1:0] dbf_lut_addr,         //address of coarse and fine delay LUTs( DP RAM)
 input dbf_lut_we,                         // memory read signal
 output reg signed [31:0] dbf_ch_dout6,//dbf output
 output reg dbf_ch_dout6_valid,
 output signed [13:0] w_cd_dout_ch6                   //dbf output valid
     );
	  
wire w_rst_n=~rst_n;
wire signed [INPUT_WD-1:0] w_fifo_out;
wire w_fifo_out_valid;
wire signed [INPUT_WD-1:0] w_cd_dout;
wire w_cd_dout_valid;
wire signed [FD_OUT_WD-1:0] w_fd_dout6;
wire w_fd_dout6_valid;
wire [ADDR_WD-1:0] w_dbf_lut_addr=dbf_lut_addr;
wire w_dbf_lut_we=dbf_lut_we;

//wire signed [46:0] w_dbf_ch_dout6=w_fd_dout6*apo_din;  //APODIZATION 

assign w_cd_dout_ch6 = w_cd_dout;
	
coarse_n_lut6 cd6_uut(
   .clk(clk),
   .rst_n(rst_n),
	.start(start),
   .cd_din(ch_in),
   .lut_addr(w_dbf_lut_addr),
   .lut_we(w_dbf_lut_we),
   .cd_din_valid(~tx_en),
   .cd_dout(w_cd_dout),
   .cd_dout_valid(w_cd_dout_valid)
    );
	 
/*fine_delay_ch_6 fine_delay6_uut6(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(tx_en),
	.start(start),
	.lut_addr(w_dbf_lut_addr),
	.lut_wr_en(w_dbf_lut_we),
   .fine_din(w_cd_dout),
   .fine_din_valid(w_cd_dout_valid),
   .fine_dout(w_fd_dout6),
   .fine_dout_valid(w_fd_dout6_valid)
    );
	 
always @(posedge clk or negedge rst_n)
  begin
    if(rst_n==0)
      begin
        dbf_ch_dout6<=32'd0;
	     dbf_ch_dout6_valid<=1'b0;
	   end
    else
      begin
        if(start)
          begin
            dbf_ch_dout6<=w_dbf_ch_dout6[46:15];
	         dbf_ch_dout6_valid<=1'b1;
	       end
	     else
	       begin
            dbf_ch_dout6<=32'd0;
	         dbf_ch_dout6_valid<=1'b0;
	       end
	   end
  end
*/
endmodule
