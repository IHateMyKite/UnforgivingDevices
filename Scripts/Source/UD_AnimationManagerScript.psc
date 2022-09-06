Scriptname UD_AnimationManagerScript extends Quest

import UnforgivingDevicesMain

;============================================================
;========================PROPERTIES==========================
;============================================================

;==========;
;==AUTO====;
;==========;
Bool                                   Property     Ready         = false   auto    hidden
UnforgivingDevicesMain                 Property     UDmain                  auto
UD_CustomDevices_NPCSlotsManager       Property     UDCD_NPCM               auto
zadlibs                                Property     libs                    auto
Faction                                Property     ZadAnimationFaction     auto
Faction                                Property     SexlabAnimationFaction  auto


;==========;                                                                           
;==MANUAL==;                                                                           
;==========;                                                                           
zadlibs_UDPatch                        Property     libsp                           hidden
    zadlibs_UDPatch Function get()
        return libs as zadlibs_UDPatch
    EndFunction
EndProperty

;===================;
;==ANIMATION ARRAY==;
;===================;
;animations arrays for faster acces
;normal animations without hobble skirt
String[] Property UD_StruggleAnimation_Armbinder            auto
String[] Property UD_StruggleAnimation_Elbowbinder          auto
String[] Property UD_StruggleAnimation_StraitJacket         auto
String[] Property UD_StruggleAnimation_CuffsFront           auto
String[] Property UD_StruggleAnimation_Yoke                 auto
String[] Property UD_StruggleAnimation_YokeBB               auto
String[] Property UD_StruggleAnimation_ElbowTie             auto
;String[] Property UD_StruggleAnimation_PetSuit             auto !TODO
String[] Property UD_StruggleAnimation_Gag                  auto
String[] Property UD_StruggleAnimation_Boots                auto ;also leg cuffs
String[] Property UD_StruggleAnimation_ArmCuffs             auto ;also gloves and mittens
String[] Property UD_StruggleAnimation_Collar               auto
String[] Property UD_StruggleAnimation_Blindfold            auto ;also includes hood
String[] Property UD_StruggleAnimation_Suit                 auto
String[] Property UD_StruggleAnimation_Belt                 auto
String[] Property UD_StruggleAnimation_Plug                 auto
String[] Property UD_StruggleAnimation_Default              auto
;animations with hobble skirt
String[] Property UD_StruggleAnimation_Armbinder_HB         auto
String[] Property UD_StruggleAnimation_Elbowbinder_HB       auto
String[] Property UD_StruggleAnimation_StraitJacket_HB      auto
String[] Property UD_StruggleAnimation_CuffsFront_HB        auto
String[] Property UD_StruggleAnimation_Yoke_HB              auto
String[] Property UD_StruggleAnimation_YokeBB_HB            auto
String[] Property UD_StruggleAnimation_ElbowTie_HB          auto
;String[] Property UD_StruggleAnimation_PetSuit_HB          auto !TODO
String[] Property UD_StruggleAnimation_Gag_HB               auto
String[] Property UD_StruggleAnimation_Boots_HB             auto ;also leg cuffs
String[] Property UD_StruggleAnimation_ArmCuffs_HB          auto ;also gloves and mittens
String[] Property UD_StruggleAnimation_Collar_HB            auto
String[] Property UD_StruggleAnimation_Blindfold_HB         auto ;also includes hood
String[] Property UD_StruggleAnimation_Suit_HB              auto
String[] Property UD_StruggleAnimation_Belt_HB              auto
String[] Property UD_StruggleAnimation_Plug_HB              auto
String[] Property UD_StruggleAnimation_Default_HB           auto


;============================================================
;======================LOCAL VARIABLES=======================
;============================================================

Bool ZAZAnimationsInstalled = false

;============================================================
;========================FUNCTIONS===========================
;============================================================

Function OnInit()
    RegisterForSingleUpdate(5.0)
    Ready = True
EndFunction

Function OnUpdate()
    Update()
EndFunction

Function Update()
    if !ZAZAnimationsInstalled && UDmain.ZaZAnimationPackInstalled
        ZAZAnimationsInstalled = true
        
        GInfo("Zaz animations not installed, installing...")
        
        ;add armbinder animations
        UD_StruggleAnimation_Armbinder          = PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder         ,"ZapArmbStruggle01")
        UD_StruggleAnimation_Armbinder          = PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder         ,"ZapArmbStruggle03")
        UD_StruggleAnimation_Armbinder          = PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder         ,"ZapArmbStruggle05")
        UD_StruggleAnimation_Armbinder          = PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder         ,"ZapArmbStruggle07")
        UD_StruggleAnimation_Armbinder          = PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder         ,"ZapArmbStruggle08")
        UD_StruggleAnimation_Armbinder          = PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder         ,"ZapArmbStruggle10")
        UD_StruggleAnimation_Armbinder_HB       = PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder_HB      ,"ZapArmbStruggle02")
        UD_StruggleAnimation_Armbinder_HB       = PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder_HB      ,"ZapArmbStruggle06")
        UD_StruggleAnimation_Armbinder_HB       = PapyrusUtil.PushString(UD_StruggleAnimation_Armbinder_HB      ,"ZapArmbStruggle09")
        
        ;straitjacket       
        UD_StruggleAnimation_StraitJacket       = PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket      ,"ZapArmbStruggle01")
        UD_StruggleAnimation_StraitJacket       = PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket      ,"ZapArmbStruggle03")
        UD_StruggleAnimation_StraitJacket       = PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket      ,"ZapArmbStruggle05")
        UD_StruggleAnimation_StraitJacket       = PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket      ,"ZapArmbStruggle07")
        UD_StruggleAnimation_StraitJacket       = PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket      ,"ZapArmbStruggle08")
        UD_StruggleAnimation_StraitJacket       = PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket      ,"ZapArmbStruggle10")
        UD_StruggleAnimation_StraitJacket_HB    = PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket_HB   ,"ZapArmbStruggle02")
        UD_StruggleAnimation_StraitJacket_HB    = PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket_HB   ,"ZapArmbStruggle06")
        UD_StruggleAnimation_StraitJacket_HB    = PapyrusUtil.PushString(UD_StruggleAnimation_StraitJacket_HB   ,"ZapArmbStruggle09")
                    
        ;yoke           
        UD_StruggleAnimation_Yoke               = PapyrusUtil.PushString(UD_StruggleAnimation_Yoke              ,"ZapYokeStruggle01")
        UD_StruggleAnimation_Yoke               = PapyrusUtil.PushString(UD_StruggleAnimation_Yoke              ,"ZapYokeStruggle03")
        UD_StruggleAnimation_Yoke               = PapyrusUtil.PushString(UD_StruggleAnimation_Yoke              ,"ZapYokeStruggle05")
        UD_StruggleAnimation_Yoke               = PapyrusUtil.PushString(UD_StruggleAnimation_Yoke              ,"ZapYokeStruggle07")
        UD_StruggleAnimation_Yoke               = PapyrusUtil.PushString(UD_StruggleAnimation_Yoke              ,"ZapYokeStruggle08")
        UD_StruggleAnimation_Yoke               = PapyrusUtil.PushString(UD_StruggleAnimation_Yoke              ,"ZapYokeStruggle10")
        UD_StruggleAnimation_Yoke_HB            = PapyrusUtil.PushString(UD_StruggleAnimation_Yoke_HB           ,"ZapYokeStruggle02")
        UD_StruggleAnimation_Yoke_HB            = PapyrusUtil.PushString(UD_StruggleAnimation_Yoke_HB           ,"ZapYokeStruggle06")
        UD_StruggleAnimation_Yoke_HB            = PapyrusUtil.PushString(UD_StruggleAnimation_Yoke_HB           ,"ZapYokeStruggle09")

        GInfo("Zaz animations installed")
    endif
    
    if ZAZAnimationsInstalled && !UDmain.ZaZAnimationPackInstalled
        ZAZAnimationsInstalled = false
        
        GInfo("Zaz animations installed but mod is not installed, uninstalling...")
        
        ;remove armbinder animations
        UD_StruggleAnimation_Armbinder          = PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder           ,"ZapArmbStruggle01")
        UD_StruggleAnimation_Armbinder          = PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder           ,"ZapArmbStruggle03")
        UD_StruggleAnimation_Armbinder          = PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder           ,"ZapArmbStruggle05")
        UD_StruggleAnimation_Armbinder          = PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder           ,"ZapArmbStruggle07")
        UD_StruggleAnimation_Armbinder          = PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder           ,"ZapArmbStruggle08")
        UD_StruggleAnimation_Armbinder          = PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder           ,"ZapArmbStruggle10")
        UD_StruggleAnimation_Armbinder_HB       = PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder_HB        ,"ZapArmbStruggle02")
        UD_StruggleAnimation_Armbinder_HB       = PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder_HB        ,"ZapArmbStruggle06")
        UD_StruggleAnimation_Armbinder_HB       = PapyrusUtil.RemoveString(UD_StruggleAnimation_Armbinder_HB        ,"ZapArmbStruggle09")

        ;straitjacket   
        UD_StruggleAnimation_StraitJacket       = PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket        ,"ZapArmbStruggle01")
        UD_StruggleAnimation_StraitJacket       = PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket        ,"ZapArmbStruggle03")
        UD_StruggleAnimation_StraitJacket       = PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket        ,"ZapArmbStruggle05")
        UD_StruggleAnimation_StraitJacket       = PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket        ,"ZapArmbStruggle07")
        UD_StruggleAnimation_StraitJacket       = PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket        ,"ZapArmbStruggle08")
        UD_StruggleAnimation_StraitJacket       = PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket        ,"ZapArmbStruggle10")
        UD_StruggleAnimation_StraitJacket_HB    = PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket_HB     ,"ZapArmbStruggle02")
        UD_StruggleAnimation_StraitJacket_HB    = PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket_HB     ,"ZapArmbStruggle06")
        UD_StruggleAnimation_StraitJacket_HB    = PapyrusUtil.RemoveString(UD_StruggleAnimation_StraitJacket_HB     ,"ZapArmbStruggle09")

        ;yoke   
        UD_StruggleAnimation_Yoke               = PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke                ,"ZapYokeStruggle01")
        UD_StruggleAnimation_Yoke               = PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke                ,"ZapYokeStruggle03")
        UD_StruggleAnimation_Yoke               = PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke                ,"ZapYokeStruggle05")
        UD_StruggleAnimation_Yoke               = PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke                ,"ZapYokeStruggle07")
        UD_StruggleAnimation_Yoke               = PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke                ,"ZapYokeStruggle08")
        UD_StruggleAnimation_Yoke               = PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke                ,"ZapYokeStruggle10")
        UD_StruggleAnimation_Yoke_HB            = PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke_HB             ,"ZapYokeStruggle02")
        UD_StruggleAnimation_Yoke_HB            = PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke_HB             ,"ZapYokeStruggle06")
        UD_StruggleAnimation_Yoke_HB            = PapyrusUtil.RemoveString(UD_StruggleAnimation_Yoke_HB             ,"ZapYokeStruggle09")
        
        GInfo("Zaz animations uninstalled")
    endif
EndFunction

string[] Function GetHeavyBondageAnimation_Armbinder(bool hobble = false)
    if !hobble
        return UD_StruggleAnimation_Armbinder
    else
        return UD_StruggleAnimation_Armbinder_HB
    endif
EndFunction

string[] Function GetStruggleAnimations(Actor akActor,Armor renDevice)
    if !akActor.wornHasKeyword(libs.zad_DeviousHobbleSkirt)
        if renDevice.hasKeyword(libs.zad_deviousheavybondage)
            if renDevice.hasKeyword(libs.zad_DeviousArmbinder)
                return UD_StruggleAnimation_Armbinder
            elseif renDevice.hasKeyword(libs.zad_DeviousArmbinderElbow)
                return UD_StruggleAnimation_Elbowbinder
            elseif renDevice.hasKeyword(libs.zad_DeviousStraitJacket)
                return UD_StruggleAnimation_StraitJacket
            elseif renDevice.hasKeyword(libs.zad_DeviousCuffsFront)
                return UD_StruggleAnimation_CuffsFront
            elseif renDevice.hasKeyword(libs.zad_DeviousYoke)
                return UD_StruggleAnimation_Yoke
            elseif renDevice.hasKeyword(libs.zad_DeviousYokeBB)
                return UD_StruggleAnimation_YokeBB
            elseif renDevice.hasKeyword(libs.zad_DeviousElbowTie)
                return UD_StruggleAnimation_ElbowTie
            elseif renDevice.hasKeyword(libs.zad_DeviousPetSuit)
                string[] temp = new string[1]
                temp[0] = "none"
                return temp
            else
                return UD_StruggleAnimation_Default
            endif
        else
            if renDevice.hasKeyword(libs.zad_deviousGag)
                return UD_StruggleAnimation_Gag
            elseif renDevice.hasKeyword(libs.zad_DeviousLegCuffs) || renDevice.hasKeyword(libs.zad_DeviousBoots)
                return UD_StruggleAnimation_Boots
            elseif renDevice.hasKeyword(libs.zad_DeviousArmCuffs) || renDevice.hasKeyword(libs.zad_DeviousGloves) || renDevice.hasKeyword(libs.zad_DeviousBondageMittens)
                return UD_StruggleAnimation_ArmCuffs
            elseif renDevice.hasKeyword(libs.zad_DeviousCollar)
                return UD_StruggleAnimation_Collar
            elseif renDevice.hasKeyword(libs.zad_DeviousBlindfold) || renDevice.hasKeyword(libs.zad_DeviousHood)
                return UD_StruggleAnimation_Blindfold
            elseif renDevice.hasKeyword(libs.zad_DeviousSuit)
                return UD_StruggleAnimation_Suit
            elseif renDevice.hasKeyword(libs.zad_DeviousBelt)
                return UD_StruggleAnimation_Belt
            elseif renDevice.hasKeyword(libs.zad_DeviousPlug)
                return UD_StruggleAnimation_Plug
            else    
                return UD_StruggleAnimation_Default
            endif
        endif
    else
        if renDevice.hasKeyword(libs.zad_deviousheavybondage)
            if renDevice.hasKeyword(libs.zad_DeviousArmbinder)
                return UD_StruggleAnimation_Armbinder_HB
            elseif renDevice.hasKeyword(libs.zad_DeviousArmbinderElbow)
                return UD_StruggleAnimation_Elbowbinder_HB
            elseif renDevice.hasKeyword(libs.zad_DeviousStraitJacket)
                return UD_StruggleAnimation_StraitJacket_HB
            elseif renDevice.hasKeyword(libs.zad_DeviousCuffsFront)
                return UD_StruggleAnimation_CuffsFront_HB
            elseif renDevice.hasKeyword(libs.zad_DeviousYoke)
                return UD_StruggleAnimation_Yoke_HB
            elseif renDevice.hasKeyword(libs.zad_DeviousYokeBB)
                return UD_StruggleAnimation_YokeBB_HB
            elseif renDevice.hasKeyword(libs.zad_DeviousElbowTie)
                return UD_StruggleAnimation_ElbowTie_HB
            elseif renDevice.hasKeyword(libs.zad_DeviousPetSuit)
                string[] temp = new string[1]
                temp[0] = "none"
                return temp
            else
                return UD_StruggleAnimation_Default_HB
            endif
        else
            if renDevice.hasKeyword(libs.zad_deviousGag)
                return UD_StruggleAnimation_Gag_HB
            elseif renDevice.hasKeyword(libs.zad_DeviousLegCuffs) || renDevice.hasKeyword(libs.zad_DeviousBoots)
                return UD_StruggleAnimation_Boots_HB
            elseif renDevice.hasKeyword(libs.zad_DeviousArmCuffs) || renDevice.hasKeyword(libs.zad_DeviousGloves) || renDevice.hasKeyword(libs.zad_DeviousBondageMittens)
                return UD_StruggleAnimation_ArmCuffs_HB
            elseif renDevice.hasKeyword(libs.zad_DeviousCollar)
                return UD_StruggleAnimation_Collar_HB
            elseif renDevice.hasKeyword(libs.zad_DeviousBlindfold) || renDevice.hasKeyword(libs.zad_DeviousHood)
                return UD_StruggleAnimation_Blindfold_HB
            elseif renDevice.hasKeyword(libs.zad_DeviousSuit)
                return UD_StruggleAnimation_Suit_HB
            elseif renDevice.hasKeyword(libs.zad_DeviousBelt)
                return UD_StruggleAnimation_Belt_HB
            elseif renDevice.hasKeyword(libs.zad_DeviousPlug)
                return UD_StruggleAnimation_Plug_HB
            else    
                return UD_StruggleAnimation_Default_HB
            endif
        endif
    endif
EndFunction

string[] Function GetStruggleAnimationsByKeyword(Actor akActor,Keyword akKeyword,bool abHobble = false)
    if !abHobble
        if akKeyword == libs.zad_DeviousArmbinder
            return UD_StruggleAnimation_Armbinder
        elseif akKeyword == libs.zad_DeviousArmbinderElbow
            return UD_StruggleAnimation_Elbowbinder
        elseif akKeyword == libs.zad_DeviousStraitJacket
            return UD_StruggleAnimation_StraitJacket
        elseif akKeyword == libs.zad_DeviousCuffsFront
            return UD_StruggleAnimation_CuffsFront
        elseif akKeyword == libs.zad_DeviousYoke
            return UD_StruggleAnimation_Yoke
        elseif akKeyword == libs.zad_DeviousYokeBB
            return UD_StruggleAnimation_YokeBB
        elseif akKeyword == libs.zad_DeviousElbowTie
            return UD_StruggleAnimation_ElbowTie
        elseif akKeyword == libs.zad_DeviousPetSuit
            string[] temp = new string[1]
            temp[0] = "none"
            return temp
        elseif akKeyword == libs.zad_deviousGag
            return UD_StruggleAnimation_Gag
        elseif akKeyword == libs.zad_DeviousLegCuffs || akKeyword == libs.zad_DeviousBoots
            return UD_StruggleAnimation_Boots
        elseif akKeyword == libs.zad_DeviousArmCuffs || akKeyword == libs.zad_DeviousGloves || akKeyword == libs.zad_DeviousBondageMittens
            return UD_StruggleAnimation_ArmCuffs
        elseif akKeyword == libs.zad_DeviousCollar
            return UD_StruggleAnimation_Collar
        elseif akKeyword == libs.zad_DeviousBlindfold || akKeyword == libs.zad_DeviousHood
            return UD_StruggleAnimation_Blindfold
        elseif akKeyword == libs.zad_DeviousSuit
            return UD_StruggleAnimation_Suit
        elseif akKeyword == libs.zad_DeviousBelt
            return UD_StruggleAnimation_Belt
        elseif akKeyword == libs.zad_DeviousPlug
            return UD_StruggleAnimation_Plug
        else    
            return UD_StruggleAnimation_Default
        endif
    else
        if akKeyword == libs.zad_DeviousArmbinder
            return UD_StruggleAnimation_Armbinder_HB
        elseif akKeyword == libs.zad_DeviousArmbinderElbow
            return UD_StruggleAnimation_Elbowbinder_HB
        elseif akKeyword == libs.zad_DeviousStraitJacket
            return UD_StruggleAnimation_StraitJacket_HB
        elseif akKeyword == libs.zad_DeviousCuffsFront
            return UD_StruggleAnimation_CuffsFront_HB
        elseif akKeyword == libs.zad_DeviousYoke
            return UD_StruggleAnimation_Yoke_HB
        elseif akKeyword == libs.zad_DeviousYokeBB
            return UD_StruggleAnimation_YokeBB_HB
        elseif akKeyword == libs.zad_DeviousElbowTie
            return UD_StruggleAnimation_ElbowTie_HB
        elseif akKeyword == libs.zad_DeviousPetSuit
            string[] temp = new string[1]
            temp[0] = "none"
            return temp
        elseif akKeyword == libs.zad_deviousGag
            return UD_StruggleAnimation_Gag_HB
        elseif akKeyword == libs.zad_DeviousLegCuffs || akKeyword == libs.zad_DeviousBoots
            return UD_StruggleAnimation_Boots_HB
        elseif akKeyword == libs.zad_DeviousArmCuffs || akKeyword == libs.zad_DeviousGloves || akKeyword == libs.zad_DeviousBondageMittens
            return UD_StruggleAnimation_ArmCuffs_HB
        elseif akKeyword == libs.zad_DeviousCollar
            return UD_StruggleAnimation_Collar_HB
        elseif akKeyword == libs.zad_DeviousBlindfold || akKeyword == libs.zad_DeviousHood
            return UD_StruggleAnimation_Blindfold_HB
        elseif akKeyword == libs.zad_DeviousSuit
            return UD_StruggleAnimation_Suit_HB
        elseif akKeyword == libs.zad_DeviousBelt
            return UD_StruggleAnimation_Belt_HB
        elseif akKeyword == libs.zad_DeviousPlug
            return UD_StruggleAnimation_Plug_HB
        else    
            return UD_StruggleAnimation_Default_HB
        endif
    endif
EndFunction

;reduced startanimation function
;doesn't disable actor movement and doesn't check if actor is valid
;doesn't check camera state
bool Function FastStartThirdPersonAnimation(actor akActor, string animation)
    if animation == "none"
        UDmain.Warning("StartThirdPersonAnimation - Called animation is None, aborting")
        return false
    endif
    
    akActor.SetFactionRank(ZadAnimationFaction, 1)
        
    if akActor.IsWeaponDrawn()
        akActor.SheatheWeapon()
        ; Wait for users with flourish sheathe animations.
        int timeout=0
        while akActor.IsWeaponDrawn() && timeout <= 35 ;  Wait 3.5 seconds at most before giving up and proceeding.
            Utility.Wait(0.1)
            timeout += 1
        EndWhile
    EndIf
    
    ;unequip shield
    Form loc_shield = GetShield(akActor)
    if loc_shield
        akActor.unequipItem(loc_shield,true,true)
        StorageUtil.SetFormValue(akActor,"UD_UnequippedShield",loc_shield)
    endif
    
    Debug.SendAnimationEvent(akActor, animation)
    
    return true
EndFunction

;reduced endanimation function
;doesn't enable actor movement and doesn't check if actor is valid
;doesn't check camera state
Function FastEndThirdPersonAnimation(actor akActor)
    akActor.RemoveFromFaction(ZadAnimationFaction)
        
    Form loc_shield = StorageUtil.GetFormValue(akActor,"UD_UnequippedShield",none)
    if loc_shield
        StorageUtil.UnsetFormValue(akActor,"UD_UnequippedShield")
        akActor.equipItem(loc_shield,false,true)
        StorageUtil.UnSetFormValue(akActor,"UD_UnequippedShield")
    endif
    
    Debug.SendAnimationEvent(akActor, "IdleForceDefaultState")
EndFunction

;copied from zadlibs
Bool Function IsAnimating(Actor akActor, Bool abBonusCheck = true)
    if abBonusCheck
        if (akActor.GetSitState() != 0) || akActor.IsOnMount()
            return True
        endif
    endif
    return (akActor.IsInFaction(ZadAnimationFaction) || akActor.IsInFaction(SexlabAnimationFaction))
EndFunction