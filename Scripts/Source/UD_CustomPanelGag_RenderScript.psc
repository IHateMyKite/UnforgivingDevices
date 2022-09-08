Scriptname UD_CustomPanelGag_RenderScript extends UD_CustomGag_RenderScript  

float Property UD_RemovePlugDifficulty = 100.0 auto
;MiscObject Property UD_GagPanelPlug Auto

Function InitPost()
    UD_ActiveEffectName = "Add Plug"
    UD_DeviceType = "Panel Gag"
EndFunction

string Function addInfoString(string str = "")
    ;string res = str
    str += "Plugged: "
    if isPlugged()
        str += "YES\n"
        if !wearerFreeHands(True) 
        endif
    else
        str += "NO\n"
    endif
    
    return parent.addInfoString(str)
EndFunction

Function safeCheck()
    if !UD_SpecialMenuInteraction
        UD_SpecialMenuInteraction = UDCDmain.DefaultPanelGagSpecialMsg
    endif
    if !UD_SpecialMenuInteractionWH
        UD_SpecialMenuInteractionWH = UDCDmain.DefaultPanelGagSpecialMsg
    endif
    parent.safeCheck()
EndFunction

Function onDeviceMenuInitPost(bool[] aControlFilter)
    parent.onDeviceMenuInitPost(aControlFilter)
    
    if wearerFreeHands() && !isPlugged()
        UDCDmain.currentDeviceMenu_switch1 = True
    endif
    if isPlugged()
        UDCDmain.currentDeviceMenu_switch2 = True
    endif
    UDCDmain.currentDeviceMenu_allowSpecialMenu = True
EndFunction

Function onDeviceMenuInitPostWH(bool[] aControlFilter)
    parent.onDeviceMenuInitPostWH(aControlFilter)
    
    if (wearerFreeHands() || helperFreeHands()) && !isPlugged()
        UDCDmain.currentDeviceMenu_switch1 = True
    endif
    if isPlugged()
        UDCDmain.currentDeviceMenu_switch2 = True
    endif
    UDCDmain.currentDeviceMenu_allowSpecialMenu = True
EndFunction

bool Function proccesSpecialMenu(int msgChoice)
    bool res = parent.proccesSpecialMenu(msgChoice)
    if msgChoice == 0 ; Insert Plug
        plugGag()
        return false
    ElseIf msgChoice == 1 ; Remove Plug
        if wearerFreeHands(True)
            unplugGag()
            return true
        else
            return removePlugMinigame()
        endif
    EndIf
    return res
EndFunction

bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
    bool res = parent.proccesSpecialMenuWH(akSource,msgChoice)
    if msgChoice == 0 ; Insert Plug
        plugGag()
        return false
    ElseIf msgChoice == 1 ; Remove Plug
        if wearerFreeHands(True) || helperFreeHands(True)
            unplugGag()
            return true
        else
            return removePlugMinigame()
        endif
    EndIf
    return res
EndFunction

bool removePlugMinigame_on = False
bool Function removePlugMinigame()
    if !minigamePrecheck()
        return false
    endif
    
    resetMinigameValues()
    
    setMinigameOffensiveVar(False,0.0,0.0,True)
    setMinigameWearerVar(True,UD_base_stat_drain*0.8)
    setMinigameEffectVar(True,True,1.0)
    setMinigameWidgetVar(True,False,0xc5f513,0x8df513)
    setMinigameMinStats(0.7)
    
    float mult = 1.0
    if hasHelper()
        setMinigameHelperVar(True,UD_base_stat_drain*0.8)
        setMinigameEffectHelperVar(True,True,1.2)    
        mult += 0.25
        if HelperFreeHands(True,True)
            mult += 0.15
        endif
    endif
    setMinigameMult(1,mult)
    
    if minigamePostCheck()
        removePlugMinigame_on = True
        minigame()
        removePlugMinigame_on = False
        return true
    else
        return false
    endif
EndFunction

float removePlugProgress = 0.0
Function OnMinigameTick(Float abUpdateTime)
    if removePlugMinigame_on
        removePlugProgress += Utility.randomFloat(1.5,6.0)*UDCDmain.getStruggleDifficultyModifier()*abUpdateTime*getMinigameMult(1)
        if removePlugProgress > UD_RemovePlugDifficulty
            stopMinigame()
            removePlug()
            removePlugMinigame_on = False
        endif
    endif
    parent.OnMinigameTick(abUpdateTime)
EndFunction

bool Function OnCritDevicePre()
    if removePlugMinigame_on
        removePlugProgress += Utility.randomFloat(5.0,10.0)*UDCDmain.getStruggleDifficultyModifier()*getMinigameMult(1)
        if removePlugProgress > UD_RemovePlugDifficulty
            stopMinigame()
            removePlug()
            removePlugMinigame_on = False
        endif
        Return True
    else
        return parent.OnCritDevicePre()
    endif
EndFunction

Function OnCritFailure()
    if removePlugMinigame_on
        removePlugProgress -= 5.0
        if removePlugProgress < 0
            removePlugProgress = 0.0
        endif
    endif
    parent.OnCritFailure()
EndFunction

Function plugGag(bool silent = false)
    libs.PlugPanelgag(getWearer())
    if !silent
        if hasHelper()
            if WearerIsPlayer()
                UDmain.Print(getHelperName() +" inserted plug in to yours " + getDeviceName() + "!",1)
            elseif WearerIsFollower() && HelperIsPlayer()
                UDmain.Print("You inserted the plug in "+getWearerName()+"s "+ getDeviceName(),1)
            elseif WearerIsFollower()
                UDmain.Print(getHelperName() + " inserted plug in to the "+getWearerName()+"s "+ getDeviceName(),1)
            endif
        else
            if WearerIsPlayer()
                UDmain.Print("You insert the plug in to the panel gag",1)
            elseif WearerIsFollower()
                UDmain.Print(getWearerName()+" inserts the plug in to the "+ getDeviceName(),1)
            endif
        endif
    endif
    resetCooldown(1.0)
    removePlugProgress = 0.0
EndFunction

Function unplugGag(bool silent = false)
    libs.UnPlugPanelGag(getWearer())
    if !silent
        if hasHelper()
            if WearerIsPlayer()
                UDmain.Print("With " + getHelperName() +"s help you managed to remove the plug from the panel gag.",1)
            elseif WearerIsFollower() && HelperIsPlayer()
                UDmain.Print("You helped  "+getWearerName()+" to remove the plug from the "+ getDeviceName(),1)
            elseif WearerIsFollower()
                UDmain.Print(getHelperName() + " helped "+getWearerName()+" to remove the plug from the "+ getDeviceName(),1)
            endif
        else
            if WearerIsPlayer()
                UDmain.Print("You removed the plug from the "+ getDeviceName() +"!",1)
            elseif WearerIsFollower()
                UDmain.Print(getWearerName()+" removed the plug from the "+ getDeviceName(),1)
            endif
        endif
    endif
    resetCooldown(1.0)
EndFunction

Function addPlug()
    plugGag(True)
EndFunction

Function removePlug()
    unplugGag()
EndFunction

bool Function isPlugged()
    if getWearer().GetFactionRank(UDCDmain.zadGagPanelFaction)
        return True
    else
        return False
    endif
EndFunction

bool Function canBeActivated()
    return !isPlugged()
EndFunction

Function activateDevice()
    if WearerIsPlayer()
        UDmain.Print("Your panel gag plugs itself!",1)
    elseif WearerIsFollower()
        UDmain.Print(getWearerName() + "s " + getDeviceName()+" plugs itself!",2)        
    endif
    addPlug()
EndFunction

Function updateWidget(bool force = false)
    if removePlugMinigame_on
        setWidgetVal(removePlugProgress/UD_RemovePlugDifficulty,force)    
    else
        parent.updateWidget(force)
    endif
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
Function OnMinigameEnd() ;called when minigame end
    parent.OnMinigameEnd()
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