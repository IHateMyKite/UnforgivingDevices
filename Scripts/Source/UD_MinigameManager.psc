Scriptname UD_MinigameManager extends UD_ModuleBase

import UnforgivingDevicesMain

UD_MinigameManager Function GetSingleton() global
    return UD_Native.GetModuleByAlias("MINM") as UD_MinigameManager
EndFunction

Event OnSetup()
EndEvent

Function OnGameReload()
EndFunction

Function ReadyDeviceMinigame(UD_CustomDevice_RenderScript akDevice, Actor akHelper)
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
        UDMain.UDCDmain.MinigameKeysRegister()
    else
        StorageUtil.SetFormValue(Wearer, "UD_currentMinigameDevice", akDevice.deviceRendered)
    endif
    
    if loc_is3DLoaded
        UDmain.libsp.pant(Wearer)
    endif
    
    akDevice.OnMinigameStart()
EndFunction

Function UpdateMinigameExpression(UD_CustomDevice_RenderScript akDevice, Actor akHelper)
    Actor Wearer = akDevice.GetWearer()
    Actor Helper = akDevice.GetHelper()
    float[] loc_expression = akDevice.GetCurrentMinigameExpression()
    UDmain.libsp.ExpLibs.ApplyExpressionRaw(Wearer, loc_expression, 100,false,15)
    if Helper
        UDmain.libsp.ExpLibs.ApplyExpressionRaw(Helper, loc_expression, 100,false,15)
    endif
EndFunction

Function StopDeviceMinigame(UD_CustomDevice_RenderScript akDevice, Actor akHelper)
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
    
    if loc_PlayerInMinigame
        UDMain.UDCDmain.MinigameKeysUnRegister()
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