ORG 0x410

ADR:    WORD $RES
CNT:    WORD 0
TEMP:   WORD 0
MASK:   WORD 0x00FF 

START:  CLA
        LD  (ADR)+
        AND MASK
        ST  CNT

LEN:    IN  3
        AND #0x40
        BEQ LEN
        LD  CNT
        OUT 2

NEXT:   LD  CNT
        CMP #0x00
        BEQ DONE

        LD  (ADR)+
        ST  TEMP

SYM1:   IN  3
        AND #0x40
        BEQ SYM1
        LD  TEMP
        OUT 2

       	LOOP CNT
        JUMP SYM2
	    JUMP DONE

SYM2:   IN  3
        AND #0x40
        BEQ SYM2
        LD  TEMP
        SWAB
        OUT 2

       	LOOP CNT
        JUMP NEXT
	    JUMP DONE

DONE:   HLT

ORG 0x5A5

RES: WORD 0
