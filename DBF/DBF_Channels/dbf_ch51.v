`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:17:18 03/08/2016 
// Design Name: 
// Module Name:    dbf_ch51 
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

module dbf_ch51 #(`include "param.h"
)(
 input clk,
 input rst_n,
 input tx_en,
 input start,
 input [INPUT_WD-1:0] ch_in,               //input sample
 input signed [APO_WD-1:0] apo_din,             //window function value for apodisation 
 input [ADDR_WD-1:0] dbf_lut_addr,         //address of coarse and fine delay LUTs( DP RAM)
 input dbf_lut_we,                         // memory read signal
 output reg signed [31:0] dbf_ch_dout51,//dbf output
 output reg dbf_ch_dout51_valid,
 output signed [13:0] w_cd_dout_ch51                  //dbf output valid
     );
	  
wire w_rst_n=~rst_n;
wire signed [INPUT_WD-1:0] w_fifo_out;
wire w_fifo_out_valid;
wire signed [INPUT_WD-1:0] w_cd_dout;
wire w_cd_dout_valid;
wire signed [FD_OUT_WD-1:0] w_fd_dout51;
wire w_fd_dout51_valid;
wire [ADDR_WD-1:0] w_dbf_lut_addr=dbf_lut_addr;
wire w_dbf_lut_we=dbf_lut_we;
 
wire signed [46:0] w_dbf_ch_dout51=w_fd_dout51*apo_din;  //APODIZATION 

assign w_cd_dout_ch51 = w_cd_dout;

coarse_n_lut51 cd51_uut(
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
	 
/*fine_delay_ch51 fine_delay_ch51_uut51(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(tx_en),
	.start(start),
	.lut_addr(w_dbf_lut_addr),
	.lut_wr_en(w_dbf_lut_we),
   .fine_din(w_cd_dout),
   .fine_din_valid(w_cd_dout_valid),
   .fine_dout(w_fd_dout51),
   .fine_dout_valid(w_fd_dout51_valid)
    );
	 
always @(posedge clk or negedge rst_n)
  begin
    if(rst_n==0)
      begin
        dbf_ch_dout51<=32'd0;
	     dbf_ch_dout51_valid<=1'b0;
	   end
    else
      begin
        if(start)
          begin
            dbf_ch_dout51<=w_dbf_ch_dout51[46:15];
	         dbf_ch_dout51_valid<=1'b1;
	       end
	     else
	       begin
            dbf_ch_dout51<=32'd0;
	         dbf_ch_dout51_valid<=1'b0;
	     end
	   end
  end
 */

endmodule
  
