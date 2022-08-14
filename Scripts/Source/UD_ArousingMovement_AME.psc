Scriptname UD_ArousingMovement_AME extends ActiveMagicEffect
import UnforgivingDevicesMain
UnforgivingDevicesMain  Property UDmain auto
UD_OrgasmManager        Property UDOM   auto
Actor akActor
Float _updateTime
Bool _finished = false
Float _magnitude
Float _lastX = 0.0
Float _lastY = 0.0
Cell _previousCell = none
;Float _lastZ = 0. ,ignore height

Function OnEffectStart(Actor akTarget, Actor akCaster)
    akActor = akTarget
    if UDmain.UDNPCM.IsRegistered(akActor)
        _magnitude = fRange(GetMagnitude(),0.01,100.0)
        _lastX = akActor.GetPositionX()
        _lastY = akActor.GetPositionY()
        _previousCell = akActor.GetParentCell()
        UpdateTime()
        RegisterForSingleUpdate(_updateTime)
    endif
EndFunction

Function UpdateTime()
    if akActor == UDmain.Player
        _updateTime = fRange(UDOM.UD_OrgasmUpdateTime/2.0,0.2,1.0)
    else
        _updateTime = 1.0
    endif
EndFunction

Function Update()
    UpdateTime()
EndFunction

Event OnUpdate()
    if _finished
        return
    endif
    Update()
    Int loc_distance = Round(CalcTraveledDistance())
    if UDmain.UDCDMain.ActorInMinigame(akActor)
        loc_distance += 200
    endif
    loc_distance = iRange(loc_distance,0,1000)
    if loc_distance
        UDOM.UpdateBaseOrgasmVals(akActor, Math.Ceiling(_updateTime), loc_distance*_magnitude/100, 0.2, loc_distance*_magnitude/100)
    endif
    _lastX = akActor.GetPositionX()
    _lastY = akActor.GetPositionY()
    _previousCell = akActor.GetParentCell()
    RegisterForSingleUpdate(_updateTime)
EndEvent

Function OnEffectFinish(Actor akTarget, Actor akCaster)
    GoToState("Finished")
    _finished = true
EndFunction

Float Function CalcTraveledDistance()
    if akActor.IsOnMount()
        return 0.0
    endif
    if _previousCell == akActor.GetParentCell()
        Float loc_x = akActor.GetPositionX()
        Float loc_y = akActor.GetPositionY()
        Float loc_Dx = _lastX - loc_x
        Float loc_Dy = _lastY - loc_Y
        return Math.sqrt(loc_Dx*loc_Dx + loc_Dy*loc_Dy)
    else
        return 0.0
    endif   
EndFunction

State Finished
    Function UpdateTime()
    EndFunction

    Function Update()
    EndFunction

    Event OnUpdate()
    EndEvent
EndState