Scriptname UD_ParalelProcess extends Quest

import UnforgivingDevicesMain
import UD_NPCInteligence
import UD_Native

UDCustomDeviceMain Property UDCDmain auto
UnforgivingDevicesMain Property UDmain auto

zadlibs_UDPatch Property libsp
    zadlibs_UDPatch Function get()
        return UDmain.libs as zadlibs_UDPatch
    EndFunction
EndProperty
UD_ExpressionManager Property UDEM
    UD_ExpressionManager Function get()
        return UDmain.UDEM
    EndFunction
EndProperty
UD_OrgasmManager Property UDOM
    UD_OrgasmManager Function get()
        return UDmain.UDOM
    EndFunction
EndProperty

Bool Property Ready auto

Event OnInit()
    registerEvents()

    if UDmain.TraceAllowed()
        UDmain.Log("UD_ParalelProcess ready!",0)
    endif
    
    Ready = True
EndEvent

Function Update()
    UnregisterForAllModEvents()
    RegisterEvents()
EndFunction

;==============================
;           REGISTER
;==============================
Function RegisterEvents()
    RegisterForModEvent(    "UDOrgasmParalel"        , "Receive_Orgasm"                )
    
EndFunction

;==============================
;           ORGASM
;==============================

;vars
bool _OrgasmMutex = false

;mutex
Function Start_OrgasmMutex()
    while _OrgasmMutex
        Utility.waitMenuMode(0.05)
    endwhile
    _OrgasmMutex = true
EndFunction

Function End_OrgasmMutex()
    _OrgasmMutex = false
EndFunction

;starter
bool _OrgasmStarter_Received = false

Function Send_Orgasm(Actor akActor, bool abWairForReceive = false)
    if !akActor
        UDmain.Error("Send_Orgasm wrong arg received!")
    endif
    
    if abWairForReceive
        Start_OrgasmMutex()
        _OrgasmStarter_Received = false
    endif
    
    ;send event
    int handle = ModEvent.Create("UDOrgasmParalel")
    if (handle)
        ModEvent.PushForm(handle, akActor)
        ModEvent.PushInt(handle, abWairForReceive as int)
        ModEvent.Send(handle)
        
        ;block
        if abWairForReceive
            float loc_TimeOut = 0.0
            while !_OrgasmStarter_Received && loc_TimeOut <= 1.0
                loc_TimeOut += 0.05
                Utility.waitMenuMode(0.05)
            endwhile
            
            _OrgasmStarter_Received = false
            
            if loc_TimeOut >= 1.0
                UDmain.Error("Send_Orgasm timeout!")
            endif
        endif
    else
        UDmain.Error("Send_Orgasm UDmain.Error!")
    endif
    if abWairForReceive
        End_OrgasmMutex()
    endif
EndFunction
Function Receive_Orgasm(Form fActor,int abWairForReceive)
    Actor akActor = fActor as Actor
    if abWairForReceive
        _OrgasmStarter_Received = true
    endif
    if UDmain.TraceAllowed()
        UDmain.Log("Receive_Orgasm received for " + fActor)
    endif
    
    bool loc_isplayer = UD_Native.IsPlayer(akActor)
    bool loc_isfollower = false
    
    if !loc_isplayer
        loc_isfollower = UDmain.ActorIsFollower(akActor)
    endif
    bool    loc_close                   = UDmain.ActorInCloseRange(akActor)
    bool    loc_is3Dloaded              = akActor.Is3DLoaded() || loc_isplayer
    int     loc_orgasmExhaustion        = UDOM.GetOrgasmExhaustion(akActor) + 1
    bool    loc_cond                    = loc_is3Dloaded && loc_close

    ;===========================
    ;            MESSAGE
    ;===========================

    float loc_forcing = OrgasmSystem.GetOrgasmVariable(akActor,6)
    int loc_force = 0
    if loc_forcing < 0.5
        loc_force = 0
    elseif loc_forcing < 1.0
        loc_force = 1
    else
        loc_force = 2
    endif

    bool loc_applytears = false
    if loc_force == 0
        if loc_isplayer
            UDmain.Print("You have brought yourself to orgasm.",2)
        elseif loc_cond
            UDmain.Print(getActorName(akActor) + " has brought "+GetPronounceSelf(akActor)+" to orgasm.",3)
        endif
    elseif loc_force == 1
        if loc_isplayer
            UDmain.Print("You are cumming!",2)
        elseif loc_cond
            UDmain.Print(getActorName(akActor) + " is cumming!",3)
        endif
    elseif loc_force > 1
        if loc_orgasmExhaustion >= 6
            loc_applytears = true
            if loc_isplayer
                UDmain.Print("You are losing your mind.")
            elseif loc_cond
                UDmain.Print("Orgasms are breaking " + getActorName(akActor) + "'s mind.")
            endif
        elseif loc_orgasmExhaustion >= 4
            loc_applytears = true
            if loc_isplayer
                UDmain.Print("Stimulations are making you orgasm nonstop.")
            elseif loc_cond
                UDmain.Print(getActorName(akActor) + " is orgasming nonstop.",3)
            endif
        elseif loc_orgasmExhaustion >= 3
            loc_applytears = true
            if loc_isplayer
                UDmain.Print("Constants orgasms barely let you catch a breath.")
            elseif loc_cond
                UDmain.Print(getActorName(akActor) + " can barely catch a breath from nonstop orgasms.",3)
            endif
        elseif RandomInt(1,99) < 15 
            loc_applytears = true
            if loc_isplayer
                UDmain.Print("Tears run down your cheeks as you are forced to orgasm.",2)
            elseif loc_cond
                UDmain.Print("Tears run down " + getActorName(akActor) + "'s cheeks as they are forced to orgasm.",3)
            endif
        else
            if loc_isplayer
                UDmain.Print("You are forced to orgasm!",2)
            elseif loc_cond
                UDmain.Print(getActorName(akActor) + " is forced to orgasm!",3)
            endif
        endif
    endif

    if loc_applytears && loc_cond
        UDCDmain.ApplyTearsEffect(akActor)
    endif
    
    if loc_cond
        int sID = libsp.OrgasmSound.Play(akActor)
        Sound.SetInstanceVolume(sid, libsp.Config.VolumeOrgasm)
        
        akActor.CreateDetectionEvent(akActor, 60 - 15*UDCDmain.getGaggedLevel(akActor))
    endif
    
    libsp.Aroused.UpdateActorOrgasmDate(akActor)
    
    if loc_orgasmExhaustion > 1
        UpdateMotivation(akActor, 30)
    endif
EndFunction
