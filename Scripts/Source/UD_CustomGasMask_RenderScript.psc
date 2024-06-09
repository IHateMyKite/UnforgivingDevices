Scriptname UD_CustomGasMask_RenderScript extends UD_CustomBPDevice_RenderScript

Function InitPost()
	parent.InitPost()
	UD_DeviceType = "Gas Mask"
EndFunction

;======================================================================
;Place new override functions here, do not forget to check override functions in parent if its not base script (UD_CustomDevice_RenderScript)
;Function OnVibStart(int blablabla)
;EndFunction
;======================================================================

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
Function onSpecialButtonPressed(Float afMult)
	parent.onSpecialButtonPressed(afMult)
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
string Function addInfoString(string str = "")
	return parent.addInfoString(str)
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