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
String  Property NameFull = "NO NAME"   Auto

Bool    Property Disable = False        Auto

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
    
    loc_res += LockSuit(akActor) as Int
    loc_res += LockBelt(akActor) as Int
    loc_res += LockBra(akActor) as Int
    loc_res += LockCorsetHarness(akActor) as Int
    
    loc_res += LockGloves(akActor) as Int
    loc_res += LockCuffsArms(akActor) as Int
    loc_res += LockHeavyBondage(akActor) as Int
    
    loc_res += LockBoots(akActor) as Int
    loc_res += LockCuffsLegs(akActor) as Int
    
    loc_res += LockPlugVaginal(akActor) as Int
    loc_res += LockPlugAnal(akActor) as Int
    loc_res += LockPiercingVaginal(akActor) as Int
    loc_res += LockPiercingNipples(akActor) as Int
    
    loc_res += LockDevicePost(akActor,loc_res)

    return loc_res
EndFunction

Bool Function Condition()
    return !Disable
EndFunction

Bool Function LockHood(Actor akActor)
    return LockRandomDevice(akActor,UD_Hood,UD_Hood_RND)
EndFunction
Bool Function LockGag(Actor akActor)
    return LockRandomDevice(akActor,UD_Gag,UD_Gag_RND)
EndFunction
Bool Function LockBlidnfold(Actor akActor)
    return LockRandomDevice(akActor,UD_Blindfold,UD_Blindfold_RND)
EndFunction
Bool Function LockCollar(Actor akActor)
    return LockRandomDevice(akActor,UD_Collar,UD_Collar_RND)
EndFunction

Bool Function LockSuit(Actor akActor)
    return LockRandomDevice(akActor,UD_Suit,UD_Suit_RND)
EndFunction
Bool Function LockBelt(Actor akActor)
    return LockRandomDevice(akActor,UD_Belt,UD_Belt_RND)
EndFunction
Bool Function LockBra(Actor akActor)
    return LockRandomDevice(akActor,UD_Bra,UD_Bra_RND)
EndFunction
Bool Function LockCorsetHarness(Actor akActor)
    return LockRandomDevice(akActor,UD_CorsetHarness,UD_CorsetHarness_RND)
EndFunction

Bool Function LockGloves(Actor akActor)
    return LockRandomDevice(akActor,UD_Gloves,UD_Gloves_RND)
EndFunction
Bool Function LockCuffsArms(Actor akActor)
    return LockRandomDevice(akActor,UD_CuffsArms,UD_CuffsArms_RND)
EndFunction
Bool Function LockHeavyBondage(Actor akActor)
    return LockRandomDevice(akActor,UD_HeavyBondage,UD_HeavyBondage_RND)
EndFunction

Bool Function LockBoots(Actor akActor)
    return LockRandomDevice(akActor,UD_Boots,UD_Boots_RND)
EndFunction
Bool Function LockCuffsLegs(Actor akActor)
    return LockRandomDevice(akActor,UD_CuffsLegs,UD_CuffsLegs_RND)
EndFunction

Bool Function LockPlugVaginal(Actor akActor)
    return LockRandomDevice(akActor,UD_PlugVaginal,UD_PlugVaginal_RND)
EndFunction
Bool Function LockPlugAnal(Actor akActor)
    return LockRandomDevice(akActor,UD_PlugAnal,UD_PlugAnal_RND)
EndFunction
Bool Function LockPiercingVaginal(Actor akActor)
    return LockRandomDevice(akActor,UD_PiercingVag,UD_PiercingVag_RND)
EndFunction
Bool Function LockPiercingNipples(Actor akActor)
    return LockRandomDevice(akActor,UD_PiercingNip,UD_PiercingNip_RND)
EndFunction

Bool Function LockRandomDevice(Actor akActor, Armor[] aakDevices, Int[] aaiRnd)
    if (!aakDevices || aakDevices.length == 0)
        return none
    endif
    
    Armor loc_res = none
    if (aaiRnd && (aaiRnd.length == aakDevices.length))
        ;TODO - Will use native function to be faster
    else
        ; Equally random chance
        loc_res = aakDevices[RandomInt(0,aakDevices.length - 1)]
    endif
    
    if loc_res
        return libs.LockDevice(akActor,loc_res)
    endif
    return false
EndFunction
