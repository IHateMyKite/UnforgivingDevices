Scriptname UD_OrchamsCheckScript_AME extends activemagiceffect 

import UnforgivingDevicesMain

UDCustomDeviceMain Property UDCDmain auto
UD_OrgasmManager Property UDOM 
    UD_OrgasmManager Function get()
        return UDCDmain.UDOM
    EndFunction
EndProperty
UD_ExpressionManager Property UDEM 
    UD_ExpressionManager Function get()
        return UDCDmain.UDEM
    EndFunction
EndProperty
UnforgivingDevicesMain Property UDmain
    UnforgivingDevicesMain Function get()
        return UDCDmain.UDmain
    EndFunction
EndProperty
zadlibs Property libs auto

Actor akActor = none
bool _finished = false
bool _processing = false
MagicEffect _MagickEffect = none

;local variables
float   loc_currentUpdateTime       = 1.0
bool    loc_widgetShown             = false
bool    loc_forceStop               = false
bool    loc_actorinminigame         = false
float   loc_forcing                 = 0.0
float   loc_orgasmRate              = 0.0
float   loc_orgasmRate2             = 0.0
float   loc_orgasmRateAnti          = 0.0
float   loc_orgasmResistMultiplier  = 1.0
float   loc_orgasmRateMultiplier    = 1.0
int     loc_arousal                 = 0
int     loc_tick                    = 1
int     loc_tickS                   = 0
int     loc_expressionUpdateTimer   = 0
bool    loc_orgasmResisting         = false
bool    loc_orgasmResisting2        = false
bool    loc_expressionApplied       = false
float   loc_orgasmCapacity          = 100.0
float   loc_orgasmResistence        = 2.5    
float   loc_orgasmProgress          = 0.0
float   loc_orgasmProgress2         = 0.0
float   loc_orgasmProgress_p        = 0.0
int     loc_orgasms                 = 0
int     loc_hornyAnimTimer          = 0
bool[]  loc_cameraState
int     loc_msID                    = -1
float   loc_edgeprogress            = 0.0
int     loc_edgelevel               = 0
sslBaseExpression expression
float[] loc_expression
float[] loc_expression2
float[] loc_expression3

bool    loc_isplayer = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
    akActor = akTarget
    akActor.AddToFaction(UDOM.OrgasmCheckLoopFaction)
    loc_isplayer = UDmain.ActorIsPlayer(akActor)
    if loc_isplayer && UDmain.TraceAllowed() ;only for player, because it works different for NPCs
        UDCDmain.Log("UD_OrchamsCheckScript_AME("+GetActorName(akActor)+") - OnEffectStart()",2)
    endif
    _MagickEffect   = GetBaseObject()
    loc_expression  = UDEM.GetPrebuildExpression_Horny1()
    loc_expression2 = UDEM.GetPrebuildExpression_Happy1()
    loc_expression3 = UDEM.GetPrebuildExpression_Angry1()
    
    if loc_isplayer
        loc_currentUpdateTime = UDOM.UD_OrgasmUpdateTime
    else
        loc_currentUpdateTime = 1.0
    endif
    
    ;init local variables
    loc_widgetShown             = false
    loc_forceStop               = false
    loc_orgasmRate              = 0.0
    loc_orgasmRate2             = 0.0
    loc_orgasmRateAnti          = 0.0
    loc_orgasmResistMultiplier  = UDOM.getActorOrgasmResistMultiplier(akActor)
    loc_orgasmRateMultiplier    = UDOM.getActorOrgasmRateMultiplier(akActor)
    loc_arousal                 = UDOM.getArousal(akActor)
    loc_forcing                 = UDOM.getActorOrgasmForcing(akActor)
    loc_tick                    = 1
    loc_tickS                   = 0
    loc_expressionUpdateTimer   = 0
    loc_orgasmResisting         = akActor.isInFaction(UDOM.OrgasmResistFaction)
    loc_orgasmResisting2        = false
    loc_expressionApplied       = false
    loc_orgasmCapacity          = UDOM.getActorOrgasmCapacity(akActor)
    loc_orgasmResistence        = UDOM.getActorOrgasmResist(akActor)
    loc_orgasmProgress          = StorageUtil.GetFloatValue(akActor, "UD_OrgasmProgress",0.0)
    loc_orgasmProgress2         = 0.0
    loc_orgasmProgress_p        = loc_orgasmProgress/loc_orgasmCapacity
    loc_hornyAnimTimer          = 0
    loc_msID                    = -1
    loc_orgasms                 = 0
    loc_actorinminigame         = UDCDMain.actorInMinigame(akActor)
    registerForSingleUpdate(0.1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    _finished = true
    if UDmain.TraceAllowed() && loc_isplayer
        UDCDmain.Log("UD_OrchamsCheckScript_AME("+GetActorName(akActor)+") - OnEffectFinish()",1)
    endif
    
    float loc_elapsedtime = 0.0
    while _processing && loc_elapsedtime <= 5.0 ;wait for update function to end
        Utility.waitmenumode(0.1)
        loc_elapsedtime += 0.1
    endwhile
    
    ;stop moan sound
    if loc_msID != -1
        Sound.StopInstance(loc_msID)
    endif
    
    ;end animation if it still exist
    if  loc_hornyAnimTimer > 0
        libs.EndThirdPersonAnimation(akActor, loc_cameraState, permitRestrictive=true)
        loc_hornyAnimTimer = 0
    EndIf
    
    ;hide widget
    if loc_widgetShown
        UDCDmain.toggleWidget2(false)
    endif
    
    ;reset expression
    UDEM.ResetExpressionRaw(akActor, 10)
    
    ;end mutex
    akActor.RemoveFromFaction(UDOM.OrgasmCheckLoopFaction)
EndEvent

Function Update()
    if !loc_expression
        loc_expression = UDEM.GetPrebuildExpression_Horny1()
    endif
    if !loc_expression2
        loc_expression2 = UDEM.GetPrebuildExpression_Happy1()
    endif
    if !loc_expression3
        loc_expression3 = UDEM.GetPrebuildExpression_Angry1()
    endif
    if IsRunning()
        akActor.AddToFaction(UDOM.OrgasmCheckLoopFaction)
    endif
    loc_isplayer = UDmain.ActorIsPlayer(akActor)
EndFunction

Event OnUpdate()
    _processing = true
    if IsRunning()
        if UDOM.OrgasmLoopBreak(akActor, UDOM.UD_OrgasmCheckLoop_ver) ;!UDCDmain.isRegistered(akActor) && !akActor.isDead()
            GInfo("UD_OrchamsCheckScript_AME("+GetActorName(akActor)+") - OrgasmLoopBreak -> dispeling")
            akActor.DispelSpell(UDCDmain.UDlibs.OrgasmCheckSpell)
        else
            ;Update()
            loc_orgasmProgress2 = loc_orgasmProgress
            
            loc_orgasmResisting = akActor.isInFaction(UDOM.OrgasmResistFaction)
            if loc_orgasmResisting
                loc_orgasmResisting2    = true
                loc_orgasmProgress      = UDOM.getActorOrgasmProgress(akActor)
            else
                if loc_orgasmResisting2
                    loc_orgasmResisting2            = false
                    loc_arousal                     = UDOM.getArousal(akActor)
                    loc_orgasmRate                  = UDOM.getActorOrgasmRate(akActor)
                    loc_orgasmRateMultiplier        = UDOM.getActorOrgasmRateMultiplier(akActor)
                    loc_orgasmResistMultiplier      = UDOM.getActorOrgasmResistMultiplier(akActor)
                    loc_orgasms                     = UDOM.getOrgasmingCount(akActor)
                    loc_actorinminigame             = UDCDMain.actorInMinigame(akActor)
                    UDOM.SetActorOrgasmProgress(akActor,loc_orgasmProgress)
                endif
                loc_orgasmProgress += loc_orgasmRate*loc_orgasmRateMultiplier*loc_currentUpdateTime
            endif
            
            loc_orgasmRateAnti = UDOM.CulculateAntiOrgasmRateMultiplier(loc_arousal)*loc_orgasmResistMultiplier*(loc_orgasmProgress*(loc_orgasmResistence/100.0))*loc_currentUpdateTime  ;edging, orgasm rate needs to be bigger then UD_OrgasmResistence, else actor will not reach orgasm
            
            if !loc_orgasmResisting
                if loc_orgasmRate*loc_orgasmRateMultiplier > 0.0
                    loc_orgasmProgress -= loc_orgasmRateAnti
                else
                    loc_orgasmProgress -= 3*loc_orgasmRateAnti
                endif
            endif
            
            ;proccess edge
            loc_edgeprogress += fRange(loc_orgasmRate*loc_orgasmRateMultiplier*loc_currentUpdateTime - loc_orgasmRateAnti,0.0,100.0)
            
            loc_orgasmProgress_p = fRange(loc_orgasmProgress/loc_orgasmCapacity,0.0,1.0) ;update relative orgasm progress
            
            if loc_widgetShown && !loc_orgasmResisting
                UDCDMain.widget2.SetPercent(loc_orgasmProgress_p)
            endif

            ;check orgasm
            if loc_orgasmProgress_p > 0.99
                if UDmain.TraceAllowed()            
                    UDCDmain.Log("Starting orgasm for " + getActorName(akActor))
                endif
                if loc_orgasmResisting
                    akActor.RemoveFromFaction(UDOM.OrgasmResistFaction)
                endif
                
                if loc_widgetShown
                    loc_widgetShown = false
                    UDCDMain.toggleWidget2(false)
                    UDCDmain.widget2.SetPercent(0.0,true)
                endif
                
                loc_hornyAnimTimer  = -45 ;cooldown
                
                Int loc_force = 0
                if loc_forcing < 0.5
                    loc_force = 0
                elseif loc_forcing < 1.0
                    loc_force = 1
                else
                    loc_force = 2
                endif
                
                SendOrgasmEvent()
                UDOM.startOrgasm(akActor,UDOM.UD_OrgasmDuration,UDOM.UD_OrgasmArousalReduce,loc_force,true)
                
                Utility.wait(3.0) ;wait, so orgasm variables can be updated
                
                loc_orgasmProgress = 0.0
                UDOM.SetActorOrgasmProgress(akActor,loc_orgasmProgress)
                
                loc_edgeprogress    = 0.0
                loc_edgelevel       = 0 
            else
                ;check edge
                if loc_edgeprogress >= 3.0*loc_orgasmCapacity
                    loc_edgelevel      += 1
                    loc_edgeprogress    = 0.0
                    if loc_isplayer
                        if loc_edgelevel == 1
                            UDmain.Print("You feel incredibly horny")
                        elseif loc_edgelevel == 2
                            UDmain.Print("You want to cum")
                        elseif loc_edgelevel == 3
                            UDmain.Print("You want to cum badly")
                        elseif loc_edgelevel == 4
                            UDmain.Print("You would do anythink for orgasm")
                        else
                            UDmain.Print("Unending pleasure is driving you crazy!")
                        endif
                    endif
                endif
                SendEdgeEvent()
            endif
            
            if loc_tick * loc_currentUpdateTime >= 1.0
                loc_orgasmRate2 = loc_orgasmRate
                if loc_isplayer
                    loc_currentUpdateTime = UDOM.UD_OrgasmUpdateTime
                endif
                
                loc_tick = 0
                loc_tickS += 1
                loc_edgeprogress -= 1.0*fRange(100 - loc_arousal/100,0.01,1.0)
                
                int loc_switch = (loc_tickS % 3)
                if loc_switch == 0
                    loc_orgasmCapacity              = UDOM.getActorOrgasmCapacity(akActor)
                elseif loc_switch == 1
                    loc_orgasmResistence            = UDOM.getActorOrgasmResist(akActor)
                else
                    loc_forcing                     = UDOM.getActorOrgasmForcing(akActor)
                endif
                
                if !loc_orgasmResisting
                    loc_arousal                 = UDOM.getArousal(akActor)
                    loc_orgasmRate              = UDOM.getActorOrgasmRate(akActor)
                    loc_orgasmRateMultiplier    = UDOM.getActorOrgasmRateMultiplier(akActor)
                    loc_orgasmResistMultiplier  = UDOM.getActorOrgasmResistMultiplier(akActor)
                    loc_orgasms                 = UDOM.getOrgasmingCount(akActor)
                    loc_actorinminigame         = UDCDMain.actorInMinigame(akActor)
                    UDOM.SetActorOrgasmProgress(akActor,loc_orgasmProgress)
                endif

                ;expression
                if loc_orgasmRate >= loc_orgasmResistence*0.75 && (!loc_expressionApplied || loc_expressionUpdateTimer > 5) 
                    ;init expression
                    if loc_edgelevel == 0
                        UDEM.ApplyExpressionRaw(akActor, loc_expression, iRange(Round(loc_orgasmProgress),75,100),false,10)
                    elseif loc_edgelevel > 0 && loc_edgelevel < 3
                        UDEM.ApplyExpressionRaw(akActor, loc_expression2, 75,false,10)
                    else
                        UDEM.ApplyExpressionRaw(akActor, loc_expression3, 50,false,10)
                    endif
                    
                    loc_expressionApplied = true
                    loc_expressionUpdateTimer = 0
                elseif loc_orgasmRate < loc_orgasmResistence*0.75 && loc_expressionApplied
                    UDEM.ResetExpressionRaw(akActor,10)
                    loc_expressionApplied = false
                endif
                
                ;can play horny animation ?
                if (loc_orgasmRate > 0.5*loc_orgasmResistMultiplier*loc_orgasmResistence) 
                    ;start moaning sound again. Not play when actor orgasms
                    if loc_msID == -1 && !loc_orgasms && !loc_actorinminigame
                        loc_msID = libs.MoanSound.Play(akActor)
                        Sound.SetInstanceVolume(loc_msID, fRange(loc_orgasmProgress_p*2.0,0.75,1.0)*libs.GetMoanVolume(akActor,loc_arousal))
                    endif
                else
                    ;disable moaning sound when orgasm rate is too low
                    if loc_msID != -1
                        Sound.StopInstance(loc_msID)
                        loc_msID = -1
                    endif
                endif
                if !loc_actorinminigame
                    if (loc_orgasmRate > 0.5*loc_orgasmResistMultiplier*loc_orgasmResistence) && !loc_orgasmResisting && !akActor.IsInCombat() ;orgasm progress is increasing
                        if (loc_hornyAnimTimer == 0) && !libs.IsAnimating(akActor) && UDOM.UD_HornyAnimation ;start horny animation for UD_HornyAnimationDuration
                            if Utility.RandomInt() <= (Math.ceiling(100/fRange(loc_orgasmProgress,15.0,100.0))) 
                                ; Select animation
                                loc_cameraState = libs.StartThirdPersonAnimation(akActor, libs.AnimSwitchKeyword(akActor, "Horny01"), permitRestrictive=true)
                                loc_hornyAnimTimer += UDOM.UD_HornyAnimationDuration
                            endif
                        EndIf
                    endif
                    
                    if !loc_orgasmResisting
                        if loc_hornyAnimTimer > 0 ;reduce horny animation timer 
                            loc_hornyAnimTimer -= 1
                            if (loc_hornyAnimTimer == 0)
                                libs.EndThirdPersonAnimation(akActor, loc_cameraState, permitRestrictive=true)
                                loc_hornyAnimTimer = -20 ;cooldown
                            EndIf
                        elseif loc_hornyAnimTimer < 0 ;cooldown
                            loc_hornyAnimTimer += 1
                        endif
                    endif
                endif
                
                if UDOM.UD_UseOrgasmWidget && loc_isplayer
                    if (loc_widgetShown && loc_orgasmProgress < 2.5) ;|| (loc_widgetShown)
                        UDCDMain.toggleWidget2(false)
                        loc_widgetShown = false
                    elseif !loc_widgetShown && loc_orgasmProgress >= 2.5
                        UDCDMain.widget2.SetPercent(loc_orgasmProgress_p,true)
                        UDCDMain.toggleWidget2(true)
                        loc_widgetShown = true
                    endif
                endif
                
                if loc_orgasmProgress < 0.0
                    loc_orgasmProgress = 0.0
                endif
                
                loc_expressionUpdateTimer += 1
            endif
            
            loc_tick += 1
            
            if IsRunning()
                if loc_isplayer
                    loc_currentUpdateTime = UDOM.UD_OrgasmUpdateTime
                else
                    loc_currentUpdateTime = 1.0
                endif
                registerForSingleUpdate(loc_currentUpdateTime)
            endif
        endif
    endif
    _processing = false
EndEvent


;Event UDOrgasm(Form akActor,Float afOrgasmRate,Int aiArousal,Int aiEdgeLevel,Float afForcing)
Function SendOrgasmEvent()
    int loc_id = ModEvent.Create("UDOrgasmEvent")
    if loc_id
        ModEvent.PushForm(loc_id, akActor)
        ModEvent.PushFloat(loc_id, loc_orgasmRate)
        ModEvent.PushInt(loc_id, loc_arousal)
        ModEvent.PushInt(loc_id, loc_edgelevel)
        ModEvent.PushFloat(loc_id, loc_forcing)
        ModEvent.Send(loc_id)
    endif
    Int loc_handle = ModEvent.Create("DeviceActorOrgasmExp")
    if loc_handle
        ModEvent.PushForm(loc_handle, UDOM)         ;Event source (zadlibs), in case that some other mode might call this function from different place
        ModEvent.PushForm(loc_handle, akActor)      ;Actor
        ModEvent.PushInt(loc_handle, loc_arousal)   ;Arousal after orgasm
        ModEvent.Send(loc_handle)
    endif
EndFunction

Function SendEdgeEvent()
    int loc_id = ModEvent.Create("UDEdgeEvent")
    if loc_id
        ModEvent.PushForm(loc_id, akActor)
        ModEvent.PushFloat(loc_id, loc_orgasmRate)
        ModEvent.PushInt(loc_id, loc_arousal)
        ModEvent.PushInt(loc_id, loc_edgelevel)
        ModEvent.PushFloat(loc_id, loc_forcing)
        ModEvent.Send(loc_id)
    endif
    Int loc_handle = ModEvent.Create("DeviceActorEdgeExp")
    if loc_handle
        ModEvent.PushForm(loc_handle, UDOM)         ;Event source (zadlibs), in case that some other mode might call this function from different place
        ModEvent.PushForm(loc_handle, akActor)      ;Actor
        ModEvent.Send(loc_handle)
    endif
EndFunction

bool Function IsRunning()
    return !_finished
EndFunction

Event OnPlayerLoadGame()
    Update()
EndEvent

zadlibs_UDPatch Property libsp
    zadlibs_UDPatch function Get()
        return UDCDmain.libsp
    endfunction
endproperty