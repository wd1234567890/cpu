#include "regdef.h"
#include "cpu_cde.h"

.global main
main:
    addi.w s3, zero, 0x0
    bl n1_lu12i_w_test
    bl n2_add_w_test
    bl n3_addi_w_test
    bl n4_sub_w_test
    bl n5_slt_test
    bl n6_sltu_test
    bl n7_and_test
    bl n8_or_test
    bl n9_xor_test
    bl n10_nor_test
    bl n11_slli_w_test
    bl n12_srli_w_test
    bl n13_srai_w_test

    bl n14_ld_w_test
    bl n15_st_w_test

    bl n16_beq_test
    bl n17_bne_test
    bl n18_bl_test
    bl n19_jirl_test
    bl n20_b_test

    bl n21_pcaddu12i_test
    bl n22_slti_test
    bl n23_sltui_test
    bl n24_andi_test
    bl n25_ori_test
    bl n26_xori_test
    bl n27_sll_w_test
    bl n28_sra_w_test
    bl n29_srl_w_test

    bl n37_blt_test
    bl n38_bge_test
    bl n39_bltu_test
    bl n40_bgeu_test

    bl n41_ld_b_test
    bl n42_ld_h_test
    bl n43_ld_bu_test
    bl n44_ld_hu_test
    bl n45_st_b_test
    bl n46_st_h_test
    
    addi.w a0, zero, 0x0
    .word 0x80000000


.global inst_correct
inst_correct: 
    jirl zero, ra, 0
    nop
    
.global inst_fail
inst_fail:
    beq zero, zero, inst_fail;
    nop



