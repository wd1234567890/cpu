`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2024/03/08 20:26:17
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
    input [31:0]din,
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

    logic        clk;
    logic [31:0] inst_r;
    logic [31:0] inst_rx;
    logic        inst_sel;
    logic [31:0] rf_data1;
    logic [31:0] rf_data1_r;
    logic [31:0] rf_data1_rx;
    logic [1:0]  rf_data1_sel;
    logic [31:0] rf_data2;
    logic [31:0] rf_data2_r;
    logic [31:0] rf_data2_rx;
    logic [1:0]  rf_data2_sel;
    logic [4:0]  rf_addr1;
    logic [4:0]  rf_addr2;
    logic [4:0]  rf_rd;
    logic [4:0]  rf_rd_r;
    logic [4:0]  rf_rd_2r;
    logic [4:0]  rf_rd_3r;
    logic [31:0] rf_wdata;
    logic        rf_we_rx;
    logic        rf_we_sel;
    logic        rf_we;
    logic        rf_we_r;
    logic        rf_we_2r;
    logic        rf_we_3r;
    logic [31:0] imm_r;
    logic [11:0] alu_op_r;
    logic [11:0] alu_op;
    logic [1:0]  alu_src1_sel_r;
    logic [1:0]  alu_src1_sel;
    logic [1:0]  alu_src2_sel_r;
    logic [1:0]  alu_src2_sel;
    logic        mem_we_rx;
    logic        mem_we_r;
    logic        mem_we_2r;
    logic        mem_we;
    logic        mem_we_sel;
    logic [9:0]  mem_addr;
    logic [31:0] mem_wdata;
    logic [31:0] mem_rdata_r;
    logic        br_type_rx;
    logic        br_type_r;
    logic        br_type;
    logic        br_type_sel;
    logic        wb_sel_r;
    logic        wb_sel_2r;
    logic        wb_sel_3r;
    logic        wb_sel;
    logic [31:0] alu_result_r;
    logic [31:0] alu_result_2r;//add指令中间有访存不执行
    logic [31:0] jump_target_r;
    //logic        jump_en_sel;
    logic        jump_en_r;
    //logic        jump_en_rx;
    logic [31:0] jump_target;
    logic        jump_en;
    logic        jump_en_l;
    logic        PC_sel;




    assign mem_addr = alu_result_2r[11:2];
    //assign mem_wdata = rf_data2;//此时mem_wdata与rf_data2直接相连，但是rf_data2是执行阶段产生的信号，要到访存阶段才能写入内存，所以再加一个寄存器

    //hazard
    hazard hazard(
        .jump_en(jump_en),
        .jump_en_r(jump_en_r),
        .jump_en_l(jump_en_l),
        .rf_addr1(rf_addr1),
        .rf_addr2(rf_addr2),
        .rf_rd_2r(rf_rd_2r),
        .mem_we_2r(mem_we_2r),
        .wb_sel_2r(wb_sel_2r),
        .br_type(br_type),
        .PC_sel(PC_sel),
        .rf_we_sel(rf_we_sel),
        .mem_we_sel(mem_we_sel),
        .inst_sel(inst_sel),
        .br_type_sel(br_type_sel)
    );

    //数据相关前递单元
    forwarding forwarding(
        .rf_addr1(rf_addr1),
        .rf_addr2(rf_addr2),
        .rf_rd_2r(rf_rd_2r),
        .rf_rd_3r(rf_rd_3r),
        .wb_sel_3r(wb_sel_3r),
        .rf_data1_sel(rf_data1_sel),
        .rf_data2_sel(rf_data2_sel)
    );

    //取指阶段->译码阶段
    register # (
    .WIDTH(32),
    .RST_VAL(0)
    )
register_inst (
    .clk(clk),
    .rstn(rstn),
    .en(1'b1),
    .d(inst_r),
    .q(inst)
    );

    //译码阶段->执行阶段
    register #(
        .WIDTH(121),
        .RST_VAL(0)
    )
register_decode (
        .clk(clk),
        .rstn(rstn),
        .en(1'b1),
        .d({imm_r,alu_src1_sel_r,alu_src2_sel_r,rf_data1_r,rf_data2_r,alu_op_r,mem_we_r,br_type_r,wb_sel_r,rf_rd_r,rf_we_r}),
        .q({imm,alu_src1_sel,alu_src2_sel,rf_data1,rf_data2,alu_op,mem_we_2r,br_type,wb_sel_2r,rf_rd_2r,rf_we_2r})
    );

    //执行阶段->访存阶段
    register #(
        .WIDTH(105),
        .RST_VAL(0)
    )
register_execute (
        .clk(clk),
        .rstn(rstn),
        .en(1'b1),
        .d({alu_result_r,jump_en_r,jump_target_r,mem_we_2r,rf_rd_2r,rf_we_2r,wb_sel_2r,rf_data2}),//此处men_we发挥作用结束
        .q({alu_result_2r,jump_en,jump_target,mem_we,rf_rd_3r,rf_we_3r,wb_sel_3r,mem_wdata})
    );

    //访存阶段->写回阶段
    register #(
        .WIDTH(71),
        .RST_VAL(0)
    )
register_mem (
        .clk(clk),
        .rstn(rstn),
        .en(1'b1),
        .d({alu_result_2r,mem_rdata_r,rf_we_3r,rf_rd_3r,wb_sel_3r}),
        .q({alu_result,mem_rdata,rf_we,rf_rd,wb_sel})
    );

    register #(
        .WIDTH(1),
        .RST_VAL(0)
    )
register_branch (
        .clk(clk),
        .rstn(rstn),
        .en(1'b1),
        .d(jump_en),
        .q(jump_en_l)
    );

    //alumux1 3->1
    always @(*)
    begin
        case (alu_src1_sel)
            2'b00: alu_src1 = PC;
            2'b01: alu_src1 = rf_data1;
            2'b10: alu_src1 = 32'b0; 
            default: alu_src1 = rf_data1;
        endcase
    end

    //alumux2 3->1
    always @(*)
    begin
        case (alu_src2_sel)
            2'b00: alu_src2 = imm;
            2'b01: alu_src2 = rf_data2;
            2'b10: alu_src2 = 32'd4; 
            default: alu_src2 = rf_data2;
        endcase
    end

    //rfmux 2->1
    always @(*)
    begin
        case (wb_sel)
            1'b0: rf_wdata = mem_rdata;
            1'b1: rf_wdata = alu_result;
            default: rf_wdata = mem_rdata;
        endcase
    end

    //PCmux 2->1
    always @(*)
    begin
        if(jump_en)
        begin
            npc = jump_target - 32'h8;//分支跳转时，流水线阻塞了两个周期，所以要减8
        end
        else if(PC_sel)
        begin
            npc = PC;
        end
        else
        begin
            npc = PC + 32'd4;
        end
    end

    //rf_data1 mux 2->1
    always@(*)
    begin
        case(rf_data1_sel)
            2'b00: rf_data1_r = rf_data1_rx;
            2'b01: rf_data1_r = alu_result_r;
            2'b10: rf_data1_r = alu_result_2r;
            2'b11: rf_data1_r = mem_rdata_r;
            default: rf_data1_r = rf_data1_rx;
        endcase
    end

    //rf_data2 mux 2->1
    always@(*)
    begin
        case(rf_data2_sel)
            2'b00: rf_data2_r = rf_data2_rx;
            2'b01: rf_data2_r = alu_result_r;
            2'b10: rf_data2_r = alu_result_2r;
            2'b11: rf_data2_r = mem_rdata_r;
            default: rf_data2_r = rf_data2_rx;
        endcase
    end

    //PC rst and jump
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            PC <= 32'h1c000000;
        end 
        else PC <= npc;
    end

    //mem_we mux 2->1
    always@(*)
    begin
        if(mem_we_sel)
            mem_we_r = 1'b0;
        else
            mem_we_r = mem_we_rx;
    end

    //rf_we mux 2->1
    always@(*)
    begin
        if(rf_we_sel)
            rf_we_r = 1'b0;
        else
            rf_we_r = rf_we_rx;
    end

    //inst mux 2->1判断是否hazard回去执行一下
    always@(*)
    begin
        if(inst_sel)
            inst_r = inst;
        else
            inst_r = inst_rx;
    end

    //br_type mux 2->1
    always@(*)
    begin
        if(br_type_sel)
            br_type_r = 1'b0;
        else
            br_type_r = br_type_rx;
    end

    //分支跳转
    branch branch(
    .PC(PC),
    .imm(imm),
    .rf_data1(rf_data1),
    .rf_data2(rf_data2),
    .br_type(br_type),
    .jump_en(jump_en_r),
    .jump_target(jump_target_r)
    );

    //运算单元
    ALU ALU(
    .f(alu_op),
    .a(alu_src1),
    .b(alu_src2),
    .y(alu_result_r)
    );

    //指令译码
    decoder decoder(
    .inst(inst),
    .rf_addr1(rf_addr1),
    .rf_addr2(rf_addr2),
    .rf_rd(rf_rd_r),
    .rf_we(rf_we_rx),
    .imm(imm_r),
    .alu_op(alu_op_r),
    .alu_src1_sel(alu_src1_sel_r),
    .alu_src2_sel(alu_src2_sel_r),
    .mem_we(mem_we_rx),
    .br_type(br_type_rx),
    .wb_sel(wb_sel_r)
    );

    //是否debug状态
    always @(*)
    begin
        if(debug)
            clk = clk_ld;
        else clk = clk_cpu;
    end

    //寄存器堆
    reg_files # (
        .ADDR_WIDTH(5),
        .DATA_WIDTH(32)
                )
    reg_files_inst (
        .clk(clk),
        .ra0(rf_addr1),
        .ra1(rf_addr2),
        .ra2(addr[4:0]),
        .rd0(rf_data1_rx),
        .rd1(rf_data2_rx),
        .rd2(dout_rf),
        .wa(rf_rd),
        .wd(rf_wdata),
        .we(rf_we)
        );

    //取写数据
    dram_data dram_data(
        .a(mem_addr),
        .d(mem_wdata),
        .spo(mem_rdata_r),
        .we(mem_we),
        .clk(clk),
        .dpra(addr[9:0]),
        .dpo(dout_dm)
        );

    //取、不能写指令
    dram_inst dram_inst(
        .a(PC[11:2]),//四个字节对应一个字 in looogarch
        .d(32'b0),
        .spo(inst_rx),
        .we(1'b0),
        .clk(clk),
        .dpra(addr[9:0]),
        .dpo(dout_im)
        );

endmodule
