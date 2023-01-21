Scriptname UD_Patcher extends Quest  
{Patches devices and safecheck animations}

import UnforgivingDevicesMain

zadlibs Property libs auto
UDCustomDeviceMain Property UDCDmain auto
UD_libs Property UDlibs auto

Float       Property UD_PatchMult           =  1.0     auto ;global patch multiplier, applies to all devices
int         Property UD_EscapeModifier      =   10     auto
Int         Property UD_MinLocks            =    1    auto
Int         Property UD_MaxLocks            =    6    auto

;difficulty multipliers
Float Property UD_PatchMult_HeavyBondage        = 1.0 auto
Float Property UD_PatchMult_Gag                 = 1.0 auto
Float Property UD_PatchMult_Blindfold           = 1.0 auto
Float Property UD_PatchMult_ChastityBra         = 1.0 auto
Float Property UD_PatchMult_ChastityBelt        = 1.0 auto
Float Property UD_PatchMult_Plug                = 1.0 auto
Float Property UD_PatchMult_Piercing            = 1.0 auto
Float Property UD_PatchMult_Hood                = 1.0 auto
Float Property UD_PatchMult_Generic             = 1.0 auto

Float Property UD_MinResistMult =   -1.0 auto
Float Property UD_MaxResistMult =    1.0 auto

;MCM options
Float Property UD_ManifestMod = 1.0 auto

;modifiers switches
Int Property UD_MAOChanceMod    = 100 auto
int Property UD_MAOMod          = 100 auto
Int Property UD_MAHChanceMod    = 100 auto
int Property UD_MAHMod          = 100 auto

Bool Property Ready = False auto
Event OnInit()
    Ready = True
EndEvent

Float Function GetPatchDifficulty(UD_CustomDevice_RenderScript akDevice)
    Armor akRD = akDevice.deviceRendered
    if akRD.haskeyword(UDlibs.PatchVeryHard_KW)
        return 1.75
    elseif akRD.haskeyword(UDlibs.PatchHard_KW)
        return 1.35
    elseif akRD.haskeyword(UDlibs.PatchEasy_KW)
        return 0.65
    elseif akRD.haskeyword(UDlibs.PatchVeryEasy_KW)
        return 0.25
    else
        return 1.0
    endif
EndFunction

Function patchHeavyBondage(UD_CustomHeavyBondage_RenderScript device)
    Float loc_currentmult = UD_PatchMult_HeavyBondage*UD_PatchMult*GetPatchDifficulty(device)
    ;device.UD_LockpickDifficulty = 25
    ;CheckLocks(device,true,50)
    device.UD_LockAccessDifficulty = 100.0
    device.UD_CutChance = 0.0

    device.UD_ResistPhysical = Utility.randomFloat(-0.1,0.7)
    device.UD_ResistMagicka = Utility.randomFloat(-0.5,0.75)
    device.UD_base_stat_drain = Utility.randomFloat(8.0,12.0)
    device.UD_StruggleCritDuration = Utility.randomFloat(0.75,0.9)
    device.UD_StruggleCritChance = Utility.randomInt(8,15)
    device.UD_StruggleCritMul = Utility.randomFloat(3.0,8.0)
    ;device.UD_LockpickDifficulty = 25*Utility.randomInt(1,3)
    
    int sentientModChance = 35
    device.UD_durability_damage_base = Utility.randomFloat(0.1,0.8)
    
    int loc_control = 0x0F
    
    if device.deviceRendered.hasKeyword(libs.zad_DeviousArmbinder)
        device.UD_durability_damage_base = fRange(Utility.randomFloat(0.7,1.0)/loc_currentmult,0.05,100.0)
        device.UD_CutChance = fRange(Utility.randomFloat(5.0,10.0)/loc_currentmult,1.0,50.0)
        if isSteel(device)
            device.UD_LockAccessDifficulty = 85
            device.UD_CutChance = 0
        endif
        CheckLocks(device,true,25)
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousArmbinderElbow)
        device.UD_durability_damage_base = fRange(Utility.randomFloat(0.65,0.8)/loc_currentmult,0.05,100.0)
        device.UD_CutChance = fRange(Utility.randomFloat(3.0,8.0)/loc_currentmult,1.0,50.0)
        if isSteel(device)
            device.UD_LockAccessDifficulty = 85
            device.UD_CutChance = 0
        endif
        CheckLocks(device,true,25)
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousStraitJacket)
        device.UD_durability_damage_base = fRange(Utility.randomFloat(0.7,0.9)/loc_currentmult,0.05,100.0)
        device.UD_CutChance = fRange(Utility.randomFloat(2.0,8.0)/loc_currentmult,1.0,50.0)
        sentientModChance = 75
        if isSteel(device)
            device.UD_LockAccessDifficulty = 85
            device.UD_CutChance = 0
        endif
        CheckLocks(device,true,25)
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousCuffsFront)
        device.UD_durability_damage_base = fRange(Utility.randomFloat(0.3,0.8)/loc_currentmult,0.05,100.0)
        CheckLocks(device,true,0)
        device.UD_LockAccessDifficulty = iRange(Round(Utility.randomInt(70,80)*loc_currentmult),0,95)
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousYoke) || device.deviceRendered.hasKeyword(libs.zad_DeviousYokeBB)
        device.UD_durability_damage_base = fRange(Utility.randomFloat(0.1,0.25)/loc_currentmult,0.05,100.0)
        CheckLocks(device,true,0)
        device.UD_LockAccessDifficulty = iRange(Round(Utility.randomInt(75,90)*loc_currentmult),0,95)
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousElbowTie)
        device.UD_durability_damage_base = Utility.randomFloat(0.05,0.1)
        CheckLocks(device,true,0)
        device.UD_StruggleCritChance = Utility.randomInt(3,5)
        device.UD_StruggleCritMul = Utility.randomFloat(150.0,255.0)
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousPetSuit)
        device.UD_durability_damage_base = fRange(Utility.randomFloat(0.9,1.4)/loc_currentmult,0.05,100.0)
        CheckLocks(device,true,25)
        device.UD_LockAccessDifficulty = iRange(Round(Utility.randomInt(60,80)*loc_currentmult),0,95)
        device.UD_CutChance = fRange(Utility.randomFloat(2.0,5.0)/loc_currentmult,1.0,50.0)
        sentientModChance = 75
    else
        CheckLocks(device,true,50)
    endif
    
    ;materials
    if (StringUtil.find(device.deviceInventory.getName(),"High Security") != -1 || StringUtil.find(device.deviceInventory.getName(),"Secure") != -1)
        device.UD_durability_damage_base = fRange(device.UD_durability_damage_base/4.0,0.05,100.0)
        device.UD_StruggleCritDuration = 0.5
        ;device.UD_Locks = UD_MinLocks
        device.UD_LockpickDifficulty = 100
        if device.UD_LockAccessDifficulty < 85
            device.UD_LockAccessDifficulty = 85
        endif
        
        device.UD_ResistPhysical = Utility.randomFloat(0.5,0.9)
        device.UD_ResistMagicka = Utility.randomFloat(-0.3,1.0)
    endif
    
    checkSentientModifier(device,Round(sentientModChance*loc_currentmult),3.0)

    if isEbonite(device)
        checkMendingModifier(device,Round(55*loc_currentmult),1.25)
    else
        checkMendingModifier(device,Round(35*loc_currentmult),0.8)
    endif
    
    patchFinish(device,loc_control,loc_currentmult)
EndFunction

Function patchBlindfold(UD_CustomBlindfold_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Blindfold*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    CheckLocks(device,false,30)
    ;materials
    if StringUtil.find(device.deviceInventory.getName(),"Extreme") != -1 || (StringUtil.find(device.deviceInventory.getName(),"High Security") != -1 || StringUtil.find(device.deviceInventory.getName(),"Secure") != -1)
        ;device.UD_Locks = UD_MinLocks
        device.UD_ResistPhysical = Utility.randomFloat(0.4,0.8)
        device.UD_ResistMagicka = Utility.randomFloat(0.2,1.0)
    endif
    
    checkLooseModifier(device,75,0.2,0.5)
    
    patchFinish(device,0x0F,loc_currentmult)
EndFunction

Function patchGag(UD_CustomGag_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Gag*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    
    if StringUtil.find(device.deviceInventory.getName(),"Extreme") != -1 || (StringUtil.find(device.deviceInventory.getName(),"High Security") != -1 || StringUtil.find(device.deviceInventory.getName(),"Secure") != -1)
        ;device.UD_Locks = UD_MinLocks
    endif
    
    checkLooseModifier(device,30,0.05, 0.15)
    
    if device as UD_CustomPanelGag_RenderScript
        (device as UD_CustomPanelGag_RenderScript).UD_RemovePlugDifficulty = Utility.randomInt(50,100)*loc_currentmult
    endif

    CheckLocks(device,false,25)

    patchFinish(device,0x0F,loc_currentmult)
EndFunction

Function patchBelt(UD_CustomBelt_RenderScript device)
    Float loc_currentmult = UD_PatchMult_ChastityBelt*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    
    CheckLocks(device,false,25)
    device.UD_Cooldown = Round(Utility.randomInt(140,200)/fRange(loc_currentmult,0.5,2.0))
    ;materials
    if isEbonite(device)
        device.UD_ResistPhysical = Utility.randomFloat(-0.25,0.7)
        device.UD_ResistMagicka = Utility.randomFloat(0.25,0.5)
    elseif (StringUtil.find(device.deviceInventory.getName(),"Leather") != -1)
        device.UD_ResistPhysical = Utility.randomFloat(-0.4,0.1)
        device.UD_ResistMagicka = Utility.randomFloat(-0.5,0.5)
    elseif (StringUtil.find(device.deviceInventory.getName(),"Rope") != -1)
        device.UD_ResistPhysical = Utility.randomFloat(-0.5,0.0)
        device.UD_ResistMagicka = Utility.randomFloat(-0.1,0.1)
        ;device.UD_Locks = 0
    endif
    
    if device as UD_CustomCrotchDevice_RenderScript
        device.AddAbility(UDlibs.ArousingMovement,0)
    endif
    checkSentientModifier(device,Round(70*loc_currentmult),1.25)
    
    patchFinish(device,0x0F,loc_currentmult)
EndFunction

Function patchPlug(UD_CustomPlug_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Plug*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    
    ;device.UD_Locks = 0
    device.UD_durability_damage_base = Utility.randomFloat(10.0,20.0)/loc_currentmult
    device.UD_VibDuration = Math.Floor(Utility.randomInt(45,80)*fRange(loc_currentmult,0.5,5.0))
    device.UD_OrgasmMult  = Utility.randomFloat(0.75,1.5)*fRange(loc_currentmult,0.7,1.0)
    device.UD_ArousalMult = Utility.randomFloat(0.5,1.5)*fRange(loc_currentmult,1.0,5.0)
    device.UD_Cooldown = Round(Utility.randomInt(120,240)/fRange(loc_currentmult,0.5,2.0))
    
    int loc_control = 0x0F
        
    loc_control = Math.LogicalAnd(loc_control,0x06)
    
    if device as UD_CustomInflatablePlug_RenderScript
        (device as UD_CustomInflatablePlug_RenderScript).UD_PumpDifficulty = Utility.randomInt(50,100)
        (device as UD_CustomInflatablePlug_RenderScript).UD_DeflateRate = Utility.randomInt(150,250)
    elseif device as UD_ControlablePlug_RenderScript
        device.UD_VibDuration = Utility.randomInt(450,750)
        device.UD_Cooldown = Round(Utility.randomInt(300,420)/fRange(loc_currentmult,0.5,2.0))
    else
        
    endif
    
    if device.zad_deviceKey ;lockable plug
        CheckLocks(device)
        device.UD_LockAccessDifficulty = 70
        device.UD_durability_damage_base = 0.0 
    endif
    checkMAOModifier(device,25,10,25)
    
    checkSentientModifier(device,50,1.25)
    patchFinish(device,loc_control,loc_currentmult)
EndFunction

Function patchHood(UD_CustomHood_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Hood*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    checkLooseModifier(device,100,0.05, 0.4)
    CheckLocks(device,false,40)
    patchFinish(device,0x0F,loc_currentmult)
EndFunction

Function patchBra(UD_CustomBra_RenderScript device)
    Float loc_currentmult = UD_PatchMult_ChastityBra*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    
    device.UD_durability_damage_base *= 0.5
    CheckLocks(device,false,35)
    ;device.UD_LockpickDifficulty = 25*Utility.randomInt(1,3)
    device.UD_LockAccessDifficulty = Utility.randomFloat(70.0,90.0)
    
    checkSentientModifier(device,50,1.3)
    patchFinish(device,0x0F,loc_currentmult)
EndFunction

Function patchGeneric(UD_CustomDevice_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Generic*UD_PatchMult*GetPatchDifficulty(device)

    patchDefaultValues(device,loc_currentmult)
    CheckLocks(device,true,35)

    int loc_control = 0x0F
    if device as UD_CustomMittens_RenderScript
        if !device.UD_durability_damage_base
            device.UD_durability_damage_base = fRange(Utility.randomFloat(0.25,1.0)/loc_currentmult,0.05,100.0) ;so mittens are always escapable
        endif
        checkLooseModifier(device,100,0.25, 1.0)
        loc_control = Math.LogicalAnd(loc_control,0x0E)
    endif
    
    If device as UD_CustomDynamicHeavyBondage_RS
        (device as UD_CustomDynamicHeavyBondage_RS).UD_UntieDifficulty = Utility.randomFloat(75.0,125.0)/loc_currentmult
        device.UD_Cooldown = Round(Utility.randomInt(160,240)/fRange(loc_currentmult,0.5,2.0))
    EndIf
    
    checkLooseModifier(device,50,0.15, 0.4)
    
    patchFinish(device,loc_control,loc_currentmult)
EndFunction

Function patchPiercing(UD_CustomPiercing_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Piercing*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    ;patchStart(device)
    device.UD_VibDuration = Round(Utility.randomInt(40,75)*fRange(loc_currentmult,0.3,5.0))
    device.UD_Cooldown = Round(Utility.randomInt(45,90)/fRange(loc_currentmult,0.5,2.0))
    if device.UD_DeviceKeyword == libs.zad_deviousPiercingsNipple
        CheckLocks(device,true)
        device.UD_OrgasmMult  = Utility.randomFloat(0.3,0.8)*fRange(loc_currentmult,1.0,5.0)
        device.UD_ArousalMult = Utility.randomFloat(1.5,2.0)*fRange(loc_currentmult,1.0,3.0)
        checkMAHModifier(device,45,3,8,1,3)
    elseif device.UD_DeviceKeyword == libs.zad_DeviousPiercingsVaginal
        CheckLocks(device,false)
        device.UD_OrgasmMult  = Utility.randomFloat(1.5,2.5)*fRange(loc_currentmult,0.8,3.0)
        checkMAOModifier(device,15,5,15)
    endif

    device.UD_ResistPhysical = 0.75
    device.UD_ResistMagicka = 0.1
    checkSentientModifier(device,50,1.0)
    
    patchFinish(device,0x0F,loc_currentmult)
EndFunction

bool Function isEbonite(UD_CustomDevice_RenderScript device)
    if (StringUtil.find(device.deviceInventory.getName(),"Ebonite") != -1) || (StringUtil.find(device.deviceInventory.getName(),"Latex") != -1) || (StringUtil.find(device.deviceInventory.getName(),"Rubber") != -1)
        return True
    Else
        Return False
    EndIF
EndFunction

bool Function isSteel(UD_CustomDevice_RenderScript device)
    return (StringUtil.find(device.deviceInventory.getName(),"Steel") != -1) || (StringUtil.find(device.deviceInventory.getName(),"Iron") != -1)
EndFunction

bool Function isRope(UD_CustomDevice_RenderScript device)
    return (StringUtil.find(device.deviceInventory.getName(),"Rope") != -1) ;|| (StringUtil.find(device.deviceInventory.getName(),"Iron") != -1)
EndFunction

bool Function DeviceCanHaveModes(UD_CustomDevice_RenderScript device)
    return !device.deviceRendered.haskeyword(UDlibs.PatchNoModes_KW)
EndFunction

Function checkSentientModifier(UD_CustomDevice_RenderScript device,int chance,float modifier)
    if Utility.randomInt(1,99) < chance && DeviceCanHaveModes(device)
        device.addModifier("Sentient",Utility.randomInt(Math.ceiling(5*modifier),Math.ceiling(35*modifier)))
    endif
EndFunction

Function checkMendingModifier(UD_CustomDevice_RenderScript device,int chance,float modifier)
    if Utility.randomInt(1,99) < chance && DeviceCanHaveModes(device)
        device.addModifier("Regen",formatString(120*modifier*Utility.randomFloat(0.5,2.0),1))
    endif
EndFunction

Function checkLooseModifier(UD_CustomDevice_RenderScript device,int chance,float rand_start = 0.0,float rand_end = 1.0)
    if Utility.randomInt(1,99) < chance; && DeviceCanHaveModes(device)
        device.addModifier("Loose",formatString(Utility.randomFloat(rand_start,rand_end),2))
    endif
EndFunction

Function checkMAHModifier(UD_CustomDevice_RenderScript device,int chance,int rand_start_c = 0,int rand_end_c = 100,int rand_start_d = 1,int rand_end_d = 1)
    if Utility.randomInt(1,99) < Round(chance*UD_MAHChanceMod/100) && DeviceCanHaveModes(device)
        device.addModifier("MAH",Round(Utility.randomInt(rand_start_c,rand_end_c)*UD_MAHMod/100) + "," + Utility.randomInt(rand_start_d,rand_end_d))
    endif
EndFunction

Function checkMAOModifier(UD_CustomDevice_RenderScript device,int chance,int rand_start_c = 0,int rand_end_c = 100,int rand_start_d = 1,int rand_end_d = 1)
    if Utility.randomInt(1,99) < Round(chance*UD_MAOChanceMod/100) && DeviceCanHaveModes(device)
        device.addModifier("MAO",Round(Utility.randomInt(rand_start_c,rand_end_c)*UD_MAOMod/100) + "," + Utility.randomInt(rand_start_d,rand_end_d))
    endif
EndFunction

Function checkHealModifier(UD_CustomDevice_RenderScript device,int chance,int rand_start_d = 25,int rand_end_d = 50)
    if Utility.randomInt(1,99) < chance && DeviceCanHaveModes(device)
        device.addModifier("_HEAL",Utility.randomInt(rand_start_d,rand_end_d))
    endif
EndFunction

Function checkLCheapModifier(UD_CustomDevice_RenderScript device,int chance,int rand_start_d = 5,int rand_end_d = 20)
    if Utility.randomInt(1,99) < chance && DeviceCanHaveModes(device)
        device.addModifier("_L_CHEAP",Utility.randomInt(rand_start_d,rand_end_d))
    endif
EndFunction

Function patchFinish(UD_CustomDevice_RenderScript device,int argControlVar = 0x0F,Float fMult = 1.0)
    checkInventoryScript(device,argControlVar,fMult)
    
    if device.UD_CutChance && (device.UD_durability_damage_base || device.UD_Locks)
        CheckCutting(device,35)
    endif
    
    if device.UD_Locks
        checkLCheapModifier(device,40,5,30)
    endif
    
    if device.deviceRendered.hasKeyword(libs.zad_EffectLively)
        device.UD_Cooldown = Round(device.UD_Cooldown*0.85)
    endif
    
    if device.deviceRendered.hasKeyword(libs.zad_EffectVeryLively)
        device.UD_Cooldown = Round(device.UD_Cooldown*0.6)
    endif
    
    CheckResist(device) ;check resist, so it can never bee too big or too low
    
    device.UD_WeaponHitResist = device.UD_ResistPhysical
    int loc_random = Utility.randomInt(0,100)
    if loc_random > 75
        if loc_random < 90
            device.UD_WeaponHitResist = device.UD_WeaponHitResist + Utility.randomFloat(0.25,0.75)
        else
            device.UD_WeaponHitResist = device.UD_WeaponHitResist - Utility.randomFloat(0.25,0.75)
        endif
    endif
    device.UD_SpellHitResist = device.UD_ResistMagicka
    
    int loc_level = device.GetWearer().GetLevel()
    device.UD_Level = Round(Utility.randomFloat(fRange(loc_level*0.75,1.0,100.0),fRange(loc_level*1.25,1.0,100.0)))
EndFunction


;argControlVar
;0b - BaseEscapeChance
;1b - CutDeviceEscapeChance
;2b - LockPickEscapeChance
;3b - LockAccessDifficulty
Function checkInventoryScript(UD_CustomDevice_RenderScript device,int argControlVar = 0x0F,Float fMult = 1.0)
    UD_CustomDevice_EquipScript inventoryScript = device.getInventoryScript()
    
    if Math.LogicalAnd(argControlVar,0x01)
        device.UD_durability_damage_base = (inventoryScript.BaseEscapeChance/UD_EscapeModifier)/fRange(fMult,0.25,3.0)
    else
        ;if !inventoryScript.BaseEscapeChance
        ;    device.UD_durability_damage_base = 0.0 ;inescapable device
        ;endif
    endif
    
    if device.UD_durability_damage_base == 0.0
        device.removeModifier("Loose")
    endif
    
    if Math.LogicalAnd(argControlVar,0x02)
        device.UD_CutChance = 0.75*inventoryScript.CutDeviceEscapeChance/fRange(fMult,0.5,3.0)
    endif
    
    if Math.LogicalAnd(argControlVar,0x04)
        if inventoryScript.LockPickEscapeChance >= 50.0
            device.UD_LockpickDifficulty = 1 ;Novic
        elseif inventoryScript.LockPickEscapeChance >= 20.0
            device.UD_LockpickDifficulty = Utility.randomInt(2,10) ;Apprentice
        elseif inventoryScript.LockPickEscapeChance >= 12.0
            device.UD_LockpickDifficulty = Utility.randomInt(26,35) ;Adept
        elseif inventoryScript.LockPickEscapeChance >= 7.0
            device.UD_LockpickDifficulty = Utility.randomInt(51,60) ;Expert
        elseif inventoryScript.LockPickEscapeChance > 0.0
            device.UD_LockpickDifficulty = Utility.randomInt(76,80);Master
        else 
            device.UD_LockpickDifficulty = 255 ;Requires Key
        endif
        
        if !inventoryScript.deviceKey && inventoryScript.LockPickEscapeChance == 0.0
            ;device.UD_Locks = 0
        elseif !device.UD_durability_damage_base && device.UD_Locks == 0 ;inventoryScript.deviceKey; && inventoryScript.LockAccessDifficulty < 100.0
            CheckLocks(device)
        endif
    endif
    
    if Math.LogicalAnd(argControlVar,0x08)
        if !device.UD_durability_damage_base && inventoryScript.LockAccessDifficulty < 100.0 && device.UD_LockAccessDifficulty == 100.0
            device.UD_LockAccessDifficulty = inventoryScript.LockAccessDifficulty
        endif
    endif

    inventoryScript.delete()
EndFunction

Function CheckLocks(UD_CustomDevice_RenderScript device,bool bEven = false,int iChanceNone = 0)
    if UD_MinLocks > UD_MaxLocks
        UDCDmain.Error("UD_MaxLocks needs to be bigger then UD_MinLocks!!")
        int loc_temp = UD_MaxLocks
        UD_MaxLocks = UD_MinLocks
        UD_MinLocks = loc_temp
    endif
    
    if UD_MaxLocks == UD_MinLocks
        ;device.UD_Locks = UD_MaxLocks
        return
    endif
    
    ;device have no locks
    if Utility.randomInt(0,99) < iChanceNone
        ;device.UD_Locks = 0
        return
    endif
    
    if bEven
        int loc_res = Utility.randomInt(UD_MinLocks,UD_MaxLocks)
        
        if !loc_res
            ;device.UD_Locks = 1 ;can't have device without lock!
            return
        endif
        
        if (loc_res % 2) 
            ;is not even
            if loc_res + 1 <= UD_MaxLocks
                ;device.UD_Locks = loc_res + 1
            elseif loc_res - 1 >= UD_MinLocks
                ;device.UD_Locks = loc_res - 1
            else
                ;device.UD_Locks = loc_res ;fuck it
            endif
        else
            ;device.UD_Locks = loc_res
        endif
    else
        ;device.UD_Locks = Utility.randomInt(UD_MinLocks,UD_MaxLocks)
    endif
EndFunction

Function CheckCutting(UD_CustomDevice_RenderScript device,int iChanceNone = 0)
    ;device is uncuttable
    if Utility.randomInt(1,99) < iChanceNone
        device.UD_CutChance = 0
    endif
EndFunction

Function patchDefaultValues(UD_CustomDevice_RenderScript device,Float fMult)
    ;CheckLocks(device,false,40)
    ;CheckCutting(device,35)
    device.UD_LockpickDifficulty = 25*Utility.randomInt(1,3)
    device.UD_LockAccessDifficulty = Utility.randomFloat(40.0,70.0) + 20*(fMult - 1.0)
    device.UD_base_stat_drain = Utility.randomFloat(7.0,13.0)
    device.UD_durability_damage_base = fRange(Utility.randomFloat(0.7,1.3)/fMult,0.05,100.0)
    device.UD_ResistPhysical = Utility.randomFloat(-0.5,0.9)
    device.UD_ResistMagicka = Utility.randomFloat(-0.9,1.0)

    device.UD_StruggleCritDuration = fRange(0.9/fMult,0.6,1.1)
    device.UD_StruggleCritChance = Utility.randomInt(15,30)
    device.UD_StruggleCritMul = Utility.randomFloat(2.0,6.0)
    device.UD_Cooldown = Round(Utility.randomInt(100,240)/(fRange(fMult,0.5,5.0)))
    if isEbonite(device)
        checkMendingModifier(device,Round(50*fMult),1.25*fMult)
        checkHealModifier(device,20)
    else
        checkMendingModifier(device,Round(25*fMult),0.8*fMult)
    endif
    
    if !device.isHeavyBondage()
        if isRope(device)
            checkLooseModifier(device,50,0.25, 0.5)
        endif
    else
        ;device.addModifier("Loose",1.0)
    endif
    
    checkSentientModifier(device,Round(15*fMult),1.0)
    checkHealModifier(device,10)
    
    device.CreateLock(aiDifficulty = 10, aiAccess = 100, asName = "Test Lock",abAdd = True, aiShields = 3)
    device.CreateLock(aiDifficulty = 90, aiAccess = 10, asName = "Test Lock 2",abAdd = True, aiShields = 1)
    device.CreateLock(aiDifficulty = 10, aiAccess = 100, asName = "",abAdd = True, aiShields = 3)
EndFunction

;check resist, so it can never bee too big or too low
Function CheckResist(UD_CustomDevice_RenderScript device)
    Float loc_ResistMult = device.UD_ResistPhysical + device.UD_ResistMagicka
    if loc_ResistMult > UD_MaxResistMult
        Bool loc_randomResist = Utility.randomInt(0,1)
        Float loc_dRes = loc_ResistMult - UD_MaxResistMult
        if loc_randomResist ;Decrease physical resist
            device.UD_ResistPhysical -= loc_dRes ;decrease resist by min ammount
        else    ;Decrease magickal resist
            device.UD_ResistMagicka  -= loc_dRes ;decrease resist by min ammount
        endif
    elseif loc_ResistMult < UD_MinResistMult
        Bool loc_randomResist = Utility.randomInt(0,1)
        Float loc_dRes = UD_MinResistMult - loc_ResistMult
        if loc_randomResist ;Increase physical resist
            device.UD_ResistPhysical += loc_dRes ;decrease resist by min ammount
        else    ;Decrease magickal resist
            device.UD_ResistMagicka  += loc_dRes ;decrease resist by min ammount
        endif
    endif
EndFunction