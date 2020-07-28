`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:02:10 01/30/2018 
// Design Name: 
// Module Name:    dbf_ch32 
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
`include"define.v"
module dbf_ch32 #(`include "param.h"
)(
 input clk,                             //clock of 40 MHZ freq.
 input rst_n,                           //active low reset
 input start,                           //start signal for beamforming
 input tx_en, 
 input [INPUT_WD-1:0] ch_in,               //input sample
 input signed [APO_WD-1:0] apo_din,             //window function value for apodization 
 input [ADDR_WD-1:0] dbf_lut_addr,         //address of coarse and fine delay LUTs( DP RAM)
 input dbf_lut_we,                         // memory read signal
 output reg signed [31:0] dbf_ch_dout32,//dbf channel output
 output reg dbf_ch_dout32_valid,
 output signed [13:0] w_cd_dout_ch32                  //dbf channel output valid
     );
	  
wire w_rst_n=~rst_n;
wire signed [INPUT_WD-1:0] w_fifo_out;
wire w_fifo_out_valid;
wire signed [INPUT_WD-1:0] w_cd_dout;
wire w_cd_dout_valid;
wire signed [FD_OUT_WD-1:0] w_fd_dout;
wire w_fd_dout_valid;
wire [ADDR_WD-1:0] w_dbf_lut_addr=dbf_lut_addr;
wire w_dbf_lut_we=dbf_lut_we;

wire signed [46:0] w_dbf_ch_dout32=w_fd_dout*apo_din;  //APODIZATION 

assign w_cd_dout_ch32 = w_cd_dout;

//COARSE DELAY UNIT
coarse_n_lut32 cd32_uut(
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
 //FINE DELAY UNIT	 
 
 
/*fine_delay_ch32 fine_delay_uut32(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(tx_en),
	.start(start),
	.lut_addr(w_dbf_lut_addr),
	.lut_wr_en(w_dbf_lut_we),
   .fine_din(w_cd_dout),
   .fine_din_valid(w_cd_dout_valid),
   .fine_dout(w_fd_dout),
   .fine_dout_valid(w_fd_dout_valid)
    );

always @(posedge clk or negedge rst_n)
  begin
    if(rst_n==0)
      begin
        dbf_ch_dout32<=32'd0;
	     dbf_ch_dout32_valid<=1'b0;
	   end
    else
      begin
        if(start)
          begin
            dbf_ch_dout32<=w_dbf_ch_dout32[46:15];
	         dbf_ch_dout32_valid<=1'b1;
	       end
	     else
	       begin
            dbf_ch_dout32<=32'd0;
	         dbf_ch_dout32_valid<=1'b0;
	       end
	   end
  end
 */

endmodule
