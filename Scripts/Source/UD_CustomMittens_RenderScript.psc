Scriptname UD_CustomMittens_RenderScript extends UD_CustomGloves_RenderScript  

Function InitPost()
	UD_DeviceType = "Mittens"
EndFunction

;/
Function onDeviceMenuInitPost(bool[] aControlFilter)
	parent.onDeviceMenuInitPost(aControlFilter)
	if canBeStruggled()
		UDCDmain.currentDeviceMenu_allowstruggling = True
	endif
	if canBeCutted()
		UDCDmain.currentDeviceMenu_allowCutting = True
	endif
EndFunction
/;
;/
Function OnMinigameStart()
	parent.OnMinigameStart()
	if getWearer().wornHasKeyword(libs.zad_deviousHeavyBondage) && getMinigameType() == 1 && !hasHelper()
		setMinigameDmgMult(0.5)
	endif
EndFunction
/;