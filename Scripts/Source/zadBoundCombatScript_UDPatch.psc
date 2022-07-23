Scriptname zadBoundCombatScript_UDPatch Extends zadBoundCombatScript Hidden

import UnforgivingDevicesMain

Bool Property UD_DAR = false auto

;is not used by parent script, no sin here
Function OnInit()
    Utility.waitMenuMode(2.0) ;wait few moments, so computer doesn't explode
    RegisterForSingleUpdate(10.0)
EndFunction

Event OnUpdate()
    Maintenance_ABC()
EndEvent

Function Update()
    if UD_DAR && !libs.isAnimating(Game.GetPlayer())
        ;DCLog("Forcing IdleForceDefaultState to player")
        ;EvaluateAA(Game.GetPlayer())
    endif
EndFunction

Function EvaluateAA(actor akActor)
    if StorageUtil.GetIntValue(akActor,"DDStartBoundEffectQue",0)
        return
    endif
    StorageUtil.SetIntValue(akActor,"DDStartBoundEffectQue",1)
    
    bool loc_paralysis = false
    while akActor.getAV("Paralysis")
        loc_paralysis = true
        Utility.wait(1.0) ;wait for actors paralysis to worn out first, because it can cause issue if idle is set when paralysed
    endwhile
    
    if loc_paralysis
        Utility.wait(8.0)
    endif
    
    if !UD_DAR
        parent.EvaluateAA(akActor)
    else
        Debug.SendAnimationEvent(akActor, "IdleForceDefaultState")
        libs.UpdateControls()
        If !HasCompatibleDevice(akActor)
            ;ClearAA(akActor)
            ;ResetExternalAA(akActor)
            RemoveBCPerks(akActor)
        Else
            ApplyBCPerks(akActor)
            ;int animState = GetSecondaryAAState(akActor)
            ;Debug.SendAnimationEvent(akActor, "IdleForceDefaultState")
            ;if animState != 1 && animState != 2
            ;    akActor.SetAnimationVariableInt("FNIS_abc_h2h_LocomotionPose", 1)
            ;endIf
        endif
    endif
    StorageUtil.UnSetIntValue(akActor,"DDStartBoundEffectQue")
EndFunction

Int Function SelectAnimationSet(actor akActor)
    if UD_DAR
        return 0
    else
        return parent.SelectAnimationSet(akActor)
    endif
EndFunction

Function Maintenance_ABC()
    if !UD_DAR
        parent.Maintenance_ABC()
    endif
EndFunction

Function CONFIG_ABC()
    if !UD_DAR
        parent.CONFIG_ABC()
    endif
EndFunction

Function UpdateValues() 
    if !UD_DAR
        parent.UpdateValues()
    endif
EndFunction