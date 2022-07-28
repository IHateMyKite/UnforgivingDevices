Scriptname UD_DebugMagickEffect_AME extends activemagiceffect  

UDCustomDeviceMain Property UDCDmain auto

int loc_value = 0
int loc_maxvalue = 100
float loc_updatetime = 0.1

Event OnEffectStart(Actor akTarget, Actor akCaster)
    UDCDMain.StartRecordTime()
    OnUpdate()
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    float loc_time = UDCDMain.FinishRecordTime("UD_DebugMagickEffect_AME - Time")
    UDCDMain.Log("UD_DebugMagickEffect_AME - Load = " + CalculateLoad(loc_time) )
EndEvent

Event OnUpdate()
    if loc_value < loc_maxvalue
        registerForSingleUpdate(loc_updatetime)
    else
        Dispel()
    endif
    loc_value += 1
EndEvent

Float Function CalculateLoad(Float argTime)
    return argTime/(loc_maxvalue*loc_updatetime)
EndFunction