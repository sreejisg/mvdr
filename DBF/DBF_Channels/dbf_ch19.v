`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:17:18 03/08/2016 
// Design Name: 
// Module Name:    dbf_ch19 
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

module dbf_ch19 #(`include "param.h"
)(
 input clk,
 input rst_n,
 input tx_en,
 input start,
 input [INPUT_WD-1:0] ch_in,               //input sample
 input signed [APO_WD-1:0] apo_din,             //window function value for apodisation 
 input [ADDR_WD-1:0] dbf_lut_addr,         //address of coarse and fine delay LUTs( DP RAM)
 input dbf_lut_we,                         // memory read signal
 output reg signed [31:0] dbf_ch_dout19,//dbf output
 output reg dbf_ch_dout19_valid,
 output signed [13:0] w_cd_dout_ch19                  //dbf output valid
     );
	  
wire w_rst_n=~rst_n;
wire signed [INPUT_WD-1:0] w_fifo_out;
wire w_fifo_out_valid;
wire signed [INPUT_WD-1:0] w_cd_dout;
wire w_cd_dout_valid;
wire signed [FD_OUT_WD-1:0] w_fd_dout19;
wire w_fd_dout19_valid;
wire [ADDR_WD-1:0] w_dbf_lut_addr=dbf_lut_addr;
wire w_dbf_lut_we=dbf_lut_we;
 
wire signed [46:0] w_dbf_ch_dout19=w_fd_dout19*apo_din;  //APODIZATION 

assign w_cd_dout_ch19 = w_cd_dout;

coarse_n_lut19 cd19_uut(
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
	 
/*fine_delay_ch19 fine_delay_ch19_uut19(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(tx_en),
	.start(start),
	.lut_addr(w_dbf_lut_addr),
	.lut_wr_en(w_dbf_lut_we),
   .fine_din(w_cd_dout),
   .fine_din_valid(w_cd_dout_valid),
   .fine_dout(w_fd_dout19),
   .fine_dout_valid(w_fd_dout19_valid)
    );
	 
always @(posedge clk or negedge rst_n)
  begin
    if(rst_n==0)
      begin
        dbf_ch_dout19<=32'd0;
	     dbf_ch_dout19_valid<=1'b0;
	   end
    else
      begin
        if(start)
          begin
            dbf_ch_dout19<=w_dbf_ch_dout19[46:15];
	         dbf_ch_dout19_valid<=1'b1;
	       end
	     else
	       begin
            dbf_ch_dout19<=32'd0;
	         dbf_ch_dout19_valid<=1'b0;
	     end
	   end
  end*/
 

endmodule
  
