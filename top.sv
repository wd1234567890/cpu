`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/09 22:46:41
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
    input  logic         clk,      // 时钟信号
    input  logic         rstn,      // 复位信号


    input [15:0]        x,              //sw15-0
	input               ent,            //btnc按会使数输入到寄存器
    input               del,            //btnl
    input               step,           //btnr
	input               pre,            //btnu	
    input               nxt,            //btnd
    output [15:0]       taddr,          //led15-0 
    output [2:0]        flag,           //led 16 15-0，指示数码管显示的数据类型
    output logic  [ 7:0] an,        // 数码管位选信号
    output logic  [ 6:0] seg,       // 数码管段选信号
    output logic         td,         // 定时器到时信号，接入任何一个led灯即可    
    output logic        txd,
    input logic        rxd
    );

    logic [31:0] T;//输入
    logic [31:0] q;
    logic yl, yp,yl1,yp1,yl2,yp2,yp3,yl3,yl4,yp4;
    logic [31:0] w,v,w1;
//    logic st;

    wire [31:0]  tdout;
    reg [31:0] tdin;
    wire twe;

    wire rst,tclk;

    logic [7:0] din;
    logic tx_vld;
    logic tx_rdy;

    logic [79:0] din_8;

    logic [31:0] cnt;
    logic [3:0] cnt1;
    logic start;

    logic step_p;

    logic [31:0] x1;

    UTU  UTU_inst (
    .clk(clk),
    .clk1(yp),
    .rstn(rstn),
    .x(x),
    .ent(ent),
    .del(del),
    .step(step),
    .pre(pre),
    .nxt(nxt),
    .taddr(taddr),
    .tdin(tdin),
    .tdout(tdout),
    .twe(twe),
    .flag(flag),
    .an(an),
    .seg(seg),
    .rst(rst),
    .tclk(tclk),
    .step_p(step_p)
  );

  register# ( .WIDTH(32), .RST_VAL(0))
  register_inst_src1 (
      .clk    (clk),
      .rst    (rstn),
      .en     (taddr == 16'h1 && twe),
      .d      (tdout),
      .q      (T)
  );

  register# ( .WIDTH(32), .RST_VAL(0))
  register_inst_src2 (
      .clk    (clk),
      .rst    (rstn),
      .en     (taddr == 16'h2 && twe),
      .d      (tdout),
      .q      (x1)
  );


    TFD  TFD_inst1 (
    .k(32'b00000000000000000010011100010000),
    .clk(clk),
    .rst(rstn),
    .st(1'b1),
    .q(w),
    .yl(yl),
    .yp(yp)
  );
    
    TFD TFD_inst2 (
    .k(32'b00000000011110100001001000000000),
    .clk(clk),
    .rst(rstn),
    .st(1'b1),
    .q(v),
    .yl(yl1),
    .yp(yp1)
    );

    TFD TFD_inst3 (
    .k(32'b00000000000000000010100010110000),//1/9600波特率
    //.k(2),
    .clk(clk),
    .rst(rstn),
    .st(1'b1),
    .q(w1),
    .yl(yl2),
    .yp(yp2)
    );

    TFD TFD_inst4(
        .k(32'd650),
        .clk(clk),
        .rst(rstn),
        .st(1'b1),
        .q(asd),
        .yl(yl4),
        .yp(yp4)
    );

    logic [31:0] asd;
//     seg  seg_inst (
//     .clk(yp),
//     .rst(rstn),
//     .data(q),
//     .an_t(an),
//     .seg_t(seg)
//   );

    TFD TIF_TFD (
    .k(4'b1010),
    .clk(yp2),
    .rst(rstn),
    .st(start),
    .q(cnt),
    .yl(yl3),
    .yp(yp3)
    );

    //数字转化为ASCII码
    logic [63:0] asc;
    always @(*)
    begin
        if(x1[3:0] < 4'ha)
            asc[7:0] = {4'b0,x1[3:0]} + 8'h30;
        else
            asc[7:0] = {4'b0,x1[3:0]} + 8'h37;
    end

    always @(*)
    begin
        if(x1[7:4] < 4'ha)
            asc[15:8] = {4'b0,x1[7:4]} + 8'h30;
        else
            asc[15:8] = {4'b0,x1[7:4]} + 8'h37;
    end

    always @(*)
    begin
        if(x1[11:8] < 4'ha)
            asc[23:16] = {4'b0,x1[11:8]} + 8'h30;
        else
            asc[23:16] = {4'b0,x1[11:8]} + 8'h37;
    end

    always @(*)
    begin
        if(x1[15:12] < 4'ha)
            asc[31:24] = {4'b0,x1[15:12]} + 8'h30;
        else
            asc[31:24] = {4'b0,x1[15:12]} + 8'h37;
    end

    always @(*)
    begin
        if(x1[19:16] < 4'ha)
            asc[39:32] = {4'b0,x1[19:16]} + 8'h30;
        else
            asc[39:32] = {4'b0,x1[19:16]} + 8'h37;
    end

    always @(*)
    begin
        if(x1[23:20] < 4'ha)
            asc[47:40] = {4'b0,x1[23:20]} + 8'h30;
        else
            asc[47:40] = {4'b0,x1[23:20]} + 8'h37;
    end

    always @(*)
    begin
        if(x1[27:24] < 4'ha)
            asc[55:48] = {4'b0,x1[27:24]} + 8'h30;
        else
            asc[55:48] = {4'b0,x1[27:24]} + 8'h37;
    end

    always @(*)
    begin
        if(x1[31:28] < 4'ha)
            asc[63:56] = {4'b0,x1[31:28]} + 8'h30;
        else
            asc[63:56] = {4'b0,x1[31:28]} + 8'h37;
    end


    // always @(posedge clk or negedge rstn)
    // begin
    //     if(!rstn)
    //     begin
    //         start <= 1'b0;
    //         tx_vld <= 1'b0;
    //     end
    //     else if(step_p)
    //     begin
    //         start <= 1'b1;
    //         tx_vld <= 1'b1;
    //     end
    //     else if(cnt1 == 4'b0)
    //         begin
    //         start <= 1'b0;
    //         tx_vld <= 1'b0;
    //         end
    //         else start <= start;
    // end
    logic [3:0]c;


    always @(posedge clk or negedge rstn)
    begin
        if(!rstn)
        begin
            cnt1 <= 4'b0;
            c <= 4'b0;
        end
        else if(step_p)
            begin
                din_8 <= {8'ha, 8'hd, asc};
                cnt1 <= 4'b1010;
                c <= 4'b1011;
            end
        else if(c == 4'b0)
            begin
                tx_vld <= 1'b0;
            end
        else if(yp2 && cnt1 == 4'b0)
            begin
                cnt1 <= 4'b1010;
                c <= c - 1'b1;
                tx_vld <= 1'b1;
                din <= din_8[7:0];
                din_8 <= {din_8[7:0],din_8[79:8]};
            end
        else if(yp2 && cnt1 == 4'b0011)
            begin
                tx_vld <= 1'b0;
                cnt1 <= cnt1 - 1'b1;
            end
        else if(yp2 && cnt1 != 4'b0 )
            begin
                cnt1 <= cnt1 - 1'b1;
            end
        
    end
    

    // always @(posedge clk or negedge rstn)
    // begin
    //     if(!rstn)
    //     begin
    //         cnt1 <= 4'b1010;
    //         din_8 <= 80'b0;
    //     end
    //     else if(step_p)
    //     begin
    //         din_8 <= {8'ha, 8'hd, asc};
    //         start <= 1'b1;
    //     end
    //     else if(cnt1 != 4'b0)
    //         begin
    //             cnt1 <= cnt1 - 1'b1;
    //         end
    //     else if(step_p)
    //     begin
    //         cnt1 <= 4'b1010;
    //         tx_vld <= 1'b1;
    //         din <= din_8[7:0];
    //         din_8 <= {din_8[7:0],din_8[79:8]};
    //         // cnt1 <= cnt1 - 1'b1; 
    //     end 
    //     else if(ent && taddr == 16'h3)
    //     begin
    //         start <= 1'b0;
    //         tx_vld <= 1'b0;
    //     end
    //     else cnt1 <= cnt1;
    //     // else if(cnt1 == 4'b0)
    //     //     cnt1 <= 4'b1010;
    //     // else cnt1 <= cnt1;
    // end

    timer  timer_inst (
    .clk(yp1),
    .rst(rstn),
    .k(T),
    .st(ent && taddr == 16'h1),
    .q(q),
    .td(td)
  );

  TIF  TIF_inst (
    .clk(yp2),
    .rst(rstn),
    .din(din),
    .tx_vld(tx_vld),
    .tx_rdy(tx_rdy),
    .txd(txd)
  );

//   always @(posedge yp1 or negedge rstn)
//   begin
//     if(!rstn)
//         st <= 1'b0;
//     else if(taddr == 16'h2 && twe)
//         st <= 1'b1;
//     else if(st)
//         st <= 1'b0;
//     else st <= st;
//   end

  logic [7:0] dout;

  RIF  RIF_inst (
    .clk(yp4),
    .rst(rstn),
    .rx_rdy(1'b1),
    .rxd(rxd),
    .en(rx_vld),
    .dout(dout)
  );

  logic rx_vld;
  logic [31:0] ddd;
  logic [1:0] sstart;

  always @(posedge yp4 or negedge rstn)
  begin
    if(!rstn)
        begin
            ddd <= 32'hf0f0ffff;
            sstart <= 2'b00;
        end
    else if(rx_vld && sstart == 2'b00)
        begin
            ddd[7:0] <= dout;
            ddd[31:8] <= ddd[23:0];
            sstart <= 2'b11;
        end
        else if(!rx_vld && sstart != 2'b00)
            sstart <= sstart - 1'b1;
  end

  always@(*) begin
    case(taddr)
    16'h0:   tdin = q;
    16'h1:   tdin = T;
    16'h2:   tdin = x1;
    16'h3:   tdin = ddd;
    default: tdin = 0;
    endcase
end
endmodule
