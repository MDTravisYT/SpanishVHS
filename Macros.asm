; ===================================================================================
; Some common macros and some from Sonic 1+2+3k.
; ===================================================================================
cnop macro offset,alignment
	if notZ80(MOMCPU)
		org (*-1+(alignment)-((*-1+(-(offset)))#(alignment)))
	else
		org ($-1+(alignment)-(($-1+(-(offset)))#(alignment)))
	endif
    endm

; redefine align in terms of cnop, for the padding counter
align macro alignment
		cnop 0,alignment
	endm

; define the even pseudo-instruction
even macro
	if notZ80(MOMCPU)
		if (*)&1
paddingSoFar		set paddingSoFar+1
			dc.b 0 ;ds.b 1 
		endif
	else
		if ($)&1
			db 0
		endif
	endif
    endm