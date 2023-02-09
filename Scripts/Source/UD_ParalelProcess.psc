Scriptname UD_ParalelProcess extends Quest

import UnforgivingDevicesMain
import UD_NPCInteligence

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
    RegisterForModEvent(    "UDMinigameStarter"        , "Receive_MinigameStarter"        )
    RegisterForModEvent(    "UDMinigameParalel"        , "Receive_MinigameParalel"        )
    RegisterForModEvent(    "UDOrgasmParalel"        , "Receive_Orgasm"                )
    RegisterForModEvent(    "UDMinigameCritLoop"    , "Receive_MinigameCritLoop"    )
EndFunction

;==============================
;           MINIGAME
;==============================
;vars
bool _MinigameStarterMutex = false

;mutex
Function Start_MinigameStarterMutex()
    while _MinigameStarterMutex
        Utility.waitMenuMode(0.05)
    endwhile
    _MinigameStarterMutex = true
EndFunction

Function End_MinigameStarterMutex()
    _MinigameStarterMutex = false
EndFunction

;starter
bool _MinigameStarter_Received = false
UD_CustomDevice_RenderScript Send_MinigameStarter_Package_device

Function Send_MinigameStarter(Actor akActor,UD_CustomDevice_RenderScript udDevice)
    if !akActor || !udDevice
        UDmain.Error("Send_MinigameStarter wrong arg received!")
    endif
    
    Start_MinigameStarterMutex()
    _MinigameStarter_Received = false
    
    ;send event
    int handle = ModEvent.Create("UDMinigameStarter")
    if (handle)
        Send_MinigameStarter_Package_device = udDevice
        ModEvent.PushForm(handle, akActor)
        ModEvent.Send(handle)
        
        ;block
        float loc_TimeOut = 0.0
        while !_MinigameStarter_Received && loc_TimeOut <= 2.0
            loc_TimeOut += 0.05
            Utility.waitMenuMode(0.05)
        endwhile
        _MinigameStarter_Received = false
        
        if loc_TimeOut >= 2.0
            UDmain.Error("Send_MinigameStarter("+udDevice.getDeviceHeader()+") timeout!")
        endif
    else
        UDmain.Error("Send_MinigameStarter("+udDevice.getDeviceHeader()+") UDmain.Error!")
    endif
    End_MinigameStarterMutex()
EndFunction
Function Receive_MinigameStarter(Form fActor)
    UD_CustomDevice_RenderScript loc_device = Send_MinigameStarter_Package_device
    Send_MinigameStarter_Package_device = none
    _MinigameStarter_Received           = true
    loc_device._MinigameParProc_1       = true
    loc_device.MinigameStarter()
EndFunction

;paralel
;vars
bool _MinigameParalelMutex = false
;mutex
Function Start_MinigameParalelMutex()
    while _MinigameParalelMutex
        Utility.waitMenuMode(0.05)
    endwhile
    _MinigameParalelMutex = true
EndFunction

Function End_MinigameParalelMutex()
    _MinigameParalelMutex = false
EndFunction
bool _MinigameParalel_Received = false
UD_CustomDevice_RenderScript Send_MinigameParalel_Package_device
Function Send_MinigameParalel(Actor akActor,UD_CustomDevice_RenderScript udDevice)
    if !akActor || !udDevice
        UDmain.Error("Send_MinigameParalel wrong arg received!")
    endif
    
    Start_MinigameParalelMutex()
    _MinigameParalel_Received = false
    
    ;send event
    int handle = ModEvent.Create("UDMinigameParalel")
    if (handle)
        Send_MinigameParalel_Package_device = udDevice
        ModEvent.PushForm(handle, akActor)
        ModEvent.Send(handle)
        
        ;block
        float loc_TimeOut = 0.0
        while !_MinigameParalel_Received && loc_TimeOut <= 2.0
            loc_TimeOut += 0.05
            Utility.waitMenuMode(0.05)
        endwhile
        _MinigameParalel_Received = false
        
        if loc_TimeOut >= 2.0
            UDmain.Error("Send_MinigameParalel("+udDevice.getDeviceHeader()+") timeout!")
        endif
    else
        UDmain.Error("Send_MinigameParalel("+udDevice.getDeviceHeader()+") UDmain.Error!")
    endif
    End_MinigameParalelMutex()
EndFunction
Function Receive_MinigameParalel(Form fActor)
    UD_CustomDevice_RenderScript loc_device = Send_MinigameParalel_Package_device
    Send_MinigameParalel_Package_device = none
    _MinigameParalel_Received           = true
    
    Actor     akActor       = fActor as Actor
    Actor     akHelper      = loc_device.getHelper()
    
    loc_device._MinigameParProc_2 = true
    
    ;process
    bool      loc_haveplayer    = loc_device.PlayerInMinigame()
    bool      loc_is3DLoaded    = akActor.Is3DLoaded() || loc_haveplayer
    
    ;disable regen of all stats
    float staminaRate           = akActor.getBaseAV("StaminaRate")
    float HealRate              = akActor.getBaseAV("HealRate")
    float magickaRate           = akActor.getBaseAV("MagickaRate")

    akActor.setAV("StaminaRate", staminaRate*loc_device.UD_RegenMag_Stamina)
    akActor.setAV("HealRate", HealRate*loc_device.UD_RegenMag_Health)
    akActor.setAV("MagickaRate", magickaRate*loc_device.UD_RegenMag_Magicka)

    float staminaRateHelper     = 0.0
    float HealRateHelper        = 0.0
    float magickaRateHelper     = 0.0
    if akHelper
        staminaRateHelper       = akHelper.getBaseAV("StaminaRate")
        HealRateHelper          = akHelper.getBaseAV("HealRate")
        magickaRateHelper       = akHelper.getBaseAV("MagickaRate")

        akHelper.setAV("StaminaRate", staminaRateHelper*loc_device.UD_RegenMagHelper_Stamina)
        akHelper.setAV("HealRate"    , HealRateHelper*loc_device.UD_RegenMagHelper_Health)
        akHelper.setAV("MagickaRate", magickaRateHelper*loc_device.UD_RegenMagHelper_Magicka)
    endif
    
    bool loc_canShowHUD     = loc_device.canShowHUD()
    bool loc_updatewidget   = loc_device.UD_UseWidget && UDCDmain.UD_UseWidget && loc_haveplayer
    
    Send_MinigameCritLoop(akActor, loc_device)

    float[] loc_expression = loc_device.GetCurrentMinigameExpression()
    UDEM.ApplyExpressionRaw(akActor, loc_expression, 100,false,15)
    if loc_device.hasHelper()
        UDEM.ApplyExpressionRaw(akHelper, loc_expression, 100,false,15)
    endif
    
    float loc_currentOrgasmRate     = loc_device.getStruggleOrgasmRate()
    float loc_currentArousalRate    = loc_device.getArousalRate()
    
    UDOM.UpdateOrgasmRate(akActor, loc_currentOrgasmRate,0.25)
    UDOM.UpdateArousalRate(akActor,loc_currentArousalRate)
    
    ;pause thred untill minigame end
    Float loc_UpdateTime   = 0.1
    if !loc_is3DLoaded
        loc_UpdateTime = 3.0
    elseif !loc_haveplayer
        loc_UpdateTime = 1.0
    endif
    
    Float loc_ElapsedTime1 = 0.0
    Float loc_ElapsedTime2 = 0.0
    Float loc_ElapsedTime3 = 0.0
    
    while loc_device.IsMinigameLoopRunning()
        if !loc_device.isPaused()
            ;set expression every 5 second
            if loc_is3DLoaded
                if loc_ElapsedTime1 >= 5.0
                    UDEM.ApplyExpressionRaw(akActor, loc_expression, 100,false,15)
                    if akHelper
                        UDEM.ApplyExpressionRaw(akHelper, loc_expression, 100,false,15)
                    endif
                    loc_ElapsedTime1 = 0.0
                endif
            endif
            ;update widget and HUD every 2 s
            if loc_haveplayer
                if loc_ElapsedTime2 >= 2.0
                    if loc_canShowHUD
                        loc_device.showHUDbars(False)
                    endif         
                    if loc_updatewidget
                        loc_device.showWidget(false,true)
                    endif
                    loc_ElapsedTime2 = 0.0
                endif
                ;advance skill every 3 second
                if loc_ElapsedTime3 >= 1.0
                    loc_device.advanceSkill(1.0)
                    if loc_is3DLoaded
                        loc_updatewidget    = loc_device.UD_UseWidget && UDCDmain.UD_UseWidget && loc_haveplayer
                        loc_canShowHUD      = loc_device.canShowHUD()
                    endif
                    loc_ElapsedTime3    = 0.0
                endif
            endif
        endif
        if loc_device.IsMinigameLoopRunning()
            Utility.wait(loc_UpdateTime)
            loc_ElapsedTime1 += loc_UpdateTime
            loc_ElapsedTime2 += loc_UpdateTime
            loc_ElapsedTime3 += loc_UpdateTime
        endif
    endwhile
    
    UDOM.UpdateOrgasmRate(akActor, -1*loc_currentOrgasmRate,-0.25)
    UDOM.UpdateArousalRate(akActor,-1*loc_currentArousalRate)
    
    ;returns wearer regen
    akActor.setAV("StaminaRate", staminaRate)
    akActor.setAV("HealRate", healRate)
    akActor.setAV("MagickaRate", magickaRate)
    if akHelper
        akHelper.setAV("StaminaRate", staminaRateHelper)
        akHelper.setAV("HealRate", HealRateHelper)
        akHelper.setAV("MagickaRate", magickaRateHelper)
    endif
    
    loc_device._MinigameParProc_2 = false
    
    if loc_haveplayer
        loc_device.hideHUDbars() ;hides HUD (not realy?)
        
        if loc_device.WearerIsPlayer() || loc_device.HelperIsPlayer()
            loc_device.hideWidget()
        endif
    endif
    
    if loc_is3DLoaded
        UDEM.ResetExpressionRaw(akActor,15)
        if akHelper
            UDEM.ResetExpressionRaw(akHelper,15)
        endif
    endif
    
    if loc_is3DLoaded && (UDmain.UDGV.UDG_MinigameExhaustion.Value == 1)
        loc_device.addStruggleExhaustion(akActor,akHelper)
    endif
EndFunction


;crit
;vars
bool                             _MinigameCritLoopMutex                     = false
bool                             _MinigameCritLoop_Received                 = false
UD_CustomDevice_RenderScript     Send_MinigameCritLoop_Package_device       = none
;mutex
Function Start_MinigameCritLoopMutex()
    while _MinigameCritLoopMutex
        Utility.waitMenuMode(0.25)
    endwhile
    _MinigameCritLoopMutex = true
EndFunction

Function End_MinigameCritLoopMutex()
    _MinigameCritLoopMutex = false
EndFunction

Function Send_MinigameCritLoop(Actor akActor,UD_CustomDevice_RenderScript udDevice)
    if !akActor || !udDevice
        UDmain.Error("Send_MinigameCritLoop wrong arg received!")
    endif
    
    Start_MinigameCritLoopMutex()
    _MinigameCritLoop_Received = false
    
    ;send event
    int handle = ModEvent.Create("UDMinigameCritLoop")
    if (handle)
        Send_MinigameCritLoop_Package_device = udDevice
        ModEvent.PushForm(handle, akActor)
        ModEvent.Send(handle)
        
        ;block
        float loc_TimeOut = 0.0
        while !_MinigameCritLoop_Received && loc_TimeOut <= 2.0
            loc_TimeOut += 0.1
            Utility.waitMenuMode(0.1)
        endwhile
        _MinigameCritLoop_Received = false
        
        if loc_TimeOut >= 2.0
            UDmain.Error("Send_MinigameCritLoop("+udDevice.getDeviceHeader()+") timeout!")
        endif
    else
        UDmain.Error("Send_MinigameCritLoop("+udDevice.getDeviceHeader()+") UDmain.Error!")
    endif
    End_MinigameCritLoopMutex()
EndFunction
Function Receive_MinigameCritloop(Form fActor)
    UD_CustomDevice_RenderScript loc_device = Send_MinigameCritLoop_Package_device
    Send_MinigameCritLoop_Package_device    = none
    _MinigameCritLoop_Received              = true
    Actor akActor                           = fActor as Actor
    
    loc_device._MinigameParProc_3           = true
    Bool loc_playerInMinigame               = loc_device.PlayerInMinigame()
    Bool loc_is3DLoaded                     = akActor.Is3DLoaded() || loc_playerInMinigame

    Float loc_elapsedTime = 0.0
    Float loc_updateTime  = 0.25
    string critType = "random"
    if !loc_playerInMinigame
        loc_updateTime = 1.0
        critType = "NPC"
    elseif UDCDmain.UD_AutoCrit
        critType = "Auto"
    endif
    
    if loc_playerInMinigame
        Utility.Wait(0.5) ;wait little time before starting crits
    endif
    
    ;process
    while loc_device.IsMinigameLoopRunning()
        if !loc_device.isPaused() && (!loc_is3DLoaded || !UDmain.IsMenuOpen())
            ;check crit every 1 s
            if loc_elapsedTime >= 1.0
                if loc_device.UD_minigame_canCrit
                    UDCDmain.StruggleCritCheck(loc_device,loc_device.UD_StruggleCritChance,critType,loc_device.UD_StruggleCritDuration)
                elseif loc_device._customMinigameCritChance
                    UDCDmain.StruggleCritCheck(loc_device,loc_device._customMinigameCritChance,critType,loc_device._customMinigameCritDuration)
                endif
                loc_elapsedTime = 0.0
            endif
        endif
        if loc_device.IsMinigameLoopRunning()
            Utility.Wait(loc_updateTime)
            loc_elapsedTime += loc_updateTime
        endif
    endwhile
    
    loc_device._MinigameParProc_3 = false
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

Function Send_Orgasm(Actor akActor,int iDuration,int iDecreaseArousalBy, int iForce,bool bForceAnimation,bool bWairForReceive = false)
    if !akActor
        UDmain.Error("Send_Orgasm wrong arg received!")
    endif
    
    if bWairForReceive
        Start_OrgasmMutex()
        _OrgasmStarter_Received = false
    endif
    
    ;send event
    int handle = ModEvent.Create("UDOrgasmParalel")
    if (handle)
        ModEvent.PushForm(handle, akActor)
        ModEvent.PushInt(handle, iDuration)
        ModEvent.PushInt(handle, iDecreaseArousalBy)
        ModEvent.PushInt(handle, iForce)
        ModEvent.PushInt(handle, bForceAnimation as int)
        ModEvent.PushInt(handle, bWairForReceive as int)
        ModEvent.Send(handle)
        
        ;block
        if bWairForReceive
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
    if bWairForReceive
        End_OrgasmMutex()
    endif
EndFunction
Function Receive_Orgasm(Form fActor,int iDuration,int iDecreaseArousalBy,int iForce,int bForceAnimation,int bWairForReceive)
    Actor akActor = fActor as Actor
    if bWairForReceive
        _OrgasmStarter_Received = true
    endif
    if UDmain.TraceAllowed()
        UDmain.Log("Receive_Orgasm received for " + fActor)
    endif
    
    bool loc_isplayer = UDmain.ActorIsPlayer(akActor)
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
    ;float loc_forcing = StorageUtil.getFloatValue(akActor, "UD_OrgasmForcing",0.0)
    bool loc_applytears = false
    if iForce == 0
        if loc_isplayer
            UDmain.Print("You have brought yourself to orgasm",2)
        elseif loc_cond
            UDmain.Print(getActorName(akActor) + " have brought themself to orgasm",3)
        endif
    elseif iForce == 1
        if loc_isplayer
            UDmain.Print("You are cumming!",2)
        elseif loc_cond
            UDmain.Print(getActorName(akActor) + " is cumming!",3)
        endif
    elseif iForce > 1
        if loc_orgasmExhaustion >= 6
            loc_applytears = true
            if loc_isplayer
                UDmain.Print("You are losing your mind")
            elseif loc_cond
                UDmain.Print("Orgasms are breaking " + getActorName(akActor) + "s mind")
            endif
        elseif loc_orgasmExhaustion >= 4
            loc_applytears = true
            if loc_isplayer
                UDmain.Print("Stimulations are making you orgasm nonstop")
            elseif loc_cond
                UDmain.Print(getActorName(akActor) + " are orgasming nonstop",3)
            endif
        elseif loc_orgasmExhaustion >= 3
            loc_applytears = true
            if loc_isplayer
                UDmain.Print("Constants orgasms barely let you catch a breath")
            elseif loc_cond
                UDmain.Print(getActorName(akActor) + " can barely catch a breath from nonstop climax",3)
            endif
        elseif Utility.randomInt(1,99) < 15 
            loc_applytears = true
            if loc_isplayer
                UDmain.Print("Tears run down your cheeks as you are forced to orgasm",2)
            elseif loc_cond
                UDmain.Print("Tears run down " + getActorName(akActor) + "s cheeks as they are forced to orgasm",3)
            endif
        else
            if loc_isplayer
                UDmain.Print("You are forced to orgasm!",2)
            elseif loc_cond
                UDmain.Print(getActorName(akActor) + " is forced to orgasm!",3)
            endif
        endif
    endif

    if loc_cond
        if loc_orgasmExhaustion == 1
            UDEM.ApplyExpressionRaw(akActor, UDEM.GetPrebuildExpression_Orgasm2(), 75,false,80)
        elseif loc_orgasmExhaustion < 3
            UDEM.ApplyExpressionRaw(akActor, UDEM.GetPrebuildExpression_Orgasm1(), 100,false,80)
        else
            UDEM.ApplyExpressionRaw(akActor, UDEM.GetPrebuildExpression_Orgasm3(), 100,false,80)
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
    
    UDOM.SetHornyProgress(akActor,0.0)
    UDOM.UpdateHornyLevel(akActor,-1) ;decrease horny level by 1
EndFunction