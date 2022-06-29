Scriptname UnforgivingDevicesMain extends Quest  conditional
{Main function of Unforgiving Devices}

zadlibs property libs auto 
zadxlibs property libsx auto
zadxlibs2 property libsx2 auto

;patched zadlibs
zadlibs_UDPatch property libsp
	zadlibs_UDPatch Function get()
		return libs as zadlibs_UDPatch
	EndFunction
EndProperty

bool Property UD_OrgasmExhaustion = True auto
float Property UD_OrgasmExhaustionMagnitude = 0.0 auto
int Property UD_OrgasmExhaustionDuration = 50 auto

UD_libs Property UDlibs auto
UDCustomDeviceMain Property UDCDmain auto
UD_AbadonQuest_script Property UDAbadonQuest auto

bool Property UD_AutoLoad = false auto
UD_MCM_script Property config  Auto  
UDItemManager Property ItemManager auto
UD_RandomRestraintManager Property UDRRM auto
UD_LeveledList_Patcher Property UDLLP auto
UD_OrgasmManager Property UDOM auto
UD_ExpressionManager Property UDEM auto
UD_ParalelProcess Property UDPP auto
UD_CustomDevices_NPCSlotsManager Property UDNPCM auto
UD_MutexManagerScript Property UDMM auto
UD_ModifierManager_Script Property UDMOM auto

bool property lockMCM = false auto
bool property udequiped auto
bool property DebugMod = False auto conditional
bool Property AllowNPCSupport = False auto

bool Property UD_DisableUpdate = false auto hidden conditional

;zadlibs patch control
bool Property UD_zadlibs_ParalelProccesing = false auto

bool _UD_hightPerformance
bool Property UD_hightPerformance
	Function set(bool bValue)
		_UD_hightPerformance = bValue
		if _UD_hightPerformance 
			UD_baseUpdateTime = UD_HightPerformanceTime
			;ItemManager.UD_WaitTime = 0.3
		else
			UD_baseUpdateTime = UD_LowPerformanceTime
			;ItemManager.UD_WaitTime = 0.8
		endif
	EndFunction
	
	bool Function get()
		return _UD_hightPerformance
	EndFunction
EndProperty

float Property UD_LowPerformanceTime = 1.0 Auto
float Property UD_HightPerformanceTime = 0.25 Auto

float Property UD_baseUpdateTime auto

zadConfig Property DDconfig auto 

Spell OrgasmExhaustionSpell
bool Property Ready = False auto

String[] Property UD_OfficialPatches auto

Event OnInit()
	RegisterForModEvent("UD_VibEvent","EventVib")
	UD_hightPerformance = UD_hightPerformance
	
	While !UDlibs.ready
		Utility.waitMenuMode(0.25)
	EndWhile
	if TraceAllowed()	
		Log("UDLibs ready!",0)
	endif
	While !UDCDmain.ready
		Utility.waitMenuMode(0.25)
	EndWhile
	if TraceAllowed()	
		Log("UDCDmain ready!",0)
	endif
	While !config.ready
		Utility.waitMenuMode(0.25)
	EndWhile	
	if TraceAllowed()	
		Log("config ready!",0)
	endif
	While !ItemManager.ready
		Utility.waitMenuMode(0.25)
	EndWhile		
	if TraceAllowed()	
		Log("ItemManager ready!",0)
	endif
	While !UDLLP.ready
		Utility.waitMenuMode(0.25)
	endwhile
	if TraceAllowed()	
		Log("UDLLP ready!",0)
	endif

	While !UDOM.ready
		Utility.WaitMenuMode(0.1)
	endwhile
	if TraceAllowed()	
		Log("UDOM ready!",0)
	endif
	
	OrgasmExhaustionSpell = UDlibs.OrgasmExhaustionSpell
	OrgasmExhaustionSpell.SetNthEffectDuration(0, UD_OrgasmExhaustionDuration)

	if UD_hightPerformance
		UD_baseUpdateTime = UD_HightPerformanceTime
	else
		UD_baseUpdateTime = UD_LowPerformanceTime
	endif
	
	CheckOptionalMods()
	
	if TraceAllowed()	
		Log("UnforgivingDevicesMain initialized",0)
	endif
	Print("$UDREADY")
	
	Utility.wait(5.0)
	RegisterForSingleUpdate(0.1)
	CheckPatchesOrder()
EndEvent

Event OnUpdate()
	Update()
EndEvent

Function Update()
	if !UDOM
		Error("UDOM not loaded! Loading...")
		UDOM = UDCDMain.GetMeMyForm(0x15B532,"UnforgivingDevices.esp") as UD_OrgasmManager
		Error("UDOM set to "+UDOM)
	endif
	
	if !UDEM
		Error("UDEM not loaded! Loading...")
		UDEM = UDCDMain.GetMeMyForm(0x156417,"UnforgivingDevices.esp") as UD_ExpressionManager
		Error("UDEM set to "+UDEM)
	endif

	if !UDPP
		Error("UDPP not loaded! Loading...")
		UDPP = (self as Quest) as UD_ParalelProcess
		Error("UDPP set to "+UDPP)
	endif
	
	if !UDNPCM
		Error("UDNPCM not loaded! Loading...")
		UDNPCM = UDCDMain.GetMeMyForm(0x14E7EB,"UnforgivingDevices.esp") as UD_CustomDevices_NPCSlotsManager
		Error("UDNPCM set to "+UDNPCM)
	endif
	
	if !UDMM
		Error("UDMM not loaded! Loading...")
		UDMM = UDCDMain.GetMeMyForm(0x15B555,"UnforgivingDevices.esp") as UD_MutexManagerScript
		Error("UDMM set to "+UDMM)
	endif
	
EndFunction

bool Property ZaZAnimationPackInstalled = false auto
;zbfBondageShell Property ZAZBS auto

bool Property OSLArousedInstalled = false auto
bool Property ConsoleUtilInstalled = false auto

bool Property SlaveTatsInstalled = false auto

Function CheckOptionalMods()
	If ModInstalled("ZaZAnimationPack.esm")
		ZaZAnimationPackInstalled = True
		if TraceAllowed()
			Log("Zaz animation pack detected!")
		endif
	else
		ZaZAnimationPackInstalled = False
	endif
	
	if ModInstalled("OSLAroused.esp")
		OSLArousedInstalled = True
		if TraceAllowed()
			Log("OSLAroused detected!")
		endif
	else
		OSLArousedInstalled = false
	endif
		
	if ModInstalled("SlaveTats.esp")
		SlaveTatsInstalled = True
		if TraceAllowed()
			Log("SlaveTats detected!")
		endif
	else
		SlaveTatsInstalled = false
	endif	
	
	if ModInstalled("UIExtensions.esp")
		if TraceAllowed()
			Log("UIExtensions detected!")
		endif
	else
		debug.messagebox("--!ERROR!--\nUD can't detect UIExtensions. Without this mode, some features of Unforgiving Devices will not work as intended. Please be warned.")
	endif
	
	if ConsoleUtil.GetVersion()
		ConsoleUtilInstalled = True
		if TraceAllowed()
			Log("ConsoleUtil detected!")
		endif
	else
		debug.messagebox("--!ERROR!--\nUD can't detect ConsoleUtil. Without this mode, some features of Unforgiving Devices will not work as intended. Please be warned.")
		ConsoleUtilInstalled = False
	endif
EndFUnction

Function CheckPatchesOrder()
	int loc_it = 0
	while loc_it < UD_OfficialPatches.length
		if ModInstalled(UD_OfficialPatches[loc_it])
			if !ModInstalledAfterUD(UD_OfficialPatches[loc_it])
				debug.messagebox("--!ERROR!--\nUD detected that patch "+ UD_OfficialPatches[loc_it] +" is loaded after UD. Patch always needs to be loaded after main mod or it will not work!!!")
			endif
		endif
		loc_it += 1
	endwhile
EndFunction

int Function getDDescapeDifficulty()
	if UDCDmain.UD_UseDDdifficulty
		return (8 - DDconfig.EscapeDifficulty)
	else
		return 4
	endif
EndFunction

bool Player_edge_var = False
;returns True for 3s after player edge
bool Function playerEdge()
	return Player_edge_var
EndFunction

bool _orgasmExhaustionMutex = false

Function addOrgasmExhaustion(Actor akActor)
	;/
	while _orgasmExhaustionMutex
		Utility.waitMenuMode(0.1)
	endwhile
	
	_orgasmExhaustionMutex = true
	
	if (akActor.HasMagicEffect(OrgasmExhaustionSpell.GetNthEffectMagicEffect(0)))
		akActor.DispelSpell(OrgasmExhaustionSpell)
		OrgasmExhaustionSpell.SetNthEffectMagnitude(0, UD_OrgasmExhaustionMagnitude + 15)
	else
		OrgasmExhaustionSpell.SetNthEffectMagnitude(0, UD_OrgasmExhaustionMagnitude)
	endif
	
	if (akActor.HasMagicEffectWithKeyword(UDlibs.AphrodisiacsEffect_KW))
		OrgasmExhaustionSpell.SetNthEffectDuration(0,Round(UD_OrgasmExhaustionDuration/2.0))
	else
		OrgasmExhaustionSpell.SetNthEffectDuration(0,UD_OrgasmExhaustionDuration)
	endif
	/;
	OrgasmExhaustionSpell.cast(akActor)
	
	if TraceAllowed()	
		Log("Orgasm exhaustion debuff applied to "+ getActorName(akActor),1)
	endif
	;_orgasmExhaustionMutex = false
EndFunction

bool function hasAnyUD()
	return Game.getPlayer().wornhaskeyword(libs.zad_Lockable)
endfunction

Function updateEquipedUD()
	udequiped = Game.getPlayer().wornhaskeyword(UDlibs.UnforgivingDevice)
EndFunction

;vib function queue
Function startVibEffect(Actor akActor,int strength,int duration,bool edge)
	int handle = ModEvent.Create("UD_VibEvent")
	ModEvent.PushForm(handle,akActor)
	ModEvent.PushInt(handle,strength)
	ModEvent.PushInt(handle,duration)
	ModEvent.pushBool(handle,edge)
	ModEvent.Send(handle)
EndFunction

Event EventVib(Form fActor, int strenght, int duration, bool edge)
	libs.VibrateEffect(fActor as Actor, strenght, duration, edge)
EndEvent

int Property LogLevel = 0 auto
Function Log(String msg, int level = 1)
	if (iRange(level,1,3) <= LogLevel) || DebugMod
		debug.trace("[UD," + level + ",T="+Utility.GetCurrentRealTime()+"]: " + msg)
		if ConsoleUtilInstalled ;print to console
			ConsoleUtil.PrintMessage("[UD," + level + ",T="+Utility.GetCurrentRealTime()+"]: " + msg)
		endif
	endif
EndFunction

Function CLog(String msg)
	if ConsoleUtilInstalled ;print to console
		ConsoleUtil.PrintMessage("[UD] " + msg)
	endif
EndFunction

int Property PrintLevel = 3 auto
Function Print(String msg,int iLevel = 1,bool bLog = false)
	if (iRange(iLevel,1,3) <= PrintLevel)
		debug.notification(msg)
		if bLog && TraceAllowed(); || DebugMod	
			Log("Print -> " + msg)
		endif
	endif
EndFunction

Function Error(String msg)
	debug.trace("[UD,!ERROR!,T="+Utility.GetCurrentRealTime()+"]: " + msg)
	if ConsoleUtilInstalled ;print to console
		ConsoleUtil.PrintMessage("[UD,!ERROR!,T="+Utility.GetCurrentRealTime()+"]: " + msg)
	endif
EndFunction

bool Function ActorIsFollower(Actor akActor)
	;added check for followers that are not marked as followers by normal means, to make loc_res == 4 from UDCustomDeviceMain.NPCMenu() work on them as well
	;yes yes, some of the followers don't have FollowerFaction assigned, DCL uses similar check for those.
	string acName = akActor.GetDisplayName()
	if acName == "Serana" || acName == "Inigo" || acName == "Sofia" || acName == "Vilja"
		return true
	endif
	return akActor.isInFaction(UDCDmain.FollowerFaction)
EndFunction

bool Function ActorIsValidForUD(Actor akActor)
	ActorBase loc_actorbase = akActor.GetLeveledActorBase()
	Race loc_race = loc_actorbase.getRace()
	bool loc_cond = true
	loc_cond = loc_cond && (loc_race.isPlayable() || loc_race.haskeyword(UDlibs.ActorTypeNPC))
	loc_cond = loc_cond && !loc_race.IsChildRace()
	return loc_cond
EndFunction

int Property UD_HearingRange = 4000 auto
bool Function ActorInCloseRange(Actor akActor)
	if ActorIsPlayer(akActor)
		return true
	endif
	float loc_distance = CalcDistance(Game.GetPlayer(),akActor)
	return (loc_distance >= 0 && loc_distance < UD_HearingRange)
EndFunction

bool Function TraceAllowed()
	return (LogLevel > 0)
EndFunction

Function OnGameReload()
	(libs as zadlibs_UDPatch).ResetMutex()
	
	Utility.waitMenuMode(5.0)
	
	;update all scripts
	Update()
	;RegisterForSingleUpdate(0.1)
	
	UDlibs.Update()
	
	if TraceAllowed()	
		Log("OnGameReload() called!",1)
	endif
	
	UDCDmain.OnGameReset()
	Config.LoadConfigPages()
	CheckOptionalMods()
	CheckPatchesOrder()
	
	UDPP.Update()
	
	UDOM.Update()
	
	UDEM.Update()
	
	UDNPCM.GameUpdate()
EndFunction

;=======================================================================
;							GLOBAL FUNCTIONS
;========================================================================

;convert int to bit map
string Function IntToBit(int argInt) global
	string 	loc_res = 	""
	int 	loc_i 	=	32
	while loc_i ;32 bit number
		loc_i -= 1
		if Math.LogicalAnd(argInt,Math.LeftShift(0x00000001,loc_i))
			loc_res += "1"
		else
			loc_res += "0"
		endif
		
		if !(loc_i % 4) && loc_i
			loc_res += " " ;add space for better readability
		endif
	endwhile
	return loc_res
EndFunction

float Function CalcDistance(ObjectReference obj1,ObjectReference obj2) global
	if obj1 == obj2
		return 0.0
	endif
	if obj1.GetParentCell() == obj2.GetParentCell()
		float dX = obj1.X - obj2.X
		float dY = obj1.Y - obj2.Y
		float dZ = obj1.Z - obj2.Z
		return Math.Sqrt(Math.Pow(dX,2) + Math.Pow(dY,2) + Math.Pow(dZ,2))
	else
		return -1.0
	endif
EndFunction

bool Function ActorIsPlayer(Actor akActor) global
	return akActor == Game.getPlayer()
EndFunction

string Function GetActorName(Actor akActor) global
	if !akActor
		return "ERROR:NONE"
	endif
	ActorBase loc_actorbase = akActor.GetLeveledActorBase()
	string loc_res = loc_actorbase.getName()
	if loc_res == "" ;actor have no name
		if loc_actorbase.GetSex() == 0
			loc_res = "Unnamed man"
		elseif loc_actorbase.GetSex() == 1
			loc_res = "Unnamed woman"
		else
			loc_res = "Unnamed person"
		endif
	endif
	return loc_res
EndFunction

int Function codeBit(int iCodedMap,int iValue,int iSize,int iIndex) global
	if iIndex + iSize > 32
		return 0xFFFFFFFF ;returns error value
	endif
	int loc_clear_mask = 0x00000001 ;mask used to clear bits which will be set
	;sets not shifted bit mask loc_clear_mask
	int loc_help_bit = 0x02
	while iSize > 1
		iSize -= 1
		loc_clear_mask = Math.LogicalOr(loc_clear_mask,loc_help_bit)
		loc_help_bit = Math.LeftShift(loc_help_bit,1)
	endwhile
	iValue = Math.LogicalAnd(loc_clear_mask,iValue)
	loc_clear_mask = Math.LogicalXor(Math.LeftShift(loc_clear_mask,iIndex),0xFFFFFFFF) ;shift and negate
	int loc_clear_map = Math.LogicalAnd(iCodedMap,loc_clear_mask) ;clear maps bits with mask
	return Math.LogicalOr(loc_clear_map,Math.LeftShift(iValue,iIndex)) ;sets bits
	
endfunction

int Function decodeBit(int iCodedMap,int iSize,int iIndex) global
	if iIndex + iSize > 32
		return 0xFFFFFFFF ;returns error value
	endif
	
	;sets not shifted bit mask
	int loc_clear_mask = 0x00000001 ;mask used to clear all not wanted bits
	
	;sets not shifted bit mask loc_clear_mask
	int loc_help_bit = 0x02
	while iSize > 1
		iSize -= 1
		loc_clear_mask = Math.LogicalOr(loc_clear_mask,loc_help_bit)
		loc_help_bit = Math.LeftShift(loc_help_bit,1)
	endwhile	
	
	loc_clear_mask = Math.LeftShift(loc_clear_mask,iIndex) ;shift to index position
	
	int loc_res = 0x00000000 ;return value, default is int
	loc_res = Math.LogicalAnd(iCodedMap,loc_clear_mask) ;clear maps bits with mask
	loc_res = Math.RightShift(loc_res,iIndex) ;shift to right, so value is correct
	return loc_res
EndFunction

float Function fRange(float fValue,float fMin,float fMax) global
	if fValue > fMax
		return fMax
	endif
	if fValue < fMin
		return fMin
	endif
	return fValue
EndFunction

int Function iRange(int iValue,int iMin,int iMax) global
	if iValue > iMax
		return iMax
	endif
	if iValue < iMin
		return iMin
	endif
	return iValue
EndFunction

string Function formatString(string str,int floatPoints) global
	int float_point =  StringUtil.find(str,".")
	if (float_point == -1)
		return str
	endif
	if (floatPoints + float_point + 1 > StringUtil.getLength(str))
		return str
	else
		return StringUtil.Substring(str, 0, float_point + floatPoints + 1)
	endif
EndFunction

float Function checkLimit(float value,float limit) global
	if value > limit
		return limit
	else
		return value
	endif
EndFunction

int Function Round(float value) global
	return Math.floor(value + 0.5)
EndFunction

Function closeMenu() global
	;https://www.reddit.com/r/skyrimmods/comments/elg97s/function_to_close_objects_container_menu/
	UI.InvokeString("ContainerMenu", "_global.skse.CloseMenu", "ContainerMenu")
	UI.InvokeString("Dialogue Menu", "_global.skse.CloseMenu", "Dialogue Menu")
	UI.InvokeString("InventoryMenu", "_global.skse.CloseMenu", "InventoryMenu")
	UI.InvokeString("TweenMenu", "_global.skse.CloseMenu", "TweenMenu")
	UI.InvokeString("GiftMenu", "_global.skse.CloseMenu", "GiftMenu")
EndFunction

Function closeLockpickMenu() global
	UI.InvokeString("Lockpicking Menu", "_global.skse.CloseMenu", "Lockpicking Menu")
EndFunction

string Function getPlugsVibrationStrengthString(int strenght) global
	if strenght >= 5
		return "Extremely Strong"
	endif
	if strenght == 4
		return "Very Strong"
	endif
	if strenght == 3
		return "Strong"
	endif
	if strenght == 2
		return "Weak"
	endif
	if strenght <= 1
		return "Very weak"
	endif
EndFunction

;https://www.creationkit.com/index.php?title=GetActorValuePercentage_-_Actor
float Function getMaxActorValue(Actor akActor,string akValue, float perc_part = 1.0) global
	return (akActor.GetActorValue(akValue)/akActor.GetActorValuePercentage(akValue))*perc_part
EndFunction

float Function getCurrentActorValuePerc(Actor akActor,string akValue) global
	return akActor.GetActorValuePercentage(akValue)
EndFunction

float Function getCurrentActorValuePercCustom(Actor akActor,string akValue,float fBase) global
	return akActor.GetActorValue(akValue)/fBase
EndFunction

bool Function ModInstalled(string sModFileName) global
	return (Game.GetModByName(sModFileName) != 255) && (Game.GetModByName(sModFileName) != 0) ; 255 = not found, 0 = no skse
EndFunction

bool Function ModInstalledAfterUD(string sModFileName) global
	return (Game.GetModByName(sModFileName) > Game.GetModByName("UnforgivingDevices.esp"))
EndFunction

string Function MakeDeviceHeader(Actor akActor,Armor invDevice) global
	if !invDevice || !akActor
		return "ERROR: PASSED NONE"
	endif
	return (invDevice.GetName() + "("+GetActorName(akActor) + ")")
EndFunction

Int Function ToUnsig(Int iValue) global
	if iValue < 0
		return 0
	endif
	return iValue
EndFunction

Function ShowMessageBox(string strText) global
	String[] loc_lines = StringUtil.split(strText,"\n")
	int loc_linesNum = loc_lines.length
	
	int loc_lineLimit = 12
	
	int loc_boxesNum = Math.Ceiling((loc_linesNum as float)/(loc_lineLimit as float))
	int loc_iterLine = 0
	int loc_iterBox = 0
	
	
	while loc_iterBox < (loc_boxesNum)
		string loc_messagebox = ""
		
		while loc_iterLine < iRange((loc_linesNum - loc_lineLimit*loc_iterBox),0,loc_lineLimit)
			loc_messagebox += (loc_lines[loc_iterLine + (loc_lineLimit)*loc_iterBox] + "\n")
			loc_iterLine += 1
		endwhile
		
		loc_iterBox += 1
		
		if loc_boxesNum > 1
			loc_messagebox += "===PAGE " + (loc_iterBox) + "/" + (loc_boxesNum) + "===\n"
		endif
		loc_iterLine = 0
		debug.messagebox(loc_messagebox)
		
		if Game.UsingGamepad()
			Utility.waitMenuMode(0.75)
		endif
	endwhile
EndFunction