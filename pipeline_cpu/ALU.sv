`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/08 23:44:26
// Design Name: 
// Module Name: ALU
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


module ALU(
    input logic [11:0]f, //功能选择
    input logic [31:0]a,//输入
    input logic [31:0]b,
    output logic [31:0]y //输出
    );
    logic [31:0] B;//为实现加法器复用
    logic [31:0] add;
    logic carry;
    logic overflow;

    logic less_m1;//无符号小于
    logic less_m2;//有符号小于
    logic [63:0] result;

    //assign ctr = f[1];
    assign B = b^{32{f[1]|f[2]|f[3]}};

    adder adder(
        .A(a),
        .B(B), 
        .Cin(f[1]|f[2]|f[3]),
        .carry(carry),
        .overflow(overflow),
        .y(add)
    );

    assign less_m1 = ~carry;
    assign less_m2 = /*overflow^*/add[31];

//    multi multi(        .mul1(a),        .mul2(b),        .result(result)    );


    always@(*) begin
        case(f)
            12'b000000000001: y = add;
            12'b000000000010: y = add;
            12'b000000000100: y = less_m1;
            12'b000000001000: y = less_m2;
            12'b000000010000: y = a & b;
            12'b000000100000: y = a | b;
            12'b000001000000: y = ~(a | b);
            12'b000010000000: y = a ^ b;
            12'b000100000000: y = a << b[4:0];
            12'b001000000000: y = a >> b[4:0];
            12'b010000000000: y = a >>> b[4:0];
            12'b100000000000: y = b;
 //           12'b000000000011: y = result[31:0];
            default: y = 0;
        endcase
    end

endmodule
