`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2020 14:11:15
// Design Name: 
// Module Name: Cordic
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


module Cordic(master_clk,angle,Xin,Yin,Xout,Yout);
parameter BW=32;
localparam iter=BW;
input master_clk;
input signed [31:0] angle;
input signed [BW-1:0] Xin;
input signed [BW-1:0] Yin;
output signed [BW:0] Xout;
output signed [BW:0] Yout;
wire signed [31:0] taninv[0:30];
//reg taninv [31:0] [0:30];
assign taninv[0] = 32'b00100000000000000000000000000000;
assign taninv[1] = 32'b00010010111001000000010100011110;
assign taninv[2] = 32'b00001001111110110011100001011011;
assign taninv[3] = 32'b00000101000100010001000111010100;
assign taninv[4] = 32'b00000010100010110000110101000011;
assign taninv[5] = 32'b00000001010001011101011111100001;
assign taninv[6] = 32'b00000000101000101111011000011110;
assign taninv[7] = 32'b00000000010100010111110001010101;
assign taninv[8] = 32'b00000000001010001011111001010011;
assign taninv[9] = 32'b00000000000101000101111100101111;
assign taninv[10] = 32'b00000000000010100010111110011000;
assign taninv[11] = 32'b00000000000001010001011111001100;
assign taninv[12] = 32'b00000000000000101000101111100110;
assign taninv[13] = 32'b00000000000000010100010111110011;
assign taninv[14] = 32'b00000000000000001010001011111010;
assign taninv[15] = 32'b00000000000000000101000101111101;
assign taninv[16] = 32'b00000000000000000010100010111110;
assign taninv[17] = 32'b00000000000000000001010001011111;
assign taninv[18] = 32'b00000000000000000000101000110000;
assign taninv[19] = 32'b00000000000000000000010100011000;
assign taninv[20] = 32'b00000000000000000000001010001100;
assign taninv[21] = 32'b00000000000000000000000101000110;
assign taninv[22] = 32'b00000000000000000000000010100011;
assign taninv[23] = 32'b00000000000000000000000001010001;
assign taninv[24] = 32'b00000000000000000000000000101001;
assign taninv[25] = 32'b00000000000000000000000000010100;
assign taninv[26] = 32'b00000000000000000000000000001010;
assign taninv[27] = 32'b00000000000000000000000000000101;
assign taninv[28] = 32'b00000000000000000000000000000011;
assign taninv[29] = 32'b00000000000000000000000000000001;
assign taninv[30] = 32'b00000000000000000000000000000001;
reg signed [BW:0] X [0:iter-1];
reg signed [BW:0] Y [0:iter-1];
reg signed [31:0] Z [0:iter-1];
wire [1:0] quadrant;
assign quadrant=angle[31:30];
always @(posedge master_clk)
    begin
        case(quadrant)
            2'b00,2'b11:
                begin
                    X[0]<=Xin;
                    Y[0]<=Yin;
                    Z[0]<=angle;
                end
            2'b01:
                begin
                    X[0] <= -Yin;
                    Y[0] <= Xin;
                    Z[0] <= {2'b00,angle[29:0]};
                end
            2'b10:
                begin
                    X[0] <= Yin;
                    Y[0] <= -Xin;
                    Z[0] <= {2'b11,angle[29:0]};
                end
         endcase
    end
genvar i;
generate
    for(i=0;i<(iter-1);i=i+1)
        begin: XYZ
            wire Z_sign;
            wire [BW:0] X_shr,Y_shr;
            assign X_shr=X[i]>>>(i);
            assign Y_shr=Y[i]>>>(i);
            assign Z_sign=Z[i][31];
            always @(posedge master_clk)
                begin
                    X[i+1] <= Z_sign ? X[i] + Y_shr         : X[i] - Y_shr;
                    Y[i+1] <= Z_sign ? Y[i] - X_shr         : Y[i] + X_shr;
                    Z[i+1] <= Z_sign ? Z[i] + taninv[i] : Z[i] - taninv[i];
                end
        end
endgenerate
assign Xout=X[iter-1];
assign Yout=Y[iter-1];
endmodule
