Scriptname UD_AbadonPlug_RenderScript extends UD_CustomPlug_RenderScript  

Quest Property AbadonQuest auto
UD_AbadonQuest_script Property AbadonQuestScript hidden
    UD_AbadonQuest_script Function get()
        return (AbadonQuest as UD_AbadonQuest_script)
    EndFunction
EndProperty

import UnforgivingDevicesMain
import UD_Native

;const values
float   diffuptimehours     = 4.0 ;hours
float   difficultygain      = 0.0
float   diff_gain_orgasm    = 3.0
float   diff_gain_edge      = 1.0
float   abadonPlugDiff      = 0.0
float   last_time_little_finisher_time  = 1.0
bool    finisherOn          = false ;mutex checks
float   total_strenght      = 0.0
int     orgasm_cout         = 0
bool    max_diff_finisher   = False
float   nextDeviceManifest  = 0.0
float   plug_hunger         = 0.0
bool    belt_used           = false

float Function relativeStrength()
    return abadonPlugDiff/AbadonQuestScript.max_difficulty
EndFunction

Function InitPost()
    parent.InitPost()
    nextDeviceManifest = Utility.GetCurrentGameTime() + 3.0/24.0 ;1 hour from equip
    UD_ActiveEffectName = "Plug-Abadon"
    UD_DeviceType = "Abadon Plug"

    updateVibrationParam()
    
    if AbadonQuestScript.final_finisher_set
        AbadonQuestScript.AbadonEquipSuit(getWearer(),AbadonQuestScript.final_finisher_pref)
        if WearerIsPlayer()
            UDmain.Print("Abadon plug has locked you in various bondage items to prevent you from removing it")
        endif
    endif
    
    if AbadonQuest.GetStage() == 0
        if !AbadonQuestScript.UD_AbadonVictim
            if WearerIsPlayer() || WearerIsFollower()
                AbadonQuestScript.UD_AbadonVictim = getWearer()
                if WearerIsPlayer()
                    (AbadonQuest).setStage(20)
                    (AbadonQuest).SetObjectiveDisplayed(30)
                else
                    (AbadonQuest).setStage(21)
                    (AbadonQuest).SetObjectiveDisplayed(31)
                endif
            endif
        endif
    endif
EndFunction

Int Function GetAiPriority()
    Int loc_res = 32
    if isVibrating()
        loc_res += 25
    endif
    return loc_res ;generic value
EndFunction

bool Function forceOutPlugMinigame(Bool abSilent = False)
    return forceOutAbadonPlugMinigame()
EndFunction

bool Function forceOutPlugMinigameWH(Actor akHelper, Bool abSilent = False)
    return forceOutAbadonPlugMinigameWH(akHelper)
EndFunction

bool _forceOutAbadonPlugMinigame_on = false
bool Function forceOutAbadonPlugMinigame(Bool abSilent = False)
    if !minigamePrecheck(abSilent)
        return False
    endif
    
    resetMinigameValues()
    
    setMinigameOffensiveVar(False,0.0,0.0,True)
    setMinigameDmgMult(Math.Pow(getAccesibility(),1.25))
    setMinigameWearerVar(True,UD_base_stat_drain)
    setMinigameEffectVar(True,True,1.25)
    setMinigameWidgetVar(True, False, False, 0x00FF22, 0xFF00EF, 0x00FF22, "icon-meter-pull")
    setSecWidgetVar(True, True, False, -1, -1, -1, "icon-meter-struggle")
    
    if minigamePostcheck(abSilent)
        ;register native meters
        if WearerIsPlayer()
            UDmain.UDWC.Meter_RegisterNative("device-main",1,0,150.0,true)
        endif
    
        UD_Native.RegisterDeviceCallback(VMHandle1,VMHandle2,DeviceRendered,UDCDMain.SpecialKey_Keycode,"_ForceOutAbadonMG_SKPress")
        
        string loc_param = UDmain.UDWC.GetMeterIdentifier("device-main")
        UD_Native.AddDeviceCallbackArgument(UDCDMain.SpecialKey_Keycode,0,loc_param, none)
        
        _forceOutAbadonPlugMinigame_on = True
        minigame()
        _forceOutAbadonPlugMinigame_on = False
        return true
    endif
    return false
EndFunction

bool Function forceOutAbadonPlugMinigameWH(Actor akHelper, Bool abSilent = False)
    if !minigamePrecheck(abSilent)
        return False
    endif
    
    resetMinigameValues()
    
    setHelper(akHelper)
    setMinigameOffensiveVar(False,0.0,0.0,True)
    setMinigameDmgMult(Math.Pow(getAccesibility(),1.0))
    setMinigameWearerVar(True,UD_base_stat_drain)
    setMinigameHelperVar(True,UD_base_stat_drain*0.25)
    setMinigameEffectVar(True,True,1.25)
    setMinigameEffectHelperVar(False,False)
    setMinigameWidgetVar(True, False, False, 0x00FF22, 0xFF00EF, 0x00FF22, "icon-meter-pull")
    setSecWidgetVar(True, True, False, -1, -1, -1, "icon-meter-struggle")
    setMinigameMinStats(0.8)
    
    if minigamePostcheck(abSilent)
        ;register native meters
        if PlayerInMinigame()
            UDmain.UDWC.Meter_RegisterNative("device-main",1,0,125.0,true)
        endif

        UD_Native.RegisterDeviceCallback(VMHandle1,VMHandle2,DeviceRendered,UDCDMain.SpecialKey_Keycode,"_ForceOutAbadonMG_SKPress")
        
        string loc_param = UDmain.UDWC.GetMeterIdentifier("device-main")
        UD_Native.AddDeviceCallbackArgument(UDCDMain.SpecialKey_Keycode,0,loc_param, none)
        
        _forceOutAbadonPlugMinigame_on = True
        minigame()
        _forceOutAbadonPlugMinigame_on = False
        setHelper(none)
        return true
    endif
    setHelper(none)
    return False
EndFunction

Float Function getButtonPressDamage()
    int loc_difficulty = AbadonQuestScript.overaldifficulty
    if loc_difficulty == 0
        return 0.5
    elseif loc_difficulty == 1
        return 0.25
    elseif loc_difficulty == 2
        return 0.1
    endif
EndFunction

Function addStrength(float val)
    if val > 0.0
        abadonPlugDiff += val
        total_strenght += val
        if abadonPlugDiff > AbadonQuestScript.max_difficulty
            abadonPlugDiff = AbadonQuestScript.max_difficulty
        endif
    endif
EndFunction

float Function getTotalStrenght()
    return total_strenght
EndFunction

float Function getRelativeHunger()
    return (1.0 - plug_hunger/100.0)
EndFunction

Function randomEquipHandRestrain()
    if (!getWearer().WornhasKeyword(libs.zad_DeviousHeavyBondage))
        Armor device = none
        bool res = False
        
        bool loc_haveSuit = WearerHaveSuit()
        Formlist loc_formlist = none
        
        if relativeStrength() < 0.4
            loc_formlist = UDmain.UDRRM.UD_AbadonDeviceList_HeavyBondageWeak
        elseif relativeStrength() < 0.8
            if RandomInt(1,99) > 25
                loc_formlist = UDmain.UDRRM.UD_AbadonDeviceList_HeavyBondage
            else
                loc_formlist = UDmain.UDRRM.UD_AbadonDeviceList_HeavyBondageWeak
            endif
        else
            if RandomInt(1,99) > 75
                loc_formlist = UDmain.UDRRM.UD_AbadonDeviceList_HeavyBondageHard
            else
                loc_formlist = UDmain.UDRRM.UD_AbadonDeviceList_HeavyBondage
            endif
        endif
        
        if loc_haveSuit
            Keyword[] loc_filter = new keyword[1]
            loc_filter[0] = libs.zad_deviousStraitjacket
            device = UDmain.UDRRM.getRandomFormFromFormlistFilter(loc_formlist,loc_filter,2) as Armor
        else
            device = UDmain.UDRRM.getRandomFormFromFormlist(loc_formlist) as Armor
        endif
        
        UDCDMain.LockDeviceParalel(getWearer(),device)
        nextDeviceManifest = Utility.GetCurrentGameTime() + 3.5/24.0
        Armor loc_renderDevice = UDCDmain.GetRenderDevice(device)
        if WearerIsPlayer()
            if loc_renderDevice.hasKeyword(libs.zad_DeviousArmbinder)
                debug.messagebox("Suddenly, Abadon plug starts to emit black smoke. Before you could react, smoke forces your hands helplessly behind your back and manifests into armbinder.")
            elseif loc_renderDevice.hasKeyword(libs.zad_DeviousStraitjacket)
                debug.messagebox("Suddenly, Abadon plug starts to emit black smoke. Before you could react, smoke forces your hands forcefully together and manifests into straitjacket.")
            elseif loc_renderDevice.hasKeyword(libs.zad_DeviousArmbinderElbow)
                debug.messagebox("Suddenly, Abadon plug starts to emit black smoke. Before you could react, smoke forces your hands painfully behind your back and manifests into elbowbinder.")
            elseif loc_renderDevice.hasKeyword(libs.zad_DeviousYoke)
                debug.messagebox("Suddenly, Abadon plug starts to emit black smoke. Before you could react, smoke forces your hands away from your body and locks them into cold steel yoke.")
            endif
        else
            UDmain.Print(getDeviceName() + " locks restraint on " + getWearerName())
        endif
    endif
EndFunction

bool Function equipRandomRestrain()
    Armor device = UDmain.UDRRM.getRandomSuitableRestrain(getWearer(),0xFFFCFFF3) ; exclude belts and plugs
    if !device
        return False
    endif
    if WearerIsPlayer()
        debug.messagebox("Suddenly, Abadon plug starts to emit black smoke. Before you could react, smoke manifests into " + device.getName() + "!")
    elseif WearerIsFollower()
        UDmain.Print(getWearerName() + "s Abadon plug manifested " + device.getName())
    endif
    nextDeviceManifest = Utility.GetCurrentGameTime() + 3.5/24.0
    UDCDmain.LockDeviceParalel(GetWearer(), device ,True)
    return True
EndFunction

float Function handRestrainChance()
    return (AbadonQuestScript.handrestrain_chance + AbadonQuestScript.handrestrain_chance*relativeStrength())*(0.5*(AbadonQuestScript.overaldifficulty + 1)) ;0.5 - at diff 0 (easy) , 1.5 at diff 2 (hard)
    ;return 100
EndFunction

bool msg1 = false
bool msg2 = false
bool msg3 = false
Function abadonorgasm(float mult = 1.0)
    addStrength(diff_gain_orgasm*mult*(0.5*(1 + AbadonQuestScript.overaldifficulty)))
    orgasm_cout += 1
    plug_hunger += 7.5*mult ;reduce plug hunger
    if plug_hunger > 100
        plug_hunger = 100.0
    endif
    if (AbadonQuestScript.dmg_heal)
        float hp_dmg = (AbadonQuestScript.overaldifficulty+1)*5 + Math.floor(orgasm_cout/5.0)*(AbadonQuestScript.overaldifficulty+1)
        if (getWearer().getAV("Health") > (1.0 + hp_dmg) || AbadonQuestScript.hardcore )
            getWearer().DamageAV("Health", hp_dmg)
        endif
    endif
    if (AbadonQuestScript.dmg_magica)
        getWearer().DamageAV("Magicka", (AbadonQuestScript.overaldifficulty+1)*5 + relativeStrength()*20)
    endif
    if (AbadonQuestScript.dmg_stamina)
        getWearer().DamageAV("Stamina", (AbadonQuestScript.overaldifficulty+1)*5 + relativeStrength()*20)
    endif
    
    if nextDeviceManifest < Utility.GetCurrentGameTime()
        if RandomInt() <=  Math.floor(handRestrainChance())
            equipRandomRestrain()
        endif
    endif
    
    if orgasm_cout % 2 && getRelativeDurability() < 1.0
        if WearerIsPlayer()
            UDmain.Print("You feel that your orgasm is making Abadon Plug to regain its strength!")
        elseif WearerIsFollower() && GetWearer().Is3DLoaded()
            UDmain.Print(getWearerName()+"s orgasm is making Abadon Plug to regain its strength!")
        endif
        refillDurability(10.0 + AbadonQuestScript.overaldifficulty*10.0)
    endif
    
    if finisherOn
        finisher_current_orgasms += 1
        if WearerIsPlayer()
            if(finisher_current_orgasms > 3 && !msg1)
                UDmain.Print("Plugs within you are making you orgasm nonstop!")
                msg1 = true
            elseif (finisher_current_orgasms > 6 && !msg2)
                UDmain.Print("Constant orgasms barely let you catch a breath!")
                msg2 = true
            elseif (finisher_current_orgasms > 10 && !msg3)
                UDmain.Print("You feel your mind breaking with every new orgasm")
                msg3 = true
            endif
        endif
        if finisher_current_orgasms >= finisher_goal_orgasms
            stopVibrating()
            finisher_current_orgasms = 0
            finisherOn = false
        endif
    endif
EndFunction

Function OnOrgasmPost(bool sexlab = false)
    parent.OnOrgasmPost(sexlab)
    if sexlab
        abadonorgasm(1.1)
        plug_hunger += 10*(3 - AbadonQuestScript.overaldifficulty)
        if plug_hunger > 100
            plug_hunger = 100.0
        endif
        decreaseDurabilityAndCheckUnlock(15.0)
        if RandomInt() > 60
            if WearerIsPlayer()
                UDmain.Print("You feel black goo dropping from your pussy!")
            endif
            getWearer().addItem(UDlibs.BlackGoo,3)
        endif
    else
        abadonorgasm()
    endif
EndFunction

int Function getOrgasmCout()
    return orgasm_cout
EndFunction

Function onUpdatePre(float timePassed)
    setModifierIntParam("LG",10 +  Math.floor(20.0*getTotalStrenght()*(0.5*(1 + AbadonQuestScript.overaldifficulty))))
EndFunction

Function updateVibrationParam()
    if !isVibrating()
        if plug_hunger < 30
            UD_Shocking = False
            UD_VibStrength = iRange(Round(35 + relativeStrength()*65),35,100)
            UD_VibDuration = iRange(Math.ceiling(30.0 + 80.0*relativeStrength() + 30.0*getRelativeHunger()),30,120)
            UD_EdgingMode  = 0
        elseif plug_hunger < 50
            UD_Shocking = True
            UD_VibStrength = iRange(Round(10 + relativeStrength()*50),10,60)
            UD_VibDuration = iRange(Math.ceiling(15.0 + 30.0*relativeStrength() + 15.0*getRelativeHunger()),45,90)
            UD_EdgingMode  = 2
        else
            UD_VibStrength = iRange(Round(relativeStrength()*40),0,40)
            UD_Shocking = True
            UD_EdgingMode  = 1
            UD_VibDuration = 60
        endif
        UD_Cooldown = 30 + Round(relativeStrength()*100)
    endif
EndFunction

int finisher_current_orgasms = 0
int finisher_goal_orgasms = 0
Function finisher(actor akActor,int orgasms = 5)
    if(!finisherOn);mutex check
        finisherOn = True
        
        if UDmain.TraceAllowed()
            UDmain.Log(getWearerName() + " finisher() called for " + orgasms + " orgasms")
        endif
        
        if !max_diff_finisher
            randomEquipHandRestrain()
        endif
        
        ;NEW
        msg1 = False
        msg2 = False
        msg3 = False
        finisher_goal_orgasms = orgasms
        finisher_current_orgasms = 0
        
        libs.SexlabMoan(akActor,100)
        
        stopVibratingAndWait()
        
        forceStrength(100)
        forceDuration(-1)
        forceEdgingMode(0)
        UDCDmain.startVibFunction(self)
    EndIf
EndFunction

;/
float last_time_masturbate = 0.0
Function masturbate()
    if (Utility.GetCurrentGameTime() - last_time_masturbate) > (AbadonQuestScript.masturbate_cd/24.0)
        Actor[] Positions = new Actor[1]
        Positions[0] = getWearer()
        libs.SexLab.StartSex(Positions, libs.SexLab.GetAnimationsByTag(1, "Solo", "F", true),none,CenterOn = none, AllowBed = true, Hook = "UD") ;it just works
        last_time_masturbate = Utility.GetCurrentGameTime()
    else
        debug.messagebox("You are too weak from last time.\nYou can masturbate again in "+ UDmain.FormatFloat((AbadonQuestScript.masturbate_cd/24.0 - (Utility.GetCurrentGameTime() - last_time_masturbate))*24,1) + " hours")
    endif
EndFunction
/;

float Function getCritDamage()
    int loc_difficulty = AbadonQuestScript.overaldifficulty
    float loc_helperincrease = 0
    if GetHelper()
        loc_helperincrease = 15.0
    endif
    if loc_difficulty == 0
        return 35.0 + loc_helperincrease
    elseif loc_difficulty == 1
        return 25.0 + loc_helperincrease
    elseif loc_difficulty == 2
        return 15.0 + loc_helperincrease
    endif
EndFunction

Function BeltCheck()
    if !belt_used && (getDurability() < getMaxDurability()*0.5) && !wearerHaveBelt()
        belt_used = True
        stopMinigame()
        if WearerIsPlayer()
            UDmain.Print("Plug has locked you in a chastity belt!")
        endif
        libs.lockdevice(getWearer(),UDlibs.AbadonBelt)
    endif
EndFunction

Event _ForceOutAbadonMG_SKPress(Float afValue)
    if afValue >= 30.0
        decreaseDurabilityAndCheckUnlock(getMinigameMult(0)*fRange(Math.Pow(afValue/50.0,4.0),0.75,10.0)*getButtonPressDamage()*0.25,0.0)
    else
        refillDurability(5.0 + AbadonQuestScript.overaldifficulty*2.5)
    endif
    UpdateWidget()
EndEvent

;======================================================================
;                                OVERRIDES
;======================================================================
Function OnVibrationStart()
    updateVibrationParam()
    Parent.OnVibrationStart()
EndFunction

Function OnVibrationEnd()
    plug_hunger += 5
    if plug_hunger > 100.0
        plug_hunger = 100.0
    endif
    if plug_hunger < 0
        plug_hunger = 0.0
    endif
    Parent.OnVibrationEnd()
EndFunction

Function OnMinigameEnd()
    BeltCheck()
    parent.OnMinigameEnd()
EndFunction

Function OnMinigameTick1()
    BeltCheck()
EndFunction

Function activateDevice()
    resetCooldown(1.0)
    if nextDeviceManifest < Utility.GetCurrentGameTime()
        equipRandomRestrain()
    else
        parent.activateDevice() ;start vib
    endif
EndFunction

Function updateWidget(bool force = false)
    if _forceOutAbadonPlugMinigame_on
        setSecWidgetVal(getRelativeDurability(),force)
    else
        parent.updateWidget(force)
    endif
EndFunction

Function onRemoveDevicePost(Actor akActor)
    parent.onRemoveDevicePost(akActor)
    if AbadonQuestScript.UD_AbadonVictim == getWearer()
        if WearerIsPlayer()
            if (AbadonQuest.GetCurrentStageID() == 20)
                AbadonQuest.SetObjectiveCompleted(30)
            elseif (AbadonQuest.GetCurrentStageID() == 30)
                AbadonQuest.SetObjectiveCompleted(40)
            endif
        else
            if (AbadonQuest.GetCurrentStageID() == 21)
                AbadonQuest.SetObjectiveCompleted(31)
            elseif (AbadonQuest.GetCurrentStageID() == 31)
                AbadonQuest.SetObjectiveCompleted(41)
            endif
        endif
        AbadonQuest.completeQuest()
    endif
    if !GetWearer().isDead()
        if AbadonQuestScript.final_finisher_set
            AbadonQuestScript.AbadonEquipSuit(getWearer(),AbadonQuestScript.final_finisher_pref)
        endif
    endif
EndFunction

Function onSpecialButtonPressed(float fMult)
    parent.onSpecialButtonPressed(fMult)
EndFunction

Function OnCritFailure()
    parent.OnCritFailure()
    OrgasmSystem.AddOrgasmChange(GetWearer(),"AbadonPlugCritFailure", 0x30024,UD_EroZones,0)
    OrgasmSystem.UpdateOrgasmChangeVar(GetWearer(),"AbadonPlugCritFailure",9,10,1) ;set arousal rate to 10
EndFunction

Function OnCritDevicePost()
    if _forceOutAbadonPlugMinigame_on
        decreaseDurabilityAndCheckUnlock(getCritDamage()*getAccesibility(),0.0)
        stopMinigame()
        if !isUnlocked
            BeltCheck()
            if !getWearer().wornhaskeyword(libs.zad_deviousHeavyBondage)
                ;if RandomInt() < iRange(Round(relativeStrength()*100),25 + AbadonQuestScript.overaldifficulty*12,75) ;50% - 100% chance of getting tied
                    randomEquipHandRestrain()
                ;endif
            endif
        endif
    else
        parent.OnCritDevicePost()
    endif
EndFunction

string Function addInfoString(string str = "")
    str = parent.addInfoString(str)
    str += "(AP) Strength: " + FormatFloat(abadonPlugDiff,1) + " (~"+Math.floor(relativeStrength()*100.0)+" %)" + "\n"
    str += "(AP) Hunger: "+ Math.floor(100.0 - plug_hunger) + " %\n"
    str += "(AP) Orgasms fed: "+ orgasm_cout +"\n"
    str += "(AP) Finisher?: "+ finisherOn +"\n"
    return str
EndFunction

Function onUpdatePost(float timePassed)
    updateVibrationParam()
    addStrength(UDOM.getArousal(GetWearer())*0.001*(1 + AbadonQuestScript.overaldifficulty)*(24.0*timePassed))
    plug_hunger -= 0.25*timePassed*24*60
    ;_littleFinisherUpdateTimePassed += timePassed
    if (plug_hunger < 0.0)
        plug_hunger = 0.0
    endif
    
    ;max finisher
    if !finisherOn
        if (abadonPlugDiff >= AbadonQuestScript.max_difficulty && !max_diff_finisher)
            max_diff_finisher = True
            if WearerIsPlayer()
                UDmain.Print("Abadon plug have reached its full strength!")
                if AbadonQuestScript.UD_AbadonVictim == getWearer()
                    AbadonQuestScript.SetStage(30)
                    AbadonQuestScript.SetObjectiveFailed(30)
                    AbadonQuestScript.SetObjectiveDisplayed(40)
                endif
                string tmp = "Despite your best efforts to remove the plug in time, you ultimately failed. Abadon plug has finally reached its full strength. It manifested and locked extremely sturdy straitjacket suit on your body that barely allows you to move your arms."
                tmp += "You immediately tried to struggle free, but that only made the plugs inside you start vibrating furiously. You pant in pleasure as first of many orgasms that are awaiting you starts to build up."
                tmp += "With realisation of how bad the situation you got yourself into is, you let out a scream just before a gag manifested over your mouth. Tears run down your cheeks as you uselessly try to resist the coming orgasm."
                debug.messagebox(tmp)
            else
                if AbadonQuestScript.UD_AbadonVictim == getWearer()
                    AbadonQuestScript.SetStage(31)
                    AbadonQuestScript.SetObjectiveFailed(31)
                    AbadonQuestScript.SetObjectiveDisplayed(41)
                endif
                UDmain.Print(getWearerName() + "'s " + getDeviceName() + " has reached its full potential!")
            endif
            UDmain.ItemManager.equipAbadonFinisherSuit(getWearer())
            finisher(getWearer(),AbadonQuestScript.max_orgasm_little_finisher)
        ;elseif relativeStrength() > 0.5
        ;if _littleFinisherUpdateTimePassed > 3.0
        ;        
        ;endif
        endif
    endif
    parent.OnUpdatePost(timePassed)
EndFunction

bool Function canBeStruggled(float afAccesibility = -1.0)
    if afAccesibility < 0.0
        afAccesibility = getAccesibility()
    endif
    if afAccesibility > 0.0
        return True
    else
        return false
    endif
EndFunction