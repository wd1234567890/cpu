`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/13 21:23:37
// Design Name: 
// Module Name: TFD
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


module TFD(
    input logic [31:0] k,
    input logic clk,
    input logic rst,
    input logic st,
    output logic [31:0] q,
    output logic yl,
    output logic yp
    );

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            q <= 0;
            yl <= 0;
            yp <= 0;
        end
        else if(!st)
            begin
                q <= 0;
                yl <= 0;
                yp <= 0;
            end
        else if(q==k/2)
            begin
                q <= q - 1;
                yl <= 0;
            end
        else if(q != 32'b0)
            begin
                q <= q - 1;
                yp <= 0;
            end
        else begin
            q <= k;
            yl <= 1;
            yp <= 1;
        end
    end

endmodule
