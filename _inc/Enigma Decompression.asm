;===============================================================================
; Rotina de descompressão no formato Enigma
; ->>>
;===============================================================================  
EnigmaDec:                                                     ; Offset_0x001932
                movem.l D0-D7/A1-A5, -(A7)
                move.w  D0, A3
                move.b  (A0)+, D0
                ext.w   D0
                move.w  D0, A5
                move.b  (A0)+, D4
                lsl.b   #$03, D4
                move.w  (A0)+, A2
                adda.w  A3, A2
                move.w  (A0)+, A4
                adda.w  A3, A4
                move.b  (A0)+, D5
                asl.w   #$08, D5
                move.b  (A0)+, D5
                moveq   #$10, D6
Offset_0x001952:                
                moveq   #$07, D0   
                move.w  D6, D7
                sub.w   D0, D7
                move.w  D5, D1
                lsr.w   D7, D1
                andi.w  #$007F, D1
                move.w  D1, D2
                cmpi.w  #$0040, D1
                bcc.s   Offset_0x00196C
                moveq   #$06, D0
                lsr.w   #$01, D2
Offset_0x00196C:
                bsr     Offset_0x001AA0
                andi.w  #$000F, D2
                lsr.w   #$04, D1
                add.w   D1, D1
                jmp     Offset_0x0019C8(PC, D1)   
;-------------------------------------------------------------------------------
Offset_0x00197C:
                move.w  A2, (A1)+
                addq.w  #$01, A2
                dbra    D2, Offset_0x00197C
                bra.s   Offset_0x001952
;-------------------------------------------------------------------------------
Offset_0x001986:
                move.w  A4, (A1)+
                dbra    D2, Offset_0x001986
                bra.s   Offset_0x001952
;-------------------------------------------------------------------------------                
Offset_0x00198E:
                bsr     Offset_0x0019F0
Offset_0x001992:
                move.w  D1, (A1)+
                dbra    D2, Offset_0x001992
                bra.s   Offset_0x001952
;-------------------------------------------------------------------------------
Offset_0x00199A:
                bsr     Offset_0x0019F0
Offset_0x00199E:
                move.w  D1, (A1)+
                addq.w  #$01, D1
                dbra    D2, Offset_0x00199E
                bra.s   Offset_0x001952
;-------------------------------------------------------------------------------                
Offset_0x0019A8:
                bsr     Offset_0x0019F0
Offset_0x0019AC:
                move.w  D1, (A1)+
                subq.w  #$01, D1
                dbra    D2, Offset_0x0019AC
                bra.s   Offset_0x001952         
;-------------------------------------------------------------------------------
Offset_0x0019B6:
                cmpi.w  #$000F, D2
                beq.s   Offset_0x0019D8
Offset_0x0019BC:
                bsr     Offset_0x0019F0
                move.w  D1, (A1)+
                dbra    D2, Offset_0x0019BC
                bra.s   Offset_0x001952       
;------------------------------------------------------------------------------- 
Offset_0x0019C8:
                bra.s   Offset_0x00197C
                bra.s   Offset_0x00197C
                bra.s   Offset_0x001986
                bra.s   Offset_0x001986
                bra.s   Offset_0x00198E
                bra.s   Offset_0x00199A
                bra.s   Offset_0x0019A8
                bra.s   Offset_0x0019B6                
;-------------------------------------------------------------------------------
Offset_0x0019D8:
                subq.w  #$01, A0
                cmpi.w  #$0010, D6
                bne.s   Offset_0x0019E2
                subq.w  #$01, A0
Offset_0x0019E2:
                move.w  A0, D0
                lsr.w   #$01, D0
                bcc.s   Offset_0x0019EA
                addq.w  #$01, A0
Offset_0x0019EA:
                movem.l (A7)+, D0-D7/A1-A5
                rts
Offset_0x0019F0:
                move.w  A3, D3
                move.b  D4, D1
                add.b   D1, D1
                bcc.s   Offset_0x001A02
                subq.w  #$01, D6
                btst    D6, D5
                beq.s   Offset_0x001A02
                ori.w   #$8000, D3
Offset_0x001A02:
                add.b   D1, D1
                bcc.s   Offset_0x001A10
                subq.w  #$01, D6
                btst    D6, D5
                beq.s   Offset_0x001A10
                addi.w  #$4000, D3
Offset_0x001A10:
                add.b   D1, D1
                bcc.s   Offset_0x001A1E
                subq.w  #$01, D6
                btst    D6, D5
                beq.s   Offset_0x001A1E
                addi.w  #$2000, D3
Offset_0x001A1E:
                add.b   D1, D1
                bcc.s   Offset_0x001A2C
                subq.w  #$01, D6
                btst    D6, D5
                beq.s   Offset_0x001A2C
                ori.w   #$1000, D3
Offset_0x001A2C:
                add.b   D1, D1
                bcc.s   Offset_0x001A3A
                subq.w  #$01, D6
                btst    D6, D5
                beq.s   Offset_0x001A3A
                ori.w   #$0800, D3
Offset_0x001A3A:
                move.w  D5, D1
                move.w  D6, D7
                sub.w   A5, D7
                bcc.s   Offset_0x001A6A
                move.w  D7, D6
                addi.w  #$0010, D6
                neg.w   D7
                lsl.w   D7, D1
                move.b  (A0), D5
                rol.b   D7, D5
                add.w   D7, D7
                and.w   Offset_0x001A80-$02(PC, D7), D5
                add.w   D5, D1
Offset_0x001A58:
                move.w  A5, D0
                add.w   D0, D0
                and.w   Offset_0x001A80-$02(PC, D0), D1
                add.w   D3, D1
                move.b  (A0)+, D5
                lsl.w   #$08, D5
                move.b  (A0)+, D5
                rts
Offset_0x001A6A:
                beq.s   Offset_0x001A7C
                lsr.w   D7, D1
                move.w  A5, D0
                add.w   D0, D0
                and.w   Offset_0x001A80-$02(PC, D0), D1
                add.w   D3, D1
                move.w  A5, D0
                bra.s   Offset_0x001AA0
Offset_0x001A7C:
                moveq   #$10, D6
                bra.s   Offset_0x001A58                                                     
;-------------------------------------------------------------------------------
Offset_0x001A80:
                dc.w    $0001, $0003, $0007, $000F, $001F, $003F, $007F, $00FF
                dc.w    $01FF, $03FF, $07FF, $0FFF, $1FFF, $3FFF, $7FFF, $FFFF
;-------------------------------------------------------------------------------  
Offset_0x001AA0:
                sub.w   D0, D6
                cmpi.w  #$0009, D6
                bcc.s   Offset_0x001AAE
                addq.w  #$08, D6
                asl.w   #$08, D5
                move.b  (A0)+, D5
Offset_0x001AAE:
                rts             
;===============================================================================
; Rotina de descompressão no formato Enigma
; <<<-
;===============================================================================