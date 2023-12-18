`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/14 12:57:20
// Design Name: 
// Module Name: branch
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


module branch(
    input [31:0]PC,
    input [31:0]imm,
    input [31:0]rf_data1,
    input [31:0]rf_data2,
    input br_type,
    output logic jump_en,
    output logic [31:0]jump_target
    );

    always @(*)
    begin
        case (br_type)
            1'b1:begin
                if(rf_data1 != rf_data2)
                begin
                    jump_en = 1'b1;
                    jump_target = PC + imm;
                end
                else
                begin
                    jump_en = 1'b0;
                    jump_target = 32'b0;
                end
            end 
            default: begin
                jump_en = 1'b0;
                jump_target = 32'b0;
            end
        endcase
    end
endmodule
