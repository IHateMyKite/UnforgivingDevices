Scriptname UD_ParalelProcess extends Quest

import UnforgivingDevicesMain

UDCustomDeviceMain Property UDCDmain auto
UnforgivingDevicesMain Property UDmain auto

zadlibs_UDPatch Property libsp
	zadlibs_UDPatch Function get()
		return UDmain.libs as zadlibs_UDPatch
	EndFunction
EndProperty
UD_ExpressionManager Property UDEM
	UD_ExpressionManager Function get()
		return UDmain.UDEM
	EndFunction
EndProperty
UD_OrgasmManager Property UDOM
	UD_OrgasmManager Function get()
		return UDmain.UDOM
	EndFunction
EndProperty

Bool Property Ready auto

Event OnInit()
	registerEvents()

	if TraceAllowed()	
		Log("UD_ParalelProcess ready!",0)
	endif
	
	Ready = True
EndEvent

Function Update()
	UnregisterForAllModEvents()
	RegisterEvents()
EndFunction

;==============================
;           REGISTER
;==============================
Function RegisterEvents()
	RegisterForModEvent("UDMinigameStarter", "Receive_MinigameStarter")
	RegisterForModEvent("UDMinigameParalel", "Receive_MinigameParalel")
	RegisterForModEvent("UDOrgasmParalel", "Receive_Orgasm")
EndFunction

;==============================
;           MINIGAME
;==============================
;vars
bool _MinigameStarterMutex = false

;mutex
Function Start_MinigameStarterMutex()
	while _MinigameStarterMutex
		Utility.waitMenuMode(0.05)
	endwhile
	_MinigameStarterMutex = true
EndFunction

Function End_MinigameStarterMutex()
	_MinigameStarterMutex = false
EndFunction

;starter
bool _MinigameStarter_Received = false
UD_CustomDevice_RenderScript Send_MinigameStarter_Package_device

Function Send_MinigameStarter(Actor akActor,UD_CustomDevice_RenderScript udDevice)
	if !akActor || !udDevice
		UDCDmain.Error("Send_MinigameStarter wrong arg received!")
	endif
	
	Start_MinigameStarterMutex()
	_MinigameStarter_Received = false
	
	;send event
	int handle = ModEvent.Create("UDMinigameStarter")
	if (handle)
		Send_MinigameStarter_Package_device = udDevice
		ModEvent.PushForm(handle, akActor)
        ModEvent.Send(handle)
		
		;block
		float loc_TimeOut = 0.0
		while !_MinigameStarter_Received && loc_TimeOut <= 2.0
			loc_TimeOut += 0.05
			Utility.waitMenuMode(0.05)
		endwhile
		_MinigameStarter_Received = false
		
		if loc_TimeOut >= 2.0
			UDCDmain.Error("Send_MinigameStarter timeout!")
		endif
	else
		UDCDmain.Error("Send_MinigameStarter error!")
	endif
	End_MinigameStarterMutex()
EndFunction
Function Receive_MinigameStarter(Form fActor)
	UD_CustomDevice_RenderScript loc_device = Send_MinigameStarter_Package_device
	_MinigameStarter_Received = true
	
	Actor akActor = fActor as Actor
	Actor akHelper = loc_device.getHelper()
	
	loc_device._MinigameParProc_1 = true
	StorageUtil.SetFormValue(akActor, "UD_currentMinigameDevice", loc_device.deviceRendered)
	
	if loc_device.PlayerInMinigame()
		UDCDmain.setCurrentMinigameDevice(loc_device)
	endif
	
	loc_device.OnMinigameStart()
	loc_device._MinigameParProc_1 = false
EndFunction

;paralel
;vars
bool _MinigameParalelMutex = false

;mutex
Function Start_MinigameParalelMutex()
	while _MinigameParalelMutex
		Utility.waitMenuMode(0.05)
	endwhile
	_MinigameParalelMutex = true
EndFunction

Function End_MinigameParalelMutex()
	_MinigameParalelMutex = false
EndFunction
bool _MinigameParalel_Received = false
UD_CustomDevice_RenderScript Send_MinigameParalel_Package_device
Function Send_MinigameParalel(Actor akActor,UD_CustomDevice_RenderScript udDevice)
	if !akActor || !udDevice
		UDCDmain.Error("Send_MinigameParalel wrong arg received!")
	endif
	
	Start_MinigameParalelMutex()
	_MinigameParalel_Received = false
	
	;send event
	int handle = ModEvent.Create("UDMinigameParalel")
	if (handle)
		Send_MinigameParalel_Package_device = udDevice
		ModEvent.PushForm(handle, akActor)
        ModEvent.Send(handle)
		
		;block
		float loc_TimeOut = 0.0
		while !_MinigameParalel_Received && loc_TimeOut <= 2.0
			loc_TimeOut += 0.05
			Utility.waitMenuMode(0.05)
		endwhile
		_MinigameParalel_Received = false
		
		if loc_TimeOut >= 2.0
			UDCDmain.Error("Send_MinigameParalel timeout!")
		endif
	else
		UDCDmain.Error("Send_MinigameParalel error!")
	endif
	End_MinigameParalelMutex()
EndFunction
Function Receive_MinigameParalel(Form fActor)
	UD_CustomDevice_RenderScript loc_device = Send_MinigameStarter_Package_device
	_MinigameParalel_Received = true
	
	Actor akActor = fActor as Actor
	Actor akHelper = loc_device.getHelper()
	
	loc_device._MinigameParProc_2 = true
	;process
	;start disable
	UDCDMain.StartMinigameDisable(akActor)
	if akHelper
		UDCDMain.StartMinigameDisable(akHelper)
	endif
	
	;disable regen of all stats
	float staminaRate = akActor.getBaseAV("StaminaRate")
	float HealRate = akActor.getBaseAV("HealRate")
	float magickaRate = akActor.getBaseAV("MagickaRate")

	akActor.setAV("StaminaRate", staminaRate*loc_device.UD_RegenMag_Stamina)
	akActor.setAV("HealRate", HealRate*loc_device.UD_RegenMag_Health)
	akActor.setAV("MagickaRate", magickaRate*loc_device.UD_RegenMag_Magicka)

	float staminaRateHelper = 0.0
	float HealRateHelper = 0.0
	float magickaRateHelper = 0.0
	if akHelper
		staminaRateHelper = akHelper.getBaseAV("StaminaRate")
		HealRateHelper = akHelper.getBaseAV("HealRate")
		magickaRateHelper = akHelper.getBaseAV("MagickaRate")

		akHelper.setAV("StaminaRate", staminaRateHelper*loc_device.UD_RegenMagHelper_Stamina)
		akHelper.setAV("HealRate", HealRateHelper*loc_device.UD_RegenMagHelper_Health)
		akHelper.setAV("MagickaRate", magickaRateHelper*loc_device.UD_RegenMagHelper_Magicka)			
	endif
	
	;shows bars
	if loc_device.canShowHUD()
		loc_device.showHUDbars()
	endif
	
	UDCDmain.sendMinigameCritUpdateLoop(akActor)

	float[] loc_expression = loc_device.GetCurrentMinigameExpression()
	UDCDmain.UDEM.ApplyExpressionRaw(akActor, loc_expression, 100,false,15)
	if loc_device.hasHelper()
		UDCDmain.UDEM.ApplyExpressionRaw(akHelper, loc_expression, 100,false,15)
	endif
	
	float loc_currentOrgasmRate = loc_device.getStruggleOrgasmRate()
	float loc_currentArousalRate= loc_device.getArousalRate()
	UDCDmain.UDOM.UpdateOrgasmRate(akActor, loc_currentOrgasmRate,0.25)
	UDCDmain.UDOM.UpdateArousalRate(akActor,loc_currentArousalRate)
	
	;pause thred untill minigame end
	int loc_tick = 0
	while UDCDmain.ActorInMinigame(akActor) && loc_device._MinigameMainLoop_ON
		Utility.waitMenuMode(0.5)
		loc_tick += 1
		;update disable if it gets somehow removed every 0.4s
		if !(loc_tick % 2) && loc_tick
			UDCDMain.UpdateMinigameDisable(akActor)
			if akHelper
				UDCDMain.UpdateMinigameDisable(akHelper)
			endif
		endif
		;set expression every 1 second
		if !(loc_tick % 4) && loc_tick
			UDCDmain.UDEM.ApplyExpressionRaw(akActor, loc_expression, 100,false,15)
			if loc_device.hasHelper()
				UDCDmain.UDEM.ApplyExpressionRaw(akHelper, loc_expression, 100,false,15)
			endif
		endif
		
		if !(loc_tick % 4) && loc_tick
			if loc_device.canShowHUD()
				loc_device.showHUDbars(False)
			endif 		
			;update widget color
			if loc_device.UD_UseWidget && UDCDmain.UD_UseWidget && (loc_device.WearerIsPlayer() || loc_device.HelperIsPlayer())
				loc_device.updateWidgetColor()
			endif
		endif
		
		;advance skill every 3 second
		if !(loc_tick % 6) && loc_tick
			loc_device.advanceSkill(3.0)
		endif

	endwhile
	
	UDCDmain.UDOM.RemoveOrgasmRate(akActor, loc_currentOrgasmRate,0.25)		
	UDCDmain.UDOM.UpdateArousalRate(akActor,-1*loc_currentArousalRate)
	
	;returns wearer regen
	akActor.setAV("StaminaRate", staminaRate)
	akActor.setAV("HealRate", healRate)
	akActor.setAV("MagickaRate", magickaRate)
	if akHelper
		akHelper.setAV("StaminaRate", staminaRateHelper)
		akHelper.setAV("HealRate", HealRateHelper)
		akHelper.setAV("MagickaRate", magickaRateHelper)			
	endif	
	
	loc_device.addStruggleExhaustion()
	
	UDCDmain.UDEM.ResetExpressionRaw(akActor,15)
	if akHelper
		UDCDmain.UDEM.ResetExpressionRaw(akHelper,15)
	endif
	
	;remove disable
	UDCDMain.EndMinigameDisable(akActor)
	if akHelper
		UDCDMain.EndMinigameDisable(akHelper)
	endif
	loc_device._MinigameParProc_2 = false
EndFunction

;==============================
;           ORGASM
;==============================

;vars
bool _OrgasmMutex = false

;mutex
Function Start_OrgasmMutex()
	while _OrgasmMutex
		Utility.waitMenuMode(0.05)
	endwhile
	_OrgasmMutex = true
EndFunction

Function End_OrgasmMutex()
	_OrgasmMutex = false
EndFunction

;starter
bool _OrgasmStarter_Received = false

Function Send_Orgasm(Actor akActor,int iDuration,int iDecreaseArousalBy,bool bForceAnimation,bool bWairForReceive = false)
	if !akActor
		UDCDmain.Error("Send_Orgasm wrong arg received!")
	endif
	
	if bWairForReceive
		Start_OrgasmMutex()
		_OrgasmStarter_Received = false
	endif
	
	;send event
	int handle = ModEvent.Create("UDOrgasmParalel")
	if (handle)
		ModEvent.PushForm(handle, akActor)
		ModEvent.PushInt(handle, iDuration)
		ModEvent.PushInt(handle, iDecreaseArousalBy)
		ModEvent.PushInt(handle, bForceAnimation as int)
		ModEvent.PushInt(handle, bWairForReceive as int)
        ModEvent.Send(handle)
		
		;block
		if bWairForReceive
			float loc_TimeOut = 0.0
			while !_OrgasmStarter_Received && loc_TimeOut <= 1.0
				loc_TimeOut += 0.05
				Utility.waitMenuMode(0.05)
			endwhile
			
			_OrgasmStarter_Received = false
			
			if loc_TimeOut >= 1.0
				UDCDmain.Error("Send_Orgasm timeout!")
			endif
		endif
	else
		UDCDmain.Error("Send_Orgasm error!")
	endif
	if bWairForReceive
		End_OrgasmMutex()
	endif
EndFunction
Function Receive_Orgasm(Form fActor,int iDuration,int iDecreaseArousalBy,int bForceAnimation,int bWairForReceive)
	Actor akActor = fActor as Actor
	if bWairForReceive
		_OrgasmStarter_Received = true
	endif
	if UDCDmain.TraceAllowed()
		UDCDmain.Log("Receive_Orgasm received for " + fActor)
	endif
	bool loc_close = UDmain.ActorInCloseRange(akActor)
	bool loc_is3Dloaded = akActor.Is3DLoaded() || ActorIsPlayer(akActor)
	int loc_orgasmExhaustion = UDOM.GetOrgasmExhaustion(akActor) + 1
	if !UDCDmain.isRegistered(akActor) && UDmain.UD_OrgasmExhaustion
		UDmain.addOrgasmExhaustion(akActor)
	endif
	
	if loc_is3Dloaded && loc_close
		int sID = libsp.OrgasmSound.Play(akActor)
		Sound.SetInstanceVolume(sid, libsp.Config.VolumeOrgasm)
		
		akActor.CreateDetectionEvent(akActor, 60 - 15*UDCDmain.getGaggedLevel(akActor))
	endif
	
	libsp.UpdateExposure(akActor,-1*iDecreaseArousalBy)
	libsp.Aroused.UpdateActorOrgasmDate(akActor)
	
	if loc_is3Dloaded && loc_close
		if loc_orgasmExhaustion == 1
			UDEM.ApplyExpressionRaw(akActor, UDEM.GetPrebuildExpression_Orgasm2(), 75,false,50)
		else
			UDEM.ApplyExpressionRaw(akActor, UDEM.GetPrebuildExpression_Orgasm1(), 100,false,80)
		endif
	endif
	
	SendModEvent("DeviceActorOrgasm", akActor.GetLeveledActorBase().GetName())
	
	Utility.wait(iDuration)
	
	if loc_is3Dloaded && loc_close
		UDEM.ResetExpressionRaw(akActor,80)
	endif
	
EndFunction

;========================
;          UTILITY
;========================

bool Function TraceAllowed()	
	return UDCDmain.TraceAllowed()
EndFunction
Function Log(String msg, int level = 1)
	UDmain.Log(msg,level)
EndFunction
Function Error(String msg)
	UDCDMain.Error(msg)
EndFunction
Function Print(String strMsg, int iLevel = 1,bool bLog = false)
	UDmain.Print(strMsg,iLevel,bLog)
EndFunction