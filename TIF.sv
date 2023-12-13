`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/17 20:46:20
// Design Name: 
// Module Name: TIF
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


module TIF(
    input clk,
    input rst,
    input [7:0] din,
    input tx_vld,
    output logic tx_rdy,
    output logic txd
    );
    logic [7:0] data;
    logic [3:0] cnt;

    always@(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            data <= 8'b11111111;
            tx_rdy <= 1'b1;
            txd <= 1'b1;
            cnt <= 4'h8;
        end
        else if(tx_vld & tx_rdy)
        begin 
            cnt <= 4'h8;
            data <= din;
            tx_rdy <= 1'b0;
            txd <= 1'b0;//立刻就开始发送start
        end
        else if(cnt != 4'h0)
            begin
                txd <= data[0];
                data <= {1'b1,data[7:1]};
                cnt <= cnt - 1'b1;
            end
        else 
            begin
                txd <= 1'b1;//stop
                tx_rdy <= 1'b1;
            end
    end
endmodule
