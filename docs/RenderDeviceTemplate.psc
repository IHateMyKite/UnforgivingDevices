;/  File: RenderDeviceTemplate
    This template should be always used when creating new device type.
    
    Do not forget to replace *DEVICE SCRIPT NAME* and *PARENT SCRIPT NAME* with valid script name
/;
Scriptname ;/DEVICE SCRIPT NAME/; extends ;/PARENT SCRIPT NAME/;  

import UnforgivingDevicesMain

;/  Group: Required
These functions should always be edited
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: InitPost
    This function is called only once when device is locked on actor.
    
    Wearer is already set at that point, and can be returned with GetWearer() function
    
    Example:
    ---Code
    Function InitPost()
        ; calls parent script first, so it doesn't overwritte our changes.
        parent.InitPost()
        
        ; New type of out device. This is not name! Only type. So if you would for example add some new kind of armbinder, you will name the new type for example "New Armbinder"
        UD_DeviceType = "New device type"
        
        ; lets say that our new device will have no custom active effect.
        ; In that case it should be changed to "Share", or it can be ommited as default value is "Share"
        ; But it is possible that parent script did change the active effect, so it is still better to just change it to "Share"
        UD_ActiveEffectName = "Share"
    EndFunction
    ---
/;
Function InitPost()
    parent.InitPost()
    UD_DeviceType = "Device type"
    UD_ActiveEffectName = "Active effect name"
EndFunction

;======================================================================
;Place new override functions here, do not forget to check override functions in parent if its not base script (UD_CustomDevice_RenderScript)
;Function OnVibStart(int blablabla)
;EndFunction
;======================================================================

;============================================================================================================================

;============================================================================================================================

;/  Group: Override
    These function are optional and don't need to be edited.
    Unused override function, theese are from base script. Extending different script means you also have to add their overrride functions
    Theese function should be on every object instance, as not having them may cause multiple function calls to default class
    More about reason here https://www.creationkit.com/index.php?title=Function_Reference, and Notes on using Parent section
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Function: safeCheck
    Called on init before <InitPost>.
    
    Should be used to check if some properties are not filled, and fill them.
    
    Example:
    ---Code
    
    import UnforgivingDevicesMain
    
    Function safeCheck()
        ;check if UD_MessageDeviceInteraction is already filled, and if not, fill it with out property
        ;Note that this can easily be done with Creation Kit or xEdit, but this approach might be fatser, and in some cases even safer
        if !UD_MessageDeviceInteraction
            UD_MessageDeviceInteraction = GetMeMyForm(0x123456789,"MyMod.esp") as Message
        endif
    EndFunction
    ---
/;
Function safeCheck()
    parent.safeCheck()
EndFunction

;/  Function: patchDevice
    Called on init before <safeCheck>.
    
    This functions is only called if device is patched (have UD_PatchedDevice keyword)!
    
    Used in case that custom patching is required.
    For example if the new device adds some new variable, and we want it be set to random value and weighted with actor level.
    
    In case you don't intend for device to be avaible by xEdit patcher, you can keep this function in default implementation
    
    Example:
    ---Code
    
    import UnforgivingDevicesMain
    
    ;Our new device have effect. Its duration is set by UD_NewEffectDuration
    Float Property UD_NewEffectDuration auto
    
    Function patchDevice()
        ;patch all parent values first
        parent.patchDevice()
        
        ;set our effect duration to 5 x device level
        UD_NewEffectDuration = UD_Level*5
    EndFunction
    ---
/;
Function patchDevice()
    parent.patchDevice()
EndFunction

;/  Function: activateDevice
    Called when device is activated
    
    Is only called if <UD_ActiveEffectName> is not "Share"
    
    Should always call parent script, to prevent unintended behaviour

    Example:
    ---Code
    Function activateDevice()
        ;shock actor when device is activated
        ShockWearer(25,25,false)
        
        ;activate parent device, but only after our device is activated
        parent.activateDevice()
    EndFunction
    ---
    
    See <ShockWearer>
/;
Function activateDevice() ;Device custom activate effect. You need to create it yourself. Don't forget to remove parent.activateDevice() if you don't want parent effect
    parent.activateDevice()
EndFunction

;/  Function: canBeActivated
    Called when device activate effect is checked
    
    Editing this method allows to create custom condition for activating device
    
    Only if it returns true will device be activated
    
    Should always call parent script, to prevent unintended behaviour

    Example:
    ---Code
    bool Function canBeActivated()
        ;device will only activate if wearer wears mittens
        return parent.canBeActivated() && WearerHaveMittens()
    EndFunction
    ---
    
    See <WearerHaveMittens>
/;
bool Function canBeActivated()
    return parent.canBeActivated()
EndFunction

;/  Function: OnMendPre
    Called when device is about to be mended
    
    Editing this method allows to create custom condition for mending device
    
    Only if it returns true will device be activated
    
    Should always call parent script, to prevent unintended behaviour
    
    Parameters:
        
        afMult - Mend multiplier
        
    Example:
    ---Code
    bool Function OnMendPre(float afMult)
        ;device will repair itself only if wearer arousal is less then 80
        return parent.OnMendPre(afMult) && (UDmaim.UDOM.getArousal(GetWearer()) < 80)
    EndFunction
    ---
    
    See <UD_OrgasmManager>, <getArousal>
/;
bool Function OnMendPre(float afMult) ;called on device mend (regain durability)
    return parent.OnMendPre(afMult)
EndFunction

;/  Function: OnMendPost
    Called after device is mended. Only called if OnMendPre returns true
    
    Editing this method allows to create additional effect when device will repair itself
    
    Should always call parent script, to prevent unintended behaviour
    
    Parameters:
        
        afAmount - By how much was device mended
    
    Example:
    ---Code
    Function OnMendPost(float afAmount)
        ;reduce wearer magicka by 10 x Repaired durability
        GetWearer().DamageAV("Magicka",afAmount*10)
        
        ;call it on parent script
        parent.OnMendPost(afAmount)
    EndFunction
    ---
/;
Function OnMendPost(float afAmount)
    parent.OnMendPost(afAmount)
EndFunction

;/  Function: OnCritDevicePre
    Called before minigame crit is applied.
    
    Editing this method allows to create custom condition for crit behavier
    
    If this function returns false, critting device will have no effect
    
    Should always call parent script, to prevent unintended behaviour
    
    Example:
    ---Code
    bool Function OnCritDevicePre()
        ;crits will have no effect if device have less then 50% durability left
        return parent.OnCritDevicePre() && getRelativeDurability() >= 0.5
    EndFunction
    ---
    
    See: <getRelativeDurability>
/;
bool Function OnCritDevicePre()
    return parent.OnCritDevicePre()
EndFunction

;/  Function: OnCritDevicePost
    Called after crit when <OnCritDevicePre> returns true
    
    Editing this method allows to create custom effect when wearer crits device
    
    Should always call parent script, to prevent unintended behaviour
    
    Example:
    ---Code
    Function OnCritDevicePost()
        ;if minigame have helper, steal 5 gold from them on every crit
        if HaveHelper()
            GetWearer().AddItem(UDmain.UDlibs.Gold,5)
            GetHelper().RemoveItem(UDmain.UDlibs.Gold,5)
        endif
        
        ;call parent script
        parent.OnCritDevicePost()
    EndFunction
    ---
    
    See: <UDlibs>
/;
Function OnCritDevicePost()
    parent.OnCritDevicePost()
EndFunction

;/  Function: OnOrgasmPre
    Called before most override orgasm functions.
    
    Editing this method allows to create custom condition for custom orgasm behaviour
    
    If it returns false, following overrides will be disabled
    
    * <OnMinigameOrgasm>
    * <OnMinigameOrgasmPost>
    * <OnOrgasmPost>
    
    Should always call parent script, to prevent unintended behaviour
    
    *This function will only be called if wearer is registered*
    
    Parameters:
        
        abSexlab - If orgasm is caused by sexlab animation
/;
bool Function OnOrgasmPre(bool abSexlab = false)
    return parent.OnOrgasmPre(abSexlab)
EndFunction

;/  Function: OnMinigameOrgasm
    Called after function <OnOrgasmPre> when wearer is in minigame
    
    Editing this method allows to create custom orgasm effect caused by device
    
    Should always call parent script, to prevent unintended behaviour
    
    *This function will only be called if wearer is registered*
    
    Parameters:
        
        abSexlab - If orgasm is caused by sexlab animation
        
    Example:
    ---Code
    Function OnMinigameOrgasm(bool abSexlab = false)
        ;shock helper if its present
        if haveHelper()
            ShockHelper(-15,50,true)
        endif
        
        parent.OnMinigameOrgasm(abSexlab)
    EndFunction
    ---
    
    See: <ShockHelper>
/;
Function OnMinigameOrgasm(bool abSexlab = false)
    parent.OnMinigameOrgasm(abSexlab)
EndFunction

;/  Function: OnMinigameOrgasmPost
    Same as <OnMinigameOrgasm>, but called after it
    
    Editing this method allows to create custom orgasm effect caused by device
    
    Should always call parent script, to prevent unintended behaviour
    
    *This function will only be called if wearer is registered*
/;
Function OnMinigameOrgasmPost()
    parent.OnMinigameOrgasmPost()
EndFunction

;/  Function: OnOrgasmPost
    Called after function <OnOrgasmPre>
    
    Editing this method allows to create custom orgasm effect caused by device
    
    Should always call parent script, to prevent unintended behaviour
    
    *This function will only be called if wearer is registered*
    
    Parameters:
        
        abSexlab - If orgasm is caused by sexlab animation
        
    Example:
    ---Code
    Function OnOrgasmPost(bool abSexlab = false)
        ;reduce durability by 15, and do not change condition
        decreaseDurabilityAndCheckUnlock(15.0,0.0,false)
        
        ;only call parent device if device didn't get unlocked by decreaseDurabilityAndCheckUnlock call
        if !IsUnlocked
            parent.OnOrgasmPost(abSexlab)
        endif
    EndFunction
    ---
    
    See: <decreaseDurabilityAndCheckUnlock>
/;
Function OnOrgasmPost(bool abSexlab = false)
    parent.OnOrgasmPost(abSexlab)
EndFunction

;/  Function: OnMinigameStart
    Called when minigame starts
    
    Editing this method allows to create custom effect on minigame start
    
    Should always call parent script, to prevent unintended behaviour
/;
Function OnMinigameStart() ;called when minigame start
    parent.OnMinigameStart()
EndFunction

;/  Function: OnMinigameEnd
    Called when minigame ends
    
    Editing this method allows to create custom effect on minigame end
    
    Should always call parent script, to prevent unintended behaviour
/;
Function OnMinigameEnd() ;called when minigame end
    parent.OnMinigameEnd()
EndFunction

;/  Function: OnMinigameTick
    Called on every minigame tick
    
    Editing this method allows to create custom minigame behaviour.
    
    Should always call parent script, to prevent unintended behaviour
    
    Parameters:
        
        abUpdateTime - Update time of one tick
/;
Function OnMinigameTick(Float abUpdateTime)
    parent.OnMinigameTick(abUpdateTime)
EndFunction

;/  Function: OnMinigameTick1
    Called every second while in minigame
    
    Editing this method allows to create custom minigame behaviour.
    
    Should always call parent script, to prevent unintended behaviour
/;
Function OnMinigameTick1() ;called every 1s of minigame
    parent.OnMinigameTick1()
EndFunction

;/  Function: OnMinigameTick3
    Called every three seconds while in minigame
    
    Editing this method allows to create custom minigame behaviour.
    
    Should always call parent script, to prevent unintended behaviour
/;
Function OnMinigameTick3() ;called every 3s of minigame
    parent.OnMinigameTick3()
EndFunction

;/  Function: OnCritFailure
    Called when wearer fails to crit the device (either by pressing wrong button, or by beng too slow if mandatory crit setting is enabled)
    
    Editing this method allows to create custom minigame punishment for wearer when they fail to crit the device
    
    Should always call parent script, to prevent unintended behaviour
/;
Function OnCritFailure()
    parent.OnCritFailure()
EndFunction

;/  Function: getAccesibility
    Returns accessibility of device. Overriring it allows to create custom calculation of device accessibility
    
    Should always call parent script, to prevent unintended behaviour
    
    Returning value always have to be validated with function ValidateAccessibility !
    
    Example:
    ---Code
    float Function getAccesibility()
        float loc_res = parent.getAccesibility()
        
        ;only reduce accessibility if its not zero
        if loc_res
            ;if wearer wears leg cuffs, reduce accessibility by 75%
            if getWearer().wornhaskeyword(libs.zad_DeviousLegCuffs)
                loc_res *= 0.75
            endif
        endif
        
        ;returns accessbility. Should always call ValidateAccessibility!!
        return ValidateAccessibility(loc_res)
    EndFunction
    ---
/;
float Function getAccesibility() ;return accesibility of device in range 0.0 - 1.0
    return parent.getAccesibility()
EndFunction

;/  Function: OnDeviceCutted
    Called when device is succesfully cut in cutting minigame
    
    Editing this function allows to create custom effect when device is cut
    
    Should always call parent script, to prevent unintended behaviour
/;
Function OnDeviceCutted()
    parent.OnDeviceCutted()
EndFunction

;/  Function: OnDeviceLockpicked
    Called when device is succesfully lockpicked in lockpicking minigame
    
    Editing this function allows to create custom effect when device is lockpicked
    
    Should always call parent script, to prevent unintended behaviour
/;
Function OnDeviceLockpicked() ;called when device is lockpicked
    parent.OnDeviceLockpicked()
EndFunction

;/  Function: OnLockReached
    *!!NO LONGER USED!!*
/;
Function OnLockReached() ;called when device lock is reached
    parent.OnLockReached()
EndFunction

;/  Function: OnLockJammed
    Called when devices lock is jammed
    
    Editing this function allows to create custom effect when lock is jammed
    
    Should always call parent script, to prevent unintended behaviour
/;
Function OnLockJammed() ;called when device lock is jammed
    parent.OnLockJammed()
EndFunction

;/  Function: OnDeviceUnlockedWithKey
    Called if last lock is unlocked with key
    
    Editing this function allows to create custom effect when last lock is unlocked with key
    
    Should always call parent script, to prevent unintended behaviour
/;
Function OnDeviceUnlockedWithKey() ;called when device is unlocked with key
    parent.OnDeviceUnlockedWithKey()
EndFunction

;/  Function: OnUpdatePre
    Called at start of update function
    
    Editing this function allows to create custom behaviour when updating device
    
    Should always call parent script, to prevent unintended behaviour
    
    *This function will only be called if wearer is registered*
    
    Parameters:
        
        afTimePassed - Time passed from last update call. This value is in days
/;
Function OnUpdatePre(float afTimePassed)
    parent.OnUpdatePre(afTimePassed)
EndFunction

;/  Function: OnUpdatePre
    Called at the end of update function
    
    Editing this function allows to create custom behaviour when updating device
    
    Should always call parent script, to prevent unintended behaviour
    
    *This function will only be called if wearer is registered*
    
    Parameters:
        
        afTimePassed - Time passed from last update call. This value is in days
    
    Example:
    ---Code
    
    Float _UsedOrgasmRate = 0.0
    
    Function OnUpdatePost(float afTimePassed))
        ;convert days to minutes
        Float loc_minutes = afTimePassed*24*60
        
        ;remove previous orgasm rate
        if _UsedOrgasmRate
            UDmain.UDOM.UpdateOrgasmRate(GetWearer(),-1*_UsedOrgasmRate,-0.25)
        endif
        
        ;increa orgasm rate by 50% of minutes passed
        _UsedOrgasmRate = loc_minutes*0.5
        UDmain.UDOM.UpdateOrgasmRate(GetWearer(),_UsedOrgasmRate,0.25)
        
        parent.OnUpdatePost(afTimePassed)
    EndFunction
    
    Function onRemoveDevicePost(Actor akActor)
        ;remove orgasm rate if it was applied
        if _UsedOrgasmRate
            UDmain.UDOM.UpdateOrgasmRate(akActor,-1*_UsedOrgasmRate,-0.25)
        endif
        parent.onRemoveDevicePost(akActor)
    EndFunction
    ---
/;
Function OnUpdatePost(float afTimePassed))
    parent.OnUpdatePost(afTimePassed)
EndFunction

;/  Function: OnCooldownActivatePre
    Called after cooldown passes
    
    If this returns false, no effect will be activated
    
    Editing this function allows to create custom condition for cooldown activation
    
    Should always call parent script, to prevent unintended behaviour
    
    *This function will only be called if wearer is registered*
/;
bool Function OnCooldownActivatePre()
    return parent.OnCooldownActivatePre()
EndFunction

;/  Function: OnCooldownActivatePost
    Called after device is activtaed by cooldown.
    
    Will be not called if <OnCooldownActivatePre> return false
    
    Editing this function allows to create custom behaviour on cooldown activation
    
    Should always call parent script, to prevent unintended behaviour
    
    *This function will only be called if wearer is registered*
/;
Function OnCooldownActivatePost()
    parent.OnCooldownActivatePost()
EndFunction

;/  Function: OnUpdateHourPre
    Called after hourly update
    
    If this returns false, update will be skipped
    
    Editing this function allows to create custom condition for hourly update
    
    Should always call parent script, to prevent unintended behaviour
    
    *This function will only be called if wearer is registered*
/;
bool Function OnUpdateHourPre()
    return parent.OnUpdateHourPre()
EndFunction

;/  Function: OnUpdateHourPost
    Called after <OnUpdateHourPre> if it returns true
    
    Editing this function allows to create custom behaviour for hourly update
    
    *Return value is unused*
    
    Should always call parent script, to prevent unintended behaviour
    
    *This function will only be called if wearer is registered*
/;
bool Function OnUpdateHourPost()
    return parent.OnUpdateHourPost()
EndFunction

;/  Function: onDeviceMenuInitPost
    Called before <DeviceMenu> is called
    
    Editing this function allows to create custom condition for some of the menu options
    
    Should always call parent script, to prevent unintended behaviour
    
    Parameters:
        
        aaControl - <Control Array>
        
    Example:
    ---Code
    Function onDeviceMenuInitPost(bool[] aaControl)
        ;call parent script
        parent.onDeviceMenuInitPost(aaControl)
        
        ;disable struggling and useless struggling option forever
        aaControl[0] = True
        aaControl[1] = True
    EndFunction
    
    ;do samething for helper menu
    Function onDeviceMenuInitPostWH(bool[] aaControl)
        parent.onDeviceMenuInitPostWH(aaControl)
        aaControl[0] = True
        aaControl[1] = True
    EndFunction
    ---
/;
Function onDeviceMenuInitPost(bool[] aaControl)
    parent.onDeviceMenuInitPost(aaControl)
EndFunction

;/  Function: onDeviceMenuInitPost
    Same as <onDeviceMenuInitPost>, but called before <DeviceMenuWH> is called
/;
Function onDeviceMenuInitPostWH(bool[] aaControl)
    parent.onDeviceMenuInitPostWH(aaControl)
EndFunction

;/  Function: DeviceMenuExt
    Is called at the ned of <DeviceMenu>
    
    Editing this function allows to add new options to device menu
    
    Should always call parent script, to prevent unintended behaviour
    
    Example:
    ---Code
    Function DeviceMenuExt(int aiMsgChoice)
        ;user selected option 5, which is new option for this device, process
        if aiMsgChoice == 5
            ;do somethin, open new menu, etc...
        else
            parent.DeviceMenuExt(aiMsgChoice)
        endif
    EndFunction
    ---
/;
Function DeviceMenuExt(int aiMsgChoice)
    parent.DeviceMenuExt(aiMsgChoice)
EndFunction

;/  Function: DeviceMenuExtWH
    Same as <DeviceMenuExt>, but only called when <DeviceMenuWH> is called
/;
Function DeviceMenuExtWH(int aiMsgChoice)
    parent.DeviceMenuExtWH(aiMsgChoice)
EndFunction

;/  Function: InitPostPost
    Called as absolutely last instruction of whole initialization chain.
    
    You can use this for some resource heavy processon, or even add infinite loop there.
    
    Should always call parent script, to prevent unintended behaviour
/;
Function InitPostPost()
    parent.InitPostPost()
EndFunction

;/  Function: OnRemoveDevicePre
    Called on start of device removal
    
    Editing this function allows to create custom behaviour when device is unlocked
    
    Should always call parent script, to prevent unintended behaviour
/;
Function OnRemoveDevicePre(Actor akActor)
    parent.OnRemoveDevicePre(akActor)
EndFunction

;/  Function: onRemoveDevicePost
    Called on end of device removal
    
    Editing this function allows to create custom behaviour when device is unlocked
    
    Should always call parent script, to prevent unintended behaviour
/;
Function onRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
EndFunction

;/  Function: onLockUnlocked
    Called  when one of the locks was unlocked
    
    Editing this function allows to create custom behaviour when device lock is unlocked
    
    Should always call parent script, to prevent unintended behaviour
    
    Parameters:
        
        abLockpick - If lock was lockpicked
/;
Function onLockUnlocked(bool abLockpick = false)
    parent.onLockUnlocked(abLockpick)
EndFunction

;/  Function: onSpecialButtonPressed
    Called when special button is pressed while in minigame
    
    Editing this function allows to create custom behaviour for key presses while in minigame
    
    Should always call parent script, to prevent unintended behaviour
    
    Parameters:
        
        afMult - Multiplier
/;
Function onSpecialButtonPressed(Float afMult)
    parent.onSpecialButtonPressed(afMult)
EndFunction

;/  Function: onSpecialButtonReleased
    Called when special button is released while in minigame
    
    Editing this function allows to create custom behaviour for key releases while in minigame
    
    Should always call parent script, to prevent unintended behaviour
    
    Parameters:
        
        afHoldTime - How long was key pressed in seconds
/;
Function onSpecialButtonReleased(Float afHoldTime)
    parent.onSpecialButtonReleased(afHoldTime)
EndFunction

;/  Function: onWeaponHitPre
    Called when wearer is hit with weapon. Is used as filter.
    
    If it returns false, followup function will not be called
    
    Editing this function allows to create custom condition for hit
    
    Should always call parent script, to prevent unintended behaviour
    
    Parameters:
        
        akSource - Weapon which hit the wearer
/;
bool Function onWeaponHitPre(Weapon akSource)
    return parent.onWeaponHitPre(akSource)
EndFunction

;/  Function: onWeaponHitPost
    Called when wearer is hit with weapon.
    
    Is not called if <onWeaponHitPre> returns false
    
    Editing this function allows to create custom behaviour when wearer is hit
    
    Should always call parent script, to prevent unintended behaviour
    
    Parameters:
        
        akSource - Weapon which hit the wearer
/;
Function onWeaponHitPost(Weapon akSource)
    parent.onWeaponHitPost(akSource)
EndFunction

;/  Function: onSpellHitPre
    *!!UNUSED!!*
/;
bool Function onSpellHitPre(Spell akSource)
    return parent.onSpellHitPre(akSource)
EndFunction

;/  Function: onSpellHitPre
    *!!UNUSED!!*
/;
Function onSpellHitPost(Spell akSource)
    parent.onSpellHitPost(akSource)
EndFunction

;/  Function: addInfoString
    Is called when building info string.
    
    Can be used to provide additional information in device Base Details
    
    Should always call parent script, to prevent unintended behaviour
    
    Parameters:
        
        asInfo - String which will be appended to Base details
        
    Example:
    ---Code
    
    Int Property UD_SomeVariable = 50 auto
    
    string Function addInfoString(string asInfo = "")
        ;call parent script first and add it to passed string
        asInfo += parent.addInfoString(asInfo)
        
        ;add our own information
        asInfo += "Some Variable: " + UD_SomeVariable + "\n"
        
        ;return final string
        return asInfo
    EndFunction
    ---
/;
string Function addInfoString(string asInfo = "")
    return parent.addInfoString(asInfo)
EndFunction

;/  Function: updateWidget
    Called when widget is supposed to be updated
    
    Can be used to add additional hooks for widgets (meters/icons/etc...)
    
    Should always call parent script, to prevent unintended behaviour
    
    Parameters:
        
        abForce - if update should be forced
        
    Example:
    ---Code
        Bool _CustomMinigameOn = False
        
        Function updateWidget(bool abForce = false)
            if _CustomMinigameOn
                setWidgetVal(SomeVariableOrFunctionWhichControlsWidget,abForce)
            else
                parent.updateWidget(abForce)
            endif
        EndFunction
    ---
/;
Function updateWidget(bool abForce = false)
    parent.updateWidget(abForce)
EndFunction

;/  Function: updateWidgetColor
    Called when widgets color is supposed to be updated
    
    Can be used to add additional hooks for widgets (meters/icons/etc...)
    
    Should always call parent script, to prevent unintended behaviour
/;
Function updateWidgetColor()
    parent.updateWidgetColor()
EndFunction

;/  Function: proccesSpecialMenu
    Called when user opens special menu and select the option
    
    Should be used to provide functionality to special menu options
    
    Parameters:
        
        aiMsgChoice - Choice selected
        
    ---Code
    bool Function proccesSpecialMenu(int aiMsgChoice)
        if aiMsgChoice == 2
            ;do something
        elseif aiMsgChoice == 3
            ;do something else
        else
            return parent.proccesSpecialMenu(aiMsgChoice)
        endif
        return aiMsgChoice
    EndFunction
    ---
/;
bool Function proccesSpecialMenu(int aiMsgChoice)
    return parent.proccesSpecialMenu(aiMsgChoice)
EndFunction

;/  Function: proccesSpecialMenuWH
    Called when user opens special menu with helper and select option
    
    Should be used to provide functionality to special menu options
    
    Parameters:
        
        akSource    - Current helper
        aiMsgChoice - Choice selected
        
    See: <proccesSpecialMenu>
/;
bool Function proccesSpecialMenuWH(Actor akSource,int aiMsgChoice)
    return parent.proccesSpecialMenuWH(akSource,aiMsgChoice)
EndFunction

;/  Function: getArousalRate
    Returns arousal rate which will be applied to wearer while in minigame. Is only called once per minigame
    
    Example:
        ---Code
         Bool _CustomMinigameOn = False
        
        int Function getArousalRate()
            if _CustomMinigameOn
                ;while user is in our CustomMinigame, arousal rate will be increased by 10
                return 10
            else
                return parent.getArousalRate()
            endif
        EndFunction
        ---
/;
int Function getArousalRate()
    return parent.getArousalRate()
EndFunction

;/  Function: getStruggleOrgasmRate
    Returns orgasm rate which will be applied to wearer while in minigame. Is only called once per minigame
    
    Example:
        ---Code
        Bool _CustomMinigameOn = False
        
        float Function getStruggleOrgasmRate()
            if _CustomMinigameOn
                ;while user is in our CustomMinigame, orgasm rate will be increased by 5.0
                return 5.0
            else
                return parent.getStruggleOrgasmRate()
            endif
        EndFunction
        ---
/;
float Function getStruggleOrgasmRate()
    return parent.getStruggleOrgasmRate()
EndFunction

;/  Function: GetCurrentMinigameExpression
    Returns expression which is will be applied in minigame. Is only called once when minigame begins
    
    Example:
        ---Code
        Bool _CustomMinigameOn = False
        
        Float[] Function GetCurrentMinigameExpression()
            if _CustomMinigameOn
                ;returns happy expression
                return UDmain.UDEM.GetPrebuildExpression_Happy1()
            else
                return parent.GetCurrentMinigameExpression()
            endif
        EndFunction
        ---
/;
Float[] Function GetCurrentMinigameExpression()
    return parent.GetCurrentMinigameExpression()
EndFunction