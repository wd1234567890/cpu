`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/09 23:00:21
// Design Name: 
// Module Name: counter
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


module  counter #(
    parameter WIDTH = 32, 
             RST_VLU = 0
)(
    input                   clk, rstn, 
    input                   pe, ce, 
    input       [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);
    always @(posedge clk) begin
        if (!rstn)      q <= RST_VLU;
        else if (pe)    q <= d;
        else if (ce)    q <= q - 1; 
    end
endmodule
