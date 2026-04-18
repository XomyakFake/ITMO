ORG 0x100

LEN:    WORD 5
CH0:    WORD 0    ; цифра 1 дня
CH1:    WORD 0    ; цифра 2 дня
CH2:    WORD 0    ; точка
CH3:    WORD 0    ; цифра 1 месяца
CH4:    WORD 0    ; цифра 2 месяца
PTR:    WORD $CH0 
CH_TMP: WORD 0
DAY:    WORD 0
MON:    WORD 0
SMILE:  WORD 0x3A28
SMILF:  WORD 0x0A
NUMNUM: WORD 0
NUMNUM2: WORD 0

PRTMP: WORD 0


MOFFADR: WORD $MOFF
DTABADR: WORD $DTAB
WDAY: WORD 0

STRPTR:  WORD 0

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


START:  CLA

INLOOP:
WAIT8:  IN   0x19
        AND  #0x40
        BEQ  WAIT8
        IN   0x18

        ST   CH_TMP      ; сохраняем символ во временную
        LD   LEN
        CMP  #0x03
        BEQ  CKDOT       ; позиция 2 → проверяем точку
        JUMP CKDIG       ; иначе → проверяем цифру


CKDOT:  LD   CH_TMP
        CMP  #0x2E       ; '.' = 0x2E
        BNE  INLOOP      ; не точка — игнорируем
        JUMP SAVE        ; точка — сохраняем

CKDIG:  LD   CH_TMP
        CMP  #0x30       ; '0' = 0x30
        BСS  INLOOP      ; меньше '0' — игнорируем
        CMP  #0x39       ; '9' = 0x39
        BCC INLOOP      ; больше '9' — игнорируем (BHIS = >=, т.е. > 0x39 не пройдёт)

SAVE:   LD   CH_TMP
        ST   (PTR)+      ; сохраняем по указателю, PTR++
        LOOP LEN
        JUMP INLOOP
        JUMP AFTERINP

AFTERINP:
WENTER:
      IN 0x19
      AND #0x40
      BEQ WENTER
      IN 0x18
      CMP #0x0A
      BEQ VALIDATE
      JUMP ERROUT

VALIDATE: 
      LD CH0
      SUB #0x30
      ST CH0

      LD CH1
      SUB #0x30
      ST CH1

      LD CH3
      SUB #0x30
      ST CH3

      LD CH4
      SUB #0x30
      ST CH4

      LD   CH0
      ST   NUMNUM
      CALL $MUL10
      LD   NUMNUM
      ADD  CH1
      ST   DAY

      LD   CH3
      ST   NUMNUM
      CALL $MUL10
      LD   NUMNUM
      ADD  CH4
      ST   MON

      LD   MON
      CMP  #0x01
      BCS  ERROUT

      LD   MON
      CMP  #0x0D      ; 13
      BCC ERROUT

      LD   DAY
      CMP  #0x01
      BCS  ERROUT

      LD   MON
      CMP  #0x02
      BNE  NOTFEB
      LD   DAY
      CMP  #0x1D      ; 29
      BCC ERROUT
      JUMP DATEOK



NOTFEB:
        ; Месяцы с 30 днями: 4,6,9,11
        LD   MON
        CMP  #0x04
        BEQ  CHK30
        CMP  #0x06
        BEQ  CHK30
        CMP  #0x09
        BEQ  CHK30
        CMP  #0x0B
        BEQ  CHK30
        ; Остальные — 31 день
        LD   DAY
        CMP  #0x20      ; 32
        BCC ERROUT
        JUMP DATEOK

CHK30:  LD   DAY
        CMP  #0x1F      ; 31
        BCC ERROUT


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

MOD7:    LD   WDAY
         CMP  #0x07
         BCS  MOD7DONE
         SUB  #0x07
         ST   WDAY
         JUMP MOD7

MOD7DONE:
         LD   WDAY
         ADD  DTABADR
         ST   STRPTR
         LD   (STRPTR)
         ST   STRPTR

PRINT:
      LD(STRPTR)+
      BEQ PEND
      SWAB
W1:
      IN 0x0D
      AND  #0x40
      BEQ W1
      OUT  0x0C  
      SWAB
W2:     IN   0x0D
        AND  #0x40
        BEQ  W2
        OUT  0x0C        
        JUMP PRNT
      

PEND:   HLT

ERROUT: 
WE1:    IN   0x0D
        AND  #0x40
        BEQ  WE1
        LD   SMILE
        OUT  0x0C
WE2:    IN   0x0D
        AND  #0x40
        BEQ  WE2
        LD   SMILF
        OUT  0x0C    
        HLT



ORG 0x300
MUL10:  LD   NUMNUM     ; берём число
        ASL             ; *2
        ST   NUMNUM2
        LD   NUMNUM
        ASL
        ASL
        ASL             ; *8
        ADD  NUMNUM2    ; *8 + *2 = *10
        ST   NUMNUM     ; результат обратно в NUMNUM
        RET
    

      




