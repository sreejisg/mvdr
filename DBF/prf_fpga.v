`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.02.2018 10:43:24
// Design Name: 
// Module Name: prf_fpga
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


module prf_fpga(
				fclk,
                start,            
//                rx_start,
                prf
);
//Input Output ports            
input start;
input fclk;
//output rx_start;
output reg prf;
//nets
reg [15:0] count = 10'd0;

//reg rx_temp_start;

//prf generation
//Combinatorial block
always@(posedge fclk)
begin
    if (start==1)
    begin
        if(count >= 16'd0 && count < 16'd100 )
        begin
            prf <= 1'b1;
            count <= count + 16'd1;
        end
      
        else if(count >= 16'd100 && count < 16'd1150)
        begin
            prf <= 1'b0;
            count <= count + 16'd1;
        end
        else
        begin
            count <= 16'd0;        
        end
    end
    else
    begin
       prf <=1'b0;
       count <=16'd0;
    end            
end

///Sequential block
/* always @(posedge fclk or negedge start)
begin
if(start == 0)
rx_temp_start <= 1'b0;
else
rx_temp_start <= prf;
end

assign rx_start = rx_temp_start && ~prf;
*/
endmodule

