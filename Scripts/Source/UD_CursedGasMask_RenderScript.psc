Scriptname UD_CursedGasMask_RenderScript extends UD_CustomHood_RenderScript  

Function InitPost()
    parent.InitPost()
    UD_DeviceType = "Aphrodisiac Gas Mask"
    UD_ActiveEffectName = "GasMask-Aphrodisiacs"
EndFunction

int     Property UD_AphroApplyTime    = 180 auto
float     Property UD_AphroMagnitude    = 50.0 auto

bool Function canBeActivated()
    return !getWearer().HasMagicEffectWithKeyword(UDCDmain.UDlibs.AphrodisiacsEffect_KW)
EndFunction

Function activateDevice()
    if WearerIsPlayer()
        UDmain.Print(getDeviceName() + " is forcing you to inhale aphrodisiacs!",1)
    elseif WearerIsFollower()
        UDmain.Print(getDeviceName() + " is forcing "+ getWearerName() +" to inhale aphrodisiacs!",1)
    endif
    
    Spell loc_spell = UDCDmain.UDlibs.AphrodisiacsSpell
    loc_spell.SetNthEffectMagnitude(0, UD_AphroMagnitude)
    loc_spell.SetNthEffectDuration(0, UD_AphroApplyTime)
    loc_spell.cast(getWearer(),getWearer())
EndFunction



