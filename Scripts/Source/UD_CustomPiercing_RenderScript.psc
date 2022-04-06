Scriptname UD_CustomPiercing_RenderScript extends UD_CustomVibratorBase_RenderScript  

Function InitPost()
	parent.InitPost()
	UD_DeviceType = "Piercing"
EndFunction

string Function addInfoString(string str = "")
	return parent.addInfoString(str)
EndFunction

Function patchDevice()
	UDCDmain.UDPatcher.patchPiercing(self)
EndFunction

int Function getArousalRate()
	if UD_DeviceKeyword == libs.zad_deviousPiercingsNipple
		return parent.getArousalRate() + 2
	else
		return parent.getArousalRate() + 4
	endif
EndFunction

Function onDeviceMenuInitPost(Bool[] aControlFilter)
	parent.onDeviceMenuInitPost(aControlFilter)
	
	if (isPiercing(True,False) && wearerHaveBra()) || (isPiercing(False,True) && wearerHaveBelt())
		UDCDMain.disableStruggleCondVar()
	endif
EndFunction

Function onDeviceMenuInitPostWH(Bool[] aControlFilter)
	parent.onDeviceMenuInitPostWH(aControlFilter)
	
	if (isPiercing(True,False) && wearerHaveBra()) || (isPiercing(False,True) && wearerHaveBelt())
		UDCDMain.disableStruggleCondVar()
	endif
EndFunction

float Function getAccesibility()
	float loc_res = 1.0;parent.getAccesibility()
	
	if (isPiercing(True,False) && wearerHaveBra()) || (isPiercing(False,True) && wearerHaveBelt())
		loc_res = 0.0
	else
		if getWearer().wornhaskeyword(libs.zad_DeviousHeavyBondage)
			loc_res *= 0.25
		elseif getWearer().wornhaskeyword(libs.zad_DeviousBondageMittens)
			loc_res *= 0.5
		endif
		
		if getWearer().wornhaskeyword(libs.zad_DeviousSuit)
			loc_res *= 0.75
		endif
	endif
	return fRange(loc_res,0.0,1.0)
EndFunction

;OVERRIDES because of engine bug which calls one function multiple times
bool Function proccesSpecialMenu(int msgChoice)
	return parent.proccesSpecialMenu(msgChoice)
EndFunction
bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
	return parent.proccesSpecialMenuWH(akSource,msgChoice)
EndFunction