Scriptname UD_ParalelProcess extends Quest

UDCustomDeviceMain Property UDCDmain auto
UnforgivingDevicesMain Property UDmain auto

Bool Property Ready auto

Event OnInit()
	registerEvents()

	if TraceAllowed()	
		Log("UD_ParalelProcess ready!",0)
	endif
	
	Ready = True
EndEvent

;==============================
;           REGISTER
;==============================
Function RegisterEvents()
	RegisterForModEvent("UDMinigameStarter", "Receive_MinigameStarter")
	RegisterForModEvent("UDMinigameParalel", "Receive_MinigameParalel")
EndFunction

;==============================
;           MINIGAME
;==============================
;vars
bool _MinigameMutex = false

;mutex
Function Start_MinigameMutex()
	while _MinigameMutex
		Utility.waitMenuMode(0.05)
	endwhile
	_MinigameMutex = true
EndFunction

Function End_MinigameMutex()
	_MinigameMutex = false
EndFunction

;starter
bool _MinigameStarter_Received = false
UD_CustomDevice_RenderScript Send_MinigameStarter_Package_device

Function Send_MinigameStarter(Actor akActor,UD_CustomDevice_RenderScript udDevice)
	if !akActor || !udDevice
		UDCDmain.Error("Send_MinigameStarter wrong arg received!")
	endif
	
	Start_MinigameMutex()
	_MinigameStarter_Received = false
	
	;send event
	int handle = ModEvent.Create("UDMinigameStarter")
	if (handle)
		Send_MinigameStarter_Package_device = udDevice
		ModEvent.PushForm(handle, akActor)
        ModEvent.Send(handle)
		
		;block
		float loc_TimeOut = 0.0
		while !_MinigameStarter_Received && loc_TimeOut <= 1.0
			loc_TimeOut += 0.05
			Utility.waitMenuMode(0.05)
		endwhile
		_MinigameStarter_Received = false
		
		if loc_TimeOut >= 1.0
			UDCDmain.Error("Send_MinigameStarter timeout!")
		endif
	else
		UDCDmain.Error("Send_MinigameStarter error!")
	endif
	End_MinigameMutex()
EndFunction
Function Receive_MinigameStarter(Form fActor)
	UD_CustomDevice_RenderScript loc_device = Send_MinigameStarter_Package_device
	Actor akActor = fActor as Actor
	Actor akHelper = loc_device.getHelper()
	_MinigameStarter_Received = true
	
	StorageUtil.SetFormValue(akActor, "UD_currentMinigameDevice", loc_device.deviceRendered)
	
	if loc_device.PlayerInMinigame()
		UDCDmain.setCurrentMinigameDevice(loc_device)
	endif
EndFunction

;paralel
bool _MinigameParalel_Received = false
UD_CustomDevice_RenderScript Send_MinigameParalel_Package_device
Function Send_MinigameParalel(Actor akActor,UD_CustomDevice_RenderScript udDevice)
	if !akActor || !udDevice
		UDCDmain.Error("Send_MinigameParalel wrong arg received!")
	endif
	
	Start_MinigameMutex()
	_MinigameParalel_Received = false
	
	;send event
	int handle = ModEvent.Create("UDMinigameParalel")
	if (handle)
		Send_MinigameParalel_Package_device = udDevice
		ModEvent.PushForm(handle, akActor)
        ModEvent.Send(handle)
		
		;block
		float loc_TimeOut = 0.0
		while !_MinigameParalel_Received && loc_TimeOut <= 1.0
			loc_TimeOut += 0.05
			Utility.waitMenuMode(0.05)
		endwhile
		_MinigameParalel_Received = false
		
		if loc_TimeOut >= 1.0
			UDCDmain.Error("Send_MinigameParalel timeout!")
		endif
	else
		UDCDmain.Error("Send_MinigameParalel error!")
	endif
	End_MinigameMutex()
EndFunction
Function Receive_MinigameParalel(Form fActor)
	UD_CustomDevice_RenderScript loc_device = Send_MinigameStarter_Package_device
	Actor akActor = fActor as Actor
	Actor akHelper = loc_device.getHelper()
	_MinigameParalel_Received = true
	
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
	float staminaRateHelper = 0.0
	float HealRateHelper = 0.0
	float magickaRateHelper = 0.0
	
	akActor.setAV("StaminaRate", staminaRate*loc_device.UD_RegenMag_Stamina)
	akActor.setAV("HealRate", HealRate*loc_device.UD_RegenMag_Health)
	akActor.setAV("MagickaRate", magickaRate*loc_device.UD_RegenMag_Magicka)

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
	
	if loc_device.UD_minigame_canCrit || loc_device._customMinigameCritChance
		UDCDmain.sendMinigameCritUpdateLoop(akActor)
	endif
	
	;apply expression
	sslBaseExpression loc_expression = UDCDmain.UDEM.getExpression("UDStruggleMinigame_Angry")
	(UDCDmain.libs as zadlibs_UDPatch).ApplyExpressionPatched(akActor, loc_expression, 100,false,15)
	if loc_device.hasHelper()
		(UDCDmain.libs as zadlibs_UDPatch).ApplyExpressionPatched(akHelper, loc_expression, 100,false,15)
	endif
	
	float loc_currentOrgasmRate = loc_device.getStruggleOrgasmRate()
	float loc_currentArousalRate= loc_device.getArousalRate()
	UDCDmain.UpdateOrgasmRate(akActor, loc_currentOrgasmRate,0.25)
	UDCDmain.UpdateArousalRate(akActor,loc_currentArousalRate)
	
	;pause thred untill minigame end
	int loc_tick = 0
	while UDCDmain.ActorInMinigame(akActor)
		Utility.waitMenuMode(0.25)
		loc_tick += 1
		;update disable if it gets somehow removed
		if !(loc_tick % 4)
			UDCDMain.UpdateMinigameDisable(akActor)
			if akHelper
				UDCDMain.UpdateMinigameDisable(akHelper)
			endif
		endif
	endwhile
	
	UDCDmain.RemoveOrgasmRate(akActor, loc_currentOrgasmRate,0.25)		
	UDCDmain.UpdateArousalRate(akActor,-1*loc_currentArousalRate)
	
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
	
	(UDCDmain.libs as zadlibs_UDPatch).ResetExpressionPatched(akActor, loc_expression,15)
	if akHelper
		(UDCDmain.libs as zadlibs_UDPatch).ResetExpressionPatched(akHelper, loc_expression,15)
	endif
	
	;remove disable
	UDCDMain.EndMinigameDisable(akActor)
	if akHelper
		UDCDMain.EndMinigameDisable(akHelper)
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