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

    if TraceAllowed()    
        Log("UD_ParalelProcess ready!",0)
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
        UDCDmain.Error("Send_MinigameStarter wrong arg received!")
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
            UDCDmain.Error("Send_MinigameStarter("+udDevice.getDeviceHeader()+") timeout!")
        endif
    else
        UDCDmain.Error("Send_MinigameStarter("+udDevice.getDeviceHeader()+") error!")
    endif
    End_MinigameStarterMutex()
EndFunction
Function Receive_MinigameStarter(Form fActor)
    UD_CustomDevice_RenderScript loc_device = Send_MinigameStarter_Package_device
    Send_MinigameStarter_Package_device = none
    _MinigameStarter_Received           = true
    loc_device._MinigameParProc_1       = true
    
    Actor   akActor             = fActor as Actor
    Actor   akHelper            = loc_device.getHelper()
    bool    loc_canShowHUD      = loc_device.canShowHUD()
    bool    loc_haveplayer      = loc_device.PlayerInMinigame()
    bool    loc_updatewidget    = loc_device.UD_UseWidget && UDCDmain.UD_UseWidget && loc_haveplayer
    
    UDCDMain.StartMinigameDisable(akActor)
    if akHelper
        UDCDMain.StartMinigameDisable(akHelper)
    endif
    
    if loc_haveplayer
        UDCDmain.setCurrentMinigameDevice(loc_device)
        UDCDmain.MinigameKeysRegister()
    else
        StorageUtil.SetFormValue(akActor, "UD_currentMinigameDevice", loc_device.deviceRendered)
    endif
    
    loc_device._MinigameParProc_1 = false
    
    ;shows bars
    if loc_updatewidget
        loc_device.showWidget()
    endif
    if loc_canShowHUD
        loc_device.showHUDbars()
    endif
    
    loc_device.OnMinigameStart()
    
    libsp.pant(akActor)
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
        UDCDmain.Error("Send_MinigameParalel wrong arg received!")
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
            UDCDmain.Error("Send_MinigameParalel("+udDevice.getDeviceHeader()+") timeout!")
        endif
    else
        UDCDmain.Error("Send_MinigameParalel("+udDevice.getDeviceHeader()+") error!")
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
    ;start disable
    bool      loc_haveplayer = loc_device.PlayerInMinigame()
    
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
    
    Send_MinigameCritLoop(akActor,loc_device)

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
    Float loc_UpdateTime   = 0.25
    if !loc_haveplayer
        loc_UpdateTime = 1.0
    endif
    
    Float loc_ElapsedTime1 = 0.0
    Float loc_ElapsedTime2 = 0.0
    Float loc_ElapsedTime3 = 0.0
    
    while loc_device._MinigameMainLoop_ON; && UDCDmain.ActorInMinigame(akActor)
        if !loc_device.pauseMinigame
            ;set expression every 3 second
            if loc_ElapsedTime1 >= 3.0
                UDEM.ApplyExpressionRaw(akActor, loc_expression, 100,false,15)
                if loc_device.hasHelper()
                    UDEM.ApplyExpressionRaw(akHelper, loc_expression, 100,false,15)
                endif
                loc_ElapsedTime1 = 0.0
            endif
            ;update widget and HUD every 2 s
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
            if loc_ElapsedTime3 >= 3.0
                loc_device.advanceSkill(3.0)
                loc_updatewidget    = loc_device.UD_UseWidget && UDCDmain.UD_UseWidget && loc_haveplayer
                loc_canShowHUD      = loc_device.canShowHUD()
                loc_ElapsedTime3    = 0.0
            endif
        endif
        if loc_device._MinigameMainLoop_ON
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
    
    loc_device.hideHUDbars() ;hides HUD (not realy?)
    
    if loc_device.WearerIsPlayer() || loc_device.HelperIsPlayer()
        loc_device.hideWidget()
    endif
    
    UDEM.ResetExpressionRaw(akActor,15)
    if akHelper
        UDEM.ResetExpressionRaw(akHelper,15)
    endif
    
    loc_device.addStruggleExhaustion(akActor,akHelper)
EndFunction


;paralel
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
        UDCDmain.Error("Send_MinigameCritLoop wrong arg received!")
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
            UDCDmain.Error("Send_MinigameCritLoop("+udDevice.getDeviceHeader()+") timeout!")
        endif
    else
        UDCDmain.Error("Send_MinigameCritLoop("+udDevice.getDeviceHeader()+") error!")
    endif
    End_MinigameCritLoopMutex()
EndFunction
Function Receive_MinigameCritloop(Form fActor)
    UD_CustomDevice_RenderScript loc_device = Send_MinigameCritLoop_Package_device
    Send_MinigameCritLoop_Package_device    = none
    _MinigameCritLoop_Received              = true
    Actor akActor                           = fActor as Actor
    
    loc_device._MinigameParProc_3           = true
    Bool loc_playerInMinigame = loc_device.PlayerInMinigame()

    Float loc_elapsedTime = 0.0
    Float loc_updateTime  = 0.25
    string critType = "random"
    if !loc_playerInMinigame
        loc_updateTime = 0.5
        critType = "NPC"
    elseif UDCDmain.UD_AutoCrit
        critType = "Auto"
    endif
    
    Utility.Wait(0.75) ;wait little time before starting crits
    
    ;process
    while loc_device._MinigameMainLoop_ON; && UDCDmain.ActorInMinigame(akActor)
        if !loc_device.pauseMinigame && !UDmain.IsMenuOpen()
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
        if loc_device._MinigameMainLoop_ON
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
        UDCDmain.Error("Send_Orgasm wrong arg received!")
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
                UDCDmain.Error("Send_Orgasm timeout!")
            endif
        endif
    else
        UDCDmain.Error("Send_Orgasm error!")
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
        UDCDmain.Log("Receive_Orgasm received for " + fActor)
    endif
    
    SendModEvent("DeviceActorOrgasm", akActor.GetLeveledActorBase().GetName())
    
    if !UDCDmain.isRegistered(akActor) && UDmain.UD_OrgasmExhaustion
        UDmain.addOrgasmExhaustion(akActor)
    endif
    
    bool loc_isplayer = UDmain.ActorIsPlayer(akActor)
    bool loc_isfollower = false
    
    if !loc_isplayer
        loc_isfollower = UDmain.ActorIsFollower(akActor)
    endif
    bool    loc_close                   = UDmain.ActorInCloseRange(akActor)
    bool    loc_is3Dloaded              = akActor.Is3DLoaded() || UDmain.ActorIsPlayer(akActor)
    int     loc_orgasmExhaustion        = UDOM.GetOrgasmExhaustion(akActor) + 1
    bool    loc_cond                    = loc_is3Dloaded && loc_close

    ;===========================
    ;            MESSAGE
    ;===========================
    int loc_orgexh = UDOM.GetOrgasmExhaustion(akActor) + 1
    ;float loc_forcing = StorageUtil.getFloatValue(akActor, "UD_OrgasmForcing",0.0)
    bool loc_applytears = false
    if iForce == 0
        if loc_isplayer
            UDCDmain.Print("You have brought yourself to orgasm",2)
        elseif loc_cond
            UDCDmain.Print(getActorName(akActor) + " have brought themself to orgasm",3)
        endif
    elseif iForce == 1
        if loc_isplayer
            UDCDmain.Print("You are cumming!",2)
        elseif loc_cond
            UDCDmain.Print(getActorName(akActor) + " is cumming!",3)
        endif
    elseif iForce > 1
        if loc_orgexh >= 6
            loc_applytears = true
            if loc_isplayer
                UDCDmain.Print("You are losing your mind")
            elseif loc_cond
                UDCDmain.Print("Orgasms are breaking " + getActorName(akActor) + "s mind")
            endif
        elseif loc_orgexh >= 4
            loc_applytears = true
            if loc_isplayer
                UDCDmain.Print("Stimulations are making you orgasm nonstop")
            elseif loc_cond
                UDCDmain.Print(getActorName(akActor) + " are orgasming nonstop",3)
            endif
        elseif loc_orgexh >= 3
            loc_applytears = true
            if loc_isplayer
                UDCDmain.Print("Constants orgasms barely let you catch a breath")
            elseif loc_cond
                UDCDmain.Print(getActorName(akActor) + " can barely catch a breath from nonstop climax",3)
            endif
        elseif Utility.randomInt(1,99) < 15 
            loc_applytears = true
            if loc_isplayer
                UDCDmain.Print("Tears run down your cheeks as you are forced to orgasm",2)
            elseif loc_cond
                UDCDmain.Print("Tears run down " + getActorName(akActor) + "s cheeks as they are forced to orgasm",3)
            endif
        else
            if loc_isplayer
                UDCDmain.Print("You are forced to orgasm!",2)
            elseif loc_cond
                UDCDmain.Print(getActorName(akActor) + " is forced to orgasm!",3)
            endif
        endif
    endif

    if loc_is3Dloaded && loc_close
        if loc_orgasmExhaustion == 1
            UDEM.ApplyExpressionRaw(akActor, UDEM.GetPrebuildExpression_Orgasm2(), 75,false,50)
        elseif loc_orgasmExhaustion < 3
            UDEM.ApplyExpressionRaw(akActor, UDEM.GetPrebuildExpression_Orgasm1(), 100,false,80)
        else
            UDEM.ApplyExpressionRaw(akActor, UDEM.GetPrebuildExpression_Orgasm3(), 100,false,80)
        endif
    endif  
    
    if loc_applytears
        UDCDmain.ApplyTearsEffect(akActor)
    endif
    
    if loc_is3Dloaded && loc_close
        int sID = libsp.OrgasmSound.Play(akActor)
        Sound.SetInstanceVolume(sid, libsp.Config.VolumeOrgasm)
        
        akActor.CreateDetectionEvent(akActor, 60 - 15*UDCDmain.getGaggedLevel(akActor))
    endif
    
    libsp.Aroused.UpdateActorOrgasmDate(akActor)
    
    if loc_orgexh > 1
        UpdateMotivation(akActor, 30)
    endif
    
    UDOM.SetHornyProgress(akActor,0.0)
    UDOM.UpdateHornyLevel(akActor,-1) ;decrease horny level by 1
EndFunction

;========================
;          UTILITY
;========================

bool Function TraceAllowed()    
    return UDmain.TraceAllowed()
EndFunction
Function Log(String msg, int level = 1)
    UDmain.Log(msg,level)
EndFunction
Function Error(String msg)
    UDCDMain.Error(msg)
EndFunction
Function Print(String strMsg, int iLevel = 1,bool bLog = false)
    UDmain.Print(strMsg,iLevel,bLog)
EndFunction