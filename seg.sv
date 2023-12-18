`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/14 14:41:43
// Design Name: 
// Module Name: seg
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


module seg(
    input clk,
    input rstn,
    input [31:0] data,
    output logic [7:0] an_t,
    output logic [6:0] seg_t
    );
    logic [3:0] hd_t;
    logic [2:0] x;

    always @ (posedge clk or negedge rstn) begin
        if(!rstn) x<= 0;
        else x <= x+1;
    end

    always @(*) begin                  //数码管扫描
        an_t = 8'b1111_1111;
        hd_t = data[3:0];
        case (x)        //刷新频率约为95Hz
            3'b000: begin
                an_t = 8'b1111_1110;
                hd_t = data[3:0];
            end
            3'b001: begin
                an_t = 8'b1111_1101;
                hd_t = data[7:4];
            end
            3'b010: begin
                an_t = 8'b1111_1011;
                hd_t = data[11:8];
            end
            3'b011: begin
                an_t = 8'b1111_0111;
                hd_t = data[15:12];
            end
            3'b100: begin
                an_t = 8'b1110_1111;
                hd_t = data[19:16];
            end
            3'b101: begin
                an_t = 8'b1101_1111;
                hd_t = data[23:20];
            end
            3'b110: begin
                an_t = 8'b1011_1111;
                hd_t = data[27:24];
            end
            3'b111: begin
                an_t = 8'b0111_1111;
                hd_t = data[31:28];
            end
            default: begin
                an_t = 8'b1111_1111;
                hd_t = 4'b0000;
            end
        endcase
    end

    always @ (*) begin    //7段译码
        case(hd_t)
            4'b1111:
                seg_t = 7'b0111000;
            4'b1110:
                seg_t = 7'b0110000;
            4'b1101:
                seg_t = 7'b1000010;
            4'b1100:
                seg_t = 7'b0110001;
            4'b1011:
                seg_t = 7'b1100000;
            4'b1010:
                seg_t = 7'b0001000;
            4'b1001:
                seg_t = 7'b0001100;
            4'b1000:
                seg_t = 7'b0000000;
            4'b0111:
                seg_t = 7'b0001111;
            4'b0110:
                seg_t = 7'b0100000;
            4'b0101:
                seg_t = 7'b0100100;
            4'b0100:
                seg_t = 7'b1001100;
            4'b0011:
                seg_t = 7'b0000110;
            4'b0010:
                seg_t = 7'b0010010;
            4'b0001:
                seg_t = 7'b1001111;
            4'b0000:
                seg_t = 7'b0000001;
            default:
                seg_t = 7'b1111111;
        endcase
    end
endmodule
