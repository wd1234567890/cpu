`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/09 15:47:56
// Design Name: 
// Module Name: hazard
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


module hazard(
    input jump_en,
    input jump_en_r,
    input jump_en_l,
    input [4:0] rf_addr1,
    input [4:0] rf_addr2,
    input [4:0] rf_rd_2r,
    input mem_we_2r,
    input wb_sel_2r,
    input br_type,
    output logic PC_sel,
    output logic rf_we_sel,
    output logic mem_we_sel,
    output logic inst_sel,
    output logic br_type_sel
    //output logic jump_en_sel
    );

    always @(*)//PC应该在阻塞后就正常了，我还没正常
    begin
        if(jump_en || jump_en_r)
        begin
            PC_sel = 1'b1;
            rf_we_sel = 1'b1;
            mem_we_sel = 1'b1;
            inst_sel = 1'b1;
            br_type_sel = 1'b1;
            //jump_en_sel = 1'b1;
        end
        else if(jump_en_l)
        begin
            PC_sel = 1'b0;
            rf_we_sel = 1'b1;
            mem_we_sel = 1'b1;
            inst_sel = 1'b0;
            br_type_sel = 1'b1;
        end
        //rf_rd为0是没有实际意义，无法写，但可能造成hazard检测错误
        else if(rf_addr1 == rf_rd_2r && rf_rd_2r != 5'b0 && !mem_we_2r && !wb_sel_2r && !br_type)
        begin
            PC_sel = 1'b1;
            rf_we_sel = 1'b1;
            mem_we_sel = 1'b1;
            inst_sel = 1'b1;
            br_type_sel = 1'b1;
            //jump_en_sel = 1'b1;
        end
        else if(rf_addr2 == rf_rd_2r && rf_rd_2r != 5'b0 && !mem_we_2r && !wb_sel_2r && !br_type)
        begin
            PC_sel = 1'b1;
            rf_we_sel = 1'b1;
            mem_we_sel = 1'b1;
            inst_sel = 1'b1;
            br_type_sel = 1'b1;
            //jump_en_sel = 1'b1;
        end
        else 
        begin
            PC_sel = 1'b0;
            rf_we_sel = 1'b0;
            mem_we_sel = 1'b0;
            inst_sel = 1'b0;
            br_type_sel = 1'b0;
            //jump_en_sel = 1'b0;
        end
    end

    

endmodule
