;===============================================================================
; Objeto 0x01 - Sonic
; ->>> 
;=============================================================================== 
; PBoffset_0x015054:
                tst.w   (Debug_Mode_Flag_Index).w                    ; $FFFFFE08
                beq.s   Obj_Sonic                              ; PBoffset_0x015060
                jmp     (Debug_Mode)                           ; PBoffset_0x03A098
																								
Obj_Sonic:                                                     ; PBoffset_0x015060
                moveq   #$00, D0
                move.b  Obj_Routine(A0), D0                              ; $0024
                move.w  Sonic_Index(PC, D0), D1                ; PBoffset_0x01506E
                jmp     Sonic_Index(PC, D1)                    ; PBoffset_0x01506E
;-------------------------------------------------------------------------------
Sonic_Index:                                                   ; PBoffset_0x01506E                                                  
                dc.w    Sonic_Main-Sonic_Index                 ; PBoffset_0x015078
                dc.w    Sonic_Control-Sonic_Index              ; PBoffset_0x015112
                dc.w    Sonic_Hurt-Sonic_Index                 ; PBoffset_0x01603E
                dc.w    Sonic_Death-Sonic_Index                ; PBoffset_0x0160F2
                dc.w    Sonic_ResetLevel-Sonic_Index           ; PBoffset_0x0161B2
;-------------------------------------------------------------------------------                       
Sonic_Main:                                                    ; PBoffset_0x015078
                addq.b  #$02, Obj_Routine(A0)                            ; $0024
                move.b  #$13, Obj_Height_2(A0)                           ; $0016
                move.b  #$09, Obj_Width_2(A0)                            ; $0017
                move.l  #Sonic_Mappings, Obj_Map(A0)    ; PBoffset_0x06FBE0, $0004
                move.w  #$0780, Obj_Art_VRAM(A0)                         ; $0002
                bsr     ModifySpriteAttr_2P                    ; PBoffset_0x01298E
                move.b  #$02, Obj_Priority(A0)                           ; $0018
                move.b  #$18, Obj_Width(A0)                              ; $0019
                move.b  #$04, Obj_Flags(A0)                              ; $0001
                move.w  #$0600, (Sonic_Max_Speed).w                  ; $FFFFF760
                move.w  #$000C, (Sonic_Acceleration).w               ; $FFFFF762
                move.w  #$0080, (Sonic_Deceleration).w               ; $FFFFF764
                move.b  #$0C, Obj_Player_Top_Solid(A0)                   ; $003E
                move.b  #$0D, Obj_Player_LRB_Solid(A0)                   ; $003F
                move.b  #$00, Obj_P_Flips_Remaining(A0)                  ; $002C
                move.b  #$04, Obj_Player_Flip_Speed(A0)                  ; $002D
                move.b  #$00, ($FFFFFE19).w
                move.b  #$1E, Obj_Subtype(A0)                            ; $0028
                subi.w  #$0020, Obj_X(A0)                                ; $0008
                addi.w  #$0004, Obj_Y(A0)                                ; $000C
                move.w  #$0000, ($FFFFEED2).w
                move.w  #$003F, D2
PBoffset_0x0150F8:
                bsr     CopySonicMovesForMiles                 ; PBoffset_0x01523A
                subq.w  #$04, A1
                move.w  #$0000, (A1)
                dbra    D2, PBoffset_0x0150F8
                addi.w  #$0020, Obj_X(A0)                                ; $0008
                subi.w  #$0004, Obj_Y(A0)                                ; $000C
;-------------------------------------------------------------------------------                
Sonic_Control:                                                 ; PBoffset_0x015112
                tst.w   ($FFFFFFFA).w
                beq.s   PBoffset_0x01512C
                btst    #$04, (Control_Ports_Buffer_Data+$0001).w    ; $FFFFF605
                beq.s   PBoffset_0x01512C
                move.w  #$0001, (Debug_Mode_Flag_Index).w            ; $FFFFFE08
                clr.b   ($FFFFF7CC).w
                rts
PBoffset_0x01512C:
                tst.b   ($FFFFF7CC).w
                bne.s   PBoffset_0x015138
                move.w  (Control_Ports_Buffer_Data).w, ($FFFFF602).w ; $FFFFF604
PBoffset_0x015138:
                btst    #$00, Obj_Timer(A0)                              ; $002A
                bne.s   PBoffset_0x015152
                moveq   #$00, D0
                move.b  Obj_Status(A0), D0                               ; $0022
                andi.w  #$0006, D0
                move.w  Sonic_Modes(PC, D0), D1                ; PBoffset_0x01519C
                jsr     Sonic_Modes(PC, D1)                    ; PBoffset_0x01519C
PBoffset_0x015152:
                cmpi.w  #$FF00, (Sonic_Level_Limits_Min_Y).w                     ; $FFFFEECC
                bne.s   PBoffset_0x015160
                andi.w  #$07FF, Obj_Y(A0)                                ; $000C
PBoffset_0x015160:
                bsr.s   Sonic_Display                          ; PBoffset_0x0151A4
                bsr     CopySonicMovesForMiles                 ; PBoffset_0x01523A
                bsr     Sonic_Water                            ; PBoffset_0x015264
                move.b  ($FFFFF768).w, Obj_Player_Next_Tilt(A0)          ; $0036
                move.b  ($FFFFF76A).w, Obj_Player_Tilt(A0)               ; $0037
                tst.b   ($FFFFF7C7).w
                beq.s   PBoffset_0x015188
                tst.b   Obj_Ani_Number(A0)                               ; $001C
                bne.s   PBoffset_0x015188
                move.b  Obj_Ani_Flag(A0), Obj_Ani_Number(A0)      ; $001C, $001D
PBoffset_0x015188:
                bsr     Sonic_Animate                          ; PBoffset_0x0161C6
                tst.b   Obj_Timer(A0)                                    ; $002A
                bmi.s   PBoffset_0x015198
                jsr     (TouchResponse)                        ; PBoffset_0x03807C
PBoffset_0x015198:
                bra     Load_Sonic_Dynamic_PLC                 ; PBoffset_0x0166B2
;-------------------------------------------------------------------------------
Sonic_Modes:                                                   ; PBoffset_0x01519C
                dc.w    Sonic_MdNormal-Sonic_Modes             ; PBoffset_0x01534C
                dc.w    Sonic_MdJump-Sonic_Modes               ; PBoffset_0x0153BE
                dc.w    Sonic_MdRoll-Sonic_Modes               ; PBoffset_0x0153E8
                dc.w    Sonic_MdJump2-Sonic_Modes              ; PBoffset_0x01540E
;-------------------------------------------------------------------------------                
;-------------------------------------------------------------------------------   
Sonic_PlayList:                                                ; Offset_0x00FC28
                dc.b    $82  ; GHz
                dc.b    $82
                dc.b    $85  ; Wz
                dc.b    $84
                dc.b    $85  ; Mz
                dc.b    $85  ; Mz
                dc.b    $8C
                dc.b    $86  ; HTz
                dc.b    $83  ; HPz
                dc.b    $8D
                dc.b    $88  ; OOz
                dc.b    $8B  ; DHz
                dc.b    $89  ; CNz
                dc.b    $8E  ; CPz
                dc.b    $8E  ; GCz 
                dc.b    $87  ; NGHz       
;-------------------------------------------------------------------------------  																  
Sonic_Display:                                                 ; PBoffset_0x0151A4
                move.w  Obj_P_Invunerblt_Time(A0), D0                    ; $0030
                beq.s   PBoffset_0x0151B2
                subq.w  #$01, Obj_P_Invunerblt_Time(A0)                  ; $0030
                lsr.w   #$03, D0
                bcc.s   PBoffset_0x0151B8
PBoffset_0x0151B2:
                jsr     (DisplaySprite)                        ; PBoffset_0x0120DE
PBoffset_0x0151B8:
                btst    #$01, Obj_Player_Status(A0)                      ; $002B
                beq.s   PBoffset_0x0151EA
                tst.w   Obj_P_Invcbility_Time(A0)                        ; $0032
                beq.s   PBoffset_0x0151EA
                subq.w  #$01, Obj_P_Invcbility_Time(A0)                  ; $0032
                bne.s   PBoffset_0x0151EA
                tst.b   (Boss_Flag).w                                ; $FFFFF7AA
                bne.s   PBoffset_0x0151E4
                cmpi.b  #$0C, Obj_Subtype(A0)                            ; $0028
                bcs.s   PBoffset_0x0151E4
                moveq   #$00, D0
                move.b  (Level_Id).w, D0                             ; $FFFFFE10
                lea     Sonic_PlayList(PC), A1                 ; Offset_0x00FC28
                move.b  $00(A1, D0), D0
				
																				
				
                jsr     (Play_Music)                           ; PBoffset_0x00190C
PBoffset_0x0151E4:
                bclr    #$01, Obj_Player_Status(A0)                      ; $002B
PBoffset_0x0151EA:
                btst    #$02, Obj_Player_Status(A0)                      ; $002B
                beq.s   PBoffset_0x015238
                tst.w   Obj_P_Spd_Shoes_Time(A0)                         ; $0034
                beq.s   PBoffset_0x015238
                subq.w  #$01, Obj_P_Spd_Shoes_Time(A0)                   ; $0034
                bne.s   PBoffset_0x015238
                move.w  #$0600, (Sonic_Max_Speed).w                  ; $FFFFF760
                move.w  #$000C, (Sonic_Acceleration).w               ; $FFFFF762
                move.w  #$0080, (Sonic_Deceleration).w               ; $FFFFF764
                tst.b   (Super_Sonic_Flag).w                         ; $FFFFFE19
                beq.s   PBoffset_0x015228
                move.w  #$0A00, (Sonic_Max_Speed).w                  ; $FFFFF760
                move.w  #$0030, (Sonic_Acceleration).w               ; $FFFFF762
                move.w  #$0100, (Sonic_Deceleration).w               ; $FFFFF764
PBoffset_0x015228:
                bclr    #$02, Obj_Player_Status(A0)                      ; $002B
                move.w  #$00FC, D0
                jmp     (Play_Music)                           ; PBoffset_0x00190C
PBoffset_0x015238:
                rts          
;-------------------------------------------------------------------------------
CopySonicMovesForMiles:                                        ; PBoffset_0x01523A
                move.w  ($FFFFEED2).w, D0
                lea     ($FFFFE500).w, A1
                lea     $00(A1, D0), A1
                move.w  Obj_X(A0), (A1)+                                 ; $0008
                move.w  Obj_Y(A0), (A1)+                                 ; $000C
                addq.b  #$04, ($FFFFEED3).w
                lea     ($FFFFE400).w, A1
                lea     $00(A1, D0), A1
                move.w  (Control_Ports_Buffer_Data).w, (A1)+         ; $FFFFF604
                move.w  Obj_Status(A0), (A1)+                            ; $0022
                rts  
;-------------------------------------------------------------------------------
Sonic_Water:                                                   ; PBoffset_0x015264
                tst.b   (Water_Level_Flag).w                         ; $FFFFF730
                bne.s   Sonic_InLevelWithWater                 ; PBoffset_0x01526C
PBoffset_0x01526A:
                rts
																				
Sonic_InLevelWithWater:                                        ; PBoffset_0x01526C
                move.w  (Water_Level).w, D0                          ; $FFFFF646
                cmp.w   Obj_Y(A0), D0                                    ; $000C
                bge.s   Sonic_NotInWater                       ; PBoffset_0x0152DC
                bset    #$06, Obj_Status(A0)                             ; $0022
                bne.s   PBoffset_0x01526A
                move.l  A0, A1
                bsr     Resume_Music                           ; PBoffset_0x01836A
                move.b  #$0A, ($FFFFB340).w
                move.b  #$81, ($FFFFB368).w
                move.l  A0, ($FFFFB37C).w
                move.w  #$0300, (Sonic_Max_Speed).w                  ; $FFFFF760
                move.w  #$0006, (Sonic_Acceleration).w               ; $FFFFF762
                move.w  #$0040, (Sonic_Deceleration).w               ; $FFFFF764
                tst.b   (Super_Sonic_Flag).w                         ; $FFFFFE19
                beq.s   PBoffset_0x0152BE
                move.w  #$0500, (Sonic_Max_Speed).w                  ; $FFFFF760
                move.w  #$0018, (Sonic_Acceleration).w               ; $FFFFF762
                move.w  #$0080, (Sonic_Deceleration).w               ; $FFFFF764
PBoffset_0x0152BE:
                asr.w   Obj_Speed(A0)                                    ; $0010
                asr.w   Obj_Speed_Y(A0)                                  ; $0012
                asr.w   Obj_Speed_Y(A0)                                  ; $0012
                beq.s   PBoffset_0x01526A
                move.w  #$0100, ($FFFFB41C).w
                move.w  #$00AA, D0
                jmp     (Play_Sfx)                             ; PBoffset_0x001912
;-------------------------------------------------------------------------------                
Sonic_NotInWater:                                              ; PBoffset_0x0152DC
                bclr    #$06, Obj_Status(A0)                             ; $0022
                beq.s   PBoffset_0x01526A
                move.l  A0, A1
                bsr     Resume_Music                           ; PBoffset_0x01836A
                move.w  #$0600, (Sonic_Max_Speed).w                  ; $FFFFF760
                move.w  #$000C, (Sonic_Acceleration).w               ; $FFFFF762
                move.w  #$0080, (Sonic_Deceleration).w               ; $FFFFF764
                tst.b   (Super_Sonic_Flag).w                         ; $FFFFFE19
                beq.s   PBoffset_0x015314
                move.w  #$0A00, (Sonic_Max_Speed).w                  ; $FFFFF760
                move.w  #$0030, (Sonic_Acceleration).w               ; $FFFFF762
                move.w  #$0100, (Sonic_Deceleration).w               ; $FFFFF764
PBoffset_0x015314:
                cmpi.b  #$04, Obj_Routine(A0)                            ; $0024
                beq.s   PBoffset_0x015320
                asl.w   Obj_Speed_Y(A0)                                  ; $0012
PBoffset_0x015320:
                tst.w   Obj_Speed_Y(A0)                                  ; $0012
                beq     PBoffset_0x01526A
                move.w  #$0100, ($FFFFB41C).w
                move.l  A0, A1
                bsr     Resume_Music                           ; PBoffset_0x01836A
                cmpi.w  #$F000, Obj_Speed_Y(A0)                          ; $0012
                bgt.s   PBoffset_0x015342
                move.w  #$F000, Obj_Speed_Y(A0)                          ; $0012
PBoffset_0x015342:
                move.w  #$00AA, D0
                jmp     (Play_Sfx)                             ; PBoffset_0x001912  
;-------------------------------------------------------------------------------
Sonic_MdNormal:                                                ; PBoffset_0x01534C
                move.b  (Control_Ports_Buffer_Data+$0001).w, D0      ; $FFFFF605
                andi.b  #$70, D0
                bne.s   PBoffset_0x015396
                cmpi.b  #$0A, Obj_Ani_Number(A0)                         ; $001C
                beq.s   PBoffset_0x0153BC
                cmpi.b  #$0B, Obj_Ani_Number(A0)                         ; $001C
                beq.s   PBoffset_0x0153BC
                cmpi.b  #$05, Obj_Ani_Number(A0)                         ; $001C
                bne.s   PBoffset_0x015396
                cmpi.b  #$1E, Obj_Ani_Frame(A0)                          ; $001B
                bcs.s   PBoffset_0x015396
                move.b  (Control_Ports_Buffer_Data).w, D0            ; $FFFFF604
                andi.b  #$7F, D0
                beq.s   PBoffset_0x0153BC
                move.b  #$0A, Obj_Ani_Number(A0)                         ; $001C
                cmpi.b  #$AC, Obj_Ani_Frame(A0)                          ; $001B
                bcs.s   PBoffset_0x0153BC
                move.b  #$0B, Obj_Ani_Number(A0)                         ; $001C
                bra.s   PBoffset_0x0153BC
PBoffset_0x015396:
                bsr     Sonic_Spindash                         ; PBoffset_0x015BA0
                bsr     Sonic_Jump                             ; PBoffset_0x015AA6
                bsr     Sonic_SlopeResist                      ; PBoffset_0x015CC4
                bsr     Sonic_Move                             ; PBoffset_0x015438
                bsr     Sonic_Roll                             ; PBoffset_0x015A40
                bsr     Sonic_LevelBoundaries                  ; PBoffset_0x0159E2
                jsr     (SpeedToPos)                           ; PBoffset_0x011F96
                bsr     Player_AnglePos                        ; PBoffset_0x019004
                bsr     Sonic_SlopeRepel                       ; PBoffset_0x015D36
PBoffset_0x0153BC:
                rts
;-------------------------------------------------------------------------------
Sonic_MdJump:                                                  ; PBoffset_0x0153BE
                bsr     Sonic_JumpHeight                       ; PBoffset_0x015B5E
                bsr     Sonic_ChgJumpDir                       ; PBoffset_0x015956
                bsr     Sonic_LevelBoundaries                  ; PBoffset_0x0159E2
                jsr     (ObjectFall)                           ; PBoffset_0x011F6A
                btst    #$06, Obj_Status(A0)                             ; $0022
                beq.s   PBoffset_0x0153DE
                subi.w  #$0028, Obj_Speed_Y(A0)                          ; $0012
PBoffset_0x0153DE:
                bsr     Sonic_JumpAngle                        ; PBoffset_0x015D78
                bsr     Sonic_Floor                            ; PBoffset_0x015DD8
                rts         
;-------------------------------------------------------------------------------    
Sonic_MdRoll:                                                  ; PBoffset_0x0153E8
                tst.b   Obj_Player_Spdsh_Flag(A0)                        ; $0039
                bne.s   PBoffset_0x0153F2
                bsr     Sonic_Jump                             ; PBoffset_0x015AA6
PBoffset_0x0153F2:
                bsr     Sonic_RollRepel                        ; PBoffset_0x015CFA
                bsr     Sonic_RollSpeed                        ; PBoffset_0x015846
                bsr     Sonic_LevelBoundaries                  ; PBoffset_0x0159E2
                jsr     (SpeedToPos)                           ; PBoffset_0x011F96
                bsr     Player_AnglePos                        ; PBoffset_0x019004
                bsr     Sonic_SlopeRepel                       ; PBoffset_0x015D36
                rts    
;-------------------------------------------------------------------------------      
Sonic_MdJump2:                                                 ; PBoffset_0x01540E
                bsr     Sonic_JumpHeight                       ; PBoffset_0x015B5E
                bsr     Sonic_ChgJumpDir                       ; PBoffset_0x015956
                bsr     Sonic_LevelBoundaries                  ; PBoffset_0x0159E2
                jsr     (ObjectFall)                           ; PBoffset_0x011F6A
                btst    #$06, Obj_Status(A0)                             ; $0022
                beq.s   PBoffset_0x01542E
                subi.w  #$0028, Obj_Speed_Y(A0)                          ; $0012
PBoffset_0x01542E:
                bsr     Sonic_JumpAngle                        ; PBoffset_0x015D78
                bsr     Sonic_Floor                            ; PBoffset_0x015DD8
                rts
;-------------------------------------------------------------------------------  
Sonic_Move:                                                    ; PBoffset_0x015438
                move.w  (Sonic_Max_Speed).w, D6                      ; $FFFFF760
                move.w  (Sonic_Acceleration).w, D5                   ; $FFFFF762
                move.w  (Sonic_Deceleration).w, D4                   ; $FFFFF764
                tst.b   Obj_Player_Status(A0)                            ; $002B
                bmi     PBoffset_0x0156B0
                tst.w   Obj_Player_Control(A0)                           ; $002E
                bne     PBoffset_0x015678
                btst    #$02, ($FFFFF602).w
                beq.s   PBoffset_0x015460
                bsr     PBoffset_0x015740
PBoffset_0x015460:
                btst    #$03, ($FFFFF602).w
                beq.s   PBoffset_0x01546C
                bsr     PBoffset_0x0157C6
PBoffset_0x01546C:
                move.b  Obj_Angle(A0), D0                                ; $0026
                addi.b  #$20, D0
                andi.b  #$C0, D0
                bne     PBoffset_0x015678
                tst.w   Obj_Inertia(A0)                                  ; $0014
                bne     PBoffset_0x015678
                bclr    #$05, Obj_Status(A0)                             ; $0022
                move.b  #$05, Obj_Ani_Number(A0)                         ; $001C
                btst    #$03, Obj_Status(A0)                             ; $0022
                beq     PBoffset_0x01556A
                moveq   #$00, D0
                move.b  $003D(A0), D0
                lsl.w   #$06, D0
                lea     (Obj_Memory_Address).w, A1                   ; $FFFFB000
                lea     $00(A1, D0), A1
                tst.b   Obj_Status(A1)                                   ; $0022
                bmi     PBoffset_0x01565A
                moveq   #$00, D1
                move.b  Obj_Width(A1), D1                                ; $0019
                move.w  D1, D2
                add.w   D2, D2
                subq.w  #$02, D2
                add.w   Obj_X(A0), D1                                    ; $0008
                sub.w   Obj_X(A1), D1                                    ; $0008
                tst.b   (Super_Sonic_Flag).w                         ; $FFFFFE19
                bne     PBoffset_0x0154DC
                cmpi.w  #$0002, D1
                blt.s   PBoffset_0x01552C
                cmp.w   D2, D1
                bge.s   PBoffset_0x0154EE
                bra     PBoffset_0x01565A
PBoffset_0x0154DC:
                cmpi.w  #$0002, D1
                blt     PBoffset_0x01564C
                cmp.w   D2, D1
                bge     PBoffset_0x01563C
                bra     PBoffset_0x01565A
PBoffset_0x0154EE:
                btst    #$00, Obj_Status(A0)                             ; $0022
                bne.s   PBoffset_0x01550E
                move.b  #$06, Obj_Ani_Number(A0)                         ; $001C
                addq.w  #$06, D2
                cmp.w   D2, D1
                blt     PBoffset_0x015678
                move.b  #$0C, Obj_Ani_Number(A0)                         ; $001C
                bra     PBoffset_0x015678
PBoffset_0x01550E:
                move.b  #$1D, Obj_Ani_Number(A0)                         ; $001C
                addq.w  #$06, D2
                cmp.w   D2, D1
                blt     PBoffset_0x015678
                move.b  #$1E, Obj_Ani_Number(A0)                         ; $001C
                bclr    #$00, Obj_Status(A0)                             ; $0022
                bra     PBoffset_0x015678
PBoffset_0x01552C:
                btst    #$00, Obj_Status(A0)                             ; $0022
                beq.s   PBoffset_0x01554C
                move.b  #$06, Obj_Ani_Number(A0)                         ; $001C
                cmpi.w  #$FFFC, D1
                bge     PBoffset_0x015678
                move.b  #$0C, Obj_Ani_Number(A0)                         ; $001C
                bra     PBoffset_0x015678
PBoffset_0x01554C:
                move.b  #$1D, Obj_Ani_Number(A0)                         ; $001C
                cmpi.w  #$FFFC, D1
                bge     PBoffset_0x015678
                move.b  #$1E, Obj_Ani_Number(A0)                         ; $001C
                bset    #$00, Obj_Status(A0)                             ; $0022
                bra     PBoffset_0x015678
PBoffset_0x01556A:
                jsr     (Player_HitFloor)                      ; PBoffset_0x019AD0
                cmpi.w  #$000C, D1
                blt     PBoffset_0x01565A
                tst.b   (Super_Sonic_Flag).w                         ; $FFFFFE19
                bne     PBoffset_0x015634
                cmpi.b  #$03, Obj_Player_Next_Tilt(A0)                   ; $0036
                bne.s   PBoffset_0x0155DE
                btst    #$00, Obj_Status(A0)                             ; $0022
                bne.s   PBoffset_0x0155B4
                move.b  #$06, Obj_Ani_Number(A0)                         ; $001C
                move.w  Obj_X(A0), D3                                    ; $0008
                subq.w  #$06, D3
                jsr     (Player_HitFloor_D3)                   ; PBoffset_0x019AD4
                cmpi.w  #$000C, D1
                blt     PBoffset_0x015678
                move.b  #$0C, Obj_Ani_Number(A0)                         ; $001C
                bra     PBoffset_0x015678
PBoffset_0x0155B4:
                move.b  #$1D, Obj_Ani_Number(A0)                         ; $001C
                move.w  Obj_X(A0), D3                                    ; $0008
                subq.w  #$06, D3
                jsr     (Player_HitFloor_D3)                   ; PBoffset_0x019AD4
                cmpi.w  #$000C, D1
                blt     PBoffset_0x015678
                move.b  #$1E, Obj_Ani_Number(A0)                         ; $001C
                bclr    #$00, Obj_Status(A0)                             ; $0022
                bra     PBoffset_0x015678
PBoffset_0x0155DE:
                cmpi.b  #$03, Obj_Player_Tilt(A0)                        ; $0037
                bne.s   PBoffset_0x01565A
                btst    #$00, Obj_Status(A0)                             ; $0022
                beq.s   PBoffset_0x01560E
                move.b  #$06, Obj_Ani_Number(A0)                         ; $001C
                move.w  Obj_X(A0), D3                                    ; $0008
                addq.w  #$06, D3
                jsr     (Player_HitFloor_D3)                   ; PBoffset_0x019AD4
                cmpi.w  #$000C, D1
                blt.s   PBoffset_0x015678
                move.b  #$0C, Obj_Ani_Number(A0)                         ; $001C
                bra.s   PBoffset_0x015678
PBoffset_0x01560E:
                move.b  #$1D, Obj_Ani_Number(A0)                         ; $001C
                move.w  Obj_X(A0), D3                                    ; $0008
                addq.w  #$06, D3
                jsr     (Player_HitFloor_D3)                   ; PBoffset_0x019AD4
                cmpi.w  #$000C, D1
                blt.s   PBoffset_0x015678
                move.b  #$1E, Obj_Ani_Number(A0)                         ; $001C
                bset    #$00, Obj_Status(A0)                             ; $0022
                bra.s   PBoffset_0x015678
PBoffset_0x015634:
                cmpi.b  #$03, Obj_Player_Next_Tilt(A0)                   ; $0036
                bne.s   PBoffset_0x015644
PBoffset_0x01563C:
                bclr    #$00, Obj_Status(A0)                             ; $0022
                bra.s   PBoffset_0x015652
PBoffset_0x015644:
                cmpi.b  #$03, Obj_Player_Tilt(A0)                        ; $0037
                bne.s   PBoffset_0x01565A
PBoffset_0x01564C:
                bset    #$00, Obj_Status(A0)                             ; $0022
PBoffset_0x015652:
                move.b  #$06, Obj_Ani_Number(A0)                         ; $001C
                bra.s   PBoffset_0x015678
PBoffset_0x01565A:
                btst    #$00, ($FFFFF602).w
                beq.s   PBoffset_0x01566A
                move.b  #$07, Obj_Ani_Number(A0)                         ; $001C
                bra.s   PBoffset_0x015678
PBoffset_0x01566A:
                btst    #$01, ($FFFFF602).w
                beq.s   PBoffset_0x015678
                move.b  #$08, Obj_Ani_Number(A0)                         ; $001C
PBoffset_0x015678:
                tst.b   (Super_Sonic_Flag).w                         ; $FFFFFE19
                beq     PBoffset_0x015684
                move.w  #$000C, D5
PBoffset_0x015684:
                move.b  ($FFFFF602).w, D0
                andi.b  #$0C, D0
                bne.s   PBoffset_0x0156B0
                move.w  Obj_Inertia(A0), D0                              ; $0014
                beq.s   PBoffset_0x0156B0
                bmi.s   PBoffset_0x0156A4
                sub.w   D5, D0
                bcc.s   PBoffset_0x01569E
                move.w  #$0000, D0
PBoffset_0x01569E:
                move.w  D0, Obj_Inertia(A0)                              ; $0014
                bra.s   PBoffset_0x0156B0
PBoffset_0x0156A4:
                add.w   D5, D0
                bcc.s   PBoffset_0x0156AC
                move.w  #$0000, D0
PBoffset_0x0156AC:
                move.w  D0, Obj_Inertia(A0)                              ; $0014
PBoffset_0x0156B0:
                move.b  Obj_Angle(A0), D0                                ; $0026
                jsr     (CalcSine)                             ; PBoffset_0x00396A
                muls.w  Obj_Inertia(A0), D1                              ; $0014
                asr.l   #$08, D1
                move.w  D1, Obj_Speed(A0)                                ; $0010
                muls.w  Obj_Inertia(A0), D0                              ; $0014
                asr.l   #$08, D0
                move.w  D0, Obj_Speed_Y(A0)                              ; $0012
PBoffset_0x0156CE:
                move.b  Obj_Angle(A0), D0                                ; $0026
                addi.b  #$40, D0
                bmi.s   PBoffset_0x01573E
                move.b  #$40, D1
                tst.w   Obj_Inertia(A0)                                  ; $0014
                beq.s   PBoffset_0x01573E
                bmi.s   PBoffset_0x0156E6
                neg.w   D1
PBoffset_0x0156E6:
                move.b  Obj_Angle(A0), D0                                ; $0026
                add.b   D1, D0
                move.w  D0, -(A7)
                bsr     Player_WalkSpeed                       ; PBoffset_0x019948
                move.w  (A7)+, D0
                tst.w   D1
                bpl.s   PBoffset_0x01573E
                asl.w   #$08, D1
                addi.b  #$20, D0
                andi.b  #$C0, D0
                beq.s   PBoffset_0x01573A
                cmpi.b  #$40, D0
                beq.s   PBoffset_0x015728
                cmpi.b  #$80, D0
                beq.s   PBoffset_0x015722
                add.w   D1, Obj_Speed(A0)                                ; $0010
                bset    #$05, Obj_Status(A0)                             ; $0022
                move.w  #$0000, Obj_Inertia(A0)                          ; $0014
                rts
PBoffset_0x015722:
                sub.w   D1, Obj_Speed_Y(A0)                              ; $0012
                rts
PBoffset_0x015728:
                sub.w   D1, Obj_Speed(A0)                                ; $0010
                bset    #$05, Obj_Status(A0)                             ; $0022
                move.w  #$0000, Obj_Inertia(A0)                          ; $0014
                rts
PBoffset_0x01573A:
                add.w   D1, Obj_Speed_Y(A0)                              ; $0012
PBoffset_0x01573E:
                rts
PBoffset_0x015740:
                move.w  Obj_Inertia(A0), D0                              ; $0014
                beq.s   PBoffset_0x015748
                bpl.s   PBoffset_0x01577A
PBoffset_0x015748:
                bset    #$00, Obj_Status(A0)                             ; $0022
                bne.s   PBoffset_0x01575C
                bclr    #$05, Obj_Status(A0)                             ; $0022
                move.b  #$01, Obj_Ani_Flag(A0)                           ; $001D
PBoffset_0x01575C:
                sub.w   D5, D0
                move.w  D6, D1
                neg.w   D1
                cmp.w   D1, D0
                bgt.s   PBoffset_0x01576E
                add.w   D5, D0
                cmp.w   D1, D0
                ble.s   PBoffset_0x01576E
                move.w  D1, D0
PBoffset_0x01576E:
                move.w  D0, Obj_Inertia(A0)                              ; $0014
                move.b  #$00, Obj_Ani_Number(A0)                         ; $001C
                rts
PBoffset_0x01577A:
                sub.w   D4, D0
                bcc.s   PBoffset_0x015782
                move.w  #$FF80, D0
PBoffset_0x015782:
                move.w  D0, Obj_Inertia(A0)                              ; $0014
                move.b  Obj_Angle(A0), D0                                ; $0026
                addi.b  #$20, D0
                andi.b  #$C0, D0
                bne.s   PBoffset_0x0157C4
                cmpi.w  #$0400, D0
                blt.s   PBoffset_0x0157C4
                move.b  #$0D, Obj_Ani_Number(A0)                         ; $001C
                bclr    #$00, Obj_Status(A0)                             ; $0022
                move.w  #$00A4, D0
                jsr     (Play_Sfx)                             ; PBoffset_0x001912
                cmpi.b  #$0C, Obj_Subtype(A0)                            ; $0028
                bcs.s   PBoffset_0x0157C4
                move.b  #$06, ($FFFFB424).w
                move.b  #$15, ($FFFFB41A).w
PBoffset_0x0157C4:
                rts
PBoffset_0x0157C6:
                move.w  Obj_Inertia(A0), D0                              ; $0014
                bmi.s   PBoffset_0x0157FA
                bclr    #$00, Obj_Status(A0)                             ; $0022
                beq.s   PBoffset_0x0157E0
                bclr    #$05, Obj_Status(A0)                             ; $0022
                move.b  #$01, Obj_Ani_Flag(A0)                           ; $001D
PBoffset_0x0157E0:
                add.w   D5, D0
                cmp.w   D6, D0
                blt.s   PBoffset_0x0157EE
                sub.w   D5, D0
                cmp.w   D6, D0
                bge.s   PBoffset_0x0157EE
                move.w  D6, D0
PBoffset_0x0157EE:
                move.w  D0, Obj_Inertia(A0)                              ; $0014
                move.b  #$00, Obj_Ani_Number(A0)                         ; $001C
                rts
PBoffset_0x0157FA:
                add.w   D4, D0
                bcc.s   PBoffset_0x015802
                move.w  #$0080, D0
PBoffset_0x015802:
                move.w  D0, Obj_Inertia(A0)                              ; $0014
                move.b  Obj_Angle(A0), D0                                ; $0026
                addi.b  #$20, D0
                andi.b  #$C0, D0
                bne.s   PBoffset_0x015844
                cmpi.w  #$FC00, D0
                bgt.s   PBoffset_0x015844
                move.b  #$0D, Obj_Ani_Number(A0)                         ; $001C
                bset    #$00, Obj_Status(A0)                             ; $0022
                move.w  #$00A4, D0
                jsr     (Play_Sfx)                             ; PBoffset_0x001912
                cmpi.b  #$0C, Obj_Subtype(A0)                            ; $0028
                bcs.s   PBoffset_0x015844
                move.b  #$06, ($FFFFB424).w
                move.b  #$15, ($FFFFB41A).w
PBoffset_0x015844:
                rts
;-------------------------------------------------------------------------------                
Sonic_RollSpeed:                                               ; PBoffset_0x015846
                move.w  (Sonic_Max_Speed).w, D6                      ; $FFFFF760
                asl.w   #$01, D6
                move.w  (Sonic_Acceleration).w, D5                   ; $FFFFF762
                asr.w   #$01, D5
                move.w  #$0020, D4
                tst.b   Obj_Player_Status(A0)                            ; $002B
                bmi     PBoffset_0x0158DA
                tst.w   Obj_Player_Control(A0)                           ; $002E
                bne.s   PBoffset_0x01587C
                btst    #$02, ($FFFFF602).w
                beq.s   PBoffset_0x015870
                bsr     PBoffset_0x015910
PBoffset_0x015870:
                btst    #$03, ($FFFFF602).w
                beq.s   PBoffset_0x01587C
                bsr     PBoffset_0x015934
PBoffset_0x01587C:
                move.w  Obj_Inertia(A0), D0                              ; $0014
                beq.s   PBoffset_0x01589E
                bmi.s   PBoffset_0x015892
                sub.w   D5, D0
                bcc.s   PBoffset_0x01588C
                move.w  #$0000, D0
PBoffset_0x01588C:
                move.w  D0, Obj_Inertia(A0)                              ; $0014
                bra.s   PBoffset_0x01589E
PBoffset_0x015892:
                add.w   D5, D0
                bcc.s   PBoffset_0x01589A
                move.w  #$0000, D0
PBoffset_0x01589A:
                move.w  D0, Obj_Inertia(A0)                              ; $0014
PBoffset_0x01589E:
                tst.w   Obj_Inertia(A0)                                  ; $0014
                bne.s   PBoffset_0x0158DA
                tst.b   Obj_Player_Spdsh_Flag(A0)                        ; $0039
                bne.s   PBoffset_0x0158C8
                bclr    #$02, Obj_Status(A0)                             ; $0022
                move.b  #$13, Obj_Height_2(A0)                           ; $0016
                move.b  #$09, Obj_Width_2(A0)                            ; $0017
                move.b  #$05, Obj_Ani_Number(A0)                         ; $001C
                subq.w  #$05, Obj_Y(A0)                                  ; $000C
                bra.s   PBoffset_0x0158DA
PBoffset_0x0158C8:
                move.w  #$0400, Obj_Inertia(A0)                          ; $0014
                btst    #$00, Obj_Status(A0)                             ; $0022
                beq.s   PBoffset_0x0158DA
                neg.w   Obj_Inertia(A0)                                  ; $0014
PBoffset_0x0158DA:
                move.b  Obj_Angle(A0), D0                                ; $0026
                jsr     (CalcSine)                             ; PBoffset_0x00396A
                muls.w  Obj_Inertia(A0), D0                              ; $0014
                asr.l   #$08, D0
                move.w  D0, Obj_Speed_Y(A0)                              ; $0012
                muls.w  Obj_Inertia(A0), D1                              ; $0014
                asr.l   #$08, D1
                cmpi.w  #$1000, D1
                ble.s   PBoffset_0x0158FE
                move.w  #$1000, D1
PBoffset_0x0158FE:
                cmpi.w  #$F000, D1
                bge.s   PBoffset_0x015908
                move.w  #$F000, D1
PBoffset_0x015908:
                move.w  D1, Obj_Speed(A0)                                ; $0010
                bra     PBoffset_0x0156CE
PBoffset_0x015910:
                move.w  Obj_Inertia(A0), D0                              ; $0014
                beq.s   PBoffset_0x015918
                bpl.s   PBoffset_0x015926
PBoffset_0x015918:
                bset    #$00, Obj_Status(A0)                             ; $0022
                move.b  #$02, Obj_Ani_Number(A0)                         ; $001C
                rts
PBoffset_0x015926:
                sub.w   D4, D0
                bcc.s   PBoffset_0x01592E
                move.w  #$FF80, D0
PBoffset_0x01592E:
                move.w  D0, Obj_Inertia(A0)                              ; $0014
                rts
PBoffset_0x015934:
                move.w  Obj_Inertia(A0), D0                              ; $0014
                bmi.s   PBoffset_0x015948
                bclr    #$00, Obj_Status(A0)                             ; $0022
                move.b  #$02, Obj_Ani_Number(A0)                         ; $001C
                rts
PBoffset_0x015948:
                add.w   D4, D0
                bcc.s   PBoffset_0x015950
                move.w  #$0080, D0
PBoffset_0x015950:
                move.w  D0, Obj_Inertia(A0)                              ; $0014
                rts
;-------------------------------------------------------------------------------                
Sonic_ChgJumpDir:                                              ; PBoffset_0x015956
                move.w  (Sonic_Max_Speed).w, D6                      ; $FFFFF760
                move.w  (Sonic_Acceleration).w, D5                   ; $FFFFF762
                asl.w   #$01, D5
                btst    #$04, Obj_Status(A0)                             ; $0022
                bne.s   PBoffset_0x0159A0
                move.w  Obj_Speed(A0), D0                                ; $0010
                btst    #$02, ($FFFFF602).w
                beq.s   PBoffset_0x015986
                bset    #$00, Obj_Status(A0)                             ; $0022
                sub.w   D5, D0
                move.w  D6, D1
                neg.w   D1
                cmp.w   D1, D0
                bgt.s   PBoffset_0x015986
                move.w  D1, D0
PBoffset_0x015986:
                btst    #$03, ($FFFFF602).w
                beq.s   PBoffset_0x01599C
                bclr    #$00, Obj_Status(A0)                             ; $0022
                add.w   D5, D0
                cmp.w   D6, D0
                blt.s   PBoffset_0x01599C
                move.w  D6, D0
PBoffset_0x01599C:
                move.w  D0, Obj_Speed(A0)                                ; $0010
PBoffset_0x0159A0:
                cmpi.w  #$0060, ($FFFFEED8).w
                beq.s   PBoffset_0x0159B2
                bcc.s   PBoffset_0x0159AE
                addq.w  #$04, ($FFFFEED8).w
PBoffset_0x0159AE:
                subq.w  #$02, ($FFFFEED8).w
PBoffset_0x0159B2:
                cmpi.w  #$FC00, Obj_Speed_Y(A0)                          ; $0012
                bcs.s   PBoffset_0x0159E0
                move.w  Obj_Speed(A0), D0                                ; $0010
                move.w  D0, D1
                asr.w   #$05, D1
                beq.s   PBoffset_0x0159E0
                bmi.s   PBoffset_0x0159D4
                sub.w   D1, D0
                bcc.s   PBoffset_0x0159CE
                move.w  #$0000, D0
PBoffset_0x0159CE:
                move.w  D0, Obj_Speed(A0)                                ; $0010
                rts
PBoffset_0x0159D4:
                sub.w   D1, D0
                bcs.s   PBoffset_0x0159DC
                move.w  #$0000, D0
PBoffset_0x0159DC:
                move.w  D0, Obj_Speed(A0)                                ; $0010
PBoffset_0x0159E0:
                rts
;-------------------------------------------------------------------------------                
Sonic_LevelBoundaries:                                         ; PBoffset_0x0159E2
                move.l  Obj_X(A0), D1                                    ; $0008
                move.w  Obj_Speed(A0), D0                                ; $0010
                ext.l   D0
                asl.l   #$08, D0
                add.l   D0, D1
                swap.w  D1
                move.w  (Sonic_Level_Limits_Min_X).w, D0             ; $FFFFEEC8
                addi.w  #$0010, D0
                cmp.w   D1, D0
                bhi.s   PBoffset_0x015A28
                move.w  (Sonic_Level_Limits_Max_X).w, D0             ; $FFFFEECA
                addi.w  #$0128, D0
                tst.b   (Boss_Flag).w                                ; $FFFFF7AA
                bne.s   PBoffset_0x015A10
                addi.w  #$0040, D0
PBoffset_0x015A10:
                cmp.w   D1, D0
                bls.s   PBoffset_0x015A28
PBoffset_0x015A14:
                move.w  (Sonic_Level_Limits_Max_Y).w, D0             ; $FFFFEECE
                addi.w  #$00E0, D0
                cmp.w   Obj_Y(A0), D0                                    ; $000C
                blt.s   PBoffset_0x015A24
                rts
PBoffset_0x015A24:
                bra     Kill_Sonic                             ; PBoffset_0x016708
PBoffset_0x015A28:
                move.w  D0, Obj_X(A0)                                    ; $0008
                move.w  #$0000, Obj_Sub_Y(A0)                            ; $000A
                move.w  #$0000, Obj_Speed(A0)                            ; $0010
                move.w  #$0000, Obj_Inertia(A0)                          ; $0014
                bra.s   PBoffset_0x015A14
;-------------------------------------------------------------------------------                
Sonic_Roll:                                                    ; PBoffset_0x015A40
                tst.b   Obj_Player_Status(A0)                            ; $002B
                bmi.s   PBoffset_0x015A66
                move.w  Obj_Inertia(A0), D0                              ; $0014
                bpl.s   PBoffset_0x015A4E
                neg.w   D0
PBoffset_0x015A4E:
                cmpi.w  #$0080, D0
                bcs.s   PBoffset_0x015A66
                move.b  ($FFFFF602).w, D0
                andi.b  #$0C, D0
                bne.s   PBoffset_0x015A66
                btst    #$01, ($FFFFF602).w
                bne.s   PBoffset_0x015A68
PBoffset_0x015A66:
                rts
PBoffset_0x015A68:
                btst    #$02, Obj_Status(A0)                             ; $0022
                beq.s   PBoffset_0x015A72
                rts
PBoffset_0x015A72:
                bset    #$02, Obj_Status(A0)                             ; $0022
                move.b  #$0E, Obj_Height_2(A0)                           ; $0016
                move.b  #$07, Obj_Width_2(A0)                            ; $0017
                move.b  #$02, Obj_Ani_Number(A0)                         ; $001C
                addq.w  #$05, Obj_Y(A0)                                  ; $000C
                move.w  #$00BE, D0
                jsr     (Play_Sfx)                             ; PBoffset_0x001912
                tst.w   Obj_Inertia(A0)                                  ; $0014
                bne.s   PBoffset_0x015AA4
                move.w  #$0200, Obj_Inertia(A0)                          ; $0014
PBoffset_0x015AA4:
                rts
;-------------------------------------------------------------------------------                
Sonic_Jump:                                                    ; PBoffset_0x015AA6
                move.b  ($FFFFF603).w, D0
                andi.b  #$70, D0
                beq     PBoffset_0x015B54
                moveq   #$00, D0
                move.b  Obj_Angle(A0), D0                                ; $0026
                addi.b  #$80, D0
                bsr     CalcRoomOverHead                       ; PBoffset_0x0199CE
                cmpi.w  #$0006, D1
                blt     PBoffset_0x015B54
                move.w  #$0680, D2
                tst.b   (Super_Sonic_Flag).w                         ; $FFFFFE19
                beq.s   PBoffset_0x015AD6
                move.w  #$0800, D2
PBoffset_0x015AD6:
                btst    #$06, Obj_Status(A0)                             ; $0022
                beq.s   PBoffset_0x015AE2
                move.w  #$0380, D2
PBoffset_0x015AE2:
                moveq   #$00, D0
                move.b  Obj_Angle(A0), D0                                ; $0026
                subi.b  #$40, D0
                jsr     (CalcSine)                             ; PBoffset_0x00396A
                muls.w  D2, D1
                asr.l   #$08, D1
                add.w   D1, Obj_Speed(A0)                                ; $0010
                muls.w  D2, D0
                asr.l   #$08, D0
                add.w   D0, Obj_Speed_Y(A0)                              ; $0012
                bset    #$01, Obj_Status(A0)                             ; $0022
                bclr    #$05, Obj_Status(A0)                             ; $0022
                addq.l  #$04, A7
                move.b  #$01, Obj_Player_Jump(A0)                        ; $003C
                clr.b   Obj_Player_St_Convex(A0)                         ; $0038
                move.w  #$00A0, D0
                jsr     (Play_Sfx)                             ; PBoffset_0x001912
                move.b  #$13, Obj_Height_2(A0)                           ; $0016
                move.b  #$09, Obj_Width_2(A0)                            ; $0017
                btst    #$02, Obj_Status(A0)                             ; $0022
                bne.s   PBoffset_0x015B56
                move.b  #$0E, Obj_Height_2(A0)                           ; $0016
                move.b  #$07, Obj_Width_2(A0)                            ; $0017
                move.b  #$02, Obj_Ani_Number(A0)                         ; $001C
                bset    #$02, Obj_Status(A0)                             ; $0022
                addq.w  #$05, Obj_Y(A0)                                  ; $000C
PBoffset_0x015B54:
                rts
PBoffset_0x015B56:
                bset    #$04, Obj_Status(A0)                             ; $0022
                rts
;-------------------------------------------------------------------------------                
Sonic_JumpHeight:                                              ; PBoffset_0x015B5E
                tst.b   Obj_Player_Jump(A0)                              ; $003C
                beq.s   PBoffset_0x015B8A
                move.w  #$FC00, D1
                btst    #$06, Obj_Status(A0)                             ; $0022
                beq.s   PBoffset_0x015B74
                move.w  #$FE00, D1
PBoffset_0x015B74:
                cmp.w   Obj_Speed_Y(A0), D1                              ; $0012
                ble.s   PBoffset_0x015B88
                move.b  ($FFFFF602).w, D0
                andi.b  #$70, D0
                bne.s   PBoffset_0x015B88
                move.w  D1, Obj_Speed_Y(A0)                              ; $0012
PBoffset_0x015B88:
                rts
PBoffset_0x015B8A:
                tst.b   Obj_Player_Spdsh_Flag(A0)                        ; $0039
                bne.s   PBoffset_0x015B9E
                cmpi.w  #$F040, Obj_Speed_Y(A0)                          ; $0012
                bge.s   PBoffset_0x015B9E
                move.w  #$F040, Obj_Speed_Y(A0)                          ; $0012
PBoffset_0x015B9E:
                rts
;-------------------------------------------------------------------------------                
Sonic_Spindash:                                                ; PBoffset_0x015BA0
                tst.b   Obj_Player_Spdsh_Flag(A0)                        ; $0039
                bne.s   PBoffset_0x015BE8
                cmpi.b  #$08, Obj_Ani_Number(A0)                         ; $001C
                bne.s   PBoffset_0x015BE6
                move.b  ($FFFFF603).w, D0
                andi.b  #$70, D0
                beq     PBoffset_0x015BE6
                move.b  #$09, Obj_Ani_Number(A0)                         ; $001C
                move.w  #$00E0, D0
                jsr     (Play_Sfx)                             ; PBoffset_0x001912
                addq.l  #$04, A7
                move.b  #$01, Obj_Player_Spdsh_Flag(A0)                  ; $0039
                move.w  #$0000, Obj_Player_Spdsh_Cnt(A0)                 ; $003A
                cmpi.b  #$0C, Obj_Subtype(A0)                            ; $0028
                bcs.s   PBoffset_0x015BE6
                move.b  #$02, ($FFFFB41C).w
PBoffset_0x015BE6:
                rts
PBoffset_0x015BE8:
                move.b  ($FFFFF602).w, D0
                btst    #$01, D0
                bne     PBoffset_0x015C78
                move.b  #$0E, Obj_Height_2(A0)                           ; $0016
                move.b  #$07, Obj_Width_2(A0)                            ; $0017
                move.b  #$02, Obj_Ani_Number(A0)                         ; $001C
                addq.w  #$05, Obj_Y(A0)                                  ; $000C
                move.b  #$00, Obj_Player_Spdsh_Flag(A0)                  ; $0039
                move.w  #$2000, ($FFFFEED0).w
                moveq   #$00, D0
                move.b  Obj_Player_Spdsh_Cnt(A0), D0                     ; $003A
                add.w   D0, D0
                move.w  Sonic_Spindash_Speed(PC, D0), Obj_Inertia(A0)  ; PBoffset_0x015C54, $0014
                tst.b   (Super_Sonic_Flag).w                         ; $FFFFFE19
                beq.s   PBoffset_0x015C30
                move.w  Super_Sonic_Spindash_Speed(PC, D0), Obj_Inertia(A0) ; PBoffset_0x015C66, $0014
PBoffset_0x015C30:
                btst    #$00, Obj_Status(A0)                             ; $0022
                beq.s   PBoffset_0x015C3C
                neg.w   Obj_Inertia(A0)                                  ; $0014
PBoffset_0x015C3C:
                bset    #$02, Obj_Status(A0)                             ; $0022
                move.b  #$00, ($FFFFB41C).w
                move.w  #$00BC, D0
                jsr     (Play_Sfx)                             ; PBoffset_0x001912
                bra.s   PBoffset_0x015CC0       
;-------------------------------------------------------------------------------
Sonic_Spindash_Speed:                                          ; PBoffset_0x015C54     
                dc.w    $0800, $0880, $0900, $0980, $0A00, $0A80, $0B00, $0B80
                dc.w    $0C00
;-------------------------------------------------------------------------------
Super_Sonic_Spindash_Speed:                                    ; PBoffset_0x015C66    
                dc.w    $0B00, $0B80, $0C00, $0C80, $0D00, $0D80, $0E00, $0E80
                dc.w    $0F00
;-------------------------------------------------------------------------------
PBoffset_0x015C78:
                tst.w   Obj_Player_Spdsh_Cnt(A0)                         ; $003A
                beq.s   PBoffset_0x015C90                            
                move.w  Obj_Player_Spdsh_Cnt(A0), D0                     ; $003A
                lsr.w   #$05, D0
                sub.w   D0, Obj_Player_Spdsh_Cnt(A0)                     ; $003A
                bcc.s   PBoffset_0x015C90
                move.w  #$0000, Obj_Player_Spdsh_Cnt(A0)                 ; $003A
PBoffset_0x015C90:
                move.b  ($FFFFF603).w, D0
                andi.b  #$70, D0
                beq     PBoffset_0x015CC0
                move.w  #$0900, Obj_Ani_Number(A0)                       ; $001C
                move.w  #$00E0, D0
                jsr     (Play_Sfx)                             ; PBoffset_0x001912
                addi.w  #$0200, Obj_Player_Spdsh_Cnt(A0)                 ; $003A
                cmpi.w  #$0800, Obj_Player_Spdsh_Cnt(A0)                 ; $003A
                bcs.s   PBoffset_0x015CC0
                move.w  #$0800, Obj_Player_Spdsh_Cnt(A0)                 ; $003A
PBoffset_0x015CC0:
                addq.l  #$04, A7
                rts
;-------------------------------------------------------------------------------                
Sonic_SlopeResist:                                             ; PBoffset_0x015CC4
                move.b  Obj_Angle(A0), D0                                ; $0026
                addi.b  #$60, D0
                cmpi.b  #$C0, D0
                bcc.s   PBoffset_0x015CF8
                move.b  Obj_Angle(A0), D0                                ; $0026
                jsr     (CalcSine)                             ; PBoffset_0x00396A
                muls.w  #$0020, D0
                asr.l   #$08, D0
                tst.w   Obj_Inertia(A0)                                  ; $0014
                beq.s   PBoffset_0x015CF8
                bmi.s   PBoffset_0x015CF4
                tst.w   D0
                beq.s   PBoffset_0x015CF2
                add.w   D0, Obj_Inertia(A0)                              ; $0014
PBoffset_0x015CF2:
                rts
PBoffset_0x015CF4:
                add.w   D0, Obj_Inertia(A0)                              ; $0014
PBoffset_0x015CF8:
                rts
;-------------------------------------------------------------------------------                
Sonic_RollRepel:                                               ; PBoffset_0x015CFA
                move.b  Obj_Angle(A0), D0                                ; $0026
                addi.b  #$60, D0
                cmpi.b  #$C0, D0
                bcc.s   PBoffset_0x015D34
                move.b  Obj_Angle(A0), D0                                ; $0026
                jsr     (CalcSine)                             ; PBoffset_0x00396A
                muls.w  #$0050, D0
                asr.l   #$08, D0
                tst.w   Obj_Inertia(A0)                                  ; $0014
                bmi.s   PBoffset_0x015D2A
                tst.w   D0
                bpl.s   PBoffset_0x015D24
                asr.l   #$02, D0
PBoffset_0x015D24:
                add.w   D0, Obj_Inertia(A0)                              ; $0014
                rts
PBoffset_0x015D2A:
                tst.w   D0
                bmi.s   PBoffset_0x015D30
                asr.l   #$02, D0
PBoffset_0x015D30:
                add.w   D0, Obj_Inertia(A0)                              ; $0014
PBoffset_0x015D34:
                rts
;-------------------------------------------------------------------------------                
Sonic_SlopeRepel:                                              ; PBoffset_0x015D36
                nop
                tst.b   Obj_Player_St_Convex(A0)                         ; $0038
                bne.s   PBoffset_0x015D70
                tst.w   Obj_Player_Control(A0)                           ; $002E
                bne.s   PBoffset_0x015D72
                move.b  Obj_Angle(A0), D0                                ; $0026
                addi.b  #$20, D0
                andi.b  #$C0, D0
                beq.s   PBoffset_0x015D70
                move.w  Obj_Inertia(A0), D0                              ; $0014
                bpl.s   PBoffset_0x015D5A
                neg.w   D0
PBoffset_0x015D5A:
                cmpi.w  #$0280, D0
                bcc.s   PBoffset_0x015D70
                clr.w   Obj_Inertia(A0)                                  ; $0014
                bset    #$01, Obj_Status(A0)                             ; $0022
                move.w  #$001E, Obj_Player_Control(A0)                   ; $002E
PBoffset_0x015D70:
                rts
PBoffset_0x015D72:
                subq.w  #$01, Obj_Player_Control(A0)                     ; $002E
                rts
;-------------------------------------------------------------------------------                 
Sonic_JumpAngle:                                               ; PBoffset_0x015D78
                move.b  Obj_Angle(A0), D0                                ; $0026
                beq.s   PBoffset_0x015D92
                bpl.s   PBoffset_0x015D88
                addq.b  #$02, D0
                bcc.s   PBoffset_0x015D86
                moveq   #$00, D0
PBoffset_0x015D86:
                bra.s   PBoffset_0x015D8E
PBoffset_0x015D88:
                subq.b  #$02, D0
                bcc.s   PBoffset_0x015D8E
                moveq   #$00, D0
PBoffset_0x015D8E:
                move.b  D0, Obj_Angle(A0)                                ; $0026
PBoffset_0x015D92:
                move.b  Obj_Flip_Angle(A0), D0                           ; $0027
                beq.s   PBoffset_0x015DD6
                tst.w   Obj_Inertia(A0)                                  ; $0014
                bmi.s   PBoffset_0x015DB6
PBoffset_0x015D9E:
                move.b  Obj_Player_Flip_Speed(A0), D1                    ; $002D  
                add.b   D1, D0
                bcc.s   PBoffset_0x015DB4
                subq.b  #$01, Obj_P_Flips_Remaining(A0)                  ; $002C
                bcc.s   PBoffset_0x015DB4
                move.b  #$00, Obj_P_Flips_Remaining(A0)                  ; $002C
                moveq   #$00, D0
PBoffset_0x015DB4:
                bra.s   PBoffset_0x015DD2
PBoffset_0x015DB6:
                tst.b   Obj_Player_Flip_Flag(A0)                         ; $0029
                bne.s   PBoffset_0x015D9E
                move.b  Obj_Player_Flip_Speed(A0), D1                    ; $002D
                sub.b   D1, D0
                bcc.s   PBoffset_0x015DD2
                subq.b  #$01, Obj_P_Flips_Remaining(A0)                  ; $002C
                bcc.s   PBoffset_0x015DD2
                move.b  #$00, Obj_P_Flips_Remaining(A0)                  ; $002C
                moveq   #$00, D0
PBoffset_0x015DD2:
                move.b  D0, Obj_Flip_Angle(A0)                           ; $0027
PBoffset_0x015DD6:
                rts
;-------------------------------------------------------------------------------                
Sonic_Floor:                                                   ; PBoffset_0x015DD8
                move.l  #Primary_Colision_Data_Buffer, (Current_Colision_Pointer).w     ; $FFFFD000, $FFFFF796
                cmpi.b  #$0C, Obj_Player_Top_Solid(A0)                   ; $003E
                beq.s   PBoffset_0x015DF0
                move.l  #Secundary_Colision_Data_Buffer, (Current_Colision_Pointer).w     ; $FFFFD600, $FFFFF796
PBoffset_0x015DF0:
                move.b  Obj_Player_LRB_Solid(A0), D5                     ; $003F
                move.w  Obj_Speed(A0), D1                                ; $0010
                move.w  Obj_Speed_Y(A0), D2                              ; $0012
                jsr     (CalcAngle)                            ; PBoffset_0x003C02
									   
                subi.b  #$20, D0
                andi.b  #$C0, D0
                cmpi.b  #$40, D0
                beq     PBoffset_0x015EBA
                cmpi.b  #$80, D0
                beq     PBoffset_0x015F16
                cmpi.b  #$C0, D0
                beq     PBoffset_0x015F72
                bsr     Player_HitWall                         ; PBoffset_0x019DD8
                tst.w   D1
                bpl.s   PBoffset_0x015E34
                sub.w   D1, Obj_X(A0)                                    ; $0008
                move.w  #$0000, Obj_Speed(A0)                            ; $0010
PBoffset_0x015E34:
                bsr     Offset_0x0142E6
                tst.w   D1
                bpl.s   PBoffset_0x015E46
                add.w   D1, Obj_X(A0)                                    ; $0008
                move.w  #$0000, Obj_Speed(A0)                            ; $0010
PBoffset_0x015E46:
                bsr     Offset_0x0140A2
                tst.w   D1
                bpl.s   PBoffset_0x015EB8
                move.b  Obj_Speed_Y(A0), D2                              ; $0012
                addq.b  #$08, D2
                neg.b   D2
                cmp.b   D2, D1
                bge.s   PBoffset_0x015E5E
                cmp.b   D2, D0
                blt.s   PBoffset_0x015EB8
PBoffset_0x015E5E:
                add.w   D1, Obj_Y(A0)                                    ; $000C
                move.b  D3, Obj_Angle(A0)                                ; $0026
                bsr     PBoffset_0x015FCE
									   
                move.b  D3, D0
                addi.b  #$20, D0
                andi.b  #$40, D0
                bne.s   PBoffset_0x015E96
                move.b  D3, D0
                addi.b  #$10, D0
                andi.b  #$20, D0
                beq.s   PBoffset_0x015E88
                asr.w   Obj_Speed_Y(A0)                                  ; $0012
                bra.s   PBoffset_0x015EAA
PBoffset_0x015E88:
                move.w  #$0000, Obj_Speed_Y(A0)                          ; $0012
                move.w  Obj_Speed(A0), Obj_Inertia(A0)            ; $0010, $0014
                rts
PBoffset_0x015E96:
                move.w  #$0000, Obj_Speed(A0)                            ; $0010
                cmpi.w  #$0FC0, Obj_Speed_Y(A0)                          ; $0012
                ble.s   PBoffset_0x015EAA
                move.w  #$0FC0, Obj_Speed_Y(A0)                          ; $0012
PBoffset_0x015EAA:
                move.w  Obj_Speed_Y(A0), Obj_Inertia(A0)          ; $0012, $0014
                tst.b   D3
                bpl.s   PBoffset_0x015EB8
                neg.w   Obj_Inertia(A0)                                  ; $0014
PBoffset_0x015EB8:
                rts
PBoffset_0x015EBA:
                bsr     Player_HitWall                         ; PBoffset_0x019DD8
                tst.w   D1
                bpl.s   PBoffset_0x015ED4
                sub.w   D1, Obj_X(A0)                                    ; $0008
                move.w  #$0000, Obj_Speed(A0)                            ; $0010
                move.w  Obj_Speed_Y(A0), Obj_Inertia(A0)          ; $0012, $0014
                rts
PBoffset_0x015ED4:
                bsr     Player_DontRunOnWalls                  ; PBoffset_0x019CA8
                tst.w   D1
                bpl.s   PBoffset_0x015EEE
                sub.w   D1, Obj_Y(A0)                                    ; $000C
                tst.w   Obj_Speed_Y(A0)                                  ; $0012
                bpl.s   PBoffset_0x015EEC
                move.w  #$0000, Obj_Speed_Y(A0)                          ; $0012
PBoffset_0x015EEC:
                rts
PBoffset_0x015EEE:
                tst.w   Obj_Speed_Y(A0)                                  ; $0012
                bmi.s   PBoffset_0x015F14
                bsr     Offset_0x0140A2
                tst.w   D1
                bpl.s   PBoffset_0x015F14
                add.w   D1, Obj_Y(A0)                                    ; $000C
                move.b  D3, Obj_Angle(A0)                                ; $0026
                bsr     PBoffset_0x015FCE
				   
                move.w  #$0000, Obj_Speed_Y(A0)                          ; $0012
                move.w  Obj_Speed(A0), Obj_Inertia(A0)            ; $0010, $0014
PBoffset_0x015F14:
                rts
PBoffset_0x015F16:
                bsr     Player_HitWall                         ; PBoffset_0x019DD8
                tst.w   D1
                bpl.s   PBoffset_0x015F28
                sub.w   D1, Obj_X(A0)                                    ; $0008
                move.w  #$0000, Obj_Speed(A0)                            ; $0010
PBoffset_0x015F28:
                bsr     Offset_0x0142E6
                tst.w   D1
                bpl.s   PBoffset_0x015F3A
                add.w   D1, Obj_X(A0)                                    ; $0008
                move.w  #$0000, Obj_Speed(A0)                            ; $0010
PBoffset_0x015F3A:
                bsr     Player_DontRunOnWalls                  ; PBoffset_0x019CA8
                tst.w   D1
                bpl.s   PBoffset_0x015F70
                sub.w   D1, Obj_Y(A0)                                    ; $000C
                move.b  D3, D0
                addi.b  #$20, D0
                andi.b  #$40, D0
                bne.s   PBoffset_0x015F5A
                move.w  #$0000, Obj_Speed_Y(A0)                          ; $0012
                rts
PBoffset_0x015F5A:
                move.b  D3, Obj_Angle(A0)                                ; $0026
                bsr     PBoffset_0x015FCE
                move.w  Obj_Speed_Y(A0), Obj_Inertia(A0)          ; $0012, $0014
                tst.b   D3
                bpl.s   PBoffset_0x015F70
                neg.w   Obj_Inertia(A0)                                  ; $0014
PBoffset_0x015F70:
                rts
PBoffset_0x015F72:
                bsr     Offset_0x0142E6
                tst.w   D1
                bpl.s   PBoffset_0x015F8C
                add.w   D1, Obj_X(A0)                                    ; $0008
                move.w  #$0000, Obj_Speed(A0)                            ; $0010
                move.w  Obj_Speed_Y(A0), Obj_Inertia(A0)          ; $0012, $0014
                rts
PBoffset_0x015F8C:
                bsr     Player_DontRunOnWalls                  ; PBoffset_0x019CA8
                tst.w   D1
                bpl.s   PBoffset_0x015FA6
                sub.w   D1, Obj_Y(A0)                                    ; $000C
                tst.w   Obj_Speed_Y(A0)                                  ; $0012
                bpl.s   PBoffset_0x015FA4
                move.w  #$0000, Obj_Speed_Y(A0)                          ; $0012
PBoffset_0x015FA4:
                rts
PBoffset_0x015FA6:
                tst.w   Obj_Speed_Y(A0)                                  ; $0012
                bmi.s   PBoffset_0x015FCC
                bsr     Offset_0x0140A2
                tst.w   D1
                bpl.s   PBoffset_0x015FCC
                add.w   D1, Obj_Y(A0)                                    ; $000C
                move.b  D3, Obj_Angle(A0)                                ; $0026
                bsr     PBoffset_0x015FCE
				   
                move.w  #$0000, Obj_Speed_Y(A0)                          ; $0012
                move.w  Obj_Speed(A0), Obj_Inertia(A0)            ; $0010, $0014
PBoffset_0x015FCC:
                rts
PBoffset_0x015FCE:
                tst.b   Obj_Player_Spdsh_Flag(A0)                        ; $0039   
                bne.s   PBoffset_0x015FFE
                move.b  #$00, Obj_Ani_Number(A0)                         ; $001C
Sonic_ResetOnFloor:                                            ; PBoffset_0x015FDA                
                btst    #$02, Obj_Status(A0)                             ; $0022
                beq.s   PBoffset_0x015FFE
                bclr    #$02, Obj_Status(A0)                             ; $0022
                move.b  #$13, Obj_Height_2(A0)                           ; $0016
                move.b  #$09, Obj_Width_2(A0)                            ; $0017
                move.b  #$00, Obj_Ani_Number(A0)                         ; $001C
                subq.w  #$05, Obj_Y(A0)                                  ; $000C
PBoffset_0x015FFE:
                bclr    #$01, Obj_Status(A0)                             ; $0022
                bclr    #$05, Obj_Status(A0)                             ; $0022
                bclr    #$04, Obj_Status(A0)                             ; $0022
                move.b  #$00, Obj_Player_Jump(A0)                        ; $003C
                move.w  #$0000, ($FFFFF7D0).w
                move.b  #$00, Obj_Flip_Angle(A0)                         ; $0027
                move.b  #$00, Obj_Player_Flip_Flag(A0)                   ; $0029
                move.b  #$00, Obj_P_Flips_Remaining(A0)                  ; $002C
                cmpi.b  #$14, Obj_Ani_Number(A0)                         ; $001C
                bne.s   PBoffset_0x01603C
                move.b  #$00, Obj_Ani_Number(A0)                         ; $001C
PBoffset_0x01603C:
                rts   
;-------------------------------------------------------------------------------
Sonic_Hurt:                                                    ; PBoffset_0x01603E
                tst.w   (Debug_Mode_Active_Flag).w                   ; $FFFFFFFA
                beq.s   Sonic_Hurt_Normal                      ; PBoffset_0x016058
                btst    #$04, (Control_Ports_Buffer_Data+$0001).w    ; $FFFFF605
                beq.s   Sonic_Hurt_Normal                      ; PBoffset_0x016058
                move.w  #$0001, (Debug_Mode_Flag_Index).w            ; $FFFFFE08
                clr.b   ($FFFFF7CC).w
                rts
;-------------------------------------------------------------------------------                
Sonic_Hurt_Normal:                                             ; PBoffset_0x016058
                tst.b   Obj_Routine_2(A0)                                ; $0025
                bmi     PBoffset_0x0160D6
                jsr     (SpeedToPos)                           ; PBoffset_0x011F96
                addi.w  #$0030, Obj_Speed_Y(A0)                          ; $0012
                btst    #$06, Obj_Status(A0)                             ; $0022
                beq.s   PBoffset_0x01607A
                subi.w  #$0020, Obj_Speed_Y(A0)                          ; $0012
PBoffset_0x01607A:
                bsr     Sonic_HurtStop                         ; PBoffset_0x016094
                bsr     Sonic_LevelBoundaries                  ; PBoffset_0x0159E2
                bsr     CopySonicMovesForMiles                 ; PBoffset_0x01523A
                bsr     Sonic_Animate                          ; PBoffset_0x0161C6
                bsr     Load_Sonic_Dynamic_PLC                 ; PBoffset_0x0166B2
                jmp     (DisplaySprite)                        ; PBoffset_0x0120DE
;-------------------------------------------------------------------------------
Sonic_HurtStop:                                                ; PBoffset_0x016094
                move.w  (Sonic_Level_Limits_Max_Y).w, D0             ; $FFFFEECE
                addi.w  #$00E0, D0
                cmp.w   Obj_Y(A0), D0                                    ; $000C
                blt     Kill_Sonic                             ; PBoffset_0x016708
                bsr     Sonic_Floor                            ; PBoffset_0x015DD8
                btst    #$01, Obj_Status(A0)                             ; $0022
                bne.s   PBoffset_0x0160D4
                moveq   #$00, D0
                move.w  D0, Obj_Speed_Y(A0)                              ; $0012
                move.w  D0, Obj_Speed(A0)                                ; $0010
                move.w  D0, Obj_Inertia(A0)                              ; $0014
                move.b  #$00, Obj_Ani_Number(A0)                         ; $001C
                subq.b  #$02, Obj_Routine(A0)                            ; $0024
                move.w  #$0078, Obj_P_Invunerblt_Time(A0)                ; $0030
                move.b  #$00, Obj_Player_Spdsh_Flag(A0)                  ; $0039
PBoffset_0x0160D4:
                rts
;-------------------------------------------------------------------------------                
PBoffset_0x0160D6:
                subq.b  #$02, Obj_Routine(A0)                            ; $0024
                move.b  #$00, Obj_Routine_2(A0)                          ; $0025
                bsr     CopySonicMovesForMiles                 ; PBoffset_0x01523A
                bsr     Sonic_Animate                          ; PBoffset_0x0161C6
                bsr     Load_Sonic_Dynamic_PLC                 ; PBoffset_0x0166B2
                jmp     (DisplaySprite)                        ; PBoffset_0x0120DE
;-------------------------------------------------------------------------------
Sonic_Death:                                                   ; PBoffset_0x0160F2
                tst.w   (Debug_Mode_Active_Flag).w                   ; $FFFFFFFA
                beq.s   PBoffset_0x01610C                                         
                btst    #$04, (Control_Ports_Buffer_Data+$0001).w    ; $FFFFF605
                beq.s   PBoffset_0x01610C                                         
                move.w  #$0001, (Debug_Mode_Flag_Index).w            ; $FFFFFE08
                clr.b   ($FFFFF7CC).w                                           
                rts                                                             
PBoffset_0x01610C:
                bsr     Sonic_GameOver                         ; PBoffset_0x016128                                         
                jsr     (ObjectFall)                           ; PBoffset_0x011F6A
                bsr     CopySonicMovesForMiles                 ; PBoffset_0x01523A
                bsr     Sonic_Animate                          ; PBoffset_0x0161C6
                bsr     Load_Sonic_Dynamic_PLC                 ; PBoffset_0x0166B2
                jmp     (DisplaySprite)                        ; PBoffset_0x0120DE
;-------------------------------------------------------------------------------                
Sonic_GameOver:                                                ; PBoffset_0x016128
                move.b  #$00, Obj_Player_Spdsh_Flag(A0)                  ; $0039
                move.w  (Sonic_Level_Limits_Max_Y).w, D0             ; $FFFFEECE
                addi.w  #$0100, D0
                cmp.w   Obj_Y(A0), D0                                    ; $000C
                bge     PBoffset_0x0161B0
                move.w  #$FFC8, Obj_Speed_Y(A0)                          ; $0012
                addq.b  #$02, Obj_Routine(A0)                            ; $0024
                clr.b   (HUD_Timer_Refresh_Flag).w                   ; $FFFFFE1E
                addq.b  #$01, (HUD_Life_Refresh_Flag).w              ; $FFFFFE1C
                subq.b  #$01, (Life_Count).w                         ; $FFFFFE12
                bne.s   PBoffset_0x016184
                move.w  #$0000, Obj_Player_Spdsh_Cnt(A0)                 ; $003A
                move.b  #$39, ($FFFFB080).w
                move.b  #$39, ($FFFFB0C0).w
                move.b  #$01, ($FFFFB0DA).w
                clr.b   ($FFFFFE1A).w
PBoffset_0x016172:
                move.w  #$009B, D0
                jsr     (Play_Music)                           ; PBoffset_0x00190C
                moveq   #$03, D0
                jmp     (LoadPLC)                              ; PBoffset_0x001BB4
PBoffset_0x016184:
                move.w  #$003C, Obj_Player_Spdsh_Cnt(A0)                 ; $003A
                tst.b   ($FFFFFE1A).w
                beq.s   PBoffset_0x0161B0
                move.w  #$0000, Obj_Player_Spdsh_Cnt(A0)                 ; $003A
                move.b  #$39, ($FFFFB080).w
                move.b  #$39, ($FFFFB0C0).w
                move.b  #$02, ($FFFFB09A).w
                move.b  #$03, ($FFFFB0DA).w
                bra.s   PBoffset_0x016172
PBoffset_0x0161B0:
                rts    
;-------------------------------------------------------------------------------
Sonic_ResetLevel:                                              ; PBoffset_0x0161B2
                tst.w   Obj_Player_Spdsh_Cnt(A0)                         ; $003A
                beq.s   PBoffset_0x0161C4
                subq.w  #$01, Obj_Player_Spdsh_Cnt(A0)                   ; $003A
                bne.s   PBoffset_0x0161C4
                move.w  #$0001, ($FFFFFE02).w
PBoffset_0x0161C4:
                rts    
;-------------------------------------------------------------------------------
Sonic_Animate:                                                 ; PBoffset_0x0161C6
                lea     (PBoffset_0x01648E), A1
                tst.b   (Super_Sonic_Flag).w                         ; $FFFFFE19
                beq.s   PBoffset_0x0161D8
                lea     (PBoffset_0x016630), A1
PBoffset_0x0161D8:
                moveq   #$00, D0
                move.b  Obj_Ani_Number(A0), D0                           ; $001C
                cmp.b   Obj_Ani_Flag(A0), D0                             ; $001D
                beq.s   PBoffset_0x0161FA
                move.b  D0, Obj_Ani_Flag(A0)                             ; $001D
                move.b  #$00, Obj_Ani_Frame(A0)                          ; $001B
                move.b  #$00, Obj_Ani_Time(A0)                           ; $001E
                bclr    #$05, Obj_Status(A0)                             ; $0022
PBoffset_0x0161FA:
                add.w   D0, D0
                adda.w  $00(A1, D0), A1
                move.b  (A1), D0
                bmi.s   PBoffset_0x01626A
                move.b  Obj_Status(A0), D1                               ; $0022
                andi.b  #$01, D1
                andi.b  #$FC, Obj_Flags(A0)                              ; $0001
                or.b    D1, Obj_Flags(A0)                                ; $0001
                subq.b  #$01, Obj_Ani_Time(A0)                           ; $001E
                bpl.s   PBoffset_0x016238
                move.b  D0, Obj_Ani_Time(A0)                             ; $001E
PBoffset_0x016220:
                moveq   #$00, D1
                move.b  Obj_Ani_Frame(A0), D1                            ; $001B
                move.b  $01(A1, D1), D0
                cmpi.b  #$F0, D0
                bcc.s   PBoffset_0x01623A
PBoffset_0x016230:
                move.b  D0, Obj_Map_Id(A0)                               ; $001A
                addq.b  #$01, Obj_Ani_Frame(A0)                          ; $001B
PBoffset_0x016238:
                rts
PBoffset_0x01623A:
                addq.b  #$01, D0
                bne.s   PBoffset_0x01624A
                move.b  #$00, Obj_Ani_Frame(A0)                          ; $001B
                move.b  Obj_Flags(A1), D0                                ; $0001
                bra.s   PBoffset_0x016230
PBoffset_0x01624A:
                addq.b  #$01, D0
                bne.s   PBoffset_0x01625E
                move.b  $02(A1, D1), D0
                sub.b   D0, Obj_Ani_Frame(A0)                            ; $001B
                sub.b   D0, D1
                move.b  $01(A1, D1), D0
                bra.s   PBoffset_0x016230
PBoffset_0x01625E:
                addq.b  #$01, D0
                bne.s   PBoffset_0x016268
                move.b  $02(A1, D1), Obj_Ani_Number(A0)                  ; $001C
PBoffset_0x016268:
                rts
PBoffset_0x01626A:
                addq.b  #$01, D0
                bne     PBoffset_0x0163FC
                moveq   #$00, D0
                move.b  Obj_Flip_Angle(A0), D0                           ; $0027
                bne     PBoffset_0x016396
                moveq   #$00, D1
                move.b  Obj_Angle(A0), D0                                ; $0026
                bmi.s   PBoffset_0x016286
                beq.s   PBoffset_0x016286
                subq.b  #$01, D0
PBoffset_0x016286:
                move.b  Obj_Status(A0), D2                               ; $0022
                andi.b  #$01, D2
                bne.s   PBoffset_0x016292
                not.b   D0
PBoffset_0x016292:
                addi.b  #$10, D0
                bpl.s   PBoffset_0x01629A
                moveq   #$03, D1
PBoffset_0x01629A:
                andi.b  #$FC, Obj_Flags(A0)                              ; $0001
                eor.b   D1, D2
                or.b    D2, Obj_Flags(A0)                                ; $0001
                btst    #$05, Obj_Status(A0)                             ; $0022
                bne     PBoffset_0x016448
                lsr.b   #$04, D0
                andi.b  #$06, D0
                move.w  Obj_Inertia(A0), D2                              ; $0014
                bpl.s   PBoffset_0x0162BE
                neg.w   D2
PBoffset_0x0162BE:
                tst.b   Obj_Player_Status(A0)                            ; $002B
                bpl     PBoffset_0x0162C8
                add.w   D2, D2
PBoffset_0x0162C8:
                tst.b   (Super_Sonic_Flag).w                         ; $FFFFFE19
                bne.s   PBoffset_0x016324
                lea     (PBoffset_0x0164D8), A1
                cmpi.w  #$0600, D2
                bcc.s   PBoffset_0x0162E2
                lea     (PBoffset_0x0164CE), A1
                add.b   D0, D0
PBoffset_0x0162E2:
                add.b   D0, D0
                move.b  D0, D3
                moveq   #$00, D1
                move.b  Obj_Ani_Frame(A0), D1                            ; $001B
                move.b  $01(A1, D1), D0
                cmpi.b  #$FF, D0
                bne.s   PBoffset_0x016300
                move.b  #$00, Obj_Ani_Frame(A0)                          ; $001B
                move.b  Obj_Flags(A1), D0                                ; $0001
PBoffset_0x016300:
                move.b  D0, Obj_Map_Id(A0)                               ; $001A
                add.b   D3, Obj_Map_Id(A0)                               ; $001A
                subq.b  #$01, Obj_Ani_Time(A0)                           ; $001E
                bpl.s   PBoffset_0x016322
                neg.w   D2
                addi.w  #$0800, D2
                bpl.s   PBoffset_0x016318
                moveq   #$00, D2
PBoffset_0x016318:
                lsr.w   #$08, D2
                move.b  D2, Obj_Ani_Time(A0)                             ; $001E
                addq.b  #$01, Obj_Ani_Frame(A0)                          ; $001B
PBoffset_0x016322:
                rts
PBoffset_0x016324:
                lea     (PBoffset_0x01667A), A1
                cmpi.w  #$0800, D2
                bcc.s   PBoffset_0x01633C
                lea     (PBoffset_0x016670), A1
                add.b   D0, D0
                add.b   D0, D0
                bra.s   PBoffset_0x01633E
PBoffset_0x01633C:
                lsr.b   #$01, D0
PBoffset_0x01633E:
                move.b  D0, D3
                moveq   #$00, D1
                move.b  Obj_Ani_Frame(A0), D1                            ; $001B
                move.b  $01(A1, D1), D0
                cmpi.b  #$FF, D0
                bne.s   PBoffset_0x01635A
                move.b  #$00, Obj_Ani_Frame(A0)                          ; $001B
                move.b  Obj_Flags(A1), D0                                ; $0001
PBoffset_0x01635A:
                move.b  D0, Obj_Map_Id(A0)                               ; $001A
                add.b   D3, Obj_Map_Id(A0)                               ; $001A
                move.b  ($FFFFFE05).w, D1
                andi.b  #$03, D1
                bne.s   PBoffset_0x01637A
                cmpi.b  #$B5, Obj_Map_Id(A0)                             ; $001A
                bcc.s   PBoffset_0x01637A
                addi.b  #$20, Obj_Map_Id(A0)                             ; $001A
PBoffset_0x01637A:
                subq.b  #$01, Obj_Ani_Time(A0)                           ; $001E
                bpl.s   PBoffset_0x016394
                neg.w   D2
                addi.w  #$0800, D2
                bpl.s   PBoffset_0x01638A
                moveq   #$00, D2
PBoffset_0x01638A:
                lsr.w   #$08, D2
                move.b  D2, Obj_Ani_Time(A0)                             ; $001E
                addq.b  #$01, Obj_Ani_Frame(A0)                          ; $001B
PBoffset_0x016394:
                rts
PBoffset_0x016396:
                move.b  Obj_Flip_Angle(A0), D0                           ; $0027
                moveq   #$00, D1
                move.b  Obj_Status(A0), D2                               ; $0022
                andi.b  #$01, D2
                bne.s   PBoffset_0x0163C4
                andi.b  #$FC, Obj_Flags(A0)                              ; $0001
                addi.b  #$0B, D0
                divu.w  #$0016, D0
                addi.b  #$5F, D0
                move.b  D0, Obj_Map_Id(A0)                               ; $001A
                move.b  #$00, Obj_Ani_Time(A0)                           ; $001E
                rts
PBoffset_0x0163C4:
                andi.b  #$FC, Obj_Flags(A0)                              ; $0001
                tst.b   Obj_Player_Flip_Flag(A0)                         ; $0029
                beq.s   PBoffset_0x0163DC
                ori.b   #$01, Obj_Flags(A0)                              ; $0001
                addi.b  #$0B, D0
                bra.s   PBoffset_0x0163E8
PBoffset_0x0163DC:
                ori.b   #$03, Obj_Flags(A0)                              ; $0001
                neg.b   D0
                addi.b  #$8F, D0
PBoffset_0x0163E8:
                divu.w  #$0016, D0
                addi.b  #$5F, D0
                move.b  D0, Obj_Map_Id(A0)                               ; $001A
                move.b  #$00, Obj_Ani_Time(A0)                           ; $001E
                rts
PBoffset_0x0163FC:
                subq.b  #$01, Obj_Ani_Time(A0)                           ; $001E
                bpl     PBoffset_0x016238
                addq.b  #$01, D0
                bne.s   PBoffset_0x016448
                move.w  Obj_Inertia(A0), D2                              ; $0014
                bpl.s   PBoffset_0x016410
                neg.w   D2
PBoffset_0x016410:
                lea     (PBoffset_0x0164EC), A1
                cmpi.w  #$0600, D2
                bcc.s   PBoffset_0x016422
                lea     (PBoffset_0x0164E2), A1
PBoffset_0x016422:
                neg.w   D2
                addi.w  #$0400, D2
                bpl.s   PBoffset_0x01642C
                moveq   #$00, D2
PBoffset_0x01642C:
                lsr.w   #$08, D2
                move.b  D2, Obj_Ani_Time(A0)                             ; $001E
                move.b  Obj_Status(A0), D1                               ; $0022
                andi.b  #$01, D1
                andi.b  #$FC, Obj_Flags(A0)                              ; $0001
                or.b    D1, Obj_Flags(A0)                                ; $0001
                bra     PBoffset_0x016220
PBoffset_0x016448:
                subq.b  #$01, Obj_Ani_Time(A0)                           ; $001E
                bpl     PBoffset_0x016238
                move.w  Obj_Inertia(A0), D2                              ; $0014
                bmi.s   PBoffset_0x016458
                neg.w   D2
PBoffset_0x016458:
                addi.w  #$0800, D2
                bpl.s   PBoffset_0x016460
                moveq   #$00, D2
PBoffset_0x016460:
                lsr.w   #$06, D2
                move.b  D2, Obj_Ani_Time(A0)                             ; $001E
                lea     (PBoffset_0x0164F6), A1
                tst.b   (Super_Sonic_Flag).w                         ; $FFFFFE19
                beq.s   PBoffset_0x016478
                lea     (PBoffset_0x016684), A1
PBoffset_0x016478:
                move.b  Obj_Status(A0), D1                               ; $0022
                andi.b  #$01, D1
                andi.b  #$FC, Obj_Flags(A0)                              ; $0001
                or.b    D1, Obj_Flags(A0)                                ; $0001
                bra     PBoffset_0x016220                  
;-------------------------------------------------------------------------------   
PBoffset_0x01648E:                          
                dc.w    PBoffset_0x0164CE-PBoffset_0x01648E
                dc.w    PBoffset_0x0164D8-PBoffset_0x01648E
                dc.w    PBoffset_0x0164E2-PBoffset_0x01648E
                dc.w    PBoffset_0x0164EC-PBoffset_0x01648E
                dc.w    PBoffset_0x0164F6-PBoffset_0x01648E
                dc.w    PBoffset_0x016500-PBoffset_0x01648E
                dc.w    PBoffset_0x0165B6-PBoffset_0x01648E
                dc.w    PBoffset_0x0165BC-PBoffset_0x01648E
                dc.w    PBoffset_0x0165C1-PBoffset_0x01648E
                dc.w    PBoffset_0x0165C6-PBoffset_0x01648E
                dc.w    PBoffset_0x0165D2-PBoffset_0x01648E
                dc.w    PBoffset_0x0165D6-PBoffset_0x01648E
                dc.w    PBoffset_0x0165DA-PBoffset_0x01648E
                dc.w    PBoffset_0x0165E0-PBoffset_0x01648E
                dc.w    PBoffset_0x0165E7-PBoffset_0x01648E
                dc.w    PBoffset_0x0165EB-PBoffset_0x01648E
                dc.w    PBoffset_0x0165F2-PBoffset_0x01648E
                dc.w    PBoffset_0x0165F6-PBoffset_0x01648E
                dc.w    PBoffset_0x0165FA-PBoffset_0x01648E
                dc.w    PBoffset_0x016600-PBoffset_0x01648E
                dc.w    PBoffset_0x016605-PBoffset_0x01648E
                dc.w    PBoffset_0x016609-PBoffset_0x01648E
                dc.w    PBoffset_0x016610-PBoffset_0x01648E
                dc.w    PBoffset_0x016613-PBoffset_0x01648E
                dc.w    PBoffset_0x016616-PBoffset_0x01648E
                dc.w    PBoffset_0x016619-PBoffset_0x01648E
                dc.w    PBoffset_0x016619-PBoffset_0x01648E
                dc.w    PBoffset_0x01661C-PBoffset_0x01648E
                dc.w    PBoffset_0x016620-PBoffset_0x01648E
                dc.w    PBoffset_0x016624-PBoffset_0x01648E
                dc.w    PBoffset_0x016628-PBoffset_0x01648E
                dc.w    PBoffset_0x0166A1-PBoffset_0x01648E
PBoffset_0x0164CE:
                dc.b    $FF, $0F, $10, $11, $12, $13, $14, $0D
                dc.b    $0E, $FF
PBoffset_0x0164D8:
                dc.b    $FF, $2D, $2E, $2F, $30, $FF, $FF, $FF
                dc.b    $FF, $FF
PBoffset_0x0164E2:
                dc.b    $FE, $3D, $41, $3E, $41, $3F, $41, $40
                dc.b    $41, $FF
PBoffset_0x0164EC:
                dc.b    $FE, $3D, $41, $3E, $41, $3F, $41, $40
                dc.b    $41, $FF
PBoffset_0x0164F6:
                dc.b    $FD, $48, $49, $4A, $4B, $FF, $FF, $FF
                dc.b    $FF, $FF
PBoffset_0x016500:
                dc.b    $05, $01, $01, $01, $01, $01, $01, $01
                dc.b    $01, $01, $01, $01, $01, $01, $01, $01
                dc.b    $01, $01, $01, $01, $01, $01, $01, $01
                dc.b    $01, $01, $01, $01, $01, $01, $01, $02
                dc.b    $03, $03, $03, $03, $03, $04, $04, $04
                dc.b    $05, $05, $05, $04, $04, $04, $05, $05
                dc.b    $05, $04, $04, $04, $05, $05, $05, $04
                dc.b    $04, $04, $05, $05, $05, $06, $06, $06
                dc.b    $06, $06, $06, $06, $06, $06, $06, $04
                dc.b    $04, $04, $05, $05, $05, $04, $04, $04
                dc.b    $05, $05, $05, $04, $04, $04, $05, $05
                dc.b    $05, $04, $04, $04, $05, $05, $05, $06
                dc.b    $06, $06, $06, $06, $06, $06, $06, $06
                dc.b    $06, $04, $04, $04, $05, $05, $05, $04
                dc.b    $04, $04, $05, $05, $05, $04, $04, $04
                dc.b    $05, $05, $05, $04, $04, $04, $05, $05
                dc.b    $05, $06, $06, $06, $06, $06, $06, $06
                dc.b    $06, $06, $06, $04, $04, $04, $05, $05
                dc.b    $05, $04, $04, $04, $05, $05, $05, $04
                dc.b    $04, $04, $05, $05, $05, $04, $04, $04
                dc.b    $05, $05, $05, $06, $06, $06, $06, $06
                dc.b    $06, $06, $06, $06, $06, $07, $08, $08
                dc.b    $08, $09, $09, $09, $FE, $06
PBoffset_0x0165B6:
                dc.b    $09, $CC, $CD, $CE, $CD, $FF
PBoffset_0x0165BC:
                dc.b    $05, $0B, $0C, $FE, $01
PBoffset_0x0165C1:
                dc.b    $05, $4C, $4D, $FE, $01
PBoffset_0x0165C6:
                dc.b    $00, $42, $43, $42, $44, $42, $45, $42
                dc.b    $46, $42, $47, $FF
PBoffset_0x0165D2:
                dc.b    $01, $02, $FD, $00
PBoffset_0x0165D6:
                dc.b    $03, $0A, $FD, $00
PBoffset_0x0165DA:
                dc.b    $03, $C8, $C9, $CA, $CB, $FF
PBoffset_0x0165E0:
                dc.b    $05, $D2, $D3, $D4, $D5, $FD, $00
PBoffset_0x0165E7:
                dc.b    $07, $54, $59, $FF
PBoffset_0x0165EB:
                dc.b    $07, $54, $55, $56, $57, $58, $FF
PBoffset_0x0165F2:
                dc.b    $2F, $5B, $FD, $00
PBoffset_0x0165F6:
                dc.b    $01, $50, $51, $FF
PBoffset_0x0165FA:
                dc.b    $0F, $43, $43, $43, $FE, $01
PBoffset_0x016600:
                dc.b    $0F, $43, $44, $FE, $01
PBoffset_0x016605:
                dc.b    $13, $6B, $6C, $FF
PBoffset_0x016609:
                dc.b    $0B, $5A, $5A, $11, $12, $FD, $00
PBoffset_0x016610:
                dc.b    $20, $5E, $FF
PBoffset_0x016613:
                dc.b    $20, $5D, $FF
PBoffset_0x016616:
                dc.b    $20, $5C, $FF
PBoffset_0x016619:
                dc.b    $40, $4E, $FF
PBoffset_0x01661C:
                dc.b    $09, $4E, $4F, $FF
PBoffset_0x016620:
                dc.b    $77, $00, $FD, $00
PBoffset_0x016624:
                dc.b    $13, $D0, $D1, $FF
PBoffset_0x016628:
                dc.b    $03, $CF, $C8, $C9, $CA, $CB, $FE, $04
;------------------------------------------------------------------------------- 
PBoffset_0x016630:  
                dc.w    PBoffset_0x016670-PBoffset_0x016630
                dc.w    PBoffset_0x01667A-PBoffset_0x016630
                dc.w    PBoffset_0x0164E2-PBoffset_0x016630
                dc.w    PBoffset_0x0164EC-PBoffset_0x016630
                dc.w    PBoffset_0x016684-PBoffset_0x016630
                dc.w    PBoffset_0x01668E-PBoffset_0x016630
                dc.w    PBoffset_0x016694-PBoffset_0x016630
                dc.w    PBoffset_0x0165BC-PBoffset_0x016630
                dc.w    PBoffset_0x01669E-PBoffset_0x016630
                dc.w    PBoffset_0x0165C6-PBoffset_0x016630
                dc.w    PBoffset_0x0165D2-PBoffset_0x016630
                dc.w    PBoffset_0x0165D6-PBoffset_0x016630
                dc.w    PBoffset_0x0165DA-PBoffset_0x016630
                dc.w    PBoffset_0x0165E0-PBoffset_0x016630
                dc.w    PBoffset_0x0165E7-PBoffset_0x016630
                dc.w    PBoffset_0x0165EB-PBoffset_0x016630
                dc.w    PBoffset_0x0165F2-PBoffset_0x016630
                dc.w    PBoffset_0x0165F6-PBoffset_0x016630
                dc.w    PBoffset_0x0165FA-PBoffset_0x016630
                dc.w    PBoffset_0x016600-PBoffset_0x016630
                dc.w    PBoffset_0x016605-PBoffset_0x016630
                dc.w    PBoffset_0x016609-PBoffset_0x016630
                dc.w    PBoffset_0x016610-PBoffset_0x016630
                dc.w    PBoffset_0x016613-PBoffset_0x016630
                dc.w    PBoffset_0x016616-PBoffset_0x016630
                dc.w    PBoffset_0x016619-PBoffset_0x016630
                dc.w    PBoffset_0x016619-PBoffset_0x016630
                dc.w    PBoffset_0x01661C-PBoffset_0x016630
                dc.w    PBoffset_0x016620-PBoffset_0x016630
                dc.w    PBoffset_0x016624-PBoffset_0x016630
                dc.w    PBoffset_0x016628-PBoffset_0x016630
                dc.w    PBoffset_0x0166A1-PBoffset_0x016630
PBoffset_0x016670:
                dc.b    $FF, $77, $78, $79, $7A, $7B, $7C, $75
                dc.b    $76, $FF
PBoffset_0x01667A:
                dc.b    $FF, $B5, $B9, $FF, $FF, $FF, $FF, $FF
                dc.b    $FF, $FF
PBoffset_0x016684:
                dc.b    $FD, $BD, $BE, $BF, $C0, $FF, $FF, $FF
                dc.b    $FF, $FF
PBoffset_0x01668E:
                dc.b    $07, $72, $73, $74, $73, $FF
PBoffset_0x016694:
                dc.b    $09, $C2, $C3, $C4, $C3, $C5, $C6, $C7
                dc.b    $C6, $FF
PBoffset_0x01669E:
                dc.b    $05, $C1, $FF
PBoffset_0x0166A1:
                dc.b    $02, $6D, $6D, $6E, $6E, $6F, $70, $71
                dc.b    $70, $71, $70, $71, $70, $71, $FD, $00
                dc.b    $00     
;-------------------------------------------------------------------------------
Load_Sonic_Dynamic_PLC:                                        ; PBoffset_0x0166B2
                moveq   #$00, D0
                move.b  Obj_Map_Id(A0), D0                               ; $001A
; Load_Sonic_Dynamic_PLC_D0:                 
                cmp.b   ($FFFFF766).w, D0
                beq.s   PBoffset_0x016704
                move.b  D0, ($FFFFF766).w
                lea     (Sonic_Dyn_Script), A2                 ; PBoffset_0x0714E0
                add.w   D0, D0
                adda.w  $00(A2, D0), A2
                move.w  (A2)+, D5
                subq.w  #$01, D5
                bmi.s   PBoffset_0x016704
                move.w  #$F000, D4
Loop_Load_Sonic_Sprites:                                       ; PBoffset_0x0166D8
                moveq   #$00, D1
                move.w  (A2)+, D1
                move.w  D1, D3
                lsr.w   #$08, D3
                andi.w  #$00F0, D3
                addi.w  #$0010, D3
                andi.w  #$0FFF, D1
                lsl.l   #$05, D1
                addi.l  #Art_Sonic, D1                         ; PBoffset_0x050000
                move.w  D4, D2
                add.w   D3, D4
                add.w   D3, D4
                jsr     (DMA_68KtoVRAM)                        ; PBoffset_0x0019E4
                dbra    D5, Loop_Load_Sonic_Sprites            ; PBoffset_0x0166D8
PBoffset_0x016704:
                rts                                                                                                                                                                                                                        
;===============================================================================
; Objeto 0x01 - Sonic
; <<<- 
;===============================================================================