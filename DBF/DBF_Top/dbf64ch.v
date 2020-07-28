`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.01.2018 10:00:42
// Design Name: 
// Module Name: dbf8ch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module dbf_phased #(`include "param.h"
)(
        input clk,
        input rst_n,                             //active low System reset.
       input dbf_tx_en,                        //pulse repition signal
 input [INPUT_WD-1:0] ch0_din,   
 input [INPUT_WD-1:0] ch1_din,
 input [INPUT_WD-1:0] ch2_din,
 input [INPUT_WD-1:0] ch3_din,
 input [INPUT_WD-1:0] ch4_din,
 input [INPUT_WD-1:0] ch5_din,
 input [INPUT_WD-1:0] ch6_din,
 input [INPUT_WD-1:0] ch7_din,
 input [INPUT_WD-1:0] ch8_din,   
 input [INPUT_WD-1:0] ch9_din,   
 input [INPUT_WD-1:0] ch10_din,   
 input [INPUT_WD-1:0] ch11_din,   
 input [INPUT_WD-1:0] ch12_din,   
 input [INPUT_WD-1:0] ch13_din,   
 input [INPUT_WD-1:0] ch14_din,   
 input [INPUT_WD-1:0] ch15_din, 
 input [INPUT_WD-1:0] ch16_din,   
 input [INPUT_WD-1:0] ch17_din,
 input [INPUT_WD-1:0] ch18_din,
 input [INPUT_WD-1:0] ch19_din,
 input [INPUT_WD-1:0] ch20_din,
 input [INPUT_WD-1:0] ch21_din,
 input [INPUT_WD-1:0] ch22_din,
 input [INPUT_WD-1:0] ch23_din,
 input [INPUT_WD-1:0] ch24_din,   
 input [INPUT_WD-1:0] ch25_din,   
 input [INPUT_WD-1:0] ch26_din,   
 input [INPUT_WD-1:0] ch27_din,   
 input [INPUT_WD-1:0] ch28_din,   
 input [INPUT_WD-1:0] ch29_din,   
 input [INPUT_WD-1:0] ch30_din,   
 input [INPUT_WD-1:0] ch31_din,
 input [INPUT_WD-1:0] ch32_din,   
 input [INPUT_WD-1:0] ch33_din,
 input [INPUT_WD-1:0] ch34_din,
 input [INPUT_WD-1:0] ch35_din,
 input [INPUT_WD-1:0] ch36_din,
 input [INPUT_WD-1:0] ch37_din,
 input [INPUT_WD-1:0] ch38_din,
 input [INPUT_WD-1:0] ch39_din,
 input [INPUT_WD-1:0] ch40_din,   
 input [INPUT_WD-1:0] ch41_din,   
 input [INPUT_WD-1:0] ch42_din,   
 input [INPUT_WD-1:0] ch43_din,   
 input [INPUT_WD-1:0] ch44_din,   
 input [INPUT_WD-1:0] ch45_din,   
 input [INPUT_WD-1:0] ch46_din,   
 input [INPUT_WD-1:0] ch47_din,
 input [INPUT_WD-1:0] ch48_din,   
 input [INPUT_WD-1:0] ch49_din,
 input [INPUT_WD-1:0] ch50_din,
 input [INPUT_WD-1:0] ch51_din,
 input [INPUT_WD-1:0] ch52_din,
 input [INPUT_WD-1:0] ch53_din,
 input [INPUT_WD-1:0] ch54_din,
 input [INPUT_WD-1:0] ch55_din,
 input [INPUT_WD-1:0] ch56_din,   
 input [INPUT_WD-1:0] ch57_din,   
 input [INPUT_WD-1:0] ch58_din,   
 input [INPUT_WD-1:0] ch59_din,   
 input [INPUT_WD-1:0] ch60_din,   
 input [INPUT_WD-1:0] ch61_din,   
 input [INPUT_WD-1:0] ch62_din,   
 input [INPUT_WD-1:0] ch63_din, 
 
 input [3:0] apo_sel,
 output reg signed [31:0] dbf_dout,     //final dbf output
 output signed [19:0] sum_out_cd,
 output reg dbf_dout_valid,             //final dbf output valid signal
 output fsf,
 output fef,
 output [7:0] p_scan_line_cnt,
 output signed [13:0] w_cd_dout_ch0,w_cd_dout_ch1,w_cd_dout_ch2,w_cd_dout_ch3,w_cd_dout_ch4,w_cd_dout_ch5,w_cd_dout_ch6,w_cd_dout_ch7,
 output signed [13:0] w_cd_dout_ch8,w_cd_dout_ch9,w_cd_dout_ch10,w_cd_dout_ch11,w_cd_dout_ch12,w_cd_dout_ch13,w_cd_dout_ch14,w_cd_dout_ch15,
 output signed [13:0] w_cd_dout_ch16,w_cd_dout_ch17,w_cd_dout_ch18,w_cd_dout_ch19,w_cd_dout_ch20,w_cd_dout_ch21,w_cd_dout_ch22,w_cd_dout_ch23,
 output signed [13:0] w_cd_dout_ch24,w_cd_dout_ch25,w_cd_dout_ch26,w_cd_dout_ch27,w_cd_dout_ch28,w_cd_dout_ch29,w_cd_dout_ch30,w_cd_dout_ch31,
 output signed [13:0] w_cd_dout_ch32,w_cd_dout_ch33,w_cd_dout_ch34,w_cd_dout_ch35,w_cd_dout_ch36,w_cd_dout_ch37,w_cd_dout_ch38,w_cd_dout_ch39,
 output signed [13:0] w_cd_dout_ch40,w_cd_dout_ch41,w_cd_dout_ch42,w_cd_dout_ch43,w_cd_dout_ch44,w_cd_dout_ch45,w_cd_dout_ch46,w_cd_dout_ch47,
 output signed [13:0] w_cd_dout_ch48,w_cd_dout_ch49,w_cd_dout_ch50,w_cd_dout_ch51,w_cd_dout_ch52,w_cd_dout_ch53,w_cd_dout_ch54,w_cd_dout_ch55,
 output signed [13:0] w_cd_dout_ch56,w_cd_dout_ch57,w_cd_dout_ch58,w_cd_dout_ch59,w_cd_dout_ch60,w_cd_dout_ch61,w_cd_dout_ch62,w_cd_dout_ch63
    );
	 
	 
reg signed [15:0] apo_ch0, apo_ch16,apo_ch32,apo_ch48;       //apodization value for each channel
reg signed [15:0] apo_ch1, apo_ch17,apo_ch33,apo_ch49;
reg signed [15:0] apo_ch2, apo_ch18,apo_ch34,apo_ch50;
reg signed [15:0] apo_ch3, apo_ch19,apo_ch35,apo_ch51;
reg signed [15:0] apo_ch4, apo_ch20,apo_ch36,apo_ch52;
reg signed [15:0] apo_ch5, apo_ch21,apo_ch37,apo_ch53;
reg signed [15:0] apo_ch6, apo_ch22,apo_ch38,apo_ch54;
reg signed [15:0] apo_ch7, apo_ch23,apo_ch39,apo_ch55;
reg signed [15:0] apo_ch8, apo_ch24,apo_ch40,apo_ch56;  
reg signed [15:0] apo_ch9, apo_ch25,apo_ch41,apo_ch57;  
reg signed [15:0] apo_ch10,apo_ch26,apo_ch42,apo_ch58;  
reg signed [15:0] apo_ch11,apo_ch27,apo_ch43,apo_ch59;  
reg signed [15:0] apo_ch12,apo_ch28,apo_ch44,apo_ch60;  
reg signed [15:0] apo_ch13,apo_ch29,apo_ch45,apo_ch61;  
reg signed [15:0] apo_ch14,apo_ch30,apo_ch46,apo_ch62;  
reg signed [15:0] apo_ch15,apo_ch31,apo_ch47,apo_ch63;  


//reg rst_n;

always @(*)
begin
  case(apo_sel)
  4'd0:begin  //Rectangular
         apo_ch0=16'h7FFF;
         apo_ch1=16'h7FFF;
         apo_ch3=16'h7FFF;
         apo_ch2=16'h7FFF;
         apo_ch4=16'h7FFF;
         apo_ch5=16'h7FFF;
         apo_ch6=16'h7FFF;
         apo_ch7=16'h7FFF;
		 apo_ch8=16'h7FFF; 
		 apo_ch9=16'h7FFF; 
		 apo_ch10=16'h7FFF;
		 apo_ch11=16'h7FFF;
		 apo_ch12=16'h7FFF;
		 apo_ch13=16'h7FFF;
		 apo_ch14=16'h7FFF;
		 apo_ch15=16'h7FFF;
		 apo_ch16=16'h7FFF;
		 apo_ch17=16'h7FFF;
		 apo_ch18=16'h7FFF;
		 apo_ch19=16'h7FFF;
		 apo_ch20=16'h7FFF;
		 apo_ch21=16'h7FFF;
		 apo_ch22=16'h7FFF;
		 apo_ch23=16'h7FFF;
		 apo_ch24=16'h7FFF;
		 apo_ch25=16'h7FFF;
		 apo_ch26=16'h7FFF;
		 apo_ch27=16'h7FFF;
		 apo_ch28=16'h7FFF;
		 apo_ch29=16'h7FFF;
		 apo_ch30=16'h7FFF;
		 apo_ch31=16'h7FFF;
		 apo_ch32=16'h7FFF;
		 apo_ch33=16'h7FFF;
		 apo_ch34=16'h7FFF;
		 apo_ch35=16'h7FFF;
		 apo_ch36=16'h7FFF;
		 apo_ch37=16'h7FFF;
		 apo_ch38=16'h7FFF;
		 apo_ch39=16'h7FFF;
		 apo_ch40=16'h7FFF;
		 apo_ch41=16'h7FFF;
		 apo_ch42=16'h7FFF;
		 apo_ch43=16'h7FFF;
		 apo_ch44=16'h7FFF;
		 apo_ch45=16'h7FFF;
		 apo_ch46=16'h7FFF;
		 apo_ch47=16'h7FFF;
		 apo_ch48=16'h7FFF;
		 apo_ch49=16'h7FFF;
		 apo_ch50=16'h7FFF;
		 apo_ch51=16'h7FFF;
		 apo_ch52=16'h7FFF;
		 apo_ch53=16'h7FFF;
		 apo_ch54=16'h7FFF;
		 apo_ch55=16'h7FFF;
		 apo_ch56=16'h7FFF;
		 apo_ch57=16'h7FFF;
		 apo_ch58=16'h7FFF;
		 apo_ch59=16'h7FFF;
		 apo_ch60=16'h7FFF;
		 apo_ch61=16'h7FFF;
		 apo_ch62=16'h7FFF;
		 apo_ch63=16'h7FFF;
       end
  4'd1:begin //Hanning
         apo_ch0=16'd3833;
         apo_ch1=16'd13539;
         apo_ch3=16'd24576;
         apo_ch2=16'd31780;
         apo_ch4=16'd31780;
         apo_ch5=16'd24576;
         apo_ch6=16'd13539;
         apo_ch7=16'd3833;
       end
   4'd2:begin  //hamming                    
          apo_ch0=16'd2621;        
          apo_ch1=16'd8297;       
          apo_ch3=16'd21049;       
          apo_ch2=16'd31275;       
          apo_ch4=16'd31275;       
          apo_ch5=16'd21049;       
          apo_ch6=16'd8297;       
          apo_ch7=16'd2621;        
        end                        
    4'd3:begin //Kaiser                     
          apo_ch0=16'd9960;        
          apo_ch1=16'd19172;       
          apo_ch3=16'd27338;       
          apo_ch2=16'd32133;       
          apo_ch4=16'd32133;       
          apo_ch5=16'd27388;       
          apo_ch6=16'd19172;       
          apo_ch7=16'd9960;        
        end
     default:begin //hamming
               apo_ch0=16'd2621;        
               apo_ch1=16'd8297;       
               apo_ch3=16'd21049;       
               apo_ch2=16'd31275;       
               apo_ch4=16'd31275;       
               apo_ch5=16'd21049;       
               apo_ch6=16'd8297;       
               apo_ch7=16'd2621;     
             end         
       endcase
end
	 
   //include header file param.v containing parameters.

wire signed [37:0] sum_dout;  //output of summer unit
wire signed [34:0] sum_dout11;
wire signed [34:0] sum_dout12;
wire signed [34:0] sum_dout13;
wire signed [34:0] sum_dout14;
wire signed [34:0] sum_dout15;
wire signed [34:0] sum_dout16;
wire signed [34:0] sum_dout17;
wire signed [34:0] sum_dout18;

wire signed [34:0] sum_dout10;  //output of summer unit

wire signed [31:0] w_sum_dout10;  //wired output of each channel(dbf_ch module)
wire w_sum_dout1_valid0;         //wired output valid signal of each channel
wire signed [31:0] w_sum_dout11;
wire w_sum_dout1_valid1;
wire signed [31:0] w_sum_dout12;
wire w_sum_dout1_valid2;
wire signed [31:0] w_sum_dout13;
wire  w_sum_dout1_valid3;
wire signed [31:0] w_sum_dout14;
wire  w_sum_dout1_valid4;
wire signed [31:0] w_sum_dout15;
wire w_sum_dout1_valid5;
wire signed [31:0] w_sum_dout16;
wire w_sum_dout1_valid6;
wire signed [31:0] w_sum_dout17;
wire w_sum_dout1_valid7;
wire signed [31:0] w_sum_dout18;  //wir
wire w_sum_dout1_valid8;         //wire
wire signed [31:0] w_sum_dout19;       
wire w_sum_dout1_valid9;               
wire signed [31:0] w_sum_dout20;       
wire w_sum_dout1_valid10;               
wire signed [31:0] w_sum_dout21;       
wire  w_sum_dout1_valid11;              
wire signed [31:0] w_sum_dout22;       
wire  w_sum_dout1_valid12;              
wire signed [31:0] w_sum_dout23;       
wire w_sum_dout1_valid13;               
wire signed [31:0] w_sum_dout24;       
wire w_sum_dout1_valid14;               
wire signed [31:0] w_sum_dout25;       
wire w_sum_dout1_valid15;               

wire signed [31:0] w_sum_dout26,w_sum_dout27,w_sum_dout28,w_sum_dout29,w_sum_dout30,w_sum_dout31,w_sum_dout32,w_sum_dout33;       
wire w_sum_dout1_valid16,w_sum_dout1_valid17,w_sum_dout1_valid18,w_sum_dout1_valid19,w_sum_dout1_valid20,w_sum_dout1_valid21,w_sum_dout1_valid22,w_sum_dout1_valid23;  

wire signed [31:0] w_sum_dout34,w_sum_dout35,w_sum_dout36,w_sum_dout37,w_sum_dout38,w_sum_dout39,w_sum_dout40,w_sum_dout41;       
wire w_sum_dout1_valid24,w_sum_dout1_valid25,w_sum_dout1_valid26,w_sum_dout1_valid27,w_sum_dout1_valid28,w_sum_dout1_valid29,w_sum_dout1_valid30,w_sum_dout1_valid31;        

wire signed [31:0] w_sum_dout42,w_sum_dout43,w_sum_dout44,w_sum_dout45,w_sum_dout46,w_sum_dout47,w_sum_dout48,w_sum_dout49;       
wire w_sum_dout1_valid32,w_sum_dout1_valid33,w_sum_dout1_valid34,w_sum_dout1_valid35,w_sum_dout1_valid36,w_sum_dout1_valid37,w_sum_dout1_valid38,w_sum_dout1_valid39;     

wire signed [31:0] w_sum_dout50,w_sum_dout51,w_sum_dout52,w_sum_dout53,w_sum_dout54,w_sum_dout55,w_sum_dout56,w_sum_dout57;       
wire w_sum_dout1_valid40,w_sum_dout1_valid41,w_sum_dout1_valid42,w_sum_dout1_valid43,w_sum_dout1_valid44,w_sum_dout1_valid45,w_sum_dout1_valid46,w_sum_dout1_valid47;     

wire signed [31:0] w_sum_dout58,w_sum_dout59,w_sum_dout60,w_sum_dout61,w_sum_dout62,w_sum_dout63,w_sum_dout64,w_sum_dout65;       
wire w_sum_dout1_valid48,w_sum_dout1_valid49,w_sum_dout1_valid50,w_sum_dout1_valid51,w_sum_dout1_valid52,w_sum_dout1_valid53,w_sum_dout1_valid54,w_sum_dout1_valid55;     

wire signed [31:0] w_sum_dout66,w_sum_dout67,w_sum_dout68,w_sum_dout69,w_sum_dout70,w_sum_dout71,w_sum_dout72,w_sum_dout73;       
wire w_sum_dout1_valid56,w_sum_dout1_valid57,w_sum_dout1_valid58,w_sum_dout1_valid59,w_sum_dout1_valid60,w_sum_dout1_valid61,w_sum_dout1_valid62,w_sum_dout1_valid63;     

wire w_dbf_start;

wire start=w_dbf_start;       //start signal generated from delay_uut
//wire [7:0] dbf_lut_addr=w_lut_addr;
//wire dbf_lut_we=w_lut_we;

//declare memory array to write the dbf_out
//reg [DBF_OP_WD-1:0] out_mem1[ADDR_DEPTH-1:0]; 
//integer i=0,fid,fid1; //fid=file pointer

wire [ADDR_WD-1:0] w_lut_addr;
wire w_lut_we = 1'b0;

wire signed [31:0] tru_out;
reg signed [37:0] sum_dout1; //final dbf out without truncation

wire [7:0] p_scan_line_cnt_t;
assign p_scan_line_cnt = p_scan_line_cnt_t-8'd1;
//assign dbf_out14=w_sum_dout114;
// wire signed [13:0] w_cd_dout_ch0,w_cd_dout_ch1,w_cd_dout_ch2,w_cd_dout_ch3,w_cd_dout_ch4,w_cd_dout_ch5,w_cd_dout_ch6,w_cd_dout_ch7;
// wire signed [13:0] w_cd_dout_ch8,w_cd_dout_ch9,w_cd_dout_ch10,w_cd_dout_ch11,w_cd_dout_ch12,w_cd_dout_ch13,w_cd_dout_ch14,w_cd_dout_ch15;
// wire signed [13:0] w_cd_dout_ch16,w_cd_dout_ch17,w_cd_dout_ch18,w_cd_dout_ch19,w_cd_dout_ch20,w_cd_dout_ch21,w_cd_dout_ch22,w_cd_dout_ch23;
// wire signed [13:0] w_cd_dout_ch24,w_cd_dout_ch25,w_cd_dout_ch26,w_cd_dout_ch27,w_cd_dout_ch28,w_cd_dout_ch29,w_cd_dout_ch30,w_cd_dout_ch31;
// wire signed [13:0] w_cd_dout_ch32,w_cd_dout_ch33,w_cd_dout_ch34,w_cd_dout_ch35,w_cd_dout_ch36,w_cd_dout_ch37,w_cd_dout_ch38,w_cd_dout_ch39;
// wire signed [13:0] w_cd_dout_ch40,w_cd_dout_ch41,w_cd_dout_ch42,w_cd_dout_ch43,w_cd_dout_ch44,w_cd_dout_ch45,w_cd_dout_ch46,w_cd_dout_ch47;
// wire signed [13:0] w_cd_dout_ch48,w_cd_dout_ch49,w_cd_dout_ch50,w_cd_dout_ch51,w_cd_dout_ch52,w_cd_dout_ch53,w_cd_dout_ch54,w_cd_dout_ch55;
// wire signed [13:0] w_cd_dout_ch56,w_cd_dout_ch57,w_cd_dout_ch58,w_cd_dout_ch59,w_cd_dout_ch60,w_cd_dout_ch61,w_cd_dout_ch62,w_cd_dout_ch63;
 
  //output of summer unit
 wire signed [16:0] sum_cd_dout11=w_cd_dout_ch0+w_cd_dout_ch1+w_cd_dout_ch2+w_cd_dout_ch3+w_cd_dout_ch4+w_cd_dout_ch5+w_cd_dout_ch6+w_cd_dout_ch7;
 wire signed [16:0] sum_cd_dout12=w_cd_dout_ch8+w_cd_dout_ch9+w_cd_dout_ch10+w_cd_dout_ch11+w_cd_dout_ch12+w_cd_dout_ch13+w_cd_dout_ch14+w_cd_dout_ch15;
 wire signed [16:0] sum_cd_dout13=w_cd_dout_ch16+w_cd_dout_ch17+w_cd_dout_ch18+w_cd_dout_ch19+w_cd_dout_ch20+w_cd_dout_ch21+w_cd_dout_ch22+w_cd_dout_ch23;
 wire signed [16:0] sum_cd_dout14=w_cd_dout_ch24+w_cd_dout_ch25+w_cd_dout_ch26+w_cd_dout_ch27+w_cd_dout_ch28+w_cd_dout_ch29+w_cd_dout_ch30+w_cd_dout_ch31;
 wire signed [16:0] sum_cd_dout15=w_cd_dout_ch32+w_cd_dout_ch33+w_cd_dout_ch34+w_cd_dout_ch35+w_cd_dout_ch36+w_cd_dout_ch37+w_cd_dout_ch38+w_cd_dout_ch39;
 wire signed [16:0] sum_cd_dout16=w_cd_dout_ch40+w_cd_dout_ch41+w_cd_dout_ch42+w_cd_dout_ch43+w_cd_dout_ch44+w_cd_dout_ch45+w_cd_dout_ch46+w_cd_dout_ch47;
 wire signed [16:0] sum_cd_dout17=w_cd_dout_ch48+w_cd_dout_ch49+w_cd_dout_ch50+w_cd_dout_ch51+w_cd_dout_ch52+w_cd_dout_ch53+w_cd_dout_ch54+w_cd_dout_ch55;
 wire signed [16:0] sum_cd_dout18=w_cd_dout_ch56+w_cd_dout_ch57+w_cd_dout_ch58+w_cd_dout_ch59+w_cd_dout_ch60+w_cd_dout_ch61+w_cd_dout_ch62+w_cd_dout_ch63;
 
  assign sum_out_cd = sum_cd_dout11+sum_cd_dout12+sum_cd_dout13+sum_cd_dout14+sum_cd_dout15+sum_cd_dout16+sum_cd_dout17+sum_cd_dout18;
  
// 32 dbf channel modules are instantiated(dbf_ch0,...dbf_ch31).
dbf_ch0 uut0(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch0_din),
	.apo_din(apo_ch0),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout0(w_sum_dout10),
   .dbf_ch_dout0_valid(w_sum_dout1_valid0),
   .w_cd_dout_ch0(w_cd_dout_ch0)
	);
	
dbf_ch1 uut1(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch1_din),
	.apo_din(apo_ch1),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout1(w_sum_dout11),
   .dbf_ch_dout1_valid(w_sum_dout1_valid1),
   .w_cd_dout_ch1(w_cd_dout_ch1)
	);
	
dbf_ch2 uut2(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch2_din),
	.apo_din(apo_ch2),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout2(w_sum_dout12),
   .dbf_ch_dout2_valid(w_sum_dout1_valid2),
   .w_cd_dout_ch2(w_cd_dout_ch2)
	);

dbf_ch3 uut3(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch3_din),
	.apo_din(apo_ch3),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout3(w_sum_dout13),
   .dbf_ch_dout3_valid(w_sum_dout1_valid3),
   .w_cd_dout_ch3(w_cd_dout_ch3)
	);	
	
dbf_ch4 uut4(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch4_din),
	.apo_din(apo_ch4),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout4(w_sum_dout14),
   .dbf_ch_dout4_valid(w_sum_dout1_valid4),
   .w_cd_dout_ch4(w_cd_dout_ch4)
	);
	
	
dbf_ch5 uut5(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch5_din),
   .start(w_dbf_start),
	.apo_din(apo_ch5),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout5(w_sum_dout15),
   .dbf_ch_dout5_valid(w_sum_dout1_valid5),
   .w_cd_dout_ch5(w_cd_dout_ch5)
	);
	
dbf_ch6 uut6(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch6_din),
	.apo_din(apo_ch6),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout6(w_sum_dout16),
   .dbf_ch_dout6_valid(w_sum_dout1_valid6),
   .w_cd_dout_ch6(w_cd_dout_ch6)
	);
	
dbf_ch7 uut7(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch7_din),
	.apo_din(apo_ch7),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout7(w_sum_dout17),
   .dbf_ch_dout7_valid(w_sum_dout1_valid7),
   .w_cd_dout_ch7(w_cd_dout_ch7)
	);

dbf_ch8 uut8(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch8_din),
    .apo_din(apo_ch8),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout8(w_sum_dout18),
   .dbf_ch_dout8_valid(w_sum_dout1_valid8),
   .w_cd_dout_ch8(w_cd_dout_ch8)
	);
	
dbf_ch9 uut9(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch9_din),
   .apo_din(apo_ch9),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout9(w_sum_dout19),
   .dbf_ch_dout9_valid(w_sum_dout1_valid9),
   .w_cd_dout_ch9(w_cd_dout_ch9)
    );
        
dbf_ch10 uut10(
    .clk(clk),
    .rst_n(rst_n),
    .tx_en(dbf_tx_en),
    .ch_in(ch10_din),
     .apo_din(apo_ch10),
    .start(w_dbf_start),
    .dbf_lut_addr(w_lut_addr),
    .dbf_lut_we(w_lut_we),
    .dbf_ch_dout10(w_sum_dout20),
    .dbf_ch_dout10_valid(w_sum_dout1_valid10),
    .w_cd_dout_ch10(w_cd_dout_ch10)
     );	

dbf_ch11 uut11(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch11_din),
    .apo_din(apo_ch11),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout11(w_sum_dout21),
   .dbf_ch_dout11_valid(w_sum_dout1_valid11),
   .w_cd_dout_ch11(w_cd_dout_ch11)
    );	

dbf_ch12 uut12(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch12_din),
    .apo_din(apo_ch12),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout12(w_sum_dout22),
   .dbf_ch_dout12_valid(w_sum_dout1_valid12),
   .w_cd_dout_ch12(w_cd_dout_ch12)
    );	

dbf_ch13 uut13(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch13_din),
    .apo_din(apo_ch13),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout13(w_sum_dout23),
   .dbf_ch_dout13_valid(w_sum_dout1_valid13),
   .w_cd_dout_ch13(w_cd_dout_ch13)
             );	
dbf_ch14 uut14(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch14_din),
    .apo_din(apo_ch14),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout14(w_sum_dout24),
   .dbf_ch_dout14_valid(w_sum_dout1_valid14),
   .w_cd_dout_ch14(w_cd_dout_ch14)
    );    
dbf_ch15 uut15(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch14_din),
    .apo_din(apo_ch15),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout15(w_sum_dout25),
   .dbf_ch_dout15_valid(w_sum_dout1_valid15),
   .w_cd_dout_ch15(w_cd_dout_ch15)
    );   

dbf_ch16 uut16(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch16_din),
    .apo_din(apo_ch16),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout16(w_sum_dout26),
   .dbf_ch_dout16_valid(w_sum_dout1_valid16),
   .w_cd_dout_ch16(w_cd_dout_ch16)
	);
	
dbf_ch17 uut17(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch17_din),
   .apo_din(apo_ch17),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout17(w_sum_dout27),
   .dbf_ch_dout17_valid(w_sum_dout1_valid17),
   .w_cd_dout_ch17(w_cd_dout_ch17)
    );
        
dbf_ch18 uut18(
    .clk(clk),
    .rst_n(rst_n),
    .tx_en(dbf_tx_en),
    .ch_in(ch18_din),
     .apo_din(apo_ch18),
    .start(w_dbf_start),
    .dbf_lut_addr(w_lut_addr),
    .dbf_lut_we(w_lut_we),
    .dbf_ch_dout18(w_sum_dout28),
    .dbf_ch_dout18_valid(w_sum_dout1_valid18),
    .w_cd_dout_ch18(w_cd_dout_ch18)
     );	

dbf_ch19 uut19(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch11_din),
    .apo_din(apo_ch19),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout19(w_sum_dout29),
   .dbf_ch_dout19_valid(w_sum_dout1_valid19),
   .w_cd_dout_ch19(w_cd_dout_ch19)
    );	

dbf_ch20 uut20(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch20_din),
    .apo_din(apo_ch20),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout20(w_sum_dout30),
   .dbf_ch_dout20_valid(w_sum_dout1_valid20),
   .w_cd_dout_ch20(w_cd_dout_ch20)
    );	

dbf_ch21 uut21(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch21_din),
    .apo_din(apo_ch21),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout21(w_sum_dout31),
   .dbf_ch_dout21_valid(w_sum_dout1_valid21),
   .w_cd_dout_ch21(w_cd_dout_ch21)
             );	
dbf_ch22 uut22(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch22_din),
    .apo_din(apo_ch22),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout22(w_sum_dout32),
   .dbf_ch_dout22_valid(w_sum_dout1_valid22),
   .w_cd_dout_ch22(w_cd_dout_ch22)
    );    
dbf_ch23 uut23(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch23_din),
    .apo_din(apo_ch23),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout23(w_sum_dout33),
   .dbf_ch_dout23_valid(w_sum_dout1_valid23),
   .w_cd_dout_ch23(w_cd_dout_ch23)
    ); 

dbf_ch24 uut24(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch24_din),
    .apo_din(apo_ch24),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout24(w_sum_dout34),
   .dbf_ch_dout24_valid(w_sum_dout1_valid24),
   .w_cd_dout_ch24(w_cd_dout_ch24)
	);
	
dbf_ch25 uut25(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch25_din),
   .apo_din(apo_ch25),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout25(w_sum_dout35),
   .dbf_ch_dout25_valid(w_sum_dout1_valid25),
   .w_cd_dout_ch25(w_cd_dout_ch25)
    );
        
dbf_ch26 uut26(
    .clk(clk),
    .rst_n(rst_n),
    .tx_en(dbf_tx_en),
    .ch_in(ch26_din),
     .apo_din(apo_ch26),
    .start(w_dbf_start),
    .dbf_lut_addr(w_lut_addr),
    .dbf_lut_we(w_lut_we),
    .dbf_ch_dout26(w_sum_dout36),
    .dbf_ch_dout26_valid(w_sum_dout1_valid26),
    .w_cd_dout_ch26(w_cd_dout_ch26)
     );	

dbf_ch27 uut27(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch27_din),
    .apo_din(apo_ch27),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout27(w_sum_dout37),
   .dbf_ch_dout27_valid(w_sum_dout1_valid27),
   .w_cd_dout_ch27(w_cd_dout_ch27)
    );	

dbf_ch28 uut28(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch28_din),
    .apo_din(apo_ch28),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout28(w_sum_dout38),
   .dbf_ch_dout28_valid(w_sum_dout1_valid28),
   .w_cd_dout_ch28(w_cd_dout_ch28)
    );	

dbf_ch29 uut29(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch29_din),
    .apo_din(apo_ch29),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout29(w_sum_dout39),
   .dbf_ch_dout29_valid(w_sum_dout1_valid29),
   .w_cd_dout_ch29(w_cd_dout_ch29)
             );	
dbf_ch30 uut30(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch30_din),
    .apo_din(apo_ch30),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout30(w_sum_dout40),
   .dbf_ch_dout30_valid(w_sum_dout1_valid30),
   .w_cd_dout_ch30(w_cd_dout_ch30)
    );    
dbf_ch31 uut31(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch31_din),
   .apo_din(apo_ch31),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout31(w_sum_dout41),
   .dbf_ch_dout31_valid(w_sum_dout1_valid31),
   .w_cd_dout_ch31(w_cd_dout_ch31)
    ); 

dbf_ch32 uut32(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch32_din),
	.apo_din(apo_ch32),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout32(w_sum_dout42),
   .dbf_ch_dout32_valid(w_sum_dout1_valid32),
   .w_cd_dout_ch32(w_cd_dout_ch32)
	);
	
dbf_ch33 uut33(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch33_din),
	.apo_din(apo_ch33),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout33(w_sum_dout43),
   .dbf_ch_dout33_valid(w_sum_dout1_valid33),
   .w_cd_dout_ch33(w_cd_dout_ch33)
	);
	
dbf_ch34 uut34(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch34_din),
    .apo_din(apo_ch34),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout34(w_sum_dout44),
   .dbf_ch_dout34_valid(w_sum_dout1_valid34),
   .w_cd_dout_ch34(w_cd_dout_ch34)
    );    
	
dbf_ch35 uut35(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch35_din),
	.apo_din(apo_ch35),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout35(w_sum_dout45),
   .dbf_ch_dout35_valid(w_sum_dout1_valid35),
   .w_cd_dout_ch35(w_cd_dout_ch35)
	);

dbf_ch36 uut36(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch36_din),
	.apo_din(apo_ch36),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout36(w_sum_dout46),
   .dbf_ch_dout36_valid(w_sum_dout1_valid36),
   .w_cd_dout_ch36(w_cd_dout_ch36)
	);	
	
dbf_ch37 uut37(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch37_din),
	.apo_din(apo_ch37),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout37(w_sum_dout47),
   .dbf_ch_dout37_valid(w_sum_dout1_valid37),
   .w_cd_dout_ch37(w_cd_dout_ch37)
	);
	
	
dbf_ch38 uut38(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch38_din),
   .start(w_dbf_start),
	.apo_din(apo_ch38),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout38(w_sum_dout48),
   .dbf_ch_dout38_valid(w_sum_dout1_valid38),
   .w_cd_dout_ch38(w_cd_dout_ch38)
	);
	
dbf_ch39 uut39(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch39_din),
	.apo_din(apo_ch39),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout39(w_sum_dout49),
   .dbf_ch_dout39_valid(w_sum_dout1_valid39),
   .w_cd_dout_ch39(w_cd_dout_ch39)
	);
	
dbf_ch40 uut40(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch40_din),
	.apo_din(apo_ch40),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout40(w_sum_dout50),
   .dbf_ch_dout40_valid(w_sum_dout1_valid40),
   .w_cd_dout_ch40(w_cd_dout_ch40)
	);

dbf_ch41 uut41(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch41_din),
    .apo_din(apo_ch41),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout41(w_sum_dout51),
   .dbf_ch_dout41_valid(w_sum_dout1_valid41),
   .w_cd_dout_ch41(w_cd_dout_ch41)
	);
	
dbf_ch42 uut42(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch42_din),
   .apo_din(apo_ch42),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout42(w_sum_dout52),
   .dbf_ch_dout42_valid(w_sum_dout1_valid42),
   .w_cd_dout_ch42(w_cd_dout_ch42)
    );
        
dbf_ch43 uut43(
    .clk(clk),
    .rst_n(rst_n),
    .tx_en(dbf_tx_en),
    .ch_in(ch43_din),
     .apo_din(apo_ch43),
    .start(w_dbf_start),
    .dbf_lut_addr(w_lut_addr),
    .dbf_lut_we(w_lut_we),
    .dbf_ch_dout43(w_sum_dout53),
    .dbf_ch_dout43_valid(w_sum_dout1_valid43),
    .w_cd_dout_ch43(w_cd_dout_ch43)
     );	

dbf_ch44 uut44(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch44_din),
    .apo_din(apo_ch44),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout44(w_sum_dout54),
   .dbf_ch_dout44_valid(w_sum_dout1_valid44),
   .w_cd_dout_ch44(w_cd_dout_ch44)
    );	

dbf_ch45 uut45(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch45_din),
    .apo_din(apo_ch45),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout45(w_sum_dout55),
   .dbf_ch_dout45_valid(w_sum_dout1_valid45),
   .w_cd_dout_ch45(w_cd_dout_ch45)
    );	

dbf_ch46 uut46(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch46_din),
    .apo_din(apo_ch46),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout46(w_sum_dout56),
   .dbf_ch_dout46_valid(w_sum_dout1_valid46),
   .w_cd_dout_ch46(w_cd_dout_ch46)
             );	
dbf_ch47 uut47(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch47_din),
    .apo_din(apo_ch47),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout47(w_sum_dout57),
   .dbf_ch_dout47_valid(w_sum_dout1_valid47),
   .w_cd_dout_ch47(w_cd_dout_ch47)
    );    
dbf_ch48 uut48(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch48_din),
    .apo_din(apo_ch48),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout48(w_sum_dout58),
   .dbf_ch_dout48_valid(w_sum_dout1_valid48),
   .w_cd_dout_ch48(w_cd_dout_ch48)
    );   

dbf_ch49 uut49(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch49_din),
    .apo_din(apo_ch49),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout49(w_sum_dout59),
   .dbf_ch_dout49_valid(w_sum_dout1_valid49),
   .w_cd_dout_ch49(w_cd_dout_ch49)
	);

	
dbf_ch50 uut50(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch50_din),
   .apo_din(apo_ch50),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout50(w_sum_dout60),
   .dbf_ch_dout50_valid(w_sum_dout1_valid50),
   .w_cd_dout_ch50(w_cd_dout_ch50)
    );
        
dbf_ch51 uut51(
    .clk(clk),
    .rst_n(rst_n),
    .tx_en(dbf_tx_en),
    .ch_in(ch51_din),
     .apo_din(apo_ch51),
    .start(w_dbf_start),
    .dbf_lut_addr(w_lut_addr),
    .dbf_lut_we(w_lut_we),
    .dbf_ch_dout51(w_sum_dout61),
    .dbf_ch_dout51_valid(w_sum_dout1_valid51),
    .w_cd_dout_ch51(w_cd_dout_ch51)
     );	

dbf_ch52 uut52(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch52_din),
    .apo_din(apo_ch52),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout52(w_sum_dout62),
   .dbf_ch_dout52_valid(w_sum_dout1_valid52),
   .w_cd_dout_ch52(w_cd_dout_ch52)
    );	

dbf_ch53 uut53(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch53_din),
    .apo_din(apo_ch53),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout53(w_sum_dout63),
   .dbf_ch_dout53_valid(w_sum_dout1_valid53),
   .w_cd_dout_ch53(w_cd_dout_ch53)
    );	

dbf_ch54 uut54(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch54_din),
    .apo_din(apo_ch54),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout54(w_sum_dout64),
   .dbf_ch_dout54_valid(w_sum_dout1_valid54),
   .w_cd_dout_ch54(w_cd_dout_ch54)
             );	
dbf_ch55 uut55(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch55_din),
    .apo_din(apo_ch55),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout55(w_sum_dout65),
   .dbf_ch_dout55_valid(w_sum_dout1_valid55),
   .w_cd_dout_ch55(w_cd_dout_ch55)
    );    
dbf_ch56 uut56(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch56_din),
    .apo_din(apo_ch56),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout56(w_sum_dout66),
   .dbf_ch_dout56_valid(w_sum_dout1_valid56),
   .w_cd_dout_ch56(w_cd_dout_ch56)
    ); 

dbf_ch57 uut57(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch57_din),
    .apo_din(apo_ch57),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout57(w_sum_dout67),
   .dbf_ch_dout57_valid(w_sum_dout1_valid57),
   .w_cd_dout_ch57(w_cd_dout_ch57)
	);
	
dbf_ch58 uut58(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch58_din),
   .apo_din(apo_ch58),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout58(w_sum_dout68),
   .dbf_ch_dout58_valid(w_sum_dout1_valid58),
   .w_cd_dout_ch58(w_cd_dout_ch58)
    );
        
dbf_ch59 uut59(
    .clk(clk),
    .rst_n(rst_n),
    .tx_en(dbf_tx_en),
    .ch_in(ch59_din),
     .apo_din(apo_ch59),
    .start(w_dbf_start),
    .dbf_lut_addr(w_lut_addr),
    .dbf_lut_we(w_lut_we),
    .dbf_ch_dout59(w_sum_dout69),
    .dbf_ch_dout59_valid(w_sum_dout1_valid59),
    .w_cd_dout_ch59(w_cd_dout_ch59)
     );	

dbf_ch60 uut60(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch60_din),
    .apo_din(apo_ch60),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout60(w_sum_dout70),
   .dbf_ch_dout60_valid(w_sum_dout1_valid60),
   .w_cd_dout_ch60(w_cd_dout_ch60)
    );	

dbf_ch61 uut61(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch61_din),
    .apo_din(apo_ch61),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout61(w_sum_dout71),
   .dbf_ch_dout61_valid(w_sum_dout1_valid61),
   .w_cd_dout_ch61(w_cd_dout_ch61)
    );	

dbf_ch62 uut62(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch62_din),
    .apo_din(apo_ch62),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout62(w_sum_dout72),
   .dbf_ch_dout62_valid(w_sum_dout1_valid62),
   .w_cd_dout_ch62(w_cd_dout_ch62)
             );	
dbf_ch63 uut63(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
   .ch_in(ch63_din),
    .apo_din(apo_ch63),
   .start(w_dbf_start),
   .dbf_lut_addr(w_lut_addr),
   .dbf_lut_we(w_lut_we),
   .dbf_ch_dout63(w_sum_dout73),
   .dbf_ch_dout63_valid(w_sum_dout1_valid63),
   .w_cd_dout_ch63(w_cd_dout_ch63)
    );    
	   	
              	
                                // Common Delay control unit for all

// Common Delay control unit for all 32 channels
delay_ctrl_unit delay_uut(
   .clk(clk),
   .rst_n(rst_n),
   .tx_en(dbf_tx_en),
	.dbf_start(w_dbf_start),
	.frame_start_flag(fsf),
	.frame_end_flag(fef),
  // .no_scan_lines(no_scan_lines),
   .lut_addr(w_lut_addr),
   .p_scan_line_cnt(p_scan_line_cnt_t)
	);

//assign dbf_dbg_bus = {start,dbf_lut_addr,dbf_lut_we};


//SUMMER UNIT
assign sum_dout11 = w_sum_dout10+w_sum_dout11+w_sum_dout12+w_sum_dout13+w_sum_dout14+w_sum_dout15+w_sum_dout16+w_sum_dout17;
assign sum_dout12 = w_sum_dout18+w_sum_dout19+w_sum_dout20+w_sum_dout21+w_sum_dout22+w_sum_dout23+w_sum_dout24+w_sum_dout25;
assign sum_dout13 = w_sum_dout26+w_sum_dout27+w_sum_dout28+w_sum_dout29+w_sum_dout30+w_sum_dout31+w_sum_dout32+w_sum_dout33;
assign sum_dout14 = w_sum_dout34+w_sum_dout35+w_sum_dout36+w_sum_dout37+w_sum_dout38+w_sum_dout39+w_sum_dout40+w_sum_dout41;
assign sum_dout15 = w_sum_dout42+w_sum_dout43+w_sum_dout44+w_sum_dout45+w_sum_dout46+w_sum_dout47+w_sum_dout48+w_sum_dout49;
assign sum_dout16 = w_sum_dout50+w_sum_dout51+w_sum_dout52+w_sum_dout53+w_sum_dout54+w_sum_dout55+w_sum_dout56+w_sum_dout57;
assign sum_dout17 = w_sum_dout58+w_sum_dout59+w_sum_dout60+w_sum_dout61+w_sum_dout62+w_sum_dout63+w_sum_dout64+w_sum_dout65;
assign sum_dout18 = w_sum_dout66+w_sum_dout67+w_sum_dout68+w_sum_dout69+w_sum_dout70+w_sum_dout71+w_sum_dout72+w_sum_dout73;
 
assign sum_dout = sum_dout11+sum_dout12+sum_dout13+sum_dout14+sum_dout15+sum_dout16+sum_dout17+sum_dout18;
 
always @ (posedge clk or negedge rst_n)
  begin
    if(rst_n==0)
      begin
	     sum_dout1<=64'd0;
  	     dbf_dout<=32'd0;
	     dbf_dout_valid<=1'b0;
	   end
    else
      begin
        if(start)
	       begin
            sum_dout1<=sum_dout;      //output without truncation
	         dbf_dout<=tru_out;        //  "    with truncation
	         dbf_dout_valid<=1'b1;
          end
	     else
	       begin
	         sum_dout1<=64'd0;
  	         dbf_dout<=32'd0;
	         dbf_dout_valid<=1'b0;
          end
      end
  end

//truncation of output
assign tru_out[31:0] =sum_dout[37:6];

//TX ENABLE
/*prf_fpga prf_gen_inst(
						.fclk(clk),
						.start(rst_n),			
						.prf(dbf_tx_en)
			);
*/
endmodule

