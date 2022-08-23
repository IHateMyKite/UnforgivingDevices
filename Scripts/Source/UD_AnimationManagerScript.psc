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
    
    LockAnimatingActor(akActor)
    
    Debug.SendAnimationEvent(akActor, animation)
    
    return true
EndFunction

;reduced endanimation function
;doesn't enable actor movement and doesn't check if actor is valid
;doesn't check camera state
Function FastEndThirdPersonAnimation(actor akActor)
    
    UnlockAnimatingActor(akActor)
    
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

Form Function GetShield(Actor akActor)
    Form loc_shield = akActor.GetEquippedObject(0)
    if loc_shield && (loc_shield.GetType() == 26 || loc_shield.GetType() == 31)
        return loc_shield
    else
        return none
    endif
EndFunction

; vehicle marker to aling actors in animation
ObjectReference MarkerRef = None

; Prepare actors and start an animation for them 
; akActor       - first actor
; akHelper      - second actor (helper)
; animationA1   - animation (animation event) for the first actor
; animationA2   - animation (animation event) for the second actor (helper)
; return        - true if OK
bool Function FastStartThirdPersonAnimationWithHelper(actor akActor, actor akHelper, string animationA1, string animationA2, bool alignActors = true)
    If akActor == None 
        UDmain.Error("FastStartThirdPersonAnimationWithHelper - Called with akActor is None, aborting")
        Return False
    EndIf
    If akHelper == None
        Return FastStartThirdPersonAnimation(akActor, animationA1)
    EndIf
    If animationA1 == "none" && animationA1 == "none"
        UDmain.Error("FastStartThirdPersonAnimationWithHelper - Called with animationA1 is None, aborting")
        Return False
    ElseIf animationA1 == "none"
        UDmain.Log("FastStartThirdPersonAnimationWithHelper - animation for Actor 1 is None, using solo animation for the Actor 2")
        Return FastStartThirdPersonAnimation(akHelper, animationA2)
    ElseIf animationA2 == "none"
        UDmain.Log("FastStartThirdPersonAnimationWithHelper - animation for Actor 2 is None, using solo animation for the Actor 1")
        Return FastStartThirdPersonAnimation(akActor, animationA1)
    endif
    
    ; locking actors
    LockAnimatingActor(akActor)
    LockAnimatingActor(akHelper)
    
    If alignActors
        ;creating vehicle marker once
        if (MarkerRef == None)
            Form markerForm = Game.GetForm(0x0000003B)
            MarkerRef = akActor.PlaceAtMe(markerForm)
            int cycle
            while !MarkerRef.Is3DLoaded() && cycle < 50
                Utility.Wait(0.1)
                cycle += 1
            endWhile
        EndIf
        ; moving marker to the first actor
        MarkerRef.MoveTo(akActor)
        MarkerRef.Enable()
        
        akHelper.MoveTo(MarkerRef)
        akActor.MoveTo(MarkerRef)
        
        akActor.SetVehicle(MarkerRef)
        akHelper.SetVehicle(MarkerRef)
        
        akActor.StopTranslation()
        akHelper.StopTranslation()
    EndIf
    ; sending animation events
    Debug.SendAnimationEvent(akActor, animationA1)
    Debug.SendAnimationEvent(akHelper, animationA2)
    
    If alignActors
        akActor.TranslateToRef(MarkerRef, 100.0)
        akHelper.TranslateToRef(MarkerRef, 100.0)
    EndIf
    
    return true
EndFunction

Function LockAnimatingActor(Actor akActor)
    akActor.SetFactionRank(ZadAnimationFaction, 1)
    If UDmain.ActorIsPlayer(akActor)
    Else
        akActor.SetDontMove(true)
    EndIf

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
        akActor.UnequipItem(loc_shield, true, true)
        StorageUtil.SetFormValue(akActor, "UD_UnequippedShield", loc_shield)
    endif

EndFunction

Function UnlockAnimatingActor(Actor akActor)
    akActor.RemoveFromFaction(ZadAnimationFaction)
    If UDmain.ActorIsPlayer(akActor)
    Else
        akActor.SetDontMove(false)
    EndIf
    akActor.SetVehicle(None)
    
    Form loc_shield = StorageUtil.GetFormValue(akActor, "UD_UnequippedShield", none)
    if loc_shield
        StorageUtil.UnsetFormValue(akActor,"UD_UnequippedShield")
        akActor.equipItem(loc_shield,false,true)
        StorageUtil.UnSetFormValue(akActor,"UD_UnequippedShield")
    endif
EndFunction

String[] UD_StruggleAnimDefs
; For debug purposes. Remove in prod
; Disables cache de facto
Bool forceReloadFiles = true                ;
; Function GetStrugglePairAnimationsByKeyword
; akActor       - 
; akHelper      - 
; akKeyword     - device keyword to struggle from
; abActorState  - bool[10] additional constraints for akActor (see below fro the list of possible constraints)
; bHelperState  - bool[10] additional constraints for akHelper (see below fro the list of possible constraints)
; return        - string array of found animations for the actors. To get animation for the akActor and akHelper add A1 or A2 to the end
; Possible constraints:
; [0] hobble skirt 
; [1] bound ankles
; [2] yoke
; [3] wrists bound in front
; [4] armbinder
; [5] elbowbinder
; [6] pet suit
; [7] 
; [8] 
; JSON file syntax
;{
;   "paired": {
;       "zad_DeviousArmCuffs" : [                                   Device keyword
;           {
;               "animation" : "PS_Babo_Conquering04_S1_",               Animation base name. To get animation events for the akActor and akHelper add A1 or A2 to the end
;               "constraintsA1" : [ 0 ],                                Possible constraints for the akActor (see description for _CheckAnimationConstraints)
;               "constraintsA2" : [ 0 ],                                Possible constraints for the akHelper (see description for _CheckAnimationConstraints)
;               "lewd" : 0,                                             Rate of lewdiness
;               "aggressive" : 1,                                       Rate of aggressiveness (from akHelper towards akActor). Could be negative
;               "forced" : true                                         First forced animation will be the only animation in result array. Used to test animation in game with forceReloadFiles = true
;           },
;           ...
;       ], 
;       ...
;   }
;}
string[] Function GetStruggleAnimationsByKeywordWithHelper(Keyword akKeyword, Bool[] abActorConstraints, Bool[] abHelperConstraints)
	Debug.Trace("[UD] [TRACE] akKeyword = " + akKeyword.GetString() + ", abActorConstraints = " + abActorConstraints + ", abHelperConstraints = " + abHelperConstraints)
    Int iActorConstraints = _FromContraintsBoolArrayToInt(abActorConstraints)
    Int iHelperConstraints = _FromContraintsBoolArrayToInt(abHelperConstraints)
    String[] result_temp = new String[10]
    Int resultCount = 0
    
    If UD_StruggleAnimDefs.Length == 0 || forceReloadFiles
        UD_StruggleAnimDefs = JsonUtil.JsonInFolder("UD/StruggleAnims") 
        Debug.Trace("[UD] [TRACE] Found " + UD_StruggleAnimDefs.length + " json file(s) in location '<Data>/SKSE/Plugins/StorageUtilData/UD/StruggleAnims/'")
    EndIf
    Int i = 0
    While i < UD_StruggleAnimDefs.Length
        String file = "UD/StruggleAnims/" + UD_StruggleAnimDefs[i]
        Debug.Trace("[UD] [TRACE] Build animation list: processing " + file)
        If forceReloadFiles
            JsonUtil.Unload(file)
        EndIf
        If JsonUtil.Load(file) && JsonUtil.IsGood(file)
            String dict_path = ".paired." + akKeyword.GetString()
            Int path_count = JsonUtil.PathCount(file, dict_path)
            Int j = 0
            While j < path_count
                String anim_path = dict_path + "[" + j + "]"
                Bool forced = JsonUtil.GetPathBoolValue(file, anim_path + ".forced")
                If forced 
                    String[] result_forced = new String[1]
                    result_forced[0] = JsonUtil.GetPathStringValue(file, anim_path + ".animation")
                    Return result_forced
                EndIf
                Int[] anim_actorContraintsArray = JsonUtil.PathIntElements(file, anim_path + ".constraintsA1")
                Int[] anim_helperContraintsArray = JsonUtil.PathIntElements(file, anim_path + ".constraintsA2")
                If _CheckAnimationConstraints(iActorConstraints, anim_actorContraintsArray) && _CheckAnimationConstraints(iHelperConstraints, anim_helperContraintsArray)
                    result_temp[resultCount] = JsonUtil.GetPathStringValue(file, anim_path + ".animation")
                    resultCount += 1
                    If resultCount == result_temp.length
                        result_temp = Utility.ResizeStringArray(result_temp, result_temp.length + 10)
                    EndIf
                    Debug.Trace("[UD] [TRACE] Build animation list: pushing into array animation " + result_temp[resultCount - 1])
                EndIf
                j += 1
            EndWhile
            Debug.Trace("[UD] [TRACE] JsonUtil.PathCount(" + akKeyword.GetString() + ") = " + path_count)
        EndIf
        i += 1
    EndWhile
    Return Utility.ResizeStringArray(result_temp, resultCount)
EndFunction

; Return array with animations for solo struggling
; 
; Possible constraints:
; [0] hobble skirt 
; [1] bound ankles
; [2] yoke
; [3] wrists bound in front
; [4] armbinder
; [5] elbowbinder
; [6] pet suit
; [7] 
; [8] 
String[] Function GetStruggleAnimationsByKeyword2(Keyword akKeyword, Bool[] abActorConstraints, Bool helper = False)
    If akKeyword == None
        String[] temp = new String[1]
        temp[0] = "none"
        Return temp
    EndIf
    If abActorConstraints.length < 10
        abActorConstraints = Utility.ResizeBoolArray(abActorConstraints, 10)
    EndIf
    
    If abActorConstraints[2]
        Return GetStruggleAnimationsByKeyword(None, libs.zad_DeviousYoke, abActorConstraints[0])
    ElseIf abActorConstraints[4]
        Return GetStruggleAnimationsByKeyword(None, libs.zad_DeviousArmbinder, abActorConstraints[0])
    ElseIf abActorConstraints[5]
        Return GetStruggleAnimationsByKeyword(None, libs.zad_DeviousArmbinderElbow, abActorConstraints[0])
    ElseIf abActorConstraints[6]
        Return GetStruggleAnimationsByKeyword(None, libs.zad_DeviousPetSuit, abActorConstraints[0])
    ElseIf abActorConstraints[3]
        Return GetStruggleAnimationsByKeyword(None, libs.zad_DeviousCuffsFront, abActorConstraints[0])
    EndIf
    
    If helper
        String[] temp = new String[1]
        temp[0] = "ft_struggle_gloves_1"
        Return temp        
    Else
        Return GetStruggleAnimationsByKeyword(None, akKeyword, abActorConstraints[0])
    EndIf

EndFunction

; checks compatibility between constraints on actors and constraints in animation defined by array
; if actor is wearing an yoke then constraints will be like (0,0,1,0,0,0,0) or 4 as int
; if animation has constraints vector [0, 4, 33], it is OK to use
; if animation has constraints vector [0, 33], it is not OK to use
; if animation has constraints vector [0, 7, 33], it is OK to use
; if animation has constraints vector [], it is not OK to use
Bool Function _CheckAnimationConstraints(Int actorConstraints, Int[] animationConstraintsArray)
    If animationConstraintsArray.length == 0
        return actorConstraints == 0
    EndIf
    If actorConstraints == 0
        Return animationConstraintsArray.Find(0) > -1
    EndIf
    Int i = 0
    While i < animationConstraintsArray.length
        If Math.LogicalAnd(animationConstraintsArray[i], actorConstraints) == actorConstraints
            Return True
        EndIf
        i += 1
    EndWhile
    Return False
EndFunction

; (0,0,1,0,0,0,0) => 4
; (1,1,0,0,1,0,0) => 1+2+16
Int Function _FromContraintsBoolArrayToInt(Bool[] constraintsArray)
    If constraintsArray.length == 0
        Return 0
    EndIf
    Int i = 1
    Int m = 1
    Int r = 0
    While i < constraintsArray.length
        r += m * (constraintsArray[i] as Int)
        m *= 2
        i += 1
    EndWhile
    Return r
EndFunction