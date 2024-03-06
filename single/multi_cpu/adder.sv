`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/13 18:53:48
// Design Name: 
// Module Name: adder
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


module adder(
    input [31:0]A,
    input [31:0]B,
    input Cin,//加减法
    output carry,
    output overflow,
    output [31:0] y
    );

    assign {carry, y} = A + B +Cin;
    assign overflow = (~Cin & ~A[31] & ~B[31] & y[31]) | (~Cin & A[31] & B[31] & ~y[31]) | (Cin & A[31] & ~B[31] & ~y[31]) | (Cin & ~A[31] & B[31] & y[31]);

endmodule
