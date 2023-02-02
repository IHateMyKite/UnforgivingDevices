Scriptname UD_Patcher extends Quest  
{Patches devices and safecheck animations}

import UnforgivingDevicesMain

zadlibs Property libs auto
UDCustomDeviceMain Property UDCDmain auto
UD_libs Property UDlibs auto

Float       Property UD_PatchMult           =  1.0     auto ;global patch multiplier, applies to all devices
int         Property UD_EscapeModifier      =   10     auto
Int         Property UD_MinLocks            =    0    auto
Int         Property UD_MaxLocks            =    2    auto

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
    Float   loc_currentmult = UD_PatchMult_HeavyBondage*UD_PatchMult*GetPatchDifficulty(device)
    Int     loc_type        = 0
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
            device.UD_CutChance = 0
        endif
        loc_type = 15
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousArmbinderElbow)
        device.UD_durability_damage_base = fRange(Utility.randomFloat(0.65,0.8)/loc_currentmult,0.05,100.0)
        device.UD_CutChance = fRange(Utility.randomFloat(3.0,8.0)/loc_currentmult,1.0,50.0)
        if isSteel(device)
            device.UD_CutChance = 0
        endif
        loc_type = 16
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousStraitJacket)
        device.UD_durability_damage_base = fRange(Utility.randomFloat(0.7,0.9)/loc_currentmult,0.05,100.0)
        device.UD_CutChance = fRange(Utility.randomFloat(2.0,8.0)/loc_currentmult,1.0,50.0)
        sentientModChance = 75
        if isSteel(device)
            device.UD_CutChance = 0
        endif
        loc_type = 17
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousCuffsFront)
        device.UD_durability_damage_base = fRange(Utility.randomFloat(0.3,0.8)/loc_currentmult,0.05,100.0)
        device.UD_LockAccessDifficulty = iRange(Round(Utility.randomInt(70,80)*loc_currentmult),0,95)
        loc_type = 19
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousYoke) || device.deviceRendered.hasKeyword(libs.zad_DeviousYokeBB)
        device.UD_durability_damage_base = fRange(Utility.randomFloat(0.1,0.25)/loc_currentmult,0.05,100.0)
        device.UD_LockAccessDifficulty = iRange(Round(Utility.randomInt(75,90)*loc_currentmult),0,95)
        loc_type = 18
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousElbowTie)
        device.UD_durability_damage_base = Utility.randomFloat(0.05,0.1)
        device.UD_StruggleCritChance = Utility.randomInt(3,5)
        device.UD_StruggleCritMul = Utility.randomFloat(150.0,255.0)
        loc_type = 22
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousPetSuit)
        device.UD_durability_damage_base = fRange(Utility.randomFloat(0.9,1.4)/loc_currentmult,0.05,100.0)
        device.UD_LockAccessDifficulty = iRange(Round(Utility.randomInt(60,80)*loc_currentmult),0,95)
        device.UD_CutChance = fRange(Utility.randomFloat(2.0,5.0)/loc_currentmult,1.0,50.0)
        sentientModChance = 75
        loc_type = 21
    else
        loc_type = 0
    endif
    
    ;materials
    if (StringUtil.find(device.deviceInventory.getName(),"High Security") != -1 || StringUtil.find(device.deviceInventory.getName(),"Secure") != -1)
        device.UD_durability_damage_base = fRange(device.UD_durability_damage_base/4.0,0.05,100.0)
        device.UD_StruggleCritDuration = 0.5
        ;device.UD_Locks = UD_MinLocks
        ;device.UD_LockpickDifficulty = 100
        ;if device.UD_LockAccessDifficulty < 85
        ;    device.UD_LockAccessDifficulty = 85
        ;endif
        
        device.UD_ResistPhysical = Utility.randomFloat(0.5,0.9)
        device.UD_ResistMagicka = Utility.randomFloat(-0.3,1.0)
    endif
    
    checkSentientModifier(device,Round(sentientModChance*loc_currentmult),3.0)

    if isEbonite(device)
        checkMendingModifier(device,Round(55*loc_currentmult),1.25)
    else
        checkMendingModifier(device,Round(35*loc_currentmult),0.8)
    endif
    
    patchFinish(device,loc_control,loc_currentmult,loc_type)
EndFunction

Function patchBlindfold(UD_CustomBlindfold_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Blindfold*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    ;materials
    if StringUtil.find(device.deviceInventory.getName(),"Extreme") != -1 || (StringUtil.find(device.deviceInventory.getName(),"High Security") != -1 || StringUtil.find(device.deviceInventory.getName(),"Secure") != -1)
        ;device.UD_Locks = UD_MinLocks
        device.UD_ResistPhysical = Utility.randomFloat(0.4,0.8)
        device.UD_ResistMagicka = Utility.randomFloat(0.2,1.0)
    endif
    
    checkLooseModifier(device,75,0.2,0.5)
    
    patchFinish(device,0x0F,loc_currentmult,7)
EndFunction

Function patchGag(UD_CustomGag_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Gag*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    
    checkLooseModifier(device,30,0.05, 0.15)
    
    if device as UD_CustomPanelGag_RenderScript
        (device as UD_CustomPanelGag_RenderScript).UD_RemovePlugDifficulty = Utility.randomInt(50,100)*loc_currentmult
    endif

    patchFinish(device,0x0F,loc_currentmult,6)
EndFunction

Function patchBelt(UD_CustomBelt_RenderScript device)
    Float loc_currentmult = UD_PatchMult_ChastityBelt*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    
    device.UD_Cooldown = Round(Utility.randomInt(140,200)/fRange(loc_currentmult,0.5,2.0))
    ;materials
    if isEbonite(device)
        device.UD_ResistPhysical = Utility.randomFloat(-0.25,0.7)
        device.UD_ResistMagicka = Utility.randomFloat(0.25,0.5)
    elseif (StringUtil.find(device.deviceInventory.getName(),"Leather") != -1)
        device.UD_ResistPhysical = Utility.randomFloat(-0.4,0.1)
        device.UD_ResistMagicka = Utility.randomFloat(-0.5,0.5)
    elseif isRope(device)
        device.UD_ResistPhysical = Utility.randomFloat(-0.5,0.0)
        device.UD_ResistMagicka = Utility.randomFloat(-0.1,0.1)
    endif
    
    if device as UD_CustomCrotchDevice_RenderScript
        device.AddAbility(UDlibs.ArousingMovement,0)
    endif
    checkSentientModifier(device,Round(70*loc_currentmult),1.25)
    
    patchFinish(device,0x0F,loc_currentmult,11)
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
        device.UD_durability_damage_base = 0.0 
        GenerateLocks(device, 8,255)
    endif
    
    checkMAOModifier(device,25,10,25)
    
    checkSentientModifier(device,50,1.25)
    patchFinish(device,loc_control,loc_currentmult,-1)
EndFunction

Function patchHood(UD_CustomHood_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Hood*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    checkLooseModifier(device,100,0.05, 0.4)
    patchFinish(device,0x0F,loc_currentmult,14)
EndFunction

Function patchBra(UD_CustomBra_RenderScript device)
    Float loc_currentmult = UD_PatchMult_ChastityBra*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    
    device.UD_durability_damage_base *= 0.5
    
    checkSentientModifier(device,50,1.3)
    patchFinish(device,0x0F,loc_currentmult,12)
EndFunction

Function patchGeneric(UD_CustomDevice_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Generic*UD_PatchMult*GetPatchDifficulty(device)
    Int loc_type = 0
    patchDefaultValues(device,loc_currentmult)

    int loc_control = 0x0F
    if device as UD_CustomMittens_RenderScript
        if !device.UD_durability_damage_base
            device.UD_durability_damage_base = fRange(Utility.randomFloat(0.25,1.0)/loc_currentmult,0.05,100.0) ;so mittens are always escapable
        endif
        checkLooseModifier(device,100,0.25, 1.0)
        loc_control = Math.LogicalAnd(loc_control,0x0E)
        loc_type = 4
    elseif device as UD_CustomBoots_RenderScript
        loc_type = 5
    elseif device as UD_CustomGloves_RenderScript
        loc_type = 3
    elseif device as UD_CustomSuit_RenderScript
        loc_type = 10
    endif
    
    If device as UD_CustomDynamicHeavyBondage_RS
        (device as UD_CustomDynamicHeavyBondage_RS).UD_UntieDifficulty = Utility.randomFloat(75.0,125.0)/loc_currentmult
        device.UD_Cooldown = Round(Utility.randomInt(160,240)/fRange(loc_currentmult,0.5,2.0))
    endif
    
    
    checkLooseModifier(device,50,0.15, 0.4)
    
    patchFinish(device,loc_control,loc_currentmult,loc_type)
EndFunction

Function patchPiercing(UD_CustomPiercing_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Piercing*UD_PatchMult*GetPatchDifficulty(device)
    Int loc_type = 0
    patchDefaultValues(device,loc_currentmult)
    ;patchStart(device)
    device.UD_VibDuration = Round(Utility.randomInt(40,75)*fRange(loc_currentmult,0.3,5.0))
    device.UD_Cooldown = Round(Utility.randomInt(45,90)/fRange(loc_currentmult,0.5,2.0))
    if device.UD_DeviceKeyword == libs.zad_deviousPiercingsNipple
        loc_type = 2
        device.UD_OrgasmMult  = Utility.randomFloat(0.3,0.8)*fRange(loc_currentmult,1.0,5.0)
        device.UD_ArousalMult = Utility.randomFloat(1.5,2.0)*fRange(loc_currentmult,1.0,3.0)
        checkMAHModifier(device,45,3,8,1,3)
    elseif device.UD_DeviceKeyword == libs.zad_DeviousPiercingsVaginal
        loc_type = 1
        device.UD_OrgasmMult  = Utility.randomFloat(1.5,2.5)*fRange(loc_currentmult,0.8,3.0)
        checkMAOModifier(device,15,5,15)
    endif

    device.UD_ResistPhysical = 0.75
    device.UD_ResistMagicka = 0.1
    checkSentientModifier(device,50,1.0)
    
    patchFinish(device,0x0F,loc_currentmult,loc_type)
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
    return (StringUtil.find(device.deviceInventory.getName(),"Rope") != -1)
EndFunction

;returns true if device is extreme. This is done by checking device name for keyword Extreme or Secure
bool Function isSecure(UD_CustomDevice_RenderScript akDevice)
    return (StringUtil.find(akDevice.deviceInventory.getName(),"High Security") != -1 || StringUtil.find(akDevice.deviceInventory.getName(),"Secure") != -1)
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

Function patchFinish(UD_CustomDevice_RenderScript device,int argControlVar = 0x0F,Float fMult = 1.0, Int aiType = 0)
    checkInventoryScript(device,argControlVar,fMult,aiType)
    
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
;------------------------
Function checkInventoryScript(UD_CustomDevice_RenderScript device,int argControlVar = 0x0F,Float fMult = 1.0, Int aiType = 0)
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
        Int loc_diff = 0
        if inventoryScript.LockPickEscapeChance >= 50.0
            loc_diff = 1 ;Novic
        elseif inventoryScript.LockPickEscapeChance >= 20.0
            loc_diff = Utility.randomInt(2,10) ;Apprentice
        elseif inventoryScript.LockPickEscapeChance >= 12.0
            loc_diff = Utility.randomInt(26,35) ;Adept
        elseif inventoryScript.LockPickEscapeChance >= 7.0
            loc_diff = Utility.randomInt(51,60) ;Expert
        elseif inventoryScript.LockPickEscapeChance > 0.0
            loc_diff = Utility.randomInt(76,80);Master
        else 
            loc_diff = 255 ;Requires Key
        endif
        
        GenerateLocks(device, aiType, loc_diff)
    endif
    
    inventoryScript.delete()
EndFunction


Function GenerateLocks(UD_CustomDevice_RenderScript akDevice, Int aiType, Int aiDifficulty)
    if aiType < 0
        return
    endif
    
    if isRope(akDevice)
        return ;rope device can't have locks!
    endif
    
    if !akDevice.HaveLocks()
        Int loc_timelock = Utility.randomInt(0,2) ;random timelock, to force player in to being longer locked in akDevice
        if aiType == 0 ;generic
            akDevice.CreateLock(aiDifficulty, 75, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left lock 1", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left lock 2", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 75, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right lock 1", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right lock 2", loc_timelock, True)
        elseif aiType == 1 ;genital piercing
            akDevice.CreateLock(aiDifficulty, 50, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Genital lock", loc_timelock, True)
        elseif aiType == 2 ;nipple piercing
            akDevice.CreateLock(aiDifficulty, 70, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left nipple lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 70, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right nipple lock", loc_timelock, True)
        elseif aiType == 3 ;Gloves
            akDevice.CreateLock(aiDifficulty, 75, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left  hand lock 1", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left  hand lock 2", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 75, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right hand lock 1", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right hand lock 2", loc_timelock, True)
        elseif aiType == 4 ;Mittens
            akDevice.CreateLock(aiDifficulty, 0, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left  hand lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 0, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right hand lock", loc_timelock, True)
        elseif aiType == 5 ;boots
            akDevice.CreateLock(aiDifficulty, 25, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left  ancle lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right ancle lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 75, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left  leg lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 75, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right leg lock", loc_timelock, True)
        elseif aiType == 6 ;Gag
            akDevice.CreateLock(aiDifficulty, 50, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Strap lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 10, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Back lock", loc_timelock, True)
        elseif aiType == 7 ;Blindfold
            akDevice.CreateLock(aiDifficulty, 25, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Back lock", loc_timelock, True)
        elseif aiType == 8 || aiType == 9;Vag. Plug or Anal plug
            akDevice.CreateLock(aiDifficulty, 80, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Plug lock", loc_timelock, True)
        elseif aiType == 10 ;Suit
            akDevice.CreateLock(aiDifficulty, 80, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Front lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 60, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left arm lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 60, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right arm lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 60, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left leg lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 60, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right leg lock", loc_timelock, True)
        elseif aiType == 11 ;Belt
            akDevice.CreateLock(aiDifficulty, 80, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Front lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Back lock", loc_timelock, True)
        elseif aiType == 12 ;Bra
            akDevice.CreateLock(aiDifficulty, 75, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Front lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 15, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Back lock", loc_timelock, True)
        elseif aiType == 13 ;Harness
            akDevice.CreateLock(aiDifficulty, 65, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Neck lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 75, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Front lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 15, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Back lock", loc_timelock, True)
        elseif aiType == 14 ;hood
            akDevice.CreateLock(aiDifficulty, 75, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Front lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 15, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Back lock", loc_timelock, True)
        elseif aiType == 15 || aiType == 16 ;Armbinder or Elbowbinder
            if isSteel(akDevice)
                akDevice.CreateLock(aiDifficulty, 15, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left cuff lock", loc_timelock, True)
                akDevice.CreateLock(aiDifficulty, 15, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right cuff lock", loc_timelock, True)
            else
                akDevice.CreateLock(aiDifficulty, 0, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left shoulder lock", loc_timelock, True)
                akDevice.CreateLock(aiDifficulty, 0, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right shoulder lock", loc_timelock, True)
            endif
        elseif aiType == 17 ;Straitjacket
            if isSteel(akDevice)
                akDevice.CreateLock(aiDifficulty, 15, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left cuff lock", loc_timelock, True)
                akDevice.CreateLock(aiDifficulty, 15, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right cuff lock", loc_timelock, True)
            else
                akDevice.CreateLock(aiDifficulty, 0, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left side lock", loc_timelock, True)
                akDevice.CreateLock(aiDifficulty, 0, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right side lock", loc_timelock, True)
                akDevice.CreateLock(aiDifficulty, 0, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Front lock", loc_timelock, True)
                akDevice.CreateLock(aiDifficulty, 0, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Back lock", loc_timelock, True)
            endif
        elseif aiType == 18 || aiType == 19 || aiType == 20 ;Yoke or Front cuffs or BB yoke
            akDevice.CreateLock(aiDifficulty, 35, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left cuff lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 35, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right cuff lock", loc_timelock, True)
        elseif aiType == 21 ;Petsuit
            akDevice.CreateLock(aiDifficulty, 25, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left arm lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right arm lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 0, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left leg lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 0, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right leg lock", loc_timelock, True)
        elseif aiType == 22 ;Elbow tie
            akDevice.CreateLock(aiDifficulty, 8, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Elbow lock", loc_timelock, True)
        else
            akDevice.CreateLock(aiDifficulty, 75, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left lock 1", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Left lock 2", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 75, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right lock 1", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, Utility.randomInt(UD_MinLocks,UD_MaxLocks), "Right lock 2", loc_timelock, True)
        endif
        
        if isSecure(akDevice)
            Int loc_lockNum = akDevice.GetLockNumber()
            while loc_lockNum
                loc_lockNum -= 1
                akDevice.UpdateLockDifficulty(loc_lockNum,50) ;increase all locks difficulty by 50
            endwhile
        endif
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