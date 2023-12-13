`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/19 20:52:07
// Design Name: 
// Module Name: RIF
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


module RIF(
    input clk,
    input rst,
    input rx_rdy,
    input rxd,
    output logic en,
    output logic [7:0] dout
    );
    logic [3:0] cnt1;
    logic start;
    logic rdy1,rdy2,rdy;
    logic cnt_start;
    logic nvld;
    logic [7:0] cnt2;
    logic [4:0] cnt3;//计数16周期
    logic [3:0] cnt4;//计数8数据
    logic rx_vld;
    logic [3:0] en_cnt;
    logic en_start;

    // always @(posedge clk or negedge rst)
    // begin
    //     if(~rst) 
    //     begin
    //         rdy1 <= 1'b0;
    //         rdy2 <= 1'b0;
    //     end
    //     else
    //     begin
    //         rdy1 <= rx_rdy;
    //         rdy2 <= rdy1;
    //     end
    // end

    // assign rdy = !rdy1 & rdy2;



    always @(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            cnt1 <= 4'b1000;
        end
        else if(nvld)
            begin
                cnt1 <= 4'b1000;
            end
        else if(cnt_start)
            begin
                cnt1 <= cnt1 - 1'b1;
            end
        else cnt1 <= 4'b1000;     
    end

    //判断什么时候算起始成功


    always @(posedge clk or negedge rst)
    begin
        if(!rst)
        cnt2 <= 8'b10010000;
        else if(cnt2 == 8'b0)
            cnt2 <= 8'b10010000;
        else if(nvld)
            cnt2 <= cnt2 - 1'b1;
        else cnt2 <= 8'b10010000;
        end

    always @(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            cnt3 <= 5'b01111;
        end
        else if(cnt3 == 5'b0)
            cnt3 <= 5'b01111;
        else if(start)
            begin
                cnt3 <= cnt3 - 1'b1;
            end
        else cnt3 <= 5'b01111;
        end

    always @(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            en_cnt <= 4'b1111;
        end
        else if(en_cnt == 4'b0)
            begin
                en_cnt <= 4'b1111;
            end
        else if(en_start)
            begin
                en_cnt <= en_cnt - 1'b1;
            end
    end

    always @(posedge clk or negedge rst)
    begin
        if(!rst)
        begin 
            cnt4 <= 4'b1000;
            rx_vld <= 1'b1;
            dout <= 8'b0;
            start <= 1'b0;
            nvld <= 1'b0;
            en <= 1'b1;
            cnt_start <= 1'b0;
            en_start <= 1'b0;
        end
        else if(nvld)
            begin
                start <= 1'b0;
                cnt_start <= 1'b0;
            end
        else if(en_cnt == 4'b0)
            begin
                en_start <= 1'b0;
                en <= 1'b1;
            end
        else if(cnt2 == 8'b0)
                begin
                    nvld <= 1'b0;
                    rx_vld <= 1'b0;
                end
        else if(!rxd & en)
                begin
                    cnt_start <= 1'b1;
                    en <= 1'b0;
                end
        else if(cnt1 == 4'b001)
                cnt_start <= 0;
        else if(cnt1 == 4'b0 & !rxd)
                begin
                    start <= 1'b1;
                    dout <= 8'b0;//复位一下，应该在终止位就把接收的数打出来，这是在起始位才进行的复位
                    rx_vld <= 1'b0;
                end
        else if(cnt1 == 4'b0 & rxd)
                nvld <= 1'b1;
        else if(cnt4 == 4'b0)
            begin
                start <= 1'b0;
                cnt4 <= 4'b1000;
                rx_vld <= 1'b1;
                en_start <= 1'b1;
            end
        else if(cnt3 == 5'b0)
            begin
                dout <= {rxd,dout[7:1]};
                cnt4 <= cnt4 - 1'b1;
            end
        else cnt4 <= cnt4;
        end
    
endmodule
