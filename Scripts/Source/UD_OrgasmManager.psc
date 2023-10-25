;   File: UD_OrgasmManager
;   Contains functions for manipulating orgasm related variables and other manipulation functions
Scriptname UD_OrgasmManager extends Quest conditional

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain                      Property UDCDmain   auto
UnforgivingDevicesMain                  Property UDmain     auto
UD_libs                                 Property UDlibs     auto
zadlibs                                 Property libs       auto
UD_CustomDevices_NPCSlotsManager        Property UDCD_NPCM  auto

UD_Config _udconf
UD_Config Property UDCONF hidden
    UD_Config Function Get()
        if !_udconf
            _udconf = UDmain.UDCONF
        endif
        return _udconf
    EndFunction
EndProperty

zadlibs_UDPatch _libsp
zadlibs_UDPatch Property libsp hidden
    zadlibs_UDPatch Function get()
        if !_libsp
            _libsp = UDmain.libsp
        endif
        return _libsp
    EndFunction
EndProperty

;/  Variable: OrgasmFaction
    Faction to which will ba actor added for duration of orgasm
    
    Do not edit, *READ ONLY!*
/;
Faction Property OrgasmFaction              auto

;/  Variable: OrgasmResistFaction
    Faction to which will ba actor added if they are in resist orgasm minigame
    
    Do not edit, *READ ONLY!*
/;
Faction Property OrgasmResistFaction        auto

;DOCUMENTATION - StorageUtil interfaces
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

;/  Variable: Ready
    Will be toggled to True once script is ready
    
    Do not edit, *READ ONLY!*
/;
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

;/  Group: Arousal values
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: UpdateArousal

    Parameters:

        akActor - Actor whose arousal will be updated
        aiDiff  - By how much. Can be both positive and negative

    Returns:

        New values of arousal after update
/;
Int Function UpdateArousal(Actor akActor ,float aiDiff)
    libs.UpdateExposure(akActor, aiDiff, true)
    return GetActorArousal(akActor)
EndFunction

;/  Function: getArousal

    Faster and more accurate version of <getActorArousal> which uses faction.

    Parameters:

        akActor - Actor whose arousal will be returned

    Returns:

        Current actor arousal
/;
float Function getArousal(Actor akActor)
    return OrgasmSystem.GetOrgasmVariable(akActor,8)
EndFunction

;/  Function: getActorArousal

    Parameters:

        akActor - Actor whose arousal will be returned

    Returns:

        Current actor arousal
/;
int Function getActorArousal(Actor akActor)
    return akActor.GetFactionRank(libs.Aroused.slaArousal)
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

;/  Group: Orgasm values
===========================================================================================
===========================================================================================
===========================================================================================
/;

;;/  Function: getActorOrgasmCapacity
;
;    See <getActorOrgasmCapacity>
;/;
float Function getActorOrgasmCapacity(Actor akActor)
    return OrgasmSystem.GetOrgasmVariable(akActor,5)
EndFunction

;/  Group: Orgasm
===========================================================================================
===========================================================================================
===========================================================================================
/;

;=======================================
;ORGASM UTILITY CALCULATIONS
;=======================================

;/  Function: ActorCanOrgasm

    Check if actor can orgasm with current orgasm values. This assumes full (100) arousal

    Parameters:
        akActor - Actors who will be checked

    Returns:

        True if actor can orgasm
/;
bool Function ActorCanOrgasm(Actor akActor)
    return (OrgasmSystem.GetOrgasmVariable(akActor,1)*OrgasmSystem.GetOrgasmVariable(akActor,2) > CulculateAntiOrgasmRateMultiplier(100)*UDCONF.UD_OrgasmResistence*OrgasmSystem.GetOrgasmVariable(akActor,4))
EndFunction

;/  Function: ActorCanOrgasmHalf

    Check if actor can orgasm with current orgasm values. This assumes half (50) arousal
    
    Because its not linear, orgasm rate would need to be gigantic 

    Parameters:
        akActor - Actors who will be checked

    Returns:

        True if actor can orgasm
/;
bool Function ActorCanOrgasmHalf(Actor akActor)
    return (OrgasmSystem.GetOrgasmVariable(akActor,1)*OrgasmSystem.GetOrgasmVariable(akActor,2) > CulculateAntiOrgasmRateMultiplier(50)*UDCONF.UD_OrgasmResistence*OrgasmSystem.GetOrgasmVariable(akActor,4))
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

;=======================================
;=======================================
;ORGASM
;=======================================

;/  Function: startOrgasm

    See <Orgasm>
/;
Function startOrgasm(Actor akActor,int duration,int iArousalDecrease = 10,int iForce = 0, bool blocking = true)
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
    ActorOrgasm(akActor,duration,iArousalDecrease,iForce)
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

;/  Function: isOrgasming

    Check if actor is currently orgasming

    Parameters:
        akActor - Actors who will be checked

    Returns:

        True if actor is orgasming
/;
bool Function isOrgasming(Actor akActor)
    return akActor.isInFaction(OrgasmFaction)
EndFunction

;/  Function: getOrgasmingCount

    Number of orgasm the actor currently have (in case actor orgasm again before previous orgasm ends)

    Parameters:
        akActor - Actors who will be checked

    Returns:

        Number of orgasms
/;
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

;Int Function     UpdateHornyLevel(Actor akActor, Int aiValue)
;    Int loc_val = GetHornyLevel(akActor)
;    if aiValue
;        loc_val = iRange(loc_val + aiValue,-5,5)
;        SetHornyLevel(akActor, loc_val)
;        return loc_val
;    else
;        return loc_val
;    endif
;EndFunction

;Function     SetHornyLevel(Actor akActor, Int aiValue)
;    StorageUtil.SetIntValue(akActor,"UD_HornyLevel",iRange(aiValue,-5,5))
;EndFunction

;Int Function GetHornyLevel(Actor akActor)
;    return StorageUtil.GetIntValue(akActor,"UD_HornyLevel",0)
;EndFunction

String Function GetHornyLevelString(Actor akActor)
    float loc_HornyLevel = OrgasmSystem.GetOrgasmVariable(akActor,8)
    string loc_res
    
    if fInRange(loc_HornyLevel,0.0,40.0)
        loc_res = "Going crazy"
    elseif fInRange(loc_HornyLevel,40.0,85.0)
        loc_res = "Exhausted"
    elseif fInRange(loc_HornyLevel,85.0,115.0)
        loc_res = "Normal"
    elseif fInRange(loc_HornyLevel,115.0,200.0)
        loc_res = "Horny"
    elseif fInRange(loc_HornyLevel,200.0,275.0)
        loc_res = "Very Horny"
    elseif fInRange(loc_HornyLevel,275.0,325.0)
        loc_res = "Increadibly horny"
    else 
        loc_res = "Wants to cum badly"
    endif
    ;if fInRange(loc_HornyLevel,0.0,25.0)
    ;    loc_res = "Going crazy"
    ;elseif fInRange(loc_HornyLevel,25.0,50.0)
    ;    loc_res = "Climaxing nonstop"
    ;elseif fInRange(loc_HornyLevel,50.0,75.0)
    ;    loc_res = "Can't stop cumming"
    ;elseif fInRange(loc_HornyLevel,75.0,100.0)
    ;    loc_res = "Very exhausted"
    ;elseif loc_HornyLevel == -1
    ;    loc_res = "Exhausted"
    ;elseif loc_HornyLevel == 0
    ;    loc_res = "Normal"
    ;elseif loc_HornyLevel == 1
    ;    loc_res = "Horny"
    ;elseif loc_HornyLevel == 2
    ;    loc_res = "Very Horny"
    ;elseif loc_HornyLevel == 3
    ;    loc_res = "Increadibly horny"
    ;elseif loc_HornyLevel == 4
    ;    loc_res = "Wants to cum badly"
    ;elseif loc_HornyLevel == 5
    ;    loc_res = "Driven mad with pleasure"
    ;endif
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
    return StorageUtil.GetFloatValue(akActor,"UD_HornyProgress",0.0)/(3.0*OrgasmSystem.GetOrgasmVariable(akActor,5))
EndFunction

Function ActorOrgasm(actor akActor,int iDuration, int iDecreaseArousalBy = 10,int iForce = 0)
    Int loc_orgasms = addOrgasmToActor(akActor)
    ;call stopMinigame so it get stoped before all other shit gets processed
    bool loc_actorinminigame = UDCDmain.actorInMinigame(akActor)
    if loc_actorinminigame
        StorageUtil.SetIntValue(akActor,"UD_OrgasmInMinigame_Flag",1)
        UD_CustomDevice_RenderScript loc_device = UDCDMain.getMinigameDevice(akActor)
        if loc_device
            loc_device.StopMinigame()
        endif
    endif
    
    ;add it only for 5s
    ;OrgasmSystem.AddOrgasmChange(akActor,"PostOrgasm", 0xF000C,0xFFFFFFFF, -10.0, afOrgasmRateMult = -0.25, afOrgasmResistence = 1.0, afOrgasmResistenceMult = 0.25)
    ;OrgasmSystem.UpdateOrgasmChangeVar(akActor,"PostOrgasm", 9, -10, 1)

    if UDmain.TraceAllowed()
        UDmain.Log("ActorOrgasmPatched called for " + GetActorName(akActor),1)
    endif
    
    UDmain.UDPP.Send_Orgasm(akActor,iForce,bWairForReceive = false)
    
    bool loc_isplayer   = IsPlayer(akActor)
    bool loc_isfollower = false
    if !loc_isplayer
        loc_isfollower  = UDmain.ActorIsFollower(akActor)
    endif
    bool loc_is3Dloaded = akActor.Is3DLoaded() || loc_isplayer
    bool loc_cond       = loc_is3Dloaded && UDmain.ActorInCloseRange(akActor)
    
    if loc_actorinminigame
        Int loc_res = PlayOrgasmAnimation(akActor,iDuration,true)
        if loc_res == 1
            StorageUtil.UnsetIntValue(akActor,"UD_OrgasmInMinigame_Flag")
        endif
    elseif !loc_cond || ((akActor.IsInCombat() || akActor.IsSneaking()) && (loc_isplayer || loc_isfollower)) || (loc_isplayer && UDmain.IsAnyMenuOpen())
        if IsPlayer(akActor)
            UDmain.Print("You managed to avoid losing control over your body from orgasm!",2)
        endif
        akActor.damageAv("Stamina",50.0)
        akActor.damageAv("Magicka",50.0)
        Utility.wait(iDuration)
    elseif akActor.GetCurrentScene() || akActor.IsInFaction(libsp.Sexlab.AnimatingFaction)
        if UDmain.TraceAllowed()    
            UDmain.Log("ActorOrgasmPatched - sexlab animation detected - not playing animation for " + GetActorName(akActor),2)
        endif
        Utility.wait(iDuration)
    else
        PlayOrgasmAnimation(akActor,iDuration)
    endif
    
    loc_orgasms = RemoveOrgasmFromActor(akActor)
    if loc_orgasms == 0
        if loc_cond
            libs.ExpLibs.ResetExpressionRaw(akActor,80)
        endif
    endif
EndFunction

;/  Function: GetOrgasmAnimDuration

    Get remaining duration of orgasm animation

    Parameters:
        akActor - Actors who will be checked

    Returns:

        Remaining duration of orgasm
/;
Int Function GetOrgasmAnimDuration(Actor akActor)
    return StorageUtil.GetIntValue(akActor,"UD_OrgasmDuration",0)
EndFunction

Bool Function GetOrgasmInMinigame(Actor akActor)
    return StorageUtil.GetIntValue(akActor,"UD_OrgasmInMinigame_Flag",0)
EndFunction

;/  Function: PlayOrgasmAnimation

    Plays orgasm animation for aiDuration

    Parameters:
        akActor     - Actors who will be used in animation
        aiDuration  - For how long to play the animation
        

    Returns:

        1 in case of sucess. 0 in case of failure
/;
Int Function PlayOrgasmAnimation(Actor akActor,int aiDuration, bool abContinue = false)
    If UDmain.TraceAllowed()
        UDmain.Log("UD_OrgasmManager::PlayOrgasmAnimation() akActor = " + akActor + ", aiDuration = " + aiDuration, 3)
    EndIf
    if !aiDuration
        return 0 ;error
    endif
    if StorageUtil.GetIntValue(akActor,"UD_OrgasmDuration",0)
        Int loc_duration = Round(aiDuration*0.35)
        StorageUtil.AdjustIntValue(akActor,"UD_OrgasmDuration",loc_duration) ;incfrease current orgasm animation by 35%
        Utility.wait(loc_duration)
        return 2 ;animation prolonged, but not played
    else
        StorageUtil.SetIntValue(akActor,"UD_OrgasmDuration",aiDuration)
    endif
    
    int loc_isPlayer = IsPlayer(akActor) as Int
    if loc_isPlayer
        UDmain.UDUI.GoToState("UIDisabled") ;disable UI
        UDMain.UDWC.StatusEffect_SetBlink("effect-orgasm", True)
    endif
    
    Bool loc_is3Dloaded = akActor.Is3DLoaded()
    
    UDCDmain.DisableActor(akActor,loc_isPlayer)
    
    if loc_is3Dloaded
        ; updating ActorConstraintsInt
        UDmain.UDAM.GetActorConstraintsInt(akActor, abUseCache = False)
        String[] loc_animationArray = UDmain.UDAM.GetOrgasmAnimDefs(akActor)
        If loc_animationArray.Length > 0
            Actor[] loc_actors = new Actor[1]
            loc_actors[0] = akActor
            UDmain.UDAM.PlayAnimationByDef(loc_animationArray[Utility.RandomInt(0, loc_animationArray.Length - 1)], loc_actors, abDisableActors = False, abContinueAnimation = abContinue)
        Else
            UDmain.Warning("UD_OrgasmManager::PlayOrgasmAnimation() Can't find orgasm animations for the actor")
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
    
    if loc_isPlayer
        UDMain.UDWC.StatusEffect_SetBlink("effect-orgasm", False)
    endif
    
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
    UD_CustomDevice_NPCSlot loc_slot = UDCD_NPCM.getNPCSlotByActorName(strArg)
    if loc_slot
        Actor loc_actor = loc_slot.getActor()
        if !loc_slot.isPlayer() && UDmain.ActorInCloseRange(loc_actor)
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
        endif
        loc_slot.edge()
    endif
EndFunction

;/  Function: GetOrgasmExhaustion

    Get numer of orgasm exhaustions

    Parameters:
        akActor     - Checked actor

    Returns:

        Number of orgasm exhaustions actor currently have
/;
int Function GetOrgasmExhaustion(Actor akActor)
    return StorageUtil.getIntValue(akActor,"UD_OrgasmExhaustionNum")
EndFunction

;/  Function: isOrgasmExhaustedMax

    Checks whether the number of orgasm exhaustions is over the configured limit

    Parameters:
        akActor     - Checked actor

    Returns:

        Whether this actor is over the limit (returns false if configured limit is 0)
/;
bool Function isOrgasmExhaustedMax(Actor akActor)
    return UDCONF.UD_OrgasmExhaustionStruggleMax > 0 && (GetOrgasmExhaustion(akActor) >= UDCONF.UD_OrgasmExhaustionStruggleMax)
EndFunction

Function FocusOrgasmResistMinigame(Actor akActor)
EndFunction