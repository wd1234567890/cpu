#include "asm.h"
#include "regdef.h"
#include "inst_test.h"

LEAF(n46_st_h_test)
    addi.w  s3, s3, 1
    addi.w s0, s0, 1
    li.w  s2, 0x0
###test inst
    TEST_ST_H(0xe15f8848, 0x0e1a3600, 0x1c0d52a4, 0x0000ade, 0x0000adc, 0x36008848)
    TEST_ST_H(0x04105cf0, 0xb64d5300, 0x1c0d3f6c, 0x000056a, 0x0000568, 0x53005cf0)
    TEST_ST_H(0xd187bd18, 0xa1cf708e, 0x1c0db7a0, 0x0000bf4, 0x0000bf4, 0xd187708e)
    TEST_ST_H(0xb5abcbf4, 0xee02bbc2, 0x1c0d6188, 0x0000e44, 0x0000e44, 0xb5abbbc2)
    TEST_ST_H(0x6b04bf60, 0x306960f0, 0x1c0d8d40, 0x0000580, 0x0000580, 0x6b0460f0)
    TEST_ST_H(0x2532d240, 0xfe00ebf6, 0x1c0d7090, 0x0000086, 0x0000084, 0xebf6d240)
    TEST_ST_H(0x2b61ec90, 0x28bde000, 0x1c0d24e0, 0x00004d6, 0x00004d4, 0xe000ec90)
    TEST_ST_H(0xa52de360, 0xf5699820, 0x1c0d3b4c, 0x0000e50, 0x0000e50, 0xa52d9820)
    TEST_ST_H(0x7978aff8, 0xa69f3ca0, 0x1c0d2968, 0x0000364, 0x0000364, 0x79783ca0)
    TEST_ST_H(0xc4ddc7df, 0x0a66bf0c, 0x1c0dad70, 0x00002bc, 0x00002bc, 0xc4ddbf0c)
    TEST_ST_H(0xd6ef145e, 0x27d4869c, 0x1c0d1500, 0x00008b6, 0x00008b4, 0x869c145e)
###detect exception
    beq s2, zero, inst_correct
    beq zero, zero, inst_fail
END(n46_st_h_test)
