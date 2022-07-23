Scriptname UD_MinigameDisable_Script extends activemagiceffect  

;/
Actor _target = none
UDCustomDeviceMain Property UDCDmain auto
UD_CustomDevices_NPCSlotsManager Property UDCD_NPCM auto
bool _finished = false
MagicEffect _MagickEffect = none
Event OnEffectStart(Actor akTarget, Actor akCaster)
    _target = akTarget
    if UDCDmain.TraceAllowed()    
        UDCDmain.Log("Minigame disabler started for " + _target +"!",2)
    endif
    _MagickEffect = GetBaseObject()
    registerForSingleUpdate(0.1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    _finished = true
    if UDCDmain.TraceAllowed()    
        UDCDmain.Log("Minigame disabler OnEffectFinish() for " + _target,1)
    endif
    
    ;wait for onUpdate function to finish if it started
    while loc_precessing
        Utility.waitMenuMode(0.01)
    endwhile
    
    if _target == Game.getPlayer()
        if !_target.HasMagicEffectWithKeyword(UDCDmain.UDlibs.HardcoreDisable_KW)
            Game.EnablePlayerControls(abMovement = False)
        endif
        Game.SetPlayerAiDriven(False)
    else
        _target.SetDontMove(False)
    endif
EndEvent

bool loc_precessing = false
Event OnUpdate()
    loc_precessing = true
    if _target.hasMagicEffect(_MagickEffect) && !_finished
        if UDCDmain.TraceAllowed()        
            UDCDmain.Log("Minigame disabler updated for " + _target,1)
        endif
        if _target.hasMagicEffect(_MagickEffect)  && !_finished
            if _target == Game.getPlayer()
                if !_target.HasMagicEffectWithKeyword(UDCDmain.UDlibs.HardcoreDisable_KW)
                    Game.EnablePlayerControls(abMovement = False)
                endif
                Game.DisablePlayerControls(abMovement = False)
                Game.SetPlayerAiDriven(True)
            else
                _target.SetDontMove(True)    
            endif
        endif
        if _target.hasMagicEffect(_MagickEffect)  && !_finished
            registerForSingleUpdate(2.0)
        endif
    endif
    loc_precessing = false
EndEvent
/;