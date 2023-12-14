`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/13 18:35:06
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
    output logic [1:0]alu_src1_sel,
    output logic [1:0]alu_src2_sel,
    output logic mem_we,
    output logic br_type,//1时跳转
    output logic wb_sel
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
            wb_sel = 1'b1;
            br_type = 1'b0;
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
            wb_sel = 1'b1;
            br_type = 1'b0;
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
            wb_sel = 1'b0;
            br_type = 1'b0;
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
            wb_sel = 1'b0;
            br_type = 1'b0;
        end
        else if(inst[31:25] == 7'b0001010)//luli
        begin
            rf_addr1 = 5'b0;//其实用不到
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = {5'b0,inst[4:0]};
            rf_we = 1'b1;
            imm = {inst[24:5],12'b0};
            mem_we = 1'b0;
            alu_src1_sel = 2'b11;
            alu_src2_sel = 2'b00;
            alu_op = 12'b000000000001;
            wb_sel = 1'b1;
            br_type = 1'b0;
        end
        else if(inst[31:26] == 6'b010111)//ben
        begin
            rf_addr1 = inst[9:5];
            rf_addr2 = inst[4:0];
            rf_rd = 5'b0;//其实用不到
            rf_we = 1'b0;
            imm = {{14{inst[25]}}, inst[25:10], 2'b0};
            mem_we = 1'b0;
            alu_src1_sel = 2'b01;
            alu_src2_sel = 2'b01;
            alu_op = 12'b000000000010;
            wb_sel = 1'b0;
            br_type = 1'b1;
        end
        else
        begin
            rf_addr1 = 5'b0;//其实用不到
            rf_addr2 = 5'b0;//其实用不到
            rf_rd = 5'b0;//其实用不到
            rf_we = 1'b0;
            imm = 32'b0;
            mem_we = 1'b0;
            alu_src1_sel = 2'b00;
            alu_src2_sel = 2'b00;
            alu_op = 12'b000000000000;
            wb_sel = 1'b0;
            br_type = 1'b0;
        end
    end
endmodule
