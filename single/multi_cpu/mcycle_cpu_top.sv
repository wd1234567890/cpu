`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/20 12:47:13
// Design Name: 
// Module Name: mcycle_cpu_top
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


module mcycle_cpu_top(
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
    logic [1:0] alu_src1_sel;
    logic [1:0] alu_src2_sel;
    logic [31:0] inst_r;
    logic clk;
    logic [31:0] rf_data1_r;
    logic [31:0] rf_data2_r;
    logic [31:0] alu_result_r;
    logic rf_we_r;
    logic [4:0] rf_rd_r;
    logic [31:0] imm_r;
    logic [1:0] alu_src1_sel_r;
    logic [1:0] alu_src2_sel_r;
    logic [11:0] alu_op_r;
    logic mem_we_r;
    logic br_type_r;
    logic wb_sel_r;
    logic [31:0] rf_wdata;
    logic [31:0] rf_data1;
    logic [31:0] rf_data2;
    logic [5:0] state;
    logic [5:0] en;
    logic [4:0] rf_addr1;
    logic [4:0] rf_addr2;
    logic [11:0] alu_op;
    logic [9:0] mem_addr;
    logic [31:0] mem_wdata;
    logic mem_we;
    logic wb_sel;
    logic [4:0]rf_rd;
    logic rf_we;
    logic [31:0] mem_rdata_r;
    logic [31:0] jump_target_r;
    logic [31:0] jump_target;
    logic jump_en;
    logic jump_en_r;
    

    assign mem_addr = alu_result[11:2];
    assign mem_wdata = rf_data2;

    always @(*)
    begin
        if(debug)
            clk = clk_ld;
        else clk = clk_cpu;
    end

    logic start;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) 
        begin
            PC <= 32'h1c000000;
            start <= 1'b1;
        end 
        else if(start)
        begin
            start <= 1'b0;
        end
        else if(jump_en && state == 6'b0)
        begin
            PC <= jump_target; 
        end
        else if(state == 6'b0  && !start)
        begin
            PC <= PC + 32'd4;
        end
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

    //FSM
    FSM  FSM_inst (
    .clk(clk),
    .rstn(rstn),
    .inst(inst_r),
    .state(state),
    .en(en)
  );

    //指令译码
    decoder decoder(
    .inst(inst),
    .rf_addr1(rf_addr1),
    .rf_addr2(rf_addr2),
    .rf_rd(rf_rd_r),
    .rf_we(rf_we_r),
    .imm(imm_r),
    .alu_op(alu_op_r),
    .alu_src1_sel(alu_src1_sel_r),
    .alu_src2_sel(alu_src2_sel_r),
    .mem_we(mem_we_r),
    .br_type(br_type_r),
    .wb_sel(wb_sel_r)
    );

    //运算单元
    ALU ALU(
    .f(alu_op),
    .a(alu_src1),
    .b(alu_src2),
    .y(alu_result_r)
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
    .rd0(rf_data1_r),
    .rd1(rf_data2_r),
    .rd2(dout_rf),
    .wa(rf_rd),
    .wd(rf_wdata),
    .we(rf_we)
  );

    register # (
    .WIDTH(32),
    .RST_VAL(0)
  )
  register_inst (
    .clk(clk),
    .rstn(rstn),
    .en(en[0]),
    .d(inst_r),
    .q(inst)
  );

  register # (
    .WIDTH(32),
    .RST_VAL(0)
  )
  register_rfdata1 (
    .clk(clk),
    .rstn(rstn),
    .en(en[1]),
    .d(rf_data1_r),
    .q(rf_data1)
  );

  register # (
    .WIDTH(32),
    .RST_VAL(0)
  )
  register_rfdata2 (
    .clk(clk),
    .rstn(rstn),
    .en(en[1]),
    .d(rf_data2_r),
    .q(rf_data2)
  );

  register # (
    .WIDTH(32),
    .RST_VAL(0)
  )
  register_imm (
    .clk(clk),
    .rstn(rstn),
    .en(en[1]),
    .d(imm_r),
    .q(imm)
  );

  register # (
    .WIDTH(2),
    .RST_VAL(0)
  )
  register_alu_src1_sel (
    .clk(clk),
    .rstn(rstn),
    .en(en[1]),
    .d(alu_src1_sel_r),
    .q(alu_src1_sel)
  );

  register # (
    .WIDTH(2),
    .RST_VAL(0)
  )
  register_alu_src2_sel (
    .clk(clk),
    .rstn(rstn),
    .en(en[1]),
    .d(alu_src2_sel_r),
    .q(alu_src2_sel)
  );

  register # (
    .WIDTH(17),
    .RST_VAL(0)
  )
  register_ctl (
    .clk(clk),
    .rstn(rstn),
    .en(en[1]),
    .d({alu_op_r,mem_we_r,br_type_r,wb_sel_r}),
    .q({alu_op,mem_we,br_type,wb_sel})
  );

  register # (
    .WIDTH(32),
    .RST_VAL(0)
  )
  register_alures (
    .clk(clk),
    .rstn(rstn),
    .en(en[2]),
    .d(alu_result_r),
    .q(alu_result)
  );

  register # (
    .WIDTH(6),
    .RST_VAL(0)
  )
  register_rf_we (
    .clk(clk),
    .rstn(rstn),
    .en(en[1]),
    .d({rf_we_r,rf_rd_r}),
    .q({rf_we,rf_rd})
  );

  register # (
    .WIDTH(33),
    .RST_VAL(0)
  )
  register_jump (
    .clk(clk),
    .rstn(rstn),
    .en(en[2]),
    .d({jump_en_r,jump_target_r}),
    .q({jump_en,jump_target})
  );

  register # (
    .WIDTH(32),
    .RST_VAL(0)
  )
  register_mem_rdata (
    .clk(clk),
    .rstn(rstn),
    .en(en[3]),
    .d(mem_rdata_r),
    .q(mem_rdata)
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
    .a(PC[11:2]),
    .d(32'b0),
    .spo(inst_r),
    .we(1'b0),
    .clk(clk),
    .dpra(addr[9:0]),
    .dpo(dout_im)
    );

    //branch
    branch branch(
    .PC(PC),
    .imm(imm),
    .rf_data1(rf_data1),
    .rf_data2(rf_data2),
    .br_type(br_type),
    .jump_en(jump_en_r),
    .jump_target(jump_target_r)
    );

endmodule
