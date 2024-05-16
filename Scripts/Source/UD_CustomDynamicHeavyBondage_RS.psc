Scriptname UD_CustomDynamicHeavyBondage_RS extends UD_CustomDevice_RenderScript

import UnforgivingDevicesMain
import UD_Native

float   Property UD_UntieDifficulty = 100.0 auto
float   Property UD_UntieDmg        = 4.0   auto

bool _tied = false
float _untieProgress = 0.0

Function InitPost()
    UD_DeviceType = "Dynamic Heavy Bondage"
    UD_ActiveEffectName = "Tie up"
EndFunction

string Function addInfoString(string str = "")
    str = parent.addInfoString(str)
    str += "Tied up?: " + _tied + "\n"
    if _tied
        str += "Untie progress: " + FormatFloat(getRelativeUntieProgress()*100.0,1) + " %\n"
    endif
    return str
EndFunction

Function safeCheck()
    if !UD_SpecialMenuInteraction
        UD_SpecialMenuInteraction = UDCDmain.DefaultDynamicHBSpecialMsg
    endif
    if !UD_SpecialMenuInteractionWH
        UD_SpecialMenuInteractionWH = UDCDmain.DefaultDynamicHBSpecialMsg
    endif
    parent.safeCheck()
EndFunction

float Function getRelativeUntieProgress()
    return _untieProgress/UD_UntieDifficulty
EndFunction

Function onDeviceMenuInitPost(bool[] aControlFilter)
    parent.onDeviceMenuInitPost(aControlFilter)
    
    if _tied && CanUntie()
        UDCDmain.currentDeviceMenu_switch1 = True
    endif
    if !_tied && CanTie() && WearerFreeHands()
        UDCDmain.currentDeviceMenu_switch2 = True
    endif
    UDCDmain.currentDeviceMenu_allowSpecialMenu = True
EndFunction

Function onDeviceMenuInitPostWH(bool[] aControlFilter)
    parent.onDeviceMenuInitPostWH(aControlFilter)
    
    if _tied && CanUntie()
        UDCDmain.currentDeviceMenu_switch1 = True
    endif
    if !_tied && CanTie() && (WearerFreeHands() || HelperFreeHands())
        UDCDmain.currentDeviceMenu_switch2 = True
    endif
    UDCDmain.currentDeviceMenu_allowSpecialMenu = True
EndFunction

bool Function proccesSpecialMenu(int msgChoice)
    if msgChoice == 0 ; untie
        return UntieMinigame()
    ElseIf msgChoice == 1 ; tie up
        tieUp()
        return true
    else
       return parent.proccesSpecialMenu(msgChoice)
    endif
EndFunction

bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
    if msgChoice == 0 ; untie
        return UntieMinigame()
    ElseIf msgChoice == 1 ; tie up
        tieUp()
        return true
    else
        return parent.proccesSpecialMenuWH(akSource,msgChoice)
    endif
EndFunction

bool _untieMinigameOn = false
bool Function UntieMinigame(Bool abSilent = False)
    if !minigamePrecheck(abSilent)
        return False
    endif

    resetMinigameValues()
    
    setMinigameOffensiveVar(False,0.0,0.0)
    setMinigameCustomCrit(15,0.75)
    setMinigameWearerVar(True,UD_base_stat_drain)
    setMinigameEffectVar(True,True,0.5)
    setMinigameWidgetVar(True, True, False, 0xFFA200, 0xFFA200, -1, "icon-meter-struggle")
    setMinigameMinStats(0.8)
    
    float mult = 1.0
    
    if WearerFreeHands()
        mult += 0.25
    endif
    
    if haveHelper()
        setMinigameHelperVar(True,UD_base_stat_drain*0.8)
        setMinigameEffectHelperVar(True,True,1.2)
        mult += 0.25
    endif
    
    setMinigameMult(1,mult)
    
    if minigamePreCheck(abSilent)
        bool loc_UseNativeMeters = (WearerIsPlayer() || HelperIsPlayer())
        if loc_UseNativeMeters
            UDmain.UDWC.Meter_RegisterNative("device-main",0,getRelativeUntieProgress()*100.0,UD_UntieDmg*UDCDmain.getStruggleDifficultyModifier(),true)
            UDmain.UDWC.Meter_SetNativeMult("device-main",mult*100.0/UD_UntieDifficulty)
        endif
        
        _untieMinigameOn = True
        UD_Events.SendEvent_DeviceMinigameBegin(self,"DHB_Untie")
        minigame()
        UD_Events.SendEvent_DeviceMinigameEnd(self,"DHB_Untie")
        _untieMinigameOn = False
        
        if loc_UseNativeMeters
            UDmain.UDWC.Meter_UnregisterNative("device-main")
        endif
        return true
    else
        return false
    endif
EndFunction

Function OnMinigameTick(Float abUpdateTime)
    if _untieMinigameOn
        if PlayerInMinigame()
            UDmain.UDWC.Meter_SetNativeMult("device-main",getMinigameMult(1)*100.0/UD_UntieDifficulty)
            _untieProgress = UDmain.UDWC.Meter_GetNativeValue("device-main")*UD_UntieDifficulty/100.0
        else
            _untieProgress = fRange(_untieProgress + UD_UntieDmg*UDCDmain.getStruggleDifficultyModifier()*abUpdateTime*getMinigameMult(1),0.0,UD_UntieDifficulty)
        endif
        if _untieProgress >= UD_UntieDifficulty
            stopMinigame()
        endif
    endif
    parent.OnMinigameTick(abUpdateTime)
EndFunction

bool Function OnCritDevicePre()
    if _untieMinigameOn
        if PlayerInMinigame()
            _untieProgress = UDmain.UDWC.Meter_UpdateNativeValue("device-main",3*UD_UntieDmg*UDCDmain.getStruggleDifficultyModifier())*UD_UntieDifficulty/100.0
        else
            _untieProgress = fRange(_untieProgress + 3*UD_UntieDmg*UDCDmain.getStruggleDifficultyModifier()*getMinigameMult(1),0.0,UD_UntieDifficulty)
        endif
        if _untieProgress >= UD_UntieDifficulty
            stopMinigame()
        endif
        Return True
    else
        return parent.OnCritDevicePre()
    endif
EndFunction

Function OnCritFailure()
    if _untieMinigameOn
        if PlayerInMinigame()
            _untieProgress = UDmain.UDWC.Meter_UpdateNativeValue("device-main",-1.0*UD_UntieDifficulty*0.25)*UD_UntieDifficulty/100.0
        else
            _untieProgress =  fRange(_untieProgress - UD_UntieDifficulty*0.075,0.0,UD_UntieDifficulty)
        endif
        
    endif
    parent.OnCritFailure()
EndFunction

Function OnMinigameEnd() ;called when minigame end
    if _untieMinigameOn
        if _untieProgress >= UD_UntieDifficulty
            untie()
        endif
    endif  
    parent.OnMinigameEnd() 
EndFunction

Function updateWidget(bool force = false)
    if !_untieMinigameOn
        parent.updateWidget(force)
    endif
EndFunction

;requires override
bool Function canBeActivated()
    return !IsTiedUp() && CanTie() && (getRelativeElapsedCooldownTime() >= 0.5)
EndFunction

Function activateDevice()
    if CanTie() 
        TieUp()
    endif
EndFunction

Bool Function IsTiedUp()
    return _tied
EndFunction

Function TieUp()
    if !_tied
        if WearerIsPlayer()
            UDmain.Print(getDeviceName() + " is tying you up!")
        elseif UDCDmain.AllowNPCMessage(getWearer())
            UDmain.Print(getWearerName() + "s " + getDeviceName() + " is tying them!")
        endif
        _tied = true
        if isMinigameOn()
            StopMinigame()
        endif
        resetCooldown(3.0)
        OnTiedUp()
    endif
EndFunction

Function Untie()
    if _tied
        _untieProgress = 0.0
        _tied = false
        resetCooldown(1.0)
        OnUntied()
    endif
EndFunction

Function onRemoveDevicePost(Actor akActor)
    Untie()
    parent.onRemoveDevicePost(akActor)
EndFunction

;======================================================================
;Place new override functions here, do not forget to check override functions in parent if its not base script (UD_CustomDevice_RenderScript)
;======================================================================
Function OnTiedUp()
EndFunction
Function OnUntied()
EndFunction
Bool Function CanTie()
    return true
EndFunction
Bool Function CanUntie()
    return true
EndFunction
;============================================================================================================================
;unused override function, theese are from base script. Extending different script means you also have to add their overrride functions                                                
;theese function should be on every object instance, as not having them may cause multiple function calls to default class
;more about reason here https://www.creationkit.com/index.php?title=Function_Reference, and Notes on using Parent section
;============================================================================================================================
Function patchDevice() ;called on init. Should call patcher. Can also be dirrectly modified but should still use Patcher MCM variables
    parent.patchDevice()
EndFunction
bool Function OnMendPre(float mult) ;called on device mend (regain durability)
    return parent.OnMendPre(mult)
EndFunction
Function OnMendPost(float mult) ;called on device mend (regain durability). Only called if OnMendPre returns true
    parent.OnMendPost(mult)
EndFunction
Function OnCritDevicePost() ;called on minigame crit. Is only called if OnCritDevicePre returns true 
    parent.OnCritDevicePost()
EndFunction
bool Function OnOrgasmPre(bool sexlab = false) ;called on wearer orgasm. Is only called if wearer is registered
    return parent.OnOrgasmPre(sexlab)
EndFunction
Function OnMinigameOrgasm(bool sexlab = false) ;called on wearer orgasm while in minigame. Is only called if wearer is registered
    parent.OnMinigameOrgasm(sexlab)
EndFunction
Function OnMinigameOrgasmPost() ;called on wearer orgasm while in minigame. Is only called after OnMinigameOrgasm. Is only called if wearer is registered
    parent.OnMinigameOrgasmPost()
EndFunction
Function OnOrgasmPost(bool sexlab = false) ;called on wearer orgasm. Is only called if OnOrgasmPre returns true. Is only called if wearer is registered
    parent.OnOrgasmPost(sexlab)
EndFunction
Function OnMinigameStart() ;called when minigame start
    parent.OnMinigameStart()
EndFunction
Function OnMinigameTick1() ;called every 1s of minigame
    parent.OnMinigameTick1()
EndFunction
Function OnMinigameTick3() ;called every 3s of minigame
    parent.OnMinigameTick3()
EndFunction
float Function getAccesibility() ;return accesibility of device in range 0.0 - 1.0
    return parent.getAccesibility()
EndFunction
Function OnDeviceCutted() ;called when device is cutted
    parent.OnDeviceCutted()
EndFunction
Function OnDeviceLockpicked() ;called when device is lockpicked
    parent.OnDeviceLockpicked()
EndFunction
Function OnLockReached() ;called when device lock is reached
    parent.OnLockReached()
EndFunction
Function OnLockJammed() ;called when device lock is jammed
    parent.OnLockJammed()
EndFunction
Function OnDeviceUnlockedWithKey() ;called when device is unlocked with key
    parent.OnDeviceUnlockedWithKey()
EndFunction
Function OnUpdatePre(float timePassed) ;called on update. Is only called if wearer is registered
    parent.OnUpdatePre(timePassed)
EndFunction
Function OnUpdatePost(float timePassed) ;called on update. Is only called if wearer is registered
    parent.OnUpdatePost(timePassed)
EndFunction
bool Function OnCooldownActivatePre()
    return parent.OnCooldownActivatePre()
EndFunction
Function OnCooldownActivatePost()
    parent.OnCooldownActivatePost()
EndFunction
Function DeviceMenuExt(int msgChoice)
    parent.DeviceMenuExt(msgChoice)
EndFunction
Function DeviceMenuExtWH(int msgChoice)
    parent.DeviceMenuExtWH(msgChoice)
EndFunction
bool Function OnUpdateHourPre()
    return parent.OnUpdateHourPre()
EndFunction
bool Function OnUpdateHourPost()
    return parent.OnUpdateHourPost()
EndFunction
Function InitPostPost()
    parent.InitPostPost()
EndFunction
Function OnRemoveDevicePre(Actor akActor)
    parent.OnRemoveDevicePre(akActor)
EndFunction
Function onLockUnlocked(bool lockpick = false)
    parent.onLockUnlocked(lockpick)
EndFunction
Function onSpecialButtonPressed(float fMult)
    parent.onSpecialButtonPressed(fMult)
EndFunction
Function onSpecialButtonReleased(Float fHoldTime)
    parent.onSpecialButtonReleased(fHoldTime)
EndFunction
bool Function onWeaponHitPre(Weapon source)
    return parent.onWeaponHitPre(source)
EndFunction
Function onWeaponHitPost(Weapon source)
    parent.onWeaponHitPost(source)
EndFunction
bool Function onSpellHitPre(Spell source)
    return parent.onSpellHitPre(source)
EndFunction
Function onSpellHitPost(Spell source)
    parent.onSpellHitPost(source)
EndFunction
Function updateWidgetColor()
    parent.updateWidgetColor()
EndFunction
int Function getArousalRate()
    return parent.getArousalRate()
EndFunction
float Function getStruggleOrgasmRate()
    return parent.getStruggleOrgasmRate()
EndFunction
Float[] Function GetCurrentMinigameExpression()
	return parent.GetCurrentMinigameExpression()
EndFunction