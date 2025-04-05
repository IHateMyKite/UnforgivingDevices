Scriptname UD_ModifierManager_SkillMonitor extends Quest  

UnforgivingDevicesMain Property UDmain auto

Event OnStoryIncreaseSkill(String asSkill)
    Int loc_value = UDMain.Player.GetActorValue(asSkill) as Int
    If UDmain.TraceAllowed()
        UDmain.Info("Skill increase was detected: asSkill = " + asSkill + ", loc_value = " + loc_value)
    EndIf
    UDmain.UDMOM.UpdateModifiers_SkillMonitor(asSkill, loc_value)
    
    Stop()
EndEvent
