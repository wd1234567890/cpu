`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/09 23:05:24
// Design Name: 
// Module Name: timer
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


module timer(
    input clk,
    input rst,
    input [31:0] k,
    input st,
    output [31:0] q,
    output logic td
    );

    logic pe,ce;
    logic st1;
    logic st2;

    counter #(.WIDTH(32), .RST_VLU(0))
    counter1 (
        .clk(clk),
        .rstn(rst),
        .pe(pe),
        .ce(ce),
        .q(q),
        .d(k)
    );

    always @(posedge clk or negedge rst)
    begin
        if(~rst) 
        begin
            st1 <= 1'b0;
            st2 <= 1'b0;
        end
        else
        begin
            st1 <= st;
            st2 <= st1;
        end
    end

    assign pe = st1 & ~st2;//边沿检测，生成一个与时钟下降沿同步脉冲
    
    always @(posedge clk or negedge rst)
    begin
        if(~rst) ce <= 1'b0;
        else if(pe) 
            begin
                td <= 1'b0;
                ce <= 1'b1;
            end
        else if(q==32'b1)//此时q还会再下降一次
            begin
                td <= 1'b1;
                ce <= 1'b0;
            end
        else 
            begin
                ce <= ce;
                td <= td;
            end
    end
endmodule
