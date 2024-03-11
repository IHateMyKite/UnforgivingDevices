Scriptname UD_ZAZDrool_AME extends activemagiceffect  

import UnforgivingDevicesMain
import UD_Native

UDCustomDeviceMain Property UDCDmain auto
UnforgivingDevicesMain Property UDmain
    UnforgivingDevicesMain Function get()
        return UDCDmain.UDmain
    EndFunction
EndProperty

Actor _target
int loc_type = 3

string _node
bool _applied
bool _female = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
    _target = akTarget
    if UDmain.TraceAllowed()
        UDmain.Log("UD_ZAZDrool_AME started for " + GetActorName(_target),2)
    endif
    
    loc_type = iRange(Round(GetMagnitude()),1,4)
    if loc_type == 4
        loc_type = RandomInt(1,3)
    endif

    _female = GetActorGender(_target)
    
    Int loc_NodeCount = NiOverride.GetNumFaceOverlays()
    bool loc_found = false
    While(loc_NodeCount && !loc_found)
        loc_NodeCount -= 1
        _node = "Face [Ovl" + loc_NodeCount + "]"
        string NodeTexture = NiOverride.GetNodeOverrideString(_target,_female,_node,9,0)

        If(NodeTexture == "" || NodeTexture == "textures\\Actors\\character\\overlays\\default.dds")
            loc_found = true
        EndIf
    EndWhile
    
    if !loc_found
        UDmain.Info("Could not find free overlay slot for npc "+GetActorName(_target))
        return
    else
        ;UDMain.Info("Added tears overlay for node " + _node + " on actor "+GetActorName(_target))
    endif
    
    string loc_path = "textures\\actors\\character\\UnforgivingDevices\\drool\\drool"+loc_type+".dds"
    NiOverride.AddNodeOverrideString(_target, _female,_node , 9, 0, loc_path , true)
    
    NiOverride.AddNodeOverrideInt(_target, _female, _node, 0, -1, 0xFFFFFFFF, true) ;emissive color
    NiOverride.AddNodeOverrideFloat(_target, _female, _node, 2, -1, 0.5, true) ;gloss
    NiOverride.AddNodeOverrideFloat(_target, _female, _node, 3, -1, 0.5, true) ;specular
    NiOverride.AddNodeOverrideInt(_target, _female, _node, 7, -1, 0xFFFFFFFF, true) ;tint color
    NiOverride.AddNodeOverrideFloat(_target, _female, _node, 8, -1, 0.25, true) ;alpha
    NiOverride.ApplyNodeOverrides(_target)
    _applied = true
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    if UDmain.TraceAllowed()    
        UDmain.Log("UD_ZAZDrool_AME OnEffectFinish() for " + GetActorName(_target),2)
    endif
    
    if _applied
        NiOverride.AddNodeOverrideString(_target, _female,_node , 9, 0, "textures\\Actors\\character\\overlays\\default.dds" , true)
        NiOverride.RemoveNodeOverride(_target,_female,_node,9,0)
    endif
EndEvent

