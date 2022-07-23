Scriptname UD_CustomChargPlug_RenderScript extends UD_CustomPlug_RenderScript  

import UnforgivingDevicesMain

Int     Property UD_MaxStrength            = 100         auto
Int     Property UD_MaxDuration         = 90        auto
Float     Property UD_MaxCharge             = 100.0     auto
Float     Property UD_ChargePerOrgasm     = 25.0         auto
Float     Property UD_ChargeArousalMult    = 0.05         auto
Int     Property UD_ChargeRewardNum        = 1         auto
Form     Property UD_ChargeRewardFull    = none        auto
Form     Property UD_ChargeRewardEmpty    = none        auto
Int        _BaseCooldown        = 0
Float     _currentCharge         = 0.0

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
    str += "Charge: " + Round(getRelativeCharge()*100) + "% ("+Round(_currentCharge)+"/"+Round(UD_MaxCharge)+")" + "\n"
    return parent.addInfoString(str)
EndFunction

float Function getRelativeCharge()
    return _currentCharge/UD_MaxCharge
EndFunction

Function OnOrgasmPost(bool sexlab = false)
    parent.OnOrgasmPost(sexlab)
    stopVibrating() ;stop vibrating to prevent soft lock
    resetCooldown()
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
    UD_VibStrength     = Round(fRange(UD_MaxStrength*getRelativeCharge()    ,UD_MaxStrength*0.25    ,UD_MaxStrength    ))
    UD_VibDuration     = Round(fRange(UD_MaxDuration*getRelativeCharge()    ,UD_MaxDuration*0.50    ,UD_MaxDuration    ))
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

;============================================================================================================================
;unused override function, theese are from base script. Extending different script means you also have to add their overrride functions                                                
;theese function should be on every object instance, as not having them may cause multiple function calls to default class
;more about reason here https://www.creationkit.com/index.php?title=Function_Reference, and Notes on using Parent section
;============================================================================================================================
Function safeCheck() ;called on init. Should be used to check if some properties are not filled, and fill them
    parent.safeCheck()
EndFunction
Function patchDevice() ;called on init. Should call patcher. Can also be dirrectly modified but should still use Patcher MCM variables
    parent.patchDevice()
EndFunction
Function activateDevice() ;Device custom activate effect. You need to create it yourself. Don't forget to remove parent.activateDevice() if you don't want parent effect
    parent.activateDevice()
EndFunction
bool Function canBeActivated() ;Switch. Used to determinate if device can be currently activated
    return parent.canBeActivated()
EndFunction
bool Function OnMendPre(float mult) ;called on device mend (regain durability)
    return parent.OnMendPre(mult)
EndFunction
Function OnMendPost(float mult) ;called on device mend (regain durability). Only called if OnMendPre returns true
    parent.OnMendPost(mult)
EndFunction
bool Function OnCritDevicePre() ;called on minigame crit
    return parent.OnCritDevicePre()
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
Function OnMinigameStart() ;called when minigame start
    parent.OnMinigameStart()
EndFunction
Function OnMinigameEnd() ;called when minigame end
    parent.OnMinigameEnd()
EndFunction
Function OnMinigameTick(Float abUpdateTime) ;called every on every tick of minigame. Uses MCM performance setting
    parent.OnMinigameTick(abUpdateTime)
EndFunction
Function OnMinigameTick1() ;called every 1s of minigame
    parent.OnMinigameTick1()
EndFunction
Function OnMinigameTick3() ;called every 3s of minigame
    parent.OnMinigameTick3()
EndFunction
Function OnCritFailure() ;called on crit failure (wrong key pressed)
    parent.OnCritFailure()
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
Function onRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
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
Function updateWidget(bool force = false)
    parent.updateWidget(force)
EndFunction
Function updateWidgetColor()
    parent.updateWidgetColor()
EndFunction
bool Function proccesSpecialMenu(int msgChoice)
    return parent.proccesSpecialMenu(msgChoice)
EndFunction
bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
    return parent.proccesSpecialMenuWH(akSource,msgChoice)
EndFunction
int Function getArousalRate()
    return parent.getArousalRate()
EndFunction
float Function getStruggleOrgasmRate()
    return parent.getStruggleOrgasmRate()
EndFunction