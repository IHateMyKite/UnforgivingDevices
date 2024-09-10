Scriptname UD_Patcher extends Quest  
{Patches devices and safecheck animations}

import UnforgivingDevicesMain
import UDCustomDeviceMain
import UD_Native

zadlibs Property libs auto
UDCustomDeviceMain Property UDCDmain auto
UD_libs Property UDlibs auto

UD_ModifierManager_Script _udmom
UD_ModifierManager_Script Property UDMOM Hidden
    UD_ModifierManager_Script Function Get()
        if !_udmom
            _udmom = UDCDmain.UDmain.UDMOM
        endif
        return _udmom
    EndFunction
EndProperty

Float       Property UD_PatchMult           =  1.0    auto hidden ;global patch multiplier, applies to all devices
int         Property UD_EscapeModifier      =   10    auto hidden
Int         Property UD_MinLocks            =    0    auto hidden
Int         Property UD_MaxLocks            =    2    auto hidden

;/  Variable: UD_ModsMinCap
    If the number of modifiers is less than the specified value, the patcher will try to add more
/;
Int         Property UD_ModsMinCap          =    2    Auto Hidden

;/  Variable: UD_ModsSoftCap
    Soft cap for the number of modifiers added by the patcher (the actual number of mods may slightly exceed this value)
/;
Int         Property UD_ModsSoftCap         =    4    Auto Hidden

;/  Variable: UD_ModsHardCap
    Hard cap for the number of modifiers added by the patcher (when this value is reached, the patcher stops adding mods)
/;
Int         Property UD_ModsHardCap         =    99   Auto Hidden

;/  Variable: UD_ModGlobalProbabilityMult
    Multplier that affects probability to add each modifier 
/;
Float       Property UD_ModGlobalProbabilityMult    = 1.0   Auto Hidden

;/  Variable: UD_ModGlobalSeverityShift
    Addition to the severity of each modifier (mathematical expectation of a random variable)
/; 
Float       Property UD_ModGlobalSeverityShift      = 0.0   Auto Hidden

;/  Variable: UD_ModGlobalSeverityDispMult
    The value by which the severity dispersion of each modifier is multiplied
/;
Float       Property UD_ModGlobalSeverityDispMult   = 1.0   Auto Hidden

;difficulty multipliers
Float Property UD_PatchMult_HeavyBondage        = 1.0 auto hidden
Float Property UD_PatchMult_Gag                 = 1.0 auto hidden
Float Property UD_PatchMult_Blindfold           = 1.0 auto hidden
Float Property UD_PatchMult_ChastityBra         = 1.0 auto hidden
Float Property UD_PatchMult_ChastityBelt        = 1.0 auto hidden
Float Property UD_PatchMult_Plug                = 1.0 auto hidden
Float Property UD_PatchMult_Piercing            = 1.0 auto hidden
Float Property UD_PatchMult_Hood                = 1.0 auto hidden
Float Property UD_PatchMult_Generic             = 1.0 auto hidden

Float Property UD_MinResistMult =   -1.0 auto hidden
Float Property UD_MaxResistMult =    1.0 auto hidden

Bool  Property UD_TimedLocks    = True   auto hidden

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
    device.UD_CutChance = 0.0

    device.UD_ResistPhysical = RandomFloat(-0.1,0.7)
    device.UD_ResistMagicka = RandomFloat(-0.5,0.75)
    device.UD_base_stat_drain = RandomFloat(8.0,12.0)
    device.UD_StruggleCritDuration = RandomFloat(0.75,0.9)
    device.UD_StruggleCritChance = RandomInt(8,15)
    device.UD_StruggleCritMul = RandomFloat(3.0,8.0)
    
    int sentientModChance = 35
    device.UD_durability_damage_base = RandomFloat(0.1,0.8)
    
    int loc_control = 0x0F
    
    if device.deviceRendered.hasKeyword(libs.zad_DeviousArmbinder)
        device.UD_durability_damage_base = fRange(RandomFloat(0.7,1.0)/loc_currentmult,0.03,100.0)
        device.UD_CutChance = fRange(RandomFloat(5.0,10.0)/loc_currentmult,1.0,50.0)
        if isSteel(device.deviceInventory)
            device.UD_CutChance = 0
        endif
        loc_type = 15
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousArmbinderElbow)
        device.UD_durability_damage_base = fRange(RandomFloat(0.65,0.8)/loc_currentmult,0.03,100.0)
        device.UD_CutChance = fRange(RandomFloat(3.0,8.0)/loc_currentmult,1.0,50.0)
        if isSteel(device.deviceInventory)
            device.UD_CutChance = 0
        endif
        loc_type = 16
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousStraitJacket)
        device.UD_durability_damage_base = fRange(RandomFloat(0.7,0.9)/loc_currentmult,0.03,100.0)
        device.UD_CutChance = fRange(RandomFloat(2.0,8.0)/loc_currentmult,1.0,50.0)
        sentientModChance = 75
        if isSteel(device.deviceInventory)
            device.UD_CutChance = 0
        endif
        loc_type = 17
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousCuffsFront)
        device.UD_durability_damage_base = fRange(RandomFloat(0.3,0.8)/loc_currentmult,0.03,100.0)
        loc_type = 19
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousYoke) || device.deviceRendered.hasKeyword(libs.zad_DeviousYokeBB)
        device.UD_durability_damage_base = fRange(RandomFloat(0.1,0.25)/loc_currentmult,0.03,100.0)
        loc_type = 18
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousElbowTie)
        device.UD_durability_damage_base = RandomFloat(0.03,0.1)
        device.UD_StruggleCritChance = RandomInt(3,5)
        device.UD_StruggleCritMul = RandomFloat(150.0,255.0)
        loc_type = 22
    elseif device.deviceRendered.hasKeyword(libs.zad_DeviousPetSuit)
        device.UD_durability_damage_base = fRange(RandomFloat(0.9,1.4)/loc_currentmult,0.03,100.0)
        device.UD_CutChance = fRange(RandomFloat(2.0,5.0)/loc_currentmult,1.0,50.0)
        sentientModChance = 75
        loc_type = 21
    else
        loc_type = 0
    endif
    
    ;materials
    if isSecure(device.DeviceInventory)
        device.UD_durability_damage_base = fRange(device.UD_durability_damage_base/(2.0*loc_currentmult),0.03,100.0)
        device.UD_StruggleCritDuration = 0.65
        device.UD_ResistPhysical = RandomFloat(0.5,0.9)
        device.UD_ResistMagicka = RandomFloat(-0.3,1.0)
    endif
    
    patchFinish(device,loc_control,loc_currentmult,loc_type)
EndFunction

Function patchBlindfold(UD_CustomBlindfold_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Blindfold*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    ;materials
    if isSecure(device.DeviceInventory)
        ;device.UD_Locks = UD_MinLocks
        device.UD_ResistPhysical = RandomFloat(0.4,0.8)
        device.UD_ResistMagicka = RandomFloat(0.2,1.0)
    endif
    
    patchFinish(device,0x0F,loc_currentmult,7)
EndFunction

Function patchGag(UD_CustomGag_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Gag*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    
    if device as UD_CustomPanelGag_RenderScript
        (device as UD_CustomPanelGag_RenderScript).UD_RemovePlugDifficulty = RandomInt(50,100)*loc_currentmult
    endif

    patchFinish(device,0x0F,loc_currentmult,6)
EndFunction

Function patchBelt(UD_CustomBelt_RenderScript device)
    Float loc_currentmult = UD_PatchMult_ChastityBelt*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    
    device.UD_Cooldown = Round(RandomInt(140,200)/fRange(loc_currentmult,0.5,2.0))
    ;materials
    if isEbonite(device.deviceInventory)
        device.UD_ResistPhysical = RandomFloat(-0.25,0.7)
        device.UD_ResistMagicka = RandomFloat(0.25,0.5)
    elseif IsLeather(device.deviceInventory)
        device.UD_ResistPhysical = RandomFloat(-0.4,0.1)
        device.UD_ResistMagicka = RandomFloat(-0.5,0.5)
    elseif isRope(device.deviceInventory)
        device.UD_ResistPhysical = RandomFloat(-0.5,0.0)
        device.UD_ResistMagicka = RandomFloat(-0.1,0.1)
    endif
    
    ;if device as UD_CustomCrotchDevice_RenderScript
        ;device.AddAbility(UDlibs.ArousingMovement,0)
    ;endif

    patchFinish(device,0x0F,loc_currentmult,11)
EndFunction

Function patchPlug(UD_CustomPlug_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Plug*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    
    ;device.UD_Locks = 0
    device.UD_durability_damage_base = RandomFloat(10.0,20.0)/loc_currentmult
    device.UD_VibDuration = Math.Floor(RandomInt(45,80)*fRange(loc_currentmult,0.5,5.0))
    device.UD_OrgasmMult  = RandomFloat(0.9,1.1)*fRange(loc_currentmult,0.7,1.0)
    device.UD_ArousalMult = RandomFloat(0.5,1.5)*fRange(loc_currentmult,1.0,5.0)
    device.UD_Cooldown = Round(RandomInt(120,240)/fRange(loc_currentmult,0.5,2.0))
    
    int loc_control = 0x0F
        
    loc_control = Math.LogicalAnd(loc_control,0x06)
    
    if device as UD_CustomInflatablePlug_RenderScript
        (device as UD_CustomInflatablePlug_RenderScript).UD_PumpDifficulty = RandomInt(50,100)
        (device as UD_CustomInflatablePlug_RenderScript).UD_DeflateRate = RandomInt(150,250)
    elseif device as UD_ControlablePlug_RenderScript
        device.UD_VibDuration = RandomInt(450,750)
        device.UD_Cooldown = Round(RandomInt(300,420)/fRange(loc_currentmult,0.5,2.0))
    else
        
    endif
    
    if device.zad_deviceKey ;lockable plug
        device.UD_durability_damage_base = 0.0 
        GenerateLocks(device, 8,255)
    endif
    
    patchFinish(device,loc_control,loc_currentmult,-1)
EndFunction

Function patchHood(UD_CustomHood_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Hood*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    patchFinish(device,0x0F,loc_currentmult,14)
EndFunction

Function patchBra(UD_CustomBra_RenderScript device)
    Float loc_currentmult = UD_PatchMult_ChastityBra*UD_PatchMult*GetPatchDifficulty(device)
    patchDefaultValues(device,loc_currentmult)
    
    device.UD_durability_damage_base *= 0.5
    
    patchFinish(device,0x0F,loc_currentmult,12)
EndFunction

Function patchGeneric(UD_CustomDevice_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Generic*UD_PatchMult*GetPatchDifficulty(device)
    Int loc_type = 0
    patchDefaultValues(device,loc_currentmult)

    int loc_control = 0x0F
    if device as UD_CustomMittens_RenderScript
        if !device.UD_durability_damage_base
            device.UD_durability_damage_base = fRange(RandomFloat(0.25,1.0)/loc_currentmult,0.05,100.0) ;so mittens are always escapable
        endif
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
        (device as UD_CustomDynamicHeavyBondage_RS).UD_UntieDifficulty = RandomFloat(75.0,125.0)/loc_currentmult
        device.UD_Cooldown = Round(RandomInt(160,240)/fRange(loc_currentmult,0.5,2.0))
    endif
    
    patchFinish(device,loc_control,loc_currentmult,loc_type)
EndFunction

Function patchPiercing(UD_CustomPiercing_RenderScript device)
    Float loc_currentmult = UD_PatchMult_Piercing*UD_PatchMult*GetPatchDifficulty(device)
    Int loc_type = 0
    patchDefaultValues(device,loc_currentmult)
    ;patchStart(device)
    device.UD_VibDuration = Round(RandomInt(40,75)*fRange(loc_currentmult,0.3,5.0))
    device.UD_Cooldown = Round(RandomInt(45,90)/fRange(loc_currentmult,0.5,2.0))
    if device.UD_DeviceKeyword == libs.zad_deviousPiercingsNipple
        loc_type = 2
        device.UD_OrgasmMult  = RandomFloat(0.3,0.8)*fRange(loc_currentmult,1.0,5.0)
        device.UD_ArousalMult = RandomFloat(1.5,2.0)*fRange(loc_currentmult,1.0,3.0)
    elseif device.UD_DeviceKeyword == libs.zad_DeviousPiercingsVaginal
        loc_type = 1
        device.UD_OrgasmMult  = RandomFloat(0.9,1.3)*fRange(loc_currentmult,0.8,3.0)
    endif

    device.UD_ResistPhysical = 0.75
    device.UD_ResistMagicka = 0.1
    
    patchFinish(device,0x0F,loc_currentmult,loc_type)
EndFunction

Function ProcessModifiers(UD_CustomDevice_RenderScript akDevice)
    if DeviceCanHaveModes(akDevice)
        Int loc_modnum = 0
        Int loc_i = UDMOM.UD_ModifierListRef.Length
        Alias[] loc_valid_mods = Utility.CreateAliasArray(loc_i)
        ; first run to find all valid modifiers
        while loc_i
            loc_i -= 1
            UD_Modifier loc_mod = UDMOM.UD_ModifierListRef[loc_i] As UD_Modifier
            if loc_mod && loc_mod.PatchModifierFastCheck(akDevice)
                loc_valid_mods[loc_modnum] = loc_mod
                loc_modnum += 1
            endif
        endwhile
        UDCDmain.UDmain.Log("UD_Patcher::ProcessModifiers() Fast check: " + loc_modnum + " mods to use.", 2)
        If loc_modnum == 0
            Return
        EndIf
        loc_valid_mods = Utility.ResizeAliasArray(loc_valid_mods, loc_modnum)
        ; second run to check and assign valid mods
        Int loc_added_mods = _AddModifiersFromArray(akDevice, loc_valid_mods, UD_ModsSoftCap, UD_ModsHardCap)
        If loc_added_mods < UD_ModsMinCap
            ; a third run to add mods if their number does not reach the minimum
            _AddModifiersFromArray(akDevice, loc_valid_mods, UD_ModsSoftCap, UD_ModsSoftCap)
        EndIf
    endif
EndFunction

Int Function _AddModifiersFromArray(UD_CustomDevice_RenderScript akDevice, Alias[] aakMods, Int aiSoftCap, Int aiHardCap)
    Int loc_i = 0
    Int loc_modnum = 0
    while loc_i < aakMods.Length
        If loc_modnum >= aiHardCap
            Return loc_modnum
        EndIf
        UD_Modifier loc_mod = aakMods[loc_i] As UD_Modifier
        If !akDevice.HasModifierRef(loc_mod) && loc_mod.PatchModifierCheckAndAdd(akDevice, aiSoftCap, aakMods.Length, UD_ModGlobalProbabilityMult, UD_ModGlobalSeverityShift, UD_ModGlobalSeverityDispMult)
            UDCDmain.UDmain.Log("UD_Patcher::ProcessModifiers() Added modifier = " + loc_mod, 2)
            loc_modnum += 1
        EndIf
        loc_i += 1
    endwhile
    Return loc_modnum
EndFunction

String Function _FloatToString(Float afNumber, Int aiWidth, Int aiPrecision)
    String loc_str = FormatFloat(afNumber, aiPrecision)
    If afNumber < 0.0
        loc_str = StringUtil.SubString(loc_str, 1)
        aiWidth -= 1
    EndIf
    While StringUtil.GetLength(loc_str) < aiWidth
        loc_str = "0" + loc_str
    EndWhile
    If afNumber < 0.0
        Return "-" + loc_str
    Else
        Return loc_str
    EndIf
EndFunction

bool Function DeviceCanHaveModes(UD_CustomDevice_RenderScript akDevice)
    return !akDevice.deviceRendered.haskeyword(UDlibs.PatchNoModes_KW)
EndFunction

Function patchFinish(UD_CustomDevice_RenderScript akDevice,int aiControlVar = 0x0F,Float afMult = 1.0, Int aiType = 0)
    checkInventoryScript(akDevice,aiControlVar,afMult,aiType)
    
    if akDevice.UD_CutChance && (akDevice.UD_durability_damage_base || akDevice.UD_Locks)
        CheckCutting(akDevice,35)
    endif

    if akDevice.deviceRendered.hasKeyword(libs.zad_EffectLively)
        akDevice.UD_Cooldown = Round(akDevice.UD_Cooldown*0.85)
    endif
    
    if akDevice.deviceRendered.hasKeyword(libs.zad_EffectVeryLively)
        akDevice.UD_Cooldown = Round(akDevice.UD_Cooldown*0.6)
    endif
    
    CheckResist(akDevice) ;check resist, so it can never bee too big or too low
    
    akDevice.UD_WeaponHitResist = akDevice.UD_ResistPhysical
    int loc_random = RandomInt(0,100)
    if loc_random > 75
        if loc_random < 90
            akDevice.UD_WeaponHitResist = akDevice.UD_WeaponHitResist + RandomFloat(0.25,0.75)
        else
            akDevice.UD_WeaponHitResist = akDevice.UD_WeaponHitResist - RandomFloat(0.25,0.75)
        endif
    endif
    akDevice.UD_SpellHitResist = akDevice.UD_ResistMagicka
    
    int loc_level = akDevice.GetWearer().GetLevel()
    akDevice.UD_Level = Round(RandomFloat(fRange(loc_level*0.75,1.0,100.0),fRange(loc_level*1.25,1.0,100.0)))
    
    ProcessModifiers(akDevice)
EndFunction


;argControlVar
;0b - BaseEscapeChance
;1b - CutDeviceEscapeChance
;2b - LockPickEscapeChance
;3b - LockAccessDifficulty
;------------------------
Function checkInventoryScript(UD_CustomDevice_RenderScript device,int argControlVar = 0x0F,Float fMult = 1.0, Int aiType = 0)
    UD_CustomDevice_EquipScript inventoryScript = device.getInventoryScript()
    
    If inventoryScript == None
        Return
    EndIf
    
    if Math.LogicalAnd(argControlVar,0x01)
        device.UD_durability_damage_base = (inventoryScript.BaseEscapeChance/UD_EscapeModifier)/fRange(fMult,0.25,3.0)
    else
        ;if !inventoryScript.BaseEscapeChance
        ;    device.UD_durability_damage_base = 0.0 ;inescapable device
        ;endif
    endif
    
    if device.UD_durability_damage_base == 0.0
        ;device.removeModifier("Loose") - TODO
    endif
    
    if Math.LogicalAnd(argControlVar,0x02)
        device.UD_CutChance = 0.75*inventoryScript.CutDeviceEscapeChance/fRange(fMult,0.5,3.0)
    endif
    
    if Math.LogicalAnd(argControlVar,0x04)
        Int loc_diff = 0
        if inventoryScript.LockPickEscapeChance >= 50.0
            loc_diff = 1 ;Novic
        elseif inventoryScript.LockPickEscapeChance >= 20.0
            loc_diff = RandomInt(2,10) ;Apprentice
        elseif inventoryScript.LockPickEscapeChance >= 12.0
            loc_diff = RandomInt(26,35) ;Adept
        elseif inventoryScript.LockPickEscapeChance >= 7.0
            loc_diff = RandomInt(51,60) ;Expert
        elseif inventoryScript.LockPickEscapeChance > 0.0
            loc_diff = RandomInt(76,80);Master
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
    
    if isRope(akDevice.deviceInventory)
        return ;rope device can't have locks!
    endif
    
    if !akDevice.HaveLocks()
        Int loc_timelock = 0
        if UD_TimedLocks
            loc_timelock = RandomInt(0,2) ;random timelock, to force player in to being longer locked in akDevice
        endif
        
        if aiType == 0 ;generic
            Int[] loc_lockShields = UDCDMain.DistributeLockShields(4,RandomInt(UD_MinLocks,UD_MaxLocks))
            akDevice.CreateLock(aiDifficulty, 75, loc_lockShields[0], "Left lock 1", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, loc_lockShields[1], "Left lock 2", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 75, loc_lockShields[2], "Right lock 1", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, loc_lockShields[3], "Right lock 2", loc_timelock, True)
        elseif aiType == 1 ;genital piercing
            akDevice.CreateLock(aiDifficulty, 50, RandomInt(UD_MinLocks,UD_MaxLocks), "Genital lock", loc_timelock, True)
        elseif aiType == 2 ;nipple piercing
            Int[] loc_lockShields = UDCDMain.DistributeLockShields(2,RandomInt(UD_MinLocks,UD_MaxLocks))
            akDevice.CreateLock(aiDifficulty, 70, loc_lockShields[0], "Left nipple lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 70, loc_lockShields[1], "Right nipple lock", loc_timelock, True)
        elseif aiType == 3 ;Gloves
            Int[] loc_lockShields = UDCDMain.DistributeLockShields(4,RandomInt(UD_MinLocks,UD_MaxLocks))
            akDevice.CreateLock(aiDifficulty, 75, loc_lockShields[0], "Left  hand lock 1", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, loc_lockShields[1], "Left  hand lock 2", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 75, loc_lockShields[2], "Right hand lock 1", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, loc_lockShields[3], "Right hand lock 2", loc_timelock, True)
        elseif aiType == 4 ;Mittens
            Int[] loc_lockShields = UDCDMain.DistributeLockShields(2,RandomInt(UD_MinLocks,UD_MaxLocks))
            akDevice.CreateLock(aiDifficulty, 0, loc_lockShields[0], "Left  hand lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 0, loc_lockShields[1], "Right hand lock", loc_timelock, True)
        elseif aiType == 5 ;boots
            Int[] loc_lockShields = UDCDMain.DistributeLockShields(4,RandomInt(UD_MinLocks,UD_MaxLocks))
            akDevice.CreateLock(aiDifficulty, 25, loc_lockShields[0], "Left  ancle lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, loc_lockShields[1], "Right ancle lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 75, loc_lockShields[2], "Left  leg lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 75, loc_lockShields[3], "Right leg lock", loc_timelock, True)
        elseif aiType == 6 ;Gag
            Int[] loc_lockShields = UDCDMain.DistributeLockShields(2,RandomInt(UD_MinLocks,UD_MaxLocks))
            akDevice.CreateLock(aiDifficulty, 50, loc_lockShields[0], "Strap lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 10, loc_lockShields[1], "Back lock", loc_timelock, True)
        elseif aiType == 7 ;Blindfold
            akDevice.CreateLock(aiDifficulty, 25, RandomInt(UD_MinLocks,UD_MaxLocks), "Back lock", loc_timelock, True)
        elseif aiType == 8 || aiType == 9;Vag. Plug or Anal plug
            akDevice.CreateLock(aiDifficulty, 80, RandomInt(UD_MinLocks,UD_MaxLocks), "Plug lock", loc_timelock, True)
        elseif aiType == 10 ;Suit
            Int[] loc_lockShields = UDCDMain.DistributeLockShields(5,RandomInt(UD_MinLocks,UD_MaxLocks))
            akDevice.CreateLock(aiDifficulty, 80, loc_lockShields[0], "Front lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 60, loc_lockShields[1], "Left arm lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 60, loc_lockShields[2], "Right arm lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 60, loc_lockShields[3], "Left leg lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 60, loc_lockShields[4], "Right leg lock", loc_timelock, True)
        elseif aiType == 11 ;Belt
            Int[] loc_lockShields = UDCDMain.DistributeLockShields(2,RandomInt(UD_MinLocks,UD_MaxLocks))
            akDevice.CreateLock(aiDifficulty, 80, loc_lockShields[0], "Front lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, loc_lockShields[1], "Back lock", loc_timelock, True)
        elseif aiType == 12 ;Bra
            Int[] loc_lockShields = UDCDMain.DistributeLockShields(2,RandomInt(UD_MinLocks,UD_MaxLocks))
            akDevice.CreateLock(aiDifficulty, 75, loc_lockShields[0], "Front lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 15, loc_lockShields[1], "Back lock", loc_timelock, True)
        elseif aiType == 13 ;Harness
            Int[] loc_lockShields = UDCDMain.DistributeLockShields(3,RandomInt(UD_MinLocks,UD_MaxLocks))
            akDevice.CreateLock(aiDifficulty, 65, loc_lockShields[0], "Neck lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 75, loc_lockShields[1], "Front lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 15, loc_lockShields[2], "Back lock", loc_timelock, True)
        elseif aiType == 14 ;hood
            Int[] loc_lockShields = UDCDMain.DistributeLockShields(2,RandomInt(UD_MinLocks,UD_MaxLocks))
            akDevice.CreateLock(aiDifficulty, 75, loc_lockShields[0], "Front lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 15, loc_lockShields[1], "Back lock", loc_timelock, True)
        elseif aiType == 15 || aiType == 16 ;Armbinder or Elbowbinder
            Int[] loc_lockShields = UDCDMain.DistributeLockShields(2,RandomInt(UD_MinLocks,UD_MaxLocks))
            if isSteel(akDevice.deviceInventory)
                akDevice.CreateLock(aiDifficulty, 15, loc_lockShields[0], "Left cuff lock", loc_timelock, True)
                akDevice.CreateLock(aiDifficulty, 15, loc_lockShields[1], "Right cuff lock", loc_timelock, True)
            else
                akDevice.CreateLock(aiDifficulty, 0, loc_lockShields[0], "Left shoulder lock", loc_timelock, True)
                akDevice.CreateLock(aiDifficulty, 0, loc_lockShields[1], "Right shoulder lock", loc_timelock, True)
            endif
        elseif aiType == 17 ;Straitjacket
            if isSteel(akDevice.deviceInventory)
                Int[] loc_lockShields = UDCDMain.DistributeLockShields(2,RandomInt(UD_MinLocks,UD_MaxLocks))
                akDevice.CreateLock(aiDifficulty, 15, loc_lockShields[0], "Left cuff lock", loc_timelock, True)
                akDevice.CreateLock(aiDifficulty, 15, loc_lockShields[1], "Right cuff lock", loc_timelock, True)
            else
                Int[] loc_lockShields = UDCDMain.DistributeLockShields(4,RandomInt(UD_MinLocks,UD_MaxLocks))
                akDevice.CreateLock(aiDifficulty, 0, loc_lockShields[0], "Left side lock", loc_timelock, True)
                akDevice.CreateLock(aiDifficulty, 0, loc_lockShields[1], "Right side lock", loc_timelock, True)
                akDevice.CreateLock(aiDifficulty, 0, loc_lockShields[2], "Front lock", loc_timelock, True)
                akDevice.CreateLock(aiDifficulty, 0, loc_lockShields[3], "Back lock", loc_timelock, True)
            endif
        elseif aiType == 18 || aiType == 19 || aiType == 20 ;Yoke or Front cuffs or BB yoke
            Int[] loc_lockShields = UDCDMain.DistributeLockShields(2,RandomInt(UD_MinLocks,UD_MaxLocks))
            akDevice.CreateLock(aiDifficulty, 35, loc_lockShields[0], "Left cuff lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 35, loc_lockShields[1], "Right cuff lock", loc_timelock, True)
        elseif aiType == 21 ;Petsuit
            Int[] loc_lockShields = UDCDMain.DistributeLockShields(4,RandomInt(UD_MinLocks,UD_MaxLocks))
            akDevice.CreateLock(aiDifficulty, 25, loc_lockShields[0], "Left arm lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, loc_lockShields[1], "Right arm lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty,  0, loc_lockShields[2], "Left leg lock", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty,  0, loc_lockShields[3], "Right leg lock", loc_timelock, True)
        elseif aiType == 22 ;Elbow tie
            akDevice.CreateLock(aiDifficulty, 8, RandomInt(UD_MinLocks,UD_MaxLocks), "Elbow lock", loc_timelock, True)
        else
            Int[] loc_lockShields = UDCDMain.DistributeLockShields(4,RandomInt(UD_MinLocks,UD_MaxLocks))
            akDevice.CreateLock(aiDifficulty, 75, loc_lockShields[0], "Left lock 1", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, loc_lockShields[1], "Left lock 2", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 75, loc_lockShields[2], "Right lock 1", loc_timelock, True)
            akDevice.CreateLock(aiDifficulty, 25, loc_lockShields[3], "Right lock 2", loc_timelock, True)
        endif
        
        if isSecure(akDevice.deviceInventory)
            Int loc_lockNum = akDevice.GetLockNumber()
            while loc_lockNum
                loc_lockNum -= 1
                akDevice.UpdateLockDifficulty(loc_lockNum,50,False) ;increase all locks difficulty by 50
            endwhile
        endif
        
    endif
EndFunction

Function CheckCutting(UD_CustomDevice_RenderScript device,int iChanceNone = 0)
    ;device is uncuttable
    if RandomInt(1,99) < iChanceNone
        device.UD_CutChance = 0
    endif
EndFunction

Function patchDefaultValues(UD_CustomDevice_RenderScript device,Float fMult)
    device.UD_base_stat_drain = RandomFloat(7.0,13.0)
    device.UD_durability_damage_base = fRange(RandomFloat(0.7,1.3)/fMult,0.05,100.0)
    device.UD_ResistPhysical = RandomFloat(-0.5,0.9)
    device.UD_ResistMagicka = RandomFloat(-0.9,1.0)

    device.UD_StruggleCritDuration = fRange(0.9/fMult,0.6,1.1)
    device.UD_StruggleCritChance = RandomInt(15,30)
    device.UD_StruggleCritMul = RandomFloat(2.0,6.0)
    device.UD_Cooldown = Round(RandomInt(100,240)/(fRange(fMult,0.5,5.0)))
EndFunction

;check resist, so it can never bee too big or too low
Function CheckResist(UD_CustomDevice_RenderScript device)
    if UD_MinResistMult == UD_MaxResistMult
        device.UD_ResistPhysical = UD_MinResistMult/2
        device.UD_ResistMagicka  = UD_MaxResistMult/2
        return
    endif
    Float loc_ResistMult = device.UD_ResistPhysical + device.UD_ResistMagicka
    if loc_ResistMult > UD_MaxResistMult
        Bool loc_randomResist = RandomInt(0,1)
        Float loc_dRes = loc_ResistMult - UD_MaxResistMult
        if loc_randomResist ;Decrease physical resist
            device.UD_ResistPhysical -= loc_dRes ;decrease resist by min ammount
            if device.UD_ResistPhysical < UD_MinResistMult
                device.UD_ResistPhysical = UD_MinResistMult
            endif
        else    ;Decrease magickal resist
            device.UD_ResistMagicka  -= loc_dRes ;decrease resist by min ammount
            if device.UD_ResistMagicka < UD_MinResistMult
                device.UD_ResistMagicka = UD_MinResistMult
            endif
        endif
    elseif loc_ResistMult < UD_MinResistMult
        Bool loc_randomResist = RandomInt(0,1)
        Float loc_dRes = UD_MinResistMult - loc_ResistMult
        if loc_randomResist ;Increase physical resist
            device.UD_ResistPhysical += loc_dRes ;increase resist by min ammount
            if device.UD_ResistPhysical > UD_MaxResistMult
                device.UD_ResistPhysical = UD_MaxResistMult
            endif
        else    ;Decrease magickal resist
            device.UD_ResistMagicka  += loc_dRes ;increase resist by min ammount
            if device.UD_ResistMagicka > UD_MaxResistMult
                device.UD_ResistMagicka = UD_MaxResistMult
            endif
        endif
    endif
EndFunction