Scriptname UD_CustomBra_RenderScript extends UD_CustomDevice_RenderScript  

Function InitPost()
    UD_DeviceType = "Chastity bra"
    UD_ActiveEffectName = "Activate Nipple Piercings"
EndFunction

Function patchDevice()
    UDCDmain.UDPatcher.patchBra(self)
EndFunction

bool Function canBeActivated()
    ;/
    int loc_num = UDCDmain.getNumberOfActivableDevicesWithKeyword(getWearer(),libs.zad_DeviousPiercingsNipple)
    if loc_num > 0
        return true
    endif
    return false
    /;
    if getWearer().wornhaskeyword(libs.zad_DeviousPiercingsNipple) && getRelativeElapsedCooldownTime() >= 0.1
        int loc_num = UDCDmain.getNumberOfActivableDevicesWithKeyword(getWearer(),false,libs.zad_DeviousPiercingsNipple)
        if loc_num > 0
            return true
        endif
        return false
    else
        return false
    endif
EndFunction

Function activateDevice()
    int loc_num = UDCDmain.getNumberOfActivableDevicesWithKeyword(getWearer(),false,libs.zad_DeviousPiercingsNipple)
    if loc_num > 0
        UD_CustomDevice_RenderScript[] loc_piercings_arr = UDCDmain.getAllActivableDevicesByKeyword(getWearer(),false,libs.zad_DeviousPiercingsNipple)
        UD_CustomDevice_RenderScript loc_piercings = loc_piercings_arr[Utility.randomInt(0,loc_piercings_arr.length - 1)]

        if (loc_piercings as UD_CustomVibratorBase_RenderScript)
            UD_CustomVibratorBase_RenderScript loc_vibrator = loc_piercings as UD_CustomVibratorBase_RenderScript
            if WearerIsPlayer() && (!loc_vibrator.canVibrate() || !UDMain.UDWC.UD_FilterVibNotifications)
                UDCDmain.Print(getDeviceName() + " activates your nipple piercings!")
            elseif UDmain.ActorInCloseRange(getWearer())
                UDCDmain.Print(getWearerName() + "s "+ getDeviceName() +" activates their nipple piercings!")
            endif
            if loc_vibrator.canVibrate()
                if !loc_vibrator.isVibrating()
                    loc_vibrator.ForceModDuration(1.5)
                    loc_vibrator.ForceModStrength(1.5)
                    loc_vibrator.activateDevice()
                    ;UDCDmain.startVibFunction(self,true)
                else
                    loc_vibrator.addVibDuration(30)
                    loc_vibrator.addVibStrength(25)
                endif
            else
                loc_piercings.activateDevice()
            endif
        endif

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
Function OnOrgasmPost(bool sexlab = false) ;called on wearer orgasm. Is only called if OnOrgasmPre returns true. Is only called if wearer is registered
    parent.OnOrgasmPost(sexlab)
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
Function onDeviceMenuInitPost(bool[] aControl)
    parent.onDeviceMenuInitPost(aControl)
EndFunction
Function onDeviceMenuInitPostWH(bool[] aControl)
    parent.onDeviceMenuInitPostWH(aControl)
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
string Function addInfoString(string str = "")
    return parent.addInfoString(str)
EndFunction
Function updateWidget(bool force = false)
    parent.updateWidget(force)
EndFunction
Function updateWidgetColor()
    parent.updateWidgetColor()
EndFunction
Float[] Function GetCurrentMinigameExpression()
	return parent.GetCurrentMinigameExpression()
EndFunction