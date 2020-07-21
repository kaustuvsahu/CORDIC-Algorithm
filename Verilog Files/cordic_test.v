`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2020 19:26:59
// Design Name: 
// Module Name: cordic_test
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


module cordic_test();
localparam BW=32;
real cos,sin;
reg [BW-1:0] Xin,Yin;
reg  [31:0] angle;
wire signed [BW:0] Xout, Yout;
reg master_clk;
localparam FALSE = 1'b0;
localparam TRUE = 1'b1;

localparam VALUE = 32'b01001101101110100111011011010100; 
localparam sf=2.0**(-31.0); 

reg signed [63:0] i;
reg      start;
initial
begin
   start = FALSE;
   $write("Starting sim");
   master_clk = 1'b0;
   angle = 0;
   Xin = VALUE;                     
   Yin = 1'd0;                      

   #1000;
   @(posedge master_clk);
   start = TRUE;
   
   
   for (i = 0; i < 360; i = i + 1)     
     
   begin
      @(posedge master_clk);
      start = FALSE;
      angle = ((1 << 32)*i)/360;    
      $display ("angle = %d, %h",i, angle);
      cos= (($itor(Xout))*sf);
      sin= (($itor(Yout))*sf);
      #(32*timeperiod)
      $display("Cos= %f ,Sin= %f",cos,sin); 
   end

   #500
   $write("Simulation has finished");
   $stop;
end

Cordic sin_cos (master_clk, angle, Xin, Yin, Xout, Yout);

parameter timeperiod = 10;  

initial
begin
  master_clk = 1'b0;
  $display ("master_clk started");
  #5;
  forever
  begin
    #(timeperiod/2) master_clk = 1'b1;
    #(timeperiod/2) master_clk = 1'b0;
  end
end

endmodule