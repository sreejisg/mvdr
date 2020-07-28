
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:39 05/17/2016 
// Design Name: 
// Module Name:    param 
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
/////////////////////////////////////////////////////////////////////////////////
parameter INPUT_WD=14,   //input sample width
DBF_OP_WD=64,  //output width of summer unit
DBF_WOT_OP_WD=64,//output width without truncation
PROBE_WD=4,    //binary representation of inserted probe(2^4 probe types) 
OUT_WD=64,     //output width of each dbf module
ADDR_DEPTH=1024, //depends on number of input samples stored.
FD_OUT_WD=29, //output width after fine delay
ADDR_WD=12,    //address width of coarse and fine delay LUTs
IN_RAM_ADDR=10,  //address width of input DP RAM
CD_OUT_WD=12,  //output width after coarse delay
FILTER_COFF=16, //width of mmse filter coefficients
SCAN_LINES=61,      //2^8 scan lines
SAMPLE_COUNT=20,  //counts input samples
DYN_RNG=8,        //2^8 dynamic receive foci
M_SAMPLE_COUNT=11,//M_SAMPLE_COUNT-N_SAMPLE_COUNT=ADDR_WD
N_SAMPLE_COUNT=6, //total samples from one dynamic receive focus(2^4)
SAMPLES_NF=4096,  //total samples received within near field(i.e.WITHIN DYNAMIC FOCUSING)
TOT_SAMPLES=9431, //total samples from one scan line
APO_WD=32;         //apodization weight width
