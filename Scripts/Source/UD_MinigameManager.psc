Scriptname UD_MinigameManager extends UD_ModuleBase

import UnforgivingDevicesMain

UD_MinigameManager Function GetSingleton() global
    return UD_Native.GetModuleByAlias("MINM") as UD_MinigameManager
EndFunction

Event OnSetup()
EndEvent

Function OnGameReload()
EndFunction

Function ReadyDeviceMinigame(ObjectReference akObj, Actor akHelper)
    UD_CustomDevice_RenderScript akDevice = akObj as UD_CustomDevice_RenderScript
    
    akDevice.setHelper(akHelper)

    Actor Wearer = akDevice.GetWearer()
    Actor Helper = akDevice.GetHelper()

    bool                    loc_WearerIsPlayer                  = akDevice.WearerIsPlayer()
    bool                    loc_HelperIsPlayer                  = akDevice.HelperIsPlayer()
    bool                    loc_PlayerInMinigame                = loc_WearerIsPlayer || loc_HelperIsPlayer
    Bool                    loc_is3DLoaded                      = loc_PlayerInMinigame || Wearer.Is3DLoaded()
    UD_CustomDevice_NPCSlot loc_WearerSlot                      = akDevice.UD_WearerSlot

    akDevice.GetWearer().AddToFaction(UDMain.UDCDmain.MinigameFaction)
    UDMain.UDCDMain.StartMinigameDisable(Wearer)
    if Helper
        Helper.AddToFaction(UDMain.UDCDmain.MinigameFaction)
        UDMain.UDCDMain.StartMinigameDisable(Helper)
    endif
    
    if loc_PlayerInMinigame
        UnforgivingDevicesMain.closeMenu()
    endif
    
    UD_Native.ForceUpdateControls()
    
    Int[] hasStruggleAnimation  ; number of found struggle animations
    Bool   loc_StartedAnimation = False
    if loc_is3DLoaded ;only play animation if actor is loaded
        hasStruggleAnimation = akDevice._PickAndPlayStruggleAnimation()
        If hasStruggleAnimation[0] == 0
            ; clear cache and try again (cache misses are possible after changing json files)
            UDmain.Warning("UD_CustomDevice_RenderScript::minigame("+akDevice.GetDeviceHeader()+") _PickAndPlayStruggleAnimation failed. Clear cache and try again")
            hasStruggleAnimation = akDevice._PickAndPlayStruggleAnimation(bClearCache = True)
            If hasStruggleAnimation[0] > 0
                loc_StartedAnimation = true
            endif
        else
            loc_StartedAnimation = true
        endif
    endif
    
    if loc_PlayerInMinigame
        UDMain.UDCDmain.setCurrentMinigameDevice(akDevice)
    else
        StorageUtil.SetFormValue(Wearer, "UD_currentMinigameDevice", akDevice.deviceRendered)
    endif
    
    if loc_is3DLoaded
        UDmain.libsp.pant(Wearer)
    endif
    
    akDevice.OnMinigameStart()
EndFunction

Function ReadyActorMinigame(Actor akTarget, Actor akHelper)
    bool                    loc_TargetIsPlayer                  = UD_Native.IsPlayer(akTarget)
    bool                    loc_HelperIsPlayer                  = UD_Native.IsPlayer(akHelper)
    bool                    loc_PlayerInMinigame                = loc_TargetIsPlayer || loc_HelperIsPlayer
    Bool                    loc_is3DLoaded                      = loc_PlayerInMinigame || akTarget.Is3DLoaded()

    akTarget.AddToFaction(UDMain.UDCDmain.MinigameFaction)
    UDMain.UDCDMain.StartMinigameDisable(akTarget)
    if akHelper
        akHelper.AddToFaction(UDMain.UDCDmain.MinigameFaction)
        UDMain.UDCDMain.StartMinigameDisable(akHelper)
    endif
    
    if loc_PlayerInMinigame
        UnforgivingDevicesMain.closeMenu()
    endif
    
    UD_Native.ForceUpdateControls()
    
    Int[] hasStruggleAnimation  ; number of found struggle animations
    Bool   loc_StartedAnimation = False
    if loc_is3DLoaded ;only play animation if actor is loaded
        String[] _HornyAnimDefs = UDmain.UDAM.GetHornyAnimDefs(akTarget)
        If _HornyAnimDefs && _HornyAnimDefs.Length > 0
            Actor[] loc_actors = new Actor[1]
            loc_actors[0] = akTarget
            UDmain.UDAM.PlayAnimationByDef(_HornyAnimDefs[UD_Native.RandomInt(0, _HornyAnimDefs.Length - 1)], loc_actors)
        Else
            UDmain.Warning("UD_MinigameManager::ReadyActorMinigame() Can't find animations for the horny actor")
        EndIf
    endif
    
    if loc_is3DLoaded
        UDmain.libsp.pant(akTarget)
    endif
EndFunction

Function LoadDeviceMinigame(ObjectReference akObj, Actor akHelper)
    UD_CustomDevice_RenderScript akDevice = akObj as UD_CustomDevice_RenderScript
    ; Wait for UD to load first
    while UD_native.AreModulesReady(true)
        Utility.Wait(1)
    endwhile
    
    Actor Wearer = akDevice.GetWearer()
    Actor Helper = akDevice.GetHelper()

    bool                    loc_WearerIsPlayer                  = akDevice.WearerIsPlayer()
    bool                    loc_HelperIsPlayer                  = akDevice.HelperIsPlayer()
    bool                    loc_PlayerInMinigame                = loc_WearerIsPlayer || loc_HelperIsPlayer
    Bool                    loc_is3DLoaded                      = loc_PlayerInMinigame || Wearer.Is3DLoaded()

    ;UDMain.UDCDMain.StartMinigameDisable(Wearer)
    ;if Helper
    ;    Helper.AddToFaction(UDMain.UDCDmain.MinigameFaction)
    ;    UDMain.UDCDMain.StartMinigameDisable(Helper)
    ;endif
    
    if loc_PlayerInMinigame
        UnforgivingDevicesMain.closeMenu()
    endif
    
    UD_Native.ForceUpdateControls()
    
    ; First stop ongoing animation, as its impossible to continue one saved
    akDevice._StopMinigameAnimation()
    
    Int[] hasStruggleAnimation  ; number of found struggle animations
    Bool   loc_StartedAnimation = False
    if loc_is3DLoaded ;only play animation if actor is loaded
        hasStruggleAnimation = akDevice._PickAndPlayStruggleAnimation()
        If hasStruggleAnimation[0] == 0
            ; clear cache and try again (cache misses are possible after changing json files)
            UDmain.Warning("UD_CustomDevice_RenderScript::minigame("+akDevice.GetDeviceHeader()+") _PickAndPlayStruggleAnimation failed. Clear cache and try again")
            hasStruggleAnimation = akDevice._PickAndPlayStruggleAnimation(bClearCache = True)
            If hasStruggleAnimation[0] > 0
                loc_StartedAnimation = true
            endif
        else
            loc_StartedAnimation = true
        endif
    endif
    
    ;akDevice.OnMinigameStart()
EndFunction

Function LoadActorMinigame(Actor akTarget, Actor akHelper)
    ; Wait for UD to load first
    while UD_native.AreModulesReady(true)
        Utility.Wait(1)
    endwhile
    
    bool                    loc_TargetIsPlayer                  = UD_Native.IsPlayer(akTarget)
    bool                    loc_HelperIsPlayer                  = UD_Native.IsPlayer(akHelper)
    bool                    loc_PlayerInMinigame                = loc_TargetIsPlayer || loc_HelperIsPlayer
    Bool                    loc_is3DLoaded                      = loc_PlayerInMinigame || akTarget.Is3DLoaded()

    if loc_PlayerInMinigame
        UnforgivingDevicesMain.closeMenu()
    endif
    
    UD_Native.ForceUpdateControls()
    
    ; First stop ongoing animation, as its impossible to continue one saved
    ; !!!!!!!!!!!! TODO !!!!!!!!!!!!!!!
    ;akDevice._StopMinigameAnimation()
    
    Int[] hasStruggleAnimation  ; number of found struggle animations
    Bool   loc_StartedAnimation = False
    if loc_is3DLoaded ;only play animation if actor is loaded
        ; !!!!!!!!!!!! TODO !!!!!!!!!!!!!!!
        ;hasStruggleAnimation = akDevice._PickAndPlayStruggleAnimation()
        ;If hasStruggleAnimation[0] == 0
        ;    ; clear cache and try again (cache misses are possible after changing json files)
        ;    UDmain.Warning("UD_CustomDevice_RenderScript::minigame("+akDevice.GetDeviceHeader()+") _PickAndPlayStruggleAnimation failed. Clear cache and try again")
        ;    hasStruggleAnimation = akDevice._PickAndPlayStruggleAnimation(bClearCache = True)
        ;    If hasStruggleAnimation[0] > 0
        ;        loc_StartedAnimation = true
        ;    endif
        ;else
        ;    loc_StartedAnimation = true
        ;endif
    endif
    
    ;akDevice.OnMinigameStart()
EndFunction

Function UpdateMinigameExpression(Actor akTarget, Actor akHelper)
    ; TODO: Way to change expression
    float[] loc_expression = UDmain.UDEM.GetPrebuildExpression_Concetrated1()
    bool loc_Res = UDmain.libsp.ExpLibs.ApplyExpressionRaw(akTarget, loc_expression, 100,false,15)
    if akHelper
        UDmain.libsp.ExpLibs.ApplyExpressionRaw(akHelper, loc_expression, 100,false,15)
    endif
EndFunction

Function StopDeviceMinigame(ObjectReference akObj, Actor akHelper)
    UD_CustomDevice_RenderScript akDevice = akObj as UD_CustomDevice_RenderScript
    Actor Wearer = akDevice.GetWearer()
    Actor Helper = akDevice.GetHelper()
    bool  loc_WearerIsPlayer   = akDevice.WearerIsPlayer()
    bool  loc_HelperIsPlayer   = akDevice.HelperIsPlayer()
    bool  loc_PlayerInMinigame = loc_WearerIsPlayer || loc_HelperIsPlayer
    Bool  loc_is3DLoaded       = loc_PlayerInMinigame || Wearer.Is3DLoaded()
    
    akDevice._StopMinigameAnimation()
    
    if loc_is3DLoaded
        UDmain.libsp.ExpLibs.ResetExpressionRaw(Wearer,15)
        if Helper
            UDmain.libsp.ExpLibs.ResetExpressionRaw(Helper,15)
        endif
    endif
    
    if Wearer
        Wearer.RemoveFromFaction(UDMain.UDCDmain.MinigameFaction)
    endif
    if Helper
        Helper.RemoveFromFaction(UDMain.UDCDmain.MinigameFaction)
    endif
    
    UD_Native.ForceUpdateControls()
    
    akDevice._UnsetMinigameDevice()
    
    if loc_is3DLoaded && (UDmain.UDGV.UDG_MinigameExhaustion.Value == 1)
        akDevice.addStruggleExhaustion(Helper)
    endif
    
    Udmain.UDMOM.Procces_UpdateModifiers_MinigameEnded(akDevice)
    
    ;remove disable from wearer
    If !UDMain.UDOM.GetOrgasmInMinigame(Wearer)
        UDMain.UDCDMain.EndMinigameDisable(Wearer,loc_WearerIsPlayer as Int)
    EndIf
    if Helper && !UDMain.UDOM.GetOrgasmInMinigame(Helper)
        UDMain.UDCDMain.EndMinigameDisable(Helper, loc_HelperIsPlayer as Int)
    endif

    akDevice.setHelper(none)
    
    akDevice._CheckUnlock()
EndFunction

Function StopActorMinigame(Actor akTarget, Actor akHelper)
    bool  loc_TargetIsPlayer   = UD_Native.IsPlayer(akTarget)
    bool  loc_HelperIsPlayer   = UD_Native.IsPlayer(akHelper)
    bool  loc_PlayerInMinigame = loc_TargetIsPlayer || loc_HelperIsPlayer
    Bool  loc_is3DLoaded       = loc_PlayerInMinigame || akTarget.Is3DLoaded()
    
    Int loc_toggle  = 0x0
    if !OrgasmSystem.IsOrgasming(akTarget)
        ;wearer is not orgasming, stop animation
        loc_toggle += 0x1
    endif
    if loc_toggle
        UDmain.UDAM.StopAnimation(akTarget, none, abEnableActors = False, aiToggle = loc_toggle)
    endif
    
    if loc_is3DLoaded
        UDmain.libsp.ExpLibs.ResetExpressionRaw(akTarget,15)
        if akHelper
            UDmain.libsp.ExpLibs.ResetExpressionRaw(akHelper,15)
        endif
    endif
    
    if akTarget
        akTarget.RemoveFromFaction(UDMain.UDCDmain.MinigameFaction)
    endif
    if akHelper
        akHelper.RemoveFromFaction(UDMain.UDCDmain.MinigameFaction)
    endif
    
    UD_Native.ForceUpdateControls()
    
    ; TODO: Add handling for non device minigames
    ;if loc_is3DLoaded && (UDmain.UDGV.UDG_MinigameExhaustion.Value == 1)
    ;    akDevice.addStruggleExhaustion(Helper)
    ;endif
    
    ;remove disable from wearer
    If !UDMain.UDOM.GetOrgasmInMinigame(akTarget)
        UDMain.UDCDMain.EndMinigameDisable(akTarget,loc_TargetIsPlayer as Int)
    EndIf
    if akHelper && !UDMain.UDOM.GetOrgasmInMinigame(akHelper)
        UDMain.UDCDMain.EndMinigameDisable(akHelper, loc_HelperIsPlayer as Int)
    endif
EndFunction


Function CutDevice(ObjectReference akObj,Float afValue)
    UD_CustomDevice_RenderScript akDevice = akObj as UD_CustomDevice_RenderScript
    akDevice._cutDevice(afValue)
EndFunction

Function PlayRedShader(Actor akWearer, Actor akHelper)
    UDMain.UDlibs.RedCrit.RemoteCast(akWearer,akWearer,akWearer)
    if akHelper
        UDMain.UDlibs.RedCrit.RemoteCast(akHelper,akHelper,akHelper)
    endif
EndFunction

Function PlayGreenShader(Actor akWearer, Actor akHelper)
    UDMain.UDlibs.GreenCrit.RemoteCast(akWearer,akWearer,akWearer)
    if akHelper
        UDMain.UDlibs.GreenCrit.RemoteCast(akHelper,akHelper,akHelper)
    endif
EndFunction

Function PlayBlueShader(Actor akWearer, Actor akHelper)
    UDMain.UDlibs.BlueCrit.RemoteCast(akWearer,akWearer,akWearer)
    if akHelper
        UDMain.UDlibs.BlueCrit.RemoteCast(akHelper,akHelper,akHelper)
    endif
EndFunction