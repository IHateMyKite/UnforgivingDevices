Scriptname UD_CustomArmCuffs_RenderScript extends UD_CustomDynamicHeavyBondage_RS

Function InitPost()
    parent.InitPost()
    UD_DeviceType = "Arm cuffs"
    UD_ActiveEffectName = "Tie up - Arms"
EndFunction

string Function addInfoString(string str = "")
    return parent.addInfoString(str)
EndFunction

bool Function CanTie()
    return UDCDMain.UD_AllowArmTie && WearerFreeHands()
EndFunction

Function OnTiedUp()
    UDCDmain.AddInvisibleArmbinder(GetWearer())
EndFunction

Function OnUntied()
    UDCDmain.RemoveInvisibleArmbinder(GetWearer())
EndFunction

float Function getAccesibility()
    if IsTiedUp()
        return 1.0
    else
        return parent.getAccesibility()
    endif
EndFunction

bool Function OnCooldownActivatePre()
    if UDCDMain.UD_AllowArmTie && isSentient()
        return parent.OnCooldownActivatePre()
    else
        return false
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
bool Function onWeaponHitPre(Weapon source, Float afDamage = -1.0)
    return parent.onWeaponHitPre(source, afDamage)
EndFunction
Function onWeaponHitPost(Weapon source, Float afDamage = -1.0)
    parent.onWeaponHitPost(source, afDamage)
EndFunction
bool Function onSpellHitPre(Form source, Float afDamage = -1.0)
    return parent.onSpellHitPre(source, afDamage)
EndFunction
Function onSpellHitPost(Form source, Float afDamage = -1.0)
    parent.onSpellHitPost(source, afDamage)
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
Float[] Function GetCurrentMinigameExpression()
	return parent.GetCurrentMinigameExpression()
EndFunction
bool Function canBeActivated()
    return parent.canBeActivated()
EndFunction