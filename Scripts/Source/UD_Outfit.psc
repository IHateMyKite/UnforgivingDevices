Scriptname UD_Outfit extends ReferenceAlias

import UD_Native

UnforgivingDevicesMain _udmain
UnforgivingDevicesMain Property UDmain Hidden
    UnforgivingDevicesMain Function Get()
        if !_udmain
            _udmain = UnforgivingDevicesMain.GetUDMain()
        endif
        return _udmain
    EndFunction
EndProperty

zadlibs Property libs
    zadlibs Function get()
        return UDmain.libs
    EndFunction
EndProperty

;/  Group: Variables
===========================================================================================
===========================================================================================
===========================================================================================
/;

;/  Variable: NameFull
    Full name of the outfit which is shown to the player
/;
String  Property NameFull       = "NO NAME"   Auto

;/  Variable: NameAlias
    Alias for outfit, so it can be retrieved later. *NEEDS TO BE UNIQUE!*
/;
String  Property NameAlias      = "ERROR"     Auto
;/  Variable: LockMessage
    Message shown when outfit is locked on player
/;
String Property  LockMessage    = ""        Auto
;/  Variable: Random
    If outfit can be randomly locked by UD
/;
Bool   Property  Random         = True      Auto

;/  Variable: Swap
    Bit Coded value with bits set to 1 if specific device kind should be swaped (forced). If the quest device is equipped, this will still not work

    Check <IsDeviceFiltered> for more inforamtion about what bits represent what

    Changing this to 0xFFFFFFFF (4294967295) will make devices to be swapped
/;
Int     Property Swap    = 0x00000000   Auto

Bool    Property Disable = False        Auto Hidden

; === HEAD
Armor[] Property UD_Hood                Auto  ; Hoods - 30
Int[]   Property UD_Hood_RND            Auto
Armor[] Property UD_Gag                 Auto  ; Gags - 44
Int[]   Property UD_Gag_RND             Auto
Armor[] Property UD_Blindfold           Auto  ; Blindfold - 55
Int[]   Property UD_Blindfold_RND       Auto
Armor[] Property UD_Collar              Auto  ; Collar - 45
Int[]   Property UD_Collar_RND          Auto

; === BODY
Armor[] Property UD_Suit                Auto  ; Suits - 32
Int[]   Property UD_Suit_RND            Auto
Armor[] Property UD_Belt                Auto  ; Belt - 49
Int[]   Property UD_Belt_RND            Auto
Armor[] Property UD_Bra                 Auto  ; Bra - 56
Int[]   Property UD_Bra_RND             Auto
Armor[] Property UD_CorsetHarness       Auto  ; Corset/Harness - 58
Int[]   Property UD_CorsetHarness_RND   Auto

; === HANDS
Armor[] Property UD_Gloves              Auto  ; Gloves - 33
Int[]   Property UD_Gloves_RND          Auto
Armor[] Property UD_CuffsArms           Auto  ; Cuffs Arms - 59
Int[]   Property UD_CuffsArms_RND       Auto
Armor[] Property UD_HeavyBondage        Auto  ; HeavyBondage - 46
Int[]   Property UD_HeavyBondage_RND    Auto

; === LEGS
Armor[] Property UD_Boots               Auto  ; Boots - 37
Int[]   Property UD_Boots_RND           Auto
Armor[] Property UD_CuffsLegs           Auto  ; Cuffs Legs - 53
Int[]   Property UD_CuffsLegs_RND       Auto

; === GENITALS/NIPPLES
Armor[] Property UD_PlugVaginal         Auto  ; Plugs Vaginal - 57
Int[]   Property UD_PlugVaginal_RND     Auto
Armor[] Property UD_PlugAnal            Auto  ; Plug Anal - 48
Int[]   Property UD_PlugAnal_RND        Auto
Armor[] Property UD_PiercingVag         Auto  ; Piercing Vaginal - 50
Int[]   Property UD_PiercingVag_RND     Auto
Armor[] Property UD_PiercingNip         Auto  ; Piercing Nipples - 51
Int[]   Property UD_PiercingNip_RND     Auto

Bool Function LockDevicePre(Actor akActor)
    return true
EndFunction
Int Function LockDevicePost(Actor akActor, Int aiLocked)
    return 0
EndFunction

Int Function LockDevices(Actor akActor)
    if !LockDevicePre(akActor)
        return 0
    endif

    Int loc_res = 0
    
    loc_res += LockHood(akActor) as Int
    loc_res += LockGag(akActor) as Int
    loc_res += LockBlidnfold(akActor) as Int
    loc_res += LockCollar(akActor) as Int
    
    loc_res += LockHeavyBondage(akActor) as Int ;heavy bondage before suit, so straitjacket  can be locked before suit
    
    loc_res += LockSuit(akActor) as Int
    loc_res += LockCorsetHarness(akActor) as Int ;first try harness, then belt
    loc_res += LockBelt(akActor) as Int
    loc_res += LockBra(akActor) as Int
    
    loc_res += LockGloves(akActor) as Int
    loc_res += LockCuffsArms(akActor) as Int
    
    loc_res += LockBoots(akActor) as Int
    loc_res += LockCuffsLegs(akActor) as Int
    
    loc_res += LockPlugVaginal(akActor) as Int
    loc_res += LockPlugAnal(akActor) as Int
    loc_res += LockPiercingVaginal(akActor) as Int
    loc_res += LockPiercingNipples(akActor) as Int
    
    loc_res += LockDevicePost(akActor,loc_res)

    if LockMessage
        UDMain.ShowSingleMessageBox(LockMessage)
    endif
    
    UDMain.Info(self + "::LockDevices("+GetActorName(akActor)+") - " + loc_res + " devices locked")
    
    return loc_res
EndFunction

; Used when selecting random outfit to equip
; Can be edited so outfit can be randomly equipped only under certain condition (for example only if actor have certain level of some equest is completed first)
Bool Function Condition(Actor akActor)
    return !Disable && Random
EndFunction

Bool Function LockHood(Actor akActor)
    return LockRandomDevice(akActor,UD_Hood,UD_Hood_RND,7,libs.zad_DeviousHood)
EndFunction
Bool Function LockGag(Actor akActor)
    return LockRandomDevice(akActor,UD_Gag,UD_Gag_RND,9,libs.zad_DeviousGag)
EndFunction
Bool Function LockBlidnfold(Actor akActor)
    return LockRandomDevice(akActor,UD_Blindfold,UD_Blindfold_RND,10,libs.zad_DeviousBlindfold)
EndFunction
Bool Function LockCollar(Actor akActor)
    return LockRandomDevice(akActor,UD_Collar,UD_Collar_RND,8,libs.zad_DeviousCollar)
EndFunction

Bool Function LockSuit(Actor akActor)
    return LockRandomDevice(akActor,UD_Suit,UD_Suit_RND,14,libs.zad_DeviousSuit)
EndFunction
Bool Function LockBelt(Actor akActor)
    return LockRandomDevice(akActor,UD_Belt,UD_Belt_RND,17,libs.zad_DeviousBelt)
EndFunction
Bool Function LockBra(Actor akActor)
    return LockRandomDevice(akActor,UD_Bra,UD_Bra_RND,16,libs.zad_DeviousBra)
EndFunction
Bool Function LockCorsetHarness(Actor akActor) ; TODO: for now both harness and corset have to be enabled. Will have to adjust this later
    return LockRandomDevice(akActor,UD_CorsetHarness,UD_CorsetHarness_RND,6,libs.zad_DeviousCorset,5,libs.zad_DeviousHarness,libs.zad_DeviousBelt)
EndFunction

Bool Function LockGloves(Actor akActor)
    return LockRandomDevice(akActor,UD_Gloves,UD_Gloves_RND,15,libs.zad_DeviousGloves)
EndFunction
Bool Function LockCuffsArms(Actor akActor)
    return LockRandomDevice(akActor,UD_CuffsArms,UD_CuffsArms_RND,12,libs.zad_DeviousArmCuffs)
EndFunction
Bool Function LockHeavyBondage(Actor akActor)
    return LockRandomDevice(akActor,UD_HeavyBondage,UD_HeavyBondage_RND,4,libs.zad_DeviousHeavyBondage)
EndFunction

Bool Function LockBoots(Actor akActor)
    return LockRandomDevice(akActor,UD_Boots,UD_Boots_RND,11,libs.zad_DeviousBoots)
EndFunction
Bool Function LockCuffsLegs(Actor akActor)
    return LockRandomDevice(akActor,UD_CuffsLegs,UD_CuffsLegs_RND,12,libs.zad_DeviousLegCuffs)
EndFunction

Bool Function LockPlugVaginal(Actor akActor)
    return LockRandomDevice(akActor,UD_PlugVaginal,UD_PlugVaginal_RND,2,libs.zad_DeviousPlugVaginal)
EndFunction
Bool Function LockPlugAnal(Actor akActor)
    return LockRandomDevice(akActor,UD_PlugAnal,UD_PlugAnal_RND,3,libs.zad_DeviousPlugAnal)
EndFunction
Bool Function LockPiercingVaginal(Actor akActor)
    return LockRandomDevice(akActor,UD_PiercingVag,UD_PiercingVag_RND,0,libs.zad_DeviousPiercingsVaginal)
EndFunction
Bool Function LockPiercingNipples(Actor akActor)
    return LockRandomDevice(akActor,UD_PiercingNip,UD_PiercingNip_RND,1,libs.zad_DeviousPiercingsNipple)
EndFunction

Bool Function LockRandomDevice(Actor akActor, Armor[] aakDevices, Int[] aaiRnd, Int aiFilter, Keyword akKeyword1, Int aiFilter2 = -1, Keyword akKeyword2 = none, Keyword akBonusCheck = none)
    if (!aakDevices || aakDevices.length == 0)
        return none
    endif
    
    if (!UDmain.UDRRM.IsDeviceFiltered(aiFilter) || (aiFilter2 != -1 && !UDmain.UDRRM.IsDeviceFiltered(aiFilter2)))
        return false
    endif
    
    if (akActor.WornHasKeyword(akKeyword1) || (akKeyword2 && akActor.WornHasKeyword(akKeyword2)))
        return false
    endif
    
    Armor loc_res = none
    if (aaiRnd && (aaiRnd.length == aakDevices.length))
        ;TODO - Will use native function to be faster
        loc_res = aakDevices[RandomIdFromDist(aaiRnd)]
    else
        ; Equally random chance
        loc_res = aakDevices[RandomInt(0,aakDevices.length - 1)]
    endif
    
    if loc_res
        ; Bonues check used to check if device doesnt have additional keyword which will make DD filter go up (belt kw on harness for example)
        if akBonusCheck && loc_res.HasKeyword(akBonusCheck) && akActor.WornHasKeyword(akBonusCheck)
            return false
        endif
        
        ; Check if device should be swaped
        if (Swap > 0) && (aiFilter >= 0 && Math.LogicalAnd(Swap,Math.LeftShift(0x00000001,aiFilter)) || (aiFilter2 >= 0 && Math.LogicalAnd(Swap,Math.LeftShift(0x00000001,aiFilter2))))
            AdditionalSwapCheck(akActor,loc_res,aiFilter)
            return libs.SwapDevices(akActor,loc_res)
        else
            return libs.LockDevice(akActor,loc_res)
        endif
    endif
    return false
EndFunction

Function AdditionalSwapCheck(Actor akActor, Armor akDevice, Int aiFilter)
    Armor loc_rd = zadNativeFunctions.GetRenderDevice(akDevice)
    if aiFilter == 4 && loc_rd.haskeyword(libs.zad_DeviousStraitJacket) && loc_rd.haskeyword(libs.zad_DeviousSuit)
        ; unlock suit if its equipped
        if akActor.wornHasKeyword(libs.zad_DeviousSuit) && !akActor.wornHasKeyword(libs.zad_DeviousStraitjacket)
            libs.UnlockDeviceByKeyword(akActor,libs.zad_DeviousSuit)
        endif
    endif
EndFunction

Int Function GetRnd(Int aiType, Int aiIndex)
    Int[] loc_rnd
    if aiType == 1
        loc_rnd = UD_Hood_RND
    elseif aiType == 2
        loc_rnd = UD_Gag_RND
    elseif aiType == 3
        loc_rnd = UD_Blindfold_RND
    elseif aiType == 4
        loc_rnd = UD_Collar_RND
    elseif aiType == 5
        loc_rnd = UD_Suit_RND
    elseif aiType == 6
        loc_rnd = UD_Belt_RND
    elseif aiType == 7
        loc_rnd = UD_Bra_RND
    elseif aiType == 8
        loc_rnd = UD_CorsetHarness_RND
    elseif aiType == 9
        loc_rnd = UD_Gloves_RND
    elseif aiType == 10
        loc_rnd = UD_CuffsArms_RND
    elseif aiType == 11
        loc_rnd = UD_HeavyBondage_RND
    elseif aiType == 12
        loc_rnd = UD_Boots_RND
    elseif aiType == 13
        loc_rnd = UD_CuffsLegs_RND
    elseif aiType == 14
        loc_rnd = UD_PlugVaginal_RND
    elseif aiType == 15
        loc_rnd = UD_PlugAnal_RND
    elseif aiType == 16
        loc_rnd = UD_PiercingVag_RND
    elseif aiType == 17
        loc_rnd = UD_PiercingNip_RND
    endif
    if loc_rnd
        return loc_rnd[aiIndex]
    endif
    return -1
EndFunction

Function UpdateRnd(Int aiType, Int aiIndex, Int aiNewValue)
    if aiType == 1
        UD_Hood_RND[aiIndex] = aiNewValue
    elseif aiType == 2
        UD_Gag_RND[aiIndex] = aiNewValue
    elseif aiType == 3
        UD_Blindfold_RND[aiIndex] = aiNewValue
    elseif aiType == 4
        UD_Collar_RND[aiIndex] = aiNewValue
    elseif aiType == 5
        UD_Suit_RND[aiIndex] = aiNewValue
    elseif aiType == 6
        UD_Belt_RND[aiIndex] = aiNewValue
    elseif aiType == 7
        UD_Bra_RND[aiIndex] = aiNewValue
    elseif aiType == 8
        UD_CorsetHarness_RND[aiIndex] = aiNewValue
    elseif aiType == 9
        UD_Gloves_RND[aiIndex] = aiNewValue
    elseif aiType == 10
        UD_CuffsArms_RND[aiIndex] = aiNewValue
    elseif aiType == 11
        UD_HeavyBondage_RND[aiIndex] = aiNewValue
    elseif aiType == 12
        UD_Boots_RND[aiIndex] = aiNewValue
    elseif aiType == 13
        UD_CuffsLegs_RND[aiIndex] = aiNewValue
    elseif aiType == 14
        UD_PlugVaginal_RND[aiIndex] = aiNewValue
    elseif aiType == 15
        UD_PlugAnal_RND[aiIndex] = aiNewValue
    elseif aiType == 16
        UD_PiercingVag_RND[aiIndex] = aiNewValue
    elseif aiType == 17
        UD_PiercingNip_RND[aiIndex] = aiNewValue
    endif
EndFunction

Function ValidateRnd()
    if UD_Hood && !UD_Hood_RND && (UD_Hood_RND.length != UD_Hood.length)
        UD_Hood_RND = Utility.CreateIntArray(UD_Hood.length,Round(100.0/UD_Hood.length))
    endif
    if UD_Gag && !UD_Gag_RND && (UD_Gag_RND.length != UD_Gag.length)
        UD_Gag_RND = Utility.CreateIntArray(UD_Gag.length,Round(100.0/UD_Gag.length))
    endif
    if UD_Blindfold && !UD_Blindfold_RND && (UD_Blindfold_RND.length != UD_Blindfold.length)
        UD_Blindfold_RND = Utility.CreateIntArray(UD_Blindfold.length,Round(100.0/UD_Blindfold.length))
    endif
    if UD_Collar && !UD_Collar_RND && (UD_Collar_RND.length != UD_Collar.length)
        UD_Collar_RND = Utility.CreateIntArray(UD_Collar.length,Round(100.0/UD_Collar.length))
    endif
    if UD_Suit && !UD_Suit_RND && (UD_Suit_RND.length != UD_Suit.length)
        UD_Suit_RND = Utility.CreateIntArray(UD_Suit.length,Round(100.0/UD_Suit.length))
    endif
    if UD_Belt && !UD_Belt_RND && (UD_Belt_RND.length != UD_Belt.length)
        UD_Belt_RND = Utility.CreateIntArray(UD_Belt.length,Round(100.0/UD_Belt.length))
    endif
    if UD_Bra && !UD_Bra_RND && (UD_Bra_RND.length != UD_Bra.length)
        UD_Bra_RND = Utility.CreateIntArray(UD_Bra.length,Round(100.0/UD_Bra.length))
    endif
    if UD_CorsetHarness && !UD_CorsetHarness_RND && (UD_CorsetHarness_RND.length != UD_CorsetHarness.length)
        UD_CorsetHarness_RND = Utility.CreateIntArray(UD_CorsetHarness.length,Round(100.0/UD_CorsetHarness.length))
    endif
    if UD_Gloves && !UD_Gloves_RND && (UD_Gloves_RND.length != UD_Gloves.length)
        UD_Gloves_RND = Utility.CreateIntArray(UD_Gloves.length,Round(100.0/UD_Gloves.length))
    endif
    if UD_CuffsArms && !UD_CuffsArms_RND && (UD_CuffsArms_RND.length != UD_CuffsArms.length)
        UD_CuffsArms_RND = Utility.CreateIntArray(UD_CuffsArms.length,Round(100.0/UD_CuffsArms.length))
    endif
    if UD_HeavyBondage && !UD_HeavyBondage_RND && (UD_HeavyBondage_RND.length != UD_HeavyBondage.length)
        UD_HeavyBondage_RND = Utility.CreateIntArray(UD_HeavyBondage.length,Round(100.0/UD_HeavyBondage.length))
    endif
    if UD_Boots && !UD_Boots_RND && (UD_Boots_RND.length != UD_Boots.length)
        UD_Boots_RND = Utility.CreateIntArray(UD_Boots.length,Round(100.0/UD_Boots.length))
    endif
    if UD_CuffsLegs && !UD_CuffsLegs_RND && (UD_CuffsLegs_RND.length != UD_CuffsLegs.length)
        UD_CuffsLegs_RND = Utility.CreateIntArray(UD_CuffsLegs.length,Round(100.0/UD_CuffsLegs.length))
    endif
    if UD_PlugVaginal && !UD_PlugVaginal_RND && (UD_PlugVaginal_RND.length != UD_PlugVaginal.length)
        UD_PlugVaginal_RND = Utility.CreateIntArray(UD_PlugVaginal.length,Round(100.0/UD_PlugVaginal.length))
    endif
    if UD_PlugAnal && !UD_PlugAnal_RND && (UD_PlugAnal_RND.length != UD_PlugAnal.length)
        UD_PlugAnal_RND = Utility.CreateIntArray(UD_PlugAnal.length,Round(100.0/UD_PlugAnal.length))
    endif
    if UD_PiercingVag && !UD_PiercingVag_RND && (UD_PiercingVag_RND.length != UD_PiercingVag.length)
        UD_PiercingVag_RND = Utility.CreateIntArray(UD_PiercingVag.length,Round(100.0/UD_PiercingVag.length))
    endif
    if UD_PiercingNip && !UD_PiercingNip_RND && (UD_PiercingNip_RND.length != UD_PiercingNip.length)
        UD_PiercingNip_RND = Utility.CreateIntArray(UD_PiercingNip.length,Round(100.0/UD_PiercingNip.length))
    endif
EndFunction

Function Reset()
    ForceRefTo(UDmain.Player)
    Clear()
    ValidateRnd()
EndFunction