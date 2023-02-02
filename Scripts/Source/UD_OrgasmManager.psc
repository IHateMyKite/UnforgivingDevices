Scriptname UD_OrgasmManager extends Quest conditional

import UnforgivingDevicesMain

UDCustomDeviceMain                      Property UDCDmain   auto
UnforgivingDevicesMain                  Property UDmain     auto
UD_libs                                 Property UDlibs     auto
zadlibs                                 Property libs       auto
UD_ExpressionManager                    Property UDEM       auto
UD_CustomDevices_NPCSlotsManager        Property UDCD_NPCM  auto

zadlibs_UDPatch Property libsp
    zadlibs_UDPatch function Get()
        return UDCDmain.libsp
    endfunction
endproperty

float   Property UD_OrgasmResistence        = 3.5   auto ;orgasm rate required for actor to be able to orgasm, lower the value, the faster will orgasm rate increase stop
int     Property UD_OrgasmArousalThreshold  = 95    auto ;arousal required for actor to be able to orgasm
bool    Property UD_UseOrgasmWidget         = True  auto
float   Property UD_OrgasmUpdateTime        = 0.2   auto
int     Property UD_OrgasmAnimation         = 1     auto
int     Property UD_OrgasmDuration          = 20    auto
bool    Property UD_HornyAnimation          = true  auto
int     Property UD_HornyAnimationDuration  = 5     auto
Int     Property UD_OrgasmArousalReduce     = 25    auto        ;how much will be arousal rate reduced per second
Int     Property UD_OrgasmArousalReduceDuration = 7    auto     ;how long will the effect last
Actor Property UD_StopActorOrgasmCheckLoop      = none auto
Actor Property UD_StopActorArousalCheckLoop     = none auto

Faction Property OrgasmFaction              auto
Faction Property OrgasmCheckLoopFaction     auto
Faction Property ArousalCheckLoopFaction    auto
Faction Property OrgasmResistFaction        auto

;used for validating loop on update
;current loop version, changing this to different number will reset the loops with lower versions
Int Property UD_OrgasmCheckLoop_ver     =  3     autoreadonly
int Property UD_ArousalCheckLoop_ver    =  3     autoreadonly

;DOCUMANTATION - StorageUtil interfaces
;/
    Orgasm rate                 - Key="UD_OrgasmRate"               , Type=Float    , def_value=      0.0
    Orgasm forcing              - Key="UD_OrgasmForcing"            , Type=Float    , def_value=      0.0
    Orgasm Rate Multiplier      - Key="UD_OrgasmRateMultiplier"     , Type=Float    , def_value=      1.0
    Orgasm progress             - Key="UD_OrgasmProgress"           , Type=Float    , def_value=      0.0
    Orgasm capacity             - Key="UD_OrgasmCapacity"           , Type=Float    , def_value=    100.0
    Orgasm resistance           - Key="UD_OrgasmResist"             , Type=Float    , def_value=    MCM setting (def. 3.5)
    Orgasm resistance mult.     - Key="UD_OrgasmResistMultiplier"   , Type=Float    , def_value=      1.0
/;

String Property _OrgasmEventName                = "UD_Orgasm"               auto hidden
String Property _UpdateBaseOrgasmValEventName   = "UD_UpdateBaseOrgasmVal"  auto hidden
bool Property Ready auto conditional
Event OnInit()
    RegisterModEvents()
    Ready = true
EndEvent

Function RegisterModEvents()
    _OrgasmEventName = "UD_Orgasm"
    _UpdateBaseOrgasmValEventName = "UD_UpdateBaseOrgasmVal"
    RegisterForModEvent(_OrgasmEventName,"Orgasm")
    RegisterForModEvent("DeviceActorOrgasm", "OnOrgasm")
    RegisterForModEvent("DeviceEdgedActor", "OnEdge")
    RegisterForModEvent("HookOrgasmStart", "OnSexlabOrgasmStart")
    RegisterForModEvent("SexLabOrgasmSeparate", "OnSexlabSepOrgasmStart")
    RegisterForModEvent(_UpdateBaseOrgasmValEventName, "Receive_UpdateBaseOrgasmVals")
EndFunction


;used for update, transfers loop from UD_CustomDeviceMain in to this script
;this is only valid for player, all NPCS need to be reregistered
Function Update()
    UnregisterForAllModEvents()
    RegisterModEvents()
EndFunction

Function RemoveAbilities(Actor akActor)
    if akActor
        akActor.RemoveSpell(UDlibs.OrgasmCheckAbilitySpell)
        akActor.RemoveSpell(UDlibs.ArousalCheckAbilitySpell)
    endif
EndFunction

Function CheckOrgasmCheck(Actor akActor)
    if !UDmain.ActorIsPlayer(akActor)
        return
    endif
    if !akActor.HasMagicEffectWithKeyword(UDlibs.OrgasmCheck_KW)
        StartOrgasmCheckLoop(akActor)
    endif
    if !akActor.hasSpell(UDlibs.OrgasmCheckAbilitySpell)
        if akActor.HasMagicEffectWithKeyword(UDlibs.OrgasmCheck_KW)
            akActor.DispelSpell(UDlibs.OrgasmCheckSpell)
            StartOrgasmCheckLoop(akActor)
        else
            StartOrgasmCheckLoop(akActor)
        endif
    endif
EndFunction

Function CheckArousalCheck(Actor akActor)
    if !UDmain.ActorIsPlayer(akActor)
        return
    endif
    if !akActor.HasMagicEffectWithKeyword(UDlibs.ArousalCheck_KW)
        StartArousalCheckLoop(akActor)
    endif
    if !akActor.hasSpell(UDlibs.ArousalCheckAbilitySpell)
        if akActor.HasMagicEffectWithKeyword(UDlibs.ArousalCheck_KW)
            akActor.DispelSpell(UDlibs.ArousalCheckSpell)
            StartArousalCheckLoop(akActor)
        else
            StartArousalCheckLoop(akActor)
        endif
    endif
EndFunction

Int Function UpdateArousal(Actor akActor ,float arousal)
    libs.UpdateExposure(akActor, arousal, true)
    return GetActorArousal(akActor)
EndFunction

Int Function getArousal(Actor akActor)
    if akActor.isInFaction(ArousalCheckLoopFaction)
        return akActor.GetFactionRank(ArousalCheckLoopFaction)
    else
        return getActorArousal(akActor)
    endif
EndFunction

;=============================================
;               AROUSAL RATE
;=============================================
bool _ArousalRateManip_Mutex = false
Float Function UpdateArousalRate(Actor akActor ,float fArousalRate)
    if !akActor
        return 0.0
    endif
    if !fArousalRate
        return getArousalRate(akActor)
    endif
    while _ArousalRateManip_Mutex
        Utility.waitMenuMode(0.05)
    endwhile
    _ArousalRateManip_Mutex = true
    Int loc_arousalRate_Raw = Round(fArousalRate*100)
    Float loc_newArousalRate = StorageUtil.AdjustIntValue(akActor, "UD_ArousalRate",loc_arousalRate_Raw)/100.0
    _ArousalRateManip_Mutex = false
    return loc_newArousalRate
EndFunction

Float Function getArousalRate(Actor akActor)
    return StorageUtil.getIntValue(akActor, "UD_ArousalRate",0)/100.0
EndFunction

Float Function getArousalRateM(Actor akActor)
    return getArousalRate(akActor)*getArousalRateMultiplier(akActor)
EndFunction

;=============================================
;           AROUSAL RATE MULTIPLIER
;=============================================

bool _ArousalRateMultManip_Mutex = false
Float Function UpdateArousalRateMultiplier(Actor akActor ,float fArousalRateM)
    if !akActor
        return 0.0
    endif
    if !fArousalRateM
        return getArousalRateMultiplier(akActor)
    endif
    while _ArousalRateMultManip_Mutex
        Utility.waitMenuMode(0.05)
    endwhile
    _ArousalRateMultManip_Mutex = true
    Int loc_ArousalRateMultManip_Raw = Round(fArousalRateM*100)
    Int loc_newArousalRateM = StorageUtil.getIntValue(akActor, "UD_ArousalRateM",100) + loc_ArousalRateMultManip_Raw
    StorageUtil.setIntValue(akActor, "UD_ArousalRateM",loc_newArousalRateM)
    _ArousalRateMultManip_Mutex = false
    return loc_newArousalRateM/100.0
EndFunction

Float Function getArousalRateMultiplier(Actor akActor)
    return fRange(StorageUtil.getIntValue(akActor, "UD_ArousalRateM",100)/100.0,0.0,100.0)
EndFunction

Function StartArousalCheckLoop(Actor akActor)
    if !akActor
        UDmain.Error("None passed to StartArousalCheckLoop!!!")
    endif
    
    if UDmain.TraceAllowed()    
        UDmain.Log("StartArousalCheckLoop("+getActorName(akActor)+") called")
    endif
    
    if akActor.HasMagicEffectWithKeyword(UDlibs.ArousalCheck_KW)
        return
    endif
    
    akActor.AddSpell(UDlibs.ArousalCheckAbilitySpell,false)
EndFunction

bool Function ArousalLoopBreak(Actor akActor,Int iVersion)
    bool loc_cond = false
    ;loc_cond = loc_cond || !UDCDMain.isRegistered(akActor)
    return loc_cond
EndFunction

int Function getActorArousal(Actor akActor)
    return libs.Aroused.GetActorExposure(akActor)
EndFunction
;=======================================
;                  ORGASM RATE
;=======================================
bool _OrgasmRateManip_Mutex = false
float Function UpdateOrgasmRate(Actor akActor ,float orgasmRate,float orgasmForcing)
    if !akActor
        return 0.0
    endif
    if !orgasmRate && !orgasmForcing
        return getActorOrgasmRate(akActor)
    endif
    
    while _OrgasmRateManip_Mutex
        Utility.waitMenuMode(0.05)
    endwhile
    _OrgasmRateManip_Mutex = true
    
    Int loc_orgasmRate_Raw      = Round(orgasmRate*100)
    Int loc_orgasmForcing_Raw   = Round(orgasmForcing*100)
    float loc_newOrgasmRate
    if loc_orgasmRate_Raw
        loc_newOrgasmRate = StorageUtil.AdjustIntValue(akActor, "UD_OrgasmRate",loc_orgasmRate_Raw)/100.0
    else
        loc_newOrgasmRate = getActorOrgasmRate(akActor)
    endif
    if loc_orgasmForcing_Raw
        StorageUtil.AdjustIntValue(akActor, "UD_OrgasmForcing",loc_orgasmForcing_Raw)
    endif
    
    _OrgasmRateManip_Mutex = false
    return loc_newOrgasmRate
EndFunction
float Function getActorOrgasmRate(Actor akActor)
    return fRange(StorageUtil.getIntValue(akActor, "UD_OrgasmRate",0)/100.0,0.0,1000.0)
EndFunction
float Function getActorAfterMultOrgasmRate(Actor akActor)
    return getActorOrgasmRate(akActor)*getActorOrgasmRateMultiplier(akActor)
EndFunction
float Function getActorAfterMultAntiOrgasmRate(Actor akActor)
    return CulculateAntiOrgasmRateMultiplier(getArousal(akActor))*getActorOrgasmResistMultiplier(akActor)*getActorOrgasmResist(akActor)
EndFunction
float Function getActorOrgasmForcing(Actor akActor)
    return fRange(StorageUtil.getIntValue(akActor, "UD_OrgasmForcing",0)/100.0,0.0,1.0)
EndFunction

;=======================================
;          ORGASM RATE MULTIPLIER
;=======================================
bool _OrgasmRateMultManip_Mutex = false
Float Function UpdateOrgasmRateMultiplier(Actor akActor ,float orgasmRateMultiplier)
    if !akActor
        return 1.0
    endif
    if !orgasmRateMultiplier
        return getActorOrgasmRateMultiplier(akActor)
    endif
    while _OrgasmRateMultManip_Mutex
        Utility.waitMenuMode(0.05)
    endwhile
    _OrgasmRateMultManip_Mutex = true
    Int loc_newOrgasmRateMult = StorageUtil.getIntValue(akActor, "UD_OrgasmRateMultiplier",100) + Round(orgasmRateMultiplier*100)
    StorageUtil.setIntValue(akActor, "UD_OrgasmRateMultiplier",loc_newOrgasmRateMult)
    _OrgasmRateMultManip_Mutex = false
    return loc_newOrgasmRateMult
EndFunction
float Function getActorOrgasmRateMultiplier(Actor akActor)
    return fRange(StorageUtil.getIntValue(akActor, "UD_OrgasmRateMultiplier",100)/100.0,0.0,10.0)
EndFunction

;=======================================
;              ORGASM RESISTENCE
;=======================================
bool _OrgasmResistManip_Mutex = false
Float Function UpdateOrgasmResist(Actor akActor ,float orgasmResist)
    if !akActor
        return UD_OrgasmResistence
    endif
    if !orgasmResist
        return getActorOrgasmResist(akActor)
    endif
    while _OrgasmResistManip_Mutex
        Utility.waitMenuMode(0.05)
    endwhile
    _OrgasmResistManip_Mutex = true
    Int loc_newOrgasmResist = StorageUtil.getIntValue(akActor, "UD_OrgasmResist",Round(UD_OrgasmResistence*100)) + Round(orgasmResist*100)
    StorageUtil.setIntValue(akActor, "UD_OrgasmResist",loc_newOrgasmResist)
    _OrgasmResistManip_Mutex = false
    return loc_newOrgasmResist
EndFunction
Function setActorOrgasmResist(Actor akActor,float fValue)
    while _OrgasmResistManip_Mutex
        Utility.waitMenuMode(0.05)
    endwhile
    _OrgasmResistManip_Mutex = true
    StorageUtil.SetIntValue(akActor, "UD_OrgasmResist",Round(fValue*100))
    _OrgasmResistManip_Mutex = false
EndFunction
float Function getActorOrgasmResist(Actor akActor)
    return fRange(StorageUtil.getIntValue(akActor, "UD_OrgasmResist",Round(UD_OrgasmResistence*100))/100.0,0.0,100.0)
EndFunction
float Function getActorOrgasmResistM(Actor akActor)
    return getActorOrgasmResist(akActor)*getActorOrgasmResistMultiplier(akActor)
EndFunction
;=======================================
;       ORGASM RESISTENCE MULTIPLIER
;=======================================
bool _OrgasmResistMultManip_Mutex = false
Float Function UpdateOrgasmResistMultiplier(Actor akActor ,float orgasmResistMultiplier)
    if !akActor
        return 1.0
    endif
    if !orgasmResistMultiplier
        return getActorOrgasmResistMultiplier(akActor)
    endif
    while _OrgasmResistMultManip_Mutex
        Utility.waitMenuMode(0.05)
    endwhile
    _OrgasmResistMultManip_Mutex = true
    Int loc_newOrgasmResistMultiplier = StorageUtil.getIntValue(akActor, "UD_OrgasmResistMultiplier",100) + Round(orgasmResistMultiplier*100)
    StorageUtil.setIntValue(akActor, "UD_OrgasmResistMultiplier",loc_newOrgasmResistMultiplier)
    _OrgasmResistMultManip_Mutex = false
    return loc_newOrgasmResistMultiplier
EndFunction
float Function getActorOrgasmResistMultiplier(Actor akActor)
    return fRange(StorageUtil.getIntValue(akActor, "UD_OrgasmResistMultiplier",100)/100.0,0.0,10.0)
EndFunction

;=======================================
;              ORGASM PROGRESS
;=======================================
bool _OrgasmProgressManip_Mutex
;DO NOT USE IF UPDATE LOOP IS RUNNING. Is only used by Orgasm Resist minigame
Function UpdateActorOrgasmProgress(Actor akActor,Float fValue,bool bUpdateWidget = false)
    while _OrgasmProgressManip_Mutex
        Utility.waitMenuMode(0.1)
    endwhile
    _OrgasmProgressManip_Mutex = true
    float loc_newValue = fRange(StorageUtil.GetFloatValue(akActor, "UD_OrgasmProgress",0.0) + fValue,0.0,getActorOrgasmCapacity(akActor))
    StorageUtil.SetFloatValue(akActor, "UD_OrgasmProgress",loc_newValue)
    if bUpdateWidget && UD_UseOrgasmWidget
        UDmain.UDWC.UpdatePercent_OrgasmWidget(loc_newValue/getActorOrgasmCapacity(akActor))
    endif
    _OrgasmProgressManip_Mutex = false
EndFunction
;DO NOT USE IF UPDATE LOOP IS RUNNING. Is only used by Orgasm Resist minigame
Function SetActorOrgasmProgress(Actor akActor,Float fValue)
    while _OrgasmProgressManip_Mutex
        Utility.waitMenuMode(0.05)
    endwhile
    _OrgasmProgressManip_Mutex = true
    StorageUtil.SetFloatValue(akActor, "UD_OrgasmProgress",fRange(fValue,0.0,getActorOrgasmCapacity(akActor)))
    _OrgasmProgressManip_Mutex = false
EndFunction
Function ResetActorOrgasmProgress(Actor akActor)
    StorageUtil.UnSetFloatValue(akActor, "UD_OrgasmProgress")
EndFunction
float Function getActorOrgasmProgress(Actor akActor)
    return StorageUtil.GetFloatValue(akActor, "UD_OrgasmProgress",0.0)
EndFunction
float Function getOrgasmProgressPerc(Actor akActor)
    return StorageUtil.GetFloatValue(akActor, "UD_OrgasmProgress",0.0)/getActorOrgasmCapacity(akActor)
EndFunction


;=======================================
;ORGASM CAPACITY
;=======================================
bool _OrgasmCapacity_Mutex
Int Function UpdatetActorOrgasmCapacity(Actor akActor,float fValue)
    if !akActor
        return 100
    endif
    if !fValue
        return 100
    endif
    while _OrgasmCapacity_Mutex
        Utility.waitMenuMode(0.1)
    endwhile
    _OrgasmCapacity_Mutex = true
    Int loc_NewOrgasmCapacity = StorageUtil.getIntValue(akActor, "UD_OrgasmCapacity",100) + Round(fValue)
    StorageUtil.setIntValue(akActor, "UD_OrgasmCapacity",loc_NewOrgasmCapacity)
    _OrgasmCapacity_Mutex = false
    return loc_NewOrgasmCapacity
EndFunction
float Function getActorOrgasmCapacity(Actor akActor)
    return StorageUtil.GetIntValue(akActor, "UD_OrgasmCapacity",100)
EndFunction
Function SetActorOrgasmCapacity(Actor akActor,float fValue)
    while _OrgasmCapacity_Mutex
        Utility.waitMenuMode(0.1)
    endwhile
    _OrgasmCapacity_Mutex = true
    StorageUtil.setIntValue(akActor, "UD_OrgasmCapacity",Round(fValue))
    _OrgasmCapacity_Mutex = false
EndFunction

;=======================================
;ORGASM UTILITY CALCULATIONS
;=======================================

;return true if actor can orgasm at 100 arousal
bool Function ActorCanOrgasm(Actor akActor)
    return (getActorOrgasmRate(akActor)*getActorOrgasmRateMultiplier(akActor) > CulculateAntiOrgasmRateMultiplier(100)*UD_OrgasmResistence*getActorOrgasmResistMultiplier(akActor))
EndFunction

;return true if actor can orgasm at 50 arousal, because its not linear, orgasm rate would need to be gigantic 
bool Function ActorCanOrgasmHalf(Actor akActor)
    return (getActorOrgasmRate(akActor)*getActorOrgasmRateMultiplier(akActor) > CulculateAntiOrgasmRateMultiplier(50)*UD_OrgasmResistence*getActorOrgasmResistMultiplier(akActor))
EndFunction

float Function CulculateAntiOrgasmRateMultiplier(int iArousal)
    return fRange((Math.pow(10,fRange(100.0/iRange(iArousal,1,100),1.0,2.0) - 1.0)),1.0,100.0)
EndFunction

;///////////////////////////////////////
;=======================================
;ORGASM MAIN LOOP
;=======================================
;//////////////////////////////////////;

Function StartOrgasmCheckLoop(Actor akActor)
    if UDmain.TraceAllowed()    
        UDmain.Log("StartOrgasmCheckLoop("+getActorName(akActor)+") called")
    endif
    if !akActor
        UDmain.Error("None passed to sendOrgasmCheckLoop!!!")
    endif
    if akActor.HasMagicEffectWithKeyword(UDlibs.OrgasmCheck_KW)
        return
    endif
    
    ;UDlibs.OrgasmCheckSpell.cast(akActor)
    akActor.AddSpell(UDlibs.OrgasmCheckAbilitySpell,false)
EndFunction

bool Function OrgasmLoopBreak(Actor akActor, int iVersion)
    bool loc_cond = false
    ;loc_cond = loc_cond || !UDCDmain.isRegistered(akActor)
    return loc_cond
EndFunction

;=======================================
;=======================================
;ORGASM
;=======================================

Function startOrgasm(Actor akActor,int duration,int iArousalDecrease = 75,int iForce = 0, bool blocking = true)
    if UDmain.TraceAllowed()
        UDmain.Log("startOrgasm() for " + getActorName(akActor) + ", duration = " + duration + ",blocking = " + blocking,1)
    endif
    int handle = ModEvent.Create(_OrgasmEventName)
    if (handle)
        ModEvent.PushForm(handle, akActor)
        ModEvent.PushInt(handle, duration)
        ModEvent.PushInt(handle, iArousalDecrease)
        ModEvent.PushInt(handle, iForce)
        ModEvent.Send(handle)
        
        ;check for orgasm start
        if blocking
            float loc_time = 0.0
            while !StorageUtil.GetIntValue(akActor,"UD_Orgasm_Evnt_Received",0) && loc_time <= 0.5
                Utility.waitMenuMode(0.05)
                loc_time += 0.05
            endwhile
            
            if loc_time >= 0.5
                UDmain.Error("startOrgasm("+getActorName(akActor)+") timeout!")
            endif
            StorageUtil.UnsetIntValue(akActor,"UD_Orgasm_Evnt_Received")
        endif
    endIf    
EndFunction

;will rework later
Function Orgasm(Form fActor,int duration,int iArousalDecrease,int iForce)
    Actor akActor = fActor as Actor
    StorageUtil.SetIntValue(akActor,"UD_Orgasm_Evnt_Received",1)
    ActorOrgasm(akActor,duration,iArousalDecrease,iForce,true)
EndFunction

;call devices function orgasm() when player have DD orgasm
Event OnOrgasm(string eventName, string strArg, float numArg, Form sender)
    UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByActorName(strArg)
    if slot
        slot.orgasm()
    endif
EndEvent

;call devices function orgasm() when player have sexlab orgasm
Event OnSexlabOrgasmStart(int tid, bool HasPlayer)
    if HasPlayer
        UDCD_NPCM.getPlayerSlot().orgasm()
    endif
EndEvent 

Function OnSexlabSepOrgasmStart(Form kActor, Int iThread)
    Actor akActor = kActor as Actor
    UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByActor(akActor)
    if slot
        slot.orgasm()
    endif
EndFunction

bool Function isOrgasming(Actor akActor)
    return akActor.isInFaction(OrgasmFaction)
EndFunction

Int Function getOrgasmingCount(Actor akActor)
    if isOrgasming(akActor)
        return akActor.GetFactionRank(OrgasmFaction)
    else
        return 0
    endif
EndFunction

Int Function addOrgasmToActor(Actor akActor)
    if !isOrgasming(akActor)
        akActor.addToFaction(OrgasmFaction)
        akActor.SetFactionRank(OrgasmFaction,0)
        return 0
    endif
    ;akActor.ModFactionRank(OrgasmFaction,1) ;no return of new value ??
    Int loc_res = akActor.GetFactionRank(OrgasmFaction) + 1
    akActor.SetFactionRank(OrgasmFaction,loc_res)
    return loc_res
EndFunction

int Function removeOrgasmFromActor(Actor akActor)
    if !isOrgasming(akActor)
        return 0
    endif
    
    akActor.ModFactionRank(OrgasmFaction,-1)
    int loc_count = getOrgasmingCount(akActor)
    if loc_count == 0
        akActor.removeFromFaction(OrgasmFaction)
    endif
    return loc_count
EndFunction

Int Function     UpdateHornyLevel(Actor akActor, Int aiValue)
    Int loc_val = GetHornyLevel(akActor)
    if aiValue
        loc_val = iRange(loc_val + aiValue,-5,5)
        SetHornyLevel(akActor, loc_val)
        return loc_val
    else
        return loc_val
    endif
EndFunction

Function     SetHornyLevel(Actor akActor, Int aiValue)
    StorageUtil.SetIntValue(akActor,"UD_HornyLevel",iRange(aiValue,-5,5))
EndFunction

Int Function GetHornyLevel(Actor akActor)
    return StorageUtil.GetIntValue(akActor,"UD_HornyLevel",0)
EndFunction

String Function GetHornyLevelString(Actor akActor)
    Int loc_edgeLevel = StorageUtil.GetIntValue(akActor,"UD_HornyLevel",0)
    string loc_res
    if loc_edgeLevel == -5
        loc_res = "Going crazy"
    elseif loc_edgeLevel == -4
        loc_res = "Climaxing nonstop"
    elseif loc_edgeLevel == -3
        loc_res = "Can't stop cumming"
    elseif loc_edgeLevel == -2
        loc_res = "Very exhausted"
    elseif loc_edgeLevel == -1
        loc_res = "Exhausted"
    elseif loc_edgeLevel == 0
        loc_res = "Normal"
    elseif loc_edgeLevel == 1
        loc_res = "Horny"
    elseif loc_edgeLevel == 2
        loc_res = "Very Horny"
    elseif loc_edgeLevel == 3
        loc_res = "Increadibly horny"
    elseif loc_edgeLevel == 4
        loc_res = "Wants to cum badly"
    elseif loc_edgeLevel == 5
        loc_res = "Driven mad with pleasure"
    endif
    return loc_res
EndFunction

Float Function     UpdateHornyProgress(Actor akActor, Float afValue)
    Float loc_val = GetHornyProgress(akActor)
    if afValue
        loc_val = loc_val + afValue
        SetHornyProgress(akActor, loc_val)
        return loc_val
    else
        return loc_val
    endif
EndFunction

Function     SetHornyProgress(Actor akActor, Float afValue)
    StorageUtil.SetFloatValue(akActor,"UD_HornyProgress",afValue)
EndFunction

Float Function GetHornyProgress(Actor akActor)
    return StorageUtil.GetFloatValue(akActor,"UD_HornyProgress",0.0)
EndFunction

Float Function GetRelativeHornyProgress(Actor akActor)
    return StorageUtil.GetFloatValue(akActor,"UD_HornyProgress",0.0)/(3.0*GetActorOrgasmCapacity(akActor))
EndFunction

Function ActorOrgasm(actor akActor,int iDuration, int iDecreaseArousalBy = 10,int iForce = 0, bool bForceAnimation = false)
    Int loc_orgasms = addOrgasmToActor(akActor)
    ;call stopMinigame so it get stoped before all other shit gets processed
    bool loc_actorinminigame = UDCDmain.actorInMinigame(akActor)
    if loc_actorinminigame
        StorageUtil.SetIntValue(akActor,"UD_OrgasmInMinigame_Flag",1)
        UDCDMain.getMinigameDevice(akActor).StopMinigame()
    endif
    
    UpdateBaseOrgasmVals(akActor, UD_OrgasmArousalReduceDuration, -5.0, 0.0, -1.0*iDecreaseArousalBy)

    if UDmain.TraceAllowed()
        UDCDmain.Log("ActorOrgasmPatched called for " + GetActorName(akActor),1)
    endif
    
    UDmain.UDPP.Send_Orgasm(akActor,iDuration,iDecreaseArousalBy,iForce,bForceAnimation,bWairForReceive = false)
    
    bool loc_isplayer   = UDmain.ActorIsPlayer(akActor)
    bool loc_isfollower = false
    if !loc_isplayer
        loc_isfollower  = UDmain.ActorIsFollower(akActor)
    endif
    bool loc_is3Dloaded = akActor.Is3DLoaded() || loc_isplayer
    bool loc_cond       = loc_is3Dloaded && UDmain.ActorInCloseRange(akActor)
    
    if loc_actorinminigame
        Int loc_res = PlayOrgasmAnimation(akActor,iDuration)
        if loc_res == 1
            StorageUtil.UnsetIntValue(akActor,"UD_OrgasmInMinigame_Flag")
        endif
    elseif !loc_cond || ((akActor.IsInCombat() || akActor.IsSneaking()) && (loc_isplayer || loc_isfollower))
        if UDmain.ActorIsPlayer(akActor)
            UDCDmain.Print("You managed to avoid losing control over your body from orgasm!",2)
        endif
        akActor.damageAv("Stamina",50.0)
        akActor.damageAv("Magicka",50.0)
        Utility.wait(iDuration)
    elseif akActor.GetCurrentScene() || akActor.IsInFaction(libsp.Sexlab.AnimatingFaction)
        if UDmain.TraceAllowed()    
            UDCDmain.Log("ActorOrgasmPatched - sexlab animation detected - not playing animation for " + GetActorName(akActor),2)
        endif
        Utility.wait(iDuration)
    else
        PlayOrgasmAnimation(akActor,iDuration)
    endif
    
    loc_orgasms = RemoveOrgasmFromActor(akActor)
    if loc_orgasms == 0
        if loc_cond
            UDEM.ResetExpressionRaw(akActor,80)
        endif
    endif
EndFunction

Int Function GetOrgasmAnimDuration(Actor akActor)
    return StorageUtil.GetIntValue(akActor,"UD_OrgasmDuration",0)
EndFunction

Bool Function GetOrgasmInMinigame(Actor akActor)
    return StorageUtil.GetIntValue(akActor,"UD_OrgasmInMinigame_Flag",0)
EndFunction

Int Function PlayOrgasmAnimation(Actor akActor,int aiDuration)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_OrgasmManager::PlayOrgasmAnimation() akActor = " + akActor + ", aiDuration = " + aiDuration)
    EndIf
    if !aiDuration
        return 0 ;error
    endif
    if StorageUtil.GetIntValue(akActor,"UD_OrgasmDuration",0)
        Int loc_duration = Round(aiDuration*0.35)
        StorageUtil.AdjustIntValue(akActor,"UD_OrgasmDuration",loc_duration) ;incfrease current orgasm animation by 50%
        Utility.wait(loc_duration)
        return 2 ;animation prolonged, but not player
    else
        StorageUtil.SetIntValue(akActor,"UD_OrgasmDuration",aiDuration)
    endif
    
    int loc_isPlayer = UDmain.ActorIsPlayer(akActor) as Int
    if loc_isPlayer
        UDmain.UDUI.GoToState("UIDisabled") ;disable UI
    endif
    
    UDMain.UDWC.StatusEffect_SetBlink("effect-orgasm", True)
    Bool loc_is3Dloaded = akActor.Is3DLoaded()
    
    UDCDmain.DisableActor(akActor,loc_isPlayer)
    
    if loc_is3Dloaded
        String[] animationArray = UDmain.UDAM.GetOrgasmAnimEvents(akActor)
        If animationArray.Length > 0
            UDmain.UDAM.StartSoloAnimation(akActor, animationArray[Utility.RandomInt(0, animationArray.Length - 1)], abDisableActor = False)
        EndIf
    endif
    
    int loc_elapsedtime = 0
    while loc_elapsedtime < aiDuration
        if loc_elapsedtime && !(loc_elapsedtime % 2)
            UDCDmain.UpdateDisabledActor(akActor,loc_isPlayer)
        else
            aiDuration = StorageUtil.GetIntValue(akActor,"UD_OrgasmDuration",aiDuration)
        endif
        Utility.wait(1.0)
        loc_elapsedtime += 1
    endwhile
    
    UDMain.UDWC.StatusEffect_SetBlink("effect-orgasm", False)
    StorageUtil.UnsetIntValue(akActor,"UD_OrgasmDuration")
    
    if loc_is3Dloaded
        UDmain.UDAM.StopAnimation(akActor, abEnableActors = False)
    endif
    
    UDCDmain.EnableActor(akActor,loc_isPlayer)

    if loc_isPlayer
        UDmain.UDUI.GoToState("") ;enable UI
    endif
    return 1
EndFunction

Function addOrgasmExhaustion(Actor akActor)
    UDlibs.OrgasmExhaustionSpell.Cast(akActor, akActor)
    if UDmain.TraceAllowed()
        UDmain.Log("Orgasm exhaustion debuff applied to "+ getActorName(akActor),1)
    endif
EndFunction

;UNUSED
;call devices function edge() when player get edged
Function OnEdge(string eventName, string strArg, float numArg, Form sender)
    if strArg != UDmain.Player.getActorBase().getName()
        int random = Utility.randomInt(1,3)
        if random == 1
            UDMain.UDWC.Notification_Push(strArg + " gets denied just before reaching the orgasm!")
        elseif random == 2
            UDMain.UDWC.Notification_Push(strArg + " screams as they are edged just before climax!")
        elseif random == 3
            UDMain.UDWC.Notification_Push(strArg + " is edged!")
        endif
    endif
    UD_CustomDevice_NPCSlot slot = UDCD_NPCM.getNPCSlotByActorName(strArg)
    if slot
        slot.edge()
    endif
EndFunction

int Function GetOrgasmExhaustion(Actor akActor)
    return StorageUtil.getIntValue(akActor,"UD_OrgasmExhaustionNum")
EndFunction

Function UpdateBaseOrgasmVals(Actor akActor, int aiDuration, float afOrgasmRate, float afForcing = 0.0, float afArousalRate = 0.0)
    int handle = ModEvent.Create("UD_UpdateBaseOrgasmVal")
    if (handle)
        ModEvent.PushForm (handle , akActor)
        ModEvent.PushInt  (handle , aiDuration)
        ModEvent.PushFloat(handle , afOrgasmRate)
        ModEvent.PushFloat(handle , afForcing)
        ModEvent.PushFloat(handle , afArousalRate)
        ModEvent.Send(handle)
    else
        UDmain.Error("Can't create UD_UpdateBaseOrgasmVal event!")
    endif
EndFunction

Function Receive_UpdateBaseOrgasmVals(Form akFormActor, int aiDuration, float afOrgasmRate,float afForcing, float afArousalRate)
    Actor akActor = akFormActor as Actor
    if afOrgasmRate || afForcing
        UpdateOrgasmRate(akActor,afOrgasmRate,afForcing)
    endif
    if afArousalRate
        UpdateArousalRate(akActor,afArousalRate)
    endif
    
    Utility.wait(aiDuration)
    
    if afOrgasmRate || afForcing
        UpdateOrgasmRate(akActor,-1*afOrgasmRate,-1*afForcing)
    endif
    if afArousalRate
        UpdateArousalRate(akActor,-1*afArousalRate)
    endif
EndFunction

Function FocusOrgasmResistMinigame(Actor akActor)
EndFunction