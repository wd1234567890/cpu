`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/09 12:39:15
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
    input [11:0]op,
    input br_type,
    output logic jump_en,
    output logic [31:0]jump_target
    );

    logic [31:0]alu_result;

    ALU alu_branch(
        .f(op),
        .a(rf_data1),
        .b(rf_data2),
        .y(alu_result)
    );

    always @(*)
    begin
        case (br_type)
            1'b1:begin
                if(op == 12'b0)
                begin
                    jump_en = 1'b1;
                    jump_target = rf_data1 + imm;
                end
                else if(alu_result == 32'b0)
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
