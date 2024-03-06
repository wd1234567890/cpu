`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/14 09:55:49
// Design Name: 
// Module Name: reg_files
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


module  reg_file # (
    parameter ADDR_WIDTH  = 5,              //地址宽度
    parameter DATA_WIDTH  = 32              //数据宽度
)(
    input                       clk,        //时钟
    input   [ADDR_WIDTH -1:0]   ra0, ra1, ra2,   //读地址
    output  [DATA_WIDTH -1:0]   rd0, rd1, rd2,  //读数据
    input   [ADDR_WIDTH -1:0]   wa,         //写地址
    input   [DATA_WIDTH -1:0]   wd,         //写数据
    input                       we          //写使能
);
    reg [DATA_WIDTH -1:0]  rf [0:(1<<ADDR_WIDTH)-1];    //寄存器堆

    //初始化，方便调试
    generate
        integer i;
        initial
        begin
             for (i = 0; i < 32; i = i + 1)
                 rf[i] = {32'h00000000};
        end
     endgenerate

    //读操作：读优先，异步读
    assign rd0 = rf[ra0];   
    assign rd1 = rf[ra1];
    assign rd2 = rf[ra2];

    //写操作：同步写
    always@ (posedge clk) begin
        if (we && wa != 0)  rf[wa] <= wd;  
    end

endmodule