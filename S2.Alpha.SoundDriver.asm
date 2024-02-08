;===============================================================================
; Rotina para carregar o driver de som 
; ->>>
;=============================================================================== 
SoundDriverLoad:                                               ; Offset_0x0EC000
                move    SR, -(A7)                                               
                movem.l D0-D7/A0-A6, -(A7)                                      
                move    #$2700, SR                                              
                lea     (Z80_Bus_Request), A3                        ; $00A11100
                lea     (Z80_Reset), A2                              ; $00A11200
                moveq   #$00, D2                                                
                move.w  #$0100, D1                                              
                move.w  D1, (A3)                                                
                move.w  D1, (A2)                                                
Offset_0x0EC020:
                btst    D2, (A3)                                                
                bne.s   Offset_0x0EC020                                         
                jsr     Offset_0x0EC03C(PC)                                     
                move.w  D2, (A2)                                                
                move.w  D2, (A3)                                                
                moveq   #$17, D0                                                
Offset_0x0EC02E:
                dbra    D0, Offset_0x0EC02E                                     
                move.w  D1, (A2)                                                
                movem.l (A7)+, D0-D7/A0-A6                                      
                move    (A7)+, SR                                               
                rts                                                             
;-------------------------------------------------------------------------------
Offset_0x0EC03C:
                lea     Z80_Sound_Driver(PC), A6               ; Offset_0x0EC0DC                              
                move.w  #$0E7E, D7                                              
                moveq   #$00, D6                                                
                lea     (Z80_RAM_Start), A5                          ; $00A00000
                moveq   #$00, D5                                                
                lea     (Z80_RAM_Start), A4                          ; $00A00000
Offset_0x0EC054:
                lsr.w   #$01, D6                                                
                btst    #$08, D6                                                
                bne.s   Offset_0x0EC066                                         
                jsr     Offset_0x0EC0D2(PC)                                     
                move.b  D0, D6                                                  
                ori.w   #$FF00, D6                                              
Offset_0x0EC066:
                btst    #$00, D6                                                
                beq.s   Offset_0x0EC078                                         
                jsr     Offset_0x0EC0D2(PC)                                     
                move.b  D0, (A5)+                                               
                addq.w  #$01, D5                                                
                bra     Offset_0x0EC054                                         
Offset_0x0EC078:
                jsr     Offset_0x0EC0D2(PC)                                     
                moveq   #$00, D4                                                
                move.b  D0, D4                                                  
                jsr     Offset_0x0EC0D2(PC)                                     
                move.b  D0, D3                                                  
                andi.w  #$000F, D3                                              
                addq.w  #$02, D3                                                
                andi.w  #$00F0, D0                                              
                lsl.w   #$04, D0                                                
                add.w   D0, D4                                                  
                addi.w  #$0012, D4                                              
                andi.w  #$0FFF, D4                                              
                move.w  D5, D0                                                  
                andi.w  #$F000, D0                                              
                add.w   D0, D4                                                  
                cmp.w   D4, D5                                                  
                bcc.s   Offset_0x0EC0C0                                         
                subi.w  #$1000, D4                                              
                bcc.s   Offset_0x0EC0C0                                         
                add.w   D3, D5                                                  
                addq.w  #$01, D5                                                
Offset_0x0EC0B2:
                move.b  #$00, (A5)+                                             
                addq.w  #$01, D4                                                
                dbra    D3, Offset_0x0EC0B2                                     
                bra     Offset_0x0EC054                                         
Offset_0x0EC0C0:
                add.w   D3, D5                                                  
                addq.w  #$01, D5                                                
Offset_0x0EC0C4:
                move.b  $00(A4, D4), (A5)+                                      
                addq.w  #$01, D4                                                
                dbra    D3, Offset_0x0EC0C4                                     
                bra     Offset_0x0EC054   
;-------------------------------------------------------------------------------
Offset_0x0EC0D2:
                move.b  (A6)+, D0                                               
                subq.w  #$01, D7                                                
                bne.s   Offset_0x0EC0DA                                         
                addq.w  #$04, A7                                                
Offset_0x0EC0DA:
                rts    
;-------------------------------------------------------------------------------
Z80_Sound_Driver:                                              ; Offset_0x0EC0DC
                incbin  'Sound/snd_drv.sax'     
;-------------------------------------------------------------------------------  
                cnop    $00000000, $000ED000
DAC_Sample_00:                                                 ; Offset_0x0ED000  
                incbin  'Sound/DPCM/DAC_00.bin'
DAC_Sample_01:                                                 ; Offset_0x0ED294 
                incbin  'Sound/DPCM/DAC_01.bin'
DAC_Sample_02:                                                 ; Offset_0x0ED9B7 
                incbin  'Sound/DPCM/DAC_02.bin'
DAC_Sample_03:                                                 ; Offset_0x0EE56C  
                incbin  'Sound/DPCM/DAC_03.bin'
DAC_Sample_04:                                                 ; Offset_0x0EED7A  
                incbin  'Sound/DPCM/DAC_04.bin'
DAC_Sample_05:                                                 ; Offset_0x0EF2F0  
                incbin  'Sound/DPCM/DAC_05.bin'
DAC_Sample_06:                                                 ; Offset_0x0EFA3C  
                incbin  'Sound/DPCM/DAC_06.bin'
;-------------------------------------------------------------------------------
                dc.w    (((Music_97_Ptr>>$08)|(Music_97_Ptr<<$08))&$FFFF) 
                dc.w    (((Music_98_Ptr>>$08)|(Music_98_Ptr<<$08))&$FFFF) 
                dc.w    (((Music_99_Ptr>>$08)|(Music_99_Ptr<<$08))&$FFFF) 
                dc.w    (((Music_9A_Ptr>>$08)|(Music_9A_Ptr<<$08))&$FFFF) 
                dc.w    (((Music_9B_Ptr>>$08)|(Music_9B_Ptr<<$08))&$FFFF) 
                dc.w    (((Music_9C_Ptr>>$08)|(Music_9C_Ptr<<$08))&$FFFF) 
                dc.w    (((Music_9D_Ptr>>$08)|(Music_9D_Ptr<<$08))&$FFFF) 
                dc.w    (((Music_90_Ptr>>$08)|(Music_90_Ptr<<$08))&$FFFF) 
                dc.w    (((Music_9E_Ptr>>$08)|(Music_9E_Ptr<<$08))&$FFFF)               
Music_Invencibility:                                           ; Offset_0x0F0012
                incbin  'Sound/Music/invcb_97.snd' 
Music_Extra_Life:                                              ; Offset_0x0F023D
                incbin  'Sound/Music/1up_98.snd'
Music_Title_Screen:                                            ; Offset_0x0F032A
                incbin  'Sound/Music/tscr_99.snd'
Music_Level_Results:                                           ; Offset_0x0F04FF
                incbin  'Sound/Music/lres_9A.snd'
Music_Time_Over_Game_Over:                                     ; Offset_0x0F0654
                incbin  'Sound/Music/tgovr_9B.snd'
Music_Continue:                                                ; Offset_0x0F07A3
                incbin  'Sound/Music/cont_9c.snd'
Music_Get_Emerald:                                             ; Offset_0x0F0900
                incbin  'Sound/Music/emrld_9d.snd'
Music_Hidden_Palace_Final:                                     ; Offset_0x0F09CE
                incbin  'Sound/Music/hpz_90.snd'
;-------------------------------------------------------------------------------                                                    
                cnop    $00000000, $000F1E8C
;-------------------------------------------------------------------------------                
Sega_Snd:                                                      ; Offset_0x0F1E8C               
                incbin  'Sound/PCM/sega.snd'
;-------------------------------------------------------------------------------
                dc.w    (((Music_88_Ptr>>$08)|(Music_88_Ptr<<$08))&$FFFF) 
                dc.w    (((Music_82_Ptr>>$08)|(Music_82_Ptr<<$08))&$FFFF) 
                dc.w    (((Music_85_Ptr>>$08)|(Music_85_Ptr<<$08))&$FFFF) 
                dc.w    (((Music_89_Ptr>>$08)|(Music_89_Ptr<<$08))&$FFFF)                  
                dc.w    (((Music_8B_Ptr>>$08)|(Music_8B_Ptr<<$08))&$FFFF)                  
                dc.w    (((Music_83_Ptr>>$08)|(Music_83_Ptr<<$08))&$FFFF)
                dc.w    (((Music_87_Ptr>>$08)|(Music_87_Ptr<<$08))&$FFFF)                   
                dc.w    (((Music_8A_Ptr>>$08)|(Music_8A_Ptr<<$08))&$FFFF)                 
                dc.w    (((Music_92_Ptr>>$08)|(Music_92_Ptr<<$08))&$FFFF)                  
                dc.w    (((Music_91_Ptr>>$08)|(Music_91_Ptr<<$08))&$FFFF)                  
                dc.w    (((Music_95_Ptr>>$08)|(Music_95_Ptr<<$08))&$FFFF)                
                dc.w    (((Music_94_Ptr>>$08)|(Music_94_Ptr<<$08))&$FFFF) 
                dc.w    (((Music_8E_Ptr>>$08)|(Music_8E_Ptr<<$08))&$FFFF)                   
                dc.w    (((Music_93_Ptr>>$08)|(Music_93_Ptr<<$08))&$FFFF)                 
                dc.w    (((Music_8D_Ptr>>$08)|(Music_8D_Ptr<<$08))&$FFFF)                  
                dc.w    (((Music_84_Ptr>>$08)|(Music_84_Ptr<<$08))&$FFFF)                    
                dc.w    (((Music_8F_Ptr>>$08)|(Music_8F_Ptr<<$08))&$FFFF)                  
                dc.w    (((Music_8C_Ptr>>$08)|(Music_8C_Ptr<<$08))&$FFFF) 
                dc.w    (((Music_81_Ptr>>$08)|(Music_81_Ptr<<$08))&$FFFF) 
                dc.w    (((Music_96_Ptr>>$08)|(Music_96_Ptr<<$08))&$FFFF) 
                dc.w    (((Music_86_Ptr>>$08)|(Music_86_Ptr<<$08))&$FFFF) 
Music_Oil_Ocean_Beta:                                          ; Offset_0x0F802A
                incbin  'Sound/Music/ooz_88.snd'
Music_Green_Hill:                                              ; Offset_0x0F85AC
                incbin  'Sound/Music/ghz_82.snd'
Music_Metropolis:                                              ; Offset_0x0F8D1E
                incbin  'Sound/Music/mz_85.snd'
Music_Casino_Night:                                            ; Offset_0x0F9299
                incbin  'Sound/Music/cnz_89.snd'
Music_Dust_Hill:                                               ; Offset_0x0F99B6
                incbin  'Sound/Music/dhz_8b.snd'
Music_Hidden_Palace_Beta:                                      ; Offset_0x0FA056
                incbin  'Sound/Music/hpz_83.snd'
Music_Neo_Green_Hill:                                          ; Offset_0x0FA54F
                incbin  'Sound/Music/nghz_87.snd'
Music_Death_Egg:                                               ; Offset_0x0FACDC
                incbin  'Sound/Music/dez_8a.snd'
Music_Special_Stage:                                           ; Offset_0x0FB1C3
                incbin  'Sound/Music/ss_92.snd'
Music_Level_Select_Menu:                                       ; Offset_0x0FB7CA
                incbin  'Sound/Music/menu_91.snd'
Music_End_Sequence:                                            ; Offset_0x0FB945
                incbin  'Sound/Music/endsq_95.snd'
Music_Final_Boss:                                              ; Offset_0x0FBF3E
                incbin  'Sound/Music/dezfb_94.snd'
Music_Chemical_Plant:                                          ; Offset_0x0FC276
                incbin  'Sound/Music/cpz_8e.snd'
Music_Level_Boss:                                              ; Offset_0x0FC8C1
                incbin  'Sound/Music/boss_93.snd'
Music_Sky_Chase:                                               ; Offset_0x0FCB93
                incbin  'Sound/Music/scz_8d.snd'
Music_Oil_Ocean_Final:                                         ; Offset_0x0FCF96
                incbin  'Sound/Music/ooz_84.snd'
Music_Sky_Fortress:                                            ; Offset_0x0FD41A
                incbin  'Sound/Music/sfz_8f.snd'
Music_Green_Hill_Versus_Final:                                 ; Offset_0x0FD847
                incbin  'Sound/Music/ghzvs_8c.snd'
Music_Versus_Result_Final:                                     ; Offset_0x0FDD60
                incbin  'Sound/Music/vsres_81.snd'
Music_Super_Sonic:                                             ; Offset_0x0FE1C3
                incbin  'Sound/Music/super_96.snd'
Music_Hill_Top:                                                ; Offset_0x0FE4B6
                incbin  'Sound/Music/htz_86.snd'
;-------------------------------------------------------------------------------                                                    
                cnop    $00000000, $000FEE00
;-------------------------------------------------------------------------------
Sfx_A0_To_E9:                                                  ; Offset_0x0FEE00      
                dc.w    (((Sfx_A0_Ptr>>$08)|(Sfx_A0_Ptr<<$08))&$FFFF)      
                dc.w    (((Sfx_A1_Ptr>>$08)|(Sfx_A1_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_A2_Ptr>>$08)|(Sfx_A2_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_A3_Ptr>>$08)|(Sfx_A3_Ptr<<$08))&$FFFF)
                dc.w    (((Sfx_A4_Ptr>>$08)|(Sfx_A4_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_A5_Ptr>>$08)|(Sfx_A5_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_A6_Ptr>>$08)|(Sfx_A6_Ptr<<$08))&$FFFF)      
                dc.w    (((Sfx_A7_Ptr>>$08)|(Sfx_A7_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_A8_Ptr>>$08)|(Sfx_A8_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_A9_Ptr>>$08)|(Sfx_A9_Ptr<<$08))&$FFFF)
                dc.w    (((Sfx_AA_Ptr>>$08)|(Sfx_AA_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_AB_Ptr>>$08)|(Sfx_AB_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_AC_Ptr>>$08)|(Sfx_AC_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_AD_Ptr>>$08)|(Sfx_AD_Ptr<<$08))&$FFFF)
                dc.w    (((Sfx_AE_Ptr>>$08)|(Sfx_AE_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_AF_Ptr>>$08)|(Sfx_AF_Ptr<<$08))&$FFFF)
                dc.w    (((Sfx_B0_Ptr>>$08)|(Sfx_B0_Ptr<<$08))&$FFFF)      
                dc.w    (((Sfx_B1_Ptr>>$08)|(Sfx_B1_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_B2_Ptr>>$08)|(Sfx_B2_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_B3_Ptr>>$08)|(Sfx_B3_Ptr<<$08))&$FFFF)
                dc.w    (((Sfx_B4_Ptr>>$08)|(Sfx_B4_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_B5_Ptr>>$08)|(Sfx_B5_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_B6_Ptr>>$08)|(Sfx_B6_Ptr<<$08))&$FFFF)      
                dc.w    (((Sfx_B7_Ptr>>$08)|(Sfx_B7_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_B8_Ptr>>$08)|(Sfx_B8_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_B9_Ptr>>$08)|(Sfx_B9_Ptr<<$08))&$FFFF)
                dc.w    (((Sfx_BA_Ptr>>$08)|(Sfx_BA_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_BB_Ptr>>$08)|(Sfx_BB_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_BC_Ptr>>$08)|(Sfx_BC_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_BD_Ptr>>$08)|(Sfx_BD_Ptr<<$08))&$FFFF)
                dc.w    (((Sfx_BE_Ptr>>$08)|(Sfx_BE_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_BF_Ptr>>$08)|(Sfx_BF_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_C0_Ptr>>$08)|(Sfx_C0_Ptr<<$08))&$FFFF)      
                dc.w    (((Sfx_C1_Ptr>>$08)|(Sfx_C1_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_C2_Ptr>>$08)|(Sfx_C2_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_C3_Ptr>>$08)|(Sfx_C3_Ptr<<$08))&$FFFF)
                dc.w    (((Sfx_C4_Ptr>>$08)|(Sfx_C4_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_C5_Ptr>>$08)|(Sfx_C5_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_C6_Ptr>>$08)|(Sfx_C6_Ptr<<$08))&$FFFF)      
                dc.w    (((Sfx_C7_Ptr>>$08)|(Sfx_C7_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_C8_Ptr>>$08)|(Sfx_C8_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_C9_Ptr>>$08)|(Sfx_C9_Ptr<<$08))&$FFFF)
                dc.w    (((Sfx_CA_Ptr>>$08)|(Sfx_CA_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_CB_Ptr>>$08)|(Sfx_CB_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_CC_Ptr>>$08)|(Sfx_CC_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_CD_Ptr>>$08)|(Sfx_CD_Ptr<<$08))&$FFFF)
                dc.w    (((Sfx_CE_Ptr>>$08)|(Sfx_CE_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_CF_Ptr>>$08)|(Sfx_CF_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_D0_Ptr>>$08)|(Sfx_D0_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_D1_Ptr>>$08)|(Sfx_D1_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_D2_Ptr>>$08)|(Sfx_D2_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_D3_Ptr>>$08)|(Sfx_D3_Ptr<<$08))&$FFFF)
                dc.w    (((Sfx_D4_Ptr>>$08)|(Sfx_D4_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_D5_Ptr>>$08)|(Sfx_D5_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_D6_Ptr>>$08)|(Sfx_D6_Ptr<<$08))&$FFFF)      
                dc.w    (((Sfx_D7_Ptr>>$08)|(Sfx_D7_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_D8_Ptr>>$08)|(Sfx_D8_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_D9_Ptr>>$08)|(Sfx_D9_Ptr<<$08))&$FFFF)
                dc.w    (((Sfx_DA_Ptr>>$08)|(Sfx_DA_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_DB_Ptr>>$08)|(Sfx_DB_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_DC_Ptr>>$08)|(Sfx_DC_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_DD_Ptr>>$08)|(Sfx_DD_Ptr<<$08))&$FFFF)
                dc.w    (((Sfx_DE_Ptr>>$08)|(Sfx_DE_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_DF_Ptr>>$08)|(Sfx_DF_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_E0_Ptr>>$08)|(Sfx_E0_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_E1_Ptr>>$08)|(Sfx_E1_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_E2_Ptr>>$08)|(Sfx_E2_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_E3_Ptr>>$08)|(Sfx_E3_Ptr<<$08))&$FFFF)
                dc.w    (((Sfx_E4_Ptr>>$08)|(Sfx_E4_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_E5_Ptr>>$08)|(Sfx_E5_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_E6_Ptr>>$08)|(Sfx_E6_Ptr<<$08))&$FFFF)      
                dc.w    (((Sfx_E7_Ptr>>$08)|(Sfx_E7_Ptr<<$08))&$FFFF) 
                dc.w    (((Sfx_E8_Ptr>>$08)|(Sfx_E8_Ptr<<$08))&$FFFF)   
                dc.w    (((Sfx_E9_Ptr>>$08)|(Sfx_E9_Ptr<<$08))&$FFFF)
Sfx_A0:                                                        ; Offset_0x0FEE94
                incbin  'Sound/SFX/sfx_A0.snd'
Sfx_A1:                                                        ; Offset_0x0FEEAA
                incbin  'Sound/SFX/sfx_A1.snd'
Sfx_A2:                                                        ; Offset_0x0FEED4
                incbin  'Sound/SFX/sfx_A2.snd'
Sfx_A3:                                                        ; Offset_0x0FEEF3
                incbin  'Sound/SFX/sfx_A3.snd'
Sfx_A4:                                                        ; Offset_0x0FEF25
                incbin  'Sound/SFX/sfx_A4.snd'
Sfx_A5:                                                        ; Offset_0x0FEF5A
                incbin  'Sound/SFX/sfx_A5.snd'
Sfx_A6:                                                        ; Offset_0x0FEF86
                incbin  'Sound/SFX/sfx_A6.snd'
Sfx_A7:                                                        ; Offset_0x0FEFB5
                incbin  'Sound/SFX/sfx_A7.snd'
Sfx_A8:                                                        ; Offset_0x0FEFE4
                incbin  'Sound/SFX/sfx_A8.snd'
Sfx_A9:                                                        ; Offset_0x0FEFFE
                incbin  'Sound/SFX/sfx_A9.snd'
Sfx_AA:                                                        ; Offset_0x0FF010
                incbin  'Sound/SFX/sfx_AA.snd'
Sfx_AB:                                                        ; Offset_0x0FF051
                incbin  'Sound/SFX/sfx_AB.snd'
Sfx_AC:                                                        ; Offset_0x0FF070
                incbin  'Sound/SFX/sfx_AC.snd'
Sfx_AD:                                                        ; Offset_0x0FF0A4
                incbin  'Sound/SFX/sfx_AD.snd'
Sfx_AE:                                                        ; Offset_0x0FF0DA
                incbin  'Sound/SFX/sfx_AE.snd'
Sfx_AF:                                                        ; Offset_0x0FF124
                incbin  'Sound/SFX/sfx_AF.snd'
Sfx_B0:                                                        ; Offset_0x0FF151
                incbin  'Sound/SFX/sfx_B0.snd'
Sfx_B1:                                                        ; Offset_0x0FF182
                incbin  'Sound/SFX/sfx_B1.snd'
Sfx_B2:                                                        ; Offset_0x0FF1AE
                incbin  'Sound/SFX/sfx_B2.snd'
Sfx_B3:                                                        ; Offset_0x0FF1FD
                incbin  'Sound/SFX/sfx_B3.snd'
Sfx_B4:                                                        ; Offset_0x0FF22E
                incbin  'Sound/SFX/sfx_B4.snd'
Sfx_B5:                                                        ; Offset_0x0FF289
                incbin  'Sound/SFX/sfx_B5.snd'
Sfx_B6:                                                        ; Offset_0x0FF29E
                incbin  'Sound/SFX/sfx_B6.snd'
Sfx_B7:                                                        ; Offset_0x0FF2BB
                incbin  'Sound/SFX/sfx_B7.snd'
Sfx_B8:                                                        ; Offset_0x0FF2F6
                incbin  'Sound/SFX/sfx_B8.snd'
Sfx_B9:                                                        ; Offset_0x0FF313
                incbin  'Sound/SFX/sfx_B9.snd'
Sfx_BA:                                                        ; Offset_0x0FF35D
                incbin  'Sound/SFX/sfx_BA.snd'
Sfx_BB:                                                        ; Offset_0x0FF385
                incbin  'Sound/SFX/sfx_BB.snd'
Sfx_BC:                                                        ; Offset_0x0FF3B0
                incbin  'Sound/SFX/sfx_BC.snd'
Sfx_BD:                                                        ; Offset_0x0FF3F1
                incbin  'Sound/SFX/sfx_BD.snd'
Sfx_BE:                                                        ; Offset_0x0FF444
                incbin  'Sound/SFX/sfx_BE.snd'
Sfx_BF:                                                        ; Offset_0x0FF47E
                incbin  'Sound/SFX/sfx_BF.snd'
Sfx_C0:                                                        ; Offset_0x0FF4F0
                incbin  'Sound/SFX/sfx_C0.snd'
Sfx_C1:                                                        ; Offset_0x0FF51E
                incbin  'Sound/SFX/sfx_C1.snd'
Sfx_C2:                                                        ; Offset_0x0FF558
                incbin  'Sound/SFX/sfx_C2.snd'
Sfx_C3:                                                        ; Offset_0x0FF569
                incbin  'Sound/SFX/sfx_C3.snd'
Sfx_C4:                                                        ; Offset_0x0FF5E3
                incbin  'Sound/SFX/sfx_C4.snd'
Sfx_C5:                                                        ; Offset_0x0FF60B
                incbin  'Sound/SFX/sfx_C5.snd'
Sfx_C6:                                                        ; Offset_0x0FF672
                incbin  'Sound/SFX/sfx_C6.snd'
Sfx_C7:                                                        ; Offset_0x0FF69A
                incbin  'Sound/SFX/sfx_C7.snd'
Sfx_C8:                                                        ; Offset_0x0FF6C8
                incbin  'Sound/SFX/sfx_C8.snd'
Sfx_C9:                                                        ; Offset_0x0FF6D9
                incbin  'Sound/SFX/sfx_C9.snd'
Sfx_CA:                                                        ; Offset_0x0FF706
                incbin  'Sound/SFX/sfx_CA.snd'
Sfx_CB:                                                        ; Offset_0x0FF733
                incbin  'Sound/SFX/sfx_CB.snd'
Sfx_CC:                                                        ; Offset_0x0FF766
                incbin  'Sound/SFX/sfx_CC.snd'
Sfx_CD:                                                        ; Offset_0x0FF7A0
                incbin  'Sound/SFX/sfx_CD.snd'
Sfx_CE:                                                        ; Offset_0x0FF7AD
                incbin  'Sound/SFX/sfx_CE.snd'
Sfx_CF:                                                        ; Offset_0x0FF7C2
                incbin  'Sound/SFX/sfx_CF.snd'
Sfx_D0:                                                        ; Offset_0x0FF7F9
                incbin  'Sound/SFX/sfx_D0.snd'
Sfx_D1:                                                        ; Offset_0x0FF82C
                incbin  'Sound/SFX/sfx_D1.snd'
Sfx_D2:                                                        ; Offset_0x0FF865
                incbin  'Sound/SFX/sfx_D2.snd'
Sfx_D3:                                                        ; Offset_0x0FF8A2
                incbin  'Sound/SFX/sfx_D3.snd'
Sfx_D4:                                                        ; Offset_0x0FF8E1
                incbin  'Sound/SFX/sfx_D4.snd'
Sfx_D5:                                                        ; Offset_0x0FF909
                incbin  'Sound/SFX/sfx_D5.snd'
Sfx_D6:                                                        ; Offset_0x0FF933
                incbin  'Sound/SFX/sfx_D6.snd'
Sfx_D7:                                                        ; Offset_0x0FF978
                incbin  'Sound/SFX/sfx_D7.snd'
Sfx_D8:                                                        ; Offset_0x0FF9A0
                incbin  'Sound/SFX/sfx_D8.snd'
Sfx_D9:                                                        ; Offset_0x0FF9CA
                incbin  'Sound/SFX/sfx_D9.snd'
Sfx_DA:                                                        ; Offset_0x0FF9F7
                incbin  'Sound/SFX/sfx_DA.snd'
Sfx_DB:                                                        ; Offset_0x0FFA24
                incbin  'Sound/SFX/sfx_DB.snd'
Sfx_DC:                                                        ; Offset_0x0FFA58
                incbin  'Sound/SFX/sfx_DC.snd'
Sfx_DD:                                                        ; Offset_0x0FFA9F
                incbin  'Sound/SFX/sfx_DD.snd'
Sfx_DE:                                                        ; Offset_0x0FFAC7
                incbin  'Sound/SFX/sfx_DE.snd'
Sfx_DF:                                                        ; Offset_0x0FFB01
                incbin  'Sound/SFX/sfx_DF.snd'
Sfx_E0:                                                        ; Offset_0x0FFB9D
                incbin  'Sound/SFX/sfx_E0.snd'
Sfx_E1:                                                        ; Offset_0x0FFBD8
                incbin  'Sound/SFX/sfx_E1.snd'
Sfx_E2:                                                        ; Offset_0x0FFC3F
                incbin  'Sound/SFX/sfx_E2.snd'
Sfx_E3:                                                        ; Offset_0x0FFC76
                incbin  'Sound/SFX/sfx_E3.snd'
Sfx_E4:                                                        ; Offset_0x0FFCA5
                incbin  'Sound/SFX/sfx_E4.snd'
Sfx_E5:                                                        ; Offset_0x0FFCCD
                incbin  'Sound/SFX/sfx_E5.snd'
Sfx_E6:                                                        ; Offset_0x0FFCEE
                incbin  'Sound/SFX/sfx_E6.snd'
Sfx_E7:                                                        ; Offset_0x0FFD28
                incbin  'Sound/SFX/sfx_E7.snd'
Sfx_E8:                                                        ; Offset_0x0FFD84
                incbin  'Sound/SFX/sfx_E8.snd'
Sfx_E9:                                                        ; Offset_0x0FFDAE
                incbin  'Sound/SFX/sfx_E9.snd'
;-------------------------------------------------------------------------------                                                    
                cnop    $00000000, $000FFFFE
                dc.w    $0000                
;===============================================================================
; Rotina para carregar o driver de som
; <<<-
;===============================================================================