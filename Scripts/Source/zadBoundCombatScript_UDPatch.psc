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
EndFunction

Function EvaluateAA(actor akActor)
    if StorageUtil.GetIntValue(akActor,"DDStartBoundEffectQue",0)
        return
    endif
    StorageUtil.SetIntValue(akActor,"DDStartBoundEffectQue",1)
    
    bool loc_paralysis = false
    while akActor.getAV("Paralysis") && !akActor.isDead()
        loc_paralysis = true
        Utility.wait(1.0) ;wait for actors paralysis to worn out first, because it can cause issue if idle is set when paralysed
    endwhile
    
    if akActor.isDead()
        StorageUtil.UnSetIntValue(akActor,"DDStartBoundEffectQue")
        return
    endif
    
    ;wait some time so actor have enaught time to get from standing up animation
    if loc_paralysis
        Utility.wait(4.0)
    endif
    
    if !UD_DAR
        parent.EvaluateAA(akActor)
    else
        libs.UpdateControls()
        If !HasCompatibleDevice(akActor)
            Debug.SendAnimationEvent(akActor, "IdleForceDefaultState")
            RemoveBCPerks(akActor)
        Else
            if akActor.IsWeaponDrawn()
                akActor.SheatheWeapon()
                ; Wait for users with flourish sheathe animations.
                int timeout=0
                while akActor.IsWeaponDrawn() && timeout <= 45 ;  Wait 4.5 seconds at most before giving up and proceeding.
                    Utility.Wait(0.1)
                    timeout += 1
                EndWhile
            EndIf
            ApplyBCPerks(akActor)
            Debug.SendAnimationEvent(akActor, "IdleForceDefaultState")
            
            int animSet     = SelectAnimationSet(akActor)
            int animState   = GetSecondaryAAState(akActor)
            if animState != 1 && animState != 2 && animSet != 6
                akActor.SetAnimationVariableInt("FNIS_abc_h2h_LocomotionPose", animSet + 1)
            endIf
        endif
    endif
    StorageUtil.UnSetIntValue(akActor,"DDStartBoundEffectQue")
EndFunction

Function ClearAA(actor akActor)
    while StorageUtil.GetIntValue(akActor,"DDStartBoundEffectQue",0)
        Utility.wait(1.0)
    endwhile
    if !UD_DAR
        parent.ClearAA(akActor)
    else
        akActor.SetAnimationVariableInt("FNIS_abc_h2h_LocomotionPose", 0)
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