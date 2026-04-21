ORG 0x100

LEN:     WORD 5
CH0:     WORD 0
CH1:     WORD 0
CH2:     WORD 0
CH3:     WORD 0
CH4:     WORD 0
PTR:     WORD $CH0
CH_TMP:  WORD 0
DAY:     WORD 0
MON:     WORD 0
DAYNUM:  WORD 0
MOFFADR: WORD $MOFF
DTABADR: WORD $DTAB
WDAY:    WORD 0
STRPTR:  WORD 0
NUMNUM:  WORD 0
NUMNUM2: WORD 0
SMILE:   WORD 0x3A28
SMILF:   WORD 0x0A


START:  CLA

FIRST:
WAIT:  IN   0x19
        AND  #0x40
        BEQ  WAIT
        IN   0x18
        ST   CH_TMP
        LD   LEN
        CMP  #0x03
        BEQ  CKDOT
        JUMP CKDIG

CKDOT:  LD   CH_TMP
        CMP  #0x2E
        BNE  FIRST
        JUMP SAVE

CKDIG:  LD   CH_TMP
        CMP  #0x30
        BCC  FIRST
        CMP  #0x3A
        BCs FIRST

SAVE:   LD   CH_TMP
        ST   (PTR)+
        LOOP LEN
        JUMP FIRST
        JUMP SECOND

SECOND:
WENTER: IN   0x19
        AND  #0x40
        BEQ  WENTER
        IN   0x18
        CMP  #0x0A
        BEQ  VALIDATE
        JUMP ERROUT

VALIDATE:
        LD   CH0
        SUB  #0x30
        ST   CH0
        LD   CH1
        SUB  #0x30
        ST   CH1
        LD   CH3
        SUB  #0x30
        ST   CH3
        LD   CH4
        SUB  #0x30
        ST   CH4
        LD   CH0
        ST   $NUMNUM
        CALL $MUL10
        LD   $NUMNUM
        ADD  CH1
        ST   DAY
        LD   CH3
        ST   $NUMNUM
        CALL $MUL10
        LD   $NUMNUM
        ADD  CH4
        ST   MON
        LD   MON
        CMP  #0x01
        BCC  ERROUT
        LD   MON
        CMP  #0x0D
        BCs ERROUT
        LD   DAY
        CMP  #0x01
        BCC  ERROUT
        LD   MON
        CMP  #0x02
        BNE  CKMON
        LD   DAY
        CMP  #0x1D
        BCs ERROUT
        JUMP DATEOK

CKMON: LD   MON
        CMP  #0x04
        BEQ  CHK30
        CMP  #0x06
        BEQ  CHK30
        CMP  #0x09
        BEQ  CHK30
        CMP  #0x0B
        BEQ  CHK30
        LD   DAY
        CMP  #0x20
        BCs ERROUT
        JUMP DATEOK

CHK30:  LD   DAY
        CMP  #0x1F
        BCs ERROUT

DATEOK:
        LD   MON
        SUB  #0x01
        ADD  MOFFADR
        ST   STRPTR
        LD   (STRPTR)
        ADD  DAY
        SUB  #0x01
        ST   DAYNUM
        LD   DAYNUM
        ADD  #0x03
        ST   WDAY

MOD7:   LD   WDAY
        CMP  #0x07
        BCC  MOD7DONE
        SUB  #0x07
        ST   WDAY
        JUMP MOD7

MOD7DONE:
        LD   WDAY
        ADD  DTABADR
        ST   STRPTR
        LD   (STRPTR)
        ST   STRPTR

PRINT:  LD   (STRPTR)+
        BEQ  DONE
        SWAB
        ST   WTMP     

W1:     IN   0x0D
        AND  #0x40
        BEQ  W1
        LD WTMP
        OUT  0x0C      

W2:     IN   0x0D
        AND  #0x40
        BEQ  W2
        LD WTMP
        SWAB
        OUT  0x0C        
        JUMP PRINT

DONE:   HLT

WTMP:   WORD 0 

ERROUT:
WE1:    IN   0x0D
        AND  #0x40
        BEQ  WE1
        LD   $SMILE
        SWAB         
        OUT  0x0C
WE2:    IN   0x0D
        AND  #0x40
        BEQ  WE2
        LD   $SMILE
        OUT  0x0C    
WE3:    IN   0x0D
        AND  #0x40
        BEQ  WE3
        LD   $SMILF
        OUT  0x0C   
        HLT

MUL10:  LD   $NUMNUM
        ASL
        ST   $NUMNUM2
        LD   $NUMNUM
        ASL
        ASL
        ASL
        ADD  $NUMNUM2
        ST   $NUMNUM
        RET


MOFF:   WORD 0,31,59,90,120,151,181,212,243,273,304,334

DTAB:   WORD $S_MON
        WORD $S_TUE
        WORD $S_WED
        WORD $S_THU
        WORD $S_FRI
        WORD $S_SAT
        WORD $S_SUN

S_MON:  WORD 0x4D6F,0x6E0A,0x0000
S_TUE:  WORD 0x5475,0x650A,0x0000
S_WED:  WORD 0x5765,0x640A,0x0000
S_THU:  WORD 0x5468,0x750A,0x0000
S_FRI:  WORD 0x4672,0x690A,0x0000
S_SAT:  WORD 0x5361,0x740A,0x0000
S_SUN:  WORD 0x5375,0x6E0A,0x0000
