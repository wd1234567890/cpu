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
    input clk_cpu,
    input rstn,
    input [31:0]addr,
    input [31:0]din,//用于改指令和数，但我没口了
    input we_dm,
    input we_im,
    input clk_ld,
    input debug,
    output logic [31:0]CTL,
    output logic [31:0] PC,
    output logic [31:0]PC_chk,
    output logic [31:0]npc,
    output logic [31:0] inst,
    output logic [31:0] imm,
    output logic [31:0] alu_src1,
    output logic [31:0] alu_src2,
    output logic [31:0]alu_result,
    output logic [31:0]mem_rdata,
    output logic [31:0]dout_rf,
    output logic [31:0]dout_dm,
    output logic [31:0]dout_im
    );

    logic clk;
    // logic [31:0]inst_wdata;
    // logic we;
    logic [4:0]rf_rd;
    logic [4:0]rf_addr1;
    logic [4:0]rf_addr2;
    logic [31:0]rf_data1;
    logic [31:0]rf_data2;
    logic br_type;
    logic jump_en;
    logic [31:0]jump_target;
    logic [31:0]rf_wdata;

    logic [1:0]alu_src1_sel;
    logic [1:0]alu_src2_sel;
    logic [11:0]alu_op;
    logic [9:0]mem_addr;
    logic [31:0]mem_wdata;
    logic mem_we;
    logic wb_sel;

    assign PC_chk = PC;//单周期cpu中相同

    assign mem_addr = alu_result[11:2];
    assign mem_wdata = rf_data2;

    always @(*)
    begin
        if(debug)
            clk = clk_ld;
        else clk = clk_cpu;
    end

    always @(*)
    begin
        if(jump_en)
        begin
            npc = jump_target;
        end
        else
        begin
            npc = PC + 32'd4;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            PC <= 32'h1c000000;
        end 
        else if(jump_en)
        begin
            PC <= jump_target; 
        end
        else begin
            PC <= PC + 32'd4;
        end
    end

    //mux1 3->1
    always @(*)
    begin
        case (alu_src1_sel)
            2'b00: alu_src1 = PC;
            2'b01: alu_src1 = rf_data1;
            2'b10: alu_src1 = 32'b0; 
            default: alu_src1 = rf_data1;
        endcase
    end

    //mux2 3->1
    always @(*)
    begin
        case (alu_src2_sel)
            2'b00: alu_src2 = imm;
            2'b01: alu_src2 = rf_data2;
            2'b10: alu_src2 = 32'd4; 
            default: alu_src2 = rf_data2;
        endcase
    end

    //mux3 2->1
    always @(*)
    begin
        case (wb_sel)
            1'b0: rf_wdata = mem_rdata;
            1'b1: rf_wdata = alu_result;
            default: rf_wdata = mem_rdata;
        endcase
    end

    ALU ALU(
    .f(alu_op),
    .a(alu_src1),
    .b(alu_src2),
    .y(alu_result)
    );

    //寄存器堆
    reg_file # (
    .ADDR_WIDTH(5),
    .DATA_WIDTH(32)
  )
  reg_file_inst (
    .clk(clk),
    .ra0(rf_addr1),
    .ra1(rf_addr2),
    .ra2(addr[4:0]),
    .rd0(rf_data1),
    .rd1(rf_data2),
    .rd2(dout_rf),
    .wa(rf_rd),
    .wd(rf_wdata),
    .we(rf_we)
  );

    decoder decoder(
    .inst(inst),
    .rf_addr1(rf_addr1),
    .rf_addr2(rf_addr2),
    .rf_rd(rf_rd),
    .rf_we(rf_we),
    .imm(imm),
    .alu_op(alu_op),
    .alu_src1_sel(alu_src1_sel),
    .alu_src2_sel(alu_src2_sel),
    .mem_we(mem_we),
    .br_type(br_type),
    .wb_sel(wb_sel)
    );

    //branch
    branch branch(
    .PC(PC),
    .imm(imm),
    .rf_data1(rf_data1),
    .rf_data2(rf_data2),
    .br_type(br_type),
    .jump_en(jump_en),
    .jump_target(jump_target)
    );

    //取写数据
    dram_data dram_data(
    .a(mem_addr),
    .d(mem_wdata),
    .spo(mem_rdata),
    .we(mem_we),
    .clk(clk),
    .dpra(addr[9:0]),
    .dpo(dout_dm)
    );

    //取、不能写指令
    dram_inst dram_inst(
    .a(PC[11:2]),
    .d(32'b0),
    .spo(inst),
    .we(1'b0),
    .clk(clk),
    .dpra(addr[9:0]),
    .dpo(dout_im)
    );
    
endmodule
