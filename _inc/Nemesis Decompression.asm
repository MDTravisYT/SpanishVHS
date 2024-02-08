;===============================================================================
; Rotina de descompressão no formato Nemesis
; ->>>
;=============================================================================== 
NemesisDec:                                                    ; Offset_0x001654
                movem.l D0-D7/A0/A1/A3-A5, -(A7)
                lea     (NemesisDec_Output), A3                ; Offset_0x001716
                lea     (VDP_Data_Port), A4                          ; $00C00000
                bra.s   NemesisDec_Main                        ; Offset_0x001670
;-------------------------------------------------------------------------------  
NemesisDecToRAM:                                               ; Offset_0x001666
                movem.l D0-D7/A0/A1/A3-A5, -(A7)
                lea     (NemesisDec_OutputToRAM), A3           ; Offset_0x00172C
NemesisDec_Main:                                               ; Offset_0x001670
                lea     ($FFFFAA00).w, A1
                move.w  (A0)+, D2
                lsl.w   #$01, D2
                bcc.s   Offset_0x00167E
              ; Aponta A3 para NemesisDec_Output_XOR se A3 = NemesisDec_Output ou
              ; Aponta A3 para NemesisDec_OutputRAM_XOR se A3 = NemesisDec_OutputRAM  
                adda.w  #(NemesisDec_Output_XOR-NemesisDec_Output), A3   ; $000A
Offset_0x00167E:
                lsl.w   #$02, D2
                move.w  D2, A5
                moveq   #$08, D3
                moveq   #$00, D2
                moveq   #$00, D4
                bsr     NemesisDec_4                           ; Offset_0x001742
                move.b  (A0)+, D5
                asl.w   #$08, D5
                move.b  (A0)+, D5
                move.w  #$0010, D6
                bsr.s   NemesisDec_2                           ; Offset_0x00169E
                movem.l (A7)+, D0-D7/A0/A1/A3-A5
                rts
;-------------------------------------------------------------------------------                
NemesisDec_2:                                                  ; Offset_0x00169E
                move.w  D6, D7
                subq.w  #$08, D7
                move.w  D5, D1
                lsr.w   D7, D1
                cmpi.b  #$FC, D1
                bcc.s   Offset_0x0016EA
                andi.w  #$00FF, D1
                add.w   D1, D1
                move.b  $00(A1, D1), D0
                ext.w   D0
                sub.w   D0, D6
                cmpi.w  #$0009, D6
                bcc.s   Offset_0x0016C6
                addq.w  #$08, D6
                asl.w   #$08, D5
                move.b  (A0)+, D5
Offset_0x0016C6:
                move.b  $01(A1, D1), D1
                move.w  D1, D0
                andi.w  #$000F, D1
                andi.w  #$00F0, D0
NemesisDec_SubType:                                            ; Offset_0x0016D4                 
                lsr.w   #$04, D0
NemesisDec_Loop_SubType:                                       ; Offset_0x0016D6                 
                lsl.l   #$04, D4
                or.b    D1, D4
                subq.w  #$01, D3
                bne.s   Offset_0x0016E4
              ; A3 Contém uma das rotinas de descompressão no formato Nemesis.  
              ; ( NemesisDec_Output_XOR ou NemesisDec_OutputRAM_XOR )  
                jmp     (A3)       
;-------------------------------------------------------------------------------
NemesisDec_3                                                   ; Offset_0x0016E0
                moveq   #$00, D4
                moveq   #$08, D3
Offset_0x0016E4:
                dbra    D0, NemesisDec_Loop_SubType            ; Offset_0x0016D6
                bra.s   NemesisDec_2                           ; Offset_0x00169E  
;-------------------------------------------------------------------------------  
Offset_0x0016EA:
                subq.w  #$06, D6
                cmpi.w  #$0009, D6
                bcc.s   Offset_0x0016F8
                addq.w  #$08, D6
                asl.w   #$08, D5
                move.b  (A0)+, D5
Offset_0x0016F8:
                subq.w  #$07, D6
                move.w  D5, D1
                lsr.w   D6, D1
                move.w  D1, D0
                andi.w  #$000F, D1
                andi.w  #$0070, D0
                cmpi.w  #$0009, D6
                bcc.s   NemesisDec_SubType                     ; Offset_0x0016D4
                addq.w  #$08, D6
                asl.w   #$08, D5
                move.b  (A0)+, D5
                bra.s   NemesisDec_SubType                     ; Offset_0x0016D4
;-------------------------------------------------------------------------------
NemesisDec_Output:                                             ; Offset_0x001716
                move.l  D4, (A4)
                subq.w  #$01, A5
                move.w  A5, D4
                bne.s   NemesisDec_3                           ; Offset_0x0016E0
                rts
;-------------------------------------------------------------------------------
NemesisDec_Output_XOR:                                         ; Offset_0x001720
                eor.l   D4, D2
                move.l  D2, (A4)
                subq.w  #$01, A5
                move.w  A5, D4
                bne.s   NemesisDec_3                           ; Offset_0x0016E0
                rts
;-------------------------------------------------------------------------------
NemesisDec_OutputToRAM:                                        ; Offset_0x00172C
                move.l  D4, (A4)+
                subq.w  #$01, A5
                move.w  A5, D4
                bne.s   NemesisDec_3                           ; Offset_0x0016E0
                rts
;-------------------------------------------------------------------------------
NemesisDec_Output_XORToRAM:                                    ; Offset_0x001736
                eor.l   D4, D2
                move.l  D2, (A4)+
                subq.w  #$01, A5
                move.w  A5, D4
                bne.s   NemesisDec_3                           ; Offset_0x0016E0
                rts
;-------------------------------------------------------------------------------
NemesisDec_4:                                                  ; Offset_0x001742:
                move.b  (A0)+, D0
Offset_0x001744:
                cmpi.b  #$FF, D0
                bne.s   Offset_0x00174C
                rts
Offset_0x00174C:
                move.w  D0, D7
Offset_0x00174E:
                move.b  (A0)+, D0
                cmpi.b  #$80, D0
                bcc.s   Offset_0x001744
                move.b  D0, D1
                andi.w  #$000F, D7
                andi.w  #$0070, D1
                or.w    D1, D7
                andi.w  #$000F, D0
                move.b  D0, D1
                lsl.w   #$08, D1
                or.w    D1, D7
                moveq   #$08, D1
                sub.w   D0, D1
                bne.s   Offset_0x00177C
                move.b  (A0)+, D0
                add.w   D0, D0
                move.w  D7, $00(A1, D0)
                bra.s   Offset_0x00174E
Offset_0x00177C:
                move.b  (A0)+, D0
                lsl.w   D1, D0
                add.w   D0, D0
                moveq   #$01, D5
                lsl.w   D1, D5
                subq.w  #$01, D5
Offset_0x001788:
                move.w  D7, $00(A1, D0)
                addq.w  #$02, D0
                dbra    D5, Offset_0x001788
                bra.s   Offset_0x00174E                 
;===============================================================================
; Rotina de descompressão no formato Nemesis
; <<<-
;===============================================================================