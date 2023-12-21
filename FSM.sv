`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/20 12:58:52
// Design Name: 
// Module Name: FSM
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


module FSM(
    input clk,
    input rstn,
    input [31:0]inst,
    output logic [5:0] state,
    output logic [5:0] en
    );

    parameter S00 = 6'b000000;
    parameter S10 = 6'b000001, S11 = 6'b000010, S12 = 6'b000011, S13 = 6'b000100, S14 = 6'b000101;
    parameter S20 = 6'b001001, S21 = 6'b001010, S22 = 6'b001011, S23 = 6'b001100, S24 = 6'b001101;
    parameter S30 = 6'b010001, S31 = 6'b010010, S32 = 6'b010011, S33 = 6'b010100, S34 = 6'b010101;
    parameter S40 = 6'b011001, S41 = 6'b011010, S42 = 6'b011011, S43 = 6'b011100, S44 = 6'b011101;
    parameter S50 = 6'b100001, S51 = 6'b100010, S52 = 6'b100011, S53 = 6'b100100, S54 = 6'b100101;
    parameter S60 = 6'b101001, S61 = 6'b101010, S62 = 6'b101011, S63 = 6'b101100, S64 = 6'b101101;


    logic [5:0]next_state;

    always @(posedge clk or negedge rstn)
    begin
        if(!rstn)
            state <= S00;
        else if(state == S00)
            state <= next_state;
        else if(state == S14)
            state <= S00;
        else if(state == S24)
            state <= S00;
        else if(state == S34)
            state <= S00;
        else if(state == S44)
            state <= S00;
        else if(state == S54)
            state <= S00;
        else if(state == S64)
            state <= S00;
        else state <= state + 1'b1;//每个指令内部状态跳转
    end

    always @(*)
    begin
        // if(state == S13)
        // begin
        //     next_state = S00;
        // end
        if(inst[31:15] == 17'b00000000000100000)//ADD
        begin
            next_state = S10;
        end
        else if(inst[31:22] == 10'b0000001010)//ADDI
        begin
            next_state = S20;
        end
        else if(inst[31:22] == 10'b0010100010)//LD
        begin
            next_state = S30;
        end
        else if(inst[31:22] == 10'b0010100110)//ST
        begin
            next_state = S40;
        end
        else if(inst[31:25] == 7'b0001010)//LULI
        begin
            next_state = S50;
        end
        else if(inst[31:26] == 6'b010111)//BEN
        begin
            next_state = S60;
        end
        else next_state = S00;
    end

    always @(*)
    begin
        case (state)
            S10: en = 6'b000001;//此时钟内在进行取地址
            S11: en = 6'b000010;//译码
            S12: en = 6'b000100;//执行
            S13: en = 6'b001000;//写回
            S14: en = 6'b000000;//访存
            S20: en = 6'b000001;//此时钟内在进行取地址
            S21: en = 6'b000010;//译码
            S22: en = 6'b000100;//执行
            S23: en = 6'b001000;//写回
            S24: en = 6'b000000;//访存
            S30: en = 6'b000001;//此时钟内在进行取地址
            S31: en = 6'b000010;//译码
            S32: en = 6'b000100;//执行
            S33: en = 6'b001000;//访存
            S34: en = 6'b000000;//写回
            S40: en = 6'b000001;//此时钟内在进行取地址
            S41: en = 6'b000010;//译码 
            S42: en = 6'b000100;//执行
            S43: en = 6'b001000;//访存
            S44: en = 6'b000000;//写回
            S50: en = 6'b000001;//此时钟内在进行取地址
            S51: en = 6'b000010;//译码
            S52: en = 6'b000100;//执行
            S53: en = 6'b001000;//写回
            S54: en = 6'b000000;//访存
            S60: en = 6'b000001;//此时钟内在进行取地址
            S61: en = 6'b000010;//译码
            S62: en = 6'b000100;//执行
            S63: en = 6'b001000;//写回
            S64: en = 6'b000000;//访存
            default: en = 6'b000000;
        endcase
    end

endmodule
