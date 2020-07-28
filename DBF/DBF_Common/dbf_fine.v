`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:10:38 01/30/2018 
// Design Name: 
// Module Name:    dbf_fine 
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
module dbf_fine #(`include "param.h"
)(clk,reset_n,h0,h1,datain,datain_valid,dataout,f_dout_valid);
    input signed [INPUT_WD-1:0] datain;
	 input clk, reset_n;
	 input signed [FILTER_COFF-1:0]h0,h1; //mmse filter coeffients
	 input datain_valid;
	 output signed [FD_OUT_WD-1:0]dataout;
	 output f_dout_valid;

 
    wire [FD_OUT_WD-1:0]dataout;
	 reg f_dout_valid;
	 reg signed [FD_OUT_WD-1:0] intermed_res;
	 reg signed [FD_OUT_WD-2:0] m1,m2; 
	 reg signed [INPUT_WD-1:0] fineDelayReg;

//implementation of mmse filter
	 
assign dataout=intermed_res;//[FD_OUT_WD-1:0];  //interpolated output sample
		
always @ (*)
  begin
    if(datain_valid)
	   begin
		  m1=datain*h0;
		  m2=fineDelayReg*h1;
		  intermed_res = m1+m2;
		end
	  else
	    begin
		   m1=28'd0;
		   m2=28'd0;
		   intermed_res=29'd0;
		 end
  end  
		
		
always @(posedge clk or negedge reset_n)
  begin
    if(reset_n==0)
	   begin
		  fineDelayReg <= 12'd0;
		  f_dout_valid<=1'b0;
		end
	 else
	   begin
		  if(datain_valid==1'b1)
		    begin
		      fineDelayReg <= datain;
            f_dout_valid<=1'b1;
			 end
		  else
		    begin
		      fineDelayReg <= 12'd0;
            f_dout_valid<=1'b0;
			 end
       end			 
  end
  
endmodule
