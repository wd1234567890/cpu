`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/08 23:14:18
// Design Name: 
// Module Name: decoder
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


module decoder(
    input [31:0]inst,
    output logic [4:0]rf_addr1,
    output logic [4:0]rf_addr2,
    output logic [4:0]rf_rd,
    output logic rf_we,
    output logic [31:0]imm,
    output logic [11:0]alu_op,
    output logic [11:0]b_op,
    output logic [1:0]alu_src1_sel,
    output logic [1:0]alu_src2_sel,
    output logic mem_we,
    output logic br_type,//1时跳转
    output logic wb_sel,
    output logic [1:0] wlong
    );

    always @(*)
    begin
        if(inst[31:15] == 17'b00000000000100000)//ADD
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[14:10];
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = 32'b0;
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'b000000000001;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:15] == 17'b00000000000100010)//SUB
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[14:10];
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = 32'b0;
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'b000000000010;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:15] == 17'b00000000000100100)//SLT
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[14:10];
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = 32'b0;
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'b000000000100;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:15] == 17'b00000000000100101)//SLTU
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[14:10];
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = 32'b0;
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'b000000001000;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:15] == 17'b00000000000101000)//NOR
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[14:10];
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = 32'b0;
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'h040;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0; 
            wlong = 2'b00;
        end
        else if(inst[31:15] == 17'b00000000000101001)//AND
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[14:10];
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = 32'b0;
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'h010;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:15] == 17'b00000000000101010)//OR
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[14:10];
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = 32'b0;
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'h020;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:15] == 17'b00000000000101011)//XOR
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[14:10];
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = 32'b0;
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'h080;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:15] == 17'b00000000000101110)//SLL.W
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[14:10];
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = 32'b0;
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'h100;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:15] == 17'b00000000000101111)//SRL.W
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[14:10];
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = 32'b0;
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'h200;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:15] == 17'b00000000000110000)//SRA.W
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[14:10];
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = 32'b0;
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'h400;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:15] == 17'b00000000010000001)//SLLI.W
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {27'b0, inst[14:10]};
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'h100;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:15] == 17'b00000000010001001)//SRLI.W
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {27'b0, inst[14:10]};
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'h200;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:15] == 17'b00000000010010001)//SRAI.W
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {27'b0, inst[14:10]};
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'h400;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:22] == 10'b0000001000)//SLTI
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {{20{inst[21]}}, inst[21:10]};//有符号扩展
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'h004;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:22] == 10'b0000001001)//SLTUI
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {{20{inst[21]}}, inst[21:10]};//有符号扩展
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'h008;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:22] == 10'b0000001010)//ADDI
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {{20{inst[21]}}, inst[21:10]};
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'b000000000001;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:22] == 10'b0000001101)//ANDI
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {20'b0, inst[21:10]};//零扩展
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'h010;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:22] == 10'b0000001110)//ORI
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {20'b0, inst[21:10]};//零扩展
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'h020;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:22] == 10'b0000001111)//XORI
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {20'b0, inst[21:10]};//零扩展
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'h080;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:22] == 10'b0010100000)//LD.B
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {{20{inst[21]}}, inst[21:10]};
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'b000000000001;
            b_op = 12'b000000000001;
            wb_sel = 1'b0;
            br_type = 1'b0; 
            wlong = 2'b01;
        end
        else if(inst[31:22] == 10'b0010100001)//LD.H
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {{20{inst[21]}}, inst[21:10]};
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'b000000000001;
            b_op = 12'b000000000001;
            wb_sel = 1'b0;
            br_type = 1'b0;
            wlong = 2'b10;
        end
        else if(inst[31:22] == 10'b0010100010)//LD
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {{20{inst[21]}}, inst[21:10]};
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'b000000000001;
            b_op = 12'b000000000001;
            wb_sel = 1'b0;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:22] == 10'b0010100100)//ST.B
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[4:0];//rd但本次用于读
            rf_rd = 5'b0;//本次就不用了
            rf_we = 1'b0;
            imm = {{20{inst[21]}}, inst[21:10]};
            mem_we = 1'b1;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'b000000000001;
            b_op = 12'b000000000001;
            wb_sel = 1'b0;
            br_type = 1'b0;
            wlong = 2'b01;
        end
        else if(inst[31:22] == 10'b0010100101)//ST.H
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[4:0];//rd但本次用于读
            rf_rd = 5'b0;//本次就不用了
            rf_we = 1'b0;
            imm = {{20{inst[21]}}, inst[21:10]};
            mem_we = 1'b1;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'b000000000001;
            b_op = 12'b000000000001;
            wb_sel = 1'b0;
            br_type = 1'b0;
            wlong = 2'b10;
        end
        else if(inst[31:22] == 10'b0010100110)//ST
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[4:0];//rd但本次用于读
            rf_rd = 5'b0;//本次就不用了
            rf_we = 1'b0;
            imm = {{20{inst[21]}}, inst[21:10]};
            mem_we = 1'b1;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'b000000000001;
            b_op = 12'b000000000001;
            wb_sel = 1'b0;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:22] == 10'b0010101000)//LD.BU
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {20'b0, inst[21:10]};
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'b000000000001;
            b_op = 12'b000000000001;
            wb_sel = 1'b0;
            br_type = 1'b0; 
            wlong = 2'b01;
        end
        else if(inst[31:22] == 10'b0010101001)//LD.HU
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {20'b0, inst[21:10]};
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b00;
            alu_op = 12'b000000000001;
            b_op = 12'b000000000001;
            wb_sel = 1'b0;
            br_type = 1'b0;
            wlong = 2'b10;
        end
        else if(inst[31:25] == 7'b0001010)//luli
        begin
            rf_addr1 = 5'b0;//其实用不到
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {inst[24:5],12'b0};
            mem_we = 1'b0;
            alu_src1_sel = 2'b11;
            alu_src2_sel = 2'b00;
            alu_op = 12'b000000000001;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
            wlong = 2'b00;
        end
        else if(inst[31:25] == 7'b0001110)//PCADDU 
        begin
            rf_addr1 = 5'b0;//其实用不到
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {inst[24:5],12'b0};
            mem_we = 1'b0;
            alu_src1_sel = 2'b00;
            alu_src2_sel = 2'b00;
            alu_op = 12'b000000000001;
            b_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0; 
            wlong = 2'b00;
        end
        else if(inst[31:26] == 6'b010011)//JIRL
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = inst[4:0];
            rf_we = 1'b1;
            imm = {{14{inst[25]}}, inst[25:10], 2'b0};
            mem_we = 1'b0;
            alu_src1_sel = 2'b00;
            alu_src2_sel = 2'b10;
            alu_op = 12'h001;
            b_op = 12'h000;
            wb_sel = 1'b1;
            br_type = 1'b1;
            wlong = 2'b00;
        end
        else if(inst[31:26] == 6'b010100)//B
        begin
            rf_addr1 = 5'b0;
            rf_addr2 = 5'b0;
            rf_rd = 5'b0;
            rf_we = 1'b0;
            imm = {{4{inst[25]}}, inst[9:0], inst[25:10], 2'b0};
            mem_we = 1'b0;
            alu_src1_sel = 2'b00;
            alu_src2_sel = 2'b00;
            alu_op = 12'h001;
            b_op = 12'h080;
            wb_sel = 1'b0;
            br_type = 1'b1;
            wlong = 2'b00;
        end
        else if(inst[31:26] == 6'b010101)//BL
        begin
            rf_addr1 = 5'b0;
            rf_addr2 = 5'b0;
            rf_rd = 5'b00001;
            rf_we = 1'b1;
            imm = {{4{inst[25]}}, inst[9:0], inst[25:10], 2'b0};
            mem_we = 1'b0;
            alu_src1_sel = 2'b00;
            alu_src2_sel = 2'b10;
            alu_op = 12'h001;
            b_op = 12'h080;
            wb_sel = 1'b1;
            br_type = 1'b1;
            wlong = 2'b00;
        end
        else if(inst[31:26] == 6'b010110)//BEQ
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[4:0];
            rf_rd = 5'b0;//其实用不到
            rf_we = 1'b0;
            imm = {{14{inst[25]}}, inst[25:10], 2'b0};
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'h001;
            b_op = 12'h080;
            wb_sel = 1'b0;
            br_type = 1'b1;
            wlong = 2'b00;
        end
        else if(inst[31:26] == 6'b010111)//BNE
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[4:0];
            rf_rd = 5'b0;//其实用不到
            rf_we = 1'b0;
            imm = {{14{inst[25]}}, inst[25:10], 2'b0};
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'h001;
            b_op = 12'h800;
            wb_sel = 1'b0;
            br_type = 1'b1;
            wlong = 2'b00;
        end
        else if(inst[31:26] == 6'b011000)//BLT
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[4:0];
            rf_rd = 5'b0;//其实用不到
            rf_we = 1'b0;
            imm = {{14{inst[25]}}, inst[25:10], 2'b0};
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'h001;
            b_op = 12'h801;
            wb_sel = 1'b0;
            br_type = 1'b1;
            wlong = 2'b00;
        end
        else if(inst[31:26] == 6'b011001)//BGE
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[4:0];
            rf_rd = 5'b0;//其实用不到
            rf_we = 1'b0;
            imm = {{14{inst[25]}}, inst[25:10], 2'b0};
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'h001;
            b_op = 12'h004;
            wb_sel = 1'b0;
            br_type = 1'b1;
            wlong = 2'b00;
        end
        else if(inst[31:26] == 6'b011010)//BLTU
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[4:0];
            rf_rd = 5'b0;//其实用不到
            rf_we = 1'b0;
            imm = {{14{inst[25]}}, inst[25:10], 2'b0};
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'h001;
            b_op = 12'h802;
            wb_sel = 1'b0;
            br_type = 1'b1;
            wlong = 2'b00;
        end
        else if(inst[31:26] == 6'b011011)//BGEU
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[4:0];
            rf_rd = 5'b0;//其实用不到
            rf_we = 1'b0;
            imm = {{14{inst[25]}}, inst[25:10], 2'b0};
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'h001;
            b_op = 12'h008;
            wb_sel = 1'b0;
            br_type = 1'b1;
            wlong = 2'b00;
        end
        else
        begin
            rf_addr1 = 5'b0;//其实用不到
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = 5'b11111;//防止开头进行forwarding判断
            rf_we = 1'b0;
            imm = 32'b0;
            mem_we = 1'b0;
            alu_src1_sel = 2'b00;
            alu_src2_sel = 2'b00;
            alu_op = 12'b000000000001;
            b_op = 12'b000000000001;
            wb_sel = 1'b0;
            br_type = 1'b0;
            wlong = 2'b00;
        end
    end
endmodule

/*
1.加/减/比较运算指令：pcaddu12i
5.转移指令：beq, blt, bge, bltu, bgeu, b, bl, jirl。
*/