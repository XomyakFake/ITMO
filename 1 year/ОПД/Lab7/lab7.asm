ORG 0x19E
RES: WORD 0x0000
CHECK1: WORD 0x0000
CHECK2: WORD 0x0000
ARG1:   WORD 0x0000
ARG2:   WORD 0x0000
ARG3:   WORD 0x1234
ARG4:   WORD 0x5678

START:  CALL TEST1
        CALL TEST2
        LD #0x1
        AND CHECK1
        AND CHECK2
        ST RES
STOP:   HLT

TEST1:  LD ARG1
        PUSH
        LD ARG2
        PUSH
        WORD 0x0F20  ;SWASP
        POP
        CMP ARG1       
        BNE ERROR1
        POP
        CMP ARG2     
        BEQ DONE1
ERROR1: CLA
        RET
DONE1:  LD #0x1
        ST CHECK1
        CLA
        RET

TEST2:  LD ARG3
        PUSH
        LD ARG4
        PUSH
        WORD 0x0F20  ;SWASP
        POP
        CMP ARG3       
        BNE ERROR2
        POP
        CMP ARG4      
        BEQ DONE2
ERROR2: CLA
        RET
DONE2:  LD #0x1
        ST CHECK2
        CLA
        RET
