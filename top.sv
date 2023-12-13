`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/13 18:12:28
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    input rstn

    );
    logic [31:0]PC;
    logic [31:0]w_data;
    logic [31:0]inst;
    logic we;

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            PC <= 32'h1c000000;
        end 
        else begin//未加跳转指令
            PC <= PC + 32'd4;
        end
    end

    //取、写指令
    dram_inst dram_inst(
    .a(PC[11:2]),
    .d(w_data),
    .spo(inst),
    .we(we),
    .clk(clk),
    .dpra(PC[11:2]),
    .dpo()
    );
    
endmodule
