Scriptname UD_CustomChargPlug_RenderScript extends UD_CustomPlug_RenderScript  

Int 	Property UD_MaxStrength			= 100 		auto
Int 	Property UD_MaxDuration 		= 90		auto
Float 	Property UD_MaxCharge 			= 100.0 	auto
Float 	Property UD_ChargePerOrgasm 	= 25.0 		auto
Float 	Property UD_ChargeArousalMult	= 0.05 		auto
Int 	Property UD_ChargeRewardNum		= 1 		auto
Form 	Property UD_ChargeRewardFull	= none		auto
Form 	Property UD_ChargeRewardEmpty	= none		auto
Int		_BaseCooldown		= 0
Float 	_currentCharge 		= 0.0

Function InitPost()
	parent.InitPost()
	UD_DeviceType = "Chargable Plug"
	if !hasModifier("DOR")
		addModifier("DOR")
	endif
	_BaseCooldown = UD_Cooldown
EndFunction

Function onDeviceMenuInitPost(bool[] aControlFilter)
	parent.onDeviceMenuInitPost(aControlFilter)
	if canBeStruggled() && getRelativeCharge() >= 1.0
		UDCDmain.currentDeviceMenu_allowstruggling = True
	else
		UDCDMain.disableStruggleCondVar(false)
	endif
EndFunction
Function onDeviceMenuInitPostWH(bool[] aControlFilter)
	parent.onDeviceMenuInitPostWH(aControlFilter)
	if canBeStruggled() && getRelativeCharge() >= 1.0
		UDCDmain.currentDeviceMenu_allowstruggling = True
	else
		UDCDMain.disableStruggleCondVar(false)
	endif
EndFunction

string Function addInfoString(string str = "")
	str += "Charge: " + UDCDmain.Round(getRelativeCharge()*100) + "% ("+Round(_currentCharge)+"/"+Round(UD_MaxCharge)+")" + "\n"
	return parent.addInfoString(str)
EndFunction

float Function getRelativeCharge()
	return _currentCharge/UD_MaxCharge
EndFunction

Function OnOrgasmPost(bool sexlab = false)
	parent.OnOrgasmPost(sexlab)
	if sexlab
		UpdateCharge(UD_ChargePerOrgasm*0.6)
	else
		UpdateCharge(UD_ChargePerOrgasm)
	endif
EndFunction

Function onUpdatePost(float timePassed)
	if !UD_Cooldown
		
	endif
	Float loc_playerarousal = UDOM.getArousal(getWearer())
	UpdateCharge(loc_playerarousal*UD_ChargeArousalMult*timePassed*24)
EndFunction

Function UpdateCharge(Float fValue)
	if _currentCharge < UD_MaxCharge && (_currentCharge + fValue) >= UD_MaxCharge
		UDCDmain.Print(getDeviceName() + " is fully charged!")
	endif
	_currentCharge += fValue
	if _currentCharge > UD_MaxCharge
		UD_Shocking = true
		_currentCharge = UD_MaxCharge
	endif
	UD_VibStrength 	= Round(fRange(UD_MaxStrength*getRelativeCharge()	,UD_MaxStrength*0.25	,UD_MaxStrength	))
	UD_VibDuration 	= Round(fRange(UD_MaxDuration*getRelativeCharge()	,UD_MaxDuration*0.50	,UD_MaxDuration	))
EndFunction

Float Function getVibOrgasmRate(float mult = 1.0)
	return parent.getVibOrgasmRate(mult*(1.0 + 2.0*getRelativeCharge()))
EndFunction

Function removeDevice(actor akActor)
	If getRelativeCharge() >= 1.0 ; Fully charged.
		; Break down plug.
		if UD_ChargeRewardFull
			UDCDmain.Print("After removing the plug from your trembling groin, the stand easily detaches and breaks in to " + UD_ChargeRewardFull.getName(),1)
			getWearer().AddItem(UD_ChargeRewardFull,UD_ChargeRewardNum)
		else
			UDCDmain.Print("After removing the plug from your trembling groin, the stand easily detaches",1)
		endif
	Else
		if UD_ChargeRewardEmpty
			UDCDmain.Print("Though the plug glows upon removal, the light quickly fades from it and break to " + UD_ChargeRewardEmpty.getName())
			getWearer().AddItem(UD_ChargeRewardEmpty,UD_ChargeRewardNum)
		else
			UDCDmain.Print("Though the plug glows upon removal, the light quickly fades from it")
		endif
	EndIf
	parent.removeDevice(akActor)
EndFunction

int Function CalculateCooldown(Float fMult = 1.0)
	return parent.CalculateCooldown(1.0 - 0.6*getRelativeCharge())
EndFunction

Function UpdateCooldown()
	if !UD_Cooldown
		UD_Cooldown = 60
		_BaseCooldown = UD_Cooldown
	endif
EndFunction