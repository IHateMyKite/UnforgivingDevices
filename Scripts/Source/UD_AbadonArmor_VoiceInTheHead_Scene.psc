Scriptname UD_AbadonArmor_VoiceInTheHead_Scene extends UD_ModInjection_Scene

UnforgivingDevicesMain _udmain
UnforgivingDevicesMain Property UDmain Hidden
    UnforgivingDevicesMain Function Get()
        if !_udmain
            _udmain = UnforgivingDevicesMain.GetUDMain()
        endif
        return _udmain
    EndFunction
EndProperty

Function _Prepare()
    If UDmain.TraceAllowed()
        UDmain.Log("UD_AbadonArmor_VoiceInTheHead_Scene::_Prepare()", 3)
    EndIf
    ObjectReference loc_dummy = (Parent.GetOwningQuest().GetAlias(0) as ReferenceAlias).GetReference()
    Actor loc_player = Game.GetPlayer()

    loc_dummy.MoveTo(loc_player as ObjectReference)
    Utility.Wait(0.1)
EndFunction