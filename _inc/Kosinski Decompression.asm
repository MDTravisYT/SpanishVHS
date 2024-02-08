;===============================================================================
; Rotina de descompressão no formato Kosinski
; ->>>
;=============================================================================== 
KosinskiDec:                                                   ; Offset_0x001AB0
                subq.l  #$02, A7
                move.b  (A0)+, $0001(A7)
                move.b  (A0)+, (A7)
                move.w  (A7), D5
                moveq   #$0F, D4
Offset_0x001ABC:
                lsr.w   #$01, D5
                move    SR, D6
                dbra    D4, Offset_0x001ACE
                move.b  (A0)+, $0001(A7)
                move.b  (A0)+, (A7)
                move.w  (A7), D5
                moveq   #$0F, D4
Offset_0x001ACE:
                move    D6, CCR
                bcc.s   Offset_0x001AD6
                move.b  (A0)+, (A1)+
                bra.s   Offset_0x001ABC
Offset_0x001AD6:
                moveq   #$00, D3
                lsr.w   #$01, D5
                move    SR, D6
                dbra    D4, Offset_0x001AEA
                move.b  (A0)+, $0001(A7)
                move.b  (A0)+, (A7)
                move.w  (A7), D5
                moveq   #$0F, D4
Offset_0x001AEA:
                move    D6, CCR
                bcs.s   Offset_0x001B1A
                lsr.w   #$01, D5
                dbra    D4, Offset_0x001AFE
                move.b  (A0)+, $0001(A7)
                move.b  (A0)+, (A7)
                move.w  (A7), D5
                moveq   #$0F, D4
Offset_0x001AFE:
                roxl.w  #$01, D3
                lsr.w   #$01, D5
                dbra    D4, Offset_0x001B10
                move.b  (A0)+, $0001(A7)
                move.b  (A0)+, (A7)
                move.w  (A7), D5
                moveq   #$0F, D4
Offset_0x001B10:
                roxl.w  #$01, D3
                addq.w  #$01, D3
                moveq   #-$01, D2
                move.b  (A0)+, D2
                bra.s   Offset_0x001B30
Offset_0x001B1A:
                move.b  (A0)+, D0
                move.b  (A0)+, D1
                moveq   #-$01, D2
                move.b  D1, D2
                lsl.w   #$05, D2
                move.b  D0, D2
                andi.w  #$0007, D1
                beq.s   Offset_0x001B3C
                move.b  D1, D3
                addq.w  #$01, D3
Offset_0x001B30:
                move.b  $00(A1, D2), D0
                move.b  D0, (A1)+
                dbra    D3, Offset_0x001B30
                bra.s   Offset_0x001ABC
Offset_0x001B3C:
                move.b  (A0)+, D1
                beq.s   Offset_0x001B4C
                cmpi.b  #$01, D1
                beq     Offset_0x001ABC
                move.b  D1, D3
                bra.s   Offset_0x001B30
Offset_0x001B4C:
                addq.l  #$02, A7
                rts 
;===============================================================================
; Rotina de descompressão no formato Kosinski
; <<<-
;===============================================================================