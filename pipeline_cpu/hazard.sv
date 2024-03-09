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
    input mem_we_r,
    input wb_sel_r,
    input br_type_r,
    output logic PC_sel,
    output logic rf_we_sel,
    output logic mem_we_sel
    );

    always @(*)
    begin
        if(jump_en || jump_en_r || jump_en_l)
        begin
            PC_sel = 1'b1;
            rf_we_sel = 1'b1;
            mem_we_sel = 1'b1;
        end
        else if(rf_addr1 == rf_rd_2r && !mem_we_r && !wb_sel_r && !br_type_r)
        begin
            PC_sel = 1'b1;
            rf_we_sel = 1'b1;
            mem_we_sel = 1'b1;
        end
        else 
        begin
            PC_sel = 1'b0;
            rf_we_sel = 1'b0;
            mem_we_sel = 1'b0;
        end
    end

    

endmodule
