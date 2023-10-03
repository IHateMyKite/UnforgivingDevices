;   File: UD_CustomVibratorBase_RenderScript
;   This script works as base of all devices which can vibrate
;
;   As it is extending <UD_CustomDevice_RenderScript>, most functions and properties will behave same
Scriptname UD_CustomVibratorBase_RenderScript extends UD_CustomDevice_RenderScript  

import UnforgivingDevicesMain

;Properties

;/  Group: Vibration customization
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Variable: UD_VibDuration
    Vibration duration in seconds. Negative value means that vibrations will last forever, or untill the vibrator is turned off manually by script
/;
int     property     UD_VibDuration         = 60        auto ;duration of vibrations. -1 will make the vibrator vib forever (or until stopVibrating() is called)

;/  Variable: UD_VibStrength
    Strength of vibrator. The bigger this value is, the more will vibrator increase orgasm and arousal rate while turned on
    
    if set to -1, the value will be calculated from keyword
/;
int     Property     UD_VibStrength         = -1        auto

;/  Variable: UD_ArousalMult
    Arousal multiplier, multiplies arousal which is added while vibrator is turned on
/;
float   property     UD_ArousalMult         = 1.0       auto

;/  Variable: UD_OrgasmMult
    Orgasm multiplier, multiples orgasm rate which is applied
/;
float   property     UD_OrgasmMult          = 1.0       auto

;/  Variable: UD_EdgingMode
    * 0 - normal (no edging)
    * 1 - Edging only
    * 2 - Edging random
/;
int     Property     UD_EdgingMode          = -1        auto

;/  Variable: UD_EdgingThreshold
    How big orgasm progress needs to be for vibrator to stop vibrating if <UD_EdgingMode> is 1
/;
float   Property     UD_EdgingThreshold     = 0.75      auto

;/  Variable: UD_Shocking
    Vibrator will also shock actor when vibrate is called
    
    If it can't vibrate, shock will still happen
/;
bool    Property     UD_Shocking            = False     auto

;/  Variable: UD_Chaos
    Chance in percent that vibrator will change its strength and duration on every update
/;
int     Property     UD_Chaos               = 0         auto

;/  Variable: UD_VibSound
    Custom vibration sound that will start playing when vibration start
    
    If value is not filled, or none, the default DD vibration sound will be used
/;
Sound   Property     UD_VibSound                        auto

; Manual properties
String  _VibrationEffectSlot
String  Property     VibrationEffectSlot                        Hidden
    String Function Get()
        If _VibrationEffectSlot == ""
            If UD_DeviceKeyword == libs.zad_DeviousPlugVaginal
                _VibrationEffectSlot = "dd-plug-vaginal"
            ElseIf UD_DeviceKeyword == libs.zad_DeviousPlugAnal
                _VibrationEffectSlot = "dd-plug-anal"
            ElseIf UD_DeviceKeyword == libs.zad_DeviousPiercingsNipple
                _VibrationEffectSlot = "dd-piercing-nipples"
            ElseIf UD_DeviceKeyword == libs.zad_DeviousPiercingsVaginal
                _VibrationEffectSlot = "dd-piercing-clit"
            EndIf
        EndIf
        Return _VibrationEffectSlot
    EndFunction
EndProperty

Int _currentVibStrength = 0
Int     Property     CurrentVibStrength                          Hidden
    Int Function Get()
        Return _currentVibStrength
    EndFunction
    Function Set(Int aiValue)
        If aiValue < 0
            aiValue = 0
        ElseIf aiValue > 100
            aiValue = 100
        EndIf
        StorageUtil.AdjustIntValue(getWearer(), "UD_ActiveVib_Strength", (aiValue - _currentVibStrength))
        _currentVibStrength = aiValue
    EndFunction
EndProperty

;local variables
int     _currentVibRemainingDuration    =   0
int     _forceStrength                  =   -1
int     _forceDuration                  =   0
int     _currentEdgingMode              =   -1
int     _forceEdgingMode                =   -1
float   _appliedOrgasmRate              =   0.0
float   _appliedArousalRate             =   0.0
float   _appliedForcing                 =   0.0
int     _vsID                           =   -1           ;current sound ID used to play vib sounds
bool    _paused                         =   false        ;on if vibrator is paused

;/  Group: API
===========================================================================================
===========================================================================================
===========================================================================================
/;

Function InitPost()
    parent.InitPost()
    UD_DeviceType = "Vibrator"
    UD_ActiveEffectName = ""
    if deviceRendered.haskeyword(libs.zad_EffectChaosPlug)
        UD_Chaos = 25
        UD_ActiveEffectName += "Chaos"
    endif
    
    if (deviceRendered.haskeyword(libs.zad_EffectShocking))
        UD_Shocking = True
        UD_ActiveEffectName += "Shocking"
    endif
    
    if UD_VibStrength == -1
        if (deviceRendered.haskeyword(libs.zad_EffectVibratingVeryStrong))
            UD_VibStrength = 85
        elseif (deviceRendered.haskeyword(libs.zad_EffectVibratingStrong))
            UD_VibStrength = 65
        elseif (deviceRendered.haskeyword(libs.zad_EffectVibrating))
            UD_VibStrength = 40
        elseif deviceRendered.haskeyword(libs.zad_EffectVibratingWeak)
            UD_VibStrength = 25
        elseif deviceRendered.haskeyword(libs.zad_EffectVibratingVeryWeak)
            UD_VibStrength = 10
        else
            UD_VibStrength = 0
        endif
    endif
    
    if UD_VibStrength >= 50
        UD_ActiveEffectName += "Strong Vib"
    elseif UD_VibStrength >= 25
        UD_ActiveEffectName += "Vib"
    elseif UD_VibStrength > 0
        UD_ActiveEffectName += "Weak Vib"
    endif
    
    if UD_ActiveEffectName == ""
        UD_ActiveEffectName = "Share"
    endif
    
    if UD_EdgingMode < 0
        if deviceRendered.HasKeyword(libs.zad_EffectEdgeOnly)
            UD_EdgingMode = 1
        elseif deviceRendered.HasKeyword(libs.zad_EffectEdgeRandom)
            UD_EdgingMode = 2
        else
            UD_EdgingMode = 0
        endif
    endif
EndFunction

Int Function GetAiPriority()
    Int loc_res = 15
    if isVibrating()
        loc_res += 35
    endif
    return loc_res ;generic value
EndFunction

Function safeCheck()
    if !UD_SpecialMenuInteraction
        UD_SpecialMenuInteraction = UDCDmain.DefaultVibratorSpecialMsg
    endif
    if !UD_SpecialMenuInteractionWH
        UD_SpecialMenuInteractionWH = UDCDmain.DefaultVibratorSpecialMsg
    endif
    parent.safeCheck()
EndFunction

Function InitPostPost()
    Parent.InitPostPost()
    ;infinite vib duration, start immidiatly
    if UD_VibDuration == -1 
        vibrate()
    endif
    If canVibrate() && WearerIsPlayer()
        UDMain.UDWC.StatusEffect_SetVisible(VibrationEffectSlot)
        UDMain.UDWC.StatusEffect_SetBlink(VibrationEffectSlot, False)
    EndIf
EndFunction

string Function _getEdgingModeString(int iMode)
    if iMode == 0
        return "Normal"
    elseif iMode == 1
        return "Edging"
    elseif iMode == 2
        return "Random Edging"
    else
        return "ERROR"
    endif
EndFunction

;Show vibrator details
Function _ShowVibDetails()
    String loc_res = "{-" + getDeviceName() + "-}\n"
    loc_res += "--BASE VALUES--\n"
    if UD_Chaos
        loc_res += "Vib strength: Chaos ( "+UD_Chaos+" %)\n"
    else
        loc_res += "Vib strength: " + UD_VibStrength + "\n"
    endif
    
    loc_res += "Vib duration: " + UD_VibDuration + "\n"
    loc_res += "Vib mode: " + _getEdgingModeString(UD_EdgingMode) + "\n"
    loc_res += "Shocking: " + UD_Shocking + "\n"
    loc_res += "Status --> "
    if isVibrating() && !isVibPaused()
        loc_res += "ON\n"
        loc_res += "Current vib strength: " + getCurrentVibStrenth() + "\n"

        if _currentVibRemainingDuration > 0
            loc_res += "Rem. duration: " + _currentVibRemainingDuration + " s\n"
        else
            loc_res += "Rem. duration: " + "INF" + " s\n"
        endif
        loc_res += "Arousal rate: " + FormatString(getVibArousalRate(),2) + " A/s\n"
        loc_res += "Orgasm rate: " + FormatString(_appliedOrgasmRate,2) + " Op/s\n"
        loc_res += "Current vib mode: "
        if _currentEdgingMode == 0
            loc_res += "Normal\n"
        elseif _currentEdgingMode == 1
            loc_res += "Edge\n"
        elseif _currentEdgingMode == 2
            loc_res += "Random\n"
        endif
    elseif isVibPaused()
        loc_res += "PAUSED\n"
    else
        loc_res += "OFF\n"
    endif
    UDMain.ShowMessageBox(loc_res)
EndFunction

;function called when player clicks DETAILS button in device menu
Function processDetails()
    UDCDmain.currentDeviceMenu_switch1 = isVibrating() || canVibrate()
    UDCDmain.currentDeviceMenu_switch2 = HaveLocks()
    int res = UDCDmain.VibDetailsMessage.show()
    if res == 0 
        ShowBaseDetails()
    elseif res == 1
        ShowLockDetails()
    elseif res == 2
        _ShowVibDetails()
    elseif res == 3
        ShowModifiers()
    elseif res == 4
        UDCDmain.showActorDetails(GetWearer())
    elseif res == 5
        showDebugInfo()
    else
        return
    endif
EndFunction

Function onDeviceMenuInitPost(bool[] aControlFilter)
    parent.onDeviceMenuInitPost(aControlFilter)
    ;UDCDmain.currentDeviceMenu_allowcutting = false
    if canVibrate() && WearerFreeHands() && WearerIsPlayer()
        UDCDmain.currentDeviceMenu_switch1 = True
        UDCDmain.currentDeviceMenu_allowSpecialMenu = True
    endif
EndFunction

Function onDeviceMenuInitPostWH(bool[] aControlFilter)
    parent.onDeviceMenuInitPostWH(aControlFilter)
    ;UDCDmain.currentDeviceMenu_allowcutting = false
    if canVibrate() && (WearerFreeHands() || HelperFreeHands()); && (WearerIsPlayer() || HelperIsPlayer())
        UDCDmain.currentDeviceMenu_switch1 = True
        UDCDmain.currentDeviceMenu_allowSpecialMenu = True
    endif
EndFunction

bool Function proccesSpecialMenu(int msgChoice)
    bool res = parent.proccesSpecialMenu(msgChoice)
    if msgChoice == 0
        Int loc_res = UDCDmain.ShowSoulgemMessage(GetWearer())
        if loc_res >= 0
            if UDCDmain.ChangeSoulgemState(GetWearer(),loc_res)
                if !isVibrating()
                    ForceModDuration(0.75 + (loc_res)*0.25)
                    ForceModStrength(0.75 + (loc_res)*0.25)
                    UDCDmain.startVibFunction(self,true)
                else
                    addVibDuration((1 + loc_res)*20)
                    addVibStrength((1 + loc_res)*6)
                endif
                return res
            endif
        endif
    endif
    return res
EndFunction

bool Function proccesSpecialMenuWH(Actor akSource,int msgChoice)
    bool res = parent.proccesSpecialMenuWH(akSource,msgChoice)
    if msgChoice == 0
        Int loc_res = UDCDmain.ShowSoulgemMessage(UDmain.Player)
        if loc_res >= 0
            if UDCDmain.ChangeSoulgemState(akSource,loc_res)
                if !isVibrating()
                    ForceModDuration(0.75 + (loc_res)*0.25)
                    ForceModStrength(0.75 + (loc_res)*0.25)
                    UDCDmain.startVibFunction(self,true)
                else
                    addVibDuration((1 + loc_res)*20)
                    addVibStrength((1 + loc_res)*6)
                endif
                return res
            endif
        endif
    endif
    return res
EndFunction

Function activateDevice()
    vibrate()
EndFunction

Function _StartVibSound()
    if getWearer().is3DLoaded()
        if _vsID == -1
            _vsID = _getVibrationSound().Play(getWearer())
            if WearerIsPlayer()
                Sound.SetInstanceVolume(_vsID, libs.Config.VolumeVibrator)
            else
                Sound.SetInstanceVolume(_vsID, libs.Config.VolumeVibrator * 0.5)
            endif
        endif
    endif
EndFunction

Function _StopVibSound()
    if _vsID != -1 && getWearer().is3DLoaded()
        Sound.StopInstance(_vsID)
    endif
    _vsID = -1
EndFunction

Function _UpdateVibSound()
    _StopVibSound()
    _StartVibSound()
EndFunction

;/  Function: getCurrentVibStrenth
    Returns:
    
        Current vibration strength
/;
int Function getCurrentVibStrenth()
    return CurrentVibStrength
EndFunction

;/  Function: getCurrentZadVibStrenth
    Returns:
    
        Current vibration strength converted to Zad value. Value will be integer in range 0 to 5
/;
int Function getCurrentZadVibStrenth()
    return Math.Ceiling(CurrentVibStrength * 0.05)
EndFunction

;/  Function: canVibrate
    Returns:
    
        True if device can vibrate
/;
bool Function canVibrate()
    return (UD_VibStrength > 0) || UD_Chaos; || ((UD_Shocking ) && (UD_VibStrength > 0))
EndFunction

;/  Function: isVibrating
    Returns:
    
        True if device is currently vibrating
/;
bool Function isVibrating()
    return _currentVibRemainingDuration != 0 && CurrentVibStrength > 0
EndFunction

;/  Function: isVibratingForever
    Returns:
    
        True if device is vibrating forever (<UD_VibDuration> < 0)
/;
bool Function isVibratingForever()
    return _currentVibRemainingDuration < 0
EndFunction

;/  Function: getRemainingVibrationDuration
    Returns:
    
        Remaining duration of vibrator. In case the vibrator is vibrating forever, the duration will be negative
/;
int Function getRemainingVibrationDuration()
    return _currentVibRemainingDuration
EndFunction

;/  Function: getRemainingVibrationDurationPer
    Returns:
    
        Remaining duration of vibrator as relative value in range 0.0 to 1.0
        
        In case the vibrator is vibrating forever, the returned value will be useless
/;
float Function getRemainingVibrationDurationPer()
    if _forceDuration != 0
        return _currentVibRemainingDuration/(_forceDuration as float)
    else
        return _currentVibRemainingDuration/(UD_VibDuration as float)
    endif
EndFunction

;/  Function: isVibPaused
    Returns:
    
        True if vibrations are currently paused
/;
bool Function isVibPaused()
    return _paused
EndFunction

Int _PauseTimer = 0

;/  Function: pauseVibFor
    Pause device vibration for passed time
    
    Do not use this function if device is not already vibrating

    Parameters:
    
        aiTime - For how long to pause vib
/;
Function pauseVibFor(int aiTime)
    if aiTime < 5
        aiTime = 5
    endif
    
    if !_paused
        VibPauseStart()
    endif
    
    _PauseTimer += aiTime
EndFunction

;/  Function: stopVibrating
    Stops vibrator from vibrating. Function is not blocking
/;
Function stopVibrating()
    _currentVibRemainingDuration = 0
EndFunction

;/  Function: stopVibratingAndWait
    Stops vibrator from vibrating. Function will be blocked untill vibrations end
/;
Function stopVibratingAndWait()
    if _currentVibRemainingDuration != 0
        _currentVibRemainingDuration = 0
        while CurrentVibStrength
            Utility.wait(0.1)
        endwhile
    endif
EndFunction

bool _manipMutex
Function _StartManipMutex()
    while _manipMutex
        Utility.waitMenuMode(0.1)
    endwhile
    _manipMutex = true
EndFunction

Function _EndManipMutex()
    _manipMutex = false
EndFunction

;/  Function: ForceStrength
    Change vibration strength to new value, and update both orgasm rate and arousal rate
    
    Do not use this function if device is not already vibrating

    Parameters:
    
        aiStrenth - new strength
/;
Function ForceStrength(int aiStrenth)
    _forceStrength = aiStrenth
    if isVibrating()
        _StartManipMutex()
        CurrentVibStrength = _forceStrength
        if !isVibPaused()
            _UpdateVibSound()
            _UpdateOrgasmRate(getVibOrgasmRate(),_appliedForcing)
            _UpdateArousalRate(getVibArousalRate())
        endif
        OnVibrationStrengthUpdate()
        _EndManipMutex()
    endif
EndFunction

;/  Function: ForceModStrength
    Change vibration strength by passed modifer. Uses <UD_VibStrength> as base
    
    Do not use this function if device is not already vibrating

    Parameters:
    
        afModifier - strength modifier as relative value (no percente)
/;
Function ForceModStrength(float afModifier)
    _forceStrength = Round(UD_VibStrength*afModifier)
    if isVibrating()
        _StartManipMutex()
        CurrentVibStrength = _forceStrength
        if !isVibPaused()
            _UpdateVibSound()
            _UpdateOrgasmRate(getVibOrgasmRate(),_appliedForcing)
            _UpdateArousalRate(getVibArousalRate())
        endif
        OnVibrationStrengthUpdate()
        _EndManipMutex()
    endif
EndFunction

;/  Function: ForceDuration
    Change vibration duration to passed value
    
    Do not use this function if device is not already vibrating

    Parameters:
    
        aiDuration - New duration
/;
Function ForceDuration(int aiDuration)
    if aiDuration != 0
        _StartManipMutex()
        _forceDuration = aiDuration
        if isVibrating()
            _currentVibRemainingDuration += _forceDuration
        endif
        _EndManipMutex()
    endif
EndFunction

;/  Function: ForceModDuration
    Change vibration duration by passed modifer. Uses <UD_VibDuration> as base
    
    Do not use this function if device is not already vibrating

    Parameters:
    
        afModifier - duration modifier
/;
Function ForceModDuration(float afModifier)
    if afModifier >= 0.1
        _StartManipMutex()
        _forceDuration = Round(UD_VibDuration*afModifier)
        if isVibrating()
            _currentVibRemainingDuration += _forceDuration
        endif
        _EndManipMutex()
    endif
EndFunction

;/  Function: addVibDuration
    Increase vibration duration by passed value
    
    Do not use this function if device is not already vibrating

    Parameters:
    
        aiValue - By how much will be duration increased
/;
Function addVibDuration(int aiValue = 1)
    if isVibrating() && _currentVibRemainingDuration > 0
        _StartManipMutex()
        _currentVibRemainingDuration += aiValue
        _EndManipMutex()
    endif
EndFunction

;/  Function: removeVibDuration
    Decrease vibration duration by passed value
    
    Do not use this function if device is not already vibrating

    Parameters:
    
        aiValue - By how much will be duration decreased
/;
Function removeVibDuration(int aiValue = 1)
    if isVibrating() && _currentVibRemainingDuration > 0
        _StartManipMutex()
        _currentVibRemainingDuration -= aiValue
        if _currentVibRemainingDuration < 0
            _currentVibRemainingDuration = 0
        endif
        _EndManipMutex()
    endif
EndFUnction

;/  Function: addVibStrength
    Increase vibration strength by passed value, and update oragsm/arousal rate
    
    Do not use this function if device is not already vibrating

    Parameters:
    
        aiValue - By how much will be strength increased
/;
Function addVibStrength(int aiValue = 1)
    if isVibrating()
        _StartManipMutex()
        CurrentVibStrength += aiValue
        if !isVibPaused()
            _UpdateOrgasmRate(getVibOrgasmRate(),_appliedForcing)
            _UpdateArousalRate(getVibArousalRate())
            _UpdateVibSound()
        endif
        OnVibrationStrengthUpdate()
        _EndManipMutex()
    endif
EndFunction

;/  Function: removeVibStrength
    Decrease vibration strength by passed value, and update oragsm/arousal rate
    
    Do not use this function if device is not already vibrating

    Parameters:
    
        aiValue - By how much will be strength decreased
/;
Function removeVibStrength(int aiValue = 1)
    if isVibrating()
        _StartManipMutex()
        CurrentVibStrength -= aiValue
        if CurrentVibStrength == 0
            stopVibrating()
        endif
        if !isVibPaused() && isVibrating()
            _UpdateOrgasmRate(getVibOrgasmRate(),_appliedForcing)
            _UpdateArousalRate(getVibArousalRate())
            _UpdateVibSound()
        endif
        OnVibrationStrengthUpdate()
        _EndManipMutex()
    endif
EndFUnction

;/  Function: forceEdgingMode
    Change current edging mode to passed value
    
    Do not use this function if device is not already vibrating

    Parameters:
    
        aiMode - New edging mode
/;
Function forceEdgingMode(int aiMode)
    _StartManipMutex()
    _forceEdgingMode = aiMode
    _currentEdgingMode = _forceEdgingMode
    _EndManipMutex()
EndFunction

Function _UpdateOrgasmRate(float fOrgasmRate,float fOrgasmForcing)
    if isVibrating()
        _removeOrgasmRate()
        if isVibrating()
            _setOrgasmRate(fOrgasmRate,fOrgasmForcing)
        endif
    endif
EndFunction

Function _setOrgasmRate(float fOrgasmRate,float fOrgasmForcing)
    if (fOrgasmRate != _appliedOrgasmRate || fOrgasmForcing != _appliedForcing) && isVibrating()
        _appliedOrgasmRate = fOrgasmRate
        _appliedForcing = fOrgasmForcing
        UDOM.UpdateOrgasmRate(getWearer(),_appliedOrgasmRate,_appliedForcing)
    endif
EndFunction

Function _removeOrgasmRate()
    if _appliedOrgasmRate != 0 || _appliedForcing != 0
        float loc_appliedOrgasmRate = _appliedOrgasmRate
        _appliedOrgasmRate = 0.0
        
        float loc_appliedForcing    = _appliedForcing
        _appliedForcing = 0.0
        
        UDOM.UpdateOrgasmRate(getWearer(),-1*loc_appliedOrgasmRate,-1*loc_appliedForcing)
    endif
EndFunction

Function _UpdateArousalRate(float fArousalRate)
    _removeArousalRate()
    _setArousalRate(fArousalRate)
EndFunction

Function _setArousalRate(float fArousalRate)
    if fArousalRate != _appliedArousalRate 
        _appliedArousalRate = fArousalRate
        UDOM.UpdateArousalRate(getWearer() ,fArousalRate)
    endif
EndFunction

Function _removeArousalRate()
    if _appliedArousalRate != 0
        float loc_appliedArousalRate = _appliedArousalRate
        _appliedArousalRate = 0
        UDOM.UpdateArousalRate(getWearer() ,-1*loc_appliedArousalRate)
    endif
EndFunction

Sound Function _getVibrationSound()
    if UD_VibSound
        ;custom sound filled, use it
        return UD_VibSound
    endif
    if CurrentVibStrength >= 75
        return libs.VibrateVeryStrongSound
    elseIf CurrentVibStrength >= 50
        return libs.VibrateStrongSound
    elseIf CurrentVibStrength >= 30
        return libs.VibrateStandardSound
    elseIf CurrentVibStrength >= 15
        return libs.VibrateWeakSound
    else
        return libs.VibrateVeryWeakSound
    EndIf
EndFunction

bool Property VibLoopOn = false auto hidden
Function _VibrateStart(float afDurationMult = 1.0)
    ;mutex
    if VibLoopOn
        return
    endif
    VibLoopOn = true
    
    if isVibrating()
        return
    endif

    resetCooldown(1.0)

    if UD_Chaos ;chaos plug, ignore forced strength
        CurrentVibStrength = Utility.randomInt(15,100)
    elseif _forceStrength < 0
        CurrentVibStrength = UD_VibStrength ;auto set variables from properties
    else ;use forced strength
        CurrentVibStrength = _forceStrength
    endif
    
    OnVibrationStart()
    
    if _forceDuration == 0
        _currentVibRemainingDuration = Round(UD_VibDuration*afDurationMult)
    else
        _currentVibRemainingDuration = _forceDuration
    endif
    
    if _forceEdgingMode < 0
        _currentEdgingMode = UD_EdgingMode
    else
        _currentEdgingMode = _forceEdgingMode
    endif
    
    if UD_Shocking
        ShockWearer(Utility.randomInt(50,90),25)
    endif
    
    if !isVibrating() ;not vib, error and return
        return
    endif
    
    if UDmain.TraceAllowed()    
        UDmain.Log("Vibrate called for " + getDeviceName() + " on " + getWearerName() + ", duration: " + _currentVibRemainingDuration + ", strength: " + CurrentVibStrength + ", edging: " + _currentEdgingMode)
    endif
    
    StorageUtil.AdjustIntValue(getWearer(),"UD_ActiveVib", 1)
    
    UDmain.SendModEvent("DeviceVibrateEffectStart", getWearerName(), getCurrentZadVibStrenth())
    
    PrintVibMessage_Start()

    ; Initialize Sounds
    _StartVibSound()
    
    _setOrgasmRate(getVibOrgasmRate(),1.0)
    _setArousalRate(getVibArousalRate())
    
    UD_CustomDevice_NPCSLot loc_slot = UD_WearerSlot
    if !loc_slot
        UDmain.Warning(getDeviceHeader() + " - can't register vib function because actor is not registered")
        return
    endif
    
    ;register the vibrator to slot, so it can be periodically updated
    ;failing to register the vibrator will result in infinite vibrations
    loc_slot.RegisterVibrator(self)
EndFunction

; Main Loop
Function VibrateUpdate(Int aiUpdateTime)
    ;lasts untill times runs out or device is removed (normally stopVibration is called, but its possible for device to be manually which doesn't stop this loop)
    bool loc_endflag = false
    if ((_currentVibRemainingDuration != 0) && !loc_endflag) && isDeviceValid()
        _ProcessPause(aiUpdateTime)
        if !_paused
            ;vibrate sound
            if isVibrating() && !_paused && getWearer().Is3DLoaded()
                if (_currentVibRemainingDuration % 2) == 0 ; Make noise
                    getWearer().CreateDetectionEvent(getWearer(), 50 + Round(UD_VibStrength/2.0))
                EndIf
            endif
            
            if UD_Chaos && isVibrating() && !_paused
                if Utility.randomInt() < UD_Chaos
                    ForceStrength(Utility.randomInt(15,95))
                endif
            endif
            
            if isVibrating() && !_paused
                _ProccesVibEdge()
                if !libs.IsVibrating(GetWearer())
                    libs.SetVibrating(GetWearer(), 1) ;set vibration factino to one for compatibility
                endif
            endif
            
            if isVibrating() && !_paused && (_currentVibRemainingDuration > 0)
                if (_currentVibRemainingDuration <= aiUpdateTime)
                    loc_endflag = true
                    _currentVibRemainingDuration = 0
                else
                    _currentVibRemainingDuration -= aiUpdateTime ;reduce timer
                endif
            endif
            resetCooldown(1.0)
        endif
    else
        _VibrateEnd()
    endif
EndFunction

Function _VibrateEnd(Bool abUnregister = True, Bool abStop = True)
    if abUnregister
        UD_CustomDevice_NPCSLot loc_slot = UD_WearerSlot
        if loc_slot
            loc_slot.UnregisterVibrator(self)
        endif
    endif
    
    if abStop
        _removeOrgasmRate()
        _removeArousalRate()
        
        if libs.IsVibrating(GetWearer())
            libs.StopVibrating(GetWearer()) ;remove from vibration faction
        endif
    endif
    
    _StopVibSound()
    
    if !_paused && abStop
        PrintVibMessage_Stop()
    endif
    
    if abStop
        StorageUtil.AdjustIntValue(getWearer(),"UD_ActiveVib", -1)
        
        UDCDmain.SendModEvent("DeviceVibrateEffectStop", getWearerName(), getCurrentZadVibStrenth())
        
        _currentVibRemainingDuration = 0
        CurrentVibStrength = 0
        _forceDuration = 0
        _forceStrength = -1
        _forceEdgingMode = -1
        OnVibrationEnd()
        VibLoopOn = false
    endif
EndFunction

;/  Function: vibrate
    Force device to vibrate. Is not blocking.

    Parameters:
    
        afDurationMult - Duration multiplier
/;
Function vibrate(float afDurationMult = 1.0)
    _VibrateStart(afDurationMult)
EndFunction

;/  Function: VibPauseStart
    Pause device vibration. Need to be unpaused manually with <VibPauseStop>
/;
Function VibPauseStart()
    _paused = true
    _removeOrgasmRate()
    _removeArousalRate()
    _StopVibSound()
EndFunction

;/  Function: VibPauseStop
    Unpause device vibration. Need to be unpaused manually with <VibPauseStop>
/;
Function VibPauseStop()
    if isVibrating()
        _setOrgasmRate(getVibOrgasmRate(),1.0)
        _setArousalRate(getVibArousalRate())
        _StartVibSound()
        if WearerIsPlayer()
            UDmain.Print(getDeviceName() + " has come back to life, arousing you once again",3)
        endif
    endif
    _PauseTimer = 0
    _paused = false
EndFunction

Function _ProcessPause(Int aiUpdateTime)
    if _paused
        _PauseTimer -= aiUpdateTime
        if _PauseTimer <= 0
            VibPauseStop()
        endif
    endif
EndFunction

Function _ProccesVibEdge()
    if isVibrating() && !_paused
        if _currentEdgingMode == 1
            if UDOM.getOrgasmProgressPerc(getWearer()) > UD_EdgingThreshold
                if WearerIsPlayer() && !UDMain.UDWC.UD_FilterVibNotifications
                    UDmain.Print(getDeviceName() + " suddenly stops vibrating!",3)
                endif
                pauseVibFor(10)
            endif
        elseif _currentEdgingMode == 2
            if UDOM.getOrgasmProgressPerc(getWearer()) > UD_EdgingThreshold
                if Utility.randomInt() < iRange(CurrentVibStrength, 40 , 80)
                    if WearerIsPlayer() && !UDMain.UDWC.UD_FilterVibNotifications
                        UDmain.Print(getDeviceName() + " suddenly stops vibrating!",3)
                    endif
                    pauseVibFor(Utility.randomInt(30,60))
                endif
            endif
        endif
    endif
EndFunction

Function onRemoveDevicePre(Actor akActor)
    stopVibrating()
    parent.onRemoveDevicePre(akActor)
EndFunction

;vibrator can't be currently vibrating, needs to be able to vibrate AND at least 25% of the cooldown have to pass 
bool Function canBeActivated()
    if !isVibrating() && (canVibrate() || UD_Shocking) && getRelativeElapsedCooldownTime() >= 0.25
        return true
    else
        return false
    endif
EndFunction

;/  Function: GetAppliedOrgasmRate
    Returns:
    
        Applied orgasm rate by vibrator
/;
Float Function GetAppliedOrgasmRate()
    return _appliedOrgasmRate
EndFunction

;/  Group: Vibrator Override
Few functions which should be used in similiar matter as <Override>
===========================================================================================
===========================================================================================
===========================================================================================
/;

;======================================================================
;Place new override functions here, do not forget to check override functions in parent if its not base script (UD_CustomDevice_RenderScript)
;Function OnVibStart(int blablabla)
;EndFunction
;======================================================================

;/  Function: OnVibrationStart
    Called when vibration start
/;
Function OnVibrationStart()
    UDMain.Log("UD_CustomVibratorBase_RenderScript::OnVibrationStart() " + Self + ", CurrentVibStrength = " + CurrentVibStrength, 3)
    OnVibrationStrengthUpdate()
EndFunction

;/  Function: OnVibrationEnd
    Called when vibration end
/;
Function OnVibrationEnd()
    UDMain.Log("UD_CustomVibratorBase_RenderScript::OnVibrationEnd() " + Self + ", CurrentVibStrength = " + CurrentVibStrength, 3)
    If WearerIsPlayer()
        UDMain.UDWC.StatusEffect_SetMagnitude(VibrationEffectSlot, 0)
        UDMain.UDWC.StatusEffect_SetBlink(VibrationEffectSlot, False)
    EndIf
EndFunction

;/  Function: OnVibrationStrengthUpdate
    Called when vibration strength is changed with any of the API functions
/;
Function OnVibrationStrengthUpdate()
    If WearerIsPlayer()
        UDMain.UDWC.StatusEffect_SetMagnitude(VibrationEffectSlot, CurrentVibStrength)
        UDMain.UDWC.StatusEffect_SetBlink(VibrationEffectSlot, CurrentVibStrength > 0)
    EndIf
EndFunction

;/  Function: getVibOrgasmRate
    Can be edited to adjust orgasm rate calculation formula.
    
    Default calculation formula is:
    
    ---Code
        return CurrentVibStrength * afMult * UDCDmain.UD_VibrationMultiplier * UD_OrgasmMult
    ---

    Parameters:
    
        afMult - Multiplier for returned orgasm rate

    Returns:
    
        Calculated orgasm rate
/;
float Function getVibOrgasmRate(float afMult = 1.0)
    return CurrentVibStrength * afMult * UDCDmain.UD_VibrationMultiplier * UD_OrgasmMult
EndFunction

;/  Function: getVibOrgasmRate
    Can be edited to adjust arousal rate calculation formula.
    
    Default calculation formula is:
    
    ---Code
        return CurrentVibStrength * afMult * UDCDmain.UD_ArousalMultiplier * UD_ArousalMult
    ---

    Parameters:
    
        afMult - Multiplier for returned arousal rate

    Returns:
    
        Calculated orgasm rate
/;
float Function getVibArousalRate(float afMult = 1.0)
    return CurrentVibStrength * afMult * UDCDmain.UD_ArousalMultiplier * UD_ArousalMult
EndFunction

;/  Function: PrintVibMessage_Start
    Called when vibration starts. Used to show message (someones something start vibrating etc...)
/;
Function PrintVibMessage_Start()
    if WearerIsPlayer()
        If !UDMain.UDWC.UD_FilterVibNotifications
            UDmain.Print(getDeviceName() + " starts vibrating "+ getPlugsVibrationStrengthString(getCurrentZadVibStrenth()) +"!",2)
        EndIf
    elseif UDCDmain.AllowNPCMessage(GetWearer())
        UDmain.Print(getWearerName() + "s " + getDeviceName() + " starts vibrating "+ getPlugsVibrationStrengthString(getCurrentZadVibStrenth()) +"!",3)
    endif
EndFunction

;/  Function: PrintVibMessage_Start
    Called when vibration ends. Used to show message (someones something ends vibrating etc...)
/;
Function PrintVibMessage_Stop()
    if WearerIsPlayer()
        If !UDMain.UDWC.UD_FilterVibNotifications
            UDmain.Print(getDeviceName() + " stops vibrating.",2)
        EndIf
    elseif UDCDmain.AllowNPCMessage(GetWearer())
        UDmain.Print(getWearerName() + "s " + getDeviceName() + " stops vibrating.",3)
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
Function onRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    If UDMain.ActorIsPlayer(akActor)
        UDMain.UDWC.StatusEffect_SetVisible(VibrationEffectSlot, False)
        UDMain.UDWC.StatusEffect_SetBlink(VibrationEffectSlot, False)
    EndIf
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
int Function getArousalRate()
    return parent.getArousalRate()
EndFunction
float Function getStruggleOrgasmRate()
    return parent.getStruggleOrgasmRate()
EndFunction
Float[] Function GetCurrentMinigameExpression()
	return parent.GetCurrentMinigameExpression()
EndFunction